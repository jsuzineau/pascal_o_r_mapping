unit uodWork_from_Period;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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

    upoolWork,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodWork_from_Period }

 TodWork_from_Period
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TBatpro_StringList;
    t: TOD_Batpro_Table;
    n: TOD_Niveau;
  public
    procedure Init(_Debut, _Fin: TDateTime; _idTag: Integer; _Description_Filter: String);
  end;

function odWork_from_Period: TodWork_from_Period;

implementation

{ TodWork_from_Period }

var
   FodWork_from_Period: TodWork_from_Period= nil;

function odWork_from_Period: TodWork_from_Period;
begin
     if nil = FodWork_from_Period
     then
         FodWork_from_Period:= TodWork_from_Period.Create;
     Result:= FodWork_from_Period;
end;

constructor TodWork_from_Period.Create;
begin
     sl:= TBatpro_StringList.Create;
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Work_from_Period.ott';
end;

destructor TodWork_from_Period.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TodWork_from_Period.Init( _Debut, _Fin: TDateTime; _idTag: Integer; _Description_Filter: String);
begin
     inherited Init;


     poolWork.Charge_Periode( _Debut, _Fin, _idTag, _Description_Filter, sl);

     t:= Ajoute_Table( 't');
     t.Pas_de_persistance:= True;
     t.AddColumn( 20, 'Début'      );
     t.AddColumn( 20, 'Fin'        );
     t.AddColumn( 20, 'Durée'        );
     t.AddColumn( 60, 'Description');
     n:= t.AddNiveau( 'Root');
     n.Charge_sl( sl);
     n.Ajoute_Column_Avant( 'Beginning'  , 0, 0);
     n.Ajoute_Column_Avant( 'End'        , 1, 1);
     n.Ajoute_Column_Avant( 'Duree'      , 2, 2);
     n.Ajoute_Column_Avant( 'Description', 3, 3);
end;

initialization

finalization
            FreeAndNil( FodWork_from_Period);
end.

