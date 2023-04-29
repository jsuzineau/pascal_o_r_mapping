unit uINI_Batpro_OD_Report;
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
    uEXE_INI,
    uPublieur,
    ublG_PIP,
    upoolG_PIP,
  SysUtils, Classes;

const
     inis_pBatpro_OpenOffice_Report= 'pBatpro_OpenOffice_Report';
     inik_RepertoireModeles='Répertoire des modèles';
     inik_RepertoireSorties='Répertoire des sorties';

type
 TINI_Batpro_OD_Report
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Répertoire des modèles
  private
    //function _from_Fichier: String;
  private
    function  GetRepertoire_Modeles: String;
  public
    property    Repertoire_Modeles: String
        read GetRepertoire_Modeles;
  //Répertoire des sorties
  private
    function  GetRepertoire_Sorties: String;
    procedure SetRepertoire_Sorties(const Value: String);
  public
    property    Repertoire_Sorties: String
        read GetRepertoire_Sorties
       write SetRepertoire_Sorties;
  //Observation des modifications
  public
    pChange: TPublieur;
  end;

var
   uINI_Batpro_OD_Report_NomFichier_Repertoire_Modeles: String;
   INI_Batpro_OD_Report: TINI_Batpro_OD_Report= nil;

implementation


{ TINI_Batpro_OD_Report }

constructor TINI_Batpro_OD_Report.Create;
begin
     pChange:= TPublieur.Create( 'INI_Batpro_OD_Report.pChange');
end;

destructor TINI_Batpro_OD_Report.Destroy;
begin
     Free_nil( pChange);
     inherited;
end;

function TINI_Batpro_OD_Report.GetRepertoire_Modeles: String;
begin
     //Pas propre, modif rapide, on lit dans G_PAM au lieu du fichier ini
     //Result
     //:=
     //  EXE_INI.ReadString( inis_pBatpro_OpenOffice_Report,
     //                      inik_RepertoireModeles,
     //                      ExtractFilePath( ParamStr(0))
     //                      );
     Result:= poolG_PIP.Get_Parametres_Poste.modeles_oo;
end;

function TINI_Batpro_OD_Report.GetRepertoire_Sorties: String;
begin
     Result
     :=
       EXE_INI.ReadString( inis_pBatpro_OpenOffice_Report,
                           inik_RepertoireSorties,
                           ExtractFilePath( ParamStr(0))
                           );
end;

procedure TINI_Batpro_OD_Report.SetRepertoire_Sorties( const Value: String);
begin
     EXE_INI.WriteString( inis_pBatpro_OpenOffice_Report,
                          inik_RepertoireSorties,
                          Value
                          );
     pChange.Publie;
end;

initialization
              INI_Batpro_OD_Report
              :=
                TINI_Batpro_OD_Report.Create;
              uINI_Batpro_OD_Report_NomFichier_Repertoire_Modeles
              :=
                ExtractFilePath( ParamStr(0))+'Repertoire_Modeles.txt';
finalization
              Free_nil( INI_Batpro_OD_Report);
end.
