const express = require('express');
const db = require('../db');
const { verifyToken, isAdmin } = require('../middleware/auth');

const router = express.Router();

router.get('/students', verifyToken, isAdmin, (req, res) => {
  const { type } = req.query;
  const students = db.prepare(`
    SELECT id, name FROM users 
    WHERE role = 'student' AND status = 'active' AND (type = ? OR type = 'both')
  `).all(type);
  res.json(students);
});

router.get('/by-date', verifyToken, isAdmin, (req, res) => {
  const { date, type } = req.query;
  const students = db.prepare(`
    SELECT u.id, u.name, a.status
    FROM users u
    LEFT JOIN attendance a ON a.student_id = u.id AND a.date = ?
    WHERE u.role = 'student' AND u.status = 'active' AND (u.type = ? OR u.type = 'both')
  `).all(date, type);
  res.json(students);
});

router.post('/mark', verifyToken, isAdmin, (req, res) => {
  const { date, records } = req.body;
  const stmt = db.prepare(`
    INSERT INTO attendance (student_id, date, status)
    VALUES (?, ?, ?)
    ON CONFLICT(student_id, date) DO UPDATE SET status = excluded.status
  `);
  for (const r of records) stmt.run(r.student_id, date, r.status);
  res.json({ message: 'Attendance marked' });
});

// yeh generic route hamesha sabse last mein rahe
router.get('/:studentId', verifyToken, (req, res) => {
  const { studentId } = req.params;
  if (req.user.role !== 'admin' && req.user.id !== parseInt(studentId)) {
    return res.status(403).json({ message: 'Access denied' });
  }
  const records = db.prepare(`SELECT date, status FROM attendance WHERE student_id = ? ORDER BY date DESC`).all(studentId);
  res.json(records);
});

module.exports = router;