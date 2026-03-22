const db = require('../config/database');

const createMother = async (req, res) => {
    console.log('POST /api/mothers');
    try {
        const { last_name, first_name, patronymic, date_of_birth, number_of_deliveries, number_of_pregnancies,
                medical_history, medications_during_pregnancy, gestational_diabetes, preeclampsia,
                groupb_streptococcus_status, address_id } = req.body;

        if (!last_name || !first_name || !date_of_birth) {
            return res.status(400).json({
                success: false,
                error: 'Last name, first name and date of birth are required'
            });
        }

        const [result] = await db.query(
            `INSERT INTO mothers (last_name, first_name, patronymic, date_of_birth, number_of_deliveries,
                number_of_pregnancies, medical_history, medications_during_pregnancy, gestational_diabetes,
                preeclampsia, groupb_streptococcus_status, address_id)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [last_name, first_name, patronymic || null, date_of_birth, number_of_deliveries ?? null,
             number_of_pregnancies ?? null, medical_history || null, medications_during_pregnancy || null,
             gestational_diabetes === true || gestational_diabetes === 1 ? 1 : 0,
             preeclampsia === true || preeclampsia === 1 ? 1 : 0,
             groupb_streptococcus_status || null, address_id || null]
        );

        const [newMother] = await db.query(
            `SELECT mother_id, last_name, first_name, patronymic, date_of_birth, number_of_deliveries,
                    number_of_pregnancies, medical_history, medications_during_pregnancy, gestational_diabetes,
                    preeclampsia, groupb_streptococcus_status, address_id
             FROM mothers WHERE mother_id = ?`,
            [result.insertId]
        );

        res.status(201).json({ success: true, data: newMother[0] });
    } catch (error) {
        console.error('Error creating mother:', error);
        res.status(500).json({ success: false, error: 'Error creating mother: ' + error.message });
    }
};

const getAllMothers = async (req, res) => {
    try {
        const [mothers] = await db.query(`
            SELECT m.*, a.city, a.street, a.house_number, a.building, a.apartment
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.address_id
            ORDER BY m.last_name, m.first_name
        `);
        res.json({ success: true, data: mothers });
    } catch (error) {
        console.error('Error getting mothers:', error);
        res.status(500).json({ success: false, error: 'Error getting mothers' });
    }
};

const getMotherById = async (req, res) => {
    try {
        const [mothers] = await db.query(`
            SELECT m.*, a.city, a.street, a.house_number, a.building, a.apartment
            FROM mothers m
            LEFT JOIN addresses a ON m.address_id = a.address_id
            WHERE m.mother_id = ?
        `, [req.params.id]);

        if (mothers.length === 0) {
            return res.status(404).json({ success: false, error: 'Mother not found' });
        }

        res.json({ success: true, data: mothers[0] });
    } catch (error) {
        console.error('Error getting mother:', error);
        res.status(500).json({ success: false, error: 'Error getting mother' });
    }
};

const updateMother = async (req, res) => {
    try {
        const motherId = req.params.id;
        const updates = [];
        const values = [];

        const fields = ['last_name', 'first_name', 'patronymic', 'date_of_birth', 'number_of_deliveries',
                        'number_of_pregnancies', 'medical_history', 'medications_during_pregnancy',
                        'gestational_diabetes', 'preeclampsia', 'groupb_streptococcus_status', 'address_id'];

        for (const field of fields) {
            if (req.body[field] !== undefined) {
                updates.push(`${field} = ?`);
                values.push(req.body[field]);
            }
        }

        if (updates.length === 0) {
            return res.status(400).json({ success: false, error: 'No data to update' });
        }

        values.push(motherId);
        const [result] = await db.query(
            `UPDATE mothers SET ${updates.join(', ')} WHERE mother_id = ?`,
            values
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: 'Mother not found' });
        }

        res.json({ success: true, message: 'Mother updated' });
    } catch (error) {
        console.error('Error updating mother:', error);
        res.status(500).json({ success: false, error: 'Error updating mother' });
    }
};

const deleteMother = async (req, res) => {
    try {
        const [result] = await db.query('DELETE FROM mothers WHERE mother_id = ?', [req.params.id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: 'Mother not found' });
        }

        res.json({ success: true, message: 'Mother deleted' });
    } catch (error) {
        console.error('Error deleting mother:', error);
        res.status(500).json({ success: false, error: 'Error deleting mother' });
    }
};

module.exports = { createMother, getAllMothers, getMotherById, updateMother, deleteMother };