const PatientExamModel = require('../models/patientExam');
const PatientModel = require('../models/patient');
const ParameterModel = require('../models/parameter');

class PatientExamController {
    async createPatientExam (req, res) {
        try {
            const { patient_id, exam_id, date_time } = req.body;
            const doctor_id = req.user.id;

            if (!patient_id || !exam_id || !date_time) {
                return res.status(400).json({
                    success: false,
                    error: 'patient_id, exam_id and date_time are required'
                });
            }

            const patientExists = await PatientModel.exists(patient_id);
            if (!patientExists) {
                return res.status(404).json({
                    success: false,
                    error: 'Пациент не найден'
                });
            }

            const patientsExamsId = await PatientExamModel.create({
                patient_id,
                exam_id,
                doctor_id,
                date_time
            });

            const newExam = await PatientExamModel.findById(patientsExamsId);

            res.status(201).json({
                success: true,
                data: newExam
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка создания осмотра'
            });
        }
    };

    async saveExamParameters (req, res) {

        try {
            const patientsExamsId = req.params.id;
            const { parameters } = req.body;

            if (!parameters || !Array.isArray(parameters)) {
                return res.status(400).json({
                    success: false,
                    error: 'parameters array is required'
                });
            }

           const examInfo = await PatientExamModel.getExamInfo(patientsExamsId);

            if (!examInfo) {
                return res.status(404).json({
                    success: false,
                    error: 'Осмотр не найден'
                });
            }

            const examId = examInfo.exam_id;

            const medicalParamIds = parameters.map(p => p.medical_parameter_id);
            const mappings = await PatientExamModel.getParameterMappings(examId, medicalParamIds);

            const mappingMap = new Map();
            mappings.forEach(m => {
                mappingMap.set(m.medical_parameter_id, m.med_param_exam_id);
            });

            let savedCount = 0;
            const valuesToInsert = [];

            for (const param of parameters) {
                const medParamExamId = mappingMap.get(param.medical_parameter_id);

                if (medParamExamId) {
                    valuesToInsert.push([
                        patientsExamsId,
                        medParamExamId,
                        param.value
                    ]);
                    savedCount++;
                }
            }

            if (valuesToInsert.length > 0) {
               await PatientExamModel.saveParameterValues(patientsExamsId, valuesToInsert);
            }

            res.status(201).json({
                success: true,
                message: 'Параметры сохранены',
                saved: savedCount,
                total: parameters.length
            });

        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка сохранения параметров: ' + error.message
            });
        }
    };

    async getPatientExamsByType (req, res) {
        try {
            const { patientId, examTypeId } = req.query;

            if (!patientId || !examTypeId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientId and examTypeId are required'
                });
            }

           const exams = await PatientExamModel.getPatientExamsByType(patientId, examTypeId);

            res.json({
                success: true,
                data: exams
            });
        } catch (error) {
            res.status(500).json({
            success: false,
            error: 'Error getting patient exams' });
        }
    };
};

module.exports = new PatientExamController();