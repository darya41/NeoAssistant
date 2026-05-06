const db = require('../config/database');

class ReminderModel {

    static async getStats(doctorId) {
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

        return {
            todayCount: todayRows[0]?.count ?? 0,
            tomorrowCount: tomorrowRows[0]?.count ?? 0,
            tomorrowDate: tomorrowStr
        };
    }

    static async getRemindersByDays(doctorId, daysToShow = 0) {
        try {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const todayStr = today.toISOString().split('T')[0];

            const [allReminders] = await db.query(
                `SELECT
                  reminder_id,
                  title,
                  description,
                  DATE_FORMAT(reminder_date, '%Y-%m-%d') as reminder_date,
                  is_completed,
                  created_at
               FROM reminders
               WHERE doctor_id = ?
               ORDER BY reminder_date DESC`,
                [doctorId]
            );

            if (allReminders.length === 0) {
                return {
                    reminders: [],
                    totalReminders: 0,
                    currentDaysCount: 0,
                    hasMorePastDays: false,
                    totalPastDays: 0,
                    shownDays: []
                };
            }

            const grouped = {};
            for (const r of allReminders) {
                const date = r.reminder_date;
                if (!grouped[date]) grouped[date] = [];
                grouped[date].push(r);
            }

            let dates = Object.keys(grouped);
            dates.sort().reverse();

            const todayAndFutureDates = [];
            const pastDates = [];

            for (const date of dates) {
                if (date >= todayStr) {
                    todayAndFutureDates.push(date);
                } else {
                    pastDates.push(date);
                }
            }

            let selectedDates = [];
            let hasMore = false;

            if (todayAndFutureDates.length > 0) {
                selectedDates = [...todayAndFutureDates];

                if (daysToShow > 0 && pastDates.length > 0) {
                    const pastToAdd = pastDates.slice(0, daysToShow);
                    selectedDates.push(...pastToAdd);
                }

                hasMore = pastDates.length > (daysToShow > 0 ? daysToShow : 0);
            } else {
                const showDays = daysToShow > 0 ? daysToShow : 3;
                selectedDates = pastDates.slice(0, showDays);
                hasMore = showDays < pastDates.length;
            }

            const reminders = [];
            for (const date of selectedDates) {
                const dayReminders = grouped[date];
                if (dayReminders) {
                    console.log(`   📅 ${date}: ${dayReminders.length} reminders`);
                    reminders.push(...dayReminders);
                }
            }

            const result = {
                reminders: reminders,
                totalReminders: allReminders.length,
                currentDaysCount: todayAndFutureDates.length,
                hasMorePastDays: hasMore,
                totalPastDays: pastDates.length,
                shownDays: selectedDates
            };

            console.log('📊 Result:', {
                remindersCount: result.reminders.length,
                shownDaysCount: result.shownDays.length,
                hasMorePastDays: result.hasMorePastDays
            });

            return result;

        } catch (error) {
            throw error;
        }
    }

    static async getAllByDoctorId(doctorId) {
        const [rows] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders
             WHERE doctor_id = ?
             ORDER BY reminder_date DESC, created_at DESC`,
            [doctorId]
        );
        return rows;
    }

    static async findById(reminderId, doctorId) {
        const [rows] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders
             WHERE reminder_id = ? AND doctor_id = ?`,
            [reminderId, doctorId]
        );
        return rows[0];
    }

    static async create(reminderData) {
        const { doctorId, title, description, reminder_date } = reminderData;

        const [result] = await db.query(
            `INSERT INTO reminders (doctor_id, title, description, reminder_date)
             VALUES (?, ?, ?, ?)`,
            [doctorId, title, description || null, reminder_date]
        );
        return result.insertId;
    }

    static async findCreatedReminder(reminderId) {
        const [rows] = await db.query(
            `SELECT reminder_id, title, description, reminder_date, is_completed, created_at
             FROM reminders
             WHERE reminder_id = ?`,
            [reminderId]
        );
        return rows[0];
    }

    static async updateStatus(reminderId, doctorId, is_completed) {
        const [result] = await db.query(
            `UPDATE reminders
             SET is_completed = ?
             WHERE reminder_id = ? AND doctor_id = ?`,
            [is_completed, reminderId, doctorId]
        );
        return result.affectedRows;
    }

    static async update(reminderId, doctorId, updateData) {
        const { title, description, reminder_date, is_completed } = updateData;

        const updates = [];
        const params = [];

        if (title !== undefined) {
            updates.push('title = ?');
            params.push(title);
        }
        if (description !== undefined) {
            updates.push('description = ?');
            params.push(description);
        }
        if (reminder_date !== undefined) {
            updates.push('reminder_date = ?');
            params.push(reminder_date);
        }
        if (is_completed !== undefined) {
            updates.push('is_completed = ?');
            params.push(is_completed);
        }

        if (updates.length === 0) return 0;

        const query = `UPDATE reminders SET ${updates.join(', ')} WHERE reminder_id = ? AND doctor_id = ?`;
        params.push(reminderId, doctorId);

        const [result] = await db.query(query, params);
        return result.affectedRows;
    }

    static async delete(reminderId, doctorId) {
        const [result] = await db.query(
            'DELETE FROM reminders WHERE reminder_id = ? AND doctor_id = ?',
            [reminderId, doctorId]
        );
        return result.affectedRows;
    }

    static async exists(reminderId, doctorId) {
        const [rows] = await db.query(
            'SELECT 1 FROM reminders WHERE reminder_id = ? AND doctor_id = ? LIMIT 1',
            [reminderId, doctorId]
        );
        return rows.length > 0;
    }
}

module.exports = ReminderModel;