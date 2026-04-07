const db = require('../config/database');
const PatientExamModel = require('../models/patientExam');
const PatientModel = require('../models/patient');

const createPatientExam = async (req, res) => {
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

const saveExamParameters = async (req, res) => {

    try {
        const patientsExamsId = req.params.id;
        const { parameters } = req.body;

        if (!parameters || !Array.isArray(parameters)) {
            return res.status(400).json({
                success: false,
                error: 'parameters array is required'
            });
        }

        const [examInfo] = await db.query(
            `SELECT exam_id FROM patientsexams WHERE patients_exams_id = ?`,
            [patientsExamsId]
        );

        if (!examInfo || examInfo.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Осмотр не найден'
            });
        }

        const examId = examInfo[0].exam_id;

        const medicalParamIds = parameters.map(p => p.medical_parameter_id);
        const placeholders = medicalParamIds.map(() => '?').join(',');

        const [mappings] = await db.query(
            `SELECT medical_parameter_id, med_param_exam_id
             FROM MedParamInExams
             WHERE exam_id = ? AND medical_parameter_id IN (${placeholders})`,
            [examId, ...medicalParamIds]
        );

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
            await db.query(
                `INSERT INTO medparaminpatientexams
                 (patients_exams_id, med_param_exam_id, value)
                 VALUES ?
                 ON DUPLICATE KEY UPDATE value = VALUES(value)`,
                [valuesToInsert]
            );
        }

        const [savedData] = await db.query(
            `SELECT
                mpiv.med_patient_exam_id,
                mpiv.patients_exams_id,
                mpiv.med_param_exam_id,
                mpiv.value,
                mpie.medical_parameter_id,
                mp.name as parameter_name
             FROM medparaminpatientexams mpiv
             JOIN MedParamInExams mpie ON mpiv.med_param_exam_id = mpie.med_param_exam_id
             JOIN MedicalParameters mp ON mpie.medical_parameter_id = mp.medical_parameter_id
             WHERE mpiv.patients_exams_id = ?
             ORDER BY mpie.medical_parameter_id`,
            [patientsExamsId]
        );

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

const getPatientExamsByType = async (req, res) => {
    try {
        const { patientId, examTypeId } = req.query;

        if (!patientId || !examTypeId) {
            return res.status(400).json({
                success: false,
                error: 'patientId and examTypeId are required'
            });
        }

        const [results] = await db.query(`
            SELECT patients_exams_id, date_time
            FROM patientsexams
            WHERE patient_id = ? AND exam_id = ?
            ORDER BY date_time DESC
        `, [patientId, examTypeId]);

        res.json({
            success: true,
            data: results
        });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error getting patient exams' });
    }
};

module.exports = {
    createPatientExam,
    saveExamParameters,
    getPatientExamsByType
};