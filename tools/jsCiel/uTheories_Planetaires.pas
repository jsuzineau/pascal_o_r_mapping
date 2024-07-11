unit uTheories_Planetaires;

{$mode Delphi}

interface

uses
    //uPublieur,
 Classes, SysUtils;

type
    T_Planetary_Theory
    =
     ( pt_VSOP82, pt_VSOP87, pt_PS1996, pt_Erreur);

var
   Planetary_Theory_Wanted: T_Planetary_Theory= pt_VSOP87;
   Planetary_Theory_Used: T_Planetary_Theory= pt_VSOP87;
   //Planetary_TheoryChange: TPublieur;

const
     Planetary_Theory_Name: array[pt_VSOP82..pt_Erreur] of String
     =
      ( 'VSOP82', 'VSOP87', 'PS1996', 'Erreur');

//function Planetary_Theory_From_String( s: String): T_Planetary_Theory;

//procedure Set_Planetary_Theory_to( Value: T_Planetary_Theory);

implementation

(*
function Planetary_Theory_From_String( s: String): T_Planetary_Theory;
var
   pt: T_Planetary_Theory;
begin
     Result:= pt_Erreur;
     pt:= pt_VSOP82;
     while pt <> pt_Erreur
     do
       begin
       if s = Planetary_Theory_Name[ pt]
       then
           begin
           Result:= pt;
           pt:= pt_Erreur;
           end
       else
           pt:= Succ( pt);
       end;
end;

function Invalid_Planetary_Theory: Boolean;
var
   AA: Integer;
begin
     if Planetary_Theory_Wanted <> pt_VSOP87
     then
         begin
         AA:= Temps_Lieu.Temps.TD.AA;
         Result:= (AA < 1900) or (2100 < AA);
         if Result
         then
             begin
             MessageBox_MB_OK( s_Passage_Automatique_a_VSOP87);
             Planetary_Theory_Wanted:= pt_VSOP87;
             Planetary_TheoryChange.Publish;
             end;
         end
     else
         Result:= False;
end;

procedure Set_Planetary_Theory_to( Value: T_Planetary_Theory);
begin
     if Planetary_Theory_Wanted = Value then exit;

     Planetary_Theory_Wanted:= Value;
     if not Invalid_Planetary_Theory
     then
         Planetary_TheoryChange.Publish;
end;

procedure DateChange;
begin
     Invalid_Planetary_Theory;
end;
*)

end.

