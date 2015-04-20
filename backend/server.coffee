
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
  host: '192.168.2.26'
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
    if msg.data.hasOwnProperty('temp1')
      db.serialize () =>
        stmt = db.prepare "INSERT INTO temp1 VALUES (?,?,?,?)"
        stmt.run null, msg.data.temp1.toString(), new Date().toString(), msg.id
        stmt.finalize()
  # Check if error field is empty
  if not (Object.keys(msg.error).length is 0)
    # Find the cause of error
    if msg.data.hasOwnProperty('temp1')
      db.serialize () =>
        stmt = db.prepare "INSERT INTO error VALUES (?,?,?,?)"
        #if msg.error.type is ""
        #  stmt.run null, "temp1: Unknow error ", new Date().toString(), msg.id
        #else
        stmt.run null, "temp1: " + msg.error.type, new Date().toString(), msg.id
        #stmt.finalize()


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
  db.serialize () =>
    db.each "SELECT * FROM temp1 WHERE id = (SELECT MAX(id) from temp1 where slave_id = 1) UNION SELECT * FROM temp1 WHERE id = (SELECT MAX(id) from temp1 where slave_id = 2)",
    (error, row) =>
      # Check for error
      if error
        throw new Error error

      if row.slave_id is 1
        currentstatus.slave1.data.temp1.value = row.data
        currentstatus.slave1.data.temp1.time = row.time
      if row.slave_id is 2
        currentstatus.slave2.data.temp1.value = row.data
        currentstatus.slave2.data.temp1.time = row.time
    ,
    # This is the completion callback of the first db.each call
    () =>
      db.each "SELECT * FROM error WHERE id = (SELECT MAX(id) from error where slave_id = 1) UNION SELECT * FROM error WHERE id = (SELECT MAX(id) from error where slave_id = 2)",
      (error, row) =>
        # Check for error
        if error
          throw new Error error

        if row.slave_id is 1
          currentstatus.slave1.last_error.value = row.type
          currentstatus.slave1.last_error.time = row.time
        if row.slave_id is 2
          currentstatus.slave2.last_error.value = row.type
          currentstatus.slave2.last_error.time = row.time
      ,
      # This is the completion callback of the second db.each call
      # It returns the callback passed to readDBSystemStatus
      () =>
        callback currentstatus



readDBTemp1Data = (callback) =>
  # Define JSON structure
  temp1data =
    slave1:
      data: []
    slave2:
      data: []
  # Fill the structure
  db.serialize () =>
    # This will return the 10 most recent temp1 data in desc order
    db.each "SELECT * FROM temp1 WHERE slave_id = 1 ORDER BY id DESC LIMIT 10",
    (error, row) =>
      if error
        throw new Error error

      # unshift add an object to the beginning of the array
      temp1data.slave1.data.unshift
        x: row.time,
        value: row.data
    ,
    () =>
      db.each "SELECT * FROM temp1 WHERE slave_id = 2 ORDER BY id DESC LIMIT 10",
      (error, row) =>
        if error
          throw new Error error

        # unshift add an object to the beginning of the array
        temp1data.slave2.data.unshift
          x: row.time,
          value: row.data

      ,
      () =>
        callback temp1data



server.route
  method: "GET"
  path: "/"
  handler: (request, reply) ->
    reply.view("index")

# URL used to get last updated error and data
# for all slave units
server.route
  method: 'GET'
  path: "/current_status"
  handler: (request, reply) =>
    readDBSystemStatus (currentstatus) =>
      reply currentstatus

server.route
  method: 'GET'
  path: "/temp1_graph_data"
  handler: (request, reply) =>
    readDBTemp1Data (temp1data) =>
      reply temp1data

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    data = request.payload
    writeToDB data
    reply("Message was succesfully received.")


module.exports = server;
