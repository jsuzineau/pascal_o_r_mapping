{
This unit has been produced by ws_helper.
  Input unit name : "uWSDL_codendi".
  This unit name  : "uWSDL_codendi".
  Date            : "21/12/2015 18:47:54".
}
unit uWSDL_codendi;
{$IFDEF FPC}
  {$mode objfpc} {$H+}
{$ENDIF}
{$DEFINE WST_RECORD_RTTI}
interface

uses SysUtils, Classes, TypInfo, base_service_intf, service_intf;

const
  sNAME_SPACE = 'https://192.168.1.35';
  sUNIT_NAME = 'uWSDL_codendi';

type

  Session = class;
  ArrayOfGroup = class;
  Group = class;
  ArrayOfUgroup = class;
  ArrayOfstring = class;
  ArrayOfUserInfo = class;
  UserInfo = class;
  ArrayOfTrackerDesc = class;
  ArtifactType = class;
  ArrayOfArtifactType = class;
  ArrayOfCriteria = class;
  ArtifactQueryResult = class;
  ArrayOfSortCriteria = class;
  ArtifactFromReportResult = class;
  ArrayOfArtifactFieldValue = class;
  ArrayOfArtifactFieldNameValue = class;
  ArrayOfArtifactFollowup = class;
  ArrayOfArtifactCanned = class;
  ArrayOfArtifactReport = class;
  ArrayOfArtifactFile = class;
  ArtifactFile = class;
  Artifact = class;
  ArrayOfArtifactDependency = class;
  ArrayOfArtifactCC = class;
  ArrayOfArtifactHistory = class;
  ArrayOfFRSPackage = class;
  ArrayOfFRSRelease = class;
  ArrayOfFRSFile = class;
  FRSFile = class;
  ArrayOfDocman_Item = class;
  ArrayOfMetadata = class;
  ArrayOfItemInfo = class;
  ArrayOfPermission = class;
  ArrayOfMetadataValue = class;
  ArrayOfInteger = class;
  ArrayOflong = class;
  Revision = class;
  ArrayOfRevision = class;
  Commiter = class;
  ArrayOfCommiter = class;
  SvnPathInfo = class;
  ArrayOfSvnPathInfo = class;
  SvnPathDetails = class;
  ArrayOfSvnPathDetails = class;
  DescField = class;
  ArrayOfDescFields = class;
  DescFieldValue = class;
  ArrayOfDescFieldsValues = class;
  ServiceValue = class;
  ArrayOfServicesValues = class;
  UGroupMember = class;
  ArrayOfUGroupMember = class;
  Ugroup = class;
  TrackerDesc = class;
  ArtifactFieldSet = class;
  ArrayOfArtifactFieldSet = class;
  ArtifactField = class;
  ArrayOfArtifactField = class;
  ArtifactFieldValue = class;
  ArtifactFieldNameValue = class;
  ArtifactFieldValueList = class;
  ArrayOfArtifactFieldValueList = class;
  ArtifactRule = class;
  ArrayOfArtifactRule = class;
  ArrayOfArtifact = class;
  Criteria = class;
  SortCriteria = class;
  ArtifactCanned = class;
  ArtifactFollowup = class;
  ArtifactReport = class;
  ArtifactReportDesc = class;
  ArrayOfArtifactReportDesc = class;
  ArtifactReportField = class;
  ArrayOfArtifactReportField = class;
  ArtifactCC = class;
  ArtifactDependency = class;
  ArtifactHistory = class;
  ArrayOfInt = class;
  ArtifactFromReport = class;
  ArrayOfArtifactFromReport = class;
  ArtifactFieldFromReport = class;
  ArrayOfArtifactFieldFromReport = class;
  FRSPackage = class;
  FRSRelease = class;
  Docman_Item = class;
  Permission = class;
  MetadataValue = class;
  MetadataListValue = class;
  ArrayOfMetadataListValue = class;
  Metadata = class;
  ItemInfo = class;

  Session = class(TBaseComplexRemotable)
  private
    Fuser_id : integer;
    Fsession_hash : UnicodeString;
  published
    property user_id : integer read Fuser_id write Fuser_id;
    property session_hash : UnicodeString read Fsession_hash write Fsession_hash;
  end;

  Group = class(TBaseComplexRemotable)
  private
    Fgroup_id : integer;
    Fgroup_name : UnicodeString;
    Funix_group_name : UnicodeString;
    Fdescription : UnicodeString;
  published
    property group_id : integer read Fgroup_id write Fgroup_id;
    property group_name : UnicodeString read Fgroup_name write Fgroup_name;
    property unix_group_name : UnicodeString read Funix_group_name write Funix_group_name;
    property description : UnicodeString read Fdescription write Fdescription;
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

  ArtifactType = class(TBaseComplexRemotable)
  private
    Fgroup_artifact_id : integer;
    Fgroup_id : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fitem_name : UnicodeString;
    Fopen_count : integer;
    Ftotal_count : integer;
    Ftotal_file_size : Single;
    Ffield_sets : ArrayOfArtifactFieldSet;
    Ffield_dependencies : ArrayOfArtifactRule;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property item_name : UnicodeString read Fitem_name write Fitem_name;
    property open_count : integer read Fopen_count write Fopen_count;
    property total_count : integer read Ftotal_count write Ftotal_count;
    property total_file_size : Single read Ftotal_file_size write Ftotal_file_size;
    property field_sets : ArrayOfArtifactFieldSet read Ffield_sets write Ffield_sets;
    property field_dependencies : ArrayOfArtifactRule read Ffield_dependencies write Ffield_dependencies;
  end;

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

  ArtifactFromReportResult = class(TBaseComplexRemotable)
  private
    Ftotal_artifacts_number : integer;
    Fartifacts : ArrayOfArtifactFromReport;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property total_artifacts_number : integer read Ftotal_artifacts_number write Ftotal_artifacts_number;
    property artifacts : ArrayOfArtifactFromReport read Fartifacts write Fartifacts;
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

  Artifact = class(TBaseComplexRemotable)
  private
    Fartifact_id : integer;
    Fgroup_artifact_id : integer;
    Fstatus_id : integer;
    Fsubmitted_by : integer;
    Fopen_date : integer;
    Fclose_date : integer;
    Flast_update_date : integer;
    Fsummary : UnicodeString;
    Fdetails : UnicodeString;
    Fseverity : integer;
    Fextra_fields : ArrayOfArtifactFieldValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property status_id : integer read Fstatus_id write Fstatus_id;
    property submitted_by : integer read Fsubmitted_by write Fsubmitted_by;
    property open_date : integer read Fopen_date write Fopen_date;
    property close_date : integer read Fclose_date write Fclose_date;
    property last_update_date : integer read Flast_update_date write Flast_update_date;
    property summary : UnicodeString read Fsummary write Fsummary;
    property details : UnicodeString read Fdetails write Fdetails;
    property severity : integer read Fseverity write Fseverity;
    property extra_fields : ArrayOfArtifactFieldValue read Fextra_fields write Fextra_fields;
  end;

  FRSFile = class(TBaseComplexRemotable)
  private
    Ffile_id : integer;
    Frelease_id : integer;
    Ffile_name : UnicodeString;
    Ffile_size : integer;
    Ftype_id : integer;
    Fprocessor_id : integer;
    Frelease_time : integer;
    Fpost_date : integer;
    Fcomputed_md5 : UnicodeString;
    Freference_md5 : UnicodeString;
    Fuser_id : integer;
    Fcomment : UnicodeString;
  published
    property file_id : integer read Ffile_id write Ffile_id;
    property release_id : integer read Frelease_id write Frelease_id;
    property file_name : UnicodeString read Ffile_name write Ffile_name;
    property file_size : integer read Ffile_size write Ffile_size;
    property type_id : integer read Ftype_id write Ftype_id;
    property processor_id : integer read Fprocessor_id write Fprocessor_id;
    property release_time : integer read Frelease_time write Frelease_time;
    property post_date : integer read Fpost_date write Fpost_date;
    property computed_md5 : UnicodeString read Fcomputed_md5 write Fcomputed_md5;
    property reference_md5 : UnicodeString read Freference_md5 write Freference_md5;
    property user_id : integer read Fuser_id write Fuser_id;
    property comment : UnicodeString read Fcomment write Fcomment;
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

  UGroupMember = class(TBaseComplexRemotable)
  private
    Fuser_id : integer;
    Fuser_name : UnicodeString;
  published
    property user_id : integer read Fuser_id write Fuser_id;
    property user_name : UnicodeString read Fuser_name write Fuser_name;
  end;

  Ugroup = class(TBaseComplexRemotable)
  private
    Fugroup_id : integer;
    Fname : UnicodeString;
    Fmembers : ArrayOfUGroupMember;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property ugroup_id : integer read Fugroup_id write Fugroup_id;
    property name : UnicodeString read Fname write Fname;
    property members : ArrayOfUGroupMember read Fmembers write Fmembers;
  end;

  TrackerDesc = class(TBaseComplexRemotable)
  private
    Fgroup_artifact_id : integer;
    Fgroup_id : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fitem_name : UnicodeString;
    Fopen_count : integer;
    Ftotal_count : integer;
    Freports_desc : ArrayOfArtifactReportDesc;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property item_name : UnicodeString read Fitem_name write Fitem_name;
    property open_count : integer read Fopen_count write Fopen_count;
    property total_count : integer read Ftotal_count write Ftotal_count;
    property reports_desc : ArrayOfArtifactReportDesc read Freports_desc write Freports_desc;
  end;

  ArtifactFieldSet = class(TBaseComplexRemotable)
  private
    Ffield_set_id : integer;
    Fgroup_artifact_id : integer;
    Fname : UnicodeString;
    F_label : UnicodeString;
    Fdescription : UnicodeString;
    Fdescription_text : UnicodeString;
    Frank : integer;
    Ffields : ArrayOfArtifactField;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_set_id : integer read Ffield_set_id write Ffield_set_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property name : UnicodeString read Fname write Fname;
    property _label : UnicodeString read F_label write F_label;
    property description : UnicodeString read Fdescription write Fdescription;
    property description_text : UnicodeString read Fdescription_text write Fdescription_text;
    property rank : integer read Frank write Frank;
    property fields : ArrayOfArtifactField read Ffields write Ffields;
  end;

  ArtifactField = class(TBaseComplexRemotable)
  private
    Ffield_id : integer;
    Fgroup_artifact_id : integer;
    Ffield_set_id : integer;
    Ffield_name : UnicodeString;
    Fdata_type : integer;
    Fdisplay_type : UnicodeString;
    Fdisplay_size : UnicodeString;
    F_label : UnicodeString;
    Fdescription : UnicodeString;
    Fscope : UnicodeString;
    Frequired : integer;
    Fempty_ok : integer;
    Fkeep_history : integer;
    Fspecial : integer;
    Fvalue_function : UnicodeString;
    Favailable_values : ArrayOfArtifactFieldValueList;
    Fdefault_value : UnicodeString;
    Fuser_can_submit : boolean;
    Fuser_can_update : boolean;
    Fuser_can_read : boolean;
    Fis_standard_field : boolean;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property field_id : integer read Ffield_id write Ffield_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property field_set_id : integer read Ffield_set_id write Ffield_set_id;
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property data_type : integer read Fdata_type write Fdata_type;
    property display_type : UnicodeString read Fdisplay_type write Fdisplay_type;
    property display_size : UnicodeString read Fdisplay_size write Fdisplay_size;
    property _label : UnicodeString read F_label write F_label;
    property description : UnicodeString read Fdescription write Fdescription;
    property scope : UnicodeString read Fscope write Fscope;
    property required : integer read Frequired write Frequired;
    property empty_ok : integer read Fempty_ok write Fempty_ok;
    property keep_history : integer read Fkeep_history write Fkeep_history;
    property special : integer read Fspecial write Fspecial;
    property value_function : UnicodeString read Fvalue_function write Fvalue_function;
    property available_values : ArrayOfArtifactFieldValueList read Favailable_values write Favailable_values;
    property default_value : UnicodeString read Fdefault_value write Fdefault_value;
    property user_can_submit : boolean read Fuser_can_submit write Fuser_can_submit;
    property user_can_update : boolean read Fuser_can_update write Fuser_can_update;
    property user_can_read : boolean read Fuser_can_read write Fuser_can_read;
    property is_standard_field : boolean read Fis_standard_field write Fis_standard_field;
  end;

  ArtifactFieldValue = class(TBaseComplexRemotable)
  private
    Ffield_id : integer;
    Fartifact_id : integer;
    Ffield_value : UnicodeString;
  published
    property field_id : integer read Ffield_id write Ffield_id;
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property field_value : UnicodeString read Ffield_value write Ffield_value;
  end;

  ArtifactFieldNameValue = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Ffield_value : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property field_value : UnicodeString read Ffield_value write Ffield_value;
  end;

  ArtifactFieldValueList = class(TBaseComplexRemotable)
  private
    Ffield_id : integer;
    Fgroup_artifact_id : integer;
    Fvalue_id : integer;
    Fvalue : UnicodeString;
    Fdescription : UnicodeString;
    Forder_id : integer;
    Fstatus : UnicodeString;
  published
    property field_id : integer read Ffield_id write Ffield_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property value_id : integer read Fvalue_id write Fvalue_id;
    property value : UnicodeString read Fvalue write Fvalue;
    property description : UnicodeString read Fdescription write Fdescription;
    property order_id : integer read Forder_id write Forder_id;
    property status : UnicodeString read Fstatus write Fstatus;
  end;

  ArtifactRule = class(TBaseComplexRemotable)
  private
    Frule_id : integer;
    Fgroup_artifact_id : integer;
    Fsource_field_id : integer;
    Fsource_value_id : integer;
    Ftarget_field_id : integer;
    Ftarget_value_id : integer;
  published
    property rule_id : integer read Frule_id write Frule_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property source_field_id : integer read Fsource_field_id write Fsource_field_id;
    property source_value_id : integer read Fsource_value_id write Fsource_value_id;
    property target_field_id : integer read Ftarget_field_id write Ftarget_field_id;
    property target_value_id : integer read Ftarget_value_id write Ftarget_value_id;
  end;

  Criteria = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Ffield_value : UnicodeString;
    F_operator : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property field_value : UnicodeString read Ffield_value write Ffield_value;
    property _operator : UnicodeString read F_operator write F_operator;
  end;

  SortCriteria = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Fsort_direction : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property sort_direction : UnicodeString read Fsort_direction write Fsort_direction;
  end;

  ArtifactCanned = class(TBaseComplexRemotable)
  private
    Fartifact_canned_id : integer;
    Fgroup_artifact_id : integer;
    Ftitle : UnicodeString;
    Fbody : UnicodeString;
  published
    property artifact_canned_id : integer read Fartifact_canned_id write Fartifact_canned_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property title : UnicodeString read Ftitle write Ftitle;
    property body : UnicodeString read Fbody write Fbody;
  end;

  ArtifactFollowup = class(TBaseComplexRemotable)
  private
    Fartifact_id : integer;
    Ffollow_up_id : integer;
    Fcomment : UnicodeString;
    Fdate : integer;
    Foriginal_date : integer;
    Fby : UnicodeString;
    Foriginal_by : UnicodeString;
    Fcomment_type_id : integer;
    Fcomment_type : UnicodeString;
    Ffield_name : UnicodeString;
    Fuser_can_edit : integer;
  published
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property follow_up_id : integer read Ffollow_up_id write Ffollow_up_id;
    property comment : UnicodeString read Fcomment write Fcomment;
    property date : integer read Fdate write Fdate;
    property original_date : integer read Foriginal_date write Foriginal_date;
    property by : UnicodeString read Fby write Fby;
    property original_by : UnicodeString read Foriginal_by write Foriginal_by;
    property comment_type_id : integer read Fcomment_type_id write Fcomment_type_id;
    property comment_type : UnicodeString read Fcomment_type write Fcomment_type;
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property user_can_edit : integer read Fuser_can_edit write Fuser_can_edit;
  end;

  ArtifactReport = class(TBaseComplexRemotable)
  private
    Freport_id : integer;
    Fgroup_artifact_id : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fscope : UnicodeString;
    Ffields : ArrayOfArtifactReportField;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property report_id : integer read Freport_id write Freport_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property scope : UnicodeString read Fscope write Fscope;
    property fields : ArrayOfArtifactReportField read Ffields write Ffields;
  end;

  ArtifactReportDesc = class(TBaseComplexRemotable)
  private
    Freport_id : integer;
    Fgroup_artifact_id : integer;
    Fname : UnicodeString;
    Fdescription : UnicodeString;
    Fscope : UnicodeString;
  published
    property report_id : integer read Freport_id write Freport_id;
    property group_artifact_id : integer read Fgroup_artifact_id write Fgroup_artifact_id;
    property name : UnicodeString read Fname write Fname;
    property description : UnicodeString read Fdescription write Fdescription;
    property scope : UnicodeString read Fscope write Fscope;
  end;

  ArtifactReportField = class(TBaseComplexRemotable)
  private
    Freport_id : integer;
    Ffield_name : UnicodeString;
    Fshow_on_query : integer;
    Fshow_on_result : integer;
    Fplace_query : integer;
    Fplace_result : integer;
    Fcol_width : integer;
  published
    property report_id : integer read Freport_id write Freport_id;
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property show_on_query : integer read Fshow_on_query write Fshow_on_query;
    property show_on_result : integer read Fshow_on_result write Fshow_on_result;
    property place_query : integer read Fplace_query write Fplace_query;
    property place_result : integer read Fplace_result write Fplace_result;
    property col_width : integer read Fcol_width write Fcol_width;
  end;

  ArtifactCC = class(TBaseComplexRemotable)
  private
    Fartifact_cc_id : integer;
    Fartifact_id : integer;
    Femail : UnicodeString;
    Fadded_by : integer;
    Fadded_by_name : UnicodeString;
    Fcomment : UnicodeString;
    Fdate : integer;
  published
    property artifact_cc_id : integer read Fartifact_cc_id write Fartifact_cc_id;
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property email : UnicodeString read Femail write Femail;
    property added_by : integer read Fadded_by write Fadded_by;
    property added_by_name : UnicodeString read Fadded_by_name write Fadded_by_name;
    property comment : UnicodeString read Fcomment write Fcomment;
    property date : integer read Fdate write Fdate;
  end;

  ArtifactDependency = class(TBaseComplexRemotable)
  private
    Fartifact_depend_id : integer;
    Fartifact_id : integer;
    Fis_dependent_on_artifact_id : integer;
    Fsummary : UnicodeString;
    Ftracker_id : integer;
    Ftracker_name : UnicodeString;
    Fgroup_id : integer;
    Fgroup_name : UnicodeString;
  published
    property artifact_depend_id : integer read Fartifact_depend_id write Fartifact_depend_id;
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property is_dependent_on_artifact_id : integer read Fis_dependent_on_artifact_id write Fis_dependent_on_artifact_id;
    property summary : UnicodeString read Fsummary write Fsummary;
    property tracker_id : integer read Ftracker_id write Ftracker_id;
    property tracker_name : UnicodeString read Ftracker_name write Ftracker_name;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property group_name : UnicodeString read Fgroup_name write Fgroup_name;
  end;

  ArtifactHistory = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Fold_value : UnicodeString;
    Fnew_value : UnicodeString;
    Fmodification_by : UnicodeString;
    Fdate : integer;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property old_value : UnicodeString read Fold_value write Fold_value;
    property new_value : UnicodeString read Fnew_value write Fnew_value;
    property modification_by : UnicodeString read Fmodification_by write Fmodification_by;
    property date : integer read Fdate write Fdate;
  end;

  ArtifactFromReport = class(TBaseComplexRemotable)
  private
    Fartifact_id : integer;
    Fseverity : integer;
    Ffields : ArrayOfArtifactFieldFromReport;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property artifact_id : integer read Fartifact_id write Fartifact_id;
    property severity : integer read Fseverity write Fseverity;
    property fields : ArrayOfArtifactFieldFromReport read Ffields write Ffields;
  end;

  ArtifactFieldFromReport = class(TBaseComplexRemotable)
  private
    Ffield_name : UnicodeString;
    Ffield_value : UnicodeString;
  published
    property field_name : UnicodeString read Ffield_name write Ffield_name;
    property field_value : UnicodeString read Ffield_value write Ffield_value;
  end;

  FRSPackage = class(TBaseComplexRemotable)
  private
    Fpackage_id : integer;
    Fgroup_id : integer;
    Fname : UnicodeString;
    Fstatus_id : integer;
    Frank : integer;
    Fapprove_license : boolean;
  published
    property package_id : integer read Fpackage_id write Fpackage_id;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property name : UnicodeString read Fname write Fname;
    property status_id : integer read Fstatus_id write Fstatus_id;
    property rank : integer read Frank write Frank;
    property approve_license : boolean read Fapprove_license write Fapprove_license;
  end;

  FRSRelease = class(TBaseComplexRemotable)
  private
    Frelease_id : integer;
    Fpackage_id : integer;
    Fname : UnicodeString;
    Fnotes : UnicodeString;
    Fchanges : UnicodeString;
    Fstatus_id : UnicodeString;
    Frelease_date : integer;
    Freleased_by : UnicodeString;
  published
    property release_id : integer read Frelease_id write Frelease_id;
    property package_id : integer read Fpackage_id write Fpackage_id;
    property name : UnicodeString read Fname write Fname;
    property notes : UnicodeString read Fnotes write Fnotes;
    property changes : UnicodeString read Fchanges write Fchanges;
    property status_id : UnicodeString read Fstatus_id write Fstatus_id;
    property release_date : integer read Frelease_date write Frelease_date;
    property released_by : UnicodeString read Freleased_by write Freleased_by;
  end;

  Docman_Item = class(TBaseComplexRemotable)
  private
    Fitem_id : integer;
    Fparent_id : integer;
    Fgroup_id : integer;
    Ftitle : UnicodeString;
    Fdescription : UnicodeString;
    Fcreate_date : integer;
    Fupdate_date : integer;
    Fdelete_date : integer;
    Fuser_id : integer;
    Fstatus : integer;
    Fobsolescence_date : integer;
    Frank : integer;
    Fitem_type : integer;
  published
    property item_id : integer read Fitem_id write Fitem_id;
    property parent_id : integer read Fparent_id write Fparent_id;
    property group_id : integer read Fgroup_id write Fgroup_id;
    property title : UnicodeString read Ftitle write Ftitle;
    property description : UnicodeString read Fdescription write Fdescription;
    property create_date : integer read Fcreate_date write Fcreate_date;
    property update_date : integer read Fupdate_date write Fupdate_date;
    property delete_date : integer read Fdelete_date write Fdelete_date;
    property user_id : integer read Fuser_id write Fuser_id;
    property status : integer read Fstatus write Fstatus;
    property obsolescence_date : integer read Fobsolescence_date write Fobsolescence_date;
    property rank : integer read Frank write Frank;
    property item_type : integer read Fitem_type write Fitem_type;
  end;

  Permission = class(TBaseComplexRemotable)
  private
    F_type : UnicodeString;
    Fugroup_id : integer;
  published
    property _type : UnicodeString read F_type write F_type;
    property ugroup_id : integer read Fugroup_id write Fugroup_id;
  end;

  MetadataValue = class(TBaseComplexRemotable)
  private
    F_label : UnicodeString;
    Fvalue : UnicodeString;
  published
    property _label : UnicodeString read F_label write F_label;
    property value : UnicodeString read Fvalue write Fvalue;
  end;

  MetadataListValue = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fname : UnicodeString;
  published
    property id : integer read Fid write Fid;
    property name : UnicodeString read Fname write Fname;
  end;

  Metadata = class(TBaseComplexRemotable)
  private
    F_label : UnicodeString;
    Fname : UnicodeString;
    F_type : UnicodeString;
    FisMultipleValuesAllowed : integer;
    FisEmptyAllowed : integer;
    FlistOfValues : ArrayOfMetadataListValue;
  public
    constructor Create();override;
    procedure FreeObjectProperties();override;
  published
    property _label : UnicodeString read F_label write F_label;
    property name : UnicodeString read Fname write Fname;
    property _type : UnicodeString read F_type write F_type;
    property isMultipleValuesAllowed : integer read FisMultipleValuesAllowed write FisMultipleValuesAllowed;
    property isEmptyAllowed : integer read FisEmptyAllowed write FisEmptyAllowed;
    property listOfValues : ArrayOfMetadataListValue read FlistOfValues write FlistOfValues;
  end;

  ItemInfo = class(TBaseComplexRemotable)
  private
    Fid : integer;
    Fparent_id : integer;
    Ftitle : UnicodeString;
    Ffilename : UnicodeString;
    F_type : UnicodeString;
    Fnb_versions : integer;
  published
    property id : integer read Fid write Fid;
    property parent_id : integer read Fparent_id write Fparent_id;
    property title : UnicodeString read Ftitle write Ftitle;
    property filename : UnicodeString read Ffilename write Ffilename;
    property _type : UnicodeString read F_type write F_type;
    property nb_versions : integer read Fnb_versions write Fnb_versions;
  end;

  ArrayOfGroup = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Group;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Group Read GetItem;Default;
  end;

  ArrayOfUgroup = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Ugroup;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Ugroup Read GetItem;Default;
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

  ArrayOfUserInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): UserInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : UserInfo Read GetItem;Default;
  end;

  ArrayOfTrackerDesc = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): TrackerDesc;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : TrackerDesc Read GetItem;Default;
  end;

  ArrayOfArtifactType = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactType;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactType Read GetItem;Default;
  end;

  ArrayOfCriteria = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Criteria;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Criteria Read GetItem;Default;
  end;

  ArrayOfSortCriteria = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): SortCriteria;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : SortCriteria Read GetItem;Default;
  end;

  ArrayOfArtifactFieldValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldValue Read GetItem;Default;
  end;

  ArrayOfArtifactFieldNameValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldNameValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldNameValue Read GetItem;Default;
  end;

  ArrayOfArtifactFollowup = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFollowup;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFollowup Read GetItem;Default;
  end;

  ArrayOfArtifactCanned = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactCanned;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactCanned Read GetItem;Default;
  end;

  ArrayOfArtifactReport = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactReport;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactReport Read GetItem;Default;
  end;

  ArrayOfArtifactFile = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFile;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFile Read GetItem;Default;
  end;

  ArrayOfArtifactDependency = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactDependency;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactDependency Read GetItem;Default;
  end;

  ArrayOfArtifactCC = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactCC;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactCC Read GetItem;Default;
  end;

  ArrayOfArtifactHistory = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactHistory;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactHistory Read GetItem;Default;
  end;

  ArrayOfFRSPackage = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): FRSPackage;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : FRSPackage Read GetItem;Default;
  end;

  ArrayOfFRSRelease = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): FRSRelease;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : FRSRelease Read GetItem;Default;
  end;

  ArrayOfFRSFile = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): FRSFile;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : FRSFile Read GetItem;Default;
  end;

  ArrayOfDocman_Item = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Docman_Item;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Docman_Item Read GetItem;Default;
  end;

  ArrayOfMetadata = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Metadata;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Metadata Read GetItem;Default;
  end;

  ArrayOfItemInfo = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ItemInfo;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ItemInfo Read GetItem;Default;
  end;

  ArrayOfPermission = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Permission;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Permission Read GetItem;Default;
  end;

  ArrayOfMetadataValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): MetadataValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : MetadataValue Read GetItem;Default;
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

  ArrayOfUGroupMember = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): UGroupMember;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : UGroupMember Read GetItem;Default;
  end;

  ArrayOfArtifactFieldSet = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldSet;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldSet Read GetItem;Default;
  end;

  ArrayOfArtifactField = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactField;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactField Read GetItem;Default;
  end;

  ArrayOfArtifactFieldValueList = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldValueList;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldValueList Read GetItem;Default;
  end;

  ArrayOfArtifactRule = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactRule;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactRule Read GetItem;Default;
  end;

  ArrayOfArtifact = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): Artifact;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : Artifact Read GetItem;Default;
  end;

  ArrayOfArtifactReportDesc = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactReportDesc;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactReportDesc Read GetItem;Default;
  end;

  ArrayOfArtifactReportField = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactReportField;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactReportField Read GetItem;Default;
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

  ArrayOfArtifactFromReport = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFromReport;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFromReport Read GetItem;Default;
  end;

  ArrayOfArtifactFieldFromReport = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): ArtifactFieldFromReport;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : ArtifactFieldFromReport Read GetItem;Default;
  end;

  ArrayOfMetadataListValue = class(TBaseObjectArrayRemotable)
  private
    function GetItem(AIndex: Integer): MetadataListValue;
  public
    class function GetItemClass():TBaseRemotableClass;override;
    property Item[AIndex:Integer] : MetadataListValue Read GetItem;Default;
  end;

  CodendiAPIPortType = interface(IInvokable)
    ['{2AEABA63-1C8E-4363-A227-C1C407A90B6D}']
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
  end;

  procedure Register_uWSDL_codendi_ServiceMetadata();

