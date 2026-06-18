const db = require('../config/database');
const CalculatorModel = require('../models/calculator');

class CalculatorController {

   async getAllCalculators(req, res) {
       try {
           const calculators = await CalculatorModel.findAll();

           res.status(200).json(calculators);
       } catch (error) {
           console.error('Error fetching calculators:', error);
           res.status(500).json({
               success: false,
               error: 'Error fetching calculators: ' + error.message
           });
       }
   }

    async getCalculatorById(req, res) {
        try {
            const { id } = req.params;

            const calculator = await CalculatorModel.findById(id);

            if (!calculator) {
                return res.status(404).json({
                    success: false,
                    error: 'Calculator not found'
                });
            }

            res.status(200).json({
                success: true,
                data: calculator
            });
        } catch (error) {
            console.error('Error fetching calculator:', error);
            res.status(500).json({
                success: false,
                error: 'Error fetching calculator: ' + error.message
            });
        }
    }

   async searchCalculators(req, res) {
       try {
           const { q } = req.query;

           if (!q || q.trim() === '') {
               const calculators = await CalculatorModel.findAll();
               return res.status(200).json({
                   success: true,
                   data: calculators
               });
           }

           const calculators = await CalculatorModel.search(q);

           res.status(200).json({
               success: true,
               data: calculators
           });
       } catch (error) {
           console.error('Error searching calculators:', error);
           res.status(500).json({
               success: false,
               error: 'Error searching calculators: ' + error.message
           });
       }
   }

    async getCalculatorsByType(req, res) {
        try {
            const { type } = req.params;

            const validTypes = ['formula', 'table', 'logical', 'calendar'];
            if (!validTypes.includes(type)) {
                return res.status(400).json({
                    success: false,
                    error: 'Invalid calculator type. Allowed: formula, table, logical, calendar'
                });
            }

            const calculators = await CalculatorModel.findByType(type);

            res.status(200).json({
                success: true,
                data: calculators
            });
        } catch (error) {
            console.error('Error fetching calculators by type:', error);
            res.status(500).json({
                success: false,
                error: 'Error fetching calculators by type: ' + error.message
            });
        }
    }
}

module.exports = new CalculatorController();