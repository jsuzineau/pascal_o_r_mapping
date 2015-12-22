{
This unit has been produced by ws_helper.
  Input unit name : "uWSDL_svn".
  This unit name  : "uWSDL_svn_proxy".
  Date            : "21/12/2015 18:48:58".
}

Unit uWSDL_svn_proxy;
{$IFDEF FPC} {$mode objfpc}{$H+} {$ENDIF}
Interface

Uses SysUtils, Classes, TypInfo, base_service_intf, service_intf, uWSDL_svn;

Type


  TTuleapSubversionAPIPortType_Proxy=class(TBaseProxy,uWSDL_svn.TuleapSubversionAPIPortType)
  Protected
    class function GetServiceType() : PTypeInfo;override;
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
  End;

  Function wst_CreateInstance_TuleapSubversionAPIPortType(const AFormat : string = 'SOAP:'; const ATransport : string = 'HTTP:'; const AAddress : string = ''):TuleapSubversionAPIPortType;

Implementation
uses wst_resources_imp, metadata_repository;


Function wst_CreateInstance_TuleapSubversionAPIPortType(const AFormat : string; const ATransport : string; const AAddress : string):TuleapSubversionAPIPortType;
Var
  locAdr : string;
Begin
  locAdr := AAddress;
  if ( locAdr = '' ) then
    locAdr := GetServiceDefaultAddress(TypeInfo(TuleapSubversionAPIPortType));
  Result := TTuleapSubversionAPIPortType_Proxy.Create('TuleapSubversionAPIPortType',AFormat+GetServiceDefaultFormatProperties(TypeInfo(TuleapSubversionAPIPortType)),ATransport + 'address=' + locAdr);
End;

{ TTuleapSubversionAPIPortType_Proxy implementation }

class function TTuleapSubversionAPIPortType_Proxy.GetServiceType() : PTypeInfo;
begin
  result := TypeInfo(uWSDL_svn.TuleapSubversionAPIPortType);
end;

function TTuleapSubversionAPIPortType_Proxy.getSvnPath(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  path : UnicodeString
):ArrayOfstring;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getSvnPath', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('path', TypeInfo(UnicodeString), path);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getSvnPath';
      locSerializer.Get(TypeInfo(ArrayOfstring), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapSubversionAPIPortType_Proxy.getSvnPathsWithLogDetails(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  path : UnicodeString; 
  const  sort : UnicodeString
):ArrayOfSvnPathDetails;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getSvnPathsWithLogDetails', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('path', TypeInfo(UnicodeString), path);
      locSerializer.Put('sort', TypeInfo(UnicodeString), sort);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getSvnPathsWithLogDetails';
      locSerializer.Get(TypeInfo(ArrayOfSvnPathDetails), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapSubversionAPIPortType_Proxy.getSvnLog(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  limit : integer; 
  const  author_id : integer
):ArrayOfRevision;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getSvnLog', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('limit', TypeInfo(integer), limit);
      locSerializer.Put('author_id', TypeInfo(integer), author_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getSvnLog';
      locSerializer.Get(TypeInfo(ArrayOfRevision), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapSubversionAPIPortType_Proxy.getSvnStatsUsers(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  start_date : integer; 
  const  end_date : integer
):ArrayOfCommiter;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getSvnStatsUsers', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('start_date', TypeInfo(integer), start_date);
      locSerializer.Put('end_date', TypeInfo(integer), end_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getSvnStatsUsers';
      locSerializer.Get(TypeInfo(ArrayOfCommiter), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapSubversionAPIPortType_Proxy.getSvnStatsFiles(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  start_date : integer; 
  const  end_date : integer; 
  const  limit : integer
):ArrayOfSvnPathInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getSvnStatsFiles', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('start_date', TypeInfo(integer), start_date);
      locSerializer.Put('end_date', TypeInfo(integer), end_date);
      locSerializer.Put('limit', TypeInfo(integer), limit);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getSvnStatsFiles';
      locSerializer.Get(TypeInfo(ArrayOfSvnPathInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;


initialization
  {$i uWSDL_svn.wst}

  {$IF DECLARED(Register_uWSDL_svn_ServiceMetadata)}
  Register_uWSDL_svn_ServiceMetadata();
  {$IFEND}
End.
