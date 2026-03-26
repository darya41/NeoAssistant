const db = require('../config/database');

class PatientModel {

    static async findAll() {
        const [rows] = await db.query(`
            SELECT
                p.patient_id,
                p.mother_id,
                p.date_of_birth,
                p.gender,
                p.number_history,
                CONCAT(m.last_name, ' ', m.first_name, ' ', COALESCE(m.patronymic, '')) as mother_name
            FROM patients p
            LEFT JOIN mothers m ON p.mother_id = m.mother_id
            ORDER BY p.patient_id DESC
        `);
        return rows;
    }
}

module.exports = PatientModel;