require('dotenv').config();
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD ? 'есть' : 'нет');
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();

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