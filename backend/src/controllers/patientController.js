const PatientModel = require('../models/patient');

const getAllPatients = async (req, res) => {
    console.log('GET /api/patients');
    try {
        const patients = await PatientModel.findAll();
        res.json(patients);
    } catch (error) {
        console.error('Error getting patients:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка получения пациентов'
        });
    }
};

module.exports = {
    getAllPatients
};