(function() {
  'use strict';

   var m_AUT = angular.module('AUT', ['ui.tree']);
   m_AUT.controller(
     'ctrl_AUT',
     function ($scope,$http)
       {
         $scope.remove = function (scope) {
           scope.remove();
         };

         $scope.toggle = function (scope) {
           scope.toggle();
         };

         $scope.moveLastToTheBeginning = function () {
           var a = $scope.data.pop();
           $scope.data.splice(0, 0, a);
         };

         $scope.newSubItem = function (scope) {
           var nodeData = scope.$modelValue;
           nodeData.nodes.push({
             id: nodeData.id * 10 + nodeData.nodes.length,
             title: nodeData.title + '.' + (nodeData.nodes.length + 1),
             nodes: []
           });
         };

         $scope.collapseAll = function () {
           $scope.$broadcast('collapseAll');
         };

         $scope.expandAll = function () {
           $scope.$broadcast('expandAll');
         };

       //provisoire, il faudrait avoir un nom par occurence
       $scope.NomFonction="AUT.json";

       $scope.root={};
       //$scope.root= {"Elements":[{"id":1},{"id":2},{"id":3}]};

       $http.get($scope.NomFonction)
       .success
         (
         function(response)
           {
           $scope.root = response;
           }
         );

       //$scope.root = {"Nom": "ThAutomatic_AUT.sl","Elements":[{"id":"1","Selected":"0","id":"1","nProject":"1","Beginning":"12\/08\/2015 08:44:47","End":"12\/08\/2015 12:44:47","Description":"Client 1\r\nCompta client","nUser":"0"},{"id":"2","Selected":"0","id":"2","nProject":"0","Beginning":"20\/08\/2015 10:13:50","End":"20\/08\/2015 13:13:50","Description":"","nUser":"0"},{"id":"3","Selected":"0","id":"3","nProject":"0","Beginning":"20\/08\/2015 12:08:11","End":"20\/08\/2015 13:08:11","Description":"","nUser":"0"}]};
       }
      )

})();

