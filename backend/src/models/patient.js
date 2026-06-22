const db = require('../config/database');

class PatientModel {

    static async findAllPaginated(limit, offset) {
        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM patients'
        );
        const total = countResult[0].total;

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
            LIMIT ? OFFSET ?
        `, [limit, offset]);

        return { patients: rows, total };
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
    static async searchWithPagination(query, filters = {}, limit, offset) {
        let sql = `
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
            WHERE 1=1
        `;

        let countSql = `
            SELECT COUNT(*) as total
            FROM patients p
            LEFT JOIN mothers m ON p.mother_id = m.mother_id
            WHERE 1=1
        `;

        const params = [];

        if (query && query.trim().length >= 1) {
            sql += ` AND (
                p.number_history LIKE ?
                OR CONCAT(m.last_name, ' ', m.first_name, ' ', COALESCE(m.patronymic, '')) LIKE ?
            )`;
            countSql += ` AND (
                p.number_history LIKE ?
                OR CONCAT(m.last_name, ' ', m.first_name, ' ', COALESCE(m.patronymic, '')) LIKE ?
            )`;
            const searchTerm = `%${query}%`;
            params.push(searchTerm, searchTerm);
        }

        if (filters.gender) {
            sql += ` AND p.gender = ?`;
            countSql += ` AND p.gender = ?`;
            params.push(filters.gender === 'Мужской' ? 'MALE' : 'FEMALE');
        }

        if (filters.bloodGroup) {
            sql += ` AND p.blood_group = ?`;
            countSql += ` AND p.blood_group = ?`;
            params.push(filters.bloodGroup);
        }

        if (filters.rhFactor) {
            sql += ` AND p.rh_factor = ?`;
            countSql += ` AND p.rh_factor = ?`;
            params.push(filters.rhFactor);
        }

        if (filters.dateFrom && filters.dateTo) {
            sql += ` AND p.date_of_birth BETWEEN ? AND ?`;
            countSql += ` AND p.date_of_birth BETWEEN ? AND ?`;
            params.push(filters.dateFrom, filters.dateTo);
        }

        const [countResult] = await db.query(countSql, params);
        const total = countResult[0].total;

        sql += ` ORDER BY p.patient_id DESC LIMIT ? OFFSET ?`;
        const dataParams = [...params, limit, offset];
        const [rows] = await db.query(sql, dataParams);

        return { patients: rows, total };
    }

    static async getParameterMappings(examId, medicalParamIds) {
            console.log('🔍 getParameterMappings called:', { examId, medicalParamIds });

            if (!medicalParamIds || medicalParamIds.length === 0) {
                return [];
            }

            const placeholders = medicalParamIds.map(() => '?').join(',');
            const [rows] = await db.query(
                `SELECT medical_parameter_id, med_param_exam_id
                 FROM medparaminexams
                 WHERE exam_id = ? AND medical_parameter_id IN (${placeholders})`,
                [examId, ...medicalParamIds]
            );

            return rows;
        }
}

module.exports = PatientModel;