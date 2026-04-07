const PatientModel = require('../models/patient');

class PatientController {
    async getAllPatients(req, res) {
        try {
            const patients = await PatientModel.findAll();
            res.json(patients);
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка получения пациентов'
            });
        }
    };

    async getPatientById(req, res) {
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
            res.status(500).json({
                success: false,
                error: 'Ошибка получения пациента'
            });
        }
    };

    async createPatient(req, res) {
        try {
            const { mother_id, date_of_birth, gender,
                number_history, blood_group, rh_factor,
                weight, height
            } = req.body;

            if (!date_of_birth || !gender) {
                return res.status(400).json({
                    success: false,
                    error: 'date_of_birth and gender are required'
                });
            }

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
                mother_id, date_of_birth, gender,
                number_history, blood_group, rh_factor,
                weight, height
            });

            const newPatient = await PatientModel.findById(patientId);

            res.status(201).json({
                success: true,
                data: newPatient
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка создания пациента'
            });
        }
    };

    async searchPatients(req, res) {

        try {
            const { query, gender, bloodGroup, rhFactor,
                dateFrom, dateTo
            } = req.query;

            if ((!query || query.length < 2) &&
                !gender && !bloodGroup && !rhFactor && !dateFrom && !dateTo) {
                return res.json({
                    success: true,
                    data: [],
                    meta: { query, count: 0 }
                });
            }

            const filters = {
                gender: gender,
                bloodGroup: bloodGroup,
                rhFactor: rhFactor,
                dateFrom: dateFrom,
                dateTo: dateTo
            };

            const patients = await PatientModel.search(query, filters);

            res.json({
                success: true,
                data: patients,
                meta: {
                    query: query,
                    filters: filters,
                    count: patients.length
                }
            });

        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка поиска пациентов'
            });
        }
    };
};

module.exports = new PatientController();