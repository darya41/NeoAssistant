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
                p.blood_group,
                p.rh_factor,
                p.weight,
                p.height,
                CONCAT(m.last_name, ' ', m.first_name, ' ', COALESCE(m.patronymic, '')) as mother_name
            FROM patients p
            LEFT JOIN mothers m ON p.mother_id = m.mother_id
            ORDER BY p.patient_id DESC
        `);
        return rows;
    }

    static async findById(id) {
        const [rows] = await db.query(`
            SELECT
                p.patient_id,
                p.mother_id,
                p.date_of_birth,
                p.gender,
                p.number_history,
                p.blood_group,
                p.rh_factor,
                p.weight,
                p.height,
                CONCAT(m.last_name, ' ', m.first_name, ' ', COALESCE(m.patronymic, '')) as mother_name
            FROM patients p
            LEFT JOIN mothers m ON p.mother_id = m.mother_id
            WHERE p.patient_id = ?
        `, [id]);
        return rows[0];
    }

    static async create(patientData) {
        const {
            mother_id,
            date_of_birth,
            gender,
            number_history,
            blood_group,
            rh_factor,
            weight,
            height
        } = patientData;

        // Логируем для отладки
        console.log('Creating patient with values:', {
            mother_id,
            date_of_birth,
            gender,
            number_history,
            blood_group,
            rh_factor,
            weight,
            height
        });

        const [result] = await db.query(`
            INSERT INTO patients (
                mother_id,
                date_of_birth,
                gender,
                number_history,
                blood_group,
                rh_factor,
                weight,
                height
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            mother_id || null,
            date_of_birth,
            gender,
            number_history || null,
            blood_group || null,
            rh_factor || null,
            weight || null,
            height || null
        ]);

        return result.insertId;
    }

    static async exists(id) {
        const patient = await this.findById(id);
        return !!patient;
    }

    static async motherExists(motherId) {
        const [rows] = await db.query(
            'SELECT mother_id FROM mothers WHERE mother_id = ?',
            [motherId]
        );
        return rows.length > 0;
    }
}

module.exports = PatientModel;