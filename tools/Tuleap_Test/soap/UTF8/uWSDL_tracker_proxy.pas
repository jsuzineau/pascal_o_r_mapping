{
This unit has been produced by ws_helper.
  Input unit name : "uWSDL_tracker".
  This unit name  : "uWSDL_tracker_proxy".
  Date            : "21/12/2015 18:49:20".
}

Unit uWSDL_tracker_proxy;
{$IFDEF FPC} {$mode objfpc}{$H+} {$ENDIF}
Interface

Uses SysUtils, Classes, TypInfo, base_service_intf, service_intf, uWSDL_tracker;

Type


  TTuleapTrackerV5APIPortType_Proxy=class(TBaseProxy,uWSDL_tracker.TuleapTrackerV5APIPortType)
  Protected
    class function GetServiceType() : PTypeInfo;override;
    function getVersion():Single;
    function getTrackerList(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfTracker;
    function getTrackerFields(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer
    ):ArrayOfTrackerField;
    function getArtifacts(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer; 
      const  criteria : ArrayOfCriteria; 
      const  offset : integer; 
      const  max_rows : integer
    ):ArtifactQueryResult;
    function addArtifact(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer; 
      const  value : ArrayOfArtifactFieldValue
    ):integer;
    function updateArtifact(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer; 
      const  artifact_id : integer; 
      const  value : ArrayOfArtifactFieldValue; 
      const  comment : UnicodeString; 
      const  comment_format : UnicodeString
    ):integer;
    function getArtifact(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer; 
      const  artifact_id : integer
    ):Artifact;
    function getArtifactsFromReport(
      const  sessionKey : UnicodeString; 
      const  report_id : integer; 
      const  offset : integer; 
      const  max_rows : integer
    ):ArtifactQueryResult;
    function getArtifactAttachmentChunk(
      const  sessionKey : UnicodeString; 
      const  artifact_id : integer; 
      const  attachment_id : integer; 
      const  offset : integer; 
      const  size : integer
    ):UnicodeString;
    function createTemporaryAttachment(
      const  sessionKey : UnicodeString
    ):UnicodeString;
    function appendTemporaryAttachmentChunk(
      const  sessionKey : UnicodeString; 
      const  attachment_name : UnicodeString; 
      const  content : UnicodeString
    ):integer;
    function purgeAllTemporaryAttachments(
      const  sessionKey : UnicodeString
    ):boolean;
    function getTrackerStructure(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer
    ):TrackerStructure;
    function getTrackerReports(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  tracker_id : integer
    ):ArrayOfTrackerReport;
    function getArtifactComments(
      const  sessionKey : UnicodeString; 
      const  artifact_id : integer
    ):ArrayOfArtifactComments;
    function getArtifactHistory(
      const  sessionKey : UnicodeString; 
      const  artifact_id : integer
    ):ArrayOfArtifactHistory;
    function addSelectBoxValues(
      const  sessionKey : UnicodeString; 
      const  tracker_id : integer; 
      const  field_id : integer; 
      const  values : ArrayOfString
    ):boolean;
  End;

  Function wst_CreateInstance_TuleapTrackerV5APIPortType(const AFormat : string = 'SOAP:'; const ATransport : string = 'HTTP:'; const AAddress : string = ''):TuleapTrackerV5APIPortType;

Implementation
uses wst_resources_imp, metadata_repository;


Function wst_CreateInstance_TuleapTrackerV5APIPortType(const AFormat : string; const ATransport : string; const AAddress : string):TuleapTrackerV5APIPortType;
Var
  locAdr : string;
Begin
  locAdr := AAddress;
  if ( locAdr = '' ) then
    locAdr := GetServiceDefaultAddress(TypeInfo(TuleapTrackerV5APIPortType));
  Result := TTuleapTrackerV5APIPortType_Proxy.Create('TuleapTrackerV5APIPortType',AFormat+GetServiceDefaultFormatProperties(TypeInfo(TuleapTrackerV5APIPortType)),ATransport + 'address=' + locAdr);
End;

{ TTuleapTrackerV5APIPortType_Proxy implementation }

class function TTuleapTrackerV5APIPortType_Proxy.GetServiceType() : PTypeInfo;
begin
  result := TypeInfo(uWSDL_tracker.TuleapTrackerV5APIPortType);
end;

function TTuleapTrackerV5APIPortType_Proxy.getVersion():Single;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getVersion', GetTarget(),locCallContext);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Single), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getTrackerList(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfTracker;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getTrackerList', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfTracker), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getTrackerFields(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer
):ArrayOfTrackerField;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getTrackerFields', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfTrackerField), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifacts(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer; 
  const  criteria : ArrayOfCriteria; 
  const  offset : integer; 
  const  max_rows : integer
):ArtifactQueryResult;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifacts', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
      locSerializer.Put('criteria', TypeInfo(ArrayOfCriteria), criteria);
      locSerializer.Put('offset', TypeInfo(integer), offset);
      locSerializer.Put('max_rows', TypeInfo(integer), max_rows);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArtifactQueryResult), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.addArtifact(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer; 
  const  value : ArrayOfArtifactFieldValue
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifact', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
      locSerializer.Put('value', TypeInfo(ArrayOfArtifactFieldValue), value);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.updateArtifact(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer; 
  const  artifact_id : integer; 
  const  value : ArrayOfArtifactFieldValue; 
  const  comment : UnicodeString; 
  const  comment_format : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateArtifact', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('value', TypeInfo(ArrayOfArtifactFieldValue), value);
      locSerializer.Put('comment', TypeInfo(UnicodeString), comment);
      locSerializer.Put('comment_format', TypeInfo(UnicodeString), comment_format);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifact(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer; 
  const  artifact_id : integer
):Artifact;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifact', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Artifact), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifactsFromReport(
  const  sessionKey : UnicodeString; 
  const  report_id : integer; 
  const  offset : integer; 
  const  max_rows : integer
):ArtifactQueryResult;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactsFromReport', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('report_id', TypeInfo(integer), report_id);
      locSerializer.Put('offset', TypeInfo(integer), offset);
      locSerializer.Put('max_rows', TypeInfo(integer), max_rows);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArtifactQueryResult), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifactAttachmentChunk(
  const  sessionKey : UnicodeString; 
  const  artifact_id : integer; 
  const  attachment_id : integer; 
  const  offset : integer; 
  const  size : integer
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactAttachmentChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('attachment_id', TypeInfo(integer), attachment_id);
      locSerializer.Put('offset', TypeInfo(integer), offset);
      locSerializer.Put('size', TypeInfo(integer), size);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.createTemporaryAttachment(
  const  sessionKey : UnicodeString
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createTemporaryAttachment', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.appendTemporaryAttachmentChunk(
  const  sessionKey : UnicodeString; 
  const  attachment_name : UnicodeString; 
  const  content : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('appendTemporaryAttachmentChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('attachment_name', TypeInfo(UnicodeString), attachment_name);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.purgeAllTemporaryAttachments(
  const  sessionKey : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('purgeAllTemporaryAttachments', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getTrackerStructure(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer
):TrackerStructure;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getTrackerStructure', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(TrackerStructure), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getTrackerReports(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  tracker_id : integer
):ArrayOfTrackerReport;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getTrackerReports', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfTrackerReport), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifactComments(
  const  sessionKey : UnicodeString; 
  const  artifact_id : integer
):ArrayOfArtifactComments;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactComments', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactComments), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.getArtifactHistory(
  const  sessionKey : UnicodeString; 
  const  artifact_id : integer
):ArrayOfArtifactHistory;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactHistory', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactHistory), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TTuleapTrackerV5APIPortType_Proxy.addSelectBoxValues(
  const  sessionKey : UnicodeString; 
  const  tracker_id : integer; 
  const  field_id : integer; 
  const  values : ArrayOfString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addSelectBoxValues', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('tracker_id', TypeInfo(integer), tracker_id);
      locSerializer.Put('field_id', TypeInfo(integer), field_id);
      locSerializer.Put('values', TypeInfo(ArrayOfString), values);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;


initialization
  {$i uWSDL_tracker.wst}

  {$IF DECLARED(Register_uWSDL_tracker_ServiceMetadata)}
  Register_uWSDL_tracker_ServiceMetadata();
  {$IFEND}
End.
