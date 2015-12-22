{
This unit has been produced by ws_helper.
  Input unit name : "tracker".
  This unit name  : "tracker".
  Date            : "21/12/2015 18:32:15".
}
unit tracker;
{$IFDEF FPC}
  {$mode objfpc} {$H+}
{$ENDIF}
{$DEFINE WST_RECORD_RTTI}
interface

uses SysUtils, Classes, TypInfo, base_service_intf, service_intf;

const
  sNAME_SPACE = 'https://192.168.1.35/plugins/tracker/soap';
  sUNIT_NAME = 'tracker';

type

  ArrayOfTracker = class;
  ArrayOfTrackerField = class;
  ArrayOfCriteria = class;
  ArtifactQueryResult = class;
  ArrayOfArtifactFieldValue = class;
  Artifact = class;
  TrackerStructure = class;
  ArrayOfTrackerReport = class;
  ArrayOfArtifactComments = class;
  ArrayOfArtifactHistory = class;
  ArrayOfString = class;
  TrackerField = class;
  TrackerFieldBindValue = class;
  ArrayOfTrackerFieldBindValue = class;
  TrackerFieldBindType = class;
  ArrayOfUgroup = class;
  UGroup = class;
  FieldValueFileInfo = class;
  ArrayOfFieldValueFileInfo = class;
  FieldValue = class;
  ArtifactFieldValue = class;
  ArtifactCrossReferences = class;
  ArrayOfArtifactCrossReferences = class;
  ArrayOfArtifact = class;
  CriteriaValueDate = class;
  CriteriaValueDateAdvanced = class;
  CriteriaValue = class;
  Criteria = class;
  SortCriteria = class;
  ArrayOfSortCriteria = class;
  ArtifactFile = class;
  ArrayOfArtifactFile = class;
  ArrayOfInt = class;
  TrackerSemanticTitle = class;
  TrackerSemanticStatus = class;
  TrackerSemanticContributor = class;
  AgileDashBoardSemanticInitialEffort = class;
  TrackerSemantic = class;
  TrackerWorkflowTransition = class;
  TrackerWorkflowRuleList = class;
  TrackerWorkflowRuleDate = class;
  TrackerWorkflowRuleArray = class;
  TrackerWorkflowTransitionArray = class;
  TrackerWorkflowRuleDateArray = class;
  TrackerWorkflowRuleListArray = class;
  TrackerWorkflow = class;
  TrackerReport = class;
  ArtifactComments = class;
  ArtifactFollowupComment = class;
  ArtifactHistory = class;

  ArtifactQueryResult = class(TBaseComplexRemotable)
  private
    Ftotal_artifacts_number : integer;
    Fartifacts : ArrayOfArtifact;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property total_artifacts_number : integer read Ftotal_artifacts_number write Ftotal_artifacts_number;
    property artifacts : ArrayOfArtifact read Fartifacts write Fartifacts;
  end;

  Artifact = class(TBaseComplexRemotable)
  private
    Fartifact_id : integer;
    Ftracker_id : integer;
    Fsubmitted_by : integer;
    Fsubmitted_on : integer;
    Fcross_references : ArrayOfArtifactCrossReferences;
    Flast_update_date : integer;
    Fvalue : ArrayOfArtifactFieldValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property tracker_id : integer read Ftracker_id write Ftracker_id;
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property submitted_on : integer read Fsubmitted_on write Fsubmitted_on;
    property cross_references : ArrayOfArtifactCrossReferences read Fcross_references write Fcross_references;
    property last_update_date : integer read Flast_update_date write Flast_update_date;
    property value : ArrayOfArtifactFieldValue read Fvalue write Fvalue;
  end;

  TrackerStructure = class(TBaseComplexRemotable)
  private
    Fsemantic : TrackerSemantic;
    Fworkflow : TrackerWorkflow;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property semantic : TrackerSemantic read Fsemantic write Fsemantic;
    property workflow : TrackerWorkflow read Fworkflow write Fworkflow;
  end;

  Tracker = class(TBaseComplexRemotable)
  private
    Ftracker_id : integer;
    Fgroup_id : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fitem_name : UnicodeString;
  published
    property tracker_id : integer read Ftracker_id write Ftracker_id;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property item_name : UnicodeString read Fitem_name write Fitem_name;
  end;

  TrackerField = class(TBaseComplexRemotable)
  private
    Ftracker_id : integer;
    Ffield_id : integer;
    Fshort_name : UnicodeString;
    F_label : UnicodeString;
    F_type : UnicodeString;
    Fvalues : ArrayOfTrackerFieldBindValue;
    Fbinding : TrackerFieldBindType;
    Fpermissions : ArrayOfString;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property tracker_id : integer read Ftracker_id write Ftracker_id;
    property field_id : integer read Ffield_id write Ffield_id;
    property short_name : UnicodeString read Fshort_name write Fshort_name;
    property _label : UnicodeString read F_label write F_label;
    property _type : UnicodeString read F_type write F_type;
    property values : ArrayOfTrackerFieldBindValue read Fvalues write Fvalues;
    property binding : TrackerFieldBindType read Fbinding write Fbinding;
    property permissions : ArrayOfString read Fpermissions write Fpermissions;
  end;

  TrackerFieldBindValue = class(TBaseComplexRemotable)
  private
    Fbind_value_id : integer;
    Fbind_value_label : UnicodeString;
  published
    property bind_value_id : integer read Fbind_value_id write Fbind_value_id;
    property bind_value_label : UnicodeString read Fbind_value_label write Fbind_value_label;
  end;

  TrackerFieldBindType = class(TBaseComplexRemotable)
  private
    Fbind_type : UnicodeString;
    Fbind_list : ArrayOfUgroup;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property bind_type : UnicodeString read Fbind_type write Fbind_type;
    property bind_list : ArrayOfUgroup read Fbind_list write Fbind_list;
  end;

  UGroup = class(TBaseComplexRemotable)
  private
    Fugroup_id : integer;
    Fname : UnicodeString;
  published
    property ugroup_id : integer read Fugroup_id write Fugroup_id;
    property name : UnicodeString read Fname write Fname;
  end;

  FieldValueFileInfo = class(TBaseComplexRemotable)
  private
    Fid : UnicodeString;
    Fsubmitted_by : integer;
    Fdescription : UnicodeString;
    Ffilename : UnicodeString;
    Ffilesize : integer;
    Ffiletype : UnicodeString;
    Faction : UnicodeString;
  published
    property id : UnicodeString read Fid write Fid;
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property description : UnicodeString read Fdescription write Fdescription;
    property filename : UnicodeString read Ffilename write Ffilename;
    property filesize : integer read Ffilesize write Ffilesize;
    property filetype : UnicodeString read Ffiletype write Ffiletype;
    property action : UnicodeString read Faction write Faction;
  end;

  FieldValue = class(TBaseComplexRemotable)
  private
    Fvalue : UnicodeString;
    Ffile_info : ArrayOfFieldValueFileInfo;
    Fbind_value : ArrayOfTrackerFieldBindValue;
  private
    function wstHas_value() : Boolean;
    function wstHas_file_info() : Boolean;
    function wstHas_bind_value() : Boolean;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property value : UnicodeString read Fvalue write Fvalue stored wstHas_value;
    property file_info : ArrayOfFieldValueFileInfo read Ffile_info write Ffile_info stored wstHas_file_info;
    property bind_value : ArrayOfTrackerFieldBindValue read Fbind_value write Fbind_value stored wstHas_bind_value;
  end;

  ArtifactFieldValue = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Ffield_label : UnicodeString;
    Ffield_value : FieldValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property field_label : UnicodeString read Ffield_label write Ffield_label;
    property field_value : FieldValue read Ffield_value write Ffield_value;
  end;

  ArtifactCrossReferences = class(TBaseComplexRemotable)
  private
    Fref : UnicodeString;
    Furl : UnicodeString;
  published
    property ref : UnicodeString read Fref write Fref;
    property url : UnicodeString read Furl write Furl;
  end;

  CriteriaValueDate = class(TBaseComplexRemotable)
  private
    Fop : UnicodeString;
    Fto_date : integer;
  published
    property op : UnicodeString read Fop write Fop;
    property to_date : integer read Fto_date write Fto_date;
  end;

  CriteriaValueDateAdvanced = class(TBaseComplexRemotable)
  private
    Ffrom_date : integer;
    Fto_date : integer;
  published
    property from_date : integer read Ffrom_date write Ffrom_date;
    property to_date : integer read Fto_date write Fto_date;
  end;

  CriteriaValue = class(TBaseComplexRemotable)
  private
    Fvalue : UnicodeString;
    Fdate : CriteriaValueDate;
    FdateAdvanced : CriteriaValueDateAdvanced;
  private
    function wstHas_value() : Boolean;
    function wstHas_date() : Boolean;
    function wstHas_dateAdvanced() : Boolean;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property value : UnicodeString read Fvalue write Fvalue stored wstHas_value;
    property date : CriteriaValueDate read Fdate write Fdate stored wstHas_date;
    property dateAdvanced : CriteriaValueDateAdvanced read FdateAdvanced write FdateAdvanced stored wstHas_dateAdvanced;
  end;

  Criteria = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Fvalue : CriteriaValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property value : CriteriaValue read Fvalue write Fvalue;
  end;

  SortCriteria = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Fsort_direction : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property sort_direction : UnicodeString read Fsort_direction write Fsort_direction;
  end;

  ArtifactFile = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fartifact_id : integer;
    Ffilename : UnicodeString;
    Fdescription : UnicodeString;
    Fbin_data : TBase64StringRemotable;
    Ffilesize : integer;
    Ffiletype : UnicodeString;
    Fadddate : integer;
    Fsubmitted_by : UnicodeString;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property id : integer read Fid write Fid;
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property filename : UnicodeString read Ffilename write Ffilename;
    property description : UnicodeString read Fdescription write Fdescription;
    property bin_data : TBase64StringRemotable read Fbin_data write Fbin_data;
    property filesize : integer read Ffilesize write Ffilesize;
    property filetype : UnicodeString read Ffiletype write Ffiletype;
    property adddate : integer read Fadddate write Fadddate;
    property submitted_by : UnicodeString read Fsubmitted_by write Fsubmitted_by;
  end;

  TrackerSemanticTitle = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
  end;

  TrackerSemanticStatus = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Fvalues : ArrayOfInt;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property values : ArrayOfInt read Fvalues write Fvalues;
  end;

  TrackerSemanticContributor = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
  end;

  AgileDashBoardSemanticInitialEffort = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
  end;

  TrackerSemantic = class(TBaseComplexRemotable)
  private
    Ftitle : TrackerSemanticTitle;
    Fstatus : TrackerSemanticStatus;
    Fcontributor : TrackerSemanticContributor;
    Finitial_effort : AgileDashBoardSemanticInitialEffort;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property title : TrackerSemanticTitle read Ftitle write Ftitle;
    property status : TrackerSemanticStatus read Fstatus write Fstatus;
    property contributor : TrackerSemanticContributor read Fcontributor write Fcontributor;
    property initial_effort : AgileDashBoardSemanticInitialEffort read Finitial_effort write Finitial_effort;
  end;

  TrackerWorkflowTransition = class(TBaseComplexRemotable)
  private
    Ffrom_id : integer;
    Fto_id : integer;
  published
    property from_id : integer read Ffrom_id write Ffrom_id;
    property to_id : integer read Fto_id write Fto_id;
  end;

  TrackerWorkflowRuleList = class(TBaseComplexRemotable)
  private
    Fsource_field_id : integer;
    Ftarget_field_id : integer;
    Fsource_value_id : integer;
    Ftarget_value_id : integer;
  published
    property source_field_id : integer read Fsource_field_id write Fsource_field_id;
    property target_field_id : integer read Ftarget_field_id write Ftarget_field_id;
    property source_value_id : integer read Fsource_value_id write Fsource_value_id;
    property target_value_id : integer read Ftarget_value_id write Ftarget_value_id;
  end;

  TrackerWorkflowRuleDate = class(TBaseComplexRemotable)
  private
    Fsource_field_id : integer;
    Ftarget_field_id : integer;
    Fcomparator : UnicodeString;
  published
    property source_field_id : integer read Fsource_field_id write Fsource_field_id;
    property target_field_id : integer read Ftarget_field_id write Ftarget_field_id;
    property comparator : UnicodeString read Fcomparator write Fcomparator;
  end;

  TrackerWorkflowRuleArray = class(TBaseComplexRemotable)
  private
    Fdates : TrackerWorkflowRuleDateArray;
    Flists : TrackerWorkflowRuleListArray;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property dates : TrackerWorkflowRuleDateArray read Fdates write Fdates;
    property lists : TrackerWorkflowRuleListArray read Flists write Flists;
  end;

  TrackerWorkflow = class(TBaseComplexRemotable)
  private
    Ffield_id : integer;
    Fis_used : integer;
    Frules : TrackerWorkflowRuleArray;
    Ftransitions : TrackerWorkflowTransitionArray;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_id : integer read Ffield_id write Ffield_id;
    property is_used : integer read Fis_used write Fis_used;
    property rules : TrackerWorkflowRuleArray read Frules write Frules;
    property transitions : TrackerWorkflowTransitionArray read Ftransitions write Ftransitions;
  end;

  TrackerReport = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fuser_id : integer;
    Fis_default : boolean;
  published
    property id : integer read Fid write Fid;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property user_id : integer read Fuser_id write Fuser_id;
    property is_default : boolean read Fis_default write Fis_default;
  end;

  ArtifactComments = class(TBaseComplexRemotable)
  private
    Fsubmitted_by : integer;
    Femail : UnicodeString;
    Fsubmitted_on : integer;
    Fbody : UnicodeString;
  published
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property email : UnicodeString read Femail write Femail;
    property submitted_on : integer read Fsubmitted_on write Fsubmitted_on;
    property body : UnicodeString read Fbody write Fbody;
  end;

  ArtifactFollowupComment = class(TBaseComplexRemotable)
  private
    Fsubmitted_by : integer;
    Fsubmitted_on : integer;
    Fformat : UnicodeString;
    Fbody : UnicodeString;
  published
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property submitted_on : integer read Fsubmitted_on write Fsubmitted_on;
    property format : UnicodeString read Fformat write Fformat;
    property body : UnicodeString read Fbody write Fbody;
  end;

  ArtifactHistory = class(TBaseComplexRemotable)
  private
    Fsubmitted_by : integer;
    Femail : UnicodeString;
    Fsubmitted_on : integer;
    Flast_comment : ArtifactFollowupComment;
    Ffields : ArrayOfArtifactFieldValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property email : UnicodeString read Femail write Femail;
    property submitted_on : integer read Fsubmitted_on write Fsubmitted_on;
    property last_comment : ArtifactFollowupComment read Flast_comment write Flast_comment;
    property fields : ArrayOfArtifactFieldValue read Ffields write Ffields;
  end;

  ArrayOfTracker = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Tracker;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Tracker Read GetItem;Default;
  end;

  ArrayOfTrackerField = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerField;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerField Read GetItem;Default;
  end;

  ArrayOfCriteria = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Criteria;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Criteria Read GetItem;Default;
  end;

  ArrayOfArtifactFieldValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldValue Read GetItem;Default;
  end;

  ArrayOfTrackerReport = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerReport;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerReport Read GetItem;Default;
  end;

  ArrayOfArtifactComments = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactComments;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactComments Read GetItem;Default;
  end;

  ArrayOfArtifactHistory = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactHistory;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactHistory Read GetItem;Default;
  end;

  ArrayOfString = class(TBaseSimpleTypeArrayRemotable)
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

  ArrayOfTrackerFieldBindValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerFieldBindValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerFieldBindValue Read GetItem;Default;
  end;

  ArrayOfUgroup = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): UGroup;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : UGroup Read GetItem;Default;
  end;

  ArrayOfFieldValueFileInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): FieldValueFileInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : FieldValueFileInfo Read GetItem;Default;
  end;

  ArrayOfArtifactCrossReferences = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactCrossReferences;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactCrossReferences Read GetItem;Default;
  end;

  ArrayOfArtifact = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Artifact;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Artifact Read GetItem;Default;
  end;

  ArrayOfSortCriteria = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): SortCriteria;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : SortCriteria Read GetItem;Default;
  end;

  ArrayOfArtifactFile = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFile;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFile Read GetItem;Default;
  end;

  ArrayOfInt = class(TBaseSimpleTypeArrayRemotable)
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

  TrackerWorkflowTransitionArray = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerWorkflowTransition;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerWorkflowTransition Read GetItem;Default;
  end;

  TrackerWorkflowRuleDateArray = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerWorkflowRuleDate;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerWorkflowRuleDate Read GetItem;Default;
  end;

  TrackerWorkflowRuleListArray = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerWorkflowRuleList;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerWorkflowRuleList Read GetItem;Default;
  end;

  TuleapTrackerV5APIPortType = interface(IInvokable)
    ['{E5889E84-57E8-4CA3-A4DD-BA6CDB8C3048}']
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
  end;

  procedure Register_tracker_ServiceMetadata();

