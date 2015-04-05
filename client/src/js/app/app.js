
define([
  "angular",
  "ui-router",
  "text!app/home.html"
], function (Angular, uiRouter, homeTemplate) {

  var ngmdApp = Angular.module("app", ["ui.router", "n3-line-chart"]);


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
              "$http",
              function ($scope, $http) {
                $http.get('/current_status').
                    success(function(data, status, headers, config) {
                        // this callback will be called asynchronously
                        // when the response is available
                        $scope.message = data;
                    }).
                    error(function(data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                        console.log('Error - GET on current_status, status: '+status);
                    });
            }]
          }
        }
      });

  }]);


  return ngmdApp;

});
