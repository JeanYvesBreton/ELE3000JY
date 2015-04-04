
var del = require("del");


module.exports = function (gulp, plugins, paths) {

  gulp.task("client-clean", function (done) {

    del([
      paths.clientDeploy + "**/*"
    ], done);

  });


  gulp.task("client-install", function () {

    return plugins.bower();

  });


  gulp.task("client-deploy-tasks", [
    "client-css-deploy-dep",
    "client-css-deploy-bundle",
    "client-js-deploy-dep",
    "client-js-deploy-bundle"
  ]);


  gulp.task("client-deploy", [
    "client-clean",
    "client-install"
  ], function () {

    gulp.start("client-deploy-tasks");

  });


};
