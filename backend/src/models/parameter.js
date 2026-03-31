const db = require('../config/database');

class ParameterModel {
    static async getParametersByExamId(examId) {
        const [paramIdsResult] = await db.query(
            'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
            [examId]
        );

        const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

        if (paramIds.length === 0) {
            return [];
        }

        const [paramsResult] = await db.query(`
            SELECT
                mp.medical_parameter_id,
                mp.name,
                mp.value_type,
                mp.unit,
                mp.description
            FROM MedicalParameters mp
            WHERE mp.medical_parameter_id IN (?)
                AND NOT (
                    mp.value_type = 'enum'
                    AND NOT EXISTS (
                        SELECT 1 FROM parametervalues pv
                        WHERE pv.medical_parameter_id = mp.medical_parameter_id
                    )
                )
        `, [paramIds]);

        const parameters = paramsResult;
        const enumParams = parameters.filter(param => param.value_type === 'enum');

        for (const param of enumParams) {
            const [optionsResult] = await db.query(
                'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
                [param.medical_parameter_id]
            );
            param.options = optionsResult.map(row => row.param_value);
            param.optionDescriptions = optionsResult.map(row => row.description);
        }

        return parameters;
    }
}

module.exports = ParameterModel;