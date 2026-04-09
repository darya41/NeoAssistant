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

    async getProtocolById(req, res) {
            try {
                const { id } = req.params;

                const protocol = await ProtocolModel.findById(id);

                if (!protocol) {
                    return res.status(404).json({
                        success: false,
                        error: 'Protocol not found'
                    });
                }

                res.status(200).json({
                    success: true,
                    data: protocol
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: 'Error fetching protocol: ' + error.message
                });
            }
        }
}

module.exports = new ProtocolController();