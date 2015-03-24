

Hapi = require("hapi")

server = new Hapi.Server()

server.connection
  host: 'localhost'
  port: 3000

server.route [
  {
    method: 'POST',
    path: '/system_data',
    handler: (request, response) =>
      data = request.payload
      console.log data
  },
  {
    method: 'GET',
    path: '/',
    handler: (request, response) =>
      reply 'GROW CONNECTED'

  }
]

module.exports = server;

