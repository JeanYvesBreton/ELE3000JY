
define([
  "angular",
  "text!app/home.html"
], function (Angular, homeTemplate) {

  var ngmdApp = Angular.module("app", []);

  ngmdApp.config([
    "$routeProvider",
    function ($routeProvider) {
      $routeProvinder.
        when('/home', {
         template: homeTemplate
        }).
        otherwise({
         redirectTo: '/home'
        });
      console.log("Application module is configured.");
  }]);


  return ngmdApp;

});
