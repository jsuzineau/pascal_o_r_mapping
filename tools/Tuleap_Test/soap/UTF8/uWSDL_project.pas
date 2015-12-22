{
This unit has been produced by ws_helper.
  Input unit name : "uWSDL_project".
  This unit name  : "uWSDL_project".
  Date            : "21/12/2015 18:48:32".
}
unit uWSDL_project;
{$IFDEF FPC}
  {$mode objfpc} {$H+}
{$ENDIF}
{$DEFINE WST_RECORD_RTTI}
interface

uses SysUtils, Classes, TypInfo, base_service_intf, service_intf;

const
  sNAME_SPACE = 'https://192.168.1.35/soap/project';
  sUNIT_NAME = 'uWSDL_project';

type

  UserInfo = class;
  ArrayOfDescFields = class;
  ArrayOfDescFieldsValues = class;
  ArrayOfServicesValues = class;
  ArrayOfstring = class;
  ArrayOfInteger = class;
  ArrayOflong = class;
  ArrayOfint = class;
  Revision = class;
  ArrayOfRevision = class;
  Commiter = class;
  ArrayOfCommiter = class;
  SvnPathInfo = class;
  ArrayOfSvnPathInfo = class;
  SvnPathDetails = class;
  ArrayOfSvnPathDetails = class;
  ArrayOfUserInfo = class;
  DescField = class;
  DescFieldValue = class;
  ServiceValue = class;

  UserInfo = class(TBaseComplexRemotable)
  private
    Fidentifier : UnicodeString;
    Fusername : UnicodeString;
    Fid : UnicodeString;
    Freal_name : UnicodeString;
    Femail : UnicodeString;
    Fldap_id : UnicodeString;
  published
    property identifier : UnicodeString read Fidentifier write Fidentifier;
    property username : UnicodeString read Fusername write Fusername;
    property id : UnicodeString read Fid write Fid;
    property real_name : UnicodeString read Freal_name write Freal_name;
    property email : UnicodeString read Femail write Femail;
    property ldap_id : UnicodeString read Fldap_id write Fldap_id;
  end;

  Revision = class(TBaseComplexRemotable)
  private
    Frevision : UnicodeString;
    Fauthor : UnicodeString;
    Fdate : UnicodeString;
    Fmessage : UnicodeString;
  published
    property revision : UnicodeString read Frevision write Frevision;
    property author : UnicodeString read Fauthor write Fauthor;
    property date : UnicodeString read Fdate write Fdate;
    property message : UnicodeString read Fmessage write Fmessage;
  end;

  Commiter = class(TBaseComplexRemotable)
  private
    Fuser_id : integer;
    Fcommit_count : integer;
  published
    property user_id : integer read Fuser_id write Fuser_id;
    property commit_count : integer read Fcommit_count write Fcommit_count;
  end;

  SvnPathInfo = class(TBaseComplexRemotable)
  private
    Fpath : UnicodeString;
    Fcommit_count : integer;
  published
    property path : UnicodeString read Fpath write Fpath;
    property commit_count : integer read Fcommit_count write Fcommit_count;
  end;

  SvnPathDetails = class(TBaseComplexRemotable)
  private
    Fpath : UnicodeString;
    Fauthor : integer;
    Fmessage : UnicodeString;
    Ftimestamp : integer;
  published
    property path : UnicodeString read Fpath write Fpath;
    property author : integer read Fauthor write Fauthor;
    property message : UnicodeString read Fmessage write Fmessage;
    property timestamp : integer read Ftimestamp write Ftimestamp;
  end;

  DescField = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fname : UnicodeString;
    Fis_mandatory : integer;
  published
    property id : integer read Fid write Fid;
    property name : UnicodeString read Fname write Fname;
    property is_mandatory : integer read Fis_mandatory write Fis_mandatory;
  end;

  DescFieldValue = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fvalue : UnicodeString;
  published
    property id : integer read Fid write Fid;
    property value : UnicodeString read Fvalue write Fvalue;
  end;

  ServiceValue = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fshort_name : UnicodeString;
    Fis_used : integer;
  published
    property id : integer read Fid write Fid;
    property short_name : UnicodeString read Fshort_name write Fshort_name;
    property is_used : integer read Fis_used write Fis_used;
  end;

  ArrayOfDescFields = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): DescField;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : DescField Read GetItem;Default;
  end;

  ArrayOfDescFieldsValues = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): DescFieldValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : DescFieldValue Read GetItem;Default;
  end;

  ArrayOfServicesValues = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ServiceValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ServiceValue Read GetItem;Default;
  end;

  ArrayOfstring = class(TBaseSimpleTypeArrayRemotable)
  private
    FData : array of UnicodeString;
  private
    function GetItem(AIndex: Integer): UnicodeString;
    procedure SetItem(AIndex: Integer; const AValue: UnicodeString);
  protected
    function GetLength():Integer;override;
    procedure SaveItem(AStore : IFormatterBase;const AName : String;const AIndex : Integer);override;
    procedure LoadItem(AStore : IFormatterBase;const AIndex : Integer);override;
  public
    class function GetItemTypeInfo():PTypeInfo;override;
    procedure SetLength(const ANewSize : Integer);override;
    procedure Assign(Source: TPersistent); override;
    property Item[AIndex:Integer] : UnicodeString read GetItem write SetItem; default;
  end;

  ArrayOfInteger = class(TBaseSimpleTypeArrayRemotable)
  private
    FData : array of integer;
  private
    function GetItem(AIndex: Integer): integer;
    procedure SetItem(AIndex: Integer; const AValue: integer);
  protected
    function GetLength():Integer;override;
    procedure SaveItem(AStore : IFormatterBase;const AName : String;const AIndex : Integer);override;
    procedure LoadItem(AStore : IFormatterBase;const AIndex : Integer);override;
  public
    class function GetItemTypeInfo():PTypeInfo;override;
    procedure SetLength(const ANewSize : Integer);override;
    procedure Assign(Source: TPersistent); override;
    property Item[AIndex:Integer] : integer read GetItem write SetItem; default;
  end;

  ArrayOflong = class(TBaseSimpleTypeArrayRemotable)
  private
    FData : array of Int64;
  private
    function GetItem(AIndex: Integer): Int64;
    procedure SetItem(AIndex: Integer; const AValue: Int64);
  protected
    function GetLength():Integer;override;
    procedure SaveItem(AStore : IFormatterBase;const AName : String;const AIndex : Integer);override;
    procedure LoadItem(AStore : IFormatterBase;const AIndex : Integer);override;
  public
    class function GetItemTypeInfo():PTypeInfo;override;
    procedure SetLength(const ANewSize : Integer);override;
    procedure Assign(Source: TPersistent); override;
    property Item[AIndex:Integer] : Int64 read GetItem write SetItem; default;
  end;

  ArrayOfint = class(TBaseSimpleTypeArrayRemotable)
  private
    FData : array of integer;
  private
    function GetItem(AIndex: Integer): integer;
    procedure SetItem(AIndex: Integer; const AValue: integer);
  protected
    function GetLength():Integer;override;
    procedure SaveItem(AStore : IFormatterBase;const AName : String;const AIndex : Integer);override;
    procedure LoadItem(AStore : IFormatterBase;const AIndex : Integer);override;
  public
    class function GetItemTypeInfo():PTypeInfo;override;
    procedure SetLength(const ANewSize : Integer);override;
    procedure Assign(Source: TPersistent); override;
    property Item[AIndex:Integer] : integer read GetItem write SetItem; default;
  end;

  ArrayOfRevision = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Revision;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Revision Read GetItem;Default;
  end;

  ArrayOfCommiter = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Commiter;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Commiter Read GetItem;Default;
  end;

  ArrayOfSvnPathInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): SvnPathInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : SvnPathInfo Read GetItem;Default;
  end;

  ArrayOfSvnPathDetails = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): SvnPathDetails;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : SvnPathDetails Read GetItem;Default;
  end;

  ArrayOfUserInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): UserInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : UserInfo Read GetItem;Default;
  end;

  TuleapProjectAPIPortType = interface(IInvokable)
    ['{DB799B1E-13AD-4401-AD77-F8D915938EBC}']
    function addProject(
      const  sessionKey : UnicodeString; 
      const  adminSessionKey : UnicodeString; 
      const  shortName : UnicodeString; 
      const  publicName : UnicodeString; 
      const  privacy : UnicodeString; 
      const  templateId : integer
    ):integer;
    function addProjectMember(
      const  sessionKey : UnicodeString; 
      const  groupId : integer; 
      const  userLogin : UnicodeString
    ):boolean;
    function removeProjectMember(
      const  sessionKey : UnicodeString; 
      const  groupId : integer; 
      const  userLogin : UnicodeString
    ):boolean;
    function addUserToUGroup(
      const  sessionKey : UnicodeString; 
      const  groupId : integer; 
      const  ugroupId : integer; 
      const  userId : integer
    ):boolean;
    function removeUserFromUGroup(
      const  sessionKey : UnicodeString; 
      const  groupId : integer; 
      const  ugroupId : integer; 
      const  userId : integer
    ):boolean;
    function setProjectGenericUser(
      const  session_key : UnicodeString; 
      const  group_id : integer; 
      const  password : UnicodeString
    ):UserInfo;
    procedure unsetGenericUser(
      const  session_key : UnicodeString; 
      const  groupId : integer
    );
    function getProjectGenericUser(
      const  sessionKey : UnicodeString; 
      const  groupId : integer
    ):UserInfo;
    function getPlateformProjectDescriptionFields(
      const  sessionKey : UnicodeString
    ):ArrayOfDescFields;
    procedure setProjectDescriptionFieldValue(
      const  session_key : UnicodeString; 
      const  group_id : integer; 
      const  field_id_to_update : integer; 
      const  field_value : UnicodeString
    );
    function getProjectDescriptionFieldsValue(
      const  session_key : UnicodeString; 
      const  group_id : integer
    ):ArrayOfDescFieldsValues;
    function getProjectServicesUsage(
      const  session_key : UnicodeString; 
      const  group_id : integer
    ):ArrayOfServicesValues;
    function activateService(
      const  session_key : UnicodeString; 
      const  group_id : integer; 
      const  service_id : integer
    ):boolean;
    function deactivateService(
      const  session_key : UnicodeString; 
      const  group_id : integer; 
      const  service_id : integer
    ):boolean;
  end;

  procedure Register_uWSDL_project_ServiceMetadata();

