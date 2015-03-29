# Require Hapi
Hapi = require("hapi")
# Require node.js file system
fs = require("fs")
# Require sqlite3
sqlite3 = require("sqlite3").verbose()

# Determine path of the file to use
file = __dirname + "/../db/test.db"
# Check if the file does exist
if !fs.existsSync(file)
  throw new Error "test.db file doesn't exist"

# Create new database instance
db = new sqlite3.Database(file)

# Create new server instance
server = new Hapi.Server()

server.connection
  host: '192.168.2.25'
  port: 8080

writeToDB = (msg) =>
  # Check if data field is empty
  if not (Object.keys(msg.data).length is 0)
    # Find the type of data
    if msg.data.hasOwnProperty('temp')
      db.serialize () =>
        stmt = db.prepare "INSERT INTO temp1 VALUES (?,?,?,?)"
        stmt.run "NULL", msg.data.temp.toString(), new Date().toString(), msg.id
        stmt.finalize()

      db.close()

server.route [
  {
    method: 'POST',
    path: '/system_data',
    handler: (request, reply) =>
      data = request.payload
      writeToDB data
      reply("Message was succesfully received.")
  },
  {
    method: 'GET',
    path: '/',
    handler: (request, reply) =>
      reply 'GROW CONNECTED'

  }
]

module.exports = server;

