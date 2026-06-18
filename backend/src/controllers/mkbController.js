const MkbModel = require('../models/mkb');

class MkbController {

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

            if (!q || q.trim().length < 1) {
                return res.status(200).json({
                    success: true,
                    data: [],
                    pagination: { page: 1, limit: 20, total: 0, totalPages: 0 }
                });
            }

            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 20;

            const results = await MkbModel.search(q, page, limit);

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
            console.error('Search MKB error:', error);
            res.status(500).json({
                success: false,
                error: 'Error searching MKB: ' + error.message
            });
        }
    }
}

module.exports = new MkbController();