const DiagnosticModel = require('../models/diagnostic');

class DiagnosticController {

    async getAllDiagnostics(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const result = await DiagnosticModel.findAll(page, limit);

            res.status(200).json({
                success: true,
                data: result.data,
                pagination: {
                    page: result.page,
                    limit: result.limit,
                    total: result.total,
                    totalPages: result.totalPages
                }
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching diagnostics: ' + error.message
            });
        }
    }

    async searchDiagnostics(req, res) {
        try {
            const { q } = req.query;

            if (!q || q.trim().length < 1) {
                return res.status(200).json({
                    success: true,
                    data: [],
                    pagination: {
                        page: 1,
                        limit: 20,
                        total: 0,
                        totalPages: 0
                    },
                    query: q || ''
                });
            }

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const results = await DiagnosticModel.search(q, page, limit);

            res.status(200).json({
                success: true,
                data: results.data,
                pagination: {
                    page: results.page,
                    limit: results.limit,
                    total: results.total,
                    totalPages: results.totalPages
                },
                query: q
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error searching diagnostics: ' + error.message
            });
        }
    }
}

module.exports = new DiagnosticController();