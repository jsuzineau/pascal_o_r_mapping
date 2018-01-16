unit udmxcreTest_Batpro_Ligne;
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
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms,
  FMX.Dialogs,
  udmxCreator, FMTBcd, DB, SqlExpr;

type
 TdmxcreTest_Batpro_Ligne
 =
  class( TdmxCreator)
    sqlq: TSQLQuery;
    sqlINSERT: TSQLQuery;
  private
    { Déclarations privées }
    function  Insere( numero       : Integer;
                      test_string  : String;
                      test_memo    : String;
                      test_date    : TDateTime;
                      test_integer : Integer;
                      test_smallint: Integer;
                      test_currency: Currency;
                      test_datetime: TDateTime;
                      test_double  : Double
                      ): Boolean;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmxcreTest_Batpro_Ligne: TdmxcreTest_Batpro_Ligne;

implementation

uses
    uClean,
    uDataUtilsU,
    uDataUtilsF,
    udmDatabase;

{$R *.dfm}

var
   FdmxcreTest_Batpro_Ligne: TdmxcreTest_Batpro_Ligne;

function dmxcreTest_Batpro_Ligne: TdmxcreTest_Batpro_Ligne;
begin
     Clean_Get( Result, FdmxcreTest_Batpro_Ligne, TdmxcreTest_Batpro_Ligne);
end;

{ TdmxcreTest_Batpro_Ligne }

function  TdmxcreTest_Batpro_Ligne.Insere( numero       : Integer;
                                           test_string  : String;
                                           test_memo    : String;
                                           test_date    : TDateTime;
                                           test_integer : Integer;
                                           test_smallint: Integer;
                                           test_currency: Currency;
                                           test_datetime: TDateTime;
                                           test_double  : Double): Boolean;
begin
     with sqlINSERT
     do
       begin
       ParamByName( 'numero'       ).asInteger := numero       ;
       ParamByName( 'test_string'  ).asString  := test_string  ;
       ParamByName( 'test_memo'    ).asMemo    := test_memo    ;
       ParamByName( 'test_date'    ).asString  := DateSQL_sans_quotes(test_date    );
       ParamByName( 'test_integer' ).asInteger := test_integer ;
       ParamByName( 'test_smallint').asInteger := test_smallint;
       ParamByName( 'test_currency').asCurrency:= test_currency;
       ParamByName( 'test_datetime').asString  := DateTimeSQL_sans_quotes(test_datetime);
       ParamByName( 'test_double'  ).asFloat   := test_double  ;
       end;
     Result:= ExecSQLQuery( sqlINSERT);
end;

function TdmxcreTest_Batpro_Ligne.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= Traite_Table( 'de test de la classe Batpro_Ligne', 'test_batpro_ligne',
                            sqlq, sqlq);
     if Result
     then
         begin
              if Insere( 1, 'test_string 1', 'test_memo 1', Now, 1, 1, 1, Now, 1)
         then if Insere( 2, 'test_string 2', 'test_memo 2', Now, 2, 2, 2, Now, 2)
         then if Insere( 3, 'test_string 3', 'test_memo 3', Now, 3, 3, 3, Now, 3)
         then if Insere( 4, 'test_string 4', 'test_memo 4', Now, 4, 4, 4, Now, 4)
         then if Insere( 5, 'test_string 5', 'test_memo 5', Now, 5, 5, 5, Now, 5)
         then if Insere( 6, 'test_string 6', 'test_memo 6', Now, 6, 6, 6, Now, 6)
         then if Insere( 7, 'test_string 7', 'test_memo 7', Now, 7, 7, 7, Now, 7)
         then if Insere( 8, 'test_string 8', 'test_memo 8', Now, 8, 8, 8, Now, 8)
         then    Insere( 9, 'test_string 9', 'test_memo 9', Now, 9, 9, 9, Now, 9);
         end;
     FOuvert:= True;
end;

initialization
              Clean_Create ( FdmxcreTest_Batpro_Ligne, TdmxcreTest_Batpro_Ligne);
finalization
              Clean_Destroy( FdmxcreTest_Batpro_Ligne);
end.