Implementation
uses metadata_repository, record_rtti, wst_types;

{ ArrayOfDescFields }

function ArrayOfDescFields.GetItem(AIndex: Integer): DescField;
begin
  Result := DescField(Inherited GetItem(AIndex));
end;

class function ArrayOfDescFields.GetItemClass(): TBaseRemotableClass;
begin
  Result:= DescField;
end;

{ ArrayOfDescFieldsValues }

function ArrayOfDescFieldsValues.GetItem(AIndex: Integer): DescFieldValue;
begin
  Result := DescFieldValue(Inherited GetItem(AIndex));
end;

class function ArrayOfDescFieldsValues.GetItemClass(): TBaseRemotableClass;
begin
  Result:= DescFieldValue;
end;

{ ArrayOfServicesValues }

function ArrayOfServicesValues.GetItem(AIndex: Integer): ServiceValue;
begin
  Result := ServiceValue(Inherited GetItem(AIndex));
end;

class function ArrayOfServicesValues.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ServiceValue;
end;

{ ArrayOfstring }

function ArrayOfstring.GetItem(AIndex: Integer): UnicodeString;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOfstring.SetItem(AIndex: Integer;const AValue: UnicodeString);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOfstring.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOfstring.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(UnicodeString),FData[AIndex]);
end;

