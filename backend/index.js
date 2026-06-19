require('dotenv').config();
const express = require('express');
const cors = require('cors');
require('./db'); // db.js run hote hi tables create ho jayenge

const app = express();
app.use(cors());
app.use(express.json());

const authRoutes = require('./routes/auth');
const adminRoutes = require('./routes/admin');

const attendanceRoutes = require('./routes/attendance');
app.use('/attendance', attendanceRoutes);

app.use('/auth', authRoutes);
app.use('/admin', adminRoutes);

app.get('/', (req, res) => {
  res.send('Server chal raha hai');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));