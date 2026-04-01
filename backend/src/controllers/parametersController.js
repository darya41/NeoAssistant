const db = require('../config/database');

const getParameters = async (req, res) => {
    try {
        const examId = req.query.examId;

        if (!examId) {
            return res.status(400).json({
                success: false,
                error: 'examId parameter is required'
            });
        }

        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

        if (paramIds.length === 0) {
            return res.json({ success: true, data: [] });
        }

        const [paramsResult] = await db.query(`
            SELECT mp.medical_parameter_id, mp.name, mp.value_type, mp.unit, mp.description
            FROM MedicalParameters mp
            WHERE mp.medical_parameter_id IN (?)
        `, [paramIds]);

        let parameters = paramsResult;

        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );

            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        res.json({ success: true, data: parameters });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting parameters' });
    }
};

const getAllParameters = async (req, res) => {
    try {
        const [parameters] = await db.query(`
            SELECT mp.medical_parameter_id, mp.name, mp.value_type, mp.unit, mp.description
            FROM MedicalParameters mp
            ORDER BY mp.name
        `);

        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );

            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        res.json({ success: true, data: parameters });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting parameters' });
    }
};

const getParametersWithValues = async (req, res) => {
    try {
        const { examId, patientExamId } = req.query;

        if (!examId || !patientExamId) {
           return res.status(400).json({
                success: false,
                error: 'examId and patientExamId parameters are required'
            });
        }

       const [paramInExams] = await db.query(`
            SELECT medical_parameter_id
            FROM MedParamInExams
            WHERE exam_id = ?
            ORDER BY medical_parameter_id
        `, [examId]);

        if (paramInExams.length === 0) {
            return res.json({ success: true, data: [] });
        }

        const medicalParamIds = paramInExams.map(row => row.medical_parameter_id);

        const placeholders = medicalParamIds.map(() => '?').join(',');

        const [parameters] = await db.query(`
            SELECT
                medical_parameter_id,
                name,
                unit
            FROM MedicalParameters
            WHERE medical_parameter_id IN (${placeholders})
            ORDER BY medical_parameter_id
        `, medicalParamIds);

        const nameMap = new Map();
        for (const param of parameters) {
            nameMap.set(param.medical_parameter_id, {
                name: param.name,
                unit: param.unit
            });
        }

        const valuePlaceholders = medicalParamIds.map(() => '?').join(',');

        const [patientValues] = await db.query(`
            SELECT
                med_param_exam_id,
                value
            FROM MedParamInPatientExams
            WHERE patients_exams_id = ?
                AND med_param_exam_id IN (${valuePlaceholders})
        `, [patientExamId, ...medicalParamIds]);

        const valuesMap = new Map();
        for (const row of patientValues) {
            valuesMap.set(row.med_param_exam_id, row.value);
        }

        const resultData = [];

        for (const medicalParamId of medicalParamIds) {
            const paramInfo = nameMap.get(medicalParamId);
            const value = valuesMap.get(medicalParamId);

            let displayValue = null;
            if (value && value !== 'NULL') {
                displayValue = value;
                if (paramInfo && paramInfo.unit) {
                    displayValue = `${value} ${paramInfo.unit}`;
                }
            }

            resultData.push({
                name: paramInfo ? paramInfo.name : 'Неизвестный параметр',
                value: displayValue
            });
        }

        res.json({
            success: true,
            data: resultData
        });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting parameters with values' });
    }
};

const getPrimaryExamId = async (req, res) => {
    try {
        const { patientId, examTypeId } = req.query;

        if (!patientId || !examTypeId) {
            return res.status(400).json({
                success: false,
                error: 'patientId and examTypeId parameters are required'
            });
        }

        const [result] = await db.query(`
            SELECT patients_exams_id, date_time as exam_date
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY date_time DESC
            LIMIT 1
        `, [patientId, examTypeId]);

        if (result.length === 0) {
            return res.json({ success: true, data: null });
        }

        res.json({
            success: true,
            data: {
                patient_exam_id: result[0].patients_exams_id,
                exam_date: result[0].exam_date
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting primary exam id' });
    }
};

module.exports = { getParameters, getAllParameters, getParametersWithValues, getPrimaryExamId };