
var rjs = require("requirejs");


module.exports = function (gulp, plugins, paths) {

  gulp.task("client-js-build", function (done) {

    rjs.optimize({
      baseUrl: paths.clientSrc + "js/",
      name: "main",
      paths: {
        // RequireJS Plugins
        "text": paths.clientVendors + "requirejs-text/text",

        // Libraries
        "lodash": paths.clientVendors + "lodash/lodash",
        "angular": paths.clientVendors = "angular/angular"
      },
      stubModules: [
        "text"
      ],
      optimize: "none",
      out: paths.clientBackendDeploy + "js/bundle.js"
    }, function () {
      done();
    }, function (err) {
      plugins.util.log(err);
      done();
    })

  });

};
