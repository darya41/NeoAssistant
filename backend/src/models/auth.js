const db = require('../config/database');
const bcrypt = require('bcrypt');

class AuthModel {
    static async findByEmail(email) {
        const [rows] = await db.query(
            `SELECT d.*, s.name as specialization_name
             FROM doctors d
             LEFT JOIN specializations s ON d.specialization_id = s.specialization_id
             WHERE d.work_email = ?`,
            [email]
        );
        return rows[0];
    }

    static async emailExists(email) {
        const [rows] = await db.query(
            'SELECT * FROM doctors WHERE work_email = ?',
            [email]
        );
        return rows.length > 0;
    }

    static async createDoctor(doctorData) {
        const {
            email, hashedPassword,
            last_name, first_name, middle_name,
            personal_phone, specialization_id
        } = doctorData;

        const [result] = await db.query(
            `INSERT INTO doctors
            (work_email, password, last_name, first_name, patronymic, work_phone, specialization_id)
            VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                email,
                hashedPassword,
                last_name,
                first_name,
                middle_name || null,
                personal_phone,
                specialization_id
            ]
        );

        return result.insertId;
    }

    static async updateRefreshToken(doctorId, refreshToken) {
        await db.query(
            'UPDATE doctors SET refresh_token = ? WHERE doctor_id = ?',
            [refreshToken, doctorId]
        );
    }

    static async findByRefreshToken(doctorId, refreshToken) {
        const [rows] = await db.query(
            'SELECT * FROM doctors WHERE doctor_id = ? AND refresh_token = ?',
            [doctorId, refreshToken]
        );
        return rows[0];
    }
}

module.exports = AuthModel;