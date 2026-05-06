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

    async getParametersWithValues(req, res) {
        try {
            console.log('🚀 ===== getParametersWithValues START =====');
            const { examId, patientExamId } = req.query;

            console.log('📥 Request query params:', { examId, patientExamId });

            if (!examId || !patientExamId) {
                console.log('❌ Missing required parameters');
                return res.status(400).json({
                    success: false,
                    error: 'examId and patientExamId parameters are required'
                });
            }

            console.log('📡 STEP 1: Getting parameters for examId:', examId);

            const parameters = await ParameterModel.getParametersByExamId(examId);
            console.log(`📊 Retrieved ${parameters.length} parameters from database`);
            console.log('📋 Parameters sample:', parameters.slice(0, 2));

            console.log('📡 STEP 2: Getting existing values for patientExamId:', patientExamId);
            const existingValues = await ParameterModel.getParameterValuesByPatientExamId(patientExamId);
            console.log(`📊 Retrieved ${existingValues.length} existing values`);
            console.log('📋 Values sample:', existingValues.slice(0, 2));

            const valuesMap = {};
            existingValues.forEach(value => {
                valuesMap[value.medical_parameter_id] = value.value;
            });
            console.log('🗺️ Created valuesMap with keys:', Object.keys(valuesMap));

            console.log('📡 STEP 3: Merging parameters with values');
            const resultData = parameters.map(param => {
                const merged = {
                    medical_parameter_id: param.medical_parameter_id,
                    name: param.name,
                    unit: param.unit || '',
                    value: valuesMap[param.medical_parameter_id] || '',
                    value_type: param.value_type || 'text',
                    description: param.description || '',
                    options: param.options || []
                };
                return merged;
            });

            console.log(`✅ Successfully merged ${resultData.length} parameters`);
            console.log('📤 Response data sample:', resultData.slice(0, 2));
            console.log('🏁 ===== getParametersWithValues END =====');

            res.json({
                success: true,
                data: resultData
            });
        } catch (error) {
            console.error('❌ ERROR in getParametersWithValues:', error);
            console.error('Error stack:', error.stack);
            res.status(500).json({
                success: false,
                error: 'Error getting parameters with values: ' + error.message
            });
        }
    }

    async saveExamParameters(req, res) {
        try {
            const { patientsExamsId } = req.params;
            const { parameters } = req.body;

            if (!patientsExamsId || !parameters || !Array.isArray(parameters)) {
                return res.status(400).json({
                    success: false,
                    error: 'patientsExamsId and parameters array are required'
                });
            }

            for (const param of parameters) {
                await ParameterModel.saveParameterValue(
                    patientsExamsId,
                    param.medical_parameter_id,
                    param.value
                );
            }

            res.json({
                success: true,
                message: 'Parameters saved successfully'
            });
        } catch (error) {
            console.error('Error in saveExamParameters:', error);
            res.status(500).json({
                success: false,
                error: 'Error saving parameters'
            });
        }
    }
};

module.exports = new ParametersController();