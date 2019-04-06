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
    uLog,
    uSGBD,
    uEXE_INI,
    uChrono,
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
    bSaveSQL: TButton;
    cbDatabases: TComboBox;
    e: TEdit;
    Panel1: TPanel;
    vst: TVirtualStringTree;
    procedure bExecuteClick(Sender: TObject);
    procedure bGenereClick(Sender: TObject);
    procedure bGenere_ToutClick(Sender: TObject);
    procedure bSaveSQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Liste de lignes
  public
     sl: TslAutomatic;
  //Execution du SQL
  public
    procedure Execute_SQL;
    procedure Genere( _NomTable: String);
  //Gestionnaire du VST
  private
    hVST: ThVST;
  //clé ini pour enregistrer le sql
  private
    inik_SQL: String;
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

     dmDatabase.jsDataConnexion.Fill_with_databases( cbDatabases.Items);
     cbDatabases.Text:= dmDatabase.jsDataConnexion.DataBase;
     inik_SQL:= ClassName+'.e.Text';
     e.Text:= EXE_INI.ReadString( inis_Options, inik_SQL, '');
end;

procedure TfAutomatic_VST.bSaveSQLClick(Sender: TObject);
begin
     EXE_INI.WriteString( inis_Options, inik_SQL, e.Text);
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
     dmDatabase.jsDataConnexion.Ferme_db;
     Old_Database:= dmDatabase.jsDataConnexion.DataBase;
     try
        dmDatabase.jsDataConnexion.DataBase:= cbDatabases.Text;
        Execute_SQL;
     finally
            dmDatabase.jsDataConnexion.DataBase:= Old_Database;
            end;
end;

procedure TfAutomatic_VST.Execute_SQL;
begin
     poolAutomatic.Charge( e.Text, sl);
     hVST._from_sl;
end;

procedure TfAutomatic_VST.Genere( _NomTable: String);
var
   bl: TblAutomatic;
begin
     if sl.Count = 0                               then exit;
     if Affecte_( bl, TblAutomatic, sl.Objects[0]) then exit;

     bl.Genere_code( _NomTable);
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

     Genere( NomTable);
end;

procedure TfAutomatic_VST.bGenere_ToutClick(Sender: TObject);
var
   Old_Database: String;
   sl: TStringList;
   I: Integer;
   NomTable: String;
   sChrono: String;
begin
     Chrono.Start;
     dmDatabase.jsDataConnexion.Ferme_db;
     Old_Database:= dmDatabase.jsDataConnexion.DataBase;
     try
        dmDatabase.jsDataConnexion.DataBase:= cbDatabases.Text;
        try
           sl:= TStringList.Create;
           Requete.GetTableNames( sl);
           fAutomatic_Genere_tout_sl.Execute( sl);
           for I:= 0 to sl.Count -1
           do
             begin
             NomTable:= sl[I];
             Chrono.Stop( 'Début traitement '+NomTable);
             case SGBD
             of
               sgbd_Informix: e.Text:= 'select first 1 * from '+NomTable;
               sgbd_MySQL   : e.Text:= 'select * from '+NomTable+' limit 0,1';
               sgbd_Postgres: e.Text:= 'select * from '+NomTable+' limit 1'  ;
               sgbd_SQLite3 : e.Text:= 'select * from '+NomTable+' limit 1';
               else SGBD_non_gere( Classname+'.bGenere_ToutClick');
               end;
             bExecute.Click;
             Genere( UpperCase( NomTable));
             end;
        finally
               FreeAndNil( sl);
               end;
     finally
            dmDatabase.jsDataConnexion.DataBase:= Old_Database;
            end;
     Chrono.Stop( 'Fin de la génération');
     sChrono:= Chrono.Get_Liste;
     Log.PrintLn( sChrono);
     ShowMessage( sChrono);
end;

initialization

finalization
            Clean_Destroy( FfAutomatic_VST);
end.

