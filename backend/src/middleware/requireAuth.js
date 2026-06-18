const requireAuth = (req, res, next) => {
    if (req.user.isGuest) {
        return res.status(403).json({
            success: false,
            error: 'Доступ запрещён. Только для авторизованных пользователей.'
        });
    }
    next();
};

module.exports = { requireAuth };