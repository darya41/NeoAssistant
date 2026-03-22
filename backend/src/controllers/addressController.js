const db = require('../config/database');

const createAddress = async (req, res) => {
    console.log('POST /api/addresses');
    try {
        const { settlement_type, city, address_type, street, house_number, building, apartment } = req.body;

        if (!city || !street || !house_number) {
            return res.status(400).json({
                success: false,
                error: 'City, street and house number are required'
            });
        }

        const [result] = await db.query(
            `INSERT INTO addresses (settlement_type, city, address_type, street, house_number, building, apartment)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [settlement_type || null, city, address_type || null, street, house_number, building || null, apartment || null]
        );

        const [newAddress] = await db.query(
            `SELECT address_id, settlement_type, city, address_type, street, house_number, building, apartment
             FROM addresses WHERE address_id = ?`,
            [result.insertId]
        );

        res.status(201).json({ success: true, data: newAddress[0] });
    } catch (error) {
        console.error('Error creating address:', error);
        res.status(500).json({ success: false, error: 'Error creating address' });
    }
};

const getAddressById = async (req, res) => {
    try {
        const [addresses] = await db.query(
            `SELECT address_id, settlement_type, city, address_type, street, house_number, building, apartment
             FROM addresses WHERE address_id = ?`,
            [req.params.id]
        );

        if (addresses.length === 0) {
            return res.status(404).json({ success: false, error: 'Address not found' });
        }

        res.json({ success: true, data: addresses[0] });
    } catch (error) {
        console.error('Error getting address:', error);
        res.status(500).json({ success: false, error: 'Error getting address' });
    }
};

const updateAddress = async (req, res) => {
    try {
        const { settlement_type, city, address_type, street, house_number, building, apartment } = req.body;

        const [result] = await db.query(
            `UPDATE addresses SET
                settlement_type = COALESCE(?, settlement_type),
                city = COALESCE(?, city),
                address_type = COALESCE(?, address_type),
                street = COALESCE(?, street),
                house_number = COALESCE(?, house_number),
                building = COALESCE(?, building),
                apartment = COALESCE(?, apartment)
             WHERE address_id = ?`,
            [settlement_type, city, address_type, street, house_number, building, apartment, req.params.id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: 'Address not found' });
        }

        res.json({ success: true, message: 'Address updated' });
    } catch (error) {
        console.error('Error updating address:', error);
        res.status(500).json({ success: false, error: 'Error updating address' });
    }
};

const deleteAddress = async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM addresses WHERE address_id = ?', [req.params.id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: 'Address not found' });
        }

        res.json({ success: true, message: 'Address deleted' });
    } catch (error) {
        console.error('Error deleting address:', error);
        res.status(500).json({ success: false, error: 'Error deleting address' });
    }
};

module.exports = { createAddress, getAddressById, updateAddress, deleteAddress };