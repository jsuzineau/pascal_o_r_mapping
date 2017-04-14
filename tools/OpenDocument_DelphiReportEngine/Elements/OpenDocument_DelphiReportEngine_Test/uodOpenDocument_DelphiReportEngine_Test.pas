unit uodOpenDocument_DelphiReportEngine_Test;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

    uhdmOpenDocument_DelphiReportEngine_Test,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodOpenDocument_DelphiReportEngine_Test }

 TodOpenDocument_DelphiReportEngine_Test
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    t: TOD_Batpro_Table;
    n: TOD_Niveau;
  public
    procedure Init( _hdmOpenDocument_DelphiReportEngine_Test: ThdmOpenDocument_DelphiReportEngine_Test); reintroduce;
  end;

implementation

{ TodOpenDocument_DelphiReportEngine_Test }

constructor TodOpenDocument_DelphiReportEngine_Test.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'OpenDocument_DelphiReportEngine_Test.ott';
     t:= nil;
end;

destructor TodOpenDocument_DelphiReportEngine_Test.Destroy;
begin
     FreeAndNil( n);
     FreeAndNil( t);
     inherited Destroy;
end;

procedure TodOpenDocument_DelphiReportEngine_Test.Init( _hdmOpenDocument_DelphiReportEngine_Test: ThdmOpenDocument_DelphiReportEngine_Test);
begin
     inherited Init;

     t:= Ajoute_Table( 't');
     t.AddColumn(  5, 'Code');
     t.AddColumn( 60, 'Libellé');
     t.AddColumn( 10, 'Quantité');
     t.AddColumn( 10, 'Prix unitaire');
     t.AddColumn( 10, 'Montant');
     n:= t.AddNiveau( 'Root');
     n.Charge_sl( _hdmOpenDocument_DelphiReportEngine_Test.sl);
     n.Ajoute_Column_Avant( 'Code'         , 0, 0);
     n.Ajoute_Column_Avant( 'Libelle'      , 1, 1);
     n.Ajoute_Column_Avant( 'Quantite'     , 2, 2);
     n.Ajoute_Column_Avant( 'Prix_Unitaire', 3, 3);
     n.Ajoute_Column_Avant( 'Montant'      , 4, 4);
end;

initialization

finalization
end.

