const db = require('../config/database');

class MedicationModel {

    static async findAll(page = 1, limit = 20) {
        const offset = (page - 1) * limit;

        const [rows] = await db.query(
            `SELECT * FROM medication
             ORDER BY inn ASC
             LIMIT ? OFFSET ?`,
            [limit, offset]
        );

        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM medication'
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
            'SELECT * FROM medication ORDER BY inn ASC'
        );
        return rows;
    }

    static async findByDrugClass(drugClass, page = 1, limit = 20) {
        const offset = (page - 1) * limit;

        const [rows] = await db.query(
            `SELECT * FROM medication
             WHERE drug_class = ?
             ORDER BY inn ASC
             LIMIT ? OFFSET ?`,
            [drugClass, limit, offset]
        );

        const [countResult] = await db.query(
            'SELECT COUNT(*) as total FROM medication WHERE drug_class = ?',
            [drugClass]
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
            `SELECT * FROM medication
             WHERE inn LIKE ?
                OR brand_name LIKE ?
                OR drug_class LIKE ?
                OR dosage_form LIKE ?
             ORDER BY inn ASC
             LIMIT ? OFFSET ?`,
            [searchQuery, searchQuery, searchQuery, searchQuery, limit, offset]
        );

        const [countResult] = await db.query(
            `SELECT COUNT(*) as total FROM medication
             WHERE inn LIKE ?
                OR brand_name LIKE ?
                OR drug_class LIKE ?
                OR dosage_form LIKE ?`,
            [searchQuery, searchQuery, searchQuery, searchQuery]
        );

        return {
            data: rows,
            total: countResult[0].total,
            page,
            limit,
            totalPages: Math.ceil(countResult[0].total / limit)
        };
    }


    static async getDrugClasses() {
        const [rows] = await db.query(
            'SELECT DISTINCT drug_class, COUNT(*) as count FROM medication WHERE drug_class IS NOT NULL GROUP BY drug_class ORDER BY drug_class'
        );
        return rows;
    }
}

module.exports = MedicationModel;