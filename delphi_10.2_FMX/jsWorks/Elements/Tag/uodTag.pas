unit uodTag;
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

interface

uses
    uBatpro_StringList,

    ublTag,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodTag }

 TodTag
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
    procedure Init( _bl: TblTag);
  end;

function odTag: TodTag;

implementation

{ TodTag }

var
   FodTag: TodTag= nil;

function odTag: TodTag;
begin
     if nil = FodTag
     then
         FodTag:= TodTag.Create;
     Result:= FodTag;
end;

constructor TodTag.Create;
begin
     inherited Create;
     sl:= TBatpro_StringList.Create;
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Tag.ott';
end;

destructor TodTag.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TodTag.Init( _bl: TblTag);
begin
     inherited Init;

     if _bl = nil then exit;

     Ajoute_Maitre( 'Tag', _bl);

     t:= Ajoute_Table( 't');
     t.Pas_de_persistance:= True;
     t.AddColumn( 20, 'Début'      );
     t.AddColumn( 20, 'Fin'        );
     t.AddColumn( 20, 'Durée'        );
     t.AddColumn( 60, 'Description');
     n:= t.AddNiveau( 'Root');
     n.Charge_ha( _bl.haWork);
     n.Ajoute_Column_Avant( 'Beginning'  , 0, 0);
     n.Ajoute_Column_Avant( 'End'        , 1, 1);
     n.Ajoute_Column_Avant( 'Duree'      , 2, 2);
     n.Ajoute_Column_Avant( 'Description', 3, 3);
end;

initialization

finalization
            FreeAndNil( FodTag);
end.

