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
                data: {
                    patient_exam_id: result[0].patients_exams_id,
                    exam_date: result[0].exam_date
                }
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

            const exam = await ExamModel.getExamDateTime(patientExamId);

            res.json({
                success: true,
                data: {
                    date_time: result[0].date_time
                }
            });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting exam datetime' });
        }
    };
}

module.exports = new ExamTypeController();