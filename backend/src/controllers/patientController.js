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

const getPatientById = async (req, res) => {
    console.log(`GET /api/patients/${req.params.id}`);
    try {
        const patient = await PatientModel.findById(req.params.id);

        if (!patient) {
            return res.status(404).json({
                success: false,
                error: 'Пациент не найден'
            });
        }

        res.json(patient);
    } catch (error) {
        console.error('Error getting patient:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка получения пациента'
        });
    }
};

const createPatient = async (req, res) => {
    console.log('POST /api/patients');
    try {
        const {
            mother_id,
            date_of_birth,
            gender,
            number_history,
            blood_group,
            rh_factor,
            weight,
            height
        } = req.body;

        // Проверка обязательных полей
        if (!date_of_birth || !gender) {
            return res.status(400).json({
                success: false,
                error: 'date_of_birth and gender are required'
            });
        }

        // Проверка существования матери (если указана)
        if (mother_id) {
            const motherExists = await PatientModel.motherExists(mother_id);
            if (!motherExists) {
                return res.status(400).json({
                    success: false,
                    error: 'Mother not found'
                });
            }
        }

        const patientId = await PatientModel.create({
            mother_id,
            date_of_birth,
            gender,
            number_history,
            blood_group,
            rh_factor,
            weight,
            height
        });

        const newPatient = await PatientModel.findById(patientId);

        res.status(201).json({
            success: true,
            data: newPatient
        });
    } catch (error) {
        console.error('Error creating patient:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка создания пациента'
        });
    }
};
// controllers/patientController.js
// controllers/patientController.js
const searchPatients = async (req, res) => {
    console.log('🔍 ========== ПОИСК ПАЦИЕНТОВ ==========');
    console.log('📥 Параметр query:', req.query.query);

    try {
        const { query } = req.query;

        if (!query || query.trim().length === 0) {
            console.log('❌ Query пустой');
            return res.status(400).json({
                success: false,
                error: 'Query parameter is required'
            });
        }

        if (query.length < 2) {
            console.log('⚠️ Query слишком короткий (< 2)');
            return res.json({
                success: true,
                data: [],
                meta: { query, count: 0 }
            });
        }

        const patients = await PatientModel.search(query);

        console.log(`✅ Найдено пациентов: ${patients.length}`);
        console.log('🔍 ========== КОНЕЦ ПОИСКА ==========');

        res.json({
            success: true,
            data: patients,
            meta: {
                query: query,
                count: patients.length
            }
        });

    } catch (error) {
        console.error('❌ Ошибка поиска:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка поиска пациентов'
        });
    }
};


module.exports = {
    getAllPatients,
    getPatientById,
    createPatient,
    searchPatients
};