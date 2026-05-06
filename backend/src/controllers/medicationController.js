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

    async getAllMedicationsNoPagination(req, res) {
        try {
            const medications = await MedicationModel.getAll();

            res.status(200).json({
                success: true,
                data: medications,
                count: medications.length
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
            const { q } = req.query;

            if (!q || q.trim().length < 2) {
                return res.status(400).json({
                    success: false,
                    error: 'Search query must be at least 2 characters'
                });
            }

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const results = await MedicationModel.search(q, page, limit);

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
                error: 'Error searching medications: ' + error.message
            });
        }
    }

    async getDrugClasses(req, res) {
        try {
            const drugClasses = await MedicationModel.getDrugClasses();

            res.status(200).json({
                success: true,
                data: drugClasses
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching drug classes: ' + error.message
            });
        }
    }
}

module.exports = new MedicationController();