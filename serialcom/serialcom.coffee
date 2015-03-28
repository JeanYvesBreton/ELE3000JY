
serialport = require("serialport")
http = require("http")

#serialPort.list (err, ports) =>
#  ports.forEach (port) =>
#    console.log port.comName
#    console.log port.pnpId
#    console.log port.manufacturer

# Load settings
config = require(__dirname + "/../config.json")

postData = (data_string) =>
  # options object for http PUT resquest of system_data
  # headers['Content-Length'] will be set before sending data
  # because data length is not constant
  options =
    host: '192.168.2.25',
    port: 8080,
    path: '/system_data',
    method: 'POST',
    headers:
      'Content-Type': 'application/json',
      'Content-Length': data_string.length

  # Setup the request
  req = http.request options, (res) =>
    res.setEncoding 'utf-8'
    responseString = ''

    res.on 'data', (data) =>
      responseString += data

    res.on 'end', () =>
      console.log responseString

  # TODO: error handling
  req.on 'error', (error) =>
    console.log "Error on request: "
    console.log error

  req.write data_string, () =>
    req.end()


# Localize object constructor
SerialPort = serialport.SerialPort

# Instantiate a SerialPort object
# with baudrate and parser option
serialPort = new SerialPort(config["serial-device"], {
  baudrate: config["baudrate"]
  parser: serialport.parsers.readline("\n")
}, false)


# Open connection and listen to events
serialPort.open (err) =>
  # Check if it did not open
  if (err)
    console.log "serialcom - Error: Failed to open connection because \"#{err.message}\"."
    return

  console.log "Opened connection to serialport. \n"

  # Hook events on data
  serialPort.on "data", (data) =>
    # Sending data to server by http request
    console.log "serialcom - Following data was recieved \n"
    console.log data.toString("utf8")
    console.log "Sending it to server and waiting for reply...\n"
    postData data.toString("utf8")

