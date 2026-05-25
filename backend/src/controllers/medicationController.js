const MedicationModel = require('../models/medication');

class MedicationController {

    async getAllMedications(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const result = await MedicationModel.findAll(page, limit);

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
                error: 'Error fetching medications: ' + error.message
            });
        }
    }

    async getMedicationsByDrugClass(req, res) {
        try {
            const { drugClass } = req.params;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const result = await MedicationModel.findByDrugClass(drugClass, page, limit);

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
                error: 'Error fetching medications by class: ' + error.message
            });
        }
    }

    async searchMedications(req, res) {
            try {
                const { q, page = 1, limit = 20 } = req.query;

                if (!q || q.trim().length < 1) {
                    return res.status(400).json({
                        success: false,
                        error: 'Search query must be at least 1 characters'
                    });
                }

                const parsedPage = parseInt(page) || 1;
                const parsedLimit = parseInt(limit) || 20;

                const results = await MedicationModel.search(q, parsedPage, parsedLimit);

                res.status(200).json({
                    success: true,
                    data: results.data,
                    pagination: {
                        currentPage: results.page,
                        limit: results.limit,
                        total: results.total,
                        totalPages: results.totalPages,
                        hasNext: results.page < results.totalPages
                    },
                    query: q
                });
            } catch (error) {
                console.error('[searchMedications] ERROR:', error.message);
                res.status(500).json({
                    success: false,
                    error: 'Error searching medications: ' + error.message
                });
            }
        }
}

module.exports = new MedicationController();