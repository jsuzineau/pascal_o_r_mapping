{
This unit has been produced by ws_helper.
  Input unit name : "svn".
  This unit name  : "svn".
  Date            : "21/12/2015 18:31:23".
}
unit svn;
{$IFDEF FPC}
  {$mode objfpc} {$H+}
{$ENDIF}
{$DEFINE WST_RECORD_RTTI}
interface

uses SysUtils, Classes, TypInfo, base_service_intf, service_intf;

const
  sNAME_SPACE = 'https://192.168.1.35/soap/svn';
  sUNIT_NAME = 'svn';

type

  ArrayOfstring = class;
  ArrayOfSvnPathDetails = class;
  ArrayOfRevision = class;
  ArrayOfCommiter = class;
  ArrayOfSvnPathInfo = class;
  ArrayOfInteger = class;
  ArrayOflong = class;
  ArrayOfint = class;
  Revision = class;
  Commiter = class;
  SvnPathInfo = class;
  SvnPathDetails = class;
  UserInfo = class;
  ArrayOfUserInfo = class;
  DescField = class;
  ArrayOfDescFields = class;
  DescFieldValue = class;
  ArrayOfDescFieldsValues = class;
  ServiceValue = class;
  ArrayOfServicesValues = class;

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

  ArrayOfSvnPathDetails = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): SvnPathDetails;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : SvnPathDetails Read GetItem;Default;
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

  ArrayOfUserInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): UserInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : UserInfo Read GetItem;Default;
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

  TuleapSubversionAPIPortType = interface(IInvokable)
    ['{165EAD6F-3E1D-4484-B1CD-5B279CB4FE3C}']
    function getSvnPath(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  path : UnicodeString
    ):ArrayOfstring;
    function getSvnPathsWithLogDetails(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  path : UnicodeString; 
      const  sort : UnicodeString
    ):ArrayOfSvnPathDetails;
    function getSvnLog(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  limit : integer; 
      const  author_id : integer
    ):ArrayOfRevision;
    function getSvnStatsUsers(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  start_date : integer; 
      const  end_date : integer
    ):ArrayOfCommiter;
    function getSvnStatsFiles(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  start_date : integer; 
      const  end_date : integer; 
      const  limit : integer
    ):ArrayOfSvnPathInfo;
  end;

  procedure Register_svn_ServiceMetadata();

Implementation
uses metadata_repository, record_rtti, wst_types;

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

{ ArrayOfSvnPathDetails }

function ArrayOfSvnPathDetails.GetItem(AIndex: Integer): SvnPathDetails;
begin
  Result := SvnPathDetails(Inherited GetItem(AIndex));
end;

class function ArrayOfSvnPathDetails.GetItemClass(): TBaseRemotableClass;
begin
  Result:= SvnPathDetails;
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

{ ArrayOfUserInfo }

function ArrayOfUserInfo.GetItem(AIndex: Integer): UserInfo;
begin
  Result := UserInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfUserInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= UserInfo;
end;

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


procedure Register_svn_ServiceMetadata();
var
  mm : IModuleMetadataMngr;
begin
  mm := GetModuleMetadataMngr();
  mm.SetRepositoryNameSpace(sUNIT_NAME, sNAME_SPACE);
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'TRANSPORT_Address',
    'https://192.168.1.35:443/soap/svn/'
  );
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'FORMAT_Style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPath',
    '_E_N_',
    'getSvnPath'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPath',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPath',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/svn#getSvnPath'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPath',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPath',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPathsWithLogDetails',
    '_E_N_',
    'getSvnPathsWithLogDetails'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPathsWithLogDetails',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPathsWithLogDetails',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/svn#getSvnPathsWithLogDetails'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPathsWithLogDetails',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnPathsWithLogDetails',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnLog',
    '_E_N_',
    'getSvnLog'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnLog',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnLog',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/svn#getSvnLog'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnLog',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnLog',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsUsers',
    '_E_N_',
    'getSvnStatsUsers'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsUsers',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsUsers',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/svn#getSvnStatsUsers'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsUsers',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsUsers',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsFiles',
    '_E_N_',
    'getSvnStatsFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsFiles',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsFiles',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/soap/svn#getSvnStatsFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsFiles',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapSubversionAPIPortType',
    'getSvnStatsFiles',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
end;


var
  typeRegistryInstance : TTypeRegistry = nil;
initialization
  typeRegistryInstance := GetTypeRegistry();

  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Revision),'Revision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Commiter),'Commiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathInfo),'SvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathDetails),'SvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(UserInfo),'UserInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescField),'DescField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescFieldValue),'DescFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ServiceValue),'ServiceValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfstring),'ArrayOfstring');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathDetails),'ArrayOfSvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfRevision),'ArrayOfRevision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfCommiter),'ArrayOfCommiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathInfo),'ArrayOfSvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfInteger),'ArrayOfInteger');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOflong),'ArrayOflong');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfint),'ArrayOfint');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUserInfo),'ArrayOfUserInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFields),'ArrayOfDescFields');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFieldsValues),'ArrayOfDescFieldsValues');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfServicesValues),'ArrayOfServicesValues');



End.
