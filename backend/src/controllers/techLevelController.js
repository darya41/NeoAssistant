const DoctorModel = require('../models/doctor');
const TechLevelModel = require('../models/techLevel');

class TechLevelController {
    async getAllTechLevels(req, res) {
            try {
                const levels = await TechLevelModel.getAllTechLevels();

                res.status(200).json({
                    success: true,
                    data: levels
                });
            } catch (error) {
                console.error('Error in getAllTechLevels:', error);
                res.status(500).json({
                    success: false,
                    error: 'Error fetching tech levels: ' + error.message
                });
            }
        }

    async getMyTechLevel(req, res) {
        try {
            const doctorId = req.user?.id || req.user?.doctor_id;
            console.log('getMyTechLevel - doctorId:', doctorId);

            if (!doctorId) {
                return res.status(401).json({
                    success: false,
                    error: 'User not authenticated'
                });
            }

            const doctorTechLevel = await DoctorModel.getDoctorTechLevel(doctorId);
            console.log('getMyTechLevel - doctorTechLevel:', doctorTechLevel);

            const responseData = {
                tech_level_id: null,
                tech_level_name: null,
                priority: null
            };

            if (doctorTechLevel && doctorTechLevel.tech_level_id !== null) {
                responseData.tech_level_id = doctorTechLevel.tech_level_id;
                responseData.tech_level_name = doctorTechLevel.tech_level_name || '';
                responseData.priority = doctorTechLevel.priority || 0;
            }

            res.status(200).json({
                success: true,
                data: responseData
            });
        } catch (error) {
            console.error('Error in getMyTechLevel:', error);
            res.status(500).json({
                success: false,
                error: 'Error fetching doctor tech level: ' + error.message
            });
        }
    }

    async updateMyTechLevel(req, res) {
            try {
                const doctorId = req.user?.id || req.user?.doctor_id;

                if (!doctorId) {
                    return res.status(401).json({
                        success: false,
                        error: 'User not authenticated'
                    });
                }

                const { tech_level_id } = req.body;

                if (!tech_level_id) {
                    return res.status(400).json({
                        success: false,
                        error: 'tech_level_id is required'
                    });
                }

                const updated = await DoctorModel.updateDoctorTechLevel(doctorId, tech_level_id);

                if (!updated) {
                    return res.status(500).json({
                        success: false,
                        error: 'Failed to update tech level'
                    });
                }

                const doctorTechLevel = await DoctorModel.getDoctorTechLevel(doctorId);

                res.status(200).json({
                    success: true,
                    data: {
                        tech_level_id: doctorTechLevel?.tech_level_id,
                        tech_level_name: doctorTechLevel?.tech_level_name,
                        priority: doctorTechLevel?.priority
                    },
                    message: 'Tech level updated successfully'
                });
            } catch (error) {
                console.error('Error in updateMyTechLevel:', error);
                res.status(500).json({
                    success: false,
                    error: 'Error updating tech level: ' + error.message
                });
            }
        }

}

module.exports = new TechLevelController();