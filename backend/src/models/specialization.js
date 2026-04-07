const db = require('../config/database');

class SpecializationModel {
    static async getAll() {
        const [rows] = await db.query(
            'SELECT specialization_id, name, description FROM specializations ORDER BY name'
        );
        return rows;
    }
}

module.exports = SpecializationModel;