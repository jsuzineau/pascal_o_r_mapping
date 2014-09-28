unit OOoXray;

{
This unit is part of a toolbox to pilot OpenOffice.org from Delphi using COM Automation.
Copyright (C) 2004-2007  Bernard Marcelly
This library is free software; you can redistribute it and/or modify it under the terms of
the GNU Lesser General Public License as published by the Free Software Foundation;
either version 2.1 of the License, or (at your option) any later version.
This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public License along with this
library; if not, write to the Free Software Foundation, Inc.,
59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Grids, ExtCtrls;


type
  TxrayForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    propGrid: TStringGrid;
    TabSheet2: TTabSheet;
    methGrid: TStringGrid;
    TabSheet3: TTabSheet;
    serviceGrid: TStringGrid;
    TabSheet5: TTabSheet;
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    ExitBtn: TBitBtn;
    ImplementName: TEdit;
    searchAPIBtn: TBitBtn;
    SaveBtn: TBitBtn;
    SaveDialog1: TSaveDialog;
    XrayBtn: TBitBtn;
    ObjectPath: TEdit;
    Label2: TLabel;
    TabSheet4: TTabSheet;
    interfaceGrid: TStringGrid;
    procedure methGridDblClick(Sender: TObject);
    procedure propGridDblClick(Sender: TObject);
    procedure searchAPIBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure XrayBtnClick(Sender: TObject);
    procedure propGridContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure methGridContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
    thisObject: Variant;
    unePageSDK, bkLines: TStringList;
    function  objectIsStructure: Boolean;
    procedure extractProperties;
    procedure extractMethods;
    procedure extractSupportedServices;
    procedure extractAvailableServices;
    procedure extractInterfaces;
    procedure displayAPIpage(laPage: String; item: String= '');
    procedure findPropertyBookmarks(searchName, prop_attrib: String);
    procedure XrayAgain(objName, ObjPath: String; nameIsProperty: Boolean);
  public
    { Public declarations }
    procedure retrieveInfos(ObjX: Variant; ObjXname: String);
  end;

var
  xrayForm1: TxrayForm1;

procedure xray(myObject: Variant);

implementation

{$R *.dfm}

uses StrUtils, ShellAPI, OOoMessages, OOoTools, OOoConstants, OOoXray2, OOoXray3;


const // -----  configuration de Xray /  Xray configuration  ----------

  { Répertoire principal du SDK sur votre ordinateur.
  N'oubliez pas le backslash à la fin !

  Main directory of the SDK on your computer.
  Do not forget ending backslash !                }
  SDKaddr= 'D:\OpenOffice.org2.2_SDK\';


  { Lancer le navigateur par défaut ou un navigateur spécifique.
  True : la valeur de myBrowser n'est pas utilisée.
         L'ancre dans la page du SDK ne sera pas utilisée.
  False : la valeur de myBrowser est l'adresse de l'exécutable du navigateur.
          La page sera affichée à la position de l'ancre.
  Valeur recommandée : False

  Run the default browser or a designated browser.
  True : the value of myBrowser is disregarded.
         The anchor in the SDK page will not be used.
  False : the value of myBrowser is the address of the browser executable.
          The SDK page will be displayed at anchor position.
  Recommended value : False                       }
  useDefaultBrowser= False;


  { Adresse de l'exécutable du navigateur HTML.
  Naturellement vous pouvez indiquer celle de votre navigateur par défaut.

  Address of the executable of the HTML browser to be used.
  Of course you may use the address of your default browser.    }
  myBrowser = 'C:\Program Files\Opera\Opera.exe';


  { Fournir plus (True) ou moins (False) d'informations.
  Valeur recommandée : True

  Provide more (True) or less (False) information.
  Recommended value : True                            }
  moreInfosState= True;


const
  { Ces messages ne devraient pas être traduits
  These messages should not be translated               }
  mess50= 'may be Void';  mess51= 'read only';  mess52= 'write only';
  mess53= 'value change may be listened';   mess54= 'value change may be vetoed';
  mess55= 'value is not persistent';  mess56= 'value may be ambiguous';
  mess57= 'may be set to default';  mess58= 'property may be removed';
  mess59= 'attribute';  mess60= 'pseudo-prop'; mess63= 'enum: ';


  { -------------------------------------------------- }


function isValidObject(myObject: Variant; ObjXname: String): Boolean;
var
  strV2, typeV2: String;
begin
  Result:= False;
  if existsObject(myObject)  then begin
    displayValue(myObject, strV2, typeV2);
    if (Pos(XrayMstruct, typeV2) = 1) or (Pos(XrayMobject, typeV2) = 1) then
      Result:= True
    else if Pos(XrayMstring, typeV2) = 1 then
      if strV2 = '' then
        MessageDlg(XrayMzeroString, mtInformation, [mbOK], 0)
      else
        xrayForm2.Display(strV2, ObjXname)
    else if Pos(XrayMarray, typeV2) = 1  then
      if xrayForm3.displayed then // create another instance
        with TxrayForm3.Create(nil)  do begin
          Display(myObject, ObjXname);   Free;
        end
      else
        xrayForm3.Display(myObject, ObjXname)
    else
      MessageDlg(XrayMvalue +strV2, mtInformation, [mbOK], 0);
  end;
end;


procedure xray(myObject: Variant);
begin
     OOoXray3.moreInfos:= moreInfosState;
     if isValidObject(myObject, XrayMobject)
     then
         with xrayForm1
         do
           begin
           retrieveInfos(myObject, XrayMobject);
           ShowModal;
           end;
end;



{  --------------  TxrayForm1  ---------------------- }


procedure TxrayForm1.XrayAgain(objName, ObjPath: String; nameIsProperty: Boolean);
var
  insp, info2, objX2, unElem, classeIDL: Variant;
begin
  insp:= OOoIntrospection.inspect(thisObject);
  try  // some properties and methods are not accessible by the COM bridge
    if nameIsProperty  then
      if insp.hasMethod('getPropertyValue', -1) then
          objX2:= thisObject.getPropertyValue(objName) // may throw an exception
      else begin
        classeIDL:= OOoReflection.getType(thisObject);
        unElem:= classeIDL.getField(objName);    objX2:= unElem.get(thisObject);
      end
    else begin
      info2:= insp.getMethod(objName ,-1);
      objX2:= info2.invoke(thisObject, dummyArray); // may throw an exception
    end;
    // analyze the new object obtained
    if isValidObject(objX2, ObjPath)  then
      with TxrayForm1.Create(self)  do begin
        retrieveInfos(objX2, ObjPath);     ShowModal;   Free;
      end;
  except // getPropertyValue has probably thrown exception 'The type does not fit'
    MessageDlg(Format(XrayMess72, [objName]), mtInformation, [mbOK], 0);
  end
end;



procedure TxrayForm1.retrieveInfos( ObjX: Variant; ObjXname: String);

  procedure clearInfosDisplay;
  begin
       with propGrid
       do
         begin
         RowCount:= 2; // at least two lines so that the first can remain fixed
         Cells[0, 0]:= XrayMess10;   Cells[1, 0]:= XrayMcolType;
         Cells[2, 0]:= XrayMcolValue;   Cells[3, 0]:= XrayMess13;
         end;
       with methGrid
       do
         begin
         RowCount:= 2;
         Cells[0, 0]:= XrayMess20;   Cells[1, 0]:= XrayMess21;
         Cells[2, 0]:= XrayMess22;   Cells[3, 0]:= XrayMess23;
         end;
  end;

begin { -------- TxrayForm1.retrieveInfos -------- }
      thisObject:= Objx;
      clearInfosDisplay;
      ObjectPath.Text:= ObjXname;
      ImplementName.Text:= XrayMess40; // default value
      Screen.Cursor:= crHourglass;
      try
         { these methods must be called in this order }
         if not objectIsStructure  then extractProperties;
         extractMethods;
         extractSupportedServices;
         extractAvailableServices;
         extractInterfaces;
         if propGrid.Cols[0].IndexOf('ImplementationName') >= 0
         then
             ImplementName.Text:= thisObject.ImplementationName;
      finally
             Screen.Cursor:= crDefault;
             end;
      PageControl1.ActivePageIndex:= 0; // display property page
end;


function getEnumStringValue(thisIdlClass, theValue: Variant): String;
var
  enumString: String; thatIdlClass, rfl, enufs, enux: Variant; x, tc: Integer;
begin
  Result:= '';
  if not moreInfosState  then Exit;
  { this simple code should work but does not work
      tc:= thisIdlClass.TypeClass;
  the following code is a work-around }
  thatIdlClass:= OOoReflection.forName(thisIdlClass.Name);
  tc:= thatIdlClass.TypeClass;
  if tc = _unoTypeClassENUM  then begin
    enumString:= thisIdlClass.Name;
    rfl:= OOoReflection.forName(enumString);
    enufs:= rfl.Fields;
    for x:= VarArrayLowBound(enufs, 1) to VarArrayHighBound(enufs, 1)  do begin
      enux:= enufs[x];
      if theValue = enux.get(0)  then begin
        Result:= mess63 +enumString +'.' +enux.Name;
        Exit;
      end;
    end;
  end;
end;


procedure addAfter(var existingText: String; moreText: String);
begin  // adds a text after an existing text, separated from it
  if Length(existingText) = 0 then
    existingText:= moreText
  else
    if Length(moreText) > 0  then
      existingText:= existingText + ' - ' + moreText;
end;


procedure TxrayForm1.extractProperties;

  function isRealProperty(info2: Variant; var propReadable: PropReadability;
            gridLine: TStrings; insp: Variant; var propComment: String): Boolean;
  var
    getPseudoProp, valGet: Variant;
    propName: String ;
  begin
    propName:= gridLine.Strings[0];
    if insp.hasProperty(propName, _beansPropertyConceptPROPERTYSET)  then  begin
      Result:= True; Exit;
    end else if insp.hasProperty(propName, _beansPropertyConceptATTRIBUTES)  then  begin
      addAfter(propComment, mess59); // property is an Attribute
      propReadable:= notReadable; // impossible to get value directly, xray deeper needed
      Result:= True; Exit;
    end;
    if insp.hasMethod('get' +propName, -1)  then begin
      if propReadable = arrayProp  then
        if (propName <> 'Data') and (propName <> 'DataArray')
          and (propName <> 'FormulaArray')  then
            propReadable:= noDisplay; // getting value is acceptable
      if insp.hasMethod('set' +propName, -1)  then
        addAfter(propComment, mess60)   // pseudo-prop read/write
      else begin  // pseudo-prop read-only
        addAfter(propComment, mess60); addAfter(propComment, mess51);
      end;
      if propReadable > arrayProp  then
        try  // some methods are not accessible by the COM bridge
          getPseudoProp:= insp.getMethod('get' +propName, -1);
          valGet:= getPseudoProp.invoke(thisObject, dummyArray);
          convertToGridValue(valGet, gridLine, False);  // don't change the Type cell
          addAfter(propComment, getEnumStringValue(info2.Type, valGet));
        except // invoke has probably thrown exception 'The type does not fit'
          gridLine.Strings[2]:= XrayMess61;
        end;
    end else if insp.hasMethod('set' +propName, -1)  then begin // pseudo-prop write-only
      addAfter(propComment, mess60); addAfter(propComment, mess52);
    end else
      propReadable:= notReadable; // inconsistent Introspection values

    Result:= False;
  end;

  procedure RealPropertyInfos(info2: Variant; var propComment: String);
  var
    propAttribs: Variant;
  begin
    propAttribs:= info2.Attributes;
    if (propAttribs and _beansPropertyAttributeREADONLY)       <> 0  then  addAfter(propComment, mess51);
    if (propAttribs and _beansPropertyAttributeMAYBEVOID)      <> 0  then  addAfter(propComment, mess50);
    if not moreInfosState  then Exit;

    if (propAttribs and _beansPropertyAttributeBOUND)          <> 0  then  addAfter(propComment, mess53);
    if (propAttribs and _beansPropertyAttributeCONSTRAINED)    <> 0  then  addAfter(propComment, mess54);
    if (propAttribs and _beansPropertyAttributeTRANSIENT)      <> 0  then  addAfter(propComment, mess55);
    if (propAttribs and _beansPropertyAttributeMAYBEAMBIGUOUS) <> 0  then  addAfter(propComment, mess56);
    if (propAttribs and _beansPropertyAttributeMAYBEDEFAULT)   <> 0  then  addAfter(propComment, mess57);
    if (propAttribs and _beansPropertyAttributeREMOVEABLE)     <> 0  then  addAfter(propComment, mess58);
  end;

var
  insp, info1, info2, valProp: Variant;
  propReadable: PropReadability;  propComment: String;
  x, xMax: Integer;  exists_getPropertyValue: Boolean;
begin  { ------- TxrayForm1.extractProperties ------}
  insp:= OOoIntrospection.inspect(thisObject);
  exists_getPropertyValue:= insp.hasMethod('getPropertyValue', -1);
  info1:= insp.getProperties(-1);   xMax:= VarArrayHighBound(info1, 1);
  if xMax >= 0 then propGrid.RowCount:= xMax +2;
  for x:= 0 to xMax do begin // scan properties list
    info2:= info1[x];    propComment:= '';
    with propGrid.Rows[x +1] do begin
      Strings[0]:= info2.Name;
      Strings[1]:= getShortTypeStr(info2.Type, propReadable);
      if isRealProperty(info2, propReadable, propGrid.Rows[x +1], insp, propComment)  then begin
        RealPropertyInfos(info2, propComment);
        if (propReadable > notReadable) and exists_getPropertyValue then
          try  // some properties are not accessible by the COM bridge
            valProp:= thisObject.getPropertyValue(Strings[0]);
            convertToGridValue(valProp, propGrid.Rows[x +1], False);
            addAfter(propComment, getEnumStringValue(info2.Type, valProp));
          except // getPropertyValue has probably thrown exception 'The type does not fit'
            Strings[1]:= XrayMess61;   Strings[2]:= XrayMess61;
          end;
      end;
      Strings[3]:= propComment;
    end;
  end;
end;


function  TxrayForm1.objectIsStructure: Boolean;
var
  classeIDL, elemList, elemX, elemVal: Variant;
  propReadable: PropReadability;
  x, xMax, accMode: Integer;   s1, s2, s3, elemType: String;
begin
  classeIDL:= OOoReflection.getType(thisObject);
  Result:= (classeIDL.TypeClass = _unoTypeClassSTRUCT);
  if not Result  then exit;  // object or array, or simple type, etc
  ImplementName.Text:= XrayMess62 + classeIDL.Name;  // structure name
  elemList:= classeIDL.Fields;
  xMax:= VarArrayHighBound(elemList, 1);
  if xMax >= 0 then propGrid.RowCount:= xMax +2;
  for x:= 0 to xMax do begin // scan the list of elements of the structure
    elemX:= elemList[x];
    s1:= getShortTypeStr(elemX.Type, propReadable);
    with propGrid.Rows[x +1] do begin
      Strings[0]:= elemX.Name;
      accMode:= elemX.AccessMode;
      if accMode = _reflectionFieldAccessModeWRITEONLY  then begin
        s2:= '';  s3:= mess52;
      end else begin
        if accMode = _reflectionFieldAccessModeREADONLY  then s3:= mess51  else s3:= '';
        try  // some elements are not accessible by the COM bridge
          elemVal:= elemX.get(thisObject);   displayValue(elemVal, s2, elemType);
          if (elemType = XrayMstring) and (Length(s2) = 0)  then
            s2:= '<' +XrayMzeroString +'>'
          else
            addAfter(s3, getEnumStringValue(elemX.Type, elemVal));
        except // get has probably thrown exception 'The type does not fit'
          s2:= XrayMess61;  s3:= '';
        end;
      end;
      Strings[1]:= s1;       Strings[2]:= s2;    Strings[3]:= s3;
    end;
  end;
end;


procedure TxrayForm1.extractMethods;
var
  insp, info1, info2, info3, infoParam, paramType: Variant;
  x, y, xMax: Integer;  listeParams: String; dummy: PropReadability;

begin
  insp:= OOoIntrospection.inspect(thisObject);
  info1:= insp.getMethods(-1);
  xMax:= VarArrayHighBound(info1, 1);
  if xMax >= 0 then     methGrid.RowCount:= xMax +2;
  for x:= 0 to xMax do begin   // each méthode
    info2:= info1[x];
    with methGrid.Rows[x +1] do begin
      Strings[0]:= info2.Name;
      info3:= info2.ReturnType;
      Strings[2]:= getShortTypeStr(info3, dummy);
      if Strings[2] = 'void'  then Strings[2]:= '';
      info3:= info2.ParameterInfos;  listeParams:= '';
      for y:= 0 to VarArrayHighBound(info3, 1) do begin //   each method parameter
        infoParam:= info3[y];  paramType:= infoParam.aType;
        if listeParams <> '' then listeParams:= listeParams + ' ;  ';
        listeParams:= listeParams + infoParam.aName +' : ' + getShortTypeStr(paramType, dummy);
      end;
      Strings[1]:= listeParams;
      info3:= info2.DeclaringClass; Strings[3]:= info3.Name;
    end;
  end;
end;


procedure TxrayForm1.extractSupportedServices;
var
  lesServices: Variant;  x, Xm: Integer;  triage: TStringList;
begin
  triage:= TStringList.Create;
  with triage do begin  // sort services list
    Duplicates:= dupIgnore;  CaseSensitive:= True;  Sorted:= True;  Add(XrayMess30);
    if propGrid.Cols[0].IndexOf('SupportedServiceNames') >= 0  then begin
      lesServices:=  thisObject.SupportedServiceNames;
      Xm:= VarArrayHighBound(lesServices, 1); // Xm = -1 if no service
      for x:= 0 to Xm do   Add(lesServices[x]);
    end;
    if Count > serviceGrid.RowCount  then  serviceGrid.RowCount:= Count;
  end;
  serviceGrid.Cols[0].Assign(triage);  triage.Free;
end;


procedure TxrayForm1.extractAvailableServices;
var
  lesServices: Variant;  x, Xm: Integer;  triage: TStringList;
begin
  triage:= TStringList.Create;
  with triage do begin  // sort services list
    Duplicates:= dupIgnore;  CaseSensitive:= True;  Sorted:= True;  Add(XrayMess31);
    if propGrid.Cols[0].IndexOf('AvailableServiceNames') >= 0  then begin
      lesServices:=  thisObject.AvailableServiceNames;
      Xm:= VarArrayHighBound(lesServices, 1); // Xm = -1 if no service
      for x:= 0 to Xm do   Add(lesServices[x]);
    end;
    if Count > serviceGrid.RowCount  then  serviceGrid.RowCount:= Count;
  end;
  serviceGrid.Cols[1].Assign(triage);  triage.Free;
end;


procedure TxrayForm1.extractInterfaces;
var
  y: Integer; interf: String;  triage: TStringList;
begin
  triage:= TStringList.Create;
  with triage do begin  // sort interfaces list
    Duplicates:= dupIgnore;  CaseSensitive:= True;  Sorted:= True;  Add(XrayMess32);
    // get the interface of each method
    for y:= 1 to methGrid.RowCount -1  do begin
      interf:= methGrid.Cells[3, y];
      if interf <> '' then  Add(interf);  // triage will suppress duplicates
    end;
    if Count > interfaceGrid.RowCount  then  interfaceGrid.RowCount:= Count;
  end;
  interfaceGrid.Cols[0].Assign(triage);  triage.Free;
end;


procedure TxrayForm1.methGridDblClick(Sender: TObject);
var
  y: Integer;   methodName, resultType: String;
begin
  y:= methGrid.Selection.Top;    methodName:= methGrid.Cells[0, y];
  if methodName = ''  then  exit;            // empty line
  resultType:= methGrid.Cells[2, y];
  if resultType = ''  then
   MessageDlg(XrayMess71, mtInformation, [mbOK], 0)  // the method returns nothing
  else  if (resultType ='type') or (resultType ='[]type') then
    MessageDlg(Format(XrayMess72, [methodName]), mtInformation, [mbOK], 0)  // impossible to get a type by COM
  else  if methGrid.Cells[1, y] <> '' then
      MessageDlg(XrayMess70, mtInformation, [mbOK], 0)  // xray impossible, the method needs arguments
    else
      XrayAgain(methodName, ObjectPath.Text +'.' + methodName, False);
end;



procedure TxrayForm1.propGridDblClick(Sender: TObject);
var
  propType, propName, path2: String;  y: Integer;
begin 
  y:= propGrid.Selection.Top;
  propName:= propGrid.Cells[0, y];  propType:= propGrid.Cells[1, y];
  path2:= ObjectPath.Text +'.' +propName; // path to the element in the object

  { this code is no more needed with OOo version 2.2.0 (maybe also previous  versions)
  if (propType ='type') or (propType ='[]type') then // impossible to get a type by COM
    MessageDlg(Format(XrayMess72, [propName]), mtInformation, [mbOK], 0)
  else
  }
  if Pos(mess52, propGrid.Cells[3, y]) = 0  then  // property can be read
    if Pos(mess60, propGrid.Cells[3, y]) > 0  then  // pseudo-property, use method getXXX
      XrayAgain('get' +propName, path2, False)
    else if  Pos(mess59, propGrid.Cells[3, y]) > 0  then  // interface attribute : can't xray
      MessageDlg(Format(XrayMess72, [propName]), mtInformation, [mbOK], 0)
    else // real service property
      XrayAgain(propName, path2, True)
  else  // write-only property
    MessageDlg(Format(XrayMess74, [propName]), mtInformation, [mbOK], 0);
end;



procedure TxrayForm1.displayAPIpage(laPage: String; item: String= '');
var
  pSDK: String;
begin
  if laPage = '' then exit;
  pSDK:= StringReplace(laPage, '.', '\', [rfReplaceAll]);
  pSDK:= SDKaddr +'docs\common\ref\' + pSDK +'.html';
  if FileExists(pSDK) then
    if useDefaultBrowser then
      ShellExecute(0, 'open', PChar(pSDK), nil, nil, SW_SHOW)
    else
      ShellExecute(0, 'open', PChar(myBrowser), PChar(pSDK +'#' +item), nil, SW_SHOW)
  else
    MessageDlg(XrayMess80, mtInformation, [mbOK], 0);  // no page in the SDK
end;



procedure TxrayForm1.findPropertyBookmarks(searchName, prop_attrib: String);

  function validContext(SDKindexLine: String) : Boolean;
  const
    sv2= 'com/sun/star/'; sv3= '.html';
  var
    x2: Integer; nsv2: String;
  begin
    Result:= false;  x2:= Pos(sv2, SDKindexLine);   if x2=0 then exit;
    nsv2:= Copy(SDKindexLine, x2, 1000);
    x2:= Pos(sv3, nsv2);  Delete(nsv2, x2, 1000);    // isolate service name
    nsv2:= StringReplace(nsv2, '/', '.', [rfReplaceAll]);
    x2:= serviceGrid.Cols[0].IndexOf(nsv2);  // search in supported services
    Result:= (x2 >= 0);
  end;

  procedure displayPage(htmlLine: String);
  const
    mark1= '<dt><a href="../';  mark2= '.html';
  var
    pageAddr: String;
  begin
    pageAddr:= Copy(htmlLine, Pos(mark1, htmlLine) +Length(mark1), 1000);
    Delete(pageAddr, Pos(mark2, pageAddr), 1000);
    pageAddr:= StringReplace(pageAddr, '/', '\', [rfReplaceAll]);
    displayAPIpage(pageAddr, searchName);
  end;

  procedure createThenDisplayPage(searchName: String; isSupportedProp: Boolean);
  Const
    myPage1= '<html> <head> <title>Xray results</title> <base href="';
    myPage2= '"> </head> <body> ';
    myPage3= ' <dl> ';
    myPage4= '</dl> </body> </html>';
    htmlP= ' <p>';   htmlBR= '<BR>';
  var
    pageRelais: TStringList;  tempFilesPath, myTempFile: String;
  begin
    pageRelais:= TStringList.Create;
    pageRelais.Add(myPage1 +convertToURL(SDKaddr +'docs\common\ref\index-files\') +myPage2);
    if not isSupportedProp  then
      pageRelais.Add(XrayMess86 +htmlBR +XrayMess87 +htmlP);
    pageRelais.Add(Format(XrayMess83, [searchName]) +myPage3);
    pageRelais.AddStrings(bkLines);
    pageRelais.Add(myPage4);
    tempFilesPath:= GetEnvironmentVariable('TMP');
    if tempFilesPath = '' then tempFilesPath:= GetEnvironmentVariable('TEMP');
    myTempFile:= tempFilesPath +'\XrayResults.html';
    pageRelais.SaveToFile(myTempFile);
    pageRelais.Free;
    if useDefaultBrowser then
      ShellExecute(0, 'open', PChar(myTempFile), nil, nil, SW_SHOW)
    else
      ShellExecute(0, 'open', PChar(myBrowser), PChar(myTempFile), nil, SW_SHOW)
  end;

var
  oneLine, htmlName, docAddr: String; w: Integer; isSupportedProp: Boolean;
begin  { ----------- TxrayForm1.findPropertyBookmarks ----------- }
  docAddr:= SDKaddr +'docs\common\ref\index-files\index-'
            +IntToStr(ord(UpCase(searchName[1])) -ord('A') +1) +'.html';
  unePageSDK:= TStringList.Create;  bkLines:= TStringList.Create;
  unePageSDK.LoadFromFile(docAddr); isSupportedProp:= False;
  htmlName:= '<b>' + searchName + '</b></a> - ' +prop_attrib;
  for w:= 0 to unePageSDK.Count -1 do begin // search a supported service having this property
    oneLine:= unePageSDK.Strings[w];
    if AnsiContainsText(oneLine, htmlName) and validContext(oneLine)  then begin
      bkLines.Add(oneLine); isSupportedProp:= True;
    end;
  end;
  if not isSupportedProp then begin  // search any service having this property
    for w:= 0 to unePageSDK.Count -1 do begin
      oneLine:= unePageSDK.Strings[w];
      if AnsiContainsText(oneLine, htmlName)  then
        bkLines.Add(oneLine);
    end;
  end;
  if bkLines.Count = 0  then
    MessageDlg(XrayMess80, mtInformation, [mbOK], 0)  // no page in the SDK
  else if bkLines.Count = 1  then begin  // one page of the SDK is found
    if not isSupportedProp then
      MessageDlg(XrayMess86 +#13 +XrayMess87, mtInformation, [mbOK], 0);
    displayPage(bkLines.Strings[0])
  end else  // several pages found in the SDK
    createThenDisplayPage(searchName, isSupportedProp);
  unePageSDK.Free;  bkLines.Free;
end;



procedure TxrayForm1.searchAPIBtnClick(Sender: TObject);
var
  x, y, y2: Integer; methodName, propName, getsetp, structName: String;
begin
  if not FileExists(SDKaddr +'docs\common\ref\index-files\index-1.html')  then begin
    MessageDlg(XrayMess84, mtInformation, [mbOK], 0); // Could not find the SDK
    Exit;
  end;
  if not useDefaultBrowser and not FileExists(myBrowser)  then begin
    MessageDlg(XrayMess85, mtInformation, [mbOK], 0); // Could not find the Browser
    Exit;
  end;

  if Pos(XrayMess62, ImplementName.Text) = 1  then begin // structure is displayed
    structName:= MidStr(ImplementName.Text, Length(XrayMess62) +1, 200);
    displayAPIpage(structName);    exit;
  end;
  Case PageControl1.ActivePageIndex of
  0: begin // property
      y:= propGrid.Selection.Top;  propName:= propGrid.Cells[0,y];
      if Pos(mess60, propGrid.Cells[3, y]) > 0 then begin // pseudo-property
        y2:= methGrid.Cols[0].IndexOf('get' +propName);
        if y2 < 0 then  begin
          y2:= methGrid.Cols[0].IndexOf('set' +propName);
          if y2 < 0 then begin
            MessageDlg(XrayMess81, mtInformation, [mbOK], 0);  // impossible to find pseudo-property
            exit;
          end else
            getsetp:= 'set' +propName;
        end else
          if methGrid.Cols[0].IndexOf('set' +propName) > 0 then
              getsetp:= 'get' +propName + ' / set' +propName
            else
              getsetp:= 'get' +propName;

        MessageDlg(Format(XrayMess82, [getsetp]), mtInformation, [mbOK], 0);
        methodName:= methGrid.Cells[0, y2];
        displayAPIpage(methGrid.Cells[3, y2], methodName);
      end else if Pos(mess59, propGrid.Cells[3, y]) > 0 then
        findPropertyBookmarks(propName, 'attribute')
      else
        findPropertyBookmarks(propName, 'property');
    end;
  1: begin; // methods - > interface page
      y:= methGrid.Selection.Top;
      methodName:= methGrid.Cells[0,y];
      displayAPIpage(methGrid.Cells[3, y], methodName);
    end;
  2: begin // service
      x:= serviceGrid.Selection.Left;  y:= serviceGrid.Selection.Top;
      displayAPIpage(serviceGrid.Cells[x,y]);
    end;
  3: begin // interface
      x:= interfaceGrid.Selection.Left;  y:= interfaceGrid.Selection.Top;
      displayAPIpage(interfaceGrid.Cells[x,y]);
    end;
  end;
end;



procedure TxrayForm1.SaveBtnClick(Sender: TObject);

  procedure writeCalcPage(oneGrid: TStringGrid; mySheet: Variant; sheetName: String);
  var
    x, y: Integer;  oneCol: TStrings;   myColumn, firstLine, myCell: Variant;
  begin
    mySheet.Name:= sheetName;
    firstLine:= mySheet.Rows.getByIndex(0);
    firstLine.CharWeight:= _awtFontWeightBOLD;
    firstLine.CellBackColor:= RGB(100, 255, 255);
    for x:= 0 to oneGrid.ColCount -1 do begin
      oneCol:= oneGrid.Cols[x];
      for y:= 0 to oneCol.Count -1 do begin
        if oneCol.Strings[y] <> '' then begin
          myCell:= mySheet.getCellByPosition(x, y);
          myCell.String:= oneCol.Strings[y];
        end;
        if (y mod 20) = 0   then  Application.ProcessMessages;
      end;
      myColumn:= mySheet.Columns.getByIndex(x);
      myColumn.OptimalWidth:= true; // adjust column width
    end;
  end;

var
  fileAddress: String;  myDoc, allSheets, loadProp: Variant;
begin  { ---------  TxrayForm1.SaveBtnClick --------- }
  if not SaveDialog1.Execute then exit;
  Screen.Cursor:= crHourglass;       Application.ProcessMessages;
  try
    fileAddress:= 'private:factory/scalc';   // nouveau document Calc
    loadProp:= CreateProperties(['Hidden', true]);
    myDoc:= StarDesktop.LoadComponentFromURL(fileAddress, '_blank', 0, loadProp);
    // a new Calc document has 3 sheets
    allSheets:= myDoc.Sheets;
    allSheets.insertNewByName('oneMore', 3); // create a new sheet
    writeCalcPage(propGrid,      allSheets.getByIndex(0), 'Properties');
    writeCalcPage(methGrid,      allSheets.getByIndex(1), 'Methods');
    writeCalcPage(serviceGrid,   allSheets.getByIndex(2), 'Services');
    writeCalcPage(interfaceGrid, allSheets.getByIndex(3), 'Interfaces');
    fileAddress:= convertToURL(SaveDialog1.FileName);
    myDoc.storeAsURL(fileAddress, dummyArray);
    myDoc.close(True);
  finally
    Screen.Cursor:= crDefault;
  end;
  MessageDlg(XrayMess88, mtInformation, [mbOK], 0)  // end of work
end;


procedure TxrayForm1.XrayBtnClick(Sender: TObject);
begin
  Case PageControl1.ActivePageIndex of
  0 : propGridDblClick(Sender);
  1 : methGridDblClick(Sender);
  end;
end;

procedure TxrayForm1.propGridContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  y: Integer; triage, newRow: TStringList; aLine: String;
begin
  if propGrid.Tag <> 0  then begin
    propGrid.RowCount:= 2;   propGrid.Rows[1].Clear;
    Screen.Cursor:= crHourglass;
    try
      if not objectIsStructure  then extractProperties;
    finally
      Screen.Cursor:= crDefault;
    end;
    propGrid.Cells[0,0]:= XrayMess10;   propGrid.Tag:= 0;  // unsorted properties
  end else begin
    triage:= TStringList.Create;  newRow:= TStringList.Create;
    with triage do begin  // sort properties list
      Duplicates:= dupIgnore;  CaseSensitive:= True;  Sorted:= True;
      for y:= 0 to propGrid.RowCount-1 do begin
        aLine:= propGrid.Rows[y].Text;   Add(aLine);
      end;
      for y:= 0 to Count -1 do begin
        newRow.Text:= Strings[y];   propGrid.Rows[y].Assign(newRow);
        newRow.Clear;
      end;
    end;
    propGrid.Cells[0,0]:= XrayMess10T;   propGrid.Tag:= 1; // sorted properties
    triage.Free;  newRow.Free;
  end;
end;

procedure TxrayForm1.methGridContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  y: Integer; triage, newRow: TStringList; aLine: String;
begin
  if methGrid.Tag <> 0  then begin
    methGrid.RowCount:= 2;   methGrid.Rows[1].Clear;
    Screen.Cursor:= crHourglass;
    try
      extractMethods;
    finally
      Screen.Cursor:= crDefault;
    end;
    methGrid.Cells[0,0]:= XrayMess20;   methGrid.Tag:= 0;  // unsorted methods
  end else begin
    triage:= TStringList.Create;  newRow:= TStringList.Create;
    with triage do begin  // sort methods list
      Duplicates:= dupIgnore;  CaseSensitive:= True;  Sorted:= True;
      for y:= 0 to methGrid.RowCount-1 do begin
        aLine:= methGrid.Rows[y].Text;   Add(aLine);
      end;
      for y:= 0 to Count -1 do begin
        newRow.Text:= Strings[y];  methGrid.Rows[y].Assign(newRow);
        newRow.Clear;
      end;
    end;
    methGrid.Cells[0,0]:= XrayMess20T;   methGrid.Tag:= 1; // sorted methods
    triage.Free;  newRow.Free;
  end;
end;



end.
