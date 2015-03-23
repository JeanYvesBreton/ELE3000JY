
Hapi = require("hapi")

server = new Hapi.server()
server.connection {port:8080}

server.route
  method: 'PUT'
  path: '/system_data'
  handler: (request, reply) =>
    console.log request.data