procedure ArrayOfstring.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(UnicodeString),sName,FData[AIndex]);
end;

class function ArrayOfstring.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(UnicodeString);
end;

procedure ArrayOfstring.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOfstring.Assign(Source: TPersistent);
var
  src : ArrayOfstring;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOfstring) then begin
    src := ArrayOfstring(Source);
    c := src.Length;
    Self.SetLength(c);
    if ( c > 0 ) then begin
      for i := 0 to Pred(c) do begin
        Self[i] := src[i];
      end;
    end;
  end else begin
    inherited Assign(Source);
  end;
end;

{ ArrayOfInteger }

function ArrayOfInteger.GetItem(AIndex: Integer): integer;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOfInteger.SetItem(AIndex: Integer;const AValue: integer);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOfInteger.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOfInteger.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(integer),FData[AIndex]);
end;

procedure ArrayOfInteger.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(integer),sName,FData[AIndex]);
end;

class function ArrayOfInteger.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(integer);
end;

procedure ArrayOfInteger.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOfInteger.Assign(Source: TPersistent);
var
  src : ArrayOfInteger;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOfInteger) then begin
    src := ArrayOfInteger(Source);
    c := src.Length;
    Self.SetLength(c);
    if ( c > 0 ) then begin
      for i := 0 to Pred(c) do begin
        Self[i] := src[i];
      end;
    end;
  end else begin
    inherited Assign(Source);
  end;
