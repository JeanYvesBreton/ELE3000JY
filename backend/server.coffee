console.log "Server script running"

#Hapi = require("hapi");
fork = require('child_process').fork

# Creating child with serialcom process
serialcom = fork(__dirname + '/../serialcom/serialcom.coffee')

# Simply log message on reception
serialcom.on 'message', (msg) =>
  console.log msg