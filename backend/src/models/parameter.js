const db = require('../config/database');

class ParameterModel {
    static async getParametersByExamId(examId) {
        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id, med_param_exam_id FROM medparaminexams WHERE exam_id = ?',
            [examId]
        );

        if (paramIdsResult.length === 0) {
            return [];
        }

        const medicalParamIds = paramIdsResult.map(row => row.medical_parameter_id);

        const [paramsResult] = await db.query(`
            SELECT
                mp.medical_parameter_id,
                mp.name,
                mp.value_type,
                mp.unit,
                mp.description
            FROM medicalparameters mp
            WHERE mp.medical_parameter_id IN (?)
        `, [medicalParamIds]);

        const parameters = paramsResult;
        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );
            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        return parameters;
    }

    static async getAllParameters() {
        const [parameters] = await db.query(`
            SELECT mp.medical_parameter_id, mp.name, mp.value_type, mp.unit, mp.description
            FROM medicalparameters mp
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

        return parameters;
    }

    static async getParametersWithValuesByExamId(patientExamId) {
        const [paramInExams] = await db.query(`
            SELECT mpie.medical_parameter_id, mpie.med_param_exam_id
            FROM medparaminexams mpie
            INNER JOIN patientsexams pe ON mpie.exam_id = pe.exam_id
            WHERE pe.patients_exams_id = ?
        `, [patientExamId]);

        if (paramInExams.length === 0) {
            return [];
        }

        const medicalParamIds = paramInExams.map(row => row.medical_parameter_id);
        const medParamExamIds = paramInExams.map(row => row.med_param_exam_id);

        const placeholders = medicalParamIds.map(() => '?').join(',');
        const [parameters] = await db.query(`
            SELECT medical_parameter_id, name, unit
            FROM medicalparameters
            WHERE medical_parameter_id IN (${placeholders})
            ORDER BY medical_parameter_id
        `, medicalParamIds);

        const valuePlaceholders = medParamExamIds.map(() => '?').join(',');
        const [patientValues] = await db.query(`
            SELECT med_param_exam_id, value
            FROM medparaminpatientexams
            WHERE patients_exams_id = ? AND med_param_exam_id IN (${valuePlaceholders})
        `, [patientExamId, ...medParamExamIds]);

        const nameMap = new Map();
        for (const param of parameters) {
            nameMap.set(param.medical_parameter_id, {
                name: param.name,
                unit: param.unit
            });
        }

        const valuesMap = new Map();
        for (const row of patientValues) {
            valuesMap.set(row.med_param_exam_id, row.value);
        }

        const resultData = [];
        for (const link of paramInExams) {
            const paramInfo = nameMap.get(link.medical_parameter_id);
            const value = valuesMap.get(link.med_param_exam_id);

            let displayValue = null;
            if (value && value !== 'NULL') {
                displayValue = value;
                if (paramInfo && paramInfo.unit && paramInfo.unit !== 'нет') {
                    displayValue = `${value} ${paramInfo.unit}`;
                }
            }

            resultData.push({
                name: paramInfo ? paramInfo.name : 'Неизвестный параметр',
                value: displayValue,
                medical_parameter_id: link.medical_parameter_id,
                med_param_exam_id: link.med_param_exam_id,
                raw_value: value
            });
        }

        return resultData;
    }

    static async getParameterValuesByPatientExamId(patientExamId) {
        try {
            const [examInfo] = await db.query(`
                SELECT exam_id FROM patientsexams
                WHERE patients_exams_id = ?
            `, [patientExamId]);

            if (examInfo.length === 0) {
                return [];
            }

            const examId = examInfo[0].exam_id;

            const [medParamLinks] = await db.query(`
                SELECT medical_parameter_id, med_param_exam_id
                FROM medparaminexams
                WHERE exam_id = ?
            `, [examId]);

            if (medParamLinks.length === 0) {
                return [];
            }

            const medParamExamIds = medParamLinks.map(row => row.med_param_exam_id);
            const placeholders = medParamExamIds.map(() => '?').join(',');

            const [values] = await db.query(`
                SELECT med_param_exam_id, value
                FROM medparaminpatientexams
                WHERE patients_exams_id = ? AND med_param_exam_id IN (${placeholders})
            `, [patientExamId, ...medParamExamIds]);

            const result = [];
            for (const link of medParamLinks) {
                const valueRecord = values.find(v => v.med_param_exam_id === link.med_param_exam_id);
                result.push({
                    medical_parameter_id: link.medical_parameter_id,
                    med_param_exam_id: link.med_param_exam_id,
                    value: valueRecord ? valueRecord.value : null
                });
            }

            return result;
        } catch (error) {
            console.error('Error in getParameterValuesByPatientExamId:', error);
            return [];
        }
    }

    static async saveParameterValue(patientsExamsId, medicalParameterId, value) {
        try {
            const [examInfo] = await db.query(`
                SELECT pe.exam_id
                FROM patientsexams pe
                WHERE pe.patients_exams_id = ?
            `, [patientsExamsId]);

            if (examInfo.length === 0) {
                throw new Error('Patient exam not found');
            }

            const examId = examInfo[0].exam_id;

            const [paramLink] = await db.query(`
                SELECT med_param_exam_id
                FROM medparaminexams
                WHERE exam_id = ? AND medical_parameter_id = ?
            `, [examId, medicalParameterId]);

            if (paramLink.length === 0) {
                throw new Error('Parameter not found for this exam');
            }

            const medParamExamId = paramLink[0].med_param_exam_id;

            const [existing] = await db.query(`
                SELECT id FROM medparaminpatientexams
                WHERE patients_exams_id = ? AND med_param_exam_id = ?
            `, [patientsExamsId, medParamExamId]);

            if (existing.length > 0) {
                await db.query(`
                    UPDATE medparaminpatientexams
                    SET value = ?
                    WHERE patients_exams_id = ? AND med_param_exam_id = ?
                `, [value || null, patientsExamsId, medParamExamId]);
            } else {
                await db.query(`
                    INSERT INTO medparaminpatientexams (patients_exams_id, med_param_exam_id, value)
                    VALUES (?, ?, ?)
                `, [patientsExamsId, medParamExamId, value || null]);
            }

            return true;
        } catch (error) {
            console.error('Error in saveParameterValue:', error);
            throw error;
        }
    }
}

module.exports = ParameterModel;