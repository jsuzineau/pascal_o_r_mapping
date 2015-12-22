{
This unit has been produced by ws_helper.
  Input unit name : "project".
  This unit name  : "project_proxy".
  Date            : "21/12/2015 18:31:46".
}

Unit project_proxy;
{$IFDEF FPC} {$mode objfpc}{$H+} {$ENDIF}
Interface

Uses SysUtils, Classes, TypInfo, base_service_intf, service_intf, project;

Type


  TTuleapProjectAPIPortType_Proxy=class(TBaseProxy,project.TuleapProjectAPIPortType)
  Protected
    class function GetServiceType() : PTypeInfo;override;
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
  End;

  Function wst_CreateInstance_TuleapProjectAPIPortType(const AFormat : string = 'SOAP:'; const ATransport : string = 'HTTP:'; const AAddress : string = ''):TuleapProjectAPIPortType;

Implementation
uses wst_resources_imp, metadata_repository;


Function wst_CreateInstance_TuleapProjectAPIPortType(const AFormat : string; const ATransport : string; const AAddress : string):TuleapProjectAPIPortType;
Var
  locAdr : string;
Begin
  locAdr := AAddress;
  if ( locAdr = '' ) then
    locAdr := GetServiceDefaultAddress(TypeInfo(TuleapProjectAPIPortType));
  Result := TTuleapProjectAPIPortType_Proxy.Create('TuleapProjectAPIPortType',AFormat+GetServiceDefaultFormatProperties(TypeInfo(TuleapProjectAPIPortType)),ATransport + 'address=' + locAdr);
End;

{ TTuleapProjectAPIPortType_Proxy implementation }

class function TTuleapProjectAPIPortType_Proxy.GetServiceType() : PTypeInfo;
begin
  result := TypeInfo(project.TuleapProjectAPIPortType);
end;

function TTuleapProjectAPIPortType_Proxy.addProject(
  const  sessionKey : UnicodeString; 
  const  adminSessionKey : UnicodeString; 
  const  shortName : UnicodeString; 
  const  publicName : UnicodeString; 
  const  privacy : UnicodeString; 
  const  templateId : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addProject', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('adminSessionKey', TypeInfo(UnicodeString), adminSessionKey);
      locSerializer.Put('shortName', TypeInfo(UnicodeString), shortName);
      locSerializer.Put('publicName', TypeInfo(UnicodeString), publicName);
      locSerializer.Put('privacy', TypeInfo(UnicodeString), privacy);
      locSerializer.Put('templateId', TypeInfo(integer), templateId);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addProject';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.addProjectMember(
  const  sessionKey : UnicodeString; 
  const  groupId : integer; 
  const  userLogin : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addProjectMember', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
      locSerializer.Put('userLogin', TypeInfo(UnicodeString), userLogin);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addProjectMember';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.removeProjectMember(
  const  sessionKey : UnicodeString; 
  const  groupId : integer; 
  const  userLogin : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('removeProjectMember', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
      locSerializer.Put('userLogin', TypeInfo(UnicodeString), userLogin);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'removeProjectMember';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.addUserToUGroup(
  const  sessionKey : UnicodeString; 
  const  groupId : integer; 
  const  ugroupId : integer; 
  const  userId : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addUserToUGroup', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
      locSerializer.Put('ugroupId', TypeInfo(integer), ugroupId);
      locSerializer.Put('userId', TypeInfo(integer), userId);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addUserToUGroup';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.removeUserFromUGroup(
  const  sessionKey : UnicodeString; 
  const  groupId : integer; 
  const  ugroupId : integer; 
  const  userId : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('removeUserFromUGroup', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
      locSerializer.Put('ugroupId', TypeInfo(integer), ugroupId);
      locSerializer.Put('userId', TypeInfo(integer), userId);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'removeUserFromUGroup';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.setProjectGenericUser(
  const  session_key : UnicodeString; 
  const  group_id : integer; 
  const  password : UnicodeString
):UserInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('setProjectGenericUser', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('password', TypeInfo(UnicodeString), password);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'setProjectGenericUser';
      locSerializer.Get(TypeInfo(UserInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

procedure TTuleapProjectAPIPortType_Proxy.unsetGenericUser(
  const  session_key : UnicodeString; 
  const  groupId : integer
);
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('unsetGenericUser', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.getProjectGenericUser(
  const  sessionKey : UnicodeString; 
  const  groupId : integer
):UserInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getProjectGenericUser', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('groupId', TypeInfo(integer), groupId);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getProjectGenericUser';
      locSerializer.Get(TypeInfo(UserInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.getPlateformProjectDescriptionFields(
  const  sessionKey : UnicodeString
):ArrayOfDescFields;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getPlateformProjectDescriptionFields', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getPlateformProjectDescriptionFields';
      locSerializer.Get(TypeInfo(ArrayOfDescFields), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

procedure TTuleapProjectAPIPortType_Proxy.setProjectDescriptionFieldValue(
  const  session_key : UnicodeString; 
  const  group_id : integer; 
  const  field_id_to_update : integer; 
  const  field_value : UnicodeString
);
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('setProjectDescriptionFieldValue', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('field_id_to_update', TypeInfo(integer), field_id_to_update);
      locSerializer.Put('field_value', TypeInfo(UnicodeString), field_value);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.getProjectDescriptionFieldsValue(
  const  session_key : UnicodeString; 
  const  group_id : integer
):ArrayOfDescFieldsValues;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getProjectDescriptionFieldsValue', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getProjectDescriptionFieldsValue';
      locSerializer.Get(TypeInfo(ArrayOfDescFieldsValues), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.getProjectServicesUsage(
  const  session_key : UnicodeString; 
  const  group_id : integer
):ArrayOfServicesValues;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getProjectServicesUsage', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getProjectServicesUsage';
      locSerializer.Get(TypeInfo(ArrayOfServicesValues), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.activateService(
  const  session_key : UnicodeString; 
  const  group_id : integer; 
  const  service_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('activateService', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('service_id', TypeInfo(integer), service_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'activateService';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapProjectAPIPortType_Proxy.deactivateService(
  const  session_key : UnicodeString; 
  const  group_id : integer; 
  const  service_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deactivateService', GetTarget(),locCallContext);
      locSerializer.Put('session_key', TypeInfo(UnicodeString), session_key);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('service_id', TypeInfo(integer), service_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'deactivateService';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;


initialization
  {$i project.wst}

  {$IF DECLARED(Register_project_ServiceMetadata)}
  Register_project_ServiceMetadata();
  {$IFEND}
End.
