(function() {
  'use strict';

   var m_Pouls = angular.module('Pouls', ['chart.js']);
   m_Pouls.controller
     (
     'ctrl_Pouls',
       [
       "$scope",
       "$http",
       "$interval",
       function ($scope,$http,$interval)
         {
         $scope.actif=false;
         $scope.labels = [0];
         $scope.series = ['Series A'];
         $scope.data = [[0]];
         $scope.valeur="état initial";
         $scope.options={bezierCurve : false};
         Chart.defaults.global.animation=false;
         $scope.Charger_asynchrone
         =
          function ()
            {
            if ($scope.actif)
              $interval( $scope.Charger,500, 1);
            };
         $scope.Charger
         =
          function ()
            {
            $http.get("/arduino/pouls")
            .success
              (
              function(response)
                {
                $scope.valeur= response;

                var longueur=response.length;
                var iMin= 0;
                var TMin=0;
                for (var i=0; i<longueur; i++)
                  {
                  var T= response[i];
                  if ((TMin == 0)||(TMin > T ))
                    {
                    iMin=i;
                    TMin= T;
                    }
                  }

                for (var i=iMin+1; i<iMin+longueur; i++)
                  {
                  var j= i%longueur;
                  var j_1=(i-1)%longueur;

                  var T= response[j];
                  if (-1 != $scope.labels.indexOf(T)) continue;

                  var T_1= response[j_1];
                  var delta= T-T_1;
                  if (delta==0) continue;

                  var pouls= 60000/delta;
                  if ((pouls<20)||(200<pouls)) continue;

                  $scope.labels.push( T);
                  $scope.data[0].push( pouls);
                  }
                while ($scope.labels.length > 50)
                  {
                  $scope.labels.shift();
                  $scope.data[0].shift();
                  }
                $scope.Charger_asynchrone();
                }
              );
	    };
         $scope.Charger_asynchrone();
         }
        ]
      )

})();

