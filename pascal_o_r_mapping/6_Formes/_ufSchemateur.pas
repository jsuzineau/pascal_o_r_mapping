unit ufSchemateur;
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
    uClean,
    uSGBD,
    uuStrings,
    uBatpro_StringList,

    udmDatabase,
    (*udmxTABLES,
    udmxSYSTABLES,
    udmxSHOW_INDEX,
    udmxSYSINDEXES,
    udmxDESCRIBE,
    udmxSYSCOLUMNS,*)

    ufpBas,
    ufAccueil,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Menus;

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
  //M�thodes
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
   TableAbsente: Boolean;
begin
(*     NomTable:= Parametres;

     if dmDatabase.IsMySQL
     then
         begin
         TableAbsente:= not dmxTABLES.Cherche( NomTable);
         if not TableAbsente then exit;
         end
     else
         begin
         TableAbsente:= not dmxSYSTABLES.Cherche( NomTable);
         if not TableAbsente then exit;

         // On �limine le cas o� l'�chec de Cherche viendrait de la connexion
         TableAbsente:= dmxSYSTABLES.Ouvert;
         if not TableAbsente then exit;
         end;

     if dmDatabase.ExecQuery( slLignes.Text)
     then
         ShowMessage( 'La table '+NomTable+' a �t� cr��e.')
     else
         ShowMessage( 'Des erreurs ont �t� rencontr�es lors de la cr�ation de la table '+NomTable);*)
end;

procedure TSchemateur.CreeIndex;
var
   NomTable: String;
   NomIndex: String;
   IndexAbsent: Boolean;
begin
(*     NomTable:= StrToK( ' ', Parametres);
     NomIndex:= Parametres;

     if dmDatabase.IsMySQL
     then
         begin
         IndexAbsent:= not dmxSHOW_INDEX.Cherche( NomTable, NomIndex);
         if not IndexAbsent then exit;
         end
     else
         begin
         IndexAbsent:= not dmxSYSINDEXES.Cherche( NomIndex, NomTable);
         if not IndexAbsent then exit;

         // On �limine le cas o� l'�chec de Cherche viendrait de la connexion
         IndexAbsent:= dmxSYSINDEXES.Ouvert;
         if not IndexAbsent then exit;
         end;

     if dmDatabase.ExecQuery( slLignes.Text)
     then
         ShowMessage( 'L''index '+NomIndex+' sur la table '+NomTable+' a �t� cr��.')
     else
         ShowMessage( 'Des erreurs ont �t� rencontr�es lors de la cr�ation de l''index '
                      +NomIndex+' sur la table '+NomTable+'.');*)
end;

procedure TSchemateur.CreeChamp;
var
   NomTable: String;
   NomChamp: String;
   ChampAbsent: Boolean;
begin
(*     NomTable:= StrToK( ' ', Parametres);
     NomChamp:= Parametres;

     if dmDatabase.IsMySQL
     then
         begin
         ChampAbsent:= not dmxDESCRIBE.Cherche( NomTable, NomChamp);
         if not ChampAbsent then exit;
         end
     else
         begin
         ChampAbsent:= not dmxSYSCOLUMNS.Cherche( NomTable, NomChamp);
         if not ChampAbsent then exit;

         // On �limine le cas o� l'�chec de Cherche viendrait de la connexion
         ChampAbsent:= dmxSYSCOLUMNS.Ouvert;
         if not ChampAbsent then exit;
         end;

     if dmDatabase.ExecQuery( slLignes.Text)
     then
         ShowMessage( 'Le champ '+NomChamp+' sur la table '+NomTable+' a �t� cr��.')
     else
         ShowMessage( 'Des erreurs ont �t� rencontr�es lors de la cr�ation du champ '+NomChamp+' sur la table '+NomTable+'.');*)
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
     Chemin:= ExtractFilePath( Application.ExeName);
     //fAccueil.Erreur(  'Application.ExeName: '+Application.ExeName+#13#10
     //                 +'Chemin: '+Chemin);
     Masque:= Chemin+Prefixe+'*.sql';
     Prefixe_version:= Prefixe+_Version;
     if 0<>FindFirst( Masque, faAnyFile, sr) then exit;

     repeat
           //si patch d'une version ant�rieure, on continue
           if sr.Name < Prefixe_version then continue;

           //si patch d'une version plus r�cente que celle de la base, on l'applique
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
