unit uXML;
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
    SysUtils, Classes,
    u_sys_;

const
     xml_XMLHeader         : String =
       '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'#13#10
      +'<DATAPACKET Version="2.0">            '#13#10
      +'<METADATA>                            '#13#10
      +'<FIELDS>                              '#13#10;
     xml_XMLHeader_to_Rows : String =
       '</FIELDS>  '#13#10
      +'</METADATA>'#13#10
      +'<ROWDATA>  '#13#10;
     xml_XMLFooter         : String =
       '</ROWDATA>   '#13#10
      +'</DATAPACKET>'#13#10;

     xml_XMLRowStart: String = '  <ROW'#13#10;
     xml_XMLRowStop : String = '  />  '#13#10;


procedure WriteXMLString( M: TMemoryStream; S: String);


procedure WriteXMLHeader( M: TMemoryStream);
procedure WriteXMLHeader_to_Rows( M: TMemoryStream);
procedure WriteXMLFooter( M: TMemoryStream);


procedure WriteXMLRowStart( M: TMemoryStream);
procedure WriteXMLRowStop ( M: TMemoryStream);


procedure WriteXMLDef  ( M: TMemoryStream; attrname, fieldtype: String;
                         subtype: String = ''; width: String = '');
procedure WriteXMLValue( M: TMemoryStream; attrname, Value: String);


function XMLString  ( S: String   ): String;
function XMLDate    ( D: TDateTime): String;
function XMLDateTime( D: TDateTime): String;
function XMLFloat   ( F: Extended ): String;


implementation

procedure WriteXMLString( M: TMemoryStream; S: String);
begin
     M.Write( S, Length( S));
end;

procedure WriteXMLHeader( M: TMemoryStream);
begin
     WriteXMLString( M, xml_XMLHeader);
end;

procedure WriteXMLHeader_to_Rows( M: TMemoryStream);
begin
     WriteXMLString( M, xml_XMLHeader_to_Rows);
end;

procedure WriteXMLFooter( M: TMemoryStream);
begin
     WriteXMLString( M, xml_XMLFooter);
end;

procedure WriteXMLRowStart( M: TMemoryStream);
begin
     WriteXMLString( M, xml_XMLRowStart);
end;

procedure WriteXMLRowStop(M: TMemoryStream);
begin
     WriteXMLString( M, xml_XMLRowStop);
end;

function XMLQuotedStr( S: String): String;
begin
     Result:= '"'+S+'"';//il faudrait gérer les caractères d'échappement du XML style &
end;

function XMLString( S: String): String;
begin
     Result:= XMLQuotedStr( S);
end;

function XMLDate( D: TDateTime): String;
begin
     Result:= XMLQuotedStr( FormatDateTime( 'yyyymmdd', D));
end;

function XMLDateTime( D: TDateTime): String;
var
   FT: TFormatSettings;
begin
     FT.TimeSeparator:= ':';
     Result:= XMLQuotedStr( FormatDateTime( 'yyyymmdd\Thh:nn:sszzz', D, FT));
end;

function XMLFloat( F: Extended): String;
var
   FT: TFormatSettings;
begin
     FT.DecimalSeparator:= '.';
     Result:= XMLQuotedStr( FormatFloat( '##.###############', F, FT));
end;

procedure WriteXMLDef( M: TMemoryStream; attrname, fieldtype: String;
                       subtype: String = ''; width: String = '');
     procedure TraiteAttr( NomAttr: String; var Attr: String);
     begin
          if Attr <> sys_Vide
          then
              Attr:= ' '+NomAttr+'='+XMLString( Attr);
     end;
begin
     TraiteAttr( 'attrname' , attrname );
     TraiteAttr( 'fieldtype', fieldtype);
     TraiteAttr( 'subtype'  , subtype  );
     TraiteAttr( 'width'    , width    );
     WriteXMLString( M, '<FIELD'+attrname+fieldtype+ subtype+ width+' />');
end;

procedure WriteXMLValue( M: TMemoryStream; attrname, Value: String);
begin
     WriteXMLString( M, '      '+attrname+'='+Value+#13#10);
end;

end.

//ligne insérée  : <ROW RowState="4"
//ligne supprimée: <ROW RowState="2"
//ligne modifiée:
//       ancienne ligne : <ROW RowState="1"
//       nouvelle ligne : <ROW RowState="8"