Implementation
uses metadata_repository, record_rtti, wst_types;

{ ArtifactQueryResult }

constructor ArtifactQueryResult.Create();
begin
  inherited Create();
  Fartifacts := ArrayOfArtifact.Create();
end;

procedure ArtifactQueryResult.FreeObjectProperties();
begin
  if Assigned(Fartifacts) then
    FreeAndNil(Fartifacts);
  inherited FreeObjectProperties();
end;

{ Artifact }

constructor Artifact.Create();
begin
  inherited Create();
  Fcross_references := ArrayOfArtifactCrossReferences.Create();
  Fvalue := ArrayOfArtifactFieldValue.Create();
end;

procedure Artifact.FreeObjectProperties();
begin
  if Assigned(Fcross_references) then
    FreeAndNil(Fcross_references);
  if Assigned(Fvalue) then
    FreeAndNil(Fvalue);
  inherited FreeObjectProperties();
end;

{ TrackerStructure }

constructor TrackerStructure.Create();
begin
  inherited Create();
  Fsemantic := TrackerSemantic.Create();
  Fworkflow := TrackerWorkflow.Create();
end;

procedure TrackerStructure.FreeObjectProperties();
begin
  if Assigned(Fsemantic) then
    FreeAndNil(Fsemantic);
  if Assigned(Fworkflow) then
    FreeAndNil(Fworkflow);
  inherited FreeObjectProperties();
