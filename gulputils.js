
var gulp = require("gulp"),
  gulpPlugins = require("gulp-load-plugins");


var paths = {
  clientVendors: __dirname + "/client/vendors/",
  clientSrc: __dirname + "/client/src/",
  clientBackendDeploy: __dirname + "/backend/public/static/"
};


// Function to load gulp files with split tasks (better split them gulp in smaller files)
var loadGulpFile = function (path) {
  (require(path))(gulp, gulpPlugins, paths);
};


// Load Gulp file tasks
loadGulpFile(__dirname + "/gulp/client-js.js");
