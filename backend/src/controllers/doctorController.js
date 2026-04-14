const bcrypt = require('bcrypt');
const db = require('../config/database');
const DoctorModel = require('../models/doctor');

class DoctorController {
    async updateProfile(req, res) {
        try {
            const doctorId = req.user.id;
            const {
                lastName, firstName, patronymic,
                email, phone, specializationId,
                password
            } = req.body;

            if (email) {
                const isTaken = await DoctorModel.isEmailTakenByOther(email, doctorId);
                if (isTaken) {
                    return res.status(400).json({
                        success: false,
                        error: 'Этот email уже используется другим доктором'
                    });
                }
            }

            let hashedPassword = null;
                   if (password) {
                       const bcrypt = require('bcrypt');
                       hashedPassword = await bcrypt.hash(password, 10);
                   }
            const affectedRows = await DoctorModel.updateProfile(doctorId, {
                lastName,
                firstName,
                patronymic,
                email,
                phone,
                specializationId,
                hashedPassword
            });
            if (affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    error: 'Доктор не найден или нет изменений'
                });
            }
            const doctor = await DoctorModel.findByIdWithSpecialization(doctorId);

            if (!doctor) {
                return res.status(404).json({
                    success: false,
                    error: 'Доктор не найден'
                });
            }

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
    }
}

module.exports = new DoctorController();