Implementation
uses metadata_repository, record_rtti, wst_types;

{ ArtifactType }

constructor ArtifactType.Create();
begin
  inherited Create();
  Ffield_sets := ArrayOfArtifactFieldSet.Create();
  Ffield_dependencies := ArrayOfArtifactRule.Create();
end;

procedure ArtifactType.FreeObjectProperties();
begin
  if Assigned(Ffield_sets) then
    FreeAndNil(Ffield_sets);
  if Assigned(Ffield_dependencies) then
    FreeAndNil(Ffield_dependencies);
  inherited FreeObjectProperties();
end;

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

{ ArtifactFromReportResult }

constructor ArtifactFromReportResult.Create();
begin
  inherited Create();
  Fartifacts := ArrayOfArtifactFromReport.Create();
end;

procedure ArtifactFromReportResult.FreeObjectProperties();
begin
  if Assigned(Fartifacts) then
    FreeAndNil(Fartifacts);
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

{ Artifact }

constructor Artifact.Create();
begin
  inherited Create();
  Fextra_fields := ArrayOfArtifactFieldValue.Create();
end;

procedure Artifact.FreeObjectProperties();
begin
  if Assigned(Fextra_fields) then
    FreeAndNil(Fextra_fields);
  inherited FreeObjectProperties();
