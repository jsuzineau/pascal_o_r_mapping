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
         $scope.NomFichier="";
         $scope.NbPoints=50;
         $scope.Delai=1;
         $scope.premier=true;
         $scope.valeur="état initial";
         $scope.labels = [0];
         var data
         =
          [
           {
           label: 'My First dataset',
           strokeColor: '#F16220',
           pointColor: '#F16220',
           pointStrokeColor: '#fff',
           data: [{ x: 0, y: 0 }]
           }
          ];
         var options
         =
          {
          bezierCurve : false,
          // Boolean - If we want to override with a hard coded scale
          scaleOverride: true,

          // ** Required if scaleOverride is true **
          // Number - The number of steps in a hard coded scale
          scaleSteps: 5,

          // Number - The value jump in the hard coded scale
          scaleStepWidth: 25,

          // Number - The scale starting value
          scaleStartValue: 25,
          };
         Chart.defaults.global.animation=false;

         var ctx = document.getElementById("cChart").getContext("2d");
         $scope.cChart= new Chart(ctx).Scatter( data, options);
         $scope.Charger_asynchrone
         =
          function ()
            {
            if ($scope.actif)
              $interval( $scope.Charger,$scope.Delai, 1);
            };
         $scope.Supprime_Point_debut
         =
          function ()
             {
             $scope.labels.shift();
             $scope.cChart.datasets[0].removePoint(0);
             }
         $scope.Charger
         =
          function ()
            {
            $http.get("/data/get")
            .success
              (
              function(response)
                {
                $scope.valeur= response;
                $scope.NomFichier=response.value.NomFichier;

                var Ts_Size=response.value.Ts_Size;
                var iMin= 0;
                var TMin=0;
                for (var i=0; i<Ts_Size; i++)
                  {
                  var T= response.value[String(i)];
                  if ((TMin == 0)||(TMin > T ))
                    {
                    iMin=i;
                    TMin= T;
                    }
                  }

                for (var i=iMin+1; i<iMin+Ts_Size; i++)
                  {
                  var j= i%Ts_Size;
                  var j_1=(i-1)%Ts_Size;

                  var T= response.value[String(j)];
                  if (-1 != $scope.labels.indexOf(T)) continue;

                  var T_1= response.value[String(j_1)];
                  var delta= T-T_1;
                  if (delta==0) continue;

                  var pouls= 60000/delta;
                  if ((pouls<20)||(200<pouls)) continue;

                  $scope.labels.push( T);
                  $scope.cChart.datasets[0].addPoint( T, pouls);
                  }
                if ($scope.premier)
                  {
                  $scope.Supprime_Point_debut();
                  $scope.premier= false;
                  }
                while ($scope.labels.length > $scope.NbPoints)
                  {
                  $scope.Supprime_Point_debut();
                  }
                $scope.cChart.update();
                $scope.Charger_asynchrone();
                }
              );
	    };
         $scope.Charger_asynchrone();
         }
        ]
      )

})();

