
var rjs = require("requirejs");


module.exports = function (gulp, plugins, paths) {

  gulp.task("client-js-deploy-dep-rjs", function () {

    return gulp.src(paths.clientVendors + "requirejs/require.js")
      .pipe(gulp.dest(paths.clientDeploy + "js/"));

  });


  gulp.task("client-js-deploy-dep-rjs-watch", [
    "client-js-deploy-dep-rjs"
  ], function () {

    gulp.watch(paths.clientVendors, ["client-js-deploy-dep-rjs"]);

  });


  gulp.task("client-js-deploy-dep", [
    "client-js-deploy-dep-rjs"
  ]);


  gulp.task("client-js-deploy-dep-watch", [
    "client-js-deploy-dep-rjs-watch"
  ]);




  gulp.task("client-js-deploy-bundle", function (done) {

    rjs.optimize({
      baseUrl: paths.clientSrc + "js/",
      name: "main",
      paths: {
        // RequireJS Plugins
        "text": paths.clientVendors + "requirejs-text/text",

        // Libraries
        "lodash": paths.clientVendors + "lodash/lodash",
        "angular": paths.clientVendors + "angular/angular",
        "ui-router": paths.clientVendors + "ui-router/release/angular-ui-router",
        "n3-line-chart": paths.clientVendors + "n3-line-chart/build/line-chart"
      },
      shim: {
        "angular": {
          exports: "angular"
        }
      },
      stubModules: [
        "text"
      ],
      optimize: "none",
      out: paths.clientDeploy + "js/bundle.js"
    }, function (buildResponse) {
      plugins.util.log(buildResponse);
      done();
    }, function (err) {
      plugins.util.log(err);
      done();
    });

  });


  gulp.task("client-js-deploy-bundle-watch", [
    "client-js-deploy-bundle"
  ], function () {

    gulp.watch(paths.clientVendors, ["client-js-deploy-bundle"]);

    gulp.watch(paths.clientSrc + "js/**/*", ["client-js-deploy-bundle"]);

  });

};
