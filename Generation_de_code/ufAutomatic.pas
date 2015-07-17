unit ufAutomatic;

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,
    uuStrings,
    ublAutomatic,
    upoolAutomatic,
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ucChampsGrid;

type

 { TfAutomatic }

 TfAutomatic = class(TForm)
  bExecute: TButton;
  bGenere: TButton;
  cg: TChampsGrid;
  e: TEdit;
  Panel1: TPanel;
  procedure bExecuteClick(Sender: TObject);
  procedure bGenereClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
//atttributs
 public
    sl: TBatpro_StringList;
 end;

function fAutomatic: TfAutomatic;

implementation

{$R *.lfm}

{ TfAutomatic }

var
   FfAutomatic: TfAutomatic= nil;

function fAutomatic: TfAutomatic;
begin
     Clean_Get( Result, FfAutomatic, TfAutomatic);
end;

procedure TfAutomatic.FormCreate(Sender: TObject);
begin
     cg.Classe_Elements:= TblAutomatic;
     sl:= TBatpro_StringList.Create( ClassName+'.sl');
end;

procedure TfAutomatic.FormDestroy(Sender: TObject);
begin
     Free_nil( sl);
end;

procedure TfAutomatic.bExecuteClick(Sender: TObject);
begin
     poolAutomatic.Charge( e.Text, sl);
     cg.sl:= sl;
end;

procedure TfAutomatic.bGenereClick(Sender: TObject);
var
   bl: TblAutomatic;
   SQL: String;
   NomTable: String;

begin
     if sl.Count = 0                               then exit;
     if Affecte_( bl, TblAutomatic, sl.Objects[0]) then exit;

     NomTable:= '';
     SQL:= e.Text;
     if 1 = Pos( 'select', SQL)
     then
         begin
         StrToK( 'from ', SQL);
         NomTable:= StrToK( ' ', SQL);
         end;

     if '' = NomTable
     then
         NomTable:= 'Nouveau';
     if not InputQuery( 'Génération de code', 'Suffixe d''identification (nom de la table)', NomTable) then exit;

     bl.Genere_code( NomTable);
end;

initialization

finalization
            Clean_Destroy( FfAutomatic);
end.

