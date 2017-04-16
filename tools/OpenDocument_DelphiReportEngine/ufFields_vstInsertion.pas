unit ufFields_vstInsertion;

{$mode delphi}

interface

uses
    uOpenDocument,
    ufFields_vst,
  VirtualTrees, Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls;

type

 { TfFields_vstInsertion }

 TfFields_vstInsertion
 =
 class(TfFields_vst)
 published
  bInserer: TButton;
  procedure bInsererClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create( _Caption: String; _od: TOpenDocument); reintroduce;
   destructor Destroy; override;
 //Visiteurs des Fields du Document
 public
   procedure Document_Fields_Visitor_for_tv( _Name, _Value: String); override;
 end;

function Assure_fFields_vstInsertion( var _fFields_vstInsertion: TfFields_vstInsertion; _Caption: String; _od: TOpenDocument): TfFields_vstInsertion;

implementation

{$R *.lfm}

{ TfFields_vstInsertion }

function Assure_fFields_vstInsertion( var _fFields_vstInsertion: TfFields_vstInsertion; _Caption: String; _od: TOpenDocument): TfFields_vstInsertion;
begin
     if nil = _fFields_vstInsertion
     then
         _fFields_vstInsertion:= TfFields_vstInsertion.Create( _Caption, _od);
     Result:= _fFields_vstInsertion;
end;

constructor TfFields_vstInsertion.Create(_Caption: String; _od: TOpenDocument);
begin
     inherited Create( _Caption, _od);
end;

destructor TfFields_vstInsertion.Destroy;
begin
     inherited Destroy;
end;

procedure TfFields_vstInsertion.Document_Fields_Visitor_for_tv( _Name, _Value: String);
begin
     inherited Document_Fields_Visitor_for_tv(_Name, _Value);
     if  1 = Pos( '_', _Name) then exit;

     Ajoute_Valeur_dans_tv ( _Name, _Value)
end;

procedure TfFields_vstInsertion.bInsererClick(Sender: TObject);
var
   tn: PVirtualNode;
   Selection: String;
begin
     tn:= vst.GetFirstSelected();
     if tn = nil then exit;

     Selection:= hvst.Cle_from_Node( tn);
     od.Add_FieldGet( Selection);
     od.pChange.Publie;
end;

end.

