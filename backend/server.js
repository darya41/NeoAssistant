require('dotenv').config();

const express = require('express');
const cors = require('cors');
const db = require('./src/config/database');

const { authenticateToken } = require('./src/middleware/auth');

const authRoutes = require('./src/routes/authRoutes');
const addressRoutes = require('./src/routes/addressRoutes');
const motherRoutes = require('./src/routes/motherRoutes');
const parametersRoutes = require('./src/routes/parametersRoutes');
const patientRoutes = require('./src/routes/patientRoutes');
const patientExamRoutes = require('./src/routes/patientExamRoutes');
const reminderRoutes = require('./src/routes/reminderRoutes');
const doctorRoutes = require('./src/routes/doctorRoutes');
const specializationRoutes = require('./src/routes/specializationRoutes');
const examTypeRoutes = require('./src/routes/examTypeRoutes');
const protocolRoutes = require('./src/routes/protocolRoutes');

const app = express();

app.use(cors());
app.use(express.json());

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

app.use('/api/auth', authRoutes);
app.use('/api/addresses', addressRoutes);
app.use('/api/mothers', motherRoutes);
app.use('/api/parameters', parametersRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/exams', patientExamRoutes);
app.use('/api/reminders', reminderRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/specializations', specializationRoutes);
app.use('/api/exam-types', examTypeRoutes);
app.use('/api/protocols', protocolRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\nСервер запущен на порту ${PORT}`);
    console.log(`База данных: ${process.env.DB_NAME}`);
    console.log(`http://localhost:${PORT}/api/health - проверить подключение\n`);
});