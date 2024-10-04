unit ufAutomatic;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,
    uuStrings,
    uRequete,
    ublAutomatic,
    upoolAutomatic,
  Classes, SysUtils, VCL.Forms,
  VCL.StdCtrls, ucChampsGrid, VCL.Dialogs, VCL.ExtCtrls, Vcl.Controls;

type

 { TfAutomatic }

 TfAutomatic = class(TForm)
  bExecute: TButton;
  bGenere: TButton;
  bGenere_Tout: TButton;
  cg: TChampsGrid;
  e: TEdit;
  Panel1: TPanel;
  procedure bExecuteClick(Sender: TObject);
  procedure bGenereClick(Sender: TObject);
  procedure bGenere_ToutClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
//atttributs
 public
    sl: TBatpro_StringList;
 end;

function fAutomatic: TfAutomatic;

implementation

{$R *.dfm}

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
     cg.Refresh;
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

procedure TfAutomatic.bGenere_ToutClick(Sender: TObject);
var
   sl: TStringList;
   I: Integer;
begin
     try
        sl:= TStringList.Create;
        Requete.GetTableNames( sl);
        for I:= 0 to sl.Count -1
        do
          begin
          e.Text:= 'select * from '+sl[I]+' limit 0,5';
          bExecute.Click;
          bGenere.Click;
          end;
     finally
            FreeAndNil( sl);
            end;
end;

initialization

finalization
            Clean_Destroy( FfAutomatic);
end.