end;

{ ArrayOflong }

function ArrayOflong.GetItem(AIndex: Integer): Int64;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOflong.SetItem(AIndex: Integer;const AValue: Int64);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOflong.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOflong.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(Int64),FData[AIndex]);
end;

procedure ArrayOflong.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(Int64),sName,FData[AIndex]);
end;

class function ArrayOflong.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(Int64);
end;

procedure ArrayOflong.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOflong.Assign(Source: TPersistent);
var
  src : ArrayOflong;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOflong) then begin
    src := ArrayOflong(Source);
    c := src.Length;
    Self.SetLength(c);
    if ( c > 0 ) then begin
      for i := 0 to Pred(c) do begin
        Self[i] := src[i];
      end;
    end;
  end else begin
    inherited Assign(Source);
  end;
end;

{ ArrayOfint }

function ArrayOfint.GetItem(AIndex: Integer): integer;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOfint.SetItem(AIndex: Integer;const AValue: integer);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOfint.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOfint.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(integer),FData[AIndex]);
end;

procedure ArrayOfint.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(integer),sName,FData[AIndex]);
end;

class function ArrayOfint.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(integer);
end;

procedure ArrayOfint.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOfint.Assign(Source: TPersistent);
var
  src : ArrayOfint;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOfint) then begin
    src := ArrayOfint(Source);
    c := src.Length;
    Self.SetLength(c);
    if ( c > 0 ) then begin
      for i := 0 to Pred(c) do begin
        Self[i] := src[i];
      end;
    end;
  end else begin
    inherited Assign(Source);
  end;
end;

{ ArrayOfRevision }

function ArrayOfRevision.GetItem(AIndex: Integer): Revision;
begin
  Result := Revision(Inherited GetItem(AIndex));
end;

class function ArrayOfRevision.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Revision;
end;

{ ArrayOfCommiter }

function ArrayOfCommiter.GetItem(AIndex: Integer): Commiter;
begin
  Result := Commiter(Inherited GetItem(AIndex));
end;

class function ArrayOfCommiter.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Commiter;
end;

{ ArrayOfSvnPathInfo }

function ArrayOfSvnPathInfo.GetItem(AIndex: Integer): SvnPathInfo;
begin
  Result := SvnPathInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfSvnPathInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= SvnPathInfo;
end;

{ ArrayOfSvnPathDetails }

function ArrayOfSvnPathDetails.GetItem(AIndex: Integer): SvnPathDetails;
begin
  Result := SvnPathDetails(Inherited GetItem(AIndex));
end;

class function ArrayOfSvnPathDetails.GetItemClass(): TBaseRemotableClass;
begin
  Result:= SvnPathDetails;
end;

{ ArrayOfUserInfo }

function ArrayOfUserInfo.GetItem(AIndex: Integer): UserInfo;
begin
  Result := UserInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfUserInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= UserInfo;
end;


procedure Register_uWSDL_project_ServiceMetadata();
var
  mm : IModuleMetadataMngr;
