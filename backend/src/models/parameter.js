const db = require('../config/database');

class ParameterModel {
    static async getParametersByExamId(examId) {
        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

        if (paramIds.length === 0) {
            return [];
        }

        const [paramsResult] = await db.query(`
            SELECT
                mp.medical_parameter_id,
                mp.name,
                mp.value_type,
                mp.unit,
                mp.description
            FROM MedicalParameters mp
            WHERE mp.medical_parameter_id IN (?)
                AND NOT (
                    mp.value_type = 'enum'
                    AND NOT EXISTS (
                        SELECT 1 FROM parametervalues pv
                        WHERE pv.medical_parameter_id = mp.medical_parameter_id
                    )
                )
        `, [paramIds]);

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

    static async getParametersWithValues(examId, patientExamId) {
        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

        if (paramIds.length === 0) {
            return [];
        }

        const [paramsResult] = await db.query(`
            SELECT
                mp.medical_parameter_id,
                mp.name,
                mp.value_type,
                mp.unit,
                mp.description,
                mpiv.value as saved_value
            FROM MedicalParameters mp
            LEFT JOIN MedParamInExams mpie ON mp.medical_parameter_id = mpie.medical_parameter_id
            LEFT JOIN MedParamInPatientExams mpiv ON mpie.med_param_exam_id = mpiv.med_param_exam_id
                AND mpiv.patients_exams_id = ?
            WHERE mp.medical_parameter_id IN (?)
        `, [patientExamId, paramIds]);

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

    static async getPrimaryExamId(patientId, examTypeId) {
        const [result] = await db.query(`
            SELECT patients_exams_id
            FROM PatientExams
            WHERE patient_id = ? AND exam_type_id = ?
            ORDER BY exam_date DESC
            LIMIT 1
        `, [patientId, examTypeId]);

        return result.length > 0 ? result[0].patients_exams_id : null;
    }

    static async saveParameterValues(patientExamId, parameters) {
        const connection = await db.getConnection();

        try {
            await connection.beginTransaction();

            await connection.query(
                'DELETE FROM MedParamInPatientExams WHERE patients_exams_id = ?',
                [patientExamId]
            );

            for (const param of parameters) {
                const [medParamExamResult] = await connection.query(
                    `SELECT med_param_exam_id
                     FROM MedParamInExams
                     WHERE exam_id = ? AND medical_parameter_id = ?`,
                    [param.exam_id, param.medical_parameter_id]
                );

                if (medParamExamResult.length > 0 && param.value) {
                    await connection.query(
                        `INSERT INTO MedParamInPatientExams
                         (value, med_param_exam_id, patients_exams_id)
                         VALUES (?, ?, ?)`,
                        [param.value, medParamExamResult[0].med_param_exam_id, patientExamId]
                    );
                }
            }

            await connection.commit();
            return true;
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    }

    static async createPatientExam(patientId, examTypeId, examDate) {
        const [result] = await db.query(
            `INSERT INTO PatientExams (patient_id, exam_type_id, exam_date)
             VALUES (?, ?, ?)`,
            [patientId, examTypeId, examDate]
        );

        return result.insertId;
    }
}

module.exports = ParameterModel;