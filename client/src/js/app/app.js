
define([
  "angular",
  "ui-router",
  "n3-line-chart",
  "d3",
  "text!app/home.html"
], function (Angular, uiRouter, n3LineChart, d3, homeTemplate) {

  var ngmdApp = Angular.module("app", [
    "ui.router",
    "n3-line-chart"
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

                $http.get('/current_status')
                  .success(function(data, status, headers, config) {
                    // this callback will be called asynchronously
                    // when the response is available
                    $scope.message = data;
                  })
                  .error(function(data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                    console.log('Error - GET on current_status, status: '+status);
                  });

                $http.get('/temp1_graph_data')
                  .success(function(data, status, headers, config) {
                    // this callback will be called asynchronously
                    // when the response is available
                    // TODO: Separate concern in servide to isolate transformation logic
                    for (var i = 0, _len = data.slave1.data.length; i < _len; ++i) {
                      data.slave1.data[i].x = new Date(data.slave1.data[i].x);
                      data.slave1.data[i].value = parseInt(data.slave1.data[i].value);
                    }
                    for (var i = 0, _len = data.slave2.data.length; i < _len; ++i) {
                        data.slave2.data[i].x = new Date(data.slave2.data[i].x);
                        data.slave2.data[i].value = parseInt(data.slave2.data[i].value);
                    }
                    $scope.data1 = data.slave1.data;
                    $scope.data2 = data.slave2.data;
                  })
                  .error(function(data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                    console.log('Error - GET on current_status, status: '+status);
                  });

                $scope.temp1slave1 = {
                  axes: {
                    x: {
                      type: "date",
                      key: "x"
                    },
                    y: {
                      type: "linear"
                    }
                  },
                  series: [
                    {
                      y: "value",
                      color: "steelblue",
                      label: "Temp slave1",
                      lineMode: "dashed"
                    }
                  ],
                  tooltip: {
                    mode: "scrubber"
                  }
                };

                $scope.temp1slave2 = {
                  axes: {
                    x: {
                      type: "date",
                      key: "x"
                    },
                    y: {
                      type: "linear"
                    }
                  },
                  series: [
                    {
                      y: "value",
                      color: "#bcbd22",
                      label: "Temp slave2",
                      lineMode: "dashed"
                    }
                  ],
                  tooltip: {
                    mode: "scrubber"
                  }
                };

            }]
          }
        }
      });

  }]);


  return ngmdApp;

});
