# Require node.js file system
fs = require("fs")
# Require sqlite3
sqlite3 = require("sqlite3").verbose()

# Determine path of the file to use
file = process.env.PATH + "/" + "test.db"
# Check if the file does exist
if !fs.existsSync(file)
  throw new Error "test.db file doesn't exist"
  
# Create new database from 
db = new sqlite3.Database(file)

db.serialize () =>
  db.run "CREATE TABLE slave (id INTEGER PRIMARY KEY, unit_name TEXT)"
  db.run "CREATE TABLE temp1 (id INTEGER PRIMARY KEY, FOREIGN KEY(slave_id) REFERENCES slave(id) NOT NULL, data TEXT, time TEXT)"
  
