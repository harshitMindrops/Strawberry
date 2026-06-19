const bcrypt = require('bcrypt');
const db = require('./db');

const password_hash = bcrypt.hashSync('strawberry123', 10);

db.prepare(`
  INSERT INTO users (name, email, password_hash, role, status)
  VALUES ('Admin', 'admin@gmail.com', ?, 'admin', 'active')
`).run(password_hash);

console.log('Admin created');