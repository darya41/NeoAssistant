require('dotenv').config();
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD ? 'есть' : 'нет');
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

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

app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        console.log('Попытка входа:', { email });


        const [doctors] = await db.query(
            `SELECT d.*, s.name as specialization_name
             FROM doctors d
             LEFT JOIN specializations s ON d.specialization_id = s.specialization_id
             WHERE d.work_email = ?`,
            [email]
        );

        const doctor = doctors[0];

        if (!doctor) {
            return res.status(401).json({
                success: false,
                error: 'Неверный email или пароль'
            });
        }

        const validPassword = await bcrypt.compare(password, doctor.password);

        if (!validPassword) {
            return res.status(401).json({
                success: false,
                error: 'Неверный email или пароль'
            });
        }

        const accessToken = jwt.sign(
            {
                id: doctor.doctor_id,
                email: doctor.email,
                name: doctor.full_name
            },
            process.env.ACCESS_SECRET,
            { expiresIn: '15m' }
        );

        const refreshToken = jwt.sign(
            { id: doctor.doctor_id },
            process.env.REFRESH_SECRET,
            { expiresIn: '7d' }
        );

        await db.query(
            'UPDATE doctors SET refresh_token = ? WHERE doctor_id = ?',
            [refreshToken, doctor.doctor_id]
        );

        res.json({
            success: true,
            accessToken,
            refreshToken,
            doctor: {
                id: doctor.doctor_id,
                email: doctor.work_email,
                firstName: doctor.first_name,
                lastName: doctor.last_name,
                : doctor.patronymic,
                phone: doctor.work_phone,
                specialization: doctor.specialization_name
            }
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при входе'
        });
    }
});

app.post('/api/auth/refresh', async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(401).json({
                success: false,
                error: 'Refresh token не предоставлен'
            });
        }

        const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);

        const [doctors] = await db.query(
            'SELECT * FROM doctors WHERE doctor_id = ? AND refresh_token = ?',
            [decoded.id, refreshToken]
        );

        if (doctors.length === 0) {
            return res.status(401).json({
                success: false,
                error: 'Недействительный refresh token'
            });
        }

        const doctor = doctors[0];

        const newAccessToken = jwt.sign(
            {
                id: doctor.doctor_id,
                email: doctor.work_email,
                firstName: doctor.first_name,
                lastName: doctor.last_name,
                patronymic: doctor.patronymic
            },
            process.env.ACCESS_SECRET,
            { expiresIn: '15m' }
        );

        const newRefreshToken = jwt.sign(
            { id: doctor.doctor_id },
            process.env.REFRESH_SECRET,
            { expiresIn: '7d' }
        );

        await db.query(
            'UPDATE doctors SET refresh_token = ? WHERE doctor_id = ?',
            [newRefreshToken, doctor.doctor_id]
        );

        res.json({
            success: true,
            accessToken: newAccessToken,
            refreshToken: newRefreshToken
        });

    } catch (error) {
        res.status(401).json({
            success: false,
            error: 'Недействительный refresh token'
        });
    }
});