end;

{ Ugroup }

constructor Ugroup.Create();
begin
  inherited Create();
  Fmembers := ArrayOfUGroupMember.Create();
end;

procedure Ugroup.FreeObjectProperties();
begin
  if Assigned(Fmembers) then
    FreeAndNil(Fmembers);
  inherited FreeObjectProperties();
end;

{ TrackerDesc }

constructor TrackerDesc.Create();
begin
  inherited Create();
  Freports_desc := ArrayOfArtifactReportDesc.Create();
end;

procedure TrackerDesc.FreeObjectProperties();
begin
  if Assigned(Freports_desc) then
    FreeAndNil(Freports_desc);
  inherited FreeObjectProperties();
end;

{ ArtifactFieldSet }

constructor ArtifactFieldSet.Create();
begin
  inherited Create();
  Ffields := ArrayOfArtifactField.Create();
end;

procedure ArtifactFieldSet.FreeObjectProperties();
begin
  if Assigned(Ffields) then
    FreeAndNil(Ffields);
  inherited FreeObjectProperties();
end;

{ ArtifactField }

constructor ArtifactField.Create();
begin
  inherited Create();
  Favailable_values := ArrayOfArtifactFieldValueList.Create();
end;

procedure ArtifactField.FreeObjectProperties();
begin
  if Assigned(Favailable_values) then
    FreeAndNil(Favailable_values);
  inherited FreeObjectProperties();
