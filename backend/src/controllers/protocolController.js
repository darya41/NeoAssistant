const db = require('../config/database');
const ProtocolModel = require('../models/protocol');

class ProtocolController {

    async getAllProtocols(req, res) {
        try {
            const protocols = await ProtocolModel.findAll();

            res.status(200).json({
                success: true,
                data: protocols
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Error fetching protocols: ' + error.message
            });
        }
    }
}

module.exports = new ProtocolController();