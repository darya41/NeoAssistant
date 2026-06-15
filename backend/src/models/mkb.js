const db = require('../config/database');

class MkbModel {
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

   static async search(query, page = 1, limit = 20) {
       const offset = (page - 1) * limit;
       const searchQuery = `%${query}%`;

       const [rows] = await db.query(
           `SELECT * FROM mkb10
            WHERE code LIKE ? OR title LIKE ?
            ORDER BY
              CASE
                WHEN code LIKE ? THEN 1
                WHEN title LIKE ? THEN 2
                ELSE 3
              END
            LIMIT ? OFFSET ?`,
           [searchQuery, searchQuery, `%${query}%`, `%${query}%`, limit, offset]
       );

       const [countResult] = await db.query(
           `SELECT COUNT(*) as total FROM mkb10
            WHERE code LIKE ? OR title LIKE ? `,
           [searchQuery, searchQuery]
       );

       const dataWithPath = await Promise.all(
           rows.map(async (row) => {
               const path = await MkbModel.getCategoryPath(row.code);
               return {
                   ...row,
                   path: path.map(p => ({ code: p.code, title: p.title }))
               };
           })
       );

       return {
           data: dataWithPath,
           total: countResult[0].total,
           page,
           limit,
           totalPages: Math.ceil(countResult[0].total / limit)
       };
   }
}

module.exports = MkbModel;