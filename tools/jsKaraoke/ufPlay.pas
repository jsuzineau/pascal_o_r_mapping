unit ufPlay;

{$mode ObjFPC}{$H+}

interface

uses
    uBatpro_StringList,
    ublTexte,
    ublTiming,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfPlay }

 TfPlay
 =
  class(TForm)
    m: TMemo;
  public
    procedure _from( _bl, _blOld:TblTiming);
  end;

var
 fPlay: TfPlay;

implementation

{$R *.lfm}

{ TfPlay }

procedure TfPlay._from(_bl, _blOld: TblTiming);
var
   blT, blT_Old: TblTexte;
   T_OK, T_Old_OK: Boolean;
   function T_from_( _bl: TblTiming; out _blT: TblTexte): Boolean;
   begin
        Result:= Assigned( _bl);
        if not Result then exit;

        Result:= Affecte( _blT    , TblTexte, _bl.Texte_bl);
   end;
begin
     T_OK    := T_from_( _bl   , blT    );
     T_Old_OK:= T_from_( _blOld, blT_Old);

     m.Lines.Clear;

     if T_Old_OK then m.Lines.Add( blT_Old.Translitteration);
     if T_OK     then m.Lines.Add( blT    .Translitteration);

     if T_Old_OK then m.Lines.Add( blT_Old.Francais);
     if T_OK     then m.Lines.Add( blT    .Francais);

     if T_Old_OK then m.Lines.Add( blT_Old.Cyrillique);
     if T_OK     then m.Lines.Add( blT    .Cyrillique);
end;

end.

