
Hapi = require("hapi")
fs = require("fs")
sqlite3 = require("sqlite3").verbose()
handlebars = require("handlebars")


# Determine path of the file to use
file = __dirname + "/../db/test.db"
# Check if the file does exist
if !fs.existsSync(file)
  throw new Error "test.db file doesn't exist"

# Create new database instance
db = new sqlite3.Database(file)



server = new Hapi.Server()

server.connection
  #host: '192.168.2.25'
  port: 8080


server.views
  engines:
    html:
      module: handlebars
      compileMode: 'sync'
      isCached: false
  path: __dirname


server.route
  method: "GET"
  path: "/static/{param*}"
  handler:
    directory:
      path: __dirname + "/public/static"
      listing: false


# This function write to test.db the data directly
# received from the serial port whether it is
# an error or data specific to a sensor
writeToDB = (msg) =>
  # Check if data field is empty
  if not (Object.keys(msg.data).length is 0)
    # Find the type of data
    if msg.data.hasOwnProperty('temp')
      db.serialize () =>
        stmt = db.prepare "INSERT INTO temp1 VALUES (?,?,?,?)"
        stmt.run null, msg.data.temp.toString(), new Date().toString(), msg.id
        stmt.finalize()
  # Check if error field is empty
  if not (Object.keys(msg.error).length is 0)
    db.serialize () =>
      stmt = db.prepare "INSERT INTO error VALUES (?,?,?,?)"
      stmt.run null, msg.error.type, new Date().toString(), msg.id
      stmt.finalize()

# This function returns the last portrait of
# the slaves conditions with the time at which
# each data was received
readDBSystemStatus = (callback) =>
  # Define json structure
  currentstatus =
    slave1:
      data:
        temp1:
          value: ''
          time: ''
      last_error:
        value: ''
        time: ''
    slave2:
      data:
        temp1:
          value: ''
          time: ''
      last_error:
        value: ''
        time: ''

  # Fill the structure with db data
  db.serialize (callback) =>
    db.each "SELECT MAX(id) AS id, data, time, slave_id FROM temp1 WHERE slave_id = 1", (error, row) =>
      currentstatus.slave1.data.temp1.value = row.data
      currentstatus.slave1.data.temp1.time = row.time
    return callback(currentstatus)


server.route
  method: "GET"
  path: "/"
  handler: (request, reply) ->
    reply.view("index")

server.route
  method: 'GET'
  path: "/current_status"
  handler: (request, reply) =>
    readDBSystemStatus (currentstatus) =>
      reply currentstatus

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    data = request.payload
    writeToDB data
    reply("Message was succesfully received.")


module.exports = server;
