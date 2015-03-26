# Require node.js file system
fs = require("fs")
# Require sqlite3
sqlite3 = require("sqlite3").verbose()

# Determine path of the file to use
file = __dirname + "/test.db"
# Check if the file does exist
if !fs.existsSync(file)
  throw new Error "test.db file doesn't exist"
  
# Create new database from 
db = new sqlite3.Database(file)

db.serialize () =>
  db.run "CREATE TABLE slave (id INTEGER PRIMARY KEY, unit_name TEXT)"
  db.run "CREATE TABLE temp1 (id INTEGER PRIMARY KEY, data TEXT, time TEXT, slave_id INTEGER, FOREIGN KEY(slave_id) REFERENCES slave(id))"
  db.run "CREATE TABLE error (id INTEGER PRIMARY KEY, type TEXT, time TEXT, slave_id INTEGER, FOREIGN KEY(slave_id) REFERENCES slave(id))"
  console.log 'test.db has been created'
  console.log 'yeah'
db.close()
