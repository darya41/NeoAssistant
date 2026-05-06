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

    async getAllDiagnosticsNoPagination(req, res) {
        try {
            const diagnostics = await DiagnosticModel.getAll();

            res.status(200).json({
                success: true,
                data: diagnostics,
                count: diagnostics.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching diagnostics: ' + error.message
            });
        }
    }

    async getDiagnosticById(req, res) {
        try {
            const { id } = req.params;
            const diagnostic = await DiagnosticModel.findById(id);

            if (!diagnostic) {
                return res.status(404).json({
                    success: false,
                    error: 'Diagnostic test not found'
                });
            }

            res.status(200).json({
                success: true,
                data: diagnostic
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching diagnostic: ' + error.message
            });
        }
    }

    async getDiagnosticsByType(req, res) {
        try {
            const { type } = req.params;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const validTypes = ['лабораторный', 'инструментальный', 'функциональный', 'визуализационный'];
            if (!validTypes.includes(type)) {
                return res.status(400).json({
                    success: false,
                    error: `Invalid type. Must be one of: ${validTypes.join(', ')}`
                });
            }

            const result = await DiagnosticModel.findByType(type, page, limit);

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
                error: 'Error fetching diagnostics by type: ' + error.message
            });
        }
    }

    async searchDiagnostics(req, res) {
        try {
            const { q } = req.query;

            if (!q || q.trim().length < 2) {
                return res.status(400).json({
                    success: false,
                    error: 'Search query must be at least 2 characters'
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

    async getDiagnosticTypes(req, res) {
        try {
            const types = await DiagnosticModel.getTypes();

            res.status(200).json({
                success: true,
                data: types
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching diagnostic types: ' + error.message
            });
        }
    }
}

module.exports = new DiagnosticController();