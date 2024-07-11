unit uSexa_radians;

{$mode Delphi}

interface

uses
 Classes, SysUtils;

function HeureMinutesSecondes( Value: Extended): String;

function Degres90MinutesSecondes( Value: Extended): String;

function Degres360MinutesSecondes( Value: Extended): String;

implementation

function ValeurMinutesSecondes( w: Byte; Valeur: Extended; u1, u2, u3: string): String;
var
   Partie_entiere, Minutes, Secondes: Integer;
   Negatif: Boolean;
begin
     Negatif:= Valeur < 0;

     if Negatif then Valeur:= -Valeur;

     Partie_entiere:= Trunc(Valeur);
     Valeur:= (Valeur - Partie_entiere)*60;
     Minutes:= Trunc(Valeur);
     Secondes:= Trunc((Valeur-Minutes)*60);

     Result:= Format( '%*d%s%2.0d%s%2.0d%s',[w,Partie_entiere,u1,Minutes,u2,Secondes,u3]);
     if Negatif then Result[1]:= '-';
end;

function HeureMinutesSecondes( Value: Extended): String;
begin
     Result:= ValeurMinutesSecondes( 2, Value*12/PI,'h','min','s');
end;

function Degres90MinutesSecondes( Value: Extended): String;
begin
     Result:= ValeurMinutesSecondes( 3, Value*180/PI,'°','''','"');
end;

function Degres360MinutesSecondes( Value: Extended): String;
begin
     Result:= ValeurMinutesSecondes( 4, Value*180/PI,'°','''','"');
end;

end.

