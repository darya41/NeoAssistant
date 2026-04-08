const SpecializationModel = require('../models/specialization');

class SpecializationController {
    async getAll(req, res) {
       try {
              const specializations = await SpecializationModel.getAll();
              if (!specializations || specializations.length === 0) {
                              console.log('No specializations found, returning empty array');
                              return res.json([]);
                          }
              res.json(specializations);
           } catch (error) {
               res.status(500).json({
                   success: false,
                   error: 'Ошибка загрузки специализаций'
               });
           }
    }
}

module.exports = new SpecializationController();