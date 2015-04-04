
define([
  "angular",
  "text!app/home.html"
], function (Angular, homeTemplate) {

  var ngmdApp = Angular.module("app", []);

  ngmdApp.config([
    "$routeProvider",
    function ($routeProvider) {
      console.log("Application module is configured.");
  }]);


  return ngmdApp;

});
