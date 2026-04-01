const db = require('../config/database');

class MotherModel {
    static async findAll() {
        const [rows] = await db.query(`
            SELECT m.*, a.city, a.street, a.house_number, a.building, a.apartment
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.address_id
            ORDER BY m.last_name, m.first_name
        `);
        return rows;
    }

    static async findById(id) {
        const [rows] = await db.query(`
            SELECT m.*, a.city, a.street, a.house_number, a.building, a.apartment
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.address_id
            WHERE m.mother_id = ?
        `, [id]);
        return rows[0];
    }

    static async create(motherData) {
        const {
            last_name,
            first_name,
            patronymic,
            date_of_birth,
            number_of_deliveries,
            number_of_pregnancies,
            medical_history,
            medications_during_pregnancy,
            gestational_diabetes,
            preeclampsia,
            groupb_streptococcus_status,
            address_id,
            blood_group,
            rh_factor
        } = motherData;

        const [result] = await db.query(
            `INSERT INTO mothers (
                last_name, first_name, patronymic, date_of_birth,
                number_of_deliveries, number_of_pregnancies,
                medical_history, medications_during_pregnancy,
                gestational_diabetes, preeclampsia,
                groupb_streptococcus_status, address_id,
                blood_group, rh_factor
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                last_name,
                first_name,
                patronymic || null,
                date_of_birth,
                number_of_deliveries ?? null,
                number_of_pregnancies ?? null,
                medical_history || null,
                medications_during_pregnancy || null,
                gestational_diabetes === true || gestational_diabetes === 1 ? 1 : 0,
                preeclampsia === true || preeclampsia === 1 ? 1 : 0,
                groupb_streptococcus_status || null,
                address_id || null,
                blood_group || null,
                rh_factor || null
            ]
        );
        return result.insertId;
    }

    static async update(id, motherData) {
        const {
            last_name,
            first_name,
            patronymic,
            date_of_birth,
            number_of_deliveries,
            number_of_pregnancies,
            medical_history,
            medications_during_pregnancy,
            gestational_diabetes,
            preeclampsia,
            groupb_streptococcus_status,
            address_id,
            blood_group,
            rh_factor
        } = motherData;

        const [result] = await db.query(
            `UPDATE mothers SET
                last_name = ?,
                first_name = ?,
                patronymic = ?,
                date_of_birth = ?,
                number_of_deliveries = ?,
                number_of_pregnancies = ?,
                medical_history = ?,
                medications_during_pregnancy = ?,
                gestational_diabetes = ?,
                preeclampsia = ?,
                groupb_streptococcus_status = ?,
                address_id = ?,
                blood_group = ?,
                rh_factor = ?
            WHERE mother_id = ?`,
            [
                last_name,
                first_name,
                patronymic || null,
                date_of_birth,
                number_of_deliveries ?? null,
                number_of_pregnancies ?? null,
                medical_history || null,
                medications_during_pregnancy || null,
                gestational_diabetes === true || gestational_diabetes === 1 ? 1 : 0,
                preeclampsia === true || preeclampsia === 1 ? 1 : 0,
                groupb_streptococcus_status || null,
                address_id || null,
                blood_group || null,
                rh_factor || null,
                id
            ]
        );
        return result.affectedRows;
    }

    static async delete(id) {
        const [result] = await db.query(
            'DELETE FROM mothers WHERE mother_id = ?',
            [id]
        );
        return result.affectedRows;
    }

    static async motherExists(motherId) {
        const [rows] = await db.query(
            'SELECT mother_id FROM mothers WHERE mother_id = ?',
            [motherId]
        );
        return rows.length > 0;
    }
}

module.exports = MotherModel;