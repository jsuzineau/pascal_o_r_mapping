﻿unit ufSchemateur;
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
    uClean,
    uSGBD,
    uuStrings,
    uBatpro_StringList,
    uOD_Forms,

    udmDatabase,
    //udmxTABLES,
    //udmxSYSTABLES,
    //udmxSHOW_INDEX,
    //udmxSYSINDEXES,
    //udmxDESCRIBE,
    //udmxSYSCOLUMNS,
    uRequete,

    ufpBas,
    ufAccueil_Erreur,

  Windows, Messages, SysUtils, Variants, Classes, VCL.Graphics, VCL.Controls, VCL.Forms,
  VCL.Dialogs, VCL.ActnList, VCL.StdCtrls, VCL.ExtCtrls, VCL.Menus;

type
 TfSchemateur
 =
  class(TfpBas)
  public
    function Execute( _Version: String): Boolean; reintroduce;
  end;

function fSchemateur: TfSchemateur;

implementation

{$R *.dfm}

var
   FfSchemateur: TfSchemateur= nil;

function fSchemateur: TfSchemateur;
begin
     Clean_Get( Result, FfSchemateur, TfSchemateur);
end;

type
 TSchemateur
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _NomFichier: String);
    destructor Destroy; override;
  //Attributs
  private
    NomFichier: String;
    slLignes: TBatpro_StringList;
    Verbe, Parametres: String;
  //Méthodes
  private
    procedure CreeTable;
    procedure CreeIndex;
    procedure CreeChamp;
  public
    procedure Execute;
  end;

{ TSchemateur }

constructor TSchemateur.Create( _NomFichier: String);
var
   Entete: String;
begin
     NomFichier:= _NomFichier;
     slLignes:= TBatpro_StringList.Create( ClassName+'.slLignes');
     slLignes.LoadFromFile( NomFichier);
     if slLignes.Count = 0
     then
         Entete:= ''
     else
         begin
         Entete:= slLignes.Strings[ 0];
         slLignes.Delete( 0);
         end;
     Verbe:= StrToK( ' ', Entete);
     Parametres:= Entete;
end;

destructor TSchemateur.Destroy;
begin
     Free_nil( slLignes);
     inherited;
end;

procedure TSchemateur.CreeTable;
var
   NomTable: String;
   Table_Existe: Boolean;
begin
     NomTable:= Parametres;

     Table_Existe:= dmDatabase.jsDataConnexion.Table_Cherche( NomTable);
     if Table_Existe then exit;

     Requete.SQL:= slLignes.Text;

     if Requete.Execute
     then
         uForms_ShowMessage( 'La table '+NomTable+' a été créée.')
     else
         uForms_ShowMessage( 'Des erreurs ont été rencontrées lors de la création de la table '+NomTable);
end;

procedure TSchemateur.CreeIndex;
var
   NomTable: String;
   NomIndex: String;
   IndexExiste: Boolean;
begin
     NomTable:= StrToK( ' ', Parametres);
     NomIndex:= Parametres;

     IndexExiste:= dmDatabase.jsDataConnexion.Index_Cherche( NomTable, NomIndex);
     if IndexExiste then exit;

     Requete.SQL:= slLignes.Text;

     if Requete.Execute
     then
         uForms_ShowMessage( 'L''index '+NomIndex+' sur la table '+NomTable+' a été créé.')
     else
         uForms_ShowMessage( 'Des erreurs ont été rencontrées lors de la création de l''index '
                      +NomIndex+' sur la table '+NomTable+'.');
end;

procedure TSchemateur.CreeChamp;
var
   NomTable: String;
   NomChamp: String;
   ChampExiste: Boolean;
begin
     NomTable:= StrToK( ' ', Parametres);
     NomChamp:= Parametres;

     ChampExiste:= dmDatabase.jsDataConnexion.Champ_Cherche( NomTable, NomChamp);
     if ChampExiste then exit;

     Requete.SQL:= slLignes.Text;

     if Requete.Execute
     then
         uForms_ShowMessage( 'Le champ '+NomChamp+' sur la table '+NomTable+' a été créé.')
     else
         uForms_ShowMessage( 'Des erreurs ont été rencontrées lors de la création du champ '+NomChamp+' sur la table '+NomTable+'.');
end;


procedure TSchemateur.Execute;
begin
          if 'CreeTable' = Verbe then CreeTable
     else if 'CreeIndex' = Verbe then CreeIndex
     else if 'CreeChamp' = Verbe then CreeChamp;
end;

{ TfSchemateur }

function TfSchemateur.Execute( _Version: String): Boolean;
var
   Prefixe: String;
   Chemin: String;
   Masque: String;
   Prefixe_version: String;
   sr: TSearchRec;
   s: TSchemateur;

begin
     Result:= True;

     Prefixe:= 'sch_'+sSGBD+'_v';
     Chemin:= ExtractFilePath( uOD_Forms_EXE_Name);
     //fAccueil_Erreur(  'uOD_Forms_EXE_Name: '+uOD_Forms_EXE_Name+#13#10
     //                 +'Chemin: '+Chemin);
     Masque:= Chemin+Prefixe+'*.sql';
     Prefixe_version:= Prefixe+_Version;
     if 0<>FindFirst( Masque, faAnyFile, sr) then exit;

     repeat
           //si patch d'une version antérieure, on continue
           if sr.Name < Prefixe_version then continue;

           //si patch d'une version plus récente que celle de la base, on l'applique
           s:= TSchemateur.Create( Chemin+sr.Name);
           s.Execute;
           Free_nil( s);

     until FindNext( sr) <> 0;
end;

initialization
              Clean_Create ( FfSchemateur, TfSchemateur);
finalization
              Clean_Destroy( FfSchemateur);
end.
