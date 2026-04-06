const db = require('../config/database');

class ParameterModel {
    static async getParametersByExamId(examId) {
        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id, med_param_exam_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        if (paramIdsResult.length === 0) {
            return [];
        }

        const medicalParamIds = paramIdsResult.map(row => row.medical_parameter_id);
        const medParamExamIds = paramIdsResult.map(row => row.med_param_exam_id);

        const [paramsResult] = await db.query(`
            SELECT
                mp.medical_parameter_id,
                mp.name,
                mp.value_type,
                mp.unit,
                mp.description
            FROM MedicalParameters mp
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

        return { parameters, paramIdsResult };
    }

    static async getAllParameters() {
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

        return parameters;
    }

    static async getParametersWithValuesByExamId(patientExamId) {
        const [paramInExams] = await db.query(`
            SELECT mpie.medical_parameter_id, mpie.med_param_exam_id
            FROM MedParamInExams mpie
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
            FROM MedicalParameters
            WHERE medical_parameter_id IN (${placeholders})
            ORDER BY medical_parameter_id
        `, medicalParamIds);

        const valuePlaceholders = medParamExamIds.map(() => '?').join(',');
        const [patientValues] = await db.query(`
            SELECT med_param_exam_id, value
            FROM MedParamInPatientExams
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
                value: displayValue
            });
        }

        return resultData;
    }

    static async getPrimaryExamId(patientId, examTypeId) {
        const [result] = await db.query(`
            SELECT patients_exams_id, date_time as exam_date
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY date_time DESC
            LIMIT 1
        `, [patientId, examTypeId]);

        return result.length > 0 ? result[0] : null;
    }

    static async getDailyExamList(patientId, examTypeId) {
        const [results] = await db.query(`
            SELECT patients_exams_id, date_time
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY patients_exams_id DESC
        `, [patientId, examTypeId]);

        return results.map(row => ({
            patient_exam_id: row.patients_exams_id,
            date_time: row.date_time
        }));
    }

    static async getExamDateTime(patientExamId) {
        const [result] = await db.query(`
            SELECT date_time
            FROM patientsexams
            WHERE patients_exams_id = ?
        `, [patientExamId]);

        return result.length > 0 ? result[0].date_time : null;
    }

    static async getExamTypeByExamId(patientExamId) {
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

        return result.length > 0 ? result[0].exam_name : 'Осмотр';
    }
}

module.exports = ParameterModel;