
define([
  "angular",
  "ui-router",
  "n3-line-chart",
  "d3",
  "text!app/home.html"
], function (Angular, uiRouter, n3LineChart, d3, homeTemplate) {

  var ngmdApp = Angular.module("app", [
    "ui.router",
    "n3-line-chart",
    "d3"
  ]);


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

                $http.get('/temp1_graph_data').
                    success(function(data, status, headers, config) {
                        // this callback will be called asynchronously
                        // when the response is available
                        $scope.data = data.slave1.data;
                    }).
                    error(function(data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                        console.log('Error - GET on current_status, status: '+status);
                    });

                $scope.options = {
                    axes: {
                        x: {key: 'x', type: 'date'},
                        y: {type: 'linear'}
                    },
                    series: [
                        {y: 'value', color: 'steelblue', thickness: '2px', type: 'area', striped: true, label: 'Pouet'}
                    ],
                    tooltip: {
                        mode: 'scrubber'
                    },
                    drawDots: true,
                    columnsHGap: 5
                }
            }]
          }
        }
      });

  }]);


  return ngmdApp;

});
