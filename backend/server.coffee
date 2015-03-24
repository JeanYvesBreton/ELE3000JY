

Hapi = require("hapi")

server = new Hapi.Server()

server.connection
  host: 'localhost'
  port: 3000

server.route [
  {
    method: 'POST',
    path: '/system_data',
    handler: (request, reply) =>
      data = request.payload
      console.log data
  },
  {
    method: 'GET',
    path: '/',
    handler: (request, reply) =>
      reply 'GROW CONNECTED'

  }
]

server.start () =>
  console.log('Server running at:', server.info.uri)

module.exports = server;

