const db = require('../config/database');

class DiagnosticModel {

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

   static async search(query, page = 1, limit = 20) {
       const offset = (page - 1) * limit;
       const searchQuery = `%${query}%`;

       const [rows] = await db.query(
           `SELECT * FROM diagnostic_test
            WHERE (name LIKE ? OR description LIKE ? OR type LIKE ?)
            ORDER BY name ASC
            LIMIT ? OFFSET ?`,
           [searchQuery, searchQuery, searchQuery, limit, offset]
       );

       const [countResult] = await db.query(
           `SELECT COUNT(*) as total FROM diagnostic_test
            WHERE (name LIKE ? OR description LIKE ? OR type LIKE ?)`,
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
}

module.exports = DiagnosticModel;