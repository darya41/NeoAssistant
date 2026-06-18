const db = require('../config/database');
const AddressModel = require('../models/address');

class AddressController {
    async createAddress(req, res) {
        try {
            const { settlement_type, city, address_type, street, house_number, building, apartment } = req.body;

            if (!city || !street || !house_number) {
                return res.status(400).json({
                    success: false,
                    error: 'City, street and house number are required'
                });
            }

            const addressId = await AddressModel.create({
                settlement_type,
                city,
                address_type,
                street,
                house_number,
                building,
                apartment
            });

            const newAddress = await AddressModel.findById(addressId);

            if (!newAddress) {
                return res.status(500).json({
                    success: false,
                    error: 'Address created but not found'
                });
            }

            const addressData = Array.isArray(newAddress) ? newAddress[0] : newAddress;

            res.status(201).json({
                success: true,
                data: addressData
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error creating address: ' + error.message
            });
        }
    }
};

module.exports = new AddressController();