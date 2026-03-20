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
                patronymic: doctor.patronymic,
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

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            success: false,
            error: 'Токен не предоставлен'
        });
    }

    jwt.verify(token, process.env.ACCESS_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({
                success: false,
                error: 'Недействительный токен'
            });
        }
        req.user = user;
        next();
    });
};

app.put('/api/doctors/profile', authenticateToken, async (req, res) => {
    try {
        const doctorId = req.user.id;
        const {
            lastName, firstName, patronymic,
            email, phone, specializationId,
            password
        } = req.body;

        if (email) {
            const [existing] = await db.query(
                'SELECT doctor_id FROM doctors WHERE work_email = ? AND doctor_id != ?',
                [email, doctorId]
            );
            if (existing.length > 0) {
                return res.status(400).json({
                    success: false,
                    error: 'Этот email уже используется другим доктором'
                });
            }
        }

        let query = 'UPDATE doctors SET ';
        const params = [];
        const updates = [];

        if (lastName) {
            updates.push('last_name = ?');
            params.push(lastName);
        }
        if (firstName) {
            updates.push('first_name = ?');
            params.push(firstName);
        }
        if (patronymic !== undefined) {
            updates.push('patronymic = ?');
            params.push(patronymic || null);
        }
        if (email) {
            updates.push('work_email = ?');
            params.push(email);
        }
        if (phone) {
            updates.push('work_phone = ?');
            params.push(phone);
        }
        if (specializationId) {
            updates.push('specialization_id = ?');
            params.push(specializationId);
        }
        if (password) {
            const hashedPassword = await bcrypt.hash(password, 10);
            updates.push('password = ?');
            params.push(hashedPassword);
        }

        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                error: 'Нет данных для обновления'
            });
        }

        query += updates.join(', ');
        query += ' WHERE doctor_id = ?';
        params.push(doctorId);

        const [result] = await db.query(query, params);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Доктор не найден'
            });
        }

        const [updatedDoctor] = await db.query(
            `SELECT d.doctor_id, d.work_email as email,
                    d.first_name, d.last_name, d.patronymic,
                    d.work_phone as phone, s.name as specialization
             FROM doctors d
             LEFT JOIN specializations s ON d.specialization_id = s.specialization_id
             WHERE d.doctor_id = ?`,
            [doctorId]
        );

        const doctor = updatedDoctor[0];

        res.json({
            success: true,
            message: 'Профиль успешно обновлён',
            doctor: {
                id: doctor.doctor_id,
                email: doctor.email,
                firstName: doctor.first_name,
                lastName: doctor.last_name,
                patronymic: doctor.patronymic,
                phone: doctor.phone,
                specialization: doctor.specialization
            }
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при обновлении профиля'
        });
    }
});

app.get('/api/reminders/stats', authenticateToken, async (req, res) => {
    try {
        const doctorId = req.user.id;
        const today = new Date().toISOString().split('T')[0];

        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const tomorrowStr = tomorrow.toISOString().split('T')[0];

        const [todayRows] = await db.query(
            'SELECT COUNT(*) as count FROM reminders WHERE doctor_id = ? AND reminder_date = ? AND is_completed = FALSE',
            [doctorId, today]
        );

        const [tomorrowRows] = await db.query(
            'SELECT COUNT(*) as count FROM reminders WHERE doctor_id = ? AND reminder_date = ? AND is_completed = FALSE',
            [doctorId, tomorrowStr]
        );

        res.json({
            todayCount: todayRows[0].count,
            tomorrowCount: tomorrowRows[0].count,
            tomorrowDate: tomorrowStr
        });

    } catch (error) {
        res.status(500).json({
            error: 'Ошибка при получении статистики'
        });
    }
});

