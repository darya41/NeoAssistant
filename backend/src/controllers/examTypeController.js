const ExamModel = require('../models/exam');

class ExamTypeController {

    async getExamTypeByExamId(req, res) {
        try {
            const { patientExamId } = req.query;

            if (!patientExamId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientExamId is required'
                });
            }

            const examName = await ExamModel.getExamTypeName(patientExamId);

            res.json({
                success: true,
                data: {
                    exam_name: examName
                }
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error getting exam type'
            });
        }
    };

    async getPrimaryExamId(req, res) {
        try {
            const { patientId, examTypeId } = req.query;

            if (!patientId || !examTypeId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientId and examTypeId parameters are required'
                });
            }

            const exam = await ExamModel.getPrimaryExamId(patientId, examTypeId);

             res.json({
                success: true,
                data: exam
             });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting primary exam id' });
        }
    };

    async getDailyExamList(req, res) {
        try {
            const { patientId, examTypeId } = req.query;

            if (!patientId || !examTypeId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientId and examTypeId are required'
                });
            }

            const examList = await ExamModel.getDailyExamList(patientId, examTypeId);

            res.json({
                success: true,
                data: examList
            });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting daily exam list' });
        }
    };

    async getExamDateTime(req, res) {
        try {
            const { patientExamId } = req.query;

            if (!patientExamId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientExamId is required'
                });
            }

            const examDateTime = await ExamModel.getExamDateTime(patientExamId);

            res.json({
                success: true,
                data: {
                    date_time: examDateTime
                }
            });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting exam datetime' });
        }
    };

   async getAllExamTypes(req, res) {
       try {
           const examTypes = await ExamModel.getAllExamTypes();

           res.json({
               success: true,
               data: examTypes
           });
       } catch (error) {
           console.error('Error in getAllExamTypes:', error);
           res.status(500).json({
               success: false,
               error: 'Error getting exam types'
           });
       }
   }
}

module.exports = new ExamTypeController();