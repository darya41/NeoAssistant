const db = require('../config/database');

class AddressModel {

    static async create(addressData) {
        const { settlement_type, city, address_type, street, house_number, building, apartment } = addressData;

        const [result] = await db.query(
            `INSERT INTO addresses (settlement_type, city, address_type, street, house_number, building, apartment)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [settlement_type || null, city, address_type || null, street, house_number, building || null, apartment || null]
        );

        return result.insertId;
    }

    static async findById(id) {
        const [rows] = await db.query(
            `SELECT address_id, settlement_type, city, address_type, street, house_number, building, apartment
             FROM addresses WHERE address_id = ?`,
            [id]
        );

        return rows[0] || null;
    }
}

module.exports = AddressModel;