app.get('/api/reminders', authenticateToken, async (req, res) => {
    try {
        const doctorId = req.user.id;

        const [rows] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders
             WHERE doctor_id = ?
             ORDER BY reminder_date DESC, created_at DESC`,
            [doctorId]
        );

        res.json({
            success: true,
            data: rows
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при получении напоминаний'
        });
    }
});

app.get('/api/reminders/:id', authenticateToken, async (req, res) => {
    try {
        const reminderId = req.params.id;
        const doctorId = req.user.id;

        const [rows] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders
             WHERE reminder_id = ? AND doctor_id = ?`,
            [reminderId, doctorId]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Напоминание не найдено'
            });
        }

        res.json({
            success: true,
            data: rows[0]
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при получении напоминания'
        });
    }
});

app.put('/api/reminders/:id', authenticateToken, async (req, res) => {
    try {
        const reminderId = req.params.id;
        const doctorId = req.user.id;
        const { is_completed } = req.body;

        const [result] = await db.query(
            `UPDATE reminders
             SET is_completed = ?
             WHERE reminder_id = ? AND doctor_id = ?`,
            [is_completed, reminderId, doctorId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Напоминание не найдено'
            });
        }

        res.json({
            success: true,
            message: 'Напоминание обновлено'
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при обновлении напоминания'
        });
    }
});

app.delete('/api/reminders/:id', authenticateToken, async (req, res) => {
    try {
        const reminderId = req.params.id;
        const doctorId = req.user.id;

        const [result] = await db.query(
            'DELETE FROM reminders WHERE reminder_id = ? AND doctor_id = ?',
            [reminderId, doctorId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: 'Напоминание не найдено'
            });
        }

        res.json({
            success: true,
            message: 'Напоминание удалено'
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при удалении напоминания'
        });
    }
});

app.post('/api/reminders', authenticateToken, async (req, res) => {
    try {
        const doctorId = req.user.id;
        const { title, description, reminder_date } = req.body;

        if (!title || !reminder_date) {
            return res.status(400).json({
                success: false,
                error: 'Название и дата обязательны'
            });
        }

        const [result] = await db.query(
            `INSERT INTO reminders (doctor_id, title, description, reminder_date)
             VALUES (?, ?, ?, ?)`,
            [doctorId, title, description || null, reminder_date]
        );

        const [newReminder] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders WHERE reminder_id = ?`,
            [result.insertId]
        );

        res.status(201).json({
            success: true,
            data: newReminder[0]
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Ошибка при создании напоминания'
        });
    }
});

app.get('/api/parameters', authenticateToken, async (req, res) => {
  try {
    const examId = req.query.examId;

    if (!examId) {
      return res.status(400).json({
        success: false,
        error: 'Параметр examId обязателен'
      });
    }

    const [paramIdsResult] = await db.query(
      'SELECT medical_parameter_id FROM MedParamInExams WHERE exam_id = ?',
      [examId]
    );

    const paramIds = paramIdsResult.map(row => row.medical_parameter_id);

    if (paramIds.length === 0) {
      return res.json({
        success: true,
        data: []
      });
    }

    const [paramsResult] = await db.query(`
      SELECT
        mp.medical_parameter_id,
        mp.name,
        mp.value_type,
        mp.unit,
        mp.description
      FROM MedicalParameters mp
      WHERE mp.medical_parameter_id IN (?)
        AND NOT (
          mp.value_type = 'enum'
          AND NOT EXISTS (
            SELECT 1 FROM parametervalues pv
            WHERE pv.medical_parameter_id = mp.medical_parameter_id
          )
        )
    `, [paramIds]);

    let parameters = paramsResult;

    const enumParams = parameters.filter(param => param.value_type === 'enum');

    for (const param of enumParams) {
      const [optionsResult] = await db.query(
        'SELECT param_value, description FROM parametervalues WHERE medical_parameter_id = ? ORDER BY param_value',
        [param.medical_parameter_id]
      );

      param.options = optionsResult.map(row => row.param_value);
      param.optionDescriptions = optionsResult.map(row => row.description);
    }

    res.json({
      success: true,
      data: parameters
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Ошибка при получении параметров'
    });
  }
});