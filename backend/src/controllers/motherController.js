const MotherModel = require('../models/mother');

class MotherController {
    async createMother(req, res) {
        try {
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
            } = req.body;

            if (!last_name || !first_name || !date_of_birth || address_id == null) {
                return res.status(400).json({
                    success: false,
                    error: 'Last name, first name and date of birth are required'
                });
            }

            const motherId = await MotherModel.create({
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
            });

            const newMother = await MotherModel.findById(motherId);

            res.status(201).json({
                success: true,
                data: newMother
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error creating mother: ' + error.message
            });
        }
    };

    async getAllMothers(req, res) {
        try {
            const mothers = await MotherModel.findAll();
            res.json({ success: true, data: mothers });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error getting mothers'
            });
        }
    };

    async getMotherById(req, res) {
        try {
            const mother = await MotherModel.findById(req.params.id);

            if (!mother) {
                return res.status(404).json({
                    success: false,
                    error: 'Mother not found'
                });
            }

            res.json({ success: true, data: mother });
        } catch (error) {
            console.error('Error getting mother:', error);
            res.status(500).json({
                success: false,
                error: 'Error getting mother'
            });
        }
    };
};

module.exports = new MotherController();