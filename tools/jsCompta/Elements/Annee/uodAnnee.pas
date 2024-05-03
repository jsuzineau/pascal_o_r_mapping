unit uodAnnee;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
        http://www.mars42.com                                                   |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
    uBatpro_StringList,

    ublAnnee,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
    uEXE_INI,
 Classes, SysUtils;

type

 { TodAnnee }

 TodAnnee
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslAnnee;
    blAnnee: TblAnnee;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blAnnee: TblAnnee); reintroduce;
  //Mois: Mois
  public
    procedure Table_Mois; 
  end;

implementation

constructor TodAnnee.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Annee.ott';
     sl:= TslAnnee.Create( ClassName+'.sl');
end;

destructor TodAnnee.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodAnnee.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Annee');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blAnnee.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodAnnee.Init( _blAnnee: TblAnnee);
begin
     inherited Init;

     if _blAnnee = nil then exit;

     blAnnee:= _blAnnee;

     Ajoute_Maitre( 'Annee', blAnnee);

     sl.Clear;
     sl.AddObject( blAnnee.sCle, blAnnee);

     Table_Mois; 
end;

procedure TodAnnee.Table_Mois;
var
   tMois: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nMois: TOD_Niveau;
begin
     blAnnee.haMois.Charge;
     
     tMois:= Ajoute_Table( 'tMois');
     tMois.Pas_de_persistance:= True;
     tMois.AddColumn( 40, 'Année');
     tMois.AddColumn( 40, 'Mois');
     tMois.AddColumn( 40, 'Déclaré');
     tMois.AddColumn( 40, 'URSSAF');
     tMois.AddColumn( 40, 'CAF net');
     tMois.AddColumn( 40, 'Montant');
     tMois.AddColumn( 40, 'URSSAF reste' );
     tMois.AddColumn( 40, 'URSSAF évalué');

     nRoot:= tMois.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     //nRoot.Ajoute_Column_Avant( 'Annee'             , 0, 0);
     nRoot.Ajoute_Column_Apres( 'Annee'             , 0, 0);
     nRoot.Ajoute_Column_Apres( 'Total_Mois_Declare', 2, 2);
     nRoot.Ajoute_Column_Apres( 'Total_Mois_Montant', 5, 5);

     nMois:= tMois.AddNiveau( 'Mois');
     nMois.Ajoute_Column_Avant( 'Annee'        , 0, 0);
     nMois.Ajoute_Column_Avant( 'Mois'         , 1, 1);
     nMois.Ajoute_Column_Avant( 'Declare'      , 2, 2);
     nMois.Ajoute_Column_Avant( 'URSSAF'       , 3, 3);
     nMois.Ajoute_Column_Avant( 'CAF_net'      , 4, 4);
     nMois.Ajoute_Column_Avant( 'Montant'      , 5, 5);
     nMois.Ajoute_Column_Avant( 'URSSAF_reste' , 6, 6);
     nMois.Ajoute_Column_Avant( 'URSSAF_evalue', 7, 7);
end;

 

end.

