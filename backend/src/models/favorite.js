const db = require('../config/database');

class FavoriteModel {
    static async isFavorite(doctorId, patientId) {
        const [rows] = await db.query(
            'SELECT 1 FROM favorite_patients WHERE doctor_id = ? AND patient_id = ? LIMIT 1',
            [doctorId, patientId]
        );
        return rows.length > 0;
    }

    static async addFavorite(doctorId, patientId) {
        const [result] = await db.query(
            'INSERT INTO favorite_patients (doctor_id, patient_id) VALUES (?, ?)',
            [doctorId, patientId]
        );
        return result.insertId;
    }

    static async removeFavorite(doctorId, patientId) {
        const [result] = await db.query(
            'DELETE FROM favorite_patients WHERE doctor_id = ? AND patient_id = ?',
            [doctorId, patientId]
        );
        return result.affectedRows;
    }

    static async getFavoritesByDoctorId(doctorId) {
            const [rows] = await db.query(
                'SELECT patient_id, created_at FROM favorite_patients WHERE doctor_id = ? ORDER BY created_at DESC',
                [doctorId]
            );
            return rows;
        }
}

module.exports = FavoriteModel;