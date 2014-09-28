unit OOoXray3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls;

type
  TxrayForm3 = class(TForm)
    arrayGrid: TStringGrid;
    Panel1: TPanel;
    ExitBtn: TBitBtn;
    XrayBtn: TBitBtn;
    Label2: TLabel;
    ObjPath: TEdit;
    indexMin: TEdit;
    indexmax: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure Display(thisArray: Variant; currObjPath: String);
    procedure arrayGridDblClick(Sender: TObject);
    procedure XrayBtnClick(Sender: TObject);
  private
    { Private declarations }
    thisArray2: Variant;
  public
    { Public declarations }
    displayed: Boolean;
  end;

  PropReadability = (notReadable, arrayProp, noDisplay, OKreadable);



const
  { Ces messages ne devraient pas être traduits
  These messages should not be translated               }
  XrayMarray= 'Array';  XrayMstruct= 'Structure';
  XrayMobject= 'Object';  XrayMstring= 'String';


var
  xrayForm3: TxrayForm3;
  moreInfos: Boolean;

procedure displayValue(V1: Variant; var strV1, typeV1: String);
function existsObject(V1: Variant): Boolean;
function  getShortTypeStr(thisIdlClass: Variant; var propReadable: PropReadability): String;
procedure convertToGridValue(valProp: Variant; gridLine: TStrings; storeTypeString: Boolean);

implementation

{$R *.dfm}

uses OOoConstants, OOoMessages, OOoTools, OOoXray2, OOoXray;

const
  { Ces messages ne devraient pas être traduits
  These messages should not be translated               }
  mess300= '- Index -';
  mess303= 'Null Array';
  mess304= '< - - - - >'; // replaces a non displayable string in a Grid cell
  mess306 = '<null>';
  mess307= '<empty>';



  { ---------------------------------------------------------------------- }

const
  maxStringLengthInGrid= 100;

const
{ TypeClass enumeration ( same structure for arrays below)
  VOID              CHAR                 BOOLEAN        BYTE      SHORT
  UNSIGNED_SHORT    LONG                 UNSIGNED_LONG  HYPER     UNSIGNED_HYPER
  FLOAT             DOUBLE               STRING         TYPE      ANY
  ENUM              TYPEDEF              STRUCT         UNION     EXCEPTION
  SEQUENCE          ARRAY                INTERFACE      SERVICE   MODULE
  INTERFACE_METHOD  INTERFACE_ATTRIBUTE  UNKNOWN        PROPERTY  CONSTANT
  CONSTANTS         SINGLETON
}

  { Ces chaînes ne devraient pas être traduites
  These strings should not be translated               }
  TypeClass2Basic : Array[0..31] of string = (
    'void',         'Char',             'Boolean',      'Byte',   'Smallint',
    'Word',         'Integer',          'Longword',     'Int64',  'Int64',
    'Single',       'Double',           'String',       'type',   'Variant',
    'Integer',      'object',           'Structure',    'object', 'object',
    'Array',        'Array',            'object',       'object', 'object',
    'object',       'object',           'unknown',      'object', 'object',
    'object',       'object');

  TypeClassIsPropReadable : Array[0..31] of PropReadability = (
    notReadable,    OKreadable,         OKreadable,     OKreadable,  OKreadable,
    OKreadable,     OKreadable,         OKreadable,     OKreadable,  OKreadable,
    OKreadable,     OKreadable,         OKreadable,     notReadable, notReadable,
    OKreadable,     notReadable,        noDisplay,      notReadable, notReadable,
    arrayProp,      arrayProp,          noDisplay,      noDisplay,   noDisplay,
    notReadable,    notReadable,        notReadable,    notReadable, notReadable,
    notReadable,    notReadable)   ;


{ ------------------------------------------------------------------------- }


