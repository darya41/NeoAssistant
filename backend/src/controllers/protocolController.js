const ProtocolModel = require('../models/protocol');

class ProtocolController {
    async getProtocolListPaginated(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const offset = (page - 1) * limit;

            const rows = await ProtocolModel.getProtocolListPaginated(limit, offset);
            const total = await ProtocolModel.getProtocolListCount();

            const hasNext = offset + limit < total;

            res.status(200).json({
                success: true,
                data: rows,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    hasNext: hasNext
                }
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching paginated protocols: ' + error.message
            });
        }
    }

    async getProtocolHierarchy(req, res) {

        try {
            const { id } = req.params;
            const rows = await ProtocolModel.getProtocolHierarchy(id);

            const level3Count = rows.filter(r => r.level === 3).length;

            res.status(200).json({
                success: true,
                data: rows
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching hierarchy: ' + error.message
            });
        }
    }

    async getProtocolDocumentById(req, res) {

        try {
            const { id } = req.params;
            const protocol = await ProtocolModel.getProtocolDocumentById(id);

            if (!protocol) {
                return res.status(404).json({
                    success: false,
                    error: 'Protocol not found'
                });
            }

            res.status(200).json({
                success: true,
                data: protocol
            });
        } catch (error) {
            console.error('[getProtocolDocumentById] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error fetching protocol: ' + error.message
            });
        }
    }

    async getFullBranch(req, res) {
        try {
            const { id } = req.params;

            const mainItem = await ProtocolModel.getHierarchyItem(id);

            if (!mainItem) {
                return res.status(404).json({
                    success: false,
                    error: 'Item not found'
                });
            }

            const descendants = await ProtocolModel.getDescendants(id);

            const itemMap = {};

            mainItem.children = [];
            itemMap[mainItem.id] = mainItem;

            for (const child of descendants) {
                child.children = [];
                itemMap[child.id] = child;
            }

            for (const child of descendants) {
                const parent = itemMap[child.parent_id];
                if (parent) {
                    parent.children.push(child);
                }
            }

            res.status(200).json({
                success: true,
                data: mainItem
            });

        } catch (error) {
            console.error('[getFullBranch] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error fetching full branch: ' + error.message
            });
        }
    }

    async searchProtocols(req, res) {
        try {
            const { q } = req.query;

            if (!q || q.trim().length < 1) {
                return res.status(400).json({
                    success: false,
                    error: 'Search query must be at least 1 characters'
                });
            }

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const offset = (page - 1) * limit;

            const rows = await ProtocolModel.searchProtocols(q, limit, offset);
            const total = await ProtocolModel.searchProtocolsCount(q);

            const hasNext = offset + limit < total;

            res.status(200).json({
                success: true,
                data: rows,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    hasNext: hasNext
                },
                query: q
            });
        } catch (error) {
            console.error('[searchProtocols] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error searching protocols: ' + error.message
            });
        }
    }

    async getProtocolsByMedicationId(req, res) {
        try {
            const { medicationId } = req.params;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const offset = (page - 1) * limit;

            const rows = await ProtocolModel.getProtocolsByMedicationId(medicationId, limit, offset);
            const total = await ProtocolModel.getProtocolsByMedicationIdCount(medicationId);

            const hasNext = offset + limit < total;

            res.status(200).json({
                success: true,
                data: rows,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    hasNext: hasNext
                },
                medicationId: medicationId
            });
        } catch (error) {
            console.error('[getProtocolsByMedicationId] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols by medication: ' + error.message
            });
        }
    }

    async getProtocolsByDiagnosticId(req, res) {
        try {
            const { diagnosticId } = req.params;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const offset = (page - 1) * limit;

            const rows = await ProtocolModel.getProtocolsByDiagnosticId(diagnosticId, limit, offset);
            const total = await ProtocolModel.getProtocolsByDiagnosticIdCount(diagnosticId);

            const hasNext = offset + limit < total;

            res.status(200).json({
                success: true,
                data: rows,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    hasNext: hasNext
                },
                diagnosticId: diagnosticId
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols by diagnostic: ' + error.message
            });
        }
    }

    async getProtocolsByMkbId(req, res) {

        try {
            const { mkbId } = req.params;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;
            const offset = (page - 1) * limit;

            const rows = await ProtocolModel.getProtocolsByMkbId(mkbId, limit, offset);
            const total = await ProtocolModel.getProtocolsByMkbIdCount(mkbId);

            const hasNext = offset + limit < total;

            res.status(200).json({
                success: true,
                data: rows,
                pagination: {
                    currentPage: page,
                    limit: limit,
                    total: total,
                    hasNext: hasNext
                },
                mkbId: mkbId
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols by MKB: ' + error.message
            });
        }
    }
}

module.exports = new ProtocolController();