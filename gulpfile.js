
var gulp = require("gulp"),
  gulpPlugins = require("gulp-load-plugins")();


var paths = {
  clientVendors: __dirname + "/client/vendors/",
  clientSrc: __dirname + "/client/src/",
  clientDeploy: __dirname + "/backend/public/static/"
};


// Function to load gulp files with split tasks (better split them gulp in smaller files)
var loadGulpFile = function (path) {
  (require(path))(gulp, gulpPlugins, paths);
};


// Load Gulp file tasks
loadGulpFile(__dirname + "/gulp/client-js.js");
loadGulpFile(__dirname + "/gulp/client-css.js");
loadGulpFile(__dirname + "/gulp/client.js");


// Task for dev
gulp.task("default", [
  "client-css-deploy-bundle-watch",
  "client-js-deploy-bundle-watch"
], function (done) {

  var exec = require("child_process").exec,
    open = require("open");

  exec("node main-backend.js", function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);

    done(err);
  });

  // Wait for server to start to open URL (1 sec or so)
  setTimeout(function () {
    open("http://localhost:8080");
  }, 1000);

});