end;

{ TrackerField }

constructor TrackerField.Create();
begin
  inherited Create();
  Fvalues := ArrayOfTrackerFieldBindValue.Create();
  Fbinding := TrackerFieldBindType.Create();
  Fpermissions := ArrayOfString.Create();
end;

procedure TrackerField.FreeObjectProperties();
begin
  if Assigned(Fvalues) then
    FreeAndNil(Fvalues);
  if Assigned(Fbinding) then
    FreeAndNil(Fbinding);
  if Assigned(Fpermissions) then
    FreeAndNil(Fpermissions);
  inherited FreeObjectProperties();
end;

{ TrackerFieldBindType }

constructor TrackerFieldBindType.Create();
begin
  inherited Create();
  Fbind_list := ArrayOfUgroup.Create();
end;

procedure TrackerFieldBindType.FreeObjectProperties();
begin
  if Assigned(Fbind_list) then
    FreeAndNil(Fbind_list);
  inherited FreeObjectProperties();
end;

{ FieldValue }

constructor FieldValue.Create();
begin
  inherited Create();
  Ffile_info := ArrayOfFieldValueFileInfo.Create();
  Fbind_value := ArrayOfTrackerFieldBindValue.Create();
end;

procedure FieldValue.FreeObjectProperties();
begin
  if Assigned(Ffile_info) then
    FreeAndNil(Ffile_info);
  if Assigned(Fbind_value) then
    FreeAndNil(Fbind_value);
  inherited FreeObjectProperties();
