const db = require('../config/database');

class DiagnosticModel {

    static async findById(id) {
        const [rows] = await db.query(
            'SELECT * FROM diagnostic_test WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    static async findAll(page = 1, limit = 20) {
        const offset = (page - 1) * limit;

        const [rows] = await db.query(
            `SELECT * FROM diagnostic_test
             ORDER BY name ASC
             LIMIT ? OFFSET ?`,
            [limit, offset]
        );

        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM diagnostic_test'
        );

        return {
            data: rows,
            total: countResult[0].total,
            page,
            limit,
            totalPages: Math.ceil(countResult[0].total / limit)
        };
    }

    static async getAll() {
        const [rows] = await db.query(
            'SELECT * FROM diagnostic_test ORDER BY name ASC'
        );
        return rows;
    }

    static async findByType(type, page = 1, limit = 20) {
        const offset = (page - 1) * limit;

        const [rows] = await db.query(
            `SELECT * FROM diagnostic_test
             WHERE type = ?
             ORDER BY name ASC
             LIMIT ? OFFSET ?`,
            [type, limit, offset]
        );

        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM diagnostic_test WHERE type = ?',
            [type]
        );

        return {
            data: rows,
            total: countResult[0].total,
            page,
            limit,
            totalPages: Math.ceil(countResult[0].total / limit)
        };
    }

    static async search(query, page = 1, limit = 20) {
        const offset = (page - 1) * limit;
        const searchQuery = `%${query}%`;

        const [rows] = await db.query(
            `SELECT * FROM diagnostic_test
             (name LIKE ? OR description LIKE ? OR type LIKE ?)
             ORDER BY name ASC
             LIMIT ? OFFSET ?`,
            [searchQuery, searchQuery, searchQuery, limit, offset]
        );

        const [countResult] = await db.query(
            `SELECT COUNT(*) as total FROM diagnostic_test
             (name LIKE ? OR description LIKE ? OR type LIKE ?)`,
            [searchQuery, searchQuery, searchQuery]
        );

        return {
            data: rows,
            total: countResult[0].total,
            page,
            limit,
            totalPages: Math.ceil(countResult[0].total / limit)
        };
    }

    static async getTypes() {
        const [rows] = await db.query(
            'SELECT DISTINCT type, COUNT(*) as count FROM diagnostic_test GROUP BY type'
        );
        return rows;
    }
}

module.exports = DiagnosticModel;