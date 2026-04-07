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

const getParametersWithValuesByExamId = async (req, res) => {
    try {
        const { patientExamId } = req.query;

        if (!patientExamId) {
            return res.status(400).json({
                success: false,
                error: 'patientExamId is required'
            });
        }


        const [paramInExams] = await db.query(`
            SELECT mpie.medical_parameter_id, mpie.med_param_exam_id
            FROM MedParamInExams mpie
            INNER JOIN patientsexams pe ON mpie.exam_id = pe.exam_id
            WHERE pe.patients_exams_id = ?
        `, [patientExamId]);


        if (paramInExams.length === 0) {
            return res.json({ success: true, data: [] });
        }

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
        const medParamExamIds = paramInExams.map(row => row.med_param_exam_id);
        const valuePlaceholders = medParamExamIds.map(() => '?').join(',');

        const [patientValues] = await db.query(`
            SELECT
                med_param_exam_id,
                value
            FROM MedParamInPatientExams
            WHERE patients_exams_id = ?
                AND med_param_exam_id IN (${valuePlaceholders})
        `, [patientExamId, ...medParamExamIds]);


        const valuesMap = new Map();
        for (const row of patientValues) {
            valuesMap.set(row.med_param_exam_id, row.value);
        }

        const resultData = [];
        let nullCount = 0;
        let hasUnitCount = 0;

        for (const link of paramInExams) {
            const paramInfo = nameMap.get(link.medical_parameter_id);
            const value = valuesMap.get(link.med_param_exam_id);

            let displayValue = null;
            if (value && value !== 'NULL') {
                displayValue = value;
                if (paramInfo && paramInfo.unit) {
                    displayValue = `${value} ${paramInfo.unit}`;
                    hasUnitCount++;
                }
            } else {
                nullCount++;
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
       res.status(500).json({
            success: false,
            error: 'Error getting parameters with values'
        });
    }
};

const getExamTypeByExamId = async (req, res) => {
    try {
        const { patientExamId } = req.query;

        if (!patientExamId) {
            return res.status(400).json({
                success: false,
                error: 'patientExamId is required'
            });
        }

        const [result] = await db.query(`
            SELECT
                CASE
                    WHEN pe.exam_id = 1 THEN 'Первичный осмотр'
                    WHEN pe.exam_id = 2 THEN 'Ежедневный осмотр'
                    ELSE 'Осмотр'
                END as exam_name
            FROM patientsexams pe
            WHERE pe.patients_exams_id = ?
        `, [patientExamId]);

        if (result.length === 0) {
            return res.json({
                success: true,
                data: { exam_name: 'Осмотр' }
            });
        }

        const examName = result[0].exam_name;

        res.json({
            success: true,
            data: {
                exam_name: examName
            }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error getting exam type'
        });
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

const getDailyExamList = async (req, res) => {
    try {
        const { patientId, examTypeId } = req.query;

        if (!patientId || !examTypeId) {
            return res.status(400).json({
                success: false,
                error: 'patientId and examTypeId are required'
            });
        }

        const [results] = await db.query(`
            SELECT patients_exams_id, date_time
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY patients_exams_id DESC
        `, [patientId, examTypeId]);


        if (results.length === 0) {
            return res.json({ success: true, data: [] });
        }

        const examList = results.map(row => ({
            patient_exam_id: row.patients_exams_id,
            date_time: row.date_time
        }));

        res.json({
            success: true,
            data: examList
        });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting daily exam list' });
    }
};

const getExamDateTime = async (req, res) => {
    try {
        const { patientExamId } = req.query;

        if (!patientExamId) {
            return res.status(400).json({
                success: false,
                error: 'patientExamId is required'
            });
        }

        const [result] = await db.query(`
            SELECT date_time
            FROM patientsexams
            WHERE patients_exams_id = ?
        `, [patientExamId]);

        if (result.length === 0) {
            return res.json({ success: true, data: null });
        }

        res.json({
            success: true,
            data: {
                date_time: result[0].date_time
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting exam datetime' });
    }
};

module.exports = { getParameters, getAllParameters, getParametersWithValuesByExamId, getPrimaryExamId, getDailyExamList, getExamDateTime, getExamTypeByExamId };