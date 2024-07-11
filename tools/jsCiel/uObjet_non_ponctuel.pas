unit uObjet_non_ponctuel;

{$mode Delphi}

interface

uses
    uObjets;

type
    T_Objet_non_ponctuel= class( T_Objet)
     public
       function DApp  : Extended ; virtual; {Diamètre Apparent en secondes d"arc}
     end;

implementation

function T_Objet_non_ponctuel.DApp  : Extended ;
begin
     Result:= 1;
end;

end.

