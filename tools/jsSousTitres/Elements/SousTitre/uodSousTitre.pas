unit uodSousTitre;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2021 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uBatpro_StringList,

    ublSousTitre,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodSousTitre }

 TodSousTitre
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslSousTitre;
  public
    procedure Init( _sl: TslSousTitre);reintroduce;
  end;

implementation

constructor TodSousTitre.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'SousTitre.ott';
end;

destructor TodSousTitre.Destroy;
begin
     inherited Destroy;
end;

procedure TodSousTitre.Init( _sl: TslSousTitre);
var
  t: TOD_Batpro_Table;
  nSousTitre, nWork, nWork_Self: TOD_Niveau;
begin
     inherited Init;

     t:= Ajoute_Table( 't');
     t.Pas_de_persistance:= True;
     t.MasquerTitreColonnes:= True;
     t.AddColumn( 10, '  ');
     t.AddColumn( 95, '  ');
     t.AddColumn( 95, '  ');
     nSousTitre  := t.AddNiveau( 'Root');

     nSousTitre.Charge_sl( _sl);

     nSousTitre.Ajoute_Column_Avant( 'id'       , 0, 0);
     nSousTitre.Ajoute_Column_Avant( 'SousTitre', 1, 1);
end;

end.