end;

function FieldValue.wstHas_value() : Boolean;
begin
  Result := ( Fvalue <> '' );
end;

function FieldValue.wstHas_file_info() : Boolean;
begin
  Result := ( Ffile_info <> ArrayOfFieldValueFileInfo(0) );
end;

function FieldValue.wstHas_bind_value() : Boolean;
begin
  Result := ( Fbind_value <> ArrayOfTrackerFieldBindValue(0) );
end;

{ ArtifactFieldValue }

constructor ArtifactFieldValue.Create();
begin
  inherited Create();
  Ffield_value := FieldValue.Create();
end;

procedure ArtifactFieldValue.FreeObjectProperties();
begin
  if Assigned(Ffield_value) then
    FreeAndNil(Ffield_value);
  inherited FreeObjectProperties();
end;

{ CriteriaValue }

constructor CriteriaValue.Create();
begin
  inherited Create();
  Fdate := CriteriaValueDate.Create();
  FdateAdvanced := CriteriaValueDateAdvanced.Create();
end;

procedure CriteriaValue.FreeObjectProperties();
begin
  if Assigned(Fdate) then
    FreeAndNil(Fdate);
  if Assigned(FdateAdvanced) then
    FreeAndNil(FdateAdvanced);
  inherited FreeObjectProperties();
