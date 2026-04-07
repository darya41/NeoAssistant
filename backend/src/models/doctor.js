const db = require('../config/database');

class DoctorModel {
    static async isEmailTakenByOther(email, doctorId) {
        const [rows] = await db.query(
            'SELECT doctor_id FROM doctors WHERE work_email = ? AND doctor_id != ?',
            [email, doctorId]
        );
        return rows.length > 0;
    }

    static async updateProfile(doctorId, updateData) {
        const {
            lastName, firstName, patronymic,
            email, phone, specializationId,
            hashedPassword
        } = updateData;

        const updates = [];
        const params = [];

        if (lastName !== undefined) {
            updates.push('last_name = ?');
            params.push(lastName);
        }
        if (firstName !== undefined) {
            updates.push('first_name = ?');
            params.push(firstName);
        }
        if (patronymic !== undefined) {
            updates.push('patronymic = ?');
            params.push(patronymic || null);
        }
        if (email !== undefined) {
            updates.push('work_email = ?');
            params.push(email);
        }
        if (phone !== undefined) {
            updates.push('work_phone = ?');
            params.push(phone);
        }
        if (specializationId !== undefined) {
            updates.push('specialization_id = ?');
            params.push(specializationId);
        }
        if (hashedPassword !== undefined) {
            updates.push('password = ?');
            params.push(hashedPassword);
        }

        if (updates.length === 0) {
            return 0;
        }

        const query = `UPDATE doctors SET ${updates.join(', ')} WHERE doctor_id = ?`;
        params.push(doctorId);

        const [result] = await db.query(query, params);
        return result.affectedRows;
    }
}

module.exports = DoctorModel;