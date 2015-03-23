
#Hapi = require("hapi");
fork = require('child_process').fork

# Creating child with serialcom process
serialcom = fork(__dirname + '/../serialcom/serialcom.coffee', [silent: true])

# Simply log message on reception
serialcom.stdout.on 'data', (data) =>
  console.log('server - stdout: %s', data)