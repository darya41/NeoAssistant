const PatientExamModel = require('../models/patientExam');
const PatientModel = require('../models/patient');

const createPatientExam = async (req, res) => {
    console.log('POST /api/patient-exams');
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
        console.error('Error creating patient exam:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка создания осмотра'
        });
    }
};

const saveExamParameters = async (req, res) => {
    console.log(`POST /api/patient-exams/${req.params.id}/parameters`);
    try {
        const patientsExamsId = req.params.id;
        const { parameters } = req.body;

        if (!parameters || !Array.isArray(parameters)) {
            return res.status(400).json({
                success: false,
                error: 'parameters array is required'
            });
        }

        const examExists = await PatientExamModel.exists(patientsExamsId);
        if (!examExists) {
            return res.status(404).json({
                success: false,
                error: 'Осмотр не найден'
            });
        }

        await PatientExamModel.saveParameters(patientsExamsId, parameters);

        res.status(201).json({
            success: true,
            message: 'Параметры сохранены'
        });
    } catch (error) {
        console.error('Error saving exam parameters:', error);
        res.status(500).json({
            success: false,
            error: 'Ошибка сохранения параметров'
        });
    }
};

module.exports = {
    createPatientExam,
    saveExamParameters
};