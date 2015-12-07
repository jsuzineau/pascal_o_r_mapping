unit uGenero_Report_XML;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_JCL,
    uOpenDocument,
 Classes, SysUtils, XMLRead, XMLWrite, sqlite3conn, DOM, DB, sqldb;

type

 { TGenero_Report_XML }

 TGenero_Report_XML
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //XML pour un Field donné
  public
    function Create_Item_from_Field( _Parent: TDOMNode; _F: TField): TDOMNode;
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

{ TGenero_Report_XML }

constructor TGenero_Report_XML.Create;
begin

end;

destructor TGenero_Report_XML.Destroy;
begin
     inherited Destroy;
end;

function TGenero_Report_XML.Create_Item_from_Field( _Parent: TDOMNode; _F: TField): TDOMNode;
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
      'BLOB',             //ftMemo,
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
          ftString   : Result:= Format( 'VARCHAR( %d)', [_F.DataSize])
          ftFixedChar: Result:= Format( 'CHAR( %d)'   , [_F.DataSize])
          else Result:= FieldtypeDefinitionsConst[ _F.DataType];
          end;
   end;
   function Value_from_FieldType: String;
   begin
        case _F.DataType
        of
          else Result:= _F.DisplayText;
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

procedure TGenero_Report_XML.XML_from_Dataset(_Parent: TDOMNode; _D: TDataset;
 _Balise: String);
var
   eBalise: TDOMNode;
   ePrint: TDOMNode;
   I: Integer;
begin
     if nil = _D then exit;

     _D.First;
     while not _D.EOF
     do
       begin
       eBalise:= _Parent.AppendChild( _Parent.OwnerDocument.CreateElement(_Balise));
       ePrint:= eBalise.AppendChild( eBalise.OwnerDocument.CreateElement('Print'));

       for I:= 0 to _D.FieldCount-1
       do
         Create_Item_from_Field( ePrint, _D.Fields[I]);

       _D.Next;
       end;
end;

procedure TGenero_Report_XML.Genere_XML(_D: TDataset);
var
   NomModele: String;
   NomFichier: String;
   xml: TXMLDocument;
   eReport: TDOMNode;
begin
     NomModele := ExtractFilePath( ParamStr(0))+'Genero_Report_XML_Template.xml';
     NomFichier:= ExtractFilePath( ParamStr(0))+'Test.xml';

     ReadXMLFile( xml, NomModele);

     eReport:= xml.FindNode( 'Report');
     if nil = eReport then exit;

     XML_from_Dataset( eReport, _D);

     WriteXMLFile( xml, NomFichier);

end;

procedure TGenero_Report_XML.Test;
var
   c: TSQLite3Connection;
   sqlq: TSQLQuery;
begin

     c:= TSQLite3Connection.Create( nil);
     try
        c.DatabaseName:= ExtractFilePath( ParamStr(0))+'test_db.sqlite';
        sqlq:= TSQLQuery.Create( nil);
        sqlq.DataBase:= c;


     finally
            Free_nil( sqlq);
            Free_nil( c);
            end;
end;

end.