end;

function CriteriaValue.wstHas_value() : Boolean;
begin
  Result := ( Fvalue <> '' );
end;

function CriteriaValue.wstHas_date() : Boolean;
begin
  Result := ( Fdate <> nil );
end;

function CriteriaValue.wstHas_dateAdvanced() : Boolean;
begin
  Result := ( FdateAdvanced <> nil );
end;

{ Criteria }

constructor Criteria.Create();
begin
  inherited Create();
  Fvalue := CriteriaValue.Create();
end;

procedure Criteria.FreeObjectProperties();
begin
  if Assigned(Fvalue) then
    FreeAndNil(Fvalue);
  inherited FreeObjectProperties();
end;

{ ArtifactFile }

constructor ArtifactFile.Create();
begin
  inherited Create();
  Fbin_data := TBase64StringRemotable.Create();
end;

procedure ArtifactFile.FreeObjectProperties();
begin
  if Assigned(Fbin_data) then
    FreeAndNil(Fbin_data);
  inherited FreeObjectProperties();
end;

{ TrackerSemanticStatus }

constructor TrackerSemanticStatus.Create();
begin
  inherited Create();
  Fvalues := ArrayOfInt.Create();
end;

procedure TrackerSemanticStatus.FreeObjectProperties();
begin
  if Assigned(Fvalues) then
    FreeAndNil(Fvalues);
  inherited FreeObjectProperties();
end;

{ TrackerSemantic }

constructor TrackerSemantic.Create();
begin
  inherited Create();
  Ftitle := TrackerSemanticTitle.Create();
  Fstatus := TrackerSemanticStatus.Create();
  Fcontributor := TrackerSemanticContributor.Create();
  Finitial_effort := AgileDashBoardSemanticInitialEffort.Create();
end;

procedure TrackerSemantic.FreeObjectProperties();
begin
  if Assigned(Ftitle) then
    FreeAndNil(Ftitle);
  if Assigned(Fstatus) then
    FreeAndNil(Fstatus);
  if Assigned(Fcontributor) then
    FreeAndNil(Fcontributor);
  if Assigned(Finitial_effort) then
    FreeAndNil(Finitial_effort);
  inherited FreeObjectProperties();
end;

{ TrackerWorkflowRuleArray }

constructor TrackerWorkflowRuleArray.Create();
begin
  inherited Create();
  Fdates := TrackerWorkflowRuleDateArray.Create();
  Flists := TrackerWorkflowRuleListArray.Create();
