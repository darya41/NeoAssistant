require('dotenv').config();
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD ? 'есть' : 'нет');
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();
const bcrypt = require('bcrypt');

const app = express();

app.use(cors());
app.use(express.json());

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
}).promise();

app.get('/api/health', async (req, res) => {
    try {
        await db.query('SELECT 1');
        res.json({
            status: 'Connected to MySQL',
            database: process.env.DB_NAME,
            host: process.env.DB_HOST
        });
    } catch (error) {
        res.status(500).json({
            status: 'Database error',
            error: error.message
        });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\nСервер запущен на порту ${PORT}`);
    console.log(`База данных: ${process.env.DB_NAME}`);
    console.log(`http://localhost:${PORT}/api/health - проверить подключение\n`);
});

app.get('/api/specializations', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT specialization_id, name, description FROM specializations ORDER BY name'
        );
        res.json(rows);
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка загрузки специализаций'
        });
    }
});

app.post('/api/auth/register', async (req, res) => {
    try {
        const {
            email, password,
            last_name, first_name, middle_name,
            personal_phone, specialization_id
        } = req.body;

        const [existing] = await db.query(
            'SELECT * FROM doctors WHERE work_email = ?',
            [email]
        );

        if (existing.length > 0) {
            return res.status(400).json({
                success: false,
                error: 'Пользователь с таким email уже существует'
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const [result] = await db.query(
            `INSERT INTO doctors
            (work_email, password,  last_name, first_name, patronymic, work_phone,  specialization_id)
            VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                email,
                hashedPassword,
                last_name,
                first_name,
                middle_name || null,
                personal_phone,
                specialization_id
            ]
        );

        res.status(201).json({
            success: true,
            message: 'Регистрация успешна'
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при регистрации'
        });
    }
});