function existsObject(V1: Variant): Boolean;
begin
  Result:= False;
  if VarIsEmpty(V1)  then
    MessageDlg(XrayMvalue +mess307, mtInformation, [mbOK], 0)
  else if VarIsNull(V1)or VarIsClear(V1)  then
    MessageDlg(XrayMvalue +mess306, mtInformation, [mbOK], 0)
  else if VarIsArray(V1) and (VarArrayHighBound(V1, 1) < VarArrayLowBound(V1, 1)) then
    MessageDlg(XrayMvalue +mess303, mtInformation, [mbOK], 0)  // null array
  else
    Result:= True;
end;


procedure displayValue(V1: Variant; var strV1, typeV1: String);
const
  { this constant is not defined in Delphi 7 although it recognizes this type
    UNO-COM binding uses the type Decimal to transfer an hyper, which is in fact an INT64 }
  varDecimal= 14;

  procedure pre_analyze_Object;
  var
    classeIDL: Variant;   tc: Integer;
  begin
    classeIDL:= OOoReflection.getType(V1);   tc:= classeIDL.getTypeClass;
    if tc = _unoTypeClassSTRUCT  then begin
      typeV1:= XrayMstruct;
      if moreInfos  then  typeV1:= typeV1 +' : ' +classeIDL.getName;
      if  not IsNullEmpty(classeIDL.getField('Name'))  then
        strV1:= ' .Name = ' + V1.Name;    // add the property name
    end else begin  // other object
        typeV1:= XrayMobject;  strV1:= '';
    end;
  end;

{  function VarTypeAsText(const AType: TVarType): string;
  begin  // simplified emulation of the Delphi function introduced in Delphi 7
    case AType of
    varEmpty:     Result:= 'Empty';
    varNull:      Result:= 'Null';
    varByte:      Result:= 'Byte';
    varSmallInt:  Result:= 'Smallint';
    varWord:      Result:= 'Word';
    varInteger:   Result:= 'Integer';
    varLongWord:  Result:= 'Longword';
    varInt64:     Result:= 'Int64';
    varDecimal:   Result:= 'Decimal';
    varDouble:    Result:= 'Double';
    varSingle:    Result:= 'Single';
    varString:    Result:= 'String';
    else          Result:= '??????';
    end;
  end;    }

var
  lb, hb: Integer;
begin   { --------- displayValue ---------- }
  if VarArrayDimCount(v1) = 0 then begin { single value }
    typeV1:= VarTypeAsText(VarType(V1)); // if compile error, uncomment function above
    case VarType(V1) of
    varEmpty: strV1:= mess307;
    varNull: strV1:= mess306;
    varByte: strV1:= IntToStr(V1) + '  ( $' + IntToHex(V1, 2) + ' )';
    varSmallInt, varWord: strV1:= IntToStr(V1) + '  ( $' + IntToHex(V1, 4) + ' )';
    varInteger, varLongWord:  strV1:= IntToStr(V1) + '  ( $' + IntToHex(V1, 8) + ' )';
    varInt64, varDecimal: strV1:= IntToStr(V1) + '  ( $' + IntToHex(V1, 16) + ' )';
    varDouble, varSingle: strV1:= FloatToStr(V1);
    varBoolean: strV1:= BoolToStr(V1, True);
    varString, varStrArg, varOleStr: begin strV1:= V1; typeV1:= XrayMstring; end;
    varDispatch: pre_analyze_Object;
    else
      strV1:= '';
    end;
  end else begin
    typeV1:= XrayMarray;
    lb:= VarArrayLowBound(v1, 1); hb:= VarArrayHighBound(v1, 1);
    if hb < lb then
      strV1:= mess303  // 'Null Array'
    else
      strV1:= XrayMarray + '[' +IntToStr(lb) + '..' +IntToStr(hb) +']';
  end;
end;



function  getShortTypeStr(thisIdlClass: Variant; var propReadable: PropReadability): String;
var
  tc: Integer; thatIdlClass: variant;
