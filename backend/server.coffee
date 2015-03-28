

Hapi = require("hapi")

server = new Hapi.Server()

server.connection
  host: '192.168.2.25'
  port: 8080

server.route [
  {
    method: 'POST',
    path: '/system_data',
    handler: (request, reply) =>
      data = request.payload
      console.log data
      #reply("Message: " + data + " was succesfully received.")
  },
  {
    method: 'GET',
    path: '/',
    handler: (request, reply) =>
      reply 'GROW CONNECTED'

  }
]

module.exports = server;

