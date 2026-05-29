const db = require('../config/database');

class ProtocolModel {
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

   static async searchProtocols(query, limit, offset) {

       const searchQuery = `%${query}%`;

       const sqlQuery = `
           SELECT
               ph.id as hierarchy_id,
               ph.protocol_document_id,
               ph.title as hierarchy_title,
               ph.level,
               ph.parent_id,
               ph.content,
               ph.sort_order,
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
             AND (
                 ph.title LIKE ?
                 OR pd.title LIKE ?
                 OR EXISTS (
                     SELECT 1
                     FROM protocol_hierarchy child
                     WHERE child.parent_id = ph.id
                       AND child.title LIKE ?
                 )
                 OR EXISTS (
                     SELECT 1
                     FROM protocol_hierarchy child
                     WHERE child.parent_id = ph.id
                       AND child.content LIKE ?
                 )
             )
           GROUP BY ph.id
           ORDER BY pd.adoption_date DESC, ph.sort_order
           LIMIT ? OFFSET ?
       `;

       const [rows] = await db.query(sqlQuery, [
           searchQuery,
           searchQuery,
           searchQuery,
           searchQuery,
           limit,
           offset
       ]);
       return rows;
   }

   static async searchProtocolsCount(query) {
       const searchQuery = `%${query}%`;

       const sqlQuery = `
           SELECT COUNT(DISTINCT ph.id) as total
           FROM protocol_hierarchy ph
           JOIN protocol_document pd ON ph.protocol_document_id = pd.id
           WHERE EXISTS (
                 SELECT 1
                 FROM protocol_hierarchy child
                 WHERE child.parent_id = ph.id
                   AND child.content IS NOT NULL
                   AND child.content != ''
             )
             AND (
                 ph.title LIKE ?
                 OR pd.title LIKE ?
                 OR EXISTS (
                     SELECT 1
                     FROM protocol_hierarchy child
                     WHERE child.parent_id = ph.id
                       AND child.title LIKE ?
                 )
                 OR EXISTS (
                     SELECT 1
                     FROM protocol_hierarchy child
                     WHERE child.parent_id = ph.id
                       AND child.content LIKE ?
                 )
             )
       `;

       const [result] = await db.query(sqlQuery, [searchQuery, searchQuery, searchQuery, searchQuery]);

       return result[0].total;
   }

   static async getProtocolsByMedicationId(medicationId, limit, offset) {

       const query = `
           SELECT
               ph.id as hierarchy_id,
               ph.protocol_document_id,
               ph.title as hierarchy_title,
               ph.level,
               ph.parent_id,
               ph.content,
               ph.sort_order,
               pd.title as protocol_title,
               pd.adoption_date,
               pm.id as medication_link_id,
               pm.pediatric_dose,
               pm.route,
               pm.frequency,
               pm.duration,
               pm.special_conditions
           FROM protocol_medication pm
           JOIN protocol_hierarchy ph ON ph.id = pm.protocol_hierarchy_id
           JOIN protocol_document pd ON pd.id = ph.protocol_document_id
           WHERE pm.medication_id = ?
           ORDER BY pd.adoption_date DESC, ph.sort_order
           LIMIT ? OFFSET ?
       `;

       const [rows] = await db.query(query, [medicationId, limit, offset]);

       return rows;
   }

   static async getProtocolsByMedicationIdCount(medicationId) {
       const query = `
           SELECT COUNT(DISTINCT ph.id) as total
           FROM protocol_medication pm
           JOIN protocol_hierarchy ph ON ph.id = pm.protocol_hierarchy_id
           WHERE pm.medication_id = ?
       `;

       const [result] = await db.query(query, [medicationId]);
       return result[0].total;
   }

   static async getProtocolsByDiagnosticId(diagnosticId, limit, offset) {
       const query = `
           SELECT
               ph.id as hierarchy_id,
               ph.protocol_document_id,
               ph.title as hierarchy_title,
               ph.level,
               ph.parent_id,
               ph.content,
               ph.sort_order,
               pd.title as protocol_title,
               pd.adoption_date,
               pd.id as protocol_document_id,
               pfd.id as diagnostic_link_id,
               pfd.requirement,
               pfd.frequency,
               pfd.special_conditions
           FROM protocol_diagnostic pfd
           JOIN protocol_hierarchy ph ON ph.id = pfd.protocol_hierarchy_id
           JOIN protocol_document pd ON pd.id = ph.protocol_document_id
           WHERE pfd.diagnostic_test_id = ?
           ORDER BY pd.adoption_date DESC, ph.sort_order
           LIMIT ? OFFSET ?
       `;

       const [rows] = await db.query(query, [diagnosticId, limit, offset]);

       return rows;
   }

   static async getProtocolsByDiagnosticIdCount(diagnosticId) {
       const query = `
           SELECT COUNT(DISTINCT ph.id) as total
           FROM protocol_diagnostic pfd
           JOIN protocol_hierarchy ph ON ph.id = pfd.protocol_hierarchy_id
           WHERE pfd.diagnostic_test_id = ?
       `;

       const [result] = await db.query(query, [diagnosticId]);
       return result[0].total;
   }

   static async getProtocolsByMkbId(mkbId, limit, offset) {

       const query = `
           SELECT
               ph.id as hierarchy_id,
               ph.protocol_document_id,
               ph.title as hierarchy_title,
               ph.level,
               ph.parent_id,
               ph.content,
               ph.sort_order,
               pd.title as protocol_title,
               pd.adoption_date,
               pml.id as mkb_link_id
           FROM protocol_mkb_link pml
           JOIN protocol_hierarchy ph ON ph.id = pml.protocol_hierarchy_id
           JOIN protocol_document pd ON pd.id = ph.protocol_document_id
           WHERE pml.mkb10_id = ?
           ORDER BY pd.adoption_date DESC, ph.sort_order
           LIMIT ? OFFSET ?
       `;

       const [rows] = await db.query(query, [mkbId, limit, offset]);

       return rows;
   }

   static async getProtocolsByMkbIdCount(mkbId) {
       const query = `
           SELECT COUNT(DISTINCT ph.id) as total
           FROM protocol_mkb_link pml
           JOIN protocol_hierarchy ph ON ph.id = pml.protocol_hierarchy_id
           WHERE pml.mkb10_id = ?
       `;

       const [result] = await db.query(query, [mkbId]);
       return result[0].total;
   }
}

module.exports = ProtocolModel;