begin
  mm := GetModuleMetadataMngr();
  mm.SetRepositoryNameSpace(sUNIT_NAME, sNAME_SPACE);
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'TRANSPORT_Address',
    'https://192.168.1.35:443/soap/project/'
  );
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'FORMAT_Style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProject',
    '_E_N_',
    'addProject'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProject',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProject',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#addProject'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProject',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProject',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProjectMember',
    '_E_N_',
    'addProjectMember'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProjectMember',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProjectMember',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#addProjectMember'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProjectMember',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addProjectMember',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeProjectMember',
    '_E_N_',
    'removeProjectMember'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeProjectMember',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeProjectMember',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#removeProjectMember'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeProjectMember',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeProjectMember',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addUserToUGroup',
    '_E_N_',
    'addUserToUGroup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addUserToUGroup',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addUserToUGroup',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#addUserToUGroup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addUserToUGroup',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'addUserToUGroup',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeUserFromUGroup',
    '_E_N_',
    'removeUserFromUGroup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeUserFromUGroup',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeUserFromUGroup',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#removeUserFromUGroup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeUserFromUGroup',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'removeUserFromUGroup',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectGenericUser',
    '_E_N_',
    'setProjectGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectGenericUser',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectGenericUser',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#setProjectGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectGenericUser',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectGenericUser',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'unsetGenericUser',
    '_E_N_',
    'unsetGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'unsetGenericUser',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'unsetGenericUser',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#unsetGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'unsetGenericUser',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'unsetGenericUser',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectGenericUser',
    '_E_N_',
    'getProjectGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectGenericUser',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectGenericUser',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#getProjectGenericUser'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectGenericUser',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectGenericUser',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getPlateformProjectDescriptionFields',
    '_E_N_',
    'getPlateformProjectDescriptionFields'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getPlateformProjectDescriptionFields',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getPlateformProjectDescriptionFields',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#getPlateformProjectDescriptionFields'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getPlateformProjectDescriptionFields',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getPlateformProjectDescriptionFields',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectDescriptionFieldValue',
    '_E_N_',
    'setProjectDescriptionFieldValue'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectDescriptionFieldValue',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectDescriptionFieldValue',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#setProjectDescriptionFieldValue'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectDescriptionFieldValue',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'setProjectDescriptionFieldValue',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectDescriptionFieldsValue',
    '_E_N_',
    'getProjectDescriptionFieldsValue'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectDescriptionFieldsValue',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectDescriptionFieldsValue',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#getProjectDescriptionFieldsValue'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectDescriptionFieldsValue',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectDescriptionFieldsValue',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectServicesUsage',
    '_E_N_',
    'getProjectServicesUsage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectServicesUsage',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectServicesUsage',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#getProjectServicesUsage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectServicesUsage',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'getProjectServicesUsage',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'activateService',
    '_E_N_',
    'activateService'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'activateService',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'activateService',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#activateService'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'activateService',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'activateService',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'deactivateService',
    '_E_N_',
    'deactivateService'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'deactivateService',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'deactivateService',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/project#deactivateService'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'deactivateService',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapProjectAPIPortType',
    'deactivateService',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
end;


var
  typeRegistryInstance : TTypeRegistry = nil;
initialization
  typeRegistryInstance := GetTypeRegistry();

  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(UserInfo),'UserInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Revision),'Revision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Commiter),'Commiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathInfo),'SvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathDetails),'SvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescField),'DescField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescFieldValue),'DescFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ServiceValue),'ServiceValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFields),'ArrayOfDescFields');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFieldsValues),'ArrayOfDescFieldsValues');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfServicesValues),'ArrayOfServicesValues');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfstring),'ArrayOfstring');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfInteger),'ArrayOfInteger');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOflong),'ArrayOflong');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfint),'ArrayOfint');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfRevision),'ArrayOfRevision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfCommiter),'ArrayOfCommiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathInfo),'ArrayOfSvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathDetails),'ArrayOfSvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUserInfo),'ArrayOfUserInfo');



End.
