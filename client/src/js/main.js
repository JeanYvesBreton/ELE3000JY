
require([
  "angular",
  "app/app"
], function (Angular, ngmdApp) {

  Angular.bootstrap(document, [ngmdApp.name]);

});
