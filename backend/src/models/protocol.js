const db = require('../config/database');

class ProtocolModel {
    static async getAllProtocolDocuments() {
        const query = 'SELECT * FROM protocol_document WHERE status = "активный" ORDER BY adoption_date DESC';
        const [rows] = await db.query(query);
        return rows;
    }

   static async getProtocolListPaginated(limit, offset) {

       const query = `
           SELECT
               ph.id as hierarchy_id,
               ph.protocol_document_id,
               ph.title as hierarchy_title,
               ph.level,
               ph.parent_id,
               ph.content,
               pd.title as protocol_title,
               pd.adoption_date
           FROM protocol_hierarchy ph
           JOIN protocol_document pd ON ph.protocol_document_id = pd.id
           WHERE EXISTS (
                 SELECT 1
                 FROM protocol_hierarchy child
                 WHERE child.parent_id = ph.id
                   AND child.content IS NOT NULL
                   AND child.content != ''
             )
           ORDER BY pd.adoption_date DESC, ph.sort_order
           LIMIT ? OFFSET ?
       `;

       const [rows] = await db.query(query, [limit, offset]);

       return rows;
   }

   static async getProtocolListCount() {
      const query = `
           SELECT COUNT(*) as total
           FROM protocol_hierarchy ph
           WHERE ph.level = 2
             AND EXISTS (
                 SELECT 1
                 FROM protocol_hierarchy child
                 WHERE child.parent_id = ph.id
                   AND child.content IS NOT NULL
                   AND child.content != ''
             )
       `;

       const [rows] = await db.query(query);

       return rows[0].total;
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