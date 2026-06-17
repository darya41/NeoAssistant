const PatientModel = require('../models/patient');

class PatientController {
    async getAllPatients(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 15;
            const offset = (page - 1) * limit;

            const { patients, total } = await PatientModel.findAllPaginated(limit, offset);

            res.json({
                success: true,
                data: patients,
                totalCount: total,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    totalPages: Math.ceil(total / limit),
                    hasNext: offset + limit < total
                }
            });
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
           const {
               query,
               gender,
               bloodGroup,
               rhFactor,
               dateFrom,
               dateTo,
               page = 1,
               limit = 15
           } = req.query;

           const pageNum = parseInt(page);
           const limitNum = parseInt(limit);
           const offset = (pageNum - 1) * limitNum;

           if ((!query || query.trim() === '') &&
               !gender && !bloodGroup && !rhFactor && !dateFrom && !dateTo) {
               const { patients, total } = await PatientModel.findAllPaginated(limitNum, offset);
               return res.json({
                   success: true,
                   data: patients,
                   pagination: {
                       currentPage: pageNum,
                       limit: limitNum,
                       total: total,
                       totalPages: Math.ceil(total / limitNum),
                       hasNext: offset + limitNum < total
                   }
               });
           }

           const filters = {
               gender: gender,
               bloodGroup: bloodGroup,
               rhFactor: rhFactor,
               dateFrom: dateFrom,
               dateTo: dateTo
           };

           const { patients, total } = await PatientModel.searchWithPagination(
               query,
               filters,
               limitNum,
               offset
           );

           res.json({
               success: true,
               data: patients,
               pagination: {
                   currentPage: pageNum,
                   limit: limitNum,
                   total: total,
                   totalPages: Math.ceil(total / limitNum),
                   hasNext: offset + limitNum < total
               }
           });

       } catch (error) {
           console.error('Search error:', error);
           res.status(500).json({
               success: false,
               error: 'Ошибка поиска пациентов'
           });
       }
   };
};

module.exports = new PatientController();