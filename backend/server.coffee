

Hapi = require("hapi")

server = new Hapi.Server()
server.connection {port:3000}

server.route
  method: 'POST'
  path: '/system_data'
  handler: (request, reply) =>
    console.log JSON.parse(request.payload)
    

module.exports = server;