end;

procedure TrackerWorkflowRuleArray.FreeObjectProperties();
begin
  if Assigned(Fdates) then
    FreeAndNil(Fdates);
  if Assigned(Flists) then
    FreeAndNil(Flists);
  inherited FreeObjectProperties();
end;

{ TrackerWorkflow }

constructor TrackerWorkflow.Create();
begin
  inherited Create();
  Frules := TrackerWorkflowRuleArray.Create();
  Ftransitions := TrackerWorkflowTransitionArray.Create();
end;

procedure TrackerWorkflow.FreeObjectProperties();
begin
  if Assigned(Frules) then
    FreeAndNil(Frules);
  if Assigned(Ftransitions) then
    FreeAndNil(Ftransitions);
  inherited FreeObjectProperties();
end;

{ ArtifactHistory }

constructor ArtifactHistory.Create();
begin
  inherited Create();
  Flast_comment := ArtifactFollowupComment.Create();
  Ffields := ArrayOfArtifactFieldValue.Create();
end;

procedure ArtifactHistory.FreeObjectProperties();
begin
  if Assigned(Flast_comment) then
    FreeAndNil(Flast_comment);
  if Assigned(Ffields) then
    FreeAndNil(Ffields);
  inherited FreeObjectProperties();
end;

{ ArrayOfTracker }

function ArrayOfTracker.GetItem(AIndex: Integer): Tracker;
begin
  Result := Tracker(Inherited GetItem(AIndex));
end;

class function ArrayOfTracker.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Tracker;
end;

{ ArrayOfTrackerField }

function ArrayOfTrackerField.GetItem(AIndex: Integer): TrackerField;
begin
  Result := TrackerField(Inherited GetItem(AIndex));
end;

class function ArrayOfTrackerField.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerField;
end;

{ ArrayOfCriteria }

function ArrayOfCriteria.GetItem(AIndex: Integer): Criteria;
begin
  Result := Criteria(Inherited GetItem(AIndex));
end;

class function ArrayOfCriteria.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Criteria;
end;

{ ArrayOfArtifactFieldValue }

function ArrayOfArtifactFieldValue.GetItem(AIndex: Integer): ArtifactFieldValue;
begin
  Result := ArtifactFieldValue(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFieldValue.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFieldValue;
end;

{ ArrayOfTrackerReport }

function ArrayOfTrackerReport.GetItem(AIndex: Integer): TrackerReport;
begin
  Result := TrackerReport(Inherited GetItem(AIndex));
end;

class function ArrayOfTrackerReport.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerReport;
end;

{ ArrayOfArtifactComments }

function ArrayOfArtifactComments.GetItem(AIndex: Integer): ArtifactComments;
begin
  Result := ArtifactComments(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactComments.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactComments;
end;

{ ArrayOfArtifactHistory }

function ArrayOfArtifactHistory.GetItem(AIndex: Integer): ArtifactHistory;
begin
  Result := ArtifactHistory(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactHistory.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactHistory;
end;

{ ArrayOfString }

function ArrayOfString.GetItem(AIndex: Integer): UnicodeString;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOfString.SetItem(AIndex: Integer;const AValue: UnicodeString);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOfString.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOfString.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(UnicodeString),FData[AIndex]);
end;

procedure ArrayOfString.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(UnicodeString),sName,FData[AIndex]);
end;

class function ArrayOfString.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(UnicodeString);
end;

procedure ArrayOfString.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOfString.Assign(Source: TPersistent);
var
  src : ArrayOfString;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOfString) then begin
    src := ArrayOfString(Source);
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

{ ArrayOfTrackerFieldBindValue }

function ArrayOfTrackerFieldBindValue.GetItem(AIndex: Integer): TrackerFieldBindValue;
begin
  Result := TrackerFieldBindValue(Inherited GetItem(AIndex));
end;

class function ArrayOfTrackerFieldBindValue.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerFieldBindValue;
end;

{ ArrayOfUgroup }

function ArrayOfUgroup.GetItem(AIndex: Integer): UGroup;
begin
  Result := UGroup(Inherited GetItem(AIndex));
end;

class function ArrayOfUgroup.GetItemClass(): TBaseRemotableClass;
begin
  Result:= UGroup;
end;

{ ArrayOfFieldValueFileInfo }

function ArrayOfFieldValueFileInfo.GetItem(AIndex: Integer): FieldValueFileInfo;
begin
  Result := FieldValueFileInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfFieldValueFileInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= FieldValueFileInfo;
end;

{ ArrayOfArtifactCrossReferences }

