const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token === 'guest_token') {
        req.user = {
            id: 0,
            isGuest: true
        };
        return next();
    }
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
        req.user.isGuest = false;
        next();
    });
};

module.exports = { authenticateToken };