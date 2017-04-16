unit ufFields_vle;

{$mode delphi}

interface

uses
    uOpenDocument,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 ValEdit, Grids, StdCtrls;

type

 { TfFields_vle }

 TfFields_vle
 =
 class(TForm)
 published
  lKey: TLabel;
  Panel1: TPanel;
  vle: TValueListEditor;
  procedure vleSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
  procedure vleSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
 //Gestion du cycle de vie
 public
   constructor Create( _od: TOpenDocument); reintroduce;
   destructor Destroy; override;
 //od
 private
   od: TOpenDocument;
 public
   procedure _from_od;
 //Visiteurs des Fields du od
 public
   procedure Document_Fields_Visitor_for_vle( _Name, _Value: String);
 //Observation des changements sur les Fields
 public
   procedure vle_Fields_Change;
   procedure vle_Fields_Delete;
 end;

 function Assure_fFields_vle( var _fFields_vle: TfFields_vle; _od: TOpenDocument): TfFields_vle;

implementation

{$R *.lfm}

{ TfFields_vle }

function Assure_fFields_vle( var _fFields_vle: TfFields_vle; _od: TOpenDocument): TfFields_vle;
begin
     if nil = _fFields_vle
     then
         _fFields_vle:= TfFields_vle.Create( _od);
     Result:= _fFields_vle;
end;

constructor TfFields_vle.Create( _od: TOpenDocument);
begin
     inherited Create( nil);
     od:= _od;
     od.pFields_Change.Abonne( Self, vle_Fields_Change);
     od.pFields_Delete.Abonne( Self, vle_Fields_Delete);
     _from_od;
end;

destructor TfFields_vle.Destroy;
begin
     od.pFields_Change.Desabonne( Self, vle_Fields_Change);
     od.pFields_Delete.Desabonne( Self, vle_Fields_Delete);
     inherited Destroy;
end;

procedure TfFields_vle._from_od;
begin
     vle.Strings.Clear;
     od.Fields_Visite( Document_Fields_Visitor_for_vle       );
end;

procedure TfFields_vle.Document_Fields_Visitor_for_vle(_Name, _Value: String);
begin
     vle.Values[ _Name]:= _Value;
end;

procedure TfFields_vle.vle_Fields_Change;
begin
     vle.Values[ od.pFields_Change.Name]:= od.pFields_Change.Value;
end;

procedure TfFields_vle.vle_Fields_Delete;
var
   Row: Integer;
begin
     if not vle.FindRow( od.pFields_Delete.Name, Row) then exit;

     vle.DeleteRow( Row);
end;

procedure TfFields_vle.vleSetEditText( Sender: TObject; ACol, ARow: Integer; const Value: string);
var
   Name: String;
begin
     Name:= vle.Keys[ ARow];
     od.Set_Field( Name, Value);
end;

procedure TfFields_vle.vleSelectCell( Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
var
   Name: String;
begin
     Name:= vle.Keys[ ARow];
     lKey.Caption:= Name;
end;

end.

