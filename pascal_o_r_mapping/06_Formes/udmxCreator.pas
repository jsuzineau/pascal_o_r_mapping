unit udmxCreator;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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

interface

uses
    u_sys_,
    uSGBD,
    uDataUtilsU,
    uDataUtilsF,
    uuStrings,

    udmDatabase,
    (*udmxPatch_INDEX,*)
    udmBatpro_DataModule,
    (*udm,*)

  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, FMTBcd, SQLDB,LCLType;

type
 TdmxCreator
 =
  class( TdmBatpro_DataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
    function Traite_Table_interne( Titre, NomTable    : String;
                                   sqlqCreate: TSQLQuery;
                                   _GED      : Boolean): Boolean;
  protected
    function Register_Dataset( D: TDataset): TypeDataset; override;
  public
    { Déclarations publiques }
      function Traite_Table    ( Titre, NomTable    : String;
                               sqlqCreate_INFORMIX,
                               sqlqCreate_MySQL   : TSQLQuery;
                               NomIndex           : String    = '' ;
                               sqlqCREATE_INDEX   : TSQLQuery = nil;
                               _GED               : Boolean= False): Boolean;
      function GED_Traite_Table( Titre, NomTable    : String;
                                 sqlqCreate_INFORMIX,
                                 sqlqCreate_MySQL   : TSQLQuery;
                                 NomIndex           : String    = '' ;
                                 sqlqCREATE_INDEX   : TSQLQuery = nil): Boolean;
    function Traite_Procedure( Titre, NomProcedure: String;
                               sqlqCreate: TSQLQuery): Boolean;
  end;

implementation

{$R *.dfm}

procedure TdmxCreator.DataModuleCreate(Sender: TObject);
begin
     inherited;
     Ouvrir_apres_login:= True;
end;

function TdmxCreator.Register_Dataset( D: TDataset): TypeDataset;
begin
     Result:= td_Special;
end;

function TdmxCreator.Traite_Table_interne( Titre, NomTable: String;
                                           sqlqCreate: TSQLQuery;
                                           _GED      : Boolean): Boolean;
begin
     if _GED
     then
         begin
         (*Result:= not dmxTABLES.Cherche( NomTable, _GED);
         if not Result then exit;*)
         end
     else
         case SGBD
         of
           sgbd_Informix:
             begin
             (*Result:= not dmxSYSTABLES.Cherche( NomTable);
             if not Result then exit;

             // On élimine le cas où l'échec de Cherche viendrait de la connexion
             Result:= dmxSYSTABLES.Ouvert;
             if not Result then exit;*)
             end;
           sgbd_MySQL:
             begin
             (*Result:= not dmxTABLES.Cherche( NomTable, _GED);
             if not Result then exit;*)
             end;
           sgbd_Postgres:
             begin
             (*Result:= not dmxTABLES.Cherche( NomTable, _GED);
             if not Result then exit;*)
             end;
           else SGBD_non_gere( 'TdmxCreator.Traite_Table_interne');
           end;

     Result
     :=
       mrYes
       =
        Application.MessageBox(
                    PChar( Format(
                    'La table %s de %s est introuvable dans la base.'#13#10+
                    'Souhaitez-vous qu''elle soit créée maintenant ?',
                                   [NomTable, Titre])),
                    PChar(Application.Title), MB_YESNO or MB_DEFBUTTON2);
     if not Result then exit;

     Result:= ExecSQLQuery( sqlqCreate);
end;

function TdmxCreator.Traite_Table( Titre, NomTable: String;
                                   sqlqCreate_INFORMIX,
                                   sqlqCreate_MySQL   : TSQLQuery;
                                   NomIndex           : String    = '' ;
                                   sqlqCREATE_INDEX   : TSQLQuery = nil;
                                   _GED      : Boolean= False): Boolean;
begin
     case SGBD
     of
       sgbd_Informix: Result:= Traite_Table_interne( Titre, NomTable, sqlqCreate_INFORMIX, _GED);
       sgbd_MySQL   : Result:= Traite_Table_interne( Titre, NomTable, sqlqCreate_MySQL   , _GED);
       sgbd_Postgres: Result:= False;
       else           Result:= False;
       end;

     (*if     Assigned( sqlqCREATE_INDEX)
        and (NomIndex <> sys_Vide)
     then
         if Result
         then
             ExecSQLQuery( sqlqCREATE_INDEX)
         else
             dmxPatch_INDEX.Ajoute_Index( NomTable, NomIndex,
                                          sqlqCREATE_INDEX.SQL.Text);*)
end;


function TdmxCreator.Traite_Procedure( Titre, NomProcedure: String;
                                      sqlqCreate: TSQLQuery): Boolean;
begin
     (*Result:= not dmxSYSPROCEDURES.Cherche( NomProcedure);
     if not Result then exit;

     // On élimine le cas où l'échec de Cherche viendrait de la connexion
     Result:= dmxSYSPROCEDURES.Ouvert;
     if not Result then exit;

     Result
     :=
       idYes
       =
        Application.MessageBox(
                    PChar( Format(
                    'La procédure stockée %s de %s est introuvable dans la base.'#13#10+
                    'Souhaitez-vous qu''elle soit créée maintenant ?',
                                   [NomProcedure, Titre])),
                    PChar(Application.Title), MB_YESNO or MB_DEFBUTTON2);
     if not Result then exit;

     Result:= ExecSQLQuery_sqlc( sqlqCreate, dmDatabase.sqlc);*)
end;

function TdmxCreator.GED_Traite_Table( Titre,
                                       NomTable: String;
                                       sqlqCreate_INFORMIX,
                                       sqlqCreate_MySQL: TSQLQuery;
                                       NomIndex: String;
                                       sqlqCREATE_INDEX: TSQLQuery): Boolean;
begin
     Result
     :=
       Traite_Table( Titre,
                     NomTable,
                     sqlqCreate_INFORMIX,
                     sqlqCreate_MySQL,
                     NomIndex,
                     sqlqCREATE_INDEX,
                     True);
end;

end.
