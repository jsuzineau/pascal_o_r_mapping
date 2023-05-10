(function() {
  'use strict';

   var m_AUT = angular.module('AUT', ['ui.tree']);
   m_AUT.controller(
     'ctrl_AUT',
     function ($scope,$http)
       {
       /*
       $scope.treeHeader_Champ_inner_Label_html= {};
       $http.get("treeHeader.Champ.inner.Label.html")
       .success
         (
         function(response)
           {
           $scope.treeHeader_Champ_inner_Label_html = response;
           }
         );
       $scope.treeHeader_Champ_inner_Edit_html= {};
       $http.get("treeHeader.Champ.inner.Edit.html")
       .success
         (
         function(response)
           {
           $scope.treeHeader_Champ_inner_Edit_html = response;
           }
         );
       */
       $scope.remove = function (scope) { scope.remove(); };
       $scope.toggle = function (scope) { scope.toggle(); };
       $scope.moveLastToTheBeginning
       =
        function ()
          {
          var a = $scope.data.pop();
          $scope.data.splice(0, 0, a);
          };

       $scope.newSubItem
       =
        function (scope)
          {
          var nodeData = scope.$modelValue;
          nodeData.nodes.push(
           {
           id: nodeData.id * 10 + nodeData.nodes.length,
           title: nodeData.title + '.' + (nodeData.nodes.length + 1),
           nodes: []
           });
          };

       $scope.collapseAll = function () { $scope.$broadcast('collapseAll'); };
       $scope.expandAll   = function () { $scope.$broadcast('expandAll'); };

       /*
       $scope.Rafraichit_Header
       =
        function ()
          {
          //mAUT.$rootScope.$templateCache.remove("treeHeader.html");
          $scope.treeHeader_html_url="treeHeader.html";
          };
       $scope.Rafraichit_Header();
       */

       $scope.SQL={};
       $http.get("../Automatic_AUT/SQL")
       .success
         (
         function(response)
           {
           $scope.SQL= response;
           }
         );

       $scope.Databases={};
       $scope.Rafraichit_Databases
       =
        function ()
          {
          $http.get("../Automatic_AUT/Databases")
          .success
            (
            function(response)
              {
              $scope.Databases= response;
              }
            );
          };
       $scope.$watch(
         function() { return $scope.Databases.Nom; },
         function(newValue, oldValue) {
           if ( newValue == oldValue ) return;
           $http.get("../Automatic_AUT/Database_Set/"+newValue)
           .success
             (
             function(response)
               {
               $scope.Databases= response;
               }
             );
         }
       );

       $scope.eSQLKeyDown
       =
        function ( $event)
          {
          if ($event.key != "Enter") return false;

          //$scope.treeHeader_html_url="";

          //envoi de la valeur
          $http.get("../Automatic_AUT/"+$scope.SQL)
          .success
            (
            function(response)
              {
              $scope.Rafraichit_Definitions();
              //$scope.Rafraichit_Header();
              $scope.root = response;
              }
            );
          return true;
          };


       $scope.Tri_Click
       =
        function ( _NomChamp)
          {
          $http.get("Tri/"+_NomChamp)
          .success
            (
            function(response)
              {
              $scope.Rafraichit_Definitions();
              $scope.root = response;
              }
            );
          };
       $scope.eFiltre_KeyDown
       =
        function ( $event,_NomChamp)
          {
          if ($event.key != "Enter") return false;

          //Récupération de la valeur
          $scope.eFiltre_NomChamp=document.getElementById( "eFiltre_"+_NomChamp);
          $scope.ValeurFiltreChamp= $scope.eFiltre_NomChamp.value;

          //envoi de la valeur
          $http.get("Filtre/"+_NomChamp+","+$scope.ValeurFiltreChamp)
          .success
            (
            function(response)
              {
              $scope.Rafraichit_Definitions();
              $scope.root = response;
              }
            );
          return true;
          };


       $scope.Definitions={Champs:[]};
       $scope.LargeurTable= "10000px";

       $scope.Rafraichit_Definitions
       =
        function ()
          {
          $http.get("AUT_Definitions.json")
          .success
            (
            function(response)
              {
              $scope.Definitions = response;
              $scope.LargeurTable=$scope.Definitions.Somme_Longueur+"em";
              }
            );
          };
       $scope.Rafraichit_Definitions();

       //$scope.root={};
       $scope.root=undefined;
       //$scope.root= {"Elements":[{"id":1},{"id":2},{"id":3}]};

       $http.get("AUT.json")
       .success
         (
         function(response)
           {
           $scope.root = response;
           $scope.Rafraichit_Databases();
           }
         );

       //$scope.root = {"Nom": "ThAutomatic_AUT.sl","Elements":[{"id":"1","Selected":"0","id":"1","nProject":"1","Beginning":"12\/08\/2015 08:44:47","End":"12\/08\/2015 12:44:47","Description":"Client 1\r\nCompta client","nUser":"0"},{"id":"2","Selected":"0","id":"2","nProject":"0","Beginning":"20\/08\/2015 10:13:50","End":"20\/08\/2015 13:13:50","Description":"","nUser":"0"},{"id":"3","Selected":"0","id":"3","nProject":"0","Beginning":"20\/08\/2015 12:08:11","End":"20\/08\/2015 13:08:11","Description":"","nUser":"0"}]};
       $scope.Page_precedente
       =
        function ()
          {
          $http.get("Page_precedente")
          .success
            (
            function(response)
              {
              $scope.root = response;
              }
            );
          }
       $scope.Page_suivante
       =
        function ()
          {
          $http.get("Page_suivante")
          .success
            (
            function(response)
              {
              $scope.root = response;
              }
            );
          }
       }
      )

})();

