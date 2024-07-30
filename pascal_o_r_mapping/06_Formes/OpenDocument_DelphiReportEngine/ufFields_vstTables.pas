unit ufFields_vstTables;

{$mode delphi}

interface

uses
    uOpenDocument,
    ufFields_vst,
  laz.VirtualTrees, Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls;

type

 { TfFields_vstTables }

 TfFields_vstTables
 =
 class(TfFields_vst)
 published
 //Gestion du cycle de vie
 public
   constructor Create( _Caption: String; _od: TOpenDocument); reintroduce;
   destructor Destroy; override;
 //Visiteurs des Fields du Document
 public
   procedure Document_Fields_Visitor_for_tv( _Name, _Value: String); override;
 end;

function Assure_fFields_vstTables( var _fFields_vstTables: TfFields_vstTables; _Caption: String; _od: TOpenDocument): TfFields_vstTables;

implementation

{$R *.lfm}

{ TfFields_vstTables }

function Assure_fFields_vstTables( var _fFields_vstTables: TfFields_vstTables; _Caption: String; _od: TOpenDocument): TfFields_vstTables;
begin
     if nil = _fFields_vstTables
     then
         _fFields_vstTables:= TfFields_vstTables.Create( _Caption, _od);
     Result:= _fFields_vstTables;
end;

constructor TfFields_vstTables.Create( _Caption: String; _od: TOpenDocument);
begin
     inherited Create( _Caption, _od);
end;

destructor TfFields_vstTables.Destroy;
begin
     inherited Destroy;
end;

procedure TfFields_vstTables.Document_Fields_Visitor_for_tv( _Name, _Value: String);
begin
     inherited Document_Fields_Visitor_for_tv(_Name, _Value);

  if  1 <> Pos( '_', _Name) then exit;

    Ajoute_Valeur_dans_tv ( _Name, _Value)
end;

end.

