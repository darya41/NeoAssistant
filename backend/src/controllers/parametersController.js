const db = require('../config/database');

const getParameters = async (req, res) => {
    try {
        const examId = req.query.examId;

        if (!examId) {
            return res.status(400).json({
                success: false,
                error: 'examId parameter is required'
            });
        }

        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

        if (paramIds.length === 0) {
            return res.json({ success: true, data: [] });
        }

        const [paramsResult] = await db.query(`
            SELECT mp.medical_parameter_id, mp.name, mp.value_type, mp.unit, mp.description
            FROM MedicalParameters mp
            WHERE mp.medical_parameter_id IN (?)
        `, [paramIds]);

        let parameters = paramsResult;

        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );

            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        res.json({ success: true, data: parameters });
    } catch (error) {
        console.error('Error getting parameters:', error);
        res.status(500).json({ success: false, error: 'Error getting parameters' });
    }
};

const getAllParameters = async (req, res) => {
    try {
        const [parameters] = await db.query(`
            SELECT mp.medical_parameter_id, mp.name, mp.value_type, mp.unit, mp.description
            FROM MedicalParameters mp
            ORDER BY mp.name
        `);

        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );

            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        res.json({ success: true, data: parameters });
    } catch (error) {
        console.error('Error getting all parameters:', error);
        res.status(500).json({ success: false, error: 'Error getting parameters' });
    }
};

module.exports = { getParameters, getAllParameters };