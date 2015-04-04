
define([
  "angular",
  "ui-router",
  "text!app/home.html"
], function (Angular, uiRouter, homeTemplate) {

  var ngmdApp = Angular.module("app", ["ui.router"]);


  ngmdApp.config([
    "$stateProvider",
    function ($stateProvider) {

      $stateProvider.state("root", {
        url: "",
        views: {
          "content-view": {
            template: homeTemplate,
            controller: [
              "$scope",
              function ($scope) {
                $scope.message = {data: 'YAY'};
            }]
          }
        }
      });

  }]);


  return ngmdApp;

});
