const express = require('express');
const db = require('../db');
const { verifyToken, isAdmin } = require('../middleware/auth');

const router = express.Router();

router.get('/pending-students', verifyToken, isAdmin, (req, res) => {
  const students = db.prepare(`
    SELECT id, name, email FROM users WHERE role = 'student' AND status = 'pending'
  `).all();
  res.json(students);
});

router.post('/approve-student/:id', verifyToken, isAdmin, (req, res) => {
  const { fees, type } = req.body;
  db.prepare(`UPDATE users SET status = 'active', fees = ?, type = ? WHERE id = ?`)
    .run(fees, type, req.params.id);
  res.json({ message: 'Student approved' });
});

module.exports = router;