end;

{ ArtifactReport }

constructor ArtifactReport.Create();
begin
  inherited Create();
  Ffields := ArrayOfArtifactReportField.Create();
end;

procedure ArtifactReport.FreeObjectProperties();
begin
  if Assigned(Ffields) then
    FreeAndNil(Ffields);
  inherited FreeObjectProperties();
end;

{ ArtifactFromReport }

constructor ArtifactFromReport.Create();
begin
  inherited Create();
  Ffields := ArrayOfArtifactFieldFromReport.Create();
end;

procedure ArtifactFromReport.FreeObjectProperties();
begin
  if Assigned(Ffields) then
    FreeAndNil(Ffields);
  inherited FreeObjectProperties();
end;

{ Metadata }

constructor Metadata.Create();
begin
  inherited Create();
  FlistOfValues := ArrayOfMetadataListValue.Create();
end;

procedure Metadata.FreeObjectProperties();
begin
  if Assigned(FlistOfValues) then
    FreeAndNil(FlistOfValues);
  inherited FreeObjectProperties();
end;

{ ArrayOfGroup }

function ArrayOfGroup.GetItem(AIndex: Integer): Group;
begin
  Result := Group(Inherited GetItem(AIndex));
end;

class function ArrayOfGroup.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Group;
end;

{ ArrayOfUgroup }

