const db = require('../config/database');

class ProtocolModel {
    static async getAllProtocolDocuments() {
        const query = 'SELECT * FROM protocol_document WHERE status = "активный" ORDER BY adoption_date DESC';
        const [rows] = await db.query(query);
        return rows;
    }

    static async getProtocolHierarchy(protocolDocumentId) {
        const [rows] = await db.query(
            `SELECT * FROM protocol_hierarchy
             WHERE protocol_document_id = ?
             ORDER BY sort_order, id`,
            [protocolDocumentId]
        );
        return rows;
    }

    static async getProtocolDocumentById(protocolDocumentId) {
        const [rows] = await db.query(
            'SELECT * FROM protocol_document WHERE id = ?',
            [protocolDocumentId]
        );
        return rows[0];
    }

    static async getFullBranch(itemId) {
        const query = `
                WITH RECURSIVE hierarchy_cte AS (
                    SELECT
                        id,
                        protocol_document_id,
                        tech_level_id,
                        parent_id,
                        title,
                        level,
                        sort_order,
                        content,
                        created_at,
                        updated_at,
                        0 as depth
                    FROM protocol_hierarchy
                    WHERE id = ?

                    UNION ALL

                    SELECT
                        h.id,
                        h.protocol_document_id,
                        h.tech_level_id,
                        h.parent_id,
                        h.title,
                        h.level,
                        h.sort_order,
                        h.content,
                        h.created_at,
                        h.updated_at,
                        c.depth + 1
                    FROM protocol_hierarchy h
                    INNER JOIN hierarchy_cte c ON h.parent_id = c.id
                )
                SELECT * FROM hierarchy_cte ORDER BY depth, sort_order;
            `;

        const [rows] = await db.query(query, [itemId]);
        return rows;
    }

    static async getFullHierarchyItem(itemId) {
        const [rows] = await db.query(
            'SELECT * FROM protocol_hierarchy WHERE id = ?',
            [itemId]
        );
        return rows[0];
    }

    static async getDescendants(itemId) {
        const query = `
                WITH RECURSIVE descendants_cte AS (
                    SELECT * FROM protocol_hierarchy WHERE id = ?
                    UNION ALL
                    SELECT h.* FROM protocol_hierarchy h
                    INNER JOIN descendants_cte d ON h.parent_id = d.id
                )
                SELECT * FROM descendants_cte WHERE id != ? ORDER BY sort_order;
            `;

        const [rows] = await db.query(query, [itemId, itemId]);
        return rows;
    }
    static async getHierarchyItem(itemId) {
        const [rows] = await db.query(
            'SELECT * FROM protocol_hierarchy WHERE id = ?',
            [itemId]
        );
        return rows[0];
    }
}

module.exports = ProtocolModel;