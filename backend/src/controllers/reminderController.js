const ReminderModel = require('../models/reminder');

class ReminderController {
    async getStats(req, res) {
        try {
            const doctorId = req.user.id;
            const stats = await ReminderModel.getStats(doctorId);
console.log('Stats from model:', stats);
           res.json({
                           todayCount: String(stats?.todayCount ?? 0),
                           tomorrowCount: String(stats?.tomorrowCount ?? 0),
                           tomorrowDate: stats?.tomorrowDate ?? ''
                       });


        } catch (error) {
           res.status(500).json({
                           todayCount: '0',
                           tomorrowCount: '0',
                           tomorrowDate: ''
                       });
        }
    }

    async getAll(req, res) {
        try {
            const doctorId = req.user.id;
            const reminders = await ReminderModel.getAllByDoctorId(doctorId);

            res.json({
                success: true,
                data: reminders
            });

        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка при получении напоминаний'
            });
        }
    }

    async getOne(req, res) {
        try {
            const reminderId = req.params.id;
            const doctorId = req.user.id;

            const reminder = await ReminderModel.findById(reminderId, doctorId);

            if (!reminder) {
                return res.status(404).json({
                    success: false,
                    error: 'Напоминание не найдено'
                });
            }

            res.json({
                success: true,
                data: reminder
            });

        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка при получении напоминания'
            });
        }
    }

    async create(req, res) {
        try {
            const doctorId = req.user.id;
            const { title, description, reminder_date } = req.body;

            if (!title || !reminder_date) {
                return res.status(400).json({
                    success: false,
                    error: 'Название и дата обязательны'
                });
            }

            const reminderId = await ReminderModel.create({
                doctorId,
                title,
                description,
                reminder_date
            });

            const newReminder = await ReminderModel.findCreatedReminder(reminderId);

            res.status(201).json({
                success: true,
                data: newReminder
            });

        } catch (error) {
            res.status(500).json({
                success: false,
                error: 'Ошибка при создании напоминания'
            });
        }
    }

    async update(req, res) {
        try {
            const reminderId = req.params.id;
            const doctorId = req.user.id;
            const { is_completed } = req.body;

            const exists = await ReminderModel.exists(reminderId, doctorId);

            if (!exists) {
                return res.status(404).json({
                    success: false,
                    error: 'Напоминание не найдено'
                });
            }
            const affectedRows = await ReminderModel.updateStatus(reminderId, doctorId, is_completed);

            if (affectedRows === 0) {
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
    }

    async delete(req, res) {
        try {
            const reminderId = req.params.id;
            const doctorId = req.user.id;

            const exists = await ReminderModel.exists(reminderId, doctorId);
            if (!exists) {
                return res.status(404).json({
                    success: false,
                    error: 'Напоминание не найдено'
                });
            }

            const affectedRows = await ReminderModel.delete(reminderId, doctorId);

            if (affectedRows === 0) {
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
    }
}

module.exports = new ReminderController();