
define([
  "angular",
  "text!app/home.html"
], function (Angular, homeTemplate) {

  var ngmdApp = Angular.module("app", []);

  ngmdApp.config([
    function () {
      console.log("Application module is configured.");
  }]);


  return ngmdApp;

});
