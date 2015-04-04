
module.exports = function (gulp, plugins, paths) {

  gulp.task("client-css-deploy-dep-bootstrap-map", function () {

    return gulp.src([
      paths.clientVendors + "bootstrap/dist/css/bootstrap.css.map"
    ])
      .pipe(gulp.dest(paths.clientDeploy + "css/"));

  });


  gulp.task("client-css-deploy-dep", [
    "client-css-deploy-dep-bootstrap-map"
  ]);


  gulp.task("client-css-deploy-dep-watch", [
    "client-css-deploy-dep"
  ], function () {

    gulp.watch(paths.clientVendors, ["client-css-deploy-dep"]);

  });



  gulp.task("client-css-deploy-bundle", function () {

    return gulp.src([
      paths.clientVendors + "bootstrap/dist/css/bootstrap.css",
      paths.clientSrc + "css/main.css"
    ], { base: "." })
      .pipe(plugins.order([
        paths.clientVendors + "bootstrap/dist/css/bootstrap.css",
        paths.clientSrc + "css/main.css"
      ], { base: "." }))
      .pipe(plugins.concat("bundle.css"))
      .pipe(gulp.dest(paths.clientDeploy + "css/"));

  });


  gulp.task("client-css-deploy-bundle-watch", [
    "client-css-deploy-bundle"
  ], function () {

    gulp.watch(paths.clientSrc + "css/**/*.css", ["client-css-deploy-bundle"]);

  });

};
