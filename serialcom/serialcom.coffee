
# TODO: Change this to a command to list all peripherals
#serialPort = require("serialport")


#serialPort.list (err, ports) =>
#  ports.forEach (port) =>
#    console.log port.comName
#    console.log port.pnpId
#    console.log port.manufacturer


# Load settings
config = require(__dirname + "/../config.json")

# Require serialport librairy
serialport = require("serialport")
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
    console.log "!!!!!!!!!!!!!!!!!!!!!!"
    console.log "Error! Failed to open connection because \"#{err.message}\"."
    return

  console.log "Opened connection to serialport. \n"

  # Hook events on data
  serialPort.on "data", (data) =>
    console.log "==============="
    console.log "Data received!"
    console.log data.toString("utf8")
    # Send serial com port message to master
    process.send data.toString("utf8")