function ArrayOfUgroup.GetItem(AIndex: Integer): Ugroup;
begin
  Result := Ugroup(Inherited GetItem(AIndex));
end;

class function ArrayOfUgroup.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Ugroup;
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

{ ArrayOfUserInfo }

function ArrayOfUserInfo.GetItem(AIndex: Integer): UserInfo;
begin
  Result := UserInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfUserInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= UserInfo;
end;

{ ArrayOfTrackerDesc }

function ArrayOfTrackerDesc.GetItem(AIndex: Integer): TrackerDesc;
begin
  Result := TrackerDesc(Inherited GetItem(AIndex));
end;

class function ArrayOfTrackerDesc.GetItemClass(): TBaseRemotableClass;
begin
  Result:= TrackerDesc;
end;

{ ArrayOfArtifactType }

function ArrayOfArtifactType.GetItem(AIndex: Integer): ArtifactType;
begin
  Result := ArtifactType(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactType.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactType;
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

{ ArrayOfSortCriteria }

function ArrayOfSortCriteria.GetItem(AIndex: Integer): SortCriteria;
begin
  Result := SortCriteria(Inherited GetItem(AIndex));
end;

class function ArrayOfSortCriteria.GetItemClass(): TBaseRemotableClass;
begin
  Result:= SortCriteria;
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

{ ArrayOfArtifactFieldNameValue }

function ArrayOfArtifactFieldNameValue.GetItem(AIndex: Integer): ArtifactFieldNameValue;
begin
  Result := ArtifactFieldNameValue(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFieldNameValue.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFieldNameValue;
end;

{ ArrayOfArtifactFollowup }

function ArrayOfArtifactFollowup.GetItem(AIndex: Integer): ArtifactFollowup;
begin
  Result := ArtifactFollowup(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFollowup.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFollowup;
end;

{ ArrayOfArtifactCanned }

function ArrayOfArtifactCanned.GetItem(AIndex: Integer): ArtifactCanned;
begin
  Result := ArtifactCanned(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactCanned.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactCanned;
end;

{ ArrayOfArtifactReport }

function ArrayOfArtifactReport.GetItem(AIndex: Integer): ArtifactReport;
begin
  Result := ArtifactReport(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactReport.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactReport;
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

{ ArrayOfArtifactDependency }

function ArrayOfArtifactDependency.GetItem(AIndex: Integer): ArtifactDependency;
begin
  Result := ArtifactDependency(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactDependency.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactDependency;
end;

{ ArrayOfArtifactCC }

function ArrayOfArtifactCC.GetItem(AIndex: Integer): ArtifactCC;
begin
  Result := ArtifactCC(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactCC.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactCC;
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

{ ArrayOfFRSPackage }

function ArrayOfFRSPackage.GetItem(AIndex: Integer): FRSPackage;
begin
  Result := FRSPackage(Inherited GetItem(AIndex));
end;

class function ArrayOfFRSPackage.GetItemClass(): TBaseRemotableClass;
begin
  Result:= FRSPackage;
end;

{ ArrayOfFRSRelease }

function ArrayOfFRSRelease.GetItem(AIndex: Integer): FRSRelease;
begin
  Result := FRSRelease(Inherited GetItem(AIndex));
end;

class function ArrayOfFRSRelease.GetItemClass(): TBaseRemotableClass;
begin
  Result:= FRSRelease;
end;

{ ArrayOfFRSFile }

function ArrayOfFRSFile.GetItem(AIndex: Integer): FRSFile;
begin
  Result := FRSFile(Inherited GetItem(AIndex));
end;

class function ArrayOfFRSFile.GetItemClass(): TBaseRemotableClass;
begin
  Result:= FRSFile;
end;

{ ArrayOfDocman_Item }

function ArrayOfDocman_Item.GetItem(AIndex: Integer): Docman_Item;
begin
  Result := Docman_Item(Inherited GetItem(AIndex));
end;

class function ArrayOfDocman_Item.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Docman_Item;
end;

{ ArrayOfMetadata }

function ArrayOfMetadata.GetItem(AIndex: Integer): Metadata;
begin
  Result := Metadata(Inherited GetItem(AIndex));
end;

class function ArrayOfMetadata.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Metadata;
end;

{ ArrayOfItemInfo }

function ArrayOfItemInfo.GetItem(AIndex: Integer): ItemInfo;
begin
  Result := ItemInfo(Inherited GetItem(AIndex));
end;

class function ArrayOfItemInfo.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ItemInfo;
end;

{ ArrayOfPermission }

function ArrayOfPermission.GetItem(AIndex: Integer): Permission;
begin
  Result := Permission(Inherited GetItem(AIndex));
end;

class function ArrayOfPermission.GetItemClass(): TBaseRemotableClass;
begin
  Result:= Permission;
end;

{ ArrayOfMetadataValue }

function ArrayOfMetadataValue.GetItem(AIndex: Integer): MetadataValue;
begin
  Result := MetadataValue(Inherited GetItem(AIndex));
end;

class function ArrayOfMetadataValue.GetItemClass(): TBaseRemotableClass;
begin
  Result:= MetadataValue;
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

{ ArrayOfUGroupMember }

function ArrayOfUGroupMember.GetItem(AIndex: Integer): UGroupMember;
begin
  Result := UGroupMember(Inherited GetItem(AIndex));
end;

class function ArrayOfUGroupMember.GetItemClass(): TBaseRemotableClass;
begin
  Result:= UGroupMember;
end;

{ ArrayOfArtifactFieldSet }

function ArrayOfArtifactFieldSet.GetItem(AIndex: Integer): ArtifactFieldSet;
begin
  Result := ArtifactFieldSet(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFieldSet.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFieldSet;
end;

{ ArrayOfArtifactField }

function ArrayOfArtifactField.GetItem(AIndex: Integer): ArtifactField;
begin
  Result := ArtifactField(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactField.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactField;
end;

{ ArrayOfArtifactFieldValueList }

function ArrayOfArtifactFieldValueList.GetItem(AIndex: Integer): ArtifactFieldValueList;
begin
  Result := ArtifactFieldValueList(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFieldValueList.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFieldValueList;
end;

{ ArrayOfArtifactRule }

function ArrayOfArtifactRule.GetItem(AIndex: Integer): ArtifactRule;
begin
  Result := ArtifactRule(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactRule.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactRule;
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

{ ArrayOfArtifactReportDesc }

function ArrayOfArtifactReportDesc.GetItem(AIndex: Integer): ArtifactReportDesc;
begin
  Result := ArtifactReportDesc(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactReportDesc.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactReportDesc;
end;

{ ArrayOfArtifactReportField }

function ArrayOfArtifactReportField.GetItem(AIndex: Integer): ArtifactReportField;
begin
  Result := ArtifactReportField(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactReportField.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactReportField;
end;

{ ArrayOfArtifactFromReport }

function ArrayOfArtifactFromReport.GetItem(AIndex: Integer): ArtifactFromReport;
begin
  Result := ArtifactFromReport(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFromReport.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFromReport;
end;

{ ArrayOfArtifactFieldFromReport }

function ArrayOfArtifactFieldFromReport.GetItem(AIndex: Integer): ArtifactFieldFromReport;
begin
  Result := ArtifactFieldFromReport(Inherited GetItem(AIndex));
end;

class function ArrayOfArtifactFieldFromReport.GetItemClass(): TBaseRemotableClass;
begin
  Result:= ArtifactFieldFromReport;
end;

{ ArrayOfMetadataListValue }

function ArrayOfMetadataListValue.GetItem(AIndex: Integer): MetadataListValue;
begin
  Result := MetadataListValue(Inherited GetItem(AIndex));
end;

class function ArrayOfMetadataListValue.GetItemClass(): TBaseRemotableClass;
begin
  Result:= MetadataListValue;
end;


procedure Register_uWSDL_codendi_ServiceMetadata();
var
  mm : IModuleMetadataMngr;
begin
  mm := GetModuleMetadataMngr();
  mm.SetRepositoryNameSpace(sUNIT_NAME, sNAME_SPACE);
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'TRANSPORT_Address',
    'https://192.168.1.35:443/soap/'
  );
  mm.SetServiceCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'FORMAT_Style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'login',
    '_E_N_',
    'login'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'login',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'login',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#login'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'login',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'login',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'loginAs',
    '_E_N_',
    'loginAs'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'loginAs',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'loginAs',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#loginAs'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'loginAs',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'loginAs',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'retrieveSession',
    '_E_N_',
    'retrieveSession'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'retrieveSession',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'retrieveSession',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#retrieveSession'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'retrieveSession',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'retrieveSession',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getAPIVersion',
    '_E_N_',
    'getAPIVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getAPIVersion',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getAPIVersion',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getAPIVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getAPIVersion',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getAPIVersion',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'logout',
    '_E_N_',
    'logout'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'logout',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'logout',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#logout'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'logout',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'logout',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getMyProjects',
    '_E_N_',
    'getMyProjects'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getMyProjects',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getMyProjects',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getMyProjects'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getMyProjects',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getMyProjects',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupByName',
    '_E_N_',
    'getGroupByName'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupByName',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupByName',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getGroupByName'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupByName',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupByName',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupById',
    '_E_N_',
    'getGroupById'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupById',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupById',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getGroupById'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupById',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupById',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupUgroups',
    '_E_N_',
    'getGroupUgroups'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupUgroups',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupUgroups',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getGroupUgroups'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupUgroups',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getGroupUgroups',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getProjectGroupsAndUsers',
    '_E_N_',
    'getProjectGroupsAndUsers'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getProjectGroupsAndUsers',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getProjectGroupsAndUsers',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getProjectGroupsAndUsers'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getProjectGroupsAndUsers',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getProjectGroupsAndUsers',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'checkUsersExistence',
    '_E_N_',
    'checkUsersExistence'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'checkUsersExistence',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'checkUsersExistence',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#checkUsersExistence'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'checkUsersExistence',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'checkUsersExistence',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUserInfo',
    '_E_N_',
    'getUserInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUserInfo',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUserInfo',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getUserInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUserInfo',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUserInfo',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getTrackerList',
    '_E_N_',
    'getTrackerList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getTrackerList',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getTrackerList',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getTrackerList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getTrackerList',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getTrackerList',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactType',
    '_E_N_',
    'getArtifactType'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactType',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactType',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactType'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactType',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactType',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactTypes',
    '_E_N_',
    'getArtifactTypes'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactTypes',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactTypes',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactTypes'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactTypes',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactTypes',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifacts',
    '_E_N_',
    'getArtifacts'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifacts',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifacts',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifacts'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifacts',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifacts',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactsFromReport',
    '_E_N_',
    'getArtifactsFromReport'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactsFromReport',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactsFromReport',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactsFromReport'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactsFromReport',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactsFromReport',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifact',
    '_E_N_',
    'addArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifact',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifact',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifact',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifact',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactWithFieldNames',
    '_E_N_',
    'addArtifactWithFieldNames'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactWithFieldNames',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactWithFieldNames',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactWithFieldNames',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactWithFieldNames',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifact',
    '_E_N_',
    'updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifact',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifact',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifact',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifact',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactWithFieldNames',
    '_E_N_',
    'updateArtifactWithFieldNames'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactWithFieldNames',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactWithFieldNames',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactWithFieldNames',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactWithFieldNames',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactFollowups',
    '_E_N_',
    'getArtifactFollowups'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactFollowups',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactFollowups',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactFollowups'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactFollowups',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactFollowups',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCannedResponses',
    '_E_N_',
    'getArtifactCannedResponses'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCannedResponses',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCannedResponses',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactCannedResponses'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCannedResponses',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCannedResponses',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactReports',
    '_E_N_',
    'getArtifactReports'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactReports',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactReports',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactReports'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactReports',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactReports',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFiles',
    '_E_N_',
    'getArtifactAttachedFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFiles',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFiles',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactAttachedFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFiles',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFiles',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFile',
    '_E_N_',
    'getArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactAttachedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactById',
    '_E_N_',
    'getArtifactById'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactById',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactById',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactById'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactById',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactById',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactDependencies',
    '_E_N_',
    'getArtifactDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactDependencies',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactDependencies',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactDependencies',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactDependencies',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactInverseDependencies',
    '_E_N_',
    'getArtifactInverseDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactInverseDependencies',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactInverseDependencies',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactInverseDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactInverseDependencies',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactInverseDependencies',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactAttachedFile',
    '_E_N_',
    'addArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactAttachedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactAttachedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactAttachedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactAttachedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactAttachedFile',
    '_E_N_',
    'deleteArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactAttachedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactAttachedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteArtifactAttachedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactAttachedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactAttachedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactDependencies',
    '_E_N_',
    'addArtifactDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactDependencies',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactDependencies',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifactDependencies'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactDependencies',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactDependencies',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactDependency',
    '_E_N_',
    'deleteArtifactDependency'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactDependency',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactDependency',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteArtifactDependency'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactDependency',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactDependency',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactFollowup',
    '_E_N_',
    'addArtifactFollowup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactFollowup',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactFollowup',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifactFollowup'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactFollowup',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactFollowup',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactFollowUp',
    '_E_N_',
    'updateArtifactFollowUp'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactFollowUp',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactFollowUp',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactFollowUp',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateArtifactFollowUp',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactFollowUp',
    '_E_N_',
    'deleteArtifactFollowUp'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactFollowUp',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactFollowUp',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteArtifact'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactFollowUp',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactFollowUp',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'existArtifactSummary',
    '_E_N_',
    'existArtifactSummary'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'existArtifactSummary',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'existArtifactSummary',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#existArtifactSummary'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'existArtifactSummary',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'existArtifactSummary',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCCList',
    '_E_N_',
    'getArtifactCCList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCCList',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCCList',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactCCList'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCCList',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactCCList',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactCC',
    '_E_N_',
    'addArtifactCC'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactCC',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactCC',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addArtifactCC'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactCC',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addArtifactCC',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactCC',
    '_E_N_',
    'deleteArtifactCC'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactCC',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactCC',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteArtifactCC'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactCC',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteArtifactCC',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactHistory',
    '_E_N_',
    'getArtifactHistory'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactHistory',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactHistory',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getArtifactHistory'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactHistory',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getArtifactHistory',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getPackages',
    '_E_N_',
    'getPackages'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getPackages',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getPackages',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getPackages'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getPackages',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getPackages',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addPackage',
    '_E_N_',
    'addPackage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addPackage',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addPackage',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addPackage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addPackage',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addPackage',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getReleases',
    '_E_N_',
    'getReleases'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getReleases',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getReleases',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getReleases'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getReleases',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getReleases',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateRelease',
    '_E_N_',
    'updateRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateRelease',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateRelease',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateRelease',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateRelease',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addRelease',
    '_E_N_',
    'addRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addRelease',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addRelease',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addRelease',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addRelease',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFiles',
    '_E_N_',
    'getFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFiles',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFiles',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFiles',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFiles',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileInfo',
    '_E_N_',
    'getFileInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileInfo',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileInfo',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getFileInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileInfo',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileInfo',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFile',
    '_E_N_',
    'getFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileChunk',
    '_E_N_',
    'getFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getFileChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFile',
    '_E_N_',
    'addFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFileChunk',
    '_E_N_',
    'addFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFileChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFileChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFileChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addFileChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addUploadedFile',
    '_E_N_',
    'addUploadedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addUploadedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addUploadedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#addUploadedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addUploadedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'addUploadedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUploadedFiles',
    '_E_N_',
    'getUploadedFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUploadedFiles',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUploadedFiles',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getUploadedFiles'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUploadedFiles',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getUploadedFiles',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteFile',
    '_E_N_',
    'deleteFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyPackage',
    '_E_N_',
    'deleteEmptyPackage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyPackage',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyPackage',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteEmptyPackage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyPackage',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyPackage',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyRelease',
    '_E_N_',
    'deleteEmptyRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyRelease',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyRelease',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteEmptyRelease'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyRelease',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteEmptyRelease',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateFileComment',
    '_E_N_',
    'updateFileComment'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateFileComment',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateFileComment',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateFileComment'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateFileComment',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateFileComment',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getRootFolder',
    '_E_N_',
    'getRootFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getRootFolder',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getRootFolder',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getRootFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getRootFolder',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getRootFolder',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'listFolder',
    '_E_N_',
    'listFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'listFolder',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'listFolder',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#listFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'listFolder',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'listFolder',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'searchDocmanItem',
    '_E_N_',
    'searchDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'searchDocmanItem',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'searchDocmanItem',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#searchDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'searchDocmanItem',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'searchDocmanItem',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileContents',
    '_E_N_',
    'getDocmanFileContents'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileContents',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileContents',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanFileContents'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileContents',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileContents',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileMD5sum',
    '_E_N_',
    'getDocmanFileMD5sum'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileMD5sum',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileMD5sum',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanFileMD5sum'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileMD5sum',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileMD5sum',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileAllVersionsMD5sum',
    '_E_N_',
    'getDocmanFileAllVersionsMD5sum'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileAllVersionsMD5sum',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileAllVersionsMD5sum',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanFileAllVersionsMD5sum'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileAllVersionsMD5sum',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileAllVersionsMD5sum',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanProjectMetadata',
    '_E_N_',
    'getDocmanProjectMetadata'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanProjectMetadata',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanProjectMetadata',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanProjectMetadata'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanProjectMetadata',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanProjectMetadata',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanTreeInfo',
    '_E_N_',
    'getDocmanTreeInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanTreeInfo',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanTreeInfo',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanTreeInfo'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanTreeInfo',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanTreeInfo',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFolder',
    '_E_N_',
    'createDocmanFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFolder',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFolder',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFolder',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFolder',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFile',
    '_E_N_',
    'createDocmanFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFile',
    '_E_N_',
    'createDocmanEmbeddedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanEmbeddedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanWikiPage',
    '_E_N_',
    'createDocmanWikiPage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanWikiPage',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanWikiPage',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanWikiPage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanWikiPage',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanWikiPage',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanLink',
    '_E_N_',
    'createDocmanLink'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanLink',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanLink',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanLink'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanLink',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanLink',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmptyDocument',
    '_E_N_',
    'createDocmanEmptyDocument'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmptyDocument',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmptyDocument',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanEmptyDocument'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmptyDocument',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmptyDocument',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFileVersion',
    '_E_N_',
    'createDocmanFileVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFileVersion',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFileVersion',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanFileVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFileVersion',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanFileVersion',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFileVersion',
    '_E_N_',
    'createDocmanEmbeddedFileVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFileVersion',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFileVersion',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#createDocmanEmbeddedFileVersion'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFileVersion',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'createDocmanEmbeddedFileVersion',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'appendDocmanFileChunk',
    '_E_N_',
    'appendDocmanFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'appendDocmanFileChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'appendDocmanFileChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#appendDocmanFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'appendDocmanFileChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'appendDocmanFileChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'moveDocmanItem',
    '_E_N_',
    'moveDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'moveDocmanItem',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'moveDocmanItem',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#moveDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'moveDocmanItem',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'moveDocmanItem',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileChunk',
    '_E_N_',
    'getDocmanFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileChunk',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileChunk',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#getDocmanFileChunk'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileChunk',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'getDocmanFileChunk',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteDocmanItem',
    '_E_N_',
    'deleteDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteDocmanItem',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteDocmanItem',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#deleteDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteDocmanItem',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'deleteDocmanItem',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'monitorDocmanItem',
    '_E_N_',
    'monitorDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'monitorDocmanItem',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'monitorDocmanItem',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#monitorDocmanItem'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'monitorDocmanItem',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'monitorDocmanItem',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFolder',
    '_E_N_',
    'updateDocmanFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFolder',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFolder',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanFolder'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFolder',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFolder',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFile',
    '_E_N_',
    'updateDocmanFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmbeddedFile',
    '_E_N_',
    'updateDocmanEmbeddedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmbeddedFile',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmbeddedFile',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanEmbeddedFile'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmbeddedFile',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmbeddedFile',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanWikiPage',
    '_E_N_',
    'updateDocmanWikiPage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanWikiPage',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanWikiPage',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanWikiPage'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanWikiPage',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanWikiPage',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanLink',
    '_E_N_',
    'updateDocmanLink'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanLink',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanLink',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanLink'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanLink',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanLink',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmptyDocument',
    '_E_N_',
    'updateDocmanEmptyDocument'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmptyDocument',
    'style',
    'rpc'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmptyDocument',
    'TRANSPORT_soapAction',
    'https://192.168.1.35#updateDocmanEmptyDocument'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmptyDocument',
    'FORMAT_Input_EncodingStyle',
    'encoded'
  );
  mm.SetOperationCustomData(
    sUNIT_NAME,
    'CodendiAPIPortType',
    'updateDocmanEmptyDocument',
    'FORMAT_OutputEncodingStyle',
    'encoded'
  );
end;


var
  typeRegistryInstance : TTypeRegistry = nil;
initialization
  typeRegistryInstance := GetTypeRegistry();

  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Session),'Session');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Group),'Group');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(UserInfo),'UserInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactType),'ArtifactType');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactQueryResult),'ArtifactQueryResult');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFromReportResult),'ArtifactFromReportResult');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFile),'ArtifactFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Artifact),'Artifact');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(FRSFile),'FRSFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Revision),'Revision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Commiter),'Commiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathInfo),'SvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SvnPathDetails),'SvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescField),'DescField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(DescFieldValue),'DescFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ServiceValue),'ServiceValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(UGroupMember),'UGroupMember');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Ugroup),'Ugroup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(TrackerDesc),'TrackerDesc');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldSet),'ArtifactFieldSet');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactField),'ArtifactField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldValue),'ArtifactFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldNameValue),'ArtifactFieldNameValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldValueList),'ArtifactFieldValueList');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactRule),'ArtifactRule');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Criteria),'Criteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(SortCriteria),'SortCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactCanned),'ArtifactCanned');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFollowup),'ArtifactFollowup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactReport),'ArtifactReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactReportDesc),'ArtifactReportDesc');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactReportField),'ArtifactReportField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactCC),'ArtifactCC');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactDependency),'ArtifactDependency');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactHistory),'ArtifactHistory');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFromReport),'ArtifactFromReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArtifactFieldFromReport),'ArtifactFieldFromReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(FRSPackage),'FRSPackage');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(FRSRelease),'FRSRelease');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Docman_Item),'Docman_Item');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Permission),'Permission');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(MetadataValue),'MetadataValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(MetadataListValue),'MetadataListValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(Metadata),'Metadata');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ItemInfo),'ItemInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfGroup),'ArrayOfGroup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUgroup),'ArrayOfUgroup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfstring),'ArrayOfstring');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUserInfo),'ArrayOfUserInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfTrackerDesc),'ArrayOfTrackerDesc');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactType),'ArrayOfArtifactType');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfCriteria),'ArrayOfCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSortCriteria),'ArrayOfSortCriteria');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldValue),'ArrayOfArtifactFieldValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldNameValue),'ArrayOfArtifactFieldNameValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFollowup),'ArrayOfArtifactFollowup');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactCanned),'ArrayOfArtifactCanned');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactReport),'ArrayOfArtifactReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFile),'ArrayOfArtifactFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactDependency),'ArrayOfArtifactDependency');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactCC),'ArrayOfArtifactCC');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactHistory),'ArrayOfArtifactHistory');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfFRSPackage),'ArrayOfFRSPackage');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfFRSRelease),'ArrayOfFRSRelease');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfFRSFile),'ArrayOfFRSFile');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDocman_Item),'ArrayOfDocman_Item');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfMetadata),'ArrayOfMetadata');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfItemInfo),'ArrayOfItemInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfPermission),'ArrayOfPermission');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfMetadataValue),'ArrayOfMetadataValue');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfInteger),'ArrayOfInteger');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOflong),'ArrayOflong');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfint),'ArrayOfint');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfRevision),'ArrayOfRevision');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfCommiter),'ArrayOfCommiter');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathInfo),'ArrayOfSvnPathInfo');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfSvnPathDetails),'ArrayOfSvnPathDetails');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFields),'ArrayOfDescFields');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfDescFieldsValues),'ArrayOfDescFieldsValues');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfServicesValues),'ArrayOfServicesValues');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfUGroupMember),'ArrayOfUGroupMember');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldSet),'ArrayOfArtifactFieldSet');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactField),'ArrayOfArtifactField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldValueList),'ArrayOfArtifactFieldValueList');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactRule),'ArrayOfArtifactRule');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifact),'ArrayOfArtifact');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactReportDesc),'ArrayOfArtifactReportDesc');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactReportField),'ArrayOfArtifactReportField');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfInt),'ArrayOfInt');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFromReport),'ArrayOfArtifactFromReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfArtifactFieldFromReport),'ArrayOfArtifactFieldFromReport');
  typeRegistryInstance.Register(sNAME_SPACE,TypeInfo(ArrayOfMetadataListValue),'ArrayOfMetadataListValue');

  typeRegistryInstance.ItemByTypeInfo[TypeInfo(ArtifactFieldSet)].RegisterExternalPropertyName('_label','label');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(ArtifactField)].RegisterExternalPropertyName('_label','label');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(Criteria)].RegisterExternalPropertyName('_operator','operator');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(Permission)].RegisterExternalPropertyName('_type','type');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(MetadataValue)].RegisterExternalPropertyName('_label','label');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(Metadata)].RegisterExternalPropertyName('_label','label');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(Metadata)].RegisterExternalPropertyName('_type','type');
  typeRegistryInstance.ItemByTypeInfo[TypeInfo(ItemInfo)].RegisterExternalPropertyName('_type','type');


End.
