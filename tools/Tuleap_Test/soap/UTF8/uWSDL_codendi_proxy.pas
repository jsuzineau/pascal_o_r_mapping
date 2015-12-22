{
This unit has been produced by ws_helper.
  Input unit name : "uWSDL_codendi".
  This unit name  : "uWSDL_codendi_proxy".
  Date            : "21/12/2015 18:47:54".
}

Unit uWSDL_codendi_proxy;
{$IFDEF FPC} {$mode objfpc}{$H+} {$ENDIF}
Interface

Uses SysUtils, Classes, TypInfo, base_service_intf, service_intf, uWSDL_codendi;

Type


  TCodendiAPIPortType_Proxy=class(TBaseProxy,uWSDL_codendi.CodendiAPIPortType)
  Protected
    class function GetServiceType() : PTypeInfo;override;
    function login(
      const  loginname : UnicodeString; 
      const  passwd : UnicodeString
    ):Session;
    function loginAs(
      const  admin_session_hash : UnicodeString; 
      const  loginname : UnicodeString
    ):UnicodeString;
    function retrieveSession(
      const  session_hash : UnicodeString
    ):Session;
    function getAPIVersion():UnicodeString;
    procedure logout(
      const  sessionKey : UnicodeString
    );
    function getMyProjects(
      const  sessionKey : UnicodeString
    ):ArrayOfGroup;
    function getGroupByName(
      const  sessionKey : UnicodeString; 
      const  unix_group_name : UnicodeString
    ):Group;
    function getGroupById(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):Group;
    function getGroupUgroups(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfUgroup;
    function getProjectGroupsAndUsers(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfUgroup;
    function checkUsersExistence(
      const  sessionKey : UnicodeString; 
      const  users : ArrayOfstring
    ):ArrayOfUserInfo;
    function getUserInfo(
      const  sessionKey : UnicodeString; 
      const  user_id : integer
    ):UserInfo;
    function getTrackerList(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfTrackerDesc;
    function getArtifactType(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer
    ):ArtifactType;
    function getArtifactTypes(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfArtifactType;
    function getArtifacts(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  criteria : ArrayOfCriteria; 
      const  offset : integer; 
      const  max_rows : integer
    ):ArtifactQueryResult;
    function getArtifactsFromReport(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  report_id : integer; 
      const  criteria : ArrayOfCriteria; 
      const  offset : integer; 
      const  max_rows : integer; 
      const  sort_criteria : ArrayOfSortCriteria
    ):ArtifactFromReportResult;
    function addArtifact(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  status_id : integer; 
      const  close_date : integer; 
      const  summary : UnicodeString; 
      const  details : UnicodeString; 
      const  severity : integer; 
      const  extra_fields : ArrayOfArtifactFieldValue
    ):integer;
    function addArtifactWithFieldNames(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  status_id : integer; 
      const  close_date : integer; 
      const  summary : UnicodeString; 
      const  details : UnicodeString; 
      const  severity : integer; 
      const  extra_fields : ArrayOfArtifactFieldNameValue
    ):integer;
    function updateArtifact(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  status_id : integer; 
      const  close_date : integer; 
      const  summary : UnicodeString; 
      const  details : UnicodeString; 
      const  severity : integer; 
      const  extra_fields : ArrayOfArtifactFieldValue
    ):integer;
    function updateArtifactWithFieldNames(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  status_id : integer; 
      const  close_date : integer; 
      const  summary : UnicodeString; 
      const  details : UnicodeString; 
      const  severity : integer; 
      const  extra_fields : ArrayOfArtifactFieldNameValue
    ):integer;
    function getArtifactFollowups(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactFollowup;
    function getArtifactCannedResponses(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer
    ):ArrayOfArtifactCanned;
    function getArtifactReports(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer
    ):ArrayOfArtifactReport;
    function getArtifactAttachedFiles(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactFile;
    function getArtifactAttachedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  file_id : integer
    ):ArtifactFile;
    function getArtifactById(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):Artifact;
    function getArtifactDependencies(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactDependency;
    function getArtifactInverseDependencies(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactDependency;
    function addArtifactAttachedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  encoded_data : UnicodeString; 
      const  description : UnicodeString; 
      const  filename : UnicodeString; 
      const  filetype : UnicodeString
    ):integer;
    function deleteArtifactAttachedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  file_id : integer
    ):integer;
    function addArtifactDependencies(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  is_dependent_on_artifact_ids : UnicodeString
    ):boolean;
    function deleteArtifactDependency(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  dependent_on_artifact_id : integer
    ):integer;
    function addArtifactFollowup(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  body : UnicodeString; 
      const  comment_type_id : integer; 
      const  format : integer
    ):boolean;
    function updateArtifactFollowUp(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  artifact_history_id : integer; 
      const  comment : UnicodeString
    ):boolean;
    function deleteArtifactFollowUp(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  artifact_history_id : integer
    ):boolean;
    function existArtifactSummary(
      const  sessionKey : UnicodeString; 
      const  group_artifact_id : integer; 
      const  summary : UnicodeString
    ):integer;
    function getArtifactCCList(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactCC;
    function addArtifactCC(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  cc_list : UnicodeString; 
      const  cc_comment : UnicodeString
    ):boolean;
    function deleteArtifactCC(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer; 
      const  artifact_cc_id : integer
    ):boolean;
    function getArtifactHistory(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  group_artifact_id : integer; 
      const  artifact_id : integer
    ):ArrayOfArtifactHistory;
    function getPackages(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfFRSPackage;
    function addPackage(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_name : UnicodeString; 
      const  status_id : integer; 
      const  rank : integer; 
      const  approve_license : boolean
    ):integer;
    function getReleases(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer
    ):ArrayOfFRSRelease;
    function updateRelease(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  notes : UnicodeString; 
      const  changes : UnicodeString; 
      const  status_id : integer
    ):boolean;
    function addRelease(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  name : UnicodeString; 
      const  notes : UnicodeString; 
      const  changes : UnicodeString; 
      const  status_id : integer; 
      const  release_date : integer
    ):integer;
    function getFiles(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer
    ):ArrayOfFRSFile;
    function getFileInfo(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  file_id : integer
    ):FRSFile;
    function getFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  file_id : integer
    ):UnicodeString;
    function getFileChunk(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  file_id : integer; 
      const  offset : integer; 
      const  size : integer
    ):UnicodeString;
    function addFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  filename : UnicodeString; 
      const  base64_contents : UnicodeString; 
      const  type_id : integer; 
      const  processor_id : integer; 
      const  reference_md5 : UnicodeString; 
      const  comment : UnicodeString
    ):integer;
    function addFileChunk(
      const  sessionKey : UnicodeString; 
      const  filename : UnicodeString; 
      const  contents : UnicodeString; 
      const  first_chunk : boolean
    ):integer;
    function addUploadedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  filename : UnicodeString; 
      const  type_id : integer; 
      const  processor_id : integer; 
      const  reference_md5 : UnicodeString; 
      const  comment : UnicodeString
    ):integer;
    function getUploadedFiles(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfstring;
    function deleteFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  file_id : integer
    ):boolean;
    function deleteEmptyPackage(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  cleanup_all : boolean
    ):ArrayOfFRSPackage;
    function deleteEmptyRelease(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  cleanup_all : boolean
    ):ArrayOfFRSRelease;
    function updateFileComment(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  package_id : integer; 
      const  release_id : integer; 
      const  file_id : integer; 
      const  comment : UnicodeString
    ):boolean;
    function getRootFolder(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):integer;
    function listFolder(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer
    ):ArrayOfDocman_Item;
    function searchDocmanItem(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  criterias : ArrayOfCriteria
    ):ArrayOfDocman_Item;
    function getDocmanFileContents(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  version_number : integer
    ):UnicodeString;
    function getDocmanFileMD5sum(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  version_number : integer
    ):UnicodeString;
    function getDocmanFileAllVersionsMD5sum(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer
    ):ArrayOfstring;
    function getDocmanProjectMetadata(
      const  sessionKey : UnicodeString; 
      const  group_id : integer
    ):ArrayOfMetadata;
    function getDocmanTreeInfo(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer
    ):ArrayOfItemInfo;
    function createDocmanFolder(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  file_size : integer; 
      const  file_name : UnicodeString; 
      const  mime_type : UnicodeString; 
      const  content : UnicodeString; 
      const  chunk_offset : integer; 
      const  chunk_size : integer; 
      const  author : UnicodeString; 
      const  date : UnicodeString; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanEmbeddedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  content : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  author : UnicodeString; 
      const  date : UnicodeString; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanWikiPage(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  content : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanLink(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  content : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanEmptyDocument(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  parent_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  ordering : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function createDocmanFileVersion(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  _label : UnicodeString; 
      const  changelog : UnicodeString; 
      const  file_size : integer; 
      const  file_name : UnicodeString; 
      const  mime_type : UnicodeString; 
      const  content : UnicodeString; 
      const  chunk_offset : integer; 
      const  chunk_size : integer; 
      const  author : UnicodeString; 
      const  date : UnicodeString
    ):integer;
    function createDocmanEmbeddedFileVersion(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  _label : UnicodeString; 
      const  changelog : UnicodeString; 
      const  content : UnicodeString; 
      const  author : UnicodeString; 
      const  date : UnicodeString
    ):integer;
    function appendDocmanFileChunk(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  content : UnicodeString; 
      const  chunk_offset : integer; 
      const  chunk_size : integer
    ):integer;
    function moveDocmanItem(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  new_parent : integer
    ):boolean;
    function getDocmanFileChunk(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  version_number : integer; 
      const  chunk_offset : integer; 
      const  chunk_size : integer
    ):UnicodeString;
    function deleteDocmanItem(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer
    ):integer;
    function monitorDocmanItem(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer
    ):boolean;
    function updateDocmanFolder(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function updateDocmanFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function updateDocmanEmbeddedFile(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function updateDocmanWikiPage(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  content : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function updateDocmanLink(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  content : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
    function updateDocmanEmptyDocument(
      const  sessionKey : UnicodeString; 
      const  group_id : integer; 
      const  item_id : integer; 
      const  title : UnicodeString; 
      const  description : UnicodeString; 
      const  status : UnicodeString; 
      const  obsolescence_date : UnicodeString; 
      const  permissions : ArrayOfPermission; 
      const  metadata : ArrayOfMetadataValue; 
      const  owner : UnicodeString; 
      const  create_date : UnicodeString; 
      const  update_date : UnicodeString
    ):integer;
  End;

  Function wst_CreateInstance_CodendiAPIPortType(const AFormat : string = 'SOAP:'; const ATransport : string = 'HTTP:'; const AAddress : string = ''):CodendiAPIPortType;

Implementation
uses wst_resources_imp, metadata_repository;


Function wst_CreateInstance_CodendiAPIPortType(const AFormat : string; const ATransport : string; const AAddress : string):CodendiAPIPortType;
Var
  locAdr : string;
Begin
  locAdr := AAddress;
  if ( locAdr = '' ) then
    locAdr := GetServiceDefaultAddress(TypeInfo(CodendiAPIPortType));
  Result := TCodendiAPIPortType_Proxy.Create('CodendiAPIPortType',AFormat+GetServiceDefaultFormatProperties(TypeInfo(CodendiAPIPortType)),ATransport + 'address=' + locAdr);
End;

{ TCodendiAPIPortType_Proxy implementation }

class function TCodendiAPIPortType_Proxy.GetServiceType() : PTypeInfo;
begin
  result := TypeInfo(uWSDL_codendi.CodendiAPIPortType);
end;

function TCodendiAPIPortType_Proxy.login(
  const  loginname : UnicodeString; 
  const  passwd : UnicodeString
):Session;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('login', GetTarget(),locCallContext);
      locSerializer.Put('loginname', TypeInfo(UnicodeString), loginname);
      locSerializer.Put('passwd', TypeInfo(UnicodeString), passwd);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Session), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.loginAs(
  const  admin_session_hash : UnicodeString; 
  const  loginname : UnicodeString
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('loginAs', GetTarget(),locCallContext);
      locSerializer.Put('admin_session_hash', TypeInfo(UnicodeString), admin_session_hash);
      locSerializer.Put('loginname', TypeInfo(UnicodeString), loginname);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.retrieveSession(
  const  session_hash : UnicodeString
):Session;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('retrieveSession', GetTarget(),locCallContext);
      locSerializer.Put('session_hash', TypeInfo(UnicodeString), session_hash);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Session), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getAPIVersion():UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getAPIVersion', GetTarget(),locCallContext);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

procedure TCodendiAPIPortType_Proxy.logout(
  const  sessionKey : UnicodeString
);
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('logout', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getMyProjects(
  const  sessionKey : UnicodeString
):ArrayOfGroup;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getMyProjects', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfGroup), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getGroupByName(
  const  sessionKey : UnicodeString; 
  const  unix_group_name : UnicodeString
):Group;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getGroupByName', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('unix_group_name', TypeInfo(UnicodeString), unix_group_name);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Group), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getGroupById(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):Group;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getGroupById', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(Group), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getGroupUgroups(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfUgroup;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getGroupUgroups', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfUgroup), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getProjectGroupsAndUsers(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfUgroup;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getProjectGroupsAndUsers', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfUgroup), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.checkUsersExistence(
  const  sessionKey : UnicodeString; 
  const  users : ArrayOfstring
):ArrayOfUserInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('checkUsersExistence', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('users', TypeInfo(ArrayOfstring), users);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfUserInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getUserInfo(
  const  sessionKey : UnicodeString; 
  const  user_id : integer
):UserInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getUserInfo', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('user_id', TypeInfo(integer), user_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(UserInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getTrackerList(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfTrackerDesc;
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
      locSerializer.Get(TypeInfo(ArrayOfTrackerDesc), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactType(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer
):ArtifactType;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactType', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArtifactType), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactTypes(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfArtifactType;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactTypes', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactType), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifacts(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
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
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
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

function TCodendiAPIPortType_Proxy.getArtifactsFromReport(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  report_id : integer; 
  const  criteria : ArrayOfCriteria; 
  const  offset : integer; 
  const  max_rows : integer; 
  const  sort_criteria : ArrayOfSortCriteria
):ArtifactFromReportResult;
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
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('report_id', TypeInfo(integer), report_id);
      locSerializer.Put('criteria', TypeInfo(ArrayOfCriteria), criteria);
      locSerializer.Put('offset', TypeInfo(integer), offset);
      locSerializer.Put('max_rows', TypeInfo(integer), max_rows);
      locSerializer.Put('sort_criteria', TypeInfo(ArrayOfSortCriteria), sort_criteria);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArtifactFromReportResult), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifact(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  status_id : integer; 
  const  close_date : integer; 
  const  summary : UnicodeString; 
  const  details : UnicodeString; 
  const  severity : integer; 
  const  extra_fields : ArrayOfArtifactFieldValue
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
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('close_date', TypeInfo(integer), close_date);
      locSerializer.Put('summary', TypeInfo(UnicodeString), summary);
      locSerializer.Put('details', TypeInfo(UnicodeString), details);
      locSerializer.Put('severity', TypeInfo(integer), severity);
      locSerializer.Put('extra_fields', TypeInfo(ArrayOfArtifactFieldValue), extra_fields);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifactWithFieldNames(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  status_id : integer; 
  const  close_date : integer; 
  const  summary : UnicodeString; 
  const  details : UnicodeString; 
  const  severity : integer; 
  const  extra_fields : ArrayOfArtifactFieldNameValue
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifactWithFieldNames', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('close_date', TypeInfo(integer), close_date);
      locSerializer.Put('summary', TypeInfo(UnicodeString), summary);
      locSerializer.Put('details', TypeInfo(UnicodeString), details);
      locSerializer.Put('severity', TypeInfo(integer), severity);
      locSerializer.Put('extra_fields', TypeInfo(ArrayOfArtifactFieldNameValue), extra_fields);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateArtifact(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  status_id : integer; 
  const  close_date : integer; 
  const  summary : UnicodeString; 
  const  details : UnicodeString; 
  const  severity : integer; 
  const  extra_fields : ArrayOfArtifactFieldValue
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
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('close_date', TypeInfo(integer), close_date);
      locSerializer.Put('summary', TypeInfo(UnicodeString), summary);
      locSerializer.Put('details', TypeInfo(UnicodeString), details);
      locSerializer.Put('severity', TypeInfo(integer), severity);
      locSerializer.Put('extra_fields', TypeInfo(ArrayOfArtifactFieldValue), extra_fields);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateArtifactWithFieldNames(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  status_id : integer; 
  const  close_date : integer; 
  const  summary : UnicodeString; 
  const  details : UnicodeString; 
  const  severity : integer; 
  const  extra_fields : ArrayOfArtifactFieldNameValue
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateArtifactWithFieldNames', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('close_date', TypeInfo(integer), close_date);
      locSerializer.Put('summary', TypeInfo(UnicodeString), summary);
      locSerializer.Put('details', TypeInfo(UnicodeString), details);
      locSerializer.Put('severity', TypeInfo(integer), severity);
      locSerializer.Put('extra_fields', TypeInfo(ArrayOfArtifactFieldNameValue), extra_fields);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactFollowups(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer
):ArrayOfArtifactFollowup;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactFollowups', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactFollowup), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactCannedResponses(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer
):ArrayOfArtifactCanned;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactCannedResponses', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactCanned), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactReports(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer
):ArrayOfArtifactReport;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactReports', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactReport), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactAttachedFiles(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer
):ArrayOfArtifactFile;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactAttachedFiles', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactFile), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactAttachedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  file_id : integer
):ArtifactFile;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactAttachedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArtifactFile), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactById(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
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
    locSerializer.BeginCall('getArtifactById', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
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

function TCodendiAPIPortType_Proxy.getArtifactDependencies(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer
):ArrayOfArtifactDependency;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactDependencies', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactDependency), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactInverseDependencies(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer
):ArrayOfArtifactDependency;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactInverseDependencies', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactDependency), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifactAttachedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  encoded_data : UnicodeString; 
  const  description : UnicodeString; 
  const  filename : UnicodeString; 
  const  filetype : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifactAttachedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('encoded_data', TypeInfo(UnicodeString), encoded_data);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('filename', TypeInfo(UnicodeString), filename);
      locSerializer.Put('filetype', TypeInfo(UnicodeString), filetype);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteArtifactAttachedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  file_id : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteArtifactAttachedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifactDependencies(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  is_dependent_on_artifact_ids : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifactDependencies', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('is_dependent_on_artifact_ids', TypeInfo(UnicodeString), is_dependent_on_artifact_ids);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteArtifactDependency(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  dependent_on_artifact_id : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteArtifactDependency', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('dependent_on_artifact_id', TypeInfo(integer), dependent_on_artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifactFollowup(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  body : UnicodeString; 
  const  comment_type_id : integer; 
  const  format : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifactFollowup', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('body', TypeInfo(UnicodeString), body);
      locSerializer.Put('comment_type_id', TypeInfo(integer), comment_type_id);
      locSerializer.Put('format', TypeInfo(integer), format);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateArtifactFollowUp(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  artifact_history_id : integer; 
  const  comment : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateArtifactFollowUp', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('artifact_history_id', TypeInfo(integer), artifact_history_id);
      locSerializer.Put('comment', TypeInfo(UnicodeString), comment);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteArtifactFollowUp(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  artifact_history_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteArtifactFollowUp', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('artifact_history_id', TypeInfo(integer), artifact_history_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.existArtifactSummary(
  const  sessionKey : UnicodeString; 
  const  group_artifact_id : integer; 
  const  summary : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('existArtifactSummary', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('summary', TypeInfo(UnicodeString), summary);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactCCList(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer
):ArrayOfArtifactCC;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getArtifactCCList', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(ArrayOfArtifactCC), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addArtifactCC(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  cc_list : UnicodeString; 
  const  cc_comment : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addArtifactCC', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('cc_list', TypeInfo(UnicodeString), cc_list);
      locSerializer.Put('cc_comment', TypeInfo(UnicodeString), cc_comment);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteArtifactCC(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
  const  artifact_id : integer; 
  const  artifact_cc_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteArtifactCC', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
      locSerializer.Put('artifact_id', TypeInfo(integer), artifact_id);
      locSerializer.Put('artifact_cc_id', TypeInfo(integer), artifact_cc_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'return';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getArtifactHistory(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  group_artifact_id : integer; 
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
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('group_artifact_id', TypeInfo(integer), group_artifact_id);
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

function TCodendiAPIPortType_Proxy.getPackages(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfFRSPackage;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getPackages', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getPackagesResponse';
      locSerializer.Get(TypeInfo(ArrayOfFRSPackage), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addPackage(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_name : UnicodeString; 
  const  status_id : integer; 
  const  rank : integer; 
  const  approve_license : boolean
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addPackage', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_name', TypeInfo(UnicodeString), package_name);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('rank', TypeInfo(integer), rank);
      locSerializer.Put('approve_license', TypeInfo(boolean), approve_license);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addPackageResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getReleases(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer
):ArrayOfFRSRelease;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getReleases', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getReleasesResponse';
      locSerializer.Get(TypeInfo(ArrayOfFRSRelease), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateRelease(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  notes : UnicodeString; 
  const  changes : UnicodeString; 
  const  status_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateRelease', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('notes', TypeInfo(UnicodeString), notes);
      locSerializer.Put('changes', TypeInfo(UnicodeString), changes);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateRelease';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addRelease(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  name : UnicodeString; 
  const  notes : UnicodeString; 
  const  changes : UnicodeString; 
  const  status_id : integer; 
  const  release_date : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addRelease', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('name', TypeInfo(UnicodeString), name);
      locSerializer.Put('notes', TypeInfo(UnicodeString), notes);
      locSerializer.Put('changes', TypeInfo(UnicodeString), changes);
      locSerializer.Put('status_id', TypeInfo(integer), status_id);
      locSerializer.Put('release_date', TypeInfo(integer), release_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addRelease';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getFiles(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer
):ArrayOfFRSFile;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getFiles', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getFilesResponse';
      locSerializer.Get(TypeInfo(ArrayOfFRSFile), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getFileInfo(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  file_id : integer
):FRSFile;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getFileInfo', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getFileInfoResponse';
      locSerializer.Get(TypeInfo(FRSFile), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  file_id : integer
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getFileResponse';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getFileChunk(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  file_id : integer; 
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
    locSerializer.BeginCall('getFileChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
      locSerializer.Put('offset', TypeInfo(integer), offset);
      locSerializer.Put('size', TypeInfo(integer), size);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getFileChunkResponse';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  filename : UnicodeString; 
  const  base64_contents : UnicodeString; 
  const  type_id : integer; 
  const  processor_id : integer; 
  const  reference_md5 : UnicodeString; 
  const  comment : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('filename', TypeInfo(UnicodeString), filename);
      locSerializer.Put('base64_contents', TypeInfo(UnicodeString), base64_contents);
      locSerializer.Put('type_id', TypeInfo(integer), type_id);
      locSerializer.Put('processor_id', TypeInfo(integer), processor_id);
      locSerializer.Put('reference_md5', TypeInfo(UnicodeString), reference_md5);
      locSerializer.Put('comment', TypeInfo(UnicodeString), comment);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addFile';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addFileChunk(
  const  sessionKey : UnicodeString; 
  const  filename : UnicodeString; 
  const  contents : UnicodeString; 
  const  first_chunk : boolean
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addFileChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('filename', TypeInfo(UnicodeString), filename);
      locSerializer.Put('contents', TypeInfo(UnicodeString), contents);
      locSerializer.Put('first_chunk', TypeInfo(boolean), first_chunk);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addFileChunk';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.addUploadedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  filename : UnicodeString; 
  const  type_id : integer; 
  const  processor_id : integer; 
  const  reference_md5 : UnicodeString; 
  const  comment : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('addUploadedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('filename', TypeInfo(UnicodeString), filename);
      locSerializer.Put('type_id', TypeInfo(integer), type_id);
      locSerializer.Put('processor_id', TypeInfo(integer), processor_id);
      locSerializer.Put('reference_md5', TypeInfo(UnicodeString), reference_md5);
      locSerializer.Put('comment', TypeInfo(UnicodeString), comment);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'addUploadedFile';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getUploadedFiles(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfstring;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getUploadedFiles', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getUploadedFilesResponse';
      locSerializer.Get(TypeInfo(ArrayOfstring), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  file_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'deleteFileResponse';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteEmptyPackage(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  cleanup_all : boolean
):ArrayOfFRSPackage;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteEmptyPackage', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('cleanup_all', TypeInfo(boolean), cleanup_all);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'deleteEmptyPackageResponse';
      locSerializer.Get(TypeInfo(ArrayOfFRSPackage), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteEmptyRelease(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  cleanup_all : boolean
):ArrayOfFRSRelease;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteEmptyRelease', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('cleanup_all', TypeInfo(boolean), cleanup_all);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'deleteEmptyReleaseResponse';
      locSerializer.Get(TypeInfo(ArrayOfFRSRelease), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateFileComment(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  package_id : integer; 
  const  release_id : integer; 
  const  file_id : integer; 
  const  comment : UnicodeString
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateFileComment', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('package_id', TypeInfo(integer), package_id);
      locSerializer.Put('release_id', TypeInfo(integer), release_id);
      locSerializer.Put('file_id', TypeInfo(integer), file_id);
      locSerializer.Put('comment', TypeInfo(UnicodeString), comment);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateFileCommentResponse';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getRootFolder(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getRootFolder', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getRootFolderResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.listFolder(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer
):ArrayOfDocman_Item;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('listFolder', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'listFolderResponse';
      locSerializer.Get(TypeInfo(ArrayOfDocman_Item), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.searchDocmanItem(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  criterias : ArrayOfCriteria
):ArrayOfDocman_Item;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('searchDocmanItem', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('criterias', TypeInfo(ArrayOfCriteria), criterias);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'searchDocmanItemResponse';
      locSerializer.Get(TypeInfo(ArrayOfDocman_Item), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanFileContents(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  version_number : integer
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanFileContents', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('version_number', TypeInfo(integer), version_number);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getDocmanFileContentsResponse';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanFileMD5sum(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  version_number : integer
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanFileMD5sum', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('version_number', TypeInfo(integer), version_number);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getDocmanFileMD5sumResponse';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanFileAllVersionsMD5sum(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer
):ArrayOfstring;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanFileAllVersionsMD5sum', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getDocmanFileAllVersionsMD5sumResponse';
      locSerializer.Get(TypeInfo(ArrayOfstring), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanProjectMetadata(
  const  sessionKey : UnicodeString; 
  const  group_id : integer
):ArrayOfMetadata;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanProjectMetadata', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getDocmanProjectMetadataResponse';
      locSerializer.Get(TypeInfo(ArrayOfMetadata), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanTreeInfo(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer
):ArrayOfItemInfo;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanTreeInfo', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      Result := Nil;
      locStrPrmName := 'getDocmanTreeInfoResponse';
      locSerializer.Get(TypeInfo(ArrayOfItemInfo), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanFolder(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanFolder', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanFolderResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  file_size : integer; 
  const  file_name : UnicodeString; 
  const  mime_type : UnicodeString; 
  const  content : UnicodeString; 
  const  chunk_offset : integer; 
  const  chunk_size : integer; 
  const  author : UnicodeString; 
  const  date : UnicodeString; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('file_size', TypeInfo(integer), file_size);
      locSerializer.Put('file_name', TypeInfo(UnicodeString), file_name);
      locSerializer.Put('mime_type', TypeInfo(UnicodeString), mime_type);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('chunk_offset', TypeInfo(integer), chunk_offset);
      locSerializer.Put('chunk_size', TypeInfo(integer), chunk_size);
      locSerializer.Put('author', TypeInfo(UnicodeString), author);
      locSerializer.Put('date', TypeInfo(UnicodeString), date);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanFileResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanEmbeddedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  content : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  author : UnicodeString; 
  const  date : UnicodeString; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanEmbeddedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('author', TypeInfo(UnicodeString), author);
      locSerializer.Put('date', TypeInfo(UnicodeString), date);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanEmbeddedFileResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanWikiPage(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  content : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanWikiPage', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanWikiPageResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanLink(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  content : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanLink', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanLinkResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanEmptyDocument(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  parent_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  ordering : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanEmptyDocument', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('parent_id', TypeInfo(integer), parent_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('ordering', TypeInfo(UnicodeString), ordering);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanEmptyDocumentResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanFileVersion(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  _label : UnicodeString; 
  const  changelog : UnicodeString; 
  const  file_size : integer; 
  const  file_name : UnicodeString; 
  const  mime_type : UnicodeString; 
  const  content : UnicodeString; 
  const  chunk_offset : integer; 
  const  chunk_size : integer; 
  const  author : UnicodeString; 
  const  date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanFileVersion', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('label', TypeInfo(UnicodeString), _label);
      locSerializer.Put('changelog', TypeInfo(UnicodeString), changelog);
      locSerializer.Put('file_size', TypeInfo(integer), file_size);
      locSerializer.Put('file_name', TypeInfo(UnicodeString), file_name);
      locSerializer.Put('mime_type', TypeInfo(UnicodeString), mime_type);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('chunk_offset', TypeInfo(integer), chunk_offset);
      locSerializer.Put('chunk_size', TypeInfo(integer), chunk_size);
      locSerializer.Put('author', TypeInfo(UnicodeString), author);
      locSerializer.Put('date', TypeInfo(UnicodeString), date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanFileVersionResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.createDocmanEmbeddedFileVersion(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  _label : UnicodeString; 
  const  changelog : UnicodeString; 
  const  content : UnicodeString; 
  const  author : UnicodeString; 
  const  date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('createDocmanEmbeddedFileVersion', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('label', TypeInfo(UnicodeString), _label);
      locSerializer.Put('changelog', TypeInfo(UnicodeString), changelog);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('author', TypeInfo(UnicodeString), author);
      locSerializer.Put('date', TypeInfo(UnicodeString), date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'createDocmanEmbeddedFileVersionResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.appendDocmanFileChunk(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  content : UnicodeString; 
  const  chunk_offset : integer; 
  const  chunk_size : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('appendDocmanFileChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('chunk_offset', TypeInfo(integer), chunk_offset);
      locSerializer.Put('chunk_size', TypeInfo(integer), chunk_size);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'appendDocmanFileChunkResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.moveDocmanItem(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  new_parent : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('moveDocmanItem', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('new_parent', TypeInfo(integer), new_parent);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'moveDocmanItemResponse';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.getDocmanFileChunk(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  version_number : integer; 
  const  chunk_offset : integer; 
  const  chunk_size : integer
):UnicodeString;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('getDocmanFileChunk', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('version_number', TypeInfo(integer), version_number);
      locSerializer.Put('chunk_offset', TypeInfo(integer), chunk_offset);
      locSerializer.Put('chunk_size', TypeInfo(integer), chunk_size);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'getDocmanFileChunkResponse';
      locSerializer.Get(TypeInfo(UnicodeString), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.deleteDocmanItem(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('deleteDocmanItem', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'deleteDocmanItemResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.monitorDocmanItem(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer
):boolean;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('monitorDocmanItem', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'monitorDocmanItemResponse';
      locSerializer.Get(TypeInfo(boolean), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanFolder(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanFolder', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanFolderResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanFileResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanEmbeddedFile(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanEmbeddedFile', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanEmbeddedFileResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanWikiPage(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  content : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanWikiPage', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanWikiPageResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanLink(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  content : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanLink', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('content', TypeInfo(UnicodeString), content);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanLinkResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;

function TCodendiAPIPortType_Proxy.updateDocmanEmptyDocument(
  const  sessionKey : UnicodeString; 
  const  group_id : integer; 
  const  item_id : integer; 
  const  title : UnicodeString; 
  const  description : UnicodeString; 
  const  status : UnicodeString; 
  const  obsolescence_date : UnicodeString; 
  const  permissions : ArrayOfPermission; 
  const  metadata : ArrayOfMetadataValue; 
  const  owner : UnicodeString; 
  const  create_date : UnicodeString; 
  const  update_date : UnicodeString
):integer;
Var
  locSerializer : IFormatterClient;
  locCallContext : ICallContext;
  locStrPrmName : string;
Begin
  locCallContext := Self as ICallContext;
  locSerializer := GetSerializer();
  Try
    locSerializer.BeginCall('updateDocmanEmptyDocument', GetTarget(),locCallContext);
      locSerializer.Put('sessionKey', TypeInfo(UnicodeString), sessionKey);
      locSerializer.Put('group_id', TypeInfo(integer), group_id);
      locSerializer.Put('item_id', TypeInfo(integer), item_id);
      locSerializer.Put('title', TypeInfo(UnicodeString), title);
      locSerializer.Put('description', TypeInfo(UnicodeString), description);
      locSerializer.Put('status', TypeInfo(UnicodeString), status);
      locSerializer.Put('obsolescence_date', TypeInfo(UnicodeString), obsolescence_date);
      locSerializer.Put('permissions', TypeInfo(ArrayOfPermission), permissions);
      locSerializer.Put('metadata', TypeInfo(ArrayOfMetadataValue), metadata);
      locSerializer.Put('owner', TypeInfo(UnicodeString), owner);
      locSerializer.Put('create_date', TypeInfo(UnicodeString), create_date);
      locSerializer.Put('update_date', TypeInfo(UnicodeString), update_date);
    locSerializer.EndCall();

    MakeCall();

    locSerializer.BeginCallRead(locCallContext);
      locStrPrmName := 'updateDocmanEmptyDocumentResponse';
      locSerializer.Get(TypeInfo(integer), locStrPrmName, Result);

  Finally
    locSerializer.Clear();
  End;
End;


initialization
  {$i uWSDL_codendi.wst}

  {$IF DECLARED(Register_uWSDL_codendi_ServiceMetadata)}
  Register_uWSDL_codendi_ServiceMetadata();
  {$IFEND}
End.
