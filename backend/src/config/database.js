const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
}).promise();

pool.getConnection()
    .then(connection => {
        console.log('Подключено к MySQL');
        connection.release();
    })
    .catch(err => {
        console.error('Ошибка подключения к MySQL:', err.message);
        console.log('Сервер продолжит работу, но проверьте подключение к БД');
    });

module.exports = pool;