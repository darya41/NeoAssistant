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
}

module.exports = ProtocolModel;