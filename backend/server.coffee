

Hapi = require("hapi")

server = new Hapi.server
server.connection {port:3000}

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    console.log request.data
    

module.exports = server;
