unit ublTest_Batpro_Ligne;
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
    SysUtils, Classes,DB,
    uBatpro_StringList,
    u_sys_,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne;

type
 TblTest_Batpro_Ligne
 =
  class( TBatpro_Ligne)
  public
    numero       : Integer;
    test_string  : String;
    test_memo    : String;
    test_date    : TDateTime;
    test_integer : Integer;
    test_smallint: Integer;
    test_currency: Currency;
    test_datetime: TDateTime;
    test_double  : Double;
    test_champ_calcule: String;
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    function sCle: String; override;
  end;

function blTest_Batpro_Ligne_from_sl( sl: TBatpro_StringList; Index: Integer): TblTest_Batpro_Ligne;
function blTest_Batpro_Ligne_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTest_Batpro_Ligne;

implementation

function blTest_Batpro_Ligne_from_sl( sl: TBatpro_StringList; Index: Integer): TblTest_Batpro_Ligne;
begin
     _Classe_from_sl( Result, TblTest_Batpro_Ligne, sl, Index);
end;

function blTest_Batpro_Ligne_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTest_Batpro_Ligne;
begin
     _Classe_from_sl_sCle( Result, TblTest_Batpro_Ligne, sl, sCle);
end;


{ TblTest_Batpro_Ligne }

constructor TblTest_Batpro_Ligne.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Test de la classe Batpro_Ligne (table Test_Batpro_Ligne)';
         CP.Font.Name:= sys_Arial;
         CP.Font.Size:= 16;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Test_Batpro_Ligne';
     Champs. Integer_from_Integer ( numero       , 'numero'       , True);
     Champs.  String_from_String  ( test_string  , 'test_string'  );
     Champs.  String_from_Memo    ( test_memo    , 'test_memo'    );
     Champs.DateTime_from_Date    ( test_date    , 'test_date'    );
     Champs. Integer_from_Integer ( test_integer , 'test_integer' );
     Champs. Integer_from_SmallInt( test_smallint, 'test_smallint');
     Champs.Currency_from_BCD     ( test_currency, 'test_currency');
     Champs.DateTime_from_        ( test_datetime, 'test_datetime');
     Champs.  Double_from_        ( test_double  , 'test_double'  );
     Champs.  String_from_String  ( test_champ_calcule, 'test_champ_calcule', False);
end;

function TblTest_Batpro_Ligne.sCle: String;
begin
     Result:= IntToStr( numero);
end;

end.
