

#SerialPortLib = require("serialport").SerialPort
serialPort = require("serialport")


serialPort.list (err, ports) =>
  ports.forEach (port) =>
    console.log port.comName
    console.log port.pnpId
    console.log port.manufacturer
