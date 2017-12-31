unit uBatpro_OD_Printer;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uForms,
    uOpenDocument,
    uOD_Temporaire,
    uBatpro_Ligne,

    uBatpro_OD_TextFieldsCreator,

    uOD_Batpro_Table,
    uBatpro_OD_TextTableManager,
    uBatpro_StringList,
  {$IFDEF MSWINDOWS}
  Windows, //pour CopyFile
  {$ELSE}
  FileUtil,	//pour CopyFile
  {$ENDIF}
  SysUtils, Classes, DB;

type
 TBatpro_OD_Printer
 =
  class
  private
   D: TOpenDocument;
   Batpro_OD_TextFieldsCreator: TBatpro_OD_TextFieldsCreator;
   Batpro_OD_TextTableManager: TBatpro_OD_TextTableManager;
   procedure Ouvre( _NomFichier: String);
   procedure Ferme;
  public
    procedure AssureModele( NomFichierModele: String;
                            ParametresNoms: array of string;
                            NomMaitres : array of String;
                            Maitres    : array of TBatpro_Ligne;
                            Details    : array of TOD_Batpro_Table
                            );
    function Execute( NomFichierModele, sTitreEtat: String;
                      ParametresNoms,
                      ParametresValeurs: array of string;
                      NomMaitres  : array of String;
                      Maitres     : array of TBatpro_Ligne;
                      Details     : array of TOD_Batpro_Table): Variant; overload;
  end;

var
   Batpro_OD_Printer: TBatpro_OD_Printer= nil;

implementation

const
     s_Titre= 'Batpro_OD_Printer_Titre';

{ TBatpro_OD_Printer }

procedure TBatpro_OD_Printer.Ouvre( _NomFichier: String);
begin
     D:= TOpenDocument.Create( _NomFichier);
     Batpro_OD_TextFieldsCreator:= TBatpro_OD_TextFieldsCreator.Create( D);
     Batpro_OD_TextTableManager := TBatpro_OD_TextTableManager .Create( D);
end;

procedure TBatpro_OD_Printer.Ferme;
begin
     D.Save;

     FreeAndNil( Batpro_OD_TextTableManager );
     FreeAndNil( Batpro_OD_TextFieldsCreator);
     FreeAndNil( D);
end;

procedure TBatpro_OD_Printer.AssureModele( NomFichierModele: String;
                                           ParametresNoms: array of string;
                                           NomMaitres  : array of String;
                                           Maitres     : array of TBatpro_Ligne;
                                           Details     : array of TOD_Batpro_Table);
var
   I, Longueur: Integer;
   NouveauModele: Boolean;
begin
     NouveauModele:= not FileExists( NomFichierModele);

     if NouveauModele
     then
         uForms_ShowMessage(  'Création d''un document vide non gérée pour l''instant'#13#10
                      +'Veuillez créer un document vide nommé '+NomFichierModele);

     Ouvre( NomFichierModele);
     try
        //champ Titre
        Batpro_OD_TextFieldsCreator.Execute_Modele( s_Titre, NouveauModele);

        //Paramètres
        Longueur:= Length( ParametresNoms);
        if Longueur <> 0
        then
            for I:= 0 to Longueur-1
            do
              Batpro_OD_TextFieldsCreator.Execute_Modele( ParametresNoms[I],
                                                      NouveauModele);
        //champs du dataset maitre
        for I:= Low( Maitres) to High( Maitres)
        do
          Batpro_OD_TextFieldsCreator.Execute_Modele( NomMaitres[I], Maitres[I], NouveauModele);

        //table du dataset détail
        for I:= Low( Details) to High( Details)
        do
          Batpro_OD_TextTableManager.Execute_Modele( NomFichierModele, Details[I], NouveauModele);
     finally
            Ferme;
            end;
end;

function TBatpro_OD_Printer.Execute( NomFichierModele, sTitreEtat: String;
                                     ParametresNoms,
                                     ParametresValeurs: array of string;
                                     NomMaitres  : array of String;
                                     Maitres     : array of TBatpro_Ligne;
                                     Details     : array of TOD_Batpro_Table): Variant;
var
   NomFichier: String;
   I, Longueur: Integer;

begin
     if ExtractFilePath( NomFichierModele) = ''
     then
         NomFichierModele:= ExtractFilePath( ParamStr(0))+ NomFichierModele;

     if not FileExists( NomFichierModele)
     then
         AssureModele( NomFichierModele, ParametresNoms, NomMaitres, Maitres, Details);

     NomFichier:= OD_Temporaire.Nouveau_ODT( 'OD_Printer');
     CopyFile( PChar(NomFichierModele), PChar( NomFichier), False);

     Ouvre( NomFichier);
     try
        D.Set_Property( D.Get_xmlContent_TEXT,'text:use-soft-page-breaks','true');

        //champ Titre
        Batpro_OD_TextFieldsCreator.Execute( s_Titre, sTitreEtat);

        //Paramètres
        Longueur:= Length( ParametresNoms);
        if Longueur <> 0
        then
            for I:= 0 to Longueur-1
            do
              Batpro_OD_TextFieldsCreator.Execute( ParametresNoms[I], ParametresValeurs[I]);

        //champs du dataset maitre
        for I:= Low( Maitres) to High( Maitres)
        do
          Batpro_OD_TextFieldsCreator.Execute( NomMaitres[I], Maitres[I]);

        //table du dataset détail
        for I:= Low( Details) to High( Details)
        do
          Batpro_OD_TextTableManager.Remplit( NomFichierModele, Details[I]);

        D.Freeze_fields;
        //D.Delete_unused_styles;
     finally
            Ferme;
            end;
     Result:= NomFichier;
end;


initialization
              Batpro_OD_Printer:= TBatpro_OD_Printer.Create;
finalization
              FreeAndNil( Batpro_OD_Printer);

end.
