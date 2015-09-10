unit upoolJSON;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

    uBatpro_Element,
    ublJSON,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uHTTP_Interface,

  fpjson, jsonparser,
  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolJSON }

 TpoolJSON
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Création à partir d'une chaine JSON
  private
    function Traite_jso( _jso: TJSONObject): TblJSON;
    procedure Traite_liste( _jso: TJSONObject; _slLoaded: TBatpro_StringList);
  public
    function Get_from_JSON( _JSON: String): TblJSON;
    procedure Charge_from_JSON( _JSON: String; _slLoaded: TBatpro_StringList);
  end;

function poolJSON: TpoolJSON;

implementation

{$R *.lfm}

var
   FpoolJSON: TpoolJSON= nil;

function poolJSON: TpoolJSON;
begin
     Clean_Get( Result, FpoolJSON, TpoolJSON);
end;

{ TpoolJSON }

procedure TpoolJSON.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Automatic';
     Classe_Elements:= TblJSON;
     Classe_Filtre:= nil;

     inherited;

     Pas_de_champ_id:= True;
end;

function TpoolJSON.Traite_jso(_jso: TJSONObject): TblJSON;
begin
     if Affecte_( Result, TblJSON, Cree_Element( nil)) then exit;
     Result._from_JSONObject( _jso);
     Ajoute( Result);
end;

procedure TpoolJSON.Traite_liste( _jso: TJSONObject;
                                  _slLoaded: TBatpro_StringList);
var
   I: Integer;
begin
     for I:= 0 to _jso.Count-1
     do
       begin
       //_jso.; à coder
       end;
end;

function TpoolJSON.Get_from_JSON(_JSON: String): TblJSON;
var
   jsp: TJSONParser;
   jso: TJSONObject;
begin
     jsp:= TJSONParser.Create( _JSON);
     jso:= jsp.Parse as TJSONObject;
     try
          Result:= Traite_jso( jso);
     finally
            Free_nil( jsp);
            end;
end;


procedure TpoolJSON.Charge_from_JSON( _JSON: String;
                                      _slLoaded: TBatpro_StringList);
var
   jsp: TJSONParser;
   jso: TJSONObject;
   procedure Traite_Object;
   var
      bl: TblJSON;
   begin
        bl:= Traite_jso( jso);
        _slLoaded.Clear;
        _slLoaded.AddObject( bl.sCle, bl);
   end;
begin
     jsp:= TJSONParser.Create( _JSON);
     jso:= jsp.Parse as TJSONObject;
     try
        case jso.JSONType
        of
          jtArray : Traite_liste( jso, _slLoaded);
          jtObject: Traite_Object;
          end;
     finally
            Free_nil( jsp);
            end;
end;

initialization
finalization
              Clean_destroy( FpoolJSON);
end.
