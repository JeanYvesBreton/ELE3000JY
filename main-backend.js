
// Import coffee-script to use coffee-script files in backend
var __registerCoffeeScript = require("coffee-script/register");


var server = require(__dirname + "/backend/server.coffee");
server.start(function () {
  console.log('Server running at:', server.info.uri);
});
