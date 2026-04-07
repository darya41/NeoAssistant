const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const AuthModel = require('../models/auth');

const AuthController = {
    async register(req, res) {
        try {
            const {
                email, password,
                last_name, first_name, middle_name,
                personal_phone, specialization_id
            } = req.body;

            const emailExists = await AuthModel.emailExists(email);
            if (existing.length > 0) {
                return res.status(400).json({
                    success: false,
                    error: 'Пользователь с таким email уже существует'
                });
            }

            const hashedPassword = await bcrypt.hash(password, 10);

            await AuthModel.createDoctor({
                email, hashedPassword,
                last_name, first_name, middle_name,
                personal_phone, specialization_id
            });

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
    },

    async login(req, res) {
        try {
            const { email, password } = req.body;

            const doctor = await AuthModel.findByEmail(email);

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

            await AuthModel.updateRefreshToken(doctor.doctor_id, refreshToken);

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
    },

    async refresh(req, res) {
        try {
            const { refreshToken } = req.body;

            if (!refreshToken) {
                return res.status(401).json({
                    success: false,
                    error: 'Refresh token не предоставлен'
                });
            }

            const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);

            const doctor = await AuthModel.findByRefreshToken(decoded.id, refreshToken);

            if (!doctor) {
                return res.status(401).json({
                    success: false,
                    error: 'Недействительный refresh token'
                });
            }

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

            await AuthModel.updateRefreshToken(doctor.doctor_id, newRefreshToken);

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
    }
};

module.exports = AuthController;