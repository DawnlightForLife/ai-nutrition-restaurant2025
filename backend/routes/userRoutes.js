const express = require('express');
const router = express.Router();

const { loginUser, registerUser } = require('../controllers/userController');

// 登录
router.post('/login', loginUser);

// 注册
router.post('/register', registerUser);

module.exports = router;
