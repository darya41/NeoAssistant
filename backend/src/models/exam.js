const db = require('../config/database');

class ExamModel {

    static async getExamTypeName(patientExamId) {
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

        return result[0]?.exam_name || 'Осмотр';
    }

    static async getPrimaryExamId(patientId, examTypeId) {
        const [result] = await db.query(`
            SELECT patients_exams_id, date_time as exam_date
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY date_time DESC
            LIMIT 1
        `, [patientId, examTypeId]);

        return result[0] || null;
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

        return result[0] || null;
    }
}

module.exports = ExamModel;