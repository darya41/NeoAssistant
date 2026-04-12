const db = require('../config/database');

class CalculatorModel {
    // Получить все калькуляторы
    static async findAll() {
        const [rows] = await db.query(
            'SELECT * FROM calculators ORDER BY id'  // Убрал sort_order
        );
        return rows;
    }

    // Получить калькулятор по ID
    static async findById(id) {
        const [rows] = await db.query(
            'SELECT * FROM calculators WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    // Поиск калькуляторов
   static async search(query) {
           const [rows] = await db.query(
               `SELECT * FROM calculators
                WHERE LOWER(name) LIKE LOWER(?)
                   OR LOWER(description) LIKE LOWER(?)
                ORDER BY
                   CASE
                       WHEN LOWER(name) LIKE LOWER(?) THEN 1
                       ELSE 2
                   END,
                   id`,
               [`%${query}%`, `%${query}%`, `%${query}%`]
           );
           return rows;
       }

    // Получить калькуляторы по типу
    static async findByType(type) {
        const [rows] = await db.query(
            'SELECT * FROM calculators WHERE type = ? ORDER BY id',  // Убрал sort_order
            [type]
        );
        return rows;
    }
}

module.exports = CalculatorModel;