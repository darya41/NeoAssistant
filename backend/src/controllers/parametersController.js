const db = require('../config/database');
const ParameterModel = require('../models/parameter');

class ParametersController {
    async getParameters(req, res) {
        try {
            const examId = req.query.examId;

            if (!examId) {
                return res.status(400).json({
                    success: false,
                    error: 'examId parameter is required'
                });
            }

            const parameters = await ParameterModel.getParametersByExamId(examId);

            res.json({ success: true, data: parameters });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting parameters' });
        }
    };

    async getAllParameters(req, res) {
        try {
            const parameters = await ParameterModel.getAllParameters();

            res.json({
                success: true,
                data: parameters
            });
        } catch (error) {
            res.status(500).json({ success: false, error: 'Error getting parameters' });
        }
    };

    async getParametersWithValuesByExamId(req, res) {
        try {
            const { patientExamId } = req.query;

            if (!patientExamId) {
                return res.status(400).json({
                    success: false,
                    error: 'patientExamId is required'
                });
            }


            const resultData = await ParameterModel.getParametersWithValuesByExamId(patientExamId);

            res.json({
                success: true,
                data: resultData
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error getting parameters with values'
            });
        }
    };
};

module.exports = new ParametersController();