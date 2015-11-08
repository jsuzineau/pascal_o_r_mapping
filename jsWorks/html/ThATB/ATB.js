(function() {
  'use strict';

   var m_ATB = angular.module('ATB', ['ngSanitize','adaptv.adaptStrap']);
   m_ATB.controller(
     'ctrl_ATB',
     function ($scope,$http)
       {
       $scope.root= {"Elements":[]};

       //provisoire, il faudrait avoir un nom par occurence
       $scope.NomFonction="ATB.json";

       $http.get($scope.NomFonction)
       .success
         (
         function(response)
           {
           $scope.root = response;
           }
         );

       //$scope.root = {"Nom": "ThAutomatic_ATB.sl","Elements":[{"id":"1","Selected":"0","id":"1","nProject":"1","Beginning":"12\/08\/2015 08:44:47","End":"12\/08\/2015 12:44:47","Description":"Client 1\r\nCompta client","nUser":"0"},{"id":"2","Selected":"0","id":"2","nProject":"0","Beginning":"20\/08\/2015 10:13:50","End":"20\/08\/2015 13:13:50","Description":"","nUser":"0"},{"id":"3","Selected":"0","id":"3","nProject":"0","Beginning":"20\/08\/2015 12:08:11","End":"20\/08\/2015 13:08:11","Description":"","nUser":"0"}]};

       // ========== ui handlers ========== //
       $scope.carSelected   // à revoir laissé pour exemple
       =
        function (car)
          {
          alert(car.name);
          };
       $scope.rowClicked    // à revoir laissé pour exemple
       =
        function (item, level, event)
          {
          event.stopPropagation();
          alert('row clicked' + item.name + '/' + level);
          };
       });
})();

