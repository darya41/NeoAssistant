const MotherModel = require('../models/mother');

const createMother = async (req, res) => {
    console.log('POST /api/mothers');
    console.log('Request body:', req.body);

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

        if (!last_name || !first_name || !date_of_birth || address_id==null ) {
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
        console.error('Error creating mother:', error);
        res.status(500).json({
            success: false,
            error: 'Error creating mother: ' + error.message
        });
    }
};

const getAllMothers = async (req, res) => {
    try {
        const mothers = await MotherModel.findAll();
        res.json({ success: true, data: mothers });
    } catch (error) {
        console.error('Error getting mothers:', error);
        res.status(500).json({
            success: false,
            error: 'Error getting mothers'
        });
    }
};

const getMotherById = async (req, res) => {
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

const updateMother = async (req, res) => {
    try {
        const motherId = req.params.id;

        const existingMother = await MotherModel.findById(motherId);
        if (!existingMother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        const affectedRows = await MotherModel.update(motherId, req.body);

        if (affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        const updatedMother = await MotherModel.findById(motherId);

        res.json({
            success: true,
            data: updatedMother,
            message: 'Mother updated successfully'
        });
    } catch (error) {
        console.error('Error updating mother:', error);
        res.status(500).json({
            success: false,
            error: 'Error updating mother: ' + error.message
        });
    }
};

const deleteMother = async (req, res) => {
    try {
        const motherId = req.params.id;

        const existingMother = await MotherModel.findById(motherId);
        if (!existingMother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        const affectedRows = await MotherModel.delete(motherId);

        if (affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        res.json({
            success: true,
            message: 'Mother deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting mother:', error);
        res.status(500).json({
            success: false,
            error: 'Error deleting mother: ' + error.message
        });
    }
};

module.exports = {
    createMother,
    getAllMothers,
    getMotherById,
    updateMother,
    deleteMother
};