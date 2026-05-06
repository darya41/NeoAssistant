const db = require('../config/database');

class MkbModel {

    static async findById(id) {
        const [rows] = await db.query(
            'SELECT * FROM mkb10 WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    static async findByCode(code) {
        const [rows] = await db.query(
            'SELECT * FROM mkb10 WHERE code = ?',
            [code]
        );
        return rows[0];
    }

    static async findByLevel(level) {
        const [rows] = await db.query(
            `SELECT * FROM mkb10
             WHERE level = ?
             ORDER BY code`,
            [level]
        );
        return rows;
    }

    static async findByParentCode(parentCode) {
        const [rows] = await db.query(
            `SELECT * FROM mkb10
             WHERE parent_code = ?
             ORDER BY code`,
            [parentCode]
        );
        return rows;
    }

    static async findAll(page = 1, limit = 100) {
        const offset = (page - 1) * limit;
        const [rows] = await db.query(
            `SELECT * FROM mkb10
             ORDER BY code
             LIMIT ? OFFSET ?`,
            [limit, offset]
        );

        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM mkb10 WHERE'
        );

        return {
            data: rows,
            total: countResult[0].total,
            page,
            limit,
            totalPages: Math.ceil(countResult[0].total / limit)
        };
    }

    static async getPath(code) {
        const path = [];
        let currentCode = code;

        while (currentCode) {
            const [rows] = await db.query(
                'SELECT * FROM mkb10 WHERE code = ?',
                [currentCode]
            );

            if (rows.length === 0) break;

            const current = rows[0];
            path.unshift(current);
            currentCode = current.parent_code;
        }

        return path;
    }

    static async search(query) {
        const [rows] = await db.query(
            `SELECT * FROM mkb10
            (code LIKE ? OR title LIKE ?)
             ORDER BY code
             LIMIT 50`,
            [`%${query}%`, `%${query}%`]
        );
        return rows;
    }

    static async getRootLevel() {
        const [rows] = await db.query(
            `SELECT * FROM mkb10
             WHERE level = 1
             ORDER BY code`
        );
        return rows;
    }

    static async getTree(parentCode = null) {
        let query = `
            SELECT * FROM mkb10
        `;
        const params = [];

        if (parentCode === null) {
            query += ` AND parent_code IS NULL AND level = 1`;
        } else {
            query += ` AND parent_code = ?`;
            params.push(parentCode);
        }

        query += ` ORDER BY code`;

        const [rows] = await db.query(query, params);

        for (const row of rows) {
            row.children = await this.getTree(row.code);
        }

        return rows;
    }

    static async getStats() {
        const [rows] = await db.query(
            `SELECT
                level,
                COUNT(*) as count
             FROM mkb10
             GROUP BY level
             ORDER BY level`
        );
        return rows;
    }
}

module.exports = MkbModel;