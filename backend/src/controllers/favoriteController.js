const FavoriteModel = require('../models/favorite');

class FavoriteController {
    async checkFavorite(req, res) {
        try {
            const doctorId = req.user.id;
            const { patientId } = req.params;

            const isFavorite = await FavoriteModel.isFavorite(doctorId, patientId);

            res.json({
                success: true,
                is_favorite: isFavorite
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка проверки избранного'
            });
        }
    }

    async addFavorite(req, res) {
        try {
            const doctorId = req.user.id;
            const { patient_id } = req.body;

            if (!patient_id) {
                return res.status(400).json({
                    success: false,
                    error: 'patient_id is required'
                });
            }

            const isFavorite = await FavoriteModel.isFavorite(doctorId, patient_id);
            if (isFavorite) {
                return res.status(400).json({
                    success: false,
                    error: 'Patient already in favorites'
                });
            }

            const favoriteId = await FavoriteModel.addFavorite(doctorId, patient_id);

            res.status(201).json({
                success: true,
                message: 'Patient added to favorites',
                data: {
                    id: favoriteId,
                    doctor_id: doctorId,
                    patient_id: patient_id
                }
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка добавления в избранное'
            });
        }
    }

    async removeFavorite(req, res) {
        try {
            const doctorId = req.user.id;
            const { patientId } = req.params;

            const affectedRows = await FavoriteModel.removeFavorite(doctorId, patientId);

            if (affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    error: 'Favorite not found'
                });
            }

            res.json({
                success: true,
                message: 'Patient removed from favorites'
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка удаления из избранного'
            });
        }
    }

     async getFavorites(req, res) {
            try {
                const doctorId = req.user.id;
                const favorites = await FavoriteModel.getFavoritesByDoctorId(doctorId);

                res.json({
                    success: true,
                    data: favorites
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: 'Ошибка получения избранного'
                });
            }
        }
}

module.exports = new FavoriteController();