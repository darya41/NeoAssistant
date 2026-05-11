const ProtocolModel = require('../models/protocol');

class ProtocolController {
    async getAllProtocolDocuments(req, res) {
        console.log('[getAllProtocolDocuments] START');
        console.log('[getAllProtocolDocuments] User ID:', req.user?.id || req.user?.doctor_id);

        try {
            const rows = await ProtocolModel.getAllProtocolDocuments();

            console.log('[getAllProtocolDocuments] Rows count:', rows.length);
            console.log('[getAllProtocolDocuments] First row (if exists):', rows[0] ? {
                id: rows[0].id,
                number: rows[0].number,
                title: rows[0].title?.substring(0, 50)
            } : 'No rows');

            res.status(200).json({
                success: true,
                data: rows
            });
            console.log('[getAllProtocolDocuments] SUCCESS');
        } catch (error) {
            console.error('[getAllProtocolDocuments] ERROR:', error.message);
            console.error('[getAllProtocolDocuments] Stack:', error.stack);
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols: ' + error.message
            });
        }
    }

    async getProtocolHierarchy(req, res) {
        console.log('[getProtocolHierarchy] START for protocol:', req.params.id);

        try {
            const { id } = req.params;
            const rows = await ProtocolModel.getProtocolHierarchy(id);

            const level3Count = rows.filter(r => r.level === 3).length;
            console.log('Found rows:', rows.length);
            console.log('Rows with level 3:', level3Count);

            res.status(200).json({
                success: true,
                data: rows
            });
            console.log('[getProtocolHierarchy] SUCCESS');
        } catch (error) {
            console.error('[getProtocolHierarchy] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error fetching hierarchy: ' + error.message
            });
        }
    }

    async getProtocolDocumentById(req, res) {
        console.log('[getProtocolDocumentById] START for id:', req.params.id);

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
            console.log('[getProtocolDocumentById] SUCCESS');
        } catch (error) {
            console.error('[getProtocolDocumentById] ERROR:', error.message);
            res.status(500).json({
                success: false,
                error: 'Error fetching protocol: ' + error.message
            });
        }
    }

    async getFullBranch(req, res) {
        console.log('[getFullBranch] START for item id:', req.params.id);

        try {
            const { id } = req.params;

            const mainItem = await ProtocolModel.getHierarchyItem(id);

            if (!mainItem) {
                return res.status(404).json({
                    success: false,
                    error: 'Item not found'
                });
            }

            console.log('Main item found:', {
                id: mainItem.id,
                title: mainItem.title,
                hasContent: !!mainItem.content,
                contentLength: mainItem.content?.length || 0
            });

            const descendants = await ProtocolModel.getDescendants(id);
            console.log('Descendants found:', descendants.length);

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

            console.log('Result item:', {
                id: mainItem.id,
                title: mainItem.title,
                contentLength: mainItem.content?.length || 0,
                childrenCount: mainItem.children.length
            });

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