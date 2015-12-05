unit uGenero_Report_XML;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_JCL,
 Classes, SysUtils, DOM, DB;

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
begin
     Result:= nil;

     if nil = _F then exit;

     Result:= _Parent.AppendChild( _Parent.OwnerDocument.CreateElement('Item'));
     Set_Property( Result, 'name', _F.FieldName);
end;

end.

