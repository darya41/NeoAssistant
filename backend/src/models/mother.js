const db = require('../config/database');

class MotherModel {
    static async findAll() {
        const [rows] = await db.query(`
            SELECT m.*, a.street, a.city, a.postal_code, a.country
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.id
            ORDER BY m.last_name, m.first_name
        `);
        return rows;
    }

    static async findById(id) {
        const [rows] = await db.query(`
            SELECT m.*, a.street, a.city, a.postal_code, a.country
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.id
            WHERE m.mother_id = ?
        `, [id]);
        return rows[0];
    }

    static async create(motherData) {
        const { last_name, first_name, patronymic, date_of_birth, phone, email, address_id } = motherData;
        const [result] = await db.query(
            `INSERT INTO mothers (last_name, first_name, patronymic, date_of_birth, phone, email, address_id)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [last_name, first_name, patronymic, date_of_birth, phone, email, address_id]
        );
        return result.insertId;
    }

    static async update(id, motherData) {
        const { last_name, first_name, patronymic, date_of_birth, phone, email, address_id } = motherData;
        const [result] = await db.query(
            `UPDATE mothers SET last_name = ?, first_name = ?, patronymic = ?, date_of_birth = ?,
             phone = ?, email = ?, address_id = ? WHERE mother_id = ?`,
            [last_name, first_name, patronymic, date_of_birth, phone, email, address_id, id]
        );
        return result.affectedRows;
    }

    static async delete(id) {
        const [result] = await db.query('DELETE FROM mothers WHERE mother_id = ?', [id]);
        return result.affectedRows;
    }

    static async findByEmail(email) {
        const [rows] = await db.query('SELECT * FROM mothers WHERE email = ?', [email]);
        return rows[0];
    }
}

module.exports = MotherModel;