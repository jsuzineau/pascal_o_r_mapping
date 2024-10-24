unit uGenero_Report_from_Dataset;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
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

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_JCL,
    uOpenDocument,
 Classes, SysUtils, XMLRead, XMLWrite, sqlite3conn, DOM, DB, sqldb;

type
 { TGenero_Report_from_Dataset }

 TGenero_Report_from_Dataset
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //XML pour un Field donné
  public
    function Create_Item_from_Field( _Parent: TDOMNode; _F: TField): TDOMNode;
  //XML pour une ligne donnée d'un dataset
  public
    procedure XML_from_Dataset_Row( _Parent: TDOMNode; _D: TDataset);
  //XML pour un dataset donné
  public
    procedure XML_from_Dataset( _Parent: TDOMNode; _D: TDataset; _Balise: String= 'OnEveryRow');
  //Génération d'un XML
  public
    procedure Genere_XML( _D: TDataset);
  //Test
  public
    procedure Test;
  end;

implementation

{ TGenero_Report_from_Dataset }

constructor TGenero_Report_from_Dataset.Create;
begin

end;

destructor TGenero_Report_from_Dataset.Destroy;
begin
     inherited Destroy;
end;

function TGenero_Report_from_Dataset.Create_Item_from_Field( _Parent: TDOMNode; _F: TField): TDOMNode;
const
  FieldtypeDefinitionsConst : Array [TFieldType] of String[20] =
    (
      '',                 //ftUnknown,
      'VARCHAR(10)',      //ftString,
      'SMALLINT',         //ftSmallint,
      'INTEGER',          //ftInteger,
      '',                 //ftWord,
      'BOOLEAN',          //ftBoolean,
      'DOUBLE PRECISION', //ftFloat,
      '',                 //ftCurrency,
      'DECIMAL(18,4)',    //ftBCD,
      'DATE',             //ftDate,
      'TIME',             //ftTime,
      'TIMESTAMP',        //ftDateTime,
      '',                 //ftBytes,
      '',                 //ftVarBytes,
      '',                 //ftAutoInc,
      'BLOB',             //ftBlob,
      'TEXT',             //ftMemo,
      'BLOB',             //ftGraphic,
      '',                 //ftFmtMemo,
      '',                 //ftParadoxOle,
      '',                 //ftDBaseOle,
      '',                 //ftTypedBinary,
      '',                 //ftCursor,
      'CHAR(10)',         //ftFixedChar,
      '',                 //ftWideString,
      'BIGINT',           //ftLargeint,
      '',                 //ftADT,
      '',                 //ftArray,
      '',                 //ftReference,
      '',                 //ftDataSet,
      '',                 //ftOraBlob,
      '',                 //ftOraClob,
      '',                 //ftVariant,
      '',                 //ftInterface,
      '',                 //ftIDispatch,
      '',                 //ftGuid,
      'TIMESTAMP',        //ftTimeStamp,
      'NUMERIC(18,6)',    //ftFMTBcd,
      '',                 //ftFixedWideChar,
      ''                  //ftWideMemo);
    );
   function type_from_FieldType: String;
   begin
        case _F.DataType
        of
          ftString   : Result:= Format( 'VARCHAR( %d)', [_F.Size]);
          ftFixedChar: Result:= Format( 'CHAR( %d)'   , [_F.Size]);
          else Result:= FieldtypeDefinitionsConst[ _F.DataType];
          end;
   end;
   function Value_from_FieldType: String;
   begin
        case _F.DataType
        of
          ftString   : Result:= _F.DisplayText;
          ftMemo     : Result:= _F.AsString;
          else         Result:= _F.DisplayText;
          end;
   end;
begin
     Result:= nil;

     if nil = _F then exit;

     Result:= _Parent.AppendChild( _Parent.OwnerDocument.CreateElement('Item'));
     Set_Property( Result, 'name', _F.FieldName);
     Set_Property( Result, 'type', type_from_FieldType);
     Set_Property( Result, 'value', Value_from_FieldType);
     Set_Property( Result, 'isNull', BoolToStr( _F.IsNull, '1','0'));
end;

procedure TGenero_Report_from_Dataset.XML_from_Dataset_Row( _Parent: TDOMNode;
                                                            _D: TDataset);
var
   ePrint: TDOMNode;
   I: Integer;
begin
     if nil = _Parent then exit;
     if nil = _D      then exit;

     ePrint:= _Parent.AppendChild(_Parent.OwnerDocument.CreateElement('Print'));

     for I:= 0 to _D.FieldCount-1
     do
       Create_Item_from_Field( ePrint, _D.Fields[I]);
end;

procedure TGenero_Report_from_Dataset.XML_from_Dataset( _Parent: TDOMNode;
                                           _D: TDataset;
                                           _Balise: String);
var
   eBalise: TDOMNode;
begin
     if nil = _D then exit;

     _D.First;
     while not _D.EOF
     do
       begin
       eBalise:= _Parent.AppendChild(_Parent.OwnerDocument.CreateElement(_Balise));
       XML_from_Dataset_Row( eBalise, _D);

       _D.Next;
       end;
end;

procedure TGenero_Report_from_Dataset.Genere_XML(_D: TDataset);
var
   NomModele: String;
   NomFichier: String;
   xml: TXMLDocument;
   eReport: TDOMNode;
begin
     NomModele := ExtractFilePath( ParamStr(0))+ClassName+'_Template.xml';
     NomFichier:= ExtractFilePath( ParamStr(0))+ClassName+'_Test.xml';

     ReadXMLFile( xml, NomModele);

     eReport:= xml.FindNode( 'Report');
     if nil = eReport then exit;

     XML_from_Dataset( eReport, _D);

     WriteXMLFile( xml, NomFichier);

end;

procedure TGenero_Report_from_Dataset.Test;
var
   c: TSQLite3Connection;
   t: TSQLTransaction;
   sqlq: TSQLQuery;
begin

     c:= TSQLite3Connection.Create( nil);
     try
        c.DatabaseName:= ExtractFilePath( ParamStr(0))+'test_db.sqlite';
        t:= TSQLTransaction.Create( nil);
        t.DataBase:= c;
        sqlq:= TSQLQuery.Create( nil);

        sqlq.DataBase:= c;
        sqlq.SQL.Text:= 'select * from test';
        sqlq.Open;

        Genere_XML( sqlq);
     finally
            Free_nil( sqlq);
            Free_nil( t);
            Free_nil( c);
            end;
end;

end.

