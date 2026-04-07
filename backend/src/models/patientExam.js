const db = require('../config/database');

class PatientExamModel {

    static async create(examData) {
        const { patient_id, exam_id, doctor_id, date_time } = examData;

        const [result] = await db.query(`
            INSERT INTO patientsExams (patient_id, exam_id, doctor_id, date_time)
            VALUES (?, ?, ?, ?)
        `, [patient_id, exam_id, doctor_id, date_time]);

        return result.insertId;
    }

    static async findById(id) {
        const [rows] = await db.query(`
            SELECT
                pe.patients_exams_id,
                pe.patient_id,
                pe.exam_id,
                pe.doctor_id,
                pe.date_time,
                e.exam_type_id,
                et.name as exam_type_name,
                CONCAT(d.last_name, ' ', d.first_name) as doctor_name
            FROM patientsExams pe
            LEFT JOIN exams e ON pe.exam_id = e.exam_id
            LEFT JOIN examsTypes et ON e.exam_type_id = et.exam_type_id
            LEFT JOIN doctors d ON pe.doctor_id = d.doctor_id
            WHERE pe.patients_exams_id = ?
        `, [id]);
        return rows[0] || null;
    }

    static async saveParameters(patientsExamsId, parameters) {
        for (const param of parameters) {
            await db.query(`
                INSERT INTO medParamInPatientExams (patients_exams_id, med_param_exam_id, value)
                VALUES (?, ?, ?)
            `, [patientsExamsId, param.medical_parameter_id, param.value]);
        }
    }

    static async exists(id) {
        const [rows] = await db.query(
            'SELECT patients_exams_id FROM patientsExams WHERE patients_exams_id = ?',
            [id]
        );
        return rows.length > 0;
    }

    static async getExamInfo(patientsExamsId) {
        const [rows] = await db.query(
            'SELECT exam_id FROM patientsexams WHERE patients_exams_id = ?',
            [patientsExamsId]
        );
        return rows[0];
    }

    static async saveParameterValues(patientsExamsId, valuesToInsert) {
        if (valuesToInsert.length === 0) return 0;

        const [result] = await db.query(
            `INSERT INTO medparaminpatientexams
                    (patients_exams_id, med_param_exam_id, value)
                    VALUES ?
                    ON DUPLICATE KEY UPDATE value = VALUES(value)`,
            [valuesToInsert]
        );
        return result.affectedRows;
    }

    static async getPatientExamsByType(patientId, examTypeId) {
        const [rows] = await db.query(
            `SELECT patients_exams_id, date_time
                        FROM patientsexams
                        WHERE patient_id = ? AND exam_id = ?
                        ORDER BY date_time DESC`,
            [patientId, examTypeId]
        );
        return rows;
    }
}

module.exports = PatientExamModel;