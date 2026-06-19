const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');

const { verifyToken } = require('../middleware/auth');
const router = express.Router();

router.get('/me', verifyToken, (req, res) => {
  const user = db.prepare('SELECT id, name, role, status, type, fees FROM users WHERE id = ?').get(req.user.id);
  if (!user) return res.status(404).json({ message: 'User not found' });
  res.json({ user });
});

router.post('/signup', (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Sab fields zaruri hain' });
  }

  const existing = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
  if (existing) return res.status(400).json({ message: 'Email already registered' });

  const password_hash = bcrypt.hashSync(password, 10);

  db.prepare(`
    INSERT INTO users (name, email, password_hash, role, status)
    VALUES (?, ?, ?, 'student', 'pending')
  `).run(name, email, password_hash);

  res.json({ message: 'Signup successful, admin approval ka wait karo' });
});

router.post('/login', (req, res) => {
  const { email, password } = req.body;

  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user) return res.status(400).json({ message: 'User nahi mila' });

  const isMatch = bcrypt.compareSync(password, user.password_hash);
  if (!isMatch) return res.status(400).json({ message: 'Galat password' });

  const token = jwt.sign(
    { id: user.id, role: user.role, status: user.status },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );

  res.json({
    token,
    user: { id: user.id, name: user.name, role: user.role, status: user.status, type: user.type, fees: user.fees }
  });
});

module.exports = router;