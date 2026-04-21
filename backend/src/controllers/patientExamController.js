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

   async saveExamParameters(req, res) {
       try {
           console.log('=========================================');
           console.log('📝 saveExamParameters called');
           console.log('📝 Timestamp:', new Date().toISOString());

           const patientsExamsId = req.params.id;
           const { parameters } = req.body;

           console.log('📝 patientsExamsId:', patientsExamsId);
           console.log('📝 parameters count:', parameters?.length || 0);
           console.log('📝 parameters:', JSON.stringify(parameters, null, 2));

           if (!parameters || !Array.isArray(parameters)) {
               console.log('❌ Invalid parameters: not an array');
               return res.status(400).json({
                   success: false,
                   error: 'parameters array is required'
               });
           }

           console.log('🔍 Getting exam info for patientsExamsId:', patientsExamsId);
           const examInfo = await PatientExamModel.getExamInfo(patientsExamsId);
           console.log('📊 examInfo:', examInfo);

           if (!examInfo) {
               console.log('❌ Exam not found for ID:', patientsExamsId);
               return res.status(404).json({
                   success: false,
                   error: 'Осмотр не найден'
               });
           }

           const examId = examInfo.exam_id;
           console.log('📊 examId:', examId);

           const medicalParamIds = parameters.map(p => p.medical_parameter_id);
           console.log('🔍 medicalParamIds:', medicalParamIds);

           console.log('🔍 Getting parameter mappings for examId:', examId);
           const mappings = await PatientModel.getParameterMappings(examId, medicalParamIds);
           console.log('📊 mappings count:', mappings?.length || 0);
           console.log('📊 mappings:', JSON.stringify(mappings, null, 2));

           const mappingMap = new Map();
           mappings.forEach(m => {
               mappingMap.set(m.medical_parameter_id, m.med_param_exam_id);
           });
           console.log('📊 mappingMap size:', mappingMap.size);

           let savedCount = 0;
           const valuesToInsert = [];

           for (const param of parameters) {
               const medParamExamId = mappingMap.get(param.medical_parameter_id);
               console.log(`🔍 param ${param.medical_parameter_id}: medParamExamId = ${medParamExamId}`);

               if (medParamExamId) {
                   valuesToInsert.push([
                       patientsExamsId,
                       medParamExamId,
                       param.value
                   ]);
                   savedCount++;
               }
           }

           console.log('📊 valuesToInsert count:', valuesToInsert.length);
           console.log('📊 savedCount:', savedCount);
           console.log('📊 total parameters:', parameters.length);

           if (valuesToInsert.length > 0) {
               console.log('💾 Saving parameter values...');
               await PatientExamModel.saveParameterValues(patientsExamsId, valuesToInsert);
               console.log('✅ Parameters saved successfully');
           } else {
               console.log('⚠️ No parameters to save');
           }

           console.log('✅ saveExamParameters completed successfully');
           console.log('=========================================');

           res.status(201).json({
               success: true,
               message: 'Параметры сохранены',
               saved: savedCount,
               total: parameters.length
           });

       } catch (error) {
           console.error('=========================================');
           console.error('❌ ERROR in saveExamParameters');
           console.error('❌ Error message:', error.message);
           console.error('❌ Error stack:', error.stack);
           console.error('❌ Timestamp:', new Date().toISOString());
           console.error('=========================================');

           res.status(500).json({
               success: false,
               error: 'Ошибка сохранения параметров: ' + error.message
           });
       }
   }
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