begin
  { this simple code should work but does not work
      tc:= thisIdlClass.TypeClass;
  the following code is a work-around }
  thatIdlClass:= OOoReflection.forName(thisIdlClass.Name);
  tc:= thatIdlClass.TypeClass;

  propReadable:= TypeClassIsPropReadable[tc];
  if (tc = _unoTypeClassARRAY) or (tc = _unoTypeClassSEQUENCE)  then
    if moreInfos  then
      Result:= thisIdlClass.Name
    else begin
      tc:= thatIdlClass.ComponentType.TypeClass;
      Result:= '[]' + TypeClass2Basic[tc];
    end
  else
    if moreInfos  then
      Result:= thisIdlClass.Name
    else
      Result:= TypeClass2Basic[tc];
end;


procedure convertToGridValue(valProp: Variant; gridLine: TStrings; storeTypeString: Boolean);
var
  s1, s2: String;
begin
  displayValue(valProp, s2, s1);
  if storeTypeString  then   gridLine.Strings[1]:= s1;
  if Pos(XrayMstring, s1) = 1  then
    if (Length(s2) > maxStringLengthInGrid)
      or (Pos(#10, s2) > 0) or (Pos(#13, s2) > 0) or (Pos(#9, s2) > 0) then
      gridLine.Strings[2]:= mess304   // the text is not displayable in the Grid Cell
    else if Length(s2) = 0  then
      gridLine.Strings[2]:= '<' +XrayMzeroString +'>'
    else
      gridLine.Strings[2]:= s2
  else
    gridLine.Strings[2]:= s2;
end;



{ --------------------------------------------------------------------------- }


procedure TxrayForm3.Display(thisArray: Variant; currObjPath: String);
var
  x, xMin, xMax: Integer;  v2: Variant;
begin
  thisArray2:= thisArray;
  ObjPath.Text:= currObjPath;
  xMin:= VarArrayLowBound(thisArray, 1);    indexMin.Text:= IntToStr(xMin);
  xMax:= VarArrayHighBound(thisArray, 1);   indexMax.Text:= IntToStr(xMax);
  with arrayGrid     do begin
    RowCount:= xMax +2;
    Cells[0, 0]:= mess300;  Cells[1, 0]:= XrayMcolType;   Cells[2, 0]:= XrayMcolValue;
    for x:= xMin to xMax do begin
      v2:= thisArray[x];   convertToGridValue(v2, Rows[x+1], True);
      Cells[0, x +1]:=  Format('%6d', [x]);
    end;
  end;
  displayed:= True; ShowModal; displayed:= False;
end;


procedure TxrayForm3.arrayGridDblClick(Sender: TObject);
var
  typeStr, elementText, idx, newObjPath: String;  objX2: Variant;  y: Integer;
begin
  y:= arrayGrid.Selection.Top;  typeStr:= arrayGrid.Cells[1, y];
  idx:= arrayGrid.Cells[0, y];
  newObjPath:= ObjPath.Text +'[' +idx +']';
  if Pos(XrayMstring, typeStr) = 1  then begin
    elementText:= thisArray2[StrToInt(idx)];
    if elementText = '' then
      MessageDlg(XrayMzeroString, mtInformation, [mbOK], 0)  // null length string
    else
      xrayForm2.Display(elementText, newObjPath);
  end else if Pos(XrayMarray, typeStr) = 1  then begin
    objX2:= thisArray2[StrToInt(idx)];
    // analyze the new Array obtained
    with TxrayForm3.Create(self)  do begin
      Display(objX2, newObjPath); Free;
    end;
  end else if (Pos(XrayMobject, typeStr) = 1) or (Pos(XrayMstruct, typeStr) = 1) then begin
    objX2:= thisArray2[StrToInt(idx)];
    // analyze the new object obtained : recursion on Xray
    with TxrayForm1.Create(self)  do begin
      retrieveInfos(objX2, newObjPath);     ShowModal;   Free;
    end;
  end;
end;

procedure TxrayForm3.XrayBtnClick(Sender: TObject);
begin
  arrayGridDblClick(Sender);
end;


end.
