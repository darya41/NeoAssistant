const db = require('../config/database');

class TechLevelModel {
      static async getAllTechLevels() {
             const [rows] = await db.query(
                 'SELECT * FROM technological_level ORDER BY priority'
             );
             return rows;
         }

}

module.exports = TechLevelModel;