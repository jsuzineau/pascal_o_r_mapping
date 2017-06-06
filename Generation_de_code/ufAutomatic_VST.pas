unit ufAutomatic_VST;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uBatpro_StringList,
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
    uuStrings,
    uTri_Ancetre,
    uhFiltre_Ancetre,
    uRequete,

    udmDatabase,

    uBatpro_Ligne,

    ublAutomatic,
    upoolAutomatic,

    uhVST,

    ufAutomatic_Genere_tout_sl,

  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, VirtualTrees, ucChampsGrid;

type

 { TfAutomatic_VST }

 TfAutomatic_VST
 =
  class(TForm)
    bExecute: TButton;
    bGenere: TButton;
    bGenere_Tout: TButton;
    cbDatabases: TComboBox;
    e: TEdit;
    Panel1: TPanel;
    vst: TVirtualStringTree;
    procedure bExecuteClick(Sender: TObject);
    procedure bGenereClick(Sender: TObject);
    procedure bGenere_ToutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Liste de lignes
  public
     sl: TslAutomatic;
  //Execution du SQL
  public
    procedure Execute_SQL;
  //Gestionnaire du VST
  private
    hVST: ThVST;
  end;

function fAutomatic_VST: TfAutomatic_VST;

implementation

{$R *.lfm}

{ TfAutomatic_VST }

var
   FfAutomatic_VST: TfAutomatic_VST= nil;

function fAutomatic_VST: TfAutomatic_VST;
begin
     Clean_Get( Result, FfAutomatic_VST, TfAutomatic_VST);
end;

procedure TfAutomatic_VST.FormCreate(Sender: TObject);
begin
     sl:= TslAutomatic.Create( ClassName+'.sl');

     hVST:= ThVST.Create( vst, sl, poolAutomatic.Tri, poolAutomatic.hf);

     dmDatabase.Fill_with_databases( cbDatabases.Items);
     cbDatabases.Text:= dmDatabase.sqlc.DatabaseName;
end;

procedure TfAutomatic_VST.FormDestroy(Sender: TObject);
begin
     Free_nil( hVST);
     Free_nil( sl);
end;

procedure TfAutomatic_VST.bExecuteClick(Sender: TObject);
var
   Old_Database: String;
begin
     dmDatabase.sqlc.Close;
     Old_Database:= dmDatabase.sqlc.DatabaseName;
     try
        dmDatabase.sqlc.DatabaseName:= cbDatabases.Text;
        Execute_SQL;
     finally
            dmDatabase.sqlc.DatabaseName:= Old_Database;
            end;
end;

procedure TfAutomatic_VST.Execute_SQL;
begin
     poolAutomatic.Charge( e.Text, sl);
     hVST._from_sl;
end;

procedure TfAutomatic_VST.bGenereClick(Sender: TObject);
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

procedure TfAutomatic_VST.bGenere_ToutClick(Sender: TObject);
var
   Old_Database: String;
   sl: TStringList;
   I: Integer;
begin
     dmDatabase.sqlc.Close;
     Old_Database:= dmDatabase.sqlc.DatabaseName;
     try
        dmDatabase.sqlc.DatabaseName:= cbDatabases.Text;
        try
           sl:= TStringList.Create;
           Requete.GetTableNames( sl);
           fAutomatic_Genere_tout_sl.Execute( sl);
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
     finally
            dmDatabase.sqlc.DatabaseName:= Old_Database;
            end;
end;

initialization

finalization
            Clean_Destroy( FfAutomatic_VST);
end.

