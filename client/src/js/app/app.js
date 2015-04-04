
define(["angular"], function (Angular) {

  var ngmdApp = Angular.module("app", []);

  ngmdApp.config([
    function () {
      console.log("Application module is configured.");
  }]);


  return ngmdApp;

});
