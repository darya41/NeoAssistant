const ProtocolModel = require('../models/protocol');

class ProtocolController {
    async getAllProtocolDocuments(req, res) {

        try {
            const rows = await ProtocolModel.getAllProtocolDocuments();

            res.status(200).json({
                success: true,
                data: rows
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols: ' + error.message
            });
        }
    }

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
}

module.exports = new ProtocolController();