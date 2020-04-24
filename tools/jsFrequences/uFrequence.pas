unit uFrequence;

{$mode delphi}

interface

uses
 Classes, SysUtils,Math;

function sFrequence( _Frequence: double; _digits: Integer=6): String;

var
   uFrequence_Separateur_Lignes: String= #13#10;

implementation

function sFrequence( _Frequence: double; _digits: Integer=6): String;
   function s_from_d( _d: double): String;
   var
      Nb_Chiffres_partie_entiere: Integer;
      Decimals: Integer;
   begin
        Nb_Chiffres_partie_entiere:= Trunc(Log10(_d))+1;
        Decimals:= _digits-1{virgule}-Nb_Chiffres_partie_entiere;
        if Decimals < 0 then Decimals:=0;
        str( _d:_digits:Decimals, Result);
        //Result:= FloatToStr( _d)+' log10:'+FloatToStr( Log10(_d));
   end;
   procedure  Hz;begin Result:= s_from_d( _Frequence     )+'  Hz'; end;
   procedure KHz;begin Result:= s_from_d( _Frequence/1E3 )+' KHz'; end;
   procedure MHz;begin Result:= s_from_d( _Frequence/1E6 )+' MHz'; end;
   procedure GHz;begin Result:= s_from_d( _Frequence/1E9 )+' GHz'; end;
   procedure THz;begin Result:= s_from_d( _Frequence/1E12)+' THz'; end;
begin
          if _Frequence < 1E3  then  Hz
     else if _Frequence < 1E6  then KHz
     else if _Frequence < 1E9  then MHz
     else if _Frequence < 1E12 then GHz
     else                           THz;
end;

end.

