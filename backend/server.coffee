

Hapi = require("hapi")

server = new Hapi.Server()
server.connection {port:3000}

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    console.log request.payload.toString('utf8')
    

module.exports = server;
