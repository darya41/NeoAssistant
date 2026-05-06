const MkbModel = require('../models/mkb');

class MkbController {

    async getMkbById(req, res) {
        try {
            const { id } = req.params;

            const mkb = await MkbModel.findById(id);

            if (!mkb) {
                return res.status(404).json({
                    success: false,
                    error: 'MKB record not found'
                });
            }

            res.status(200).json({
                success: true,
                data: mkb
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching MKB record: ' + error.message
            });
        }
    }

    async getMkbByCode(req, res) {
        try {
            const { code } = req.params;

            const mkb = await MkbModel.findByCode(code);

            if (!mkb) {
                return res.status(404).json({
                    success: false,
                    error: 'MKB record not found'
                });
            }

            const path = await MkbModel.getPath(code);

            res.status(200).json({
                success: true,
                data: mkb,
                path: path
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching MKB record: ' + error.message
            });
        }
    }

    async getMkbByLevel(req, res) {
        try {
            const { level } = req.params;

            const mkbList = await MkbModel.findByLevel(parseInt(level));

            res.status(200).json({
                success: true,
                data: mkbList,
                count: mkbList.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching MKB records: ' + error.message
            });
        }
    }

    async getMkbByParentCode(req, res) {
        try {
            const { parentCode } = req.params;

            const children = await MkbModel.findByParentCode(parentCode);

            const parent = await MkbModel.findByCode(parentCode);

            res.status(200).json({
                success: true,
                data: children,
                parent: parent,
                count: children.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching children: ' + error.message
            });
        }
    }

    async getAllMkb(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 100;

            const result = await MkbModel.findAll(page, limit);

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
                error: 'Error fetching MKB records: ' + error.message
            });
        }
    }

    async getMkbPath(req, res) {
        try {
            const { code } = req.params;

            const path = await MkbModel.getPath(code);

            res.status(200).json({
                success: true,
                data: path
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching path: ' + error.message
            });
        }
    }

    async searchMkb(req, res) {
        try {
            const { q } = req.query;

            if (!q || q.trim().length < 2) {
                return res.status(400).json({
                    success: false,
                    error: 'Search query must be at least 2 characters'
                });
            }

            const results = await MkbModel.search(q);

            res.status(200).json({
                success: true,
                data: results,
                count: results.length,
                query: q
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error searching MKB: ' + error.message
            });
        }
    }

    async getRootLevel(req, res) {
        try {
            const rootLevel = await MkbModel.getRootLevel();

            res.status(200).json({
                success: true,
                data: rootLevel,
                count: rootLevel.length
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching root level: ' + error.message
            });
        }
    }

    async getTree(req, res) {
        try {
            const tree = await MkbModel.getTree();

            res.status(200).json({
                success: true,
                data: tree
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching tree: ' + error.message
            });
        }
    }

    async getStats(req, res) {
        try {
            const stats = await MkbModel.getStats();

            res.status(200).json({
                success: true,
                data: stats
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching stats: ' + error.message
            });
        }
    }
}

module.exports = new MkbController();