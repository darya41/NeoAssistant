const db = require('../config/database');

class ProtocolModel {

    static async findAll() {
        const [rows] = await db.query(
            'SELECT * FROM protocols ORDER BY id'
        );
        return rows;
    }

    static async findById(id) {
            const [rows] = await db.query(
                'SELECT * FROM clinicalprotocol WHERE protocol_id = ?',
                [id]
            );
            return rows[0];
        }
}

module.exports = ProtocolModel;