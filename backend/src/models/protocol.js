const db = require('../config/database');

class ProtocolModel {

    static async findAll() {
        const [rows] = await db.query(
            'SELECT * FROM protocols ORDER BY id'
        );
        return rows;
    }
}

module.exports = ProtocolModel;