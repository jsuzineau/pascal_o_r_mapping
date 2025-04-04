unit upoolAutomatic;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    uBatpro_StringList,
    uhAggregation,
    uDataUtilsU,
    uhFiltre,

    uBatpro_Element,
    ublAutomatic,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolAutomatic }

 TpoolAutomatic
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Méthodes
  public
    procedure Charge( _SQL: String; _slLoaded: TBatpro_StringList; _Params: TParams=nil);
  //Connection fixe
  public
    Connection_fixe: TDatabase;
  //Gestion de la connection
  public
    function Connection: TDatabase; override;
  end;

function poolAutomatic: TpoolAutomatic;

implementation

{$R *.lfm}

var
   FpoolAutomatic: TpoolAutomatic= nil;

function poolAutomatic: TpoolAutomatic;
begin
     Clean_Get( Result, FpoolAutomatic, TpoolAutomatic);
end;

{ TpoolAutomatic }

procedure TpoolAutomatic.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Automatic';
     Classe_Elements:= TblAutomatic;
     Classe_Filtre:= ThFiltre;
     Connection_fixe:= nil;

     inherited;

     Pas_de_champ_id:= True;
end;

procedure TpoolAutomatic.Charge( _SQL: String; _slLoaded: TBatpro_StringList; _Params: TParams);
begin
     Load( _SQL, _slLoaded, nil, _Params);
end;

function TpoolAutomatic.Connection: TDatabase;
begin
     Result:= Connection_fixe;
     if Assigned( Result) then exit;

     Result:= inherited Connection;
end;

initialization
finalization
              Clean_destroy( FpoolAutomatic);
end.
