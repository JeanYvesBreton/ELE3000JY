

Hapi = require("hapi")

server = new Hapi.Server()
server.connection {port:3000}

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    request.on 'data', (data) =>
      console.log data
    request.on 'end', (data) =>
      if data
        console.log data
      console.log "end of transmission"
    

module.exports = server;