function ArrayOfArtifactCrossReferences.GetItem(AIndex: Integer): ArtifactCrossReferences;
begin
  Result := ArtifactCrossReferences(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactCrossReferences.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactCrossReferences;
end;

{ ArrayOfArtifact }

function ArrayOfArtifact.GetItem(AIndex: Integer): Artifact;
begin
  Result := Artifact(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifact.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Artifact;
end;

{ ArrayOfSortCriteria }

function ArrayOfSortCriteria.GetItem(AIndex: Integer): SortCriteria;
begin
  Result := SortCriteria(Inherited GetItem(AIndex));
end;

class function ArrayOfSortCriteria.GetItemClass(): TBaseRemotableClass;
begin
  Result:= SortCriteria;
end;

{ ArrayOfArtifactFile }

function ArrayOfArtifactFile.GetItem(AIndex: Integer): ArtifactFile;
begin
  Result := ArtifactFile(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFile.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFile;
end;

{ ArrayOfInt }

function ArrayOfInt.GetItem(AIndex: Integer): integer;
begin
  CheckIndex(AIndex);
  Result := FData[AIndex];
end;

procedure ArrayOfInt.SetItem(AIndex: Integer;const AValue: integer);
begin
  CheckIndex(AIndex);
  FData[AIndex] := AValue;
end;

function ArrayOfInt.GetLength(): Integer;
begin
  Result := System.Length(FData);
end;

procedure ArrayOfInt.SaveItem(AStore: IFormatterBase;const AName: String; const AIndex: Integer);
begin
  AStore.Put('item',TypeInfo(integer),FData[AIndex]);
end;

procedure ArrayOfInt.LoadItem(AStore: IFormatterBase;const AIndex: Integer);
var
  sName : string;
begin
  sName := 'item';
  AStore.Get(TypeInfo(integer),sName,FData[AIndex]);
end;

class function ArrayOfInt.GetItemTypeInfo(): PTypeInfo;
begin
  Result := TypeInfo(integer);
end;

procedure ArrayOfInt.SetLength(const ANewSize: Integer);
var
  i : Integer;
begin
  if ( ANewSize < 0 ) then
    i := 0
  else
    i := ANewSize;
  System.SetLength(FData,i);
end;

procedure ArrayOfInt.Assign(Source: TPersistent);
var
  src : ArrayOfInt;
  i, c : Integer;
begin
  if Assigned(Source) and Source.InheritsFrom(ArrayOfInt) then begin
    src := ArrayOfInt(Source);
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

{ TrackerWorkflowTransitionArray }

function TrackerWorkflowTransitionArray.GetItem(AIndex: Integer): TrackerWorkflowTransition;
begin
  Result := TrackerWorkflowTransition(Inherited GetItem(AIndex));
end;

class function TrackerWorkflowTransitionArray.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerWorkflowTransition;
end;

{ TrackerWorkflowRuleDateArray }

function TrackerWorkflowRuleDateArray.GetItem(AIndex: Integer): TrackerWorkflowRuleDate;
begin
  Result := TrackerWorkflowRuleDate(Inherited GetItem(AIndex));
end;

class function TrackerWorkflowRuleDateArray.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerWorkflowRuleDate;
end;

{ TrackerWorkflowRuleListArray }

function TrackerWorkflowRuleListArray.GetItem(AIndex: Integer): TrackerWorkflowRuleList;
begin
  Result := TrackerWorkflowRuleList(Inherited GetItem(AIndex));
end;

class function TrackerWorkflowRuleListArray.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerWorkflowRuleList;
end;


procedure Register_tracker_ServiceMetadata();
var
  mm : IModuleMetadataMngr;
begin
  mm := GetModuleMetadataMngr();
  mm.SetRepositoryNameSpace(sUNIT_NAME, sNAME_SPACE);
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'TRANSPORT_Address',
    'https://192.168.1.35:443/plugins/tracker/soap/'
  );
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'FORMAT_Style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getVersion',
    '_E_N_',
    'getVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getVersion',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getVersion',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getVersion',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getVersion',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerList',
    '_E_N_',
    'getTrackerList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerList',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerList',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getTrackerList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerList',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerList',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerFields',
    '_E_N_',
    'getTrackerFields'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerFields',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerFields',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getTrackerFields'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerFields',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerFields',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifacts',
    '_E_N_',
    'getArtifacts'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifacts',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifacts',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifacts'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifacts',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifacts',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addArtifact',
    '_E_N_',
    'addArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addArtifact',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addArtifact',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#addArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addArtifact',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addArtifact',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'updateArtifact',
    '_E_N_',
    'updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'updateArtifact',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'updateArtifact',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'updateArtifact',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'updateArtifact',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifact',
    '_E_N_',
    'getArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifact',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifact',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifact',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifact',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactsFromReport',
    '_E_N_',
    'getArtifactsFromReport'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactsFromReport',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactsFromReport',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifactsFromReport'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactsFromReport',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactsFromReport',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactAttachmentChunk',
    '_E_N_',
    'getArtifactAttachmentChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactAttachmentChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactAttachmentChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifactAttachmentChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactAttachmentChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactAttachmentChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'createTemporaryAttachment',
    '_E_N_',
    'createTemporaryAttachment'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'createTemporaryAttachment',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'createTemporaryAttachment',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#createTemporaryAttachment'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'createTemporaryAttachment',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'createTemporaryAttachment',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'appendTemporaryAttachmentChunk',
    '_E_N_',
    'appendTemporaryAttachmentChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'appendTemporaryAttachmentChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'appendTemporaryAttachmentChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#appendTemporaryAttachmentChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'appendTemporaryAttachmentChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'appendTemporaryAttachmentChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'purgeAllTemporaryAttachments',
    '_E_N_',
    'purgeAllTemporaryAttachments'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'purgeAllTemporaryAttachments',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'purgeAllTemporaryAttachments',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#purgeAllTemporaryAttachments'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'purgeAllTemporaryAttachments',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'purgeAllTemporaryAttachments',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerStructure',
    '_E_N_',
    'getTrackerStructure'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerStructure',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerStructure',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getTrackerStructure'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerStructure',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerStructure',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerReports',
    '_E_N_',
    'getTrackerReports'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerReports',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerReports',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getTrackerReports'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerReports',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getTrackerReports',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactComments',
    '_E_N_',
    'getArtifactComments'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactComments',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactComments',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifactComments'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactComments',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactComments',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactHistory',
    '_E_N_',
    'getArtifactHistory'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactHistory',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactHistory',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#getArtifactHistory'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactHistory',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'getArtifactHistory',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addSelectBoxValues',
    '_E_N_',
    'addSelectBoxValues'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addSelectBoxValues',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addSelectBoxValues',
    'TRANSPORT_soapAction',
    'https://192.168.1.35/plugins/tracker/soap#addSelectBoxValues'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addSelectBoxValues',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'TuleapTrackerV5APIPortType',
    'addSelectBoxValues',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
end;


var
  typeRegistryInstance : TTypeRegistry = nil;
initialization
  typeRegistryInstance := GetTypeRegistry();

  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactQueryResult),'ArtifactQueryResult');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Artifact),'Artifact');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerStructure),'TrackerStructure');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Tracker),'Tracker');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerField),'TrackerField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerFieldBindValue),'TrackerFieldBindValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerFieldBindType),'TrackerFieldBindType');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(UGroup),'UGroup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(FieldValueFileInfo),'FieldValueFileInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(FieldValue),'FieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldValue),'ArtifactFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactCrossReferences),'ArtifactCrossReferences');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(CriteriaValueDate),'CriteriaValueDate');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(CriteriaValueDateAdvanced),'CriteriaValueDateAdvanced');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(CriteriaValue),'CriteriaValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Criteria),'Criteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SortCriteria),'SortCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFile),'ArtifactFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerSemanticTitle),'TrackerSemanticTitle');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerSemanticStatus),'TrackerSemanticStatus');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerSemanticContributor),'TrackerSemanticContributor');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(AgileDashBoardSemanticInitialEffort),'AgileDashBoardSemanticInitialEffort');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerSemantic),'TrackerSemantic');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowTransition),'TrackerWorkflowTransition');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowRuleList),'TrackerWorkflowRuleList');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowRuleDate),'TrackerWorkflowRuleDate');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowRuleArray),'TrackerWorkflowRuleArray');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflow),'TrackerWorkflow');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerReport),'TrackerReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactComments),'ArtifactComments');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFollowupComment),'ArtifactFollowupComment');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactHistory),'ArtifactHistory');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfTracker),'ArrayOfTracker');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfTrackerField),'ArrayOfTrackerField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfCriteria),'ArrayOfCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldValue),'ArrayOfArtifactFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfTrackerReport),'ArrayOfTrackerReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactComments),'ArrayOfArtifactComments');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactHistory),'ArrayOfArtifactHistory');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfString),'ArrayOfString');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfTrackerFieldBindValue),'ArrayOfTrackerFieldBindValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUgroup),'ArrayOfUgroup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfFieldValueFileInfo),'ArrayOfFieldValueFileInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactCrossReferences),'ArrayOfArtifactCrossReferences');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifact),'ArrayOfArtifact');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSortCriteria),'ArrayOfSortCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFile),'ArrayOfArtifactFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfInt),'ArrayOfInt');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowTransitionArray),'TrackerWorkflowTransitionArray');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowRuleDateArray),'TrackerWorkflowRuleDateArray');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerWorkflowRuleListArray),'TrackerWorkflowRuleListArray');

  typeRegistryInstance.ItemByTypeInfo[TypeInfo(TrackerField)].RegisterExternalPropertyName('_label','label');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(TrackerField)].RegisterExternalPropertyName('_type','type');


End.
