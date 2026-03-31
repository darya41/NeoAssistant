const db = require('../config/database');
const AddressModel = require('../models/address');

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

        const addressId = await AddressModel.create({
                    settlement_type, city, address_type, street, house_number, building, apartment
                });

        const newAddress = await AddressModel.findById(addressId);

        res.status(201).json({ success: true, data: newAddress[0] });
    } catch (error) {
        console.error('Error creating address:', error);
        res.status(500).json({ success: false, error: 'Error creating address' });
    }
};



module.exports = { createAddress };