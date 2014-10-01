{-
ModelMaker 7 code
Copyright (C) 1994-2004
ModelMaker Tools
http://www.modelmakertools.com

No part of this code may be used or copied without
written permission of ModelMaker Tools
}

// ModelMaker Open Tool Services API
// Date: 6 Jan 2004

unit MMToolsApi;

interface

uses Windows, SysUtils, Classes, MMEngineDefs, MMDiagramAPI;

const
// Any expert should implement a MMExpertVersionProc (defined at the bottom of this unit)
// and return this version number. When loading the expert ModelMaker will check the version
  MMToolsApiVersion = 9;

// TODO -cToolsAPI V10: remove V9Visbility
// TODO -cToolsAPI V10: replace stdcall methods with safecall 

type
// MenuPositions in experts. Not all may actually be supported in ModelMaker,
// unsupported positions are added to the ToolsMenu
  TMMMenuPosition = (mpToolsMenu, mpHelpMenu, mpVCSMenu, mpClassesMenu,
                     mpMembersMenu, mpUnitsMenu, mpDiagramMenu, mpDiagramEditorMenu);
  TMMMenuPositions = set of TMMMenuPosition;
  TMMVCSFileStatus = (fsUnknown, fsNotCheckedOut, fsCheckedOut, fsCheckedOutMe);

  TMMViewType = (vtClasses, vtUnits, vtDiagrams, vtMembers, vtMethodEditor,
                 vtUnitEditor, vtDiagramEditor, vtMacros, vtPatterns, vtDifference,
                 vtDocumentation, vtEventTypes, vtMessages, vtDesignCritics);

// types and consts for MessageServer and DesignCriticManager
type
  TMMMsgPriority = 0..5;
  TMMMessageType = (mmtError, mmtWarning, mmtInformation, mmtToDo, mmtDone);

const
// Predefined Msg Container identifers for IMMMessageServer
// Create new Msg containers (=tabs) using IMMMessageServer.RegisterContainer
  MMMessagesContainer = 0;
  MMToDoContainer = 1;
  MMCriticsContainer = 2;
// AllContainers can be used to mark all Containers rather than a specific one
// In calls to IMMMessageServer methods
  AllContainers = -1;

// Classifier types, check IMMClassifier (IMMV10Classifier)
type
  TMMClassifierKind = (clkClass, clkInterface, clkRecord);
  TMMClassifiers = set of TMMClassifierKind;

const
  AllMMClassifiers = [clkClass, clkInterface, clkRecord];

type
  TV9Visibility = (vis9Default, vis9Private, vis9Protected, vis9Public, vis9Published, vis9Automated, vis9StrictPrivate, vis9StrictProtected);

type
  IMMNotifier = interface;
  IMMMember = interface;
  IMMField = interface;
  IMMMethod = interface;
  IMMProperty = interface;
  IMMEvent = interface;
  IMMResClause = interface;
  IMMModuleExplorer = interface;
  IMMMessage = interface;
  IMMToolServices = interface;

  IMMInterface = interface;
  {:
  GetCustomMenuData is used to insert menu items in non predefined menus and/or
  to insert sub menus. The format of the returned string should be one line per menu item definition
  Each line defines a menu item path and it's associated ActionIndex separated by a "=" (omit the quotes).
  The menu item path is a '\' separated list of menu items. Each element must be a valid and unqiue identifier.
  If a menu item with such a name is not found, it is created with default attributes.
  The ActionIndex associates the menu item with it's attributes like Caption, Hint, ShortCut etc.
  MM fetches the data for a menu item by calling the Expert's GetActionData method.
  If the ActionIndex is undefined, a default value of ActionIndex=-1 is assumed.
  Note: the actions could be linked to a an index in a TActionList and GetActionData would then
  return the data for the Action.

  For example:
  MainMenu\MainToolsItem\MyExpertItem=0
  MainMenu\MainToolsItem\MyExpertItem\DoThisItem=1
  MainMenu\MainToolsItem\MyExpertItem\DoThatItem=2
  MainMenu\MySamples=3
  MainMenu\MySamples\Sample1=4
  MainMenu\MySamples\Sample1\Sample1Sub1=5
  MainMenu\MySamples\Sample1\Sample1Sub2=6

  The existing MM main menu items have names like "MainXYZItem" where XYZ is the menu caption
  is the NON localized version of ModelMaker: MainFileItem, MainViewItem, MainOptionsItem etc.
  An invisible MainDebugItem exists. Do not use that name.

  Available popup menu IDs are
  ClassesPopup
  ClassesPopop\WizardsItem
  DiagramEditorPopup
  DiagramEditorPopup\WizardsItem
  DiagramsPopup
  DiagramsPopup\WizardsItem
  MembersPopup
  MembersPopup\WizardsItem
  UnitsPopup
  UnitsPopup\WizardsItem

  For example
  ClassesPopop\WizardsItem\NewItem=7
  ClassesPopop\WizardsItem\NewItem\Sub1=8

  GetActionData is called on inserting the menu items as defined in GetCustomMenuData.
  If GetActionData sets the TMMActionData.Updated field to True, GetActionData will be called
  for the item before it's being shown in a menu. This enables making the inserted menu item dynamic
  TMMActionData.ImageIndex is available only for toolbar buttons and is ignored for menu items.

  GetCustomToolbarData is similar to GetCustomMenuData and is used to add buttons
  to toolbars. Buttons normal or dropdownstyle toolbuttons and association with an action.
  To create a dropdown style button, add the dropdown items after defining the button.
  The dropdown items can contain submenu items.

  The available toolbar IDs are (just one)
  MainToolbar

  For example
  MainToolBar\MyButton0=0
  MainToolBar\MyButton1=1
  MainToolBar\MyButton1\DropDownItem0=2
  MainToolBar\MyButton1\DropDownItem1=3
  MainToolBar\MyButton1\DropDownSubmenu=4
  MainToolBar\MyButton1\DropDownSubmenu\Sub1=5
  MainToolBar\MyButton1\DropDownSubmenu\Sub2=6

  If the ActionData.Update = True, Toolbar buttons are updated very often and the associated
  code should be kept to a minimum. Also do not store references to any model entities in
  the update handlers.

  The actions are executed by calling the expert's ExecuteAction method.
  An ActionIndex of -1 (the default for undefined items) is NOT passed to the expert.
  }

  TMMActionData = record
    Caption: WideString; // ModelMaker provides a defaults name based on to the menu item name
    ImageIndex: Integer; // Default = -1; Only used for toolbuttons, ignored for menu items
    Hint: WideString; // Default = ''
    Checked: Boolean; // Default = False
    Enabled: Boolean; // Default = True
    Visible: Boolean; // Default = True
    Updated: Boolean; // Default = False. Setting Updated = True lets MM call GetActionData
                      // before the menu item is being shown
    ShortCut: Word; // Mapped on TShortCut, Default = 0 (none) ShortCut is static and not updated.
  end;

  IMMExpert = interface (IUnknown)
    ['{4494D382-D2DF-11D2-AA22-204C4F4F5020}']
    procedure Destroyed; safecall;
    procedure Execute(Index: Integer); safecall;
    procedure ExecuteAction(Index: Integer); safecall;
    function ExpertID: WideString; safecall;
    function GetActionCount: Integer; safecall;
    procedure GetActionData(Index: Integer; var Data: TMMActionData); safecall;
    {:
    This allows adding images contained in an imagelist to the main image list.
    It is called once when MM is creating toolbars.
    The passed ImageIndexOffset is the ImageIndex of the first image added.
    Return True if the expert wants to add images, else False.
    Only if True is returned the Images (which should be a HIMAGELIST) must be a valid
    imagelist handle. The images must be 16x16.
    }
    function GetCustomImages(ImageIndexOffset: Integer; var Images: THandle): Boolean; 
            safecall;
    function GetCustomMenuData: WideString; safecall;
    function GetCustomToolbarData: WideString; safecall;
    function GetMenuPositions(Index: Integer): TMMMenuPosition; safecall;
    function GetMenuShortCuts(Index: Integer): TShortCut; safecall;
    function GetVerbCount: Integer; safecall;
    function GetVerbs(Index: Integer): WideString; safecall;
    property ActionCount: Integer read GetActionCount;
    property MenuPositions[Index: Integer]: TMMMenuPosition read GetMenuPositions;
    property MenuShortCuts[Index: Integer]: TShortCut read GetMenuShortCuts;
    property VerbCount: Integer read GetVerbCount;
    property Verbs[Index: Integer]: WideString read GetVerbs;
  end;
  
  IMMVCSExpert = interface (IMMExpert)
    ['{4494D383-D2DF-11D2-AA22-204C4F4F5020}']
    procedure CheckIn(const VCSProject, RelFileName, FileName: WideString); safecall;
    procedure CheckOut(const VCSProject, RelFileName, FileName: WideString); safecall;
    function GetAvailable: Boolean; safecall;
    procedure GetFileStatus(const VCSProject, RelFileName, FileName: WideString; var 
            Status: TMMVCSFileStatus); safecall;
    procedure VCSExecute(Index: Integer; const VCSProject, RelFileName, FileName: 
            WideString); safecall;
    property Available: Boolean read GetAvailable;
  end;
  
  IMMNotifier = interface (IUnknown)
    ['{4E2ACF11-DDCB-11D2-AA37-204C4F4F5020}']
    procedure Destroyed; safecall;
  end;
  
  IMMProjectNotifier = interface (IMMNotifier)
    ['{4E2ACF13-DDCB-11D2-AA37-204C4F4F5020}']
    procedure AfterNew; safecall;
    procedure AfterOpen(const FileName: WideString); safecall;
    procedure AfterSave(const FileName: WideString); safecall;
    {:
    AfterStartup is called after all views are created and possibly a previous project 
    has been loaded
    }
    procedure AfterStartup; safecall;
    procedure BeforeNew(var Cancel: Boolean); safecall;
    procedure BeforeOpen(const FileName: WideString; var Cancel: Boolean); safecall;
    procedure BeforeSave(const FileName: WideString; var Cancel: Boolean); safecall;
    {:
    BeforeShutDown is called just before tearing down the application and before the 
    experts are unloaded.
    }
    procedure BeforeShutDown; safecall;
    procedure CommitEditors; safecall;
    {:
    ExpertsLoaded is called after all experts are loaded but before the views are 
    inserted.
    }
    procedure ExpertsLoaded; safecall;
  end;
  
  IMMModelPart = interface (IUnknown)
    ['{FE015730-D57D-11D2-AA26-204C4F4F5020}']
    procedure Delete; safecall;
    function Edit: Boolean; safecall;
    function GetCategory: WideString; safecall;
    function GetDeclaration: WideString; safecall;
    function GetDocumentation: WideString; safecall;
    function GetID: LongInt; safecall;
    function GetName: WideString; safecall;
    function GetOneLiner: WideString; safecall;
    function GetOptions(Index: Integer): Boolean; safecall;
    function GetOwnerID: LongInt; safecall;
    function GetOwnerInfo: LongInt; safecall;
    function GetTaggedValueCount: Integer; safecall;
    function GetTaggedValueNames(Index: Integer): WideString; safecall;
    function GetTaggedValues(const TagName: WideString): WideString; safecall;
    function GetValid: Boolean; safecall;
    function GetVisible: Boolean; safecall;

    procedure SetCategory(const Value: WideString); safecall;
    procedure SetDocumentation(const Value: WideString); safecall;
    procedure SetName(const Value: WideString); safecall;
    procedure SetOneLiner(const Value: WideString); safecall;
    procedure SetOptions(Index: Integer; Value: Boolean); safecall;
    procedure SetTaggedValues(const TagName: WideString; const Value: WideString);
            safecall;
    procedure SetVisible(const Value: Boolean); safecall;

    property Category: WideString read GetCategory write SetCategory;
    property Declaration: WideString read GetDeclaration;
    property Documentation: WideString read GetDocumentation write SetDocumentation;
    property ID: LongInt read GetID;
    property Name: WideString read GetName write SetName;
    property OneLiner: WideString read GetOneLiner write SetOneLiner;
    property Options[Index: Integer]: Boolean read GetOptions write SetOptions;
    property OwnerID: LongInt read GetOwnerID;
    property OwnerInfo: LongInt read GetOwnerInfo;
    {:
    Returns the number of (external) tagged values stored with this entity.
    }
    property TaggedValueCount: Integer read GetTaggedValueCount;
    {:
    Returns the tagged value names.
    }
    property TaggedValueNames[Index: Integer]: WideString read GetTaggedValueNames;
    {:
    Reads/writes tagged values. External applications can store additional data in this
    property. The TagName should be unique identifier. The best way to garantuee this is
    to use names like: "myexpertname.propname". Expert names (as defined by IMMExpert)
    must be unqiue and therefore the property names will be garantueed to be unique.
    }
    property TaggedValues[const TagName: WideString]: WideString read GetTaggedValues
            write SetTaggedValues;
    property Valid: Boolean read GetValid;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  IMMV10ModelPart = interface(IMMModelPart)
    ['{65F41E98-1156-4F52-94FB-90D277918232}']
    procedure AddAttribute(const Attribute: WideString); safecall;
    function GetAttributes: WideString; safecall;
    procedure SetAttributes(const Value: WideString); safecall;
    property Attributes: WideString read GetAttributes write SetAttributes;
  end;

  IMMEventType = interface (IMMModelPart)
    ['{30DD230E-BC1F-41E6-B584-3AB057A5515D}']
    function GetCallConvention: TCallConvention; safecall;
    function GetDataName: WideString; safecall;
    function GetMethodKind: TMethodKind; safecall;
    function GetParameters: WideString; safecall;
    procedure SetCallConvention(Value: TCallConvention); safecall;
    procedure SetDataName(const Value: WideString); safecall;
    procedure SetMethodKind(Value: TMethodKind); safecall;
    procedure SetParameters(const Value: WideString); safecall;
    property CallConvention: TCallConvention read GetCallConvention write 
            SetCallConvention;
    property DataName: WideString read GetDataName write SetDataName;
    property MethodKind: TMethodKind read GetMethodKind write SetMethodKind;
    property Parameters: WideString read GetParameters write SetParameters;
  end;
  
  IMMEventLibrary = interface (IUnknown)
    ['{E4648C51-D496-11D2-AA25-204C4F4F5020}']
    function AddEvent: IMMEventType; safecall;
    procedure BeginUpdate; safecall;
    procedure DeleteEvent(Index: Integer); safecall;
    procedure EndUpdate; safecall;
    function FindEventOnID(ID: Integer; var Index: Integer): Boolean; safecall;
    function FindEventOnName(const Name: WideString; var Index: Integer): Boolean;
            safecall;
    function GetEventCount: Integer; safecall;
    function GetEvents(Index: Integer): IMMEventType; safecall;
    function GetValid: Boolean; stdcall;
    property EventCount: Integer read GetEventCount;
    property Events[Index: Integer]: IMMEventType read GetEvents;
    property Valid: Boolean read GetValid;
  end;

  {:
  Warning: it's no longer safe to use IsInterface to discriminate between classes and interfaces
  because IsInterface will return False for both records and classes.
  if not IsInterface then // could be Class or Record
  Cast a IMMClassifier as IMMV10Classifier and use ClassifierKind to check the actual type
  or use QueryInterface(IMMClass, )
  }
  IMMClassifier = interface (IMMModelPart)
    ['{FE015731-D57D-11D2-AA26-204C4F4F5020}']
    function AddEvent: IMMEvent; safecall;
    function AddField: IMMField; safecall;
    function AddMethod: IMMMethod; safecall;
    function AddProperty: IMMProperty; safecall;
    function AddResClause: IMMResClause; safecall;
    procedure CustomOrderChanged; safecall;
    function FindInheritedMethod(const AName: WideString; const Params: WideString = '';
            Exact: Boolean = False): IMMMethod; safecall;
    function FindMember(const AName: WideString; var Index: Integer): Boolean; safecall;
    function FindMemberOnID(MemberID: Integer): IMMMember; safecall;
    function FindMethod(const AName: WideString; const Params: WideString = ''; Exact:
            Boolean = False): IMMMethod; safecall;
    function GetAncestor: IMMClassifier; safecall;
    function GetDescendantCount: Integer; safecall;
    function GetDescendants(Index: Integer): IMMClassifier; safecall;
    function GetIsInterface: Boolean; safecall;
    function GetIsPersistent: Boolean; safecall;
    function GetMemberCount: Integer; safecall;
    function GetMembers(Index: Integer): IMMMember; safecall;
    function GetPersistency: TClassPersistency; safecall;
    function IsClass(ClassID: Integer): Boolean; overload; safecall;
    function IsClass(C: IMMClassifier): Boolean; overload; safecall;
    procedure SetAncestor(const Value: IMMClassifier); safecall;
    procedure SetPersistency(const Value: TClassPersistency); safecall;
    property Ancestor: IMMClassifier read GetAncestor write SetAncestor;
    property DescendantCount: Integer read GetDescendantCount;
    property Descendants[Index: Integer]: IMMClassifier read GetDescendants;
    property IsInterface: Boolean read GetIsInterface;
    property IsPersistent: Boolean read GetIsPersistent;
    property MemberCount: Integer read GetMemberCount;
    property Members[Index: Integer]: IMMMember read GetMembers;
    property Persistency: TClassPersistency read GetPersistency write SetPersistency;
  end;

  IMMClassBase = IMMClassifier;

  IMMMemberMapping = interface(IUnknown)
  ['{6D418296-3C98-49F0-A856-1AF8DFF4BCCC}']
    function GetImplMember: IMMMember; safecall;
    function GetIntfMember: IMMMember; safecall;
    function GetValid: Boolean; safecall;
    property ImplMember: IMMMember read GetImplMember;
    property IntfMember: IMMMember read GetIntfMember;
    property Valid: Boolean read GetValid;
  end;

  IMMInterfaceMapping = interface(IUnknown)
  ['{58A92B1F-C916-43FF-9DF3-D543B9F40DAA}']
    function GetCount: Integer; stdcall;
    function GetMap(Index: Integer): IMMMemberMapping; stdcall;
    property Count: Integer read GetCount;
    property Map[Index: Integer]: IMMMemberMapping read GetMap; default;
  end;

  IMMV10Classifier = interface (IMMClassifier)
    ['{7F252B45-4949-42CF-A4E6-08E902FDF9F1}']
    function GetClassifierKind: TMMClassifierKind; safecall;
    procedure CreateInterfaceMap(out Map: IMMInterfaceMapping); safecall;
  end;

  IMMMember = interface (IMMModelPart)
    ['{A445C143-DB00-11D2-AA32-204C4F4F5020}']

    function GetClassBase: IMMClassifier; safecall;
    function GetCustomOrder: Integer; safecall;
    function GetDataName: WideString; safecall;
    function GetMemberType: TMemberType; safecall;
    function GetV9Visibility: TV9Visibility; safecall;

    procedure SetCustomOrder(Value: Integer); safecall;
    procedure SetDataName(const Value: WideString); safecall;
    procedure SetV9Visibility(Value: TV9Visibility); safecall;

    property ClassBase   : IMMClassifier read GetClassBase ;
    property CustomOrder : Integer       read GetCustomOrder  write SetCustomOrder ;
    property DataName    : WideString    read GetDataName     write SetDataName    ;
    property MemberType  : TMemberType   read GetMemberType;
    property V9Visibility: TV9Visibility read GetV9Visibility write SetV9Visibility;
  end;

  IMMV10Member = interface (IMMMember)
    ['{011D4505-5B8B-4FCE-B4B1-A4D738D8D6F8}']
    function GetDispIDStr: WideString; safecall;
    procedure SetDispIDStr(const Value: WideString); safecall;
    function GetVisibility: TVisibility; safecall;
    procedure SetVisibility(const Value: TVisibility); safecall;
    property DispIDStr: WideString read GetDispIDStr write SetDispIDStr;
    property Visibility: TVisibility read GetVisibility write SetVisibility;
  end;

  IMMField = interface (IMMMember)
    ['{A445C144-DB00-11D2-AA32-204C4F4F5020}']
  end;

  IMMV10Field = interface(IMMField)
  ['{19EFB4F9-4AF1-4F91-B460-37F60609A229}']
    function GetFieldKind: TFieldKind; safecall;
    function GetInitializer: WideString; safecall;
    procedure SetFieldKind(const Value: TFieldKind); safecall;
    procedure SetInitializer(const Value: WideString); safecall;
    property FieldKind: TFieldKind read GetFieldKind write SetFieldKind;
    property Initializer: WideString read GetInitializer write SetInitializer;
  end;

  IMMMethod = interface (IMMMember)
    ['{A445C145-DB00-11D2-AA32-204C4F4F5020}']
    procedure AddLocalVar(const Value: WideString); safecall;
    procedure AddSection(const Value: WideString); safecall;
    function GetAsText: WideString; safecall;
    function GetBindingKind: TBindingKind; safecall;
    function GetCallConvention: TCallConvention; safecall;
    function GetCustomImplOrder: Integer; safecall;
    function GetInheritedMethod: IMMMethod; safecall;
    function GetInstrumented: Boolean; safecall;
    function GetIsAbstract: Boolean; safecall;
    function GetLocalCode: WideString; safecall;
    function GetLocalVarCount: Integer; safecall;
    function GetLocalVars(Index: Integer): WideString; safecall;
    function GetMethodKind: TMethodKind; safecall;
    function GetParameters: WideString; safecall;
    function GetSectionCount: Integer; safecall;
    function GetSections(Index: Integer): WideString; safecall;
    function GetSectionState(Index: Integer): TSectionState; safecall;
    procedure InsertLocalVar(Index: Integer; const Value: WideString); safecall;
    procedure InsertSection(Index: Integer; const Value: WideString); safecall;
    procedure RemoveLocalVar(Index: Integer); safecall;
    procedure RemoveSection(Index: Integer); safecall;
    procedure SetBindingKind(Value: TBindingKind); safecall;
    procedure SetCallConvention(Value: TCallConvention); safecall;
    procedure SetCustomImplOrder(Value: Integer); safecall;
    procedure SetInstrumented(Value: Boolean); safecall;
    procedure SetIsAbstract(Value: Boolean); safecall;
    procedure SetLocalCode(const Value: WideString); safecall;
    procedure SetLocalVars(Index: Integer; const Value: WideString); safecall;
    procedure SetMethodKind(Value: TMethodKind); safecall;
    procedure SetParameters(const Value: WideString); safecall;
    procedure SetSections(Index: Integer; const Value: WideString); safecall;
    property AsText: WideString read GetAsText;
    property BindingKind: TBindingKind read GetBindingKind write SetBindingKind;
    property CallConvention: TCallConvention read GetCallConvention write 
            SetCallConvention;
    property CustomImplOrder: Integer read GetCustomImplOrder write SetCustomImplOrder;
    property InheritedMethod: IMMMethod read GetInheritedMethod;
    property Instrumented: Boolean read GetInstrumented write SetInstrumented;
    property IsAbstract: Boolean read GetIsAbstract write SetIsAbstract;
    property LocalCode: WideString read GetLocalCode write SetLocalCode;
    property LocalVarCount: Integer read GetLocalVarCount;
    property LocalVars[Index: Integer]: WideString read GetLocalVars write SetLocalVars;
    property MethodKind: TMethodKind read GetMethodKind write SetMethodKind;
    property Parameters: WideString read GetParameters write SetParameters;
    property SectionCount: Integer read GetSectionCount;
    property Sections[Index: Integer]: WideString read GetSections write SetSections;
    property SectionState[Index: Integer]: TSectionState read GetSectionState;
  end;

  IMMV10Method = interface (IUnknown)
    ['{7A36A3F9-1E39-4EA9-AC4E-85984806600E}']
    function GetCallParams: WideString; safecall;
    property CallParams: WideString read GetCallParams;
  end;



  {:
  InstantObjects (IO) persistency framework support.
  IsIOAttribute returns True if the property is an InstantObjects persistent attribute
  in this case IOStateField returns the InstantObjects state field.
  In general Experts should never need try modify a property that is an IOAttribute.
  }
  IMMProperty = interface (IMMMember)
    ['{A445C146-DB00-11D2-AA32-204C4F4F5020}']
    function FindDefiningProperty: IMMProperty; safecall;
    function FindInheritedProperty: IMMProperty; safecall;
    function GetArraySpec: WideString; safecall;
    function GetCustomReadSpec: WideString; safecall;
    function GetCustomWriteSpec: WideString; safecall;
    function GetDefaultSpec: TDefaultSpecifier; safecall;
    function GetDefaultSpecStr: WideString; safecall;
    function GetImplementsSpec: WideString; safecall;
    function GetIndexSpec: WideString; safecall;
    function GetIOStateField: IMMField; stdcall;
    function GetIsIOAttribute: Boolean; stdcall;
    function GetReadAccess: TRWAccessEx; safecall;
    function GetReadMember: IMMMember; safecall;
    function GetReadSpec: WideString; safecall;
    function GetStorageSpec: WideString; safecall;
    function GetWriteAccess: TRWAccessEx; safecall;
    function GetWriteMember: IMMMember; safecall;
    function GetWriteParameter: WideString; safecall;
    function GetWriteSpec: WideString; safecall;
    procedure LinkAccessMembers(const ReadMember, WriteMember: WideString); safecall;
    procedure SetAccessSpec(R, W: TRWAccessEx); safecall;
    procedure SetArraySpec(const Value: WideString); safecall;
    procedure SetCustomReadSpec(const Value: WideString); safecall;
    procedure SetCustomWriteSpec(const Value: WideString); safecall;
    procedure SetDefaultSpec(const Value: TDefaultSpecifier); safecall;
    procedure SetDefaultSpecStr(const Value: WideString); safecall;
    procedure SetImplementsSpec(const Value: WideString); safecall;
    procedure SetIndexSpec(const Value: WideString); safecall;
    procedure SetLinks(RA, WA: TRWAccessEx; StateField: Boolean); safecall;
    procedure SetStorageSpec(const Value: WideString); safecall;
    procedure SetWriteParameter(const Value: WideString); safecall;
    property ArraySpec: WideString read GetArraySpec write SetArraySpec;
    property CustomReadSpec: WideString read GetCustomReadSpec write SetCustomReadSpec;
    property CustomWriteSpec: WideString read GetCustomWriteSpec write SetCustomWriteSpec;
    property DefaultSpec: TDefaultSpecifier read GetDefaultSpec write SetDefaultSpec;
    property DefaultSpecStr: WideString read GetDefaultSpecStr write SetDefaultSpecStr;
    property ImplementsSpec: WideString read GetImplementsSpec write SetImplementsSpec;
    property IndexSpec: WideString read GetIndexSpec write SetIndexSpec;
    property IOStateField: IMMField read GetIOStateField;
    property IsIOAttribute: Boolean read GetIsIOAttribute;
    property ReadAccess: TRWAccessEx read GetReadAccess;
    property ReadMember: IMMMember read GetReadMember;
    property ReadSpec: WideString read GetReadSpec;
    property StorageSpec: WideString read GetStorageSpec write SetStorageSpec;
    property WriteAccess: TRWAccessEx read GetWriteAccess;
    property WriteMember: IMMMember read GetWriteMember;
    property WriteParameter: WideString read GetWriteParameter write SetWriteParameter;
    property WriteSpec: WideString read GetWriteSpec;
  end;
  
  IMMEvent = interface (IMMProperty)
    ['{A445C147-DB00-11D2-AA32-204C4F4F5020}']
    function GetDispatchBinding: TBindingKind; safecall;
    function GetDispatchMethod: IMMMethod; safecall;
    function GetDispatchName: WideString; safecall;
    function GetEventType: IMMEventType; safecall;
    function GetHasDispatchMethod: Boolean; safecall;
    procedure SetDispatchBinding(Value: TBindingKind); safecall;
    procedure SetDispatchName(const Value: WideString); safecall;
    procedure SetEventType(const Value: IMMEventType); safecall;
    procedure SetHasDispatchMethod(Value: Boolean); safecall;
    property DispatchBinding: TBindingKind read GetDispatchBinding write 
            SetDispatchBinding;
    property DispatchMethod: IMMMethod read GetDispatchMethod;
    property DispatchName: WideString read GetDispatchName write SetDispatchName;
    property EventType: IMMEventType read GetEventType write SetEventType;
    property HasDispatchMethod: Boolean read GetHasDispatchMethod write 
            SetHasDispatchMethod;
  end;
  
  IMMResClause = interface (IMMMember)
    ['{ECBDCDE1-DC90-11D2-AA35-204C4F4F5020}']
    function GetImpMethod: WideString; safecall;
    function GetInterfaceName: WideString; safecall;
    function GetIntfMethod: WideString; safecall;
    function GetMethodKind: TMethodKind; safecall;
    procedure SetImpMethod(const Value: WideString); safecall;
    procedure SetInterfaceName(const Value: WideString); safecall;
    procedure SetIntfMethod(const Value: WideString); safecall;
    procedure SetMethodKind(const Value: TMethodKind); safecall;
    property ImpMethod: WideString read GetImpMethod write SetImpMethod;
    property InterfaceName: WideString read GetInterfaceName write SetInterfaceName;
    property IntfMethod: WideString read GetIntfMethod write SetIntfMethod;
    property MethodKind: TMethodKind read GetMethodKind write SetMethodKind;
  end;

  {:
  Properties and Fields support this interface which allows access to the visualization
  attributes (MM6.11 onwards)
  }
  IMMMemberVisualization = interface (IUnknown)
    ['{19F771D6-CBEE-419F-88A1-7984D07D2A4D}']
    function GetAssocStyle(EndPnt: TMMAssocEndPoint): TMMClassAssocStyle; safecall;
    function GetCustomQualifier(EndPnt: TMMAssocEndPoint): Boolean; safecall;
    function GetMultiplicity(EndPnt: TMMAssocEndPoint): WideString; safecall;
    function GetQualifier(EndPnt: TMMAssocEndPoint): WideString; safecall;
    function GetRoleName(EndPnt: TMMAssocEndPoint): WideString; safecall;
    procedure SetAssocStyle(EndPnt: TMMAssocEndPoint; const Value: TMMClassAssocStyle);
            safecall;
    procedure SetCustomQualifier(EndPnt: TMMAssocEndPoint; const Value: Boolean);
            safecall;
    procedure SetMultiplicity(EndPnt: TMMAssocEndPoint; const Value: WideString);
            safecall;
    procedure SetQualifier(EndPnt: TMMAssocEndPoint; const Value: WideString); safecall;
    procedure SetRoleName(EndPnt: TMMAssocEndPoint; const Value: WideString); safecall;
    property AssocStyle[EndPnt: TMMAssocEndPoint]: TMMClassAssocStyle read GetAssocStyle
            write SetAssocStyle;
    property CustomQualifier[EndPnt: TMMAssocEndPoint]: Boolean read GetCustomQualifier
            write SetCustomQualifier;
    property Multiplicity[EndPnt: TMMAssocEndPoint]: WideString read GetMultiplicity
            write SetMultiplicity;
    property Qualifier[EndPnt: TMMAssocEndPoint]: WideString read GetQualifier write
            SetQualifier;
    property RoleName[EndPnt: TMMAssocEndPoint]: WideString read GetRoleName write
            SetRoleName;
  end;

  IMMClass = interface (IMMClassifier)
    ['{A445C141-DB00-11D2-AA32-204C4F4F5020}']
    procedure AddInterface(const Value: WideString); safecall;
    function GetInterfaceCount: Integer; safecall;
    function GetInterfaceList: WideString; safecall;
    function GetInterfaces(Index: Integer): WideString; safecall;
    procedure RemoveInterface(Index: Integer); safecall;
    procedure SetInterfaceList(const Value: WideString); safecall;
    function SupportsInterface(I: IMMInterface): Boolean; overload; safecall;
    function SupportsInterface(const Name: WideString): Boolean; overload; safecall;
    property InterfaceCount: Integer read GetInterfaceCount;
    property InterfaceList: WideString read GetInterfaceList write SetInterfaceList;
    property Interfaces[Index: Integer]: WideString read GetInterfaces;
  end;
  
  IMMInterface = interface (IMMClassifier)
    ['{A445C142-DB00-11D2-AA32-204C4F4F5020}']
    function GetGUID: WideString; safecall;
    procedure SetGUID(const Value: WideString); safecall;
    property GUID: WideString read GetGUID write SetGUID;
  end;

  IMMRecord = interface (IMMClassifier)
    ['{004E31FE-D396-4366-AFA9-7480FEE4D564}']
  end;

  IMMUnit = interface (IMMModelPart)
    ['{A445C148-DB00-11D2-AA32-204C4F4F5020}']
    procedure AddClass(C: IMMClassifier; const RegPage: WideString); safecall;
    procedure AddEvent(Event: IMMEventType); safecall;
    procedure AddToUsesClause(const Modules: WideString; IsPublic: Boolean); safecall;
    procedure CheckExpansion; safecall;
    function ContainsClassID(AID: Integer): Boolean; safecall;
    function ContainsClassName(const AName: WideString): Boolean; safecall;
    function ExploreCode: IMMModuleExplorer; safecall;
    function GetAlias: WideString; safecall;
    function GetAsText: WideString; safecall;
    function GetAutoGenEnabled: Boolean; safecall;
    function GetClassCount: Integer; safecall;
    function GetClasses(Index: Integer): IMMClassifier; safecall;
    function GetCode: WideString; safecall;
    function GetEventCount: Integer; safecall;
    function GetEvents(Index: Integer): IMMEventType; safecall;
    function GetIncompleteTagsWarning: Boolean; safecall;
    function GetRelUnitName: WideString; safecall;
    function GetUnitName: WideString; safecall;
    function GetUnitPath: WideString; safecall;
    procedure ManualGenerate; safecall;
    {:
    OrderClasses takes an ordered comma separated list of classes you want insert in the 
    unit.
    Any class not in this list will be removed from the unit. Duplicates are skipped.
    This behaves similar to the sort option in the Unit Editor Dialog.
    OrderClasses is a quick way to insert multiple classes or interfaces in a unit.
    AsText returns the generated and expanded unit code without generating to disk.
    }
    procedure OrderClasses(const ClassList: wideString); safecall;
    procedure RefreshImport; safecall;
    procedure RemoveClass(Index: Integer); safecall;
    procedure RemoveEvent(Index: Integer); safecall;
    procedure SetAlias(const Value: WideString); safecall;
    procedure SetAutoGenEnabled(const Value: Boolean); safecall;
    procedure SetCode(const Value: WideString); safecall;
    procedure SetIncompleteTagsWarning(Value: Boolean); safecall;
    procedure SetRelUnitName(const Value: WideString); safecall;
    procedure SetUnitName(const Value: WideString); safecall;
    property Alias: WideString read GetAlias write SetAlias;
    property AsText: WideString read GetAsText;
    property AutoGenEnabled: Boolean read GetAutoGenEnabled write SetAutoGenEnabled;
    property ClassCount: Integer read GetClassCount;
    property Classes[Index: Integer]: IMMClassifier read GetClasses;
    property Code: WideString read GetCode write SetCode;
    property EventCount: Integer read GetEventCount;
    property Events[Index: Integer]: IMMEventType read GetEvents;
    property IncompleteTagsWarning: Boolean read GetIncompleteTagsWarning write 
            SetIncompleteTagsWarning;
    property RelUnitName: WideString read GetRelUnitName write SetRelUnitName;
    property UnitName: WideString read GetUnitName write SetUnitName;
    property UnitPath: WideString read GetUnitPath;
  end;
  
  IMMUnitManager = interface (IUnknown)
    ['{A445C149-DB00-11D2-AA32-204C4F4F5020}']
    function AddUnit: IMMUnit; safecall;
    procedure BeginGenerate; safecall;
    procedure EndGenerate; safecall;
    function FindUnitOnID(ID: Integer; var Index: Integer): Boolean; safecall;
    function FindUnitOnName(const UnitName: WideString; var Index: Integer): Boolean; 
            safecall;
    function FirstUnitContainingClass(ClassID: Integer): IMMUnit; safecall;
    function GetUnitCount: Integer; safecall;
    function GetUnits(Index: Integer): IMMUnit; safecall;
    function GetUserLockedGeneration: Boolean; safecall;
    procedure ImportUnit(const FileName: WideString); safecall;
    {:
    IsGenerationLocked returns the state of the code generation locking.
    Code generation locking is a combination of UserLockedGeneration and internal locking.
    }
    function IsGenerationLocked: Boolean; safecall;
    procedure RethinkAliases; safecall;
    procedure SetUserLockedGeneration(const Value: Boolean); safecall;
    property UnitCount: Integer read GetUnitCount;
    property Units[Index: Integer]: IMMUnit read GetUnits;
    {:
    UserLockedGeneration corresponds to the manually (un)locking code generation
    However, generation can remain locked if internally generation is locked.
    Check IsGenerationLocked.
    }
    property UserLockedGeneration: Boolean read GetUserLockedGeneration write
            SetUserLockedGeneration;
  end;

  IMMExplorerItem = interface (IUnknown)
    ['{A9BD18A1-2CBB-11D5-A4A2-000000000000}']
    function GetBadFormat: Boolean; safecall;
    function GetDeclaration: WideString; safecall;
    function GetDocumentation: WideString; safecall;
    function GetName: WideString; safecall;
    function GetOneLiner: WideString; safecall;
    function GetV9Visibility: TV9Visibility; safecall;
    function Valid: Boolean; safecall;
    property BadFormat: Boolean read GetBadFormat;
    property Declaration: WideString read GetDeclaration;
    property Documentation: WideString read GetDocumentation;
    property Name: WideString read GetName;
    property OneLiner: WideString read GetOneLiner;
    property V9Visibility: TV9Visibility read GetV9Visibility;
  end;

  IMMV10ExplorerItem = interface (IUnknown)
    ['{B93FB0AD-6744-4D45-A706-820640BB359F}']
    function GetVisibility: TVisibility; safecall;
    property Visibility: TVisibility read GetVisibility;
  end;

  IMMProcedure = interface (IMMExplorerItem)
    ['{A9BD18A2-2CBB-11D5-A4A2-000000000000}']
    function GetCallConvention: TCallConvention; safecall;
    function GetDataName: WideString; safecall;
    function GetDecl: IMMProcedure; safecall;
    function GetDirectives: TMMProcDirectives; safecall;
    function GetExternalSpec: WideString; safecall;
    function GetImpl: IMMProcedure; safecall;
    function GetMethodKind: TMethodKind; safecall;
    function GetParameters: WideString; safecall;
    property CallConvention: TCallConvention read GetCallConvention;
    property DataName: WideString read GetDataName;
    property Decl: IMMProcedure read GetDecl;
    property Directives: TMMProcDirectives read GetDirectives;
    property ExternalSpec: WideString read GetExternalSpec;
    property Impl: IMMProcedure read GetImpl;
    property MethodKind: TMethodKind read GetMethodKind;
    property Parameters: WideString read GetParameters;
  end;

  IMMV10Procedure = interface (IMMProcedure)
    ['{A9A68FB9-BE9B-4A47-99FD-77230A77551A}']
    function AsText: WideString; safecall;
  end;

  IMMUsesClause = interface (IMMExplorerItem)
    ['{0381DED9-F50C-4C86-859C-E98B677D391F}']
    function GetModuleCount: Integer; safecall;
    function GetModules(Index: Integer): WideString; safecall;
    function GetModulesAsText: WideString; safecall;
    property ModuleCount: Integer read GetModuleCount;
    property Modules[Index: Integer]: WideString read GetModules;
    property ModulesAsText: WideString read GetModulesAsText;
  end;

  TUnitTagType = (utgNoTag,
                  utgStartIntf, utgStartReg, utgStartImp, utgStartInit,
                  utgClassIntf, utgClassReg, utgClassImp, utgClassInit,
                  utgEventDef, utgUnitDoc,
                  utgStartExpand, utgEndExpand);

  IMMUnitCodeTag = interface (IMMExplorerItem)
    ['{5038B227-531C-46D3-87E2-EF0145945EDD}']
    function GetLine: WideString; safecall;
    function GetRefID: Integer; safecall;
    function GetTagType: TUnitTagType; safecall;
    property Line: WideString read GetLine;
    property RefID: Integer read GetRefID;
    property TagType: TUnitTagType read GetTagType;
  end;

  IMMModuleExplorer = interface (IUnknown)
    ['{A9BD18A3-2CBB-11D5-A4A2-000000000000}']
    function GetCount: Integer; safecall;
    function GetItems(Index: Integer): IMMExplorerItem; safecall;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: IMMExplorerItem read GetItems;
  end;
  
  IMMCodeModel = interface (IUnknown)
    ['{FE015732-D57D-11D2-AA26-204C4F4F5020}']
    function AddClass: IMMClass; safecall;
    function AddInterface: IMMInterface; safecall;
    procedure BeginUpdate; safecall;
    procedure EndUpdate; safecall;
    function FindClass(const Name: WideString; var Index: Integer): Boolean; safecall;
    function GetClassCount: Integer; safecall;
    function GetClasses(Index: Integer): IMMClassifier; safecall;
    function GetClassOnID(ID: Integer): IMMClassifier; safecall;
    function GetClassPersistencyRoot: IMMClass; safecall;
    function GetClassTreeRoot: IMMClass; safecall;
    function GetInterfacesRoot: IMMInterface; safecall;
    function GetIUnknownRoot: IMMInterface; safecall;
    function GetMemberOnID(ID: Integer): IMMMember; safecall;
    function GetValid: Boolean; safecall;
    procedure SetClassPersistencyRoot(const Value: IMMClass); safecall;
    property ClassCount: Integer read GetClassCount;
    property Classes[Index: Integer]: IMMClassifier read GetClasses;
    property ClassPersistencyRoot: IMMClass read GetClassPersistencyRoot write
            SetClassPersistencyRoot;
    property ClassTreeRoot: IMMClass read GetClassTreeRoot;
    property InterfacesRoot: IMMInterface read GetInterfacesRoot;
    property IUnknownRoot: IMMInterface read GetIUnknownRoot;
    property Valid: Boolean read GetValid;
  end;

  IMMV10CodeModel = interface (IMMCodeModel)
    ['{8A174671-E3A1-41C8-B5D1-F5F0276CE420}']
    function AddRecord: IMMRecord; safecall;
  end;

  IMMDiagramExplorerViews = interface (IUnknown)
    ['{936C7438-A8A2-431E-93DE-47F56F9CBC76}']
    function GetCurViewAsXML: WideString; safecall;
    property CurViewAsXML: WideString read GetCurViewAsXML;
  end;

  {:
  IMMOptions is used to access Project and Environment options
  Value names should be "GroupName"\"OptionName"
  Only a limited set of options is accesible.
  For example
  ProjectOptions['CodeGeneration\Instrumentation'] := 'True'; sets Project options Code 
  generation Instrumentation to True
  GetCurrentState(OptionsName) returns the current state for a single set of options.
  
  For example, (modify code generation options and restore to previous state)
  
  SaveState := ProjectOptions.GetCurrentState('CodeGeneration');
  try
  ProjectOptions['CodeGeneration\Instrumentation'] := 'True';
  // do something with the modified options
  finally
  ProjectOptions.SetCurrentState('CodeGeneration', SaveState);
  end;
  
  GetCurrentState('') returns a list of all available options and their current values
  SetCurrentState should never be used with an empty string.
  }
  IMMOptions = interface (IUnknown)
    ['{EA13D57D-EB34-4426-B348-56C0323F3E66}']
    function GetCurrentState(const OptionsName: WideString = ''): WideString; safecall;
    function GetValues(const ValueName: WideString): WideString; safecall;
    procedure SetCurrentState(const OptionsName, Data: WideString); safecall;
    procedure SetValues(const ValueName: WideString; const ValueData: WideString); 
            safecall;
    property Values[const ValueName: WideString]: WideString read GetValues write 
            SetValues; default;
  end;
  
  IMMProject = interface (IUnknown)
    ['{9084B35B-35AD-421C-9034-D4A54197720E}']
    function GetDocumentation: WideString; safecall;
    function GetFormerNamesTV: WideString; safecall;
    function GetIsDesignProject: Boolean; safecall;
    function GetOneLiner: WideString; safecall;
    function GetOptions: IMMOptions; safecall;
    function GetTaggedValueCount: Integer; safecall;
    function GetTaggedValueNames(Index: Integer): WideString; safecall;
    function GetTaggedValues(const TagName: WideString): WideString; safecall;
    function GetTrackFormerNames: Boolean; safecall;
    procedure SetDocumentation(const Value: WideString); safecall;
    procedure SetFormerNamesTV(const Value: WideString); safecall;
    procedure SetIsDesignProject(const Value: Boolean); safecall;
    procedure SetOneLiner(const Value: WideString); safecall;
    procedure SetTaggedValues(const TagName: WideString; const Value: WideString); 
            safecall;
    procedure SetTrackFormerNames(const Value: Boolean); safecall;
    property Documentation: WideString read GetDocumentation write SetDocumentation;
    property FormerNamesTV: WideString read GetFormerNamesTV write SetFormerNamesTV;
    property IsDesignProject: Boolean read GetIsDesignProject write SetIsDesignProject;
    property OneLiner: WideString read GetOneLiner write SetOneLiner;
    property Options: IMMOptions read GetOptions;
    property TaggedValueCount: Integer read GetTaggedValueCount;
    property TaggedValueNames[Index: Integer]: WideString read GetTaggedValueNames;
    property TaggedValues[const TagName: WideString]: WideString read GetTaggedValues 
            write SetTaggedValues;
    property TrackFormerNames: Boolean read GetTrackFormerNames write SetTrackFormerNames;
  end;
  
  IMMProjectManager = interface (IUnknown)
    ['{4E2ACF10-DDCB-11D2-AA37-204C4F4F5020}']
    procedure CommitEditors; safecall;
    function GetProject: IMMProject; safecall;
    function GetProjectName: WideString; safecall;
    procedure NewProject(const FileName: WideString = ''); safecall;
    procedure OpenProject(const FileName: WideString); safecall;
    procedure SaveProject(SaveAs: Boolean); safecall;
    property Project: IMMProject read GetProject;
    property ProjectName: WideString read GetProjectName;
  end;
  
  IMMAliasManager = interface (IUnknown)
    ['{E8B6D67C-6E79-4D44-B98C-BF9F47B52E05}']
    procedure AddAlias(const Alias, Path, VCSProject: WideString); safecall;
    function AddAliasInteractive: Integer; safecall;
    function AliasedPath(const AAlias: WideString): WideString; safecall;
    function ConvertToAlias(const FileName: WideString; var RelName, AAlias: WideString): 
            Boolean; safecall;
    function GetAliasCount: Integer; safecall;
    function GetAliasedPaths(Index: Integer): WideString; safecall;
    function GetAliases(Index: Integer): WideString; safecall;
    function GetVCSProjects(Index: Integer): WideString; safecall;
    procedure RemoveAlias(Index: Integer); safecall;
    property AliasCount: Integer read GetAliasCount;
    property AliasedPaths[Index: Integer]: WideString read GetAliasedPaths;
    property Aliases[Index: Integer]: WideString read GetAliases;
    property VCSProjects[Index: Integer]: WideString read GetVCSProjects;
  end;
  
  IMMNavigator = interface (IUnknown)
    ['{AA3B0BE5-952B-11D3-AB7A-204C4F4F5020}']
    procedure ActivateView(View: TMMViewType; DoFocus: Boolean); safecall;
    function GetCurClass: IMMClassifier; safecall;
    function GetCurDiagram: IMMDiagram; safecall;
    function GetCurEventType: IMMEventType; safecall;
    function GetCurMember: IMMMember; safecall;
    function GetCurMethod: IMMMethod; safecall;
    function GetCurUnit: IMMUnit; safecall;
    {:
    GetSelectedMembers will instantiate an IInterfaceList and insert the selected members
    from the members view. If Complete is True, all members owned by the selected members
    are included even if not selected. Use Complete=True to include property access 
    members
    and event dispatch methods in the selection.
    }
    function GetSelectedMembers(Complete: Boolean): IInterfaceList;
    procedure SetCurClass(const Value: IMMClassifier); safecall;
    procedure SetCurDiagram(const Value: IMMDiagram); safecall;
    procedure SetCurEventType(const Value: IMMEventType); safecall;
    procedure SetCurMember(const Value: IMMMember); safecall;
    procedure SetCurMethod(const Value: IMMMethod); safecall;
    procedure SetCurUnit(const Value: IMMUnit); safecall;
    property CurClass: IMMClassifier read GetCurClass write SetCurClass;
    property CurDiagram: IMMDiagram read GetCurDiagram write SetCurDiagram;
    property CurEventType: IMMEventType read GetCurEventType write SetCurEventType;
    property CurMember: IMMMember read GetCurMember write SetCurMember;
    property CurMethod: IMMMethod read GetCurMethod write SetCurMethod;
    property CurUnit: IMMUnit read GetCurUnit write SetCurUnit;
  end;
  

  IMMDesignCritic = interface (IUnknown)
    ['{80E3CAE4-5B25-11D5-A500-0002B34B0C20}']
    function CriticID: WideString; safecall;
    procedure Edit; safecall;
    function GetAuthor: WideString; safecall;
    function GetCategory: WideString; safecall;
    function GetCriticName: WideString; safecall;
    procedure GetCustomState(var TaggedValues: WideString); safecall;
    function GetDescription: WideString; safecall;
    function GetEnabled: Boolean; safecall;
    function GetHeadLine: WideString; safecall;
    function GetPriority: TMMMsgPriority; safecall;
    function GetVisible: Boolean; safecall;
    procedure MsgDoubleClicked(const M: IMMMessage; var Handled: Boolean); safecall;
    procedure Refresh; safecall;
    procedure RefreshClass(ID: Integer); safecall;
    procedure RefreshUnit(ID: Integer); safecall;
    procedure SetCategory(Value: WideString); safecall;
    procedure SetCustomState(const TaggedValues: WideString); safecall;
    procedure SetEnabled(Value: Boolean); safecall;
    procedure SetPriority(Value: TMMMsgPriority); safecall;
    procedure SetVisible(Value: Boolean); safecall;
    property Author: WideString read GetAuthor;
    property Category: WideString read GetCategory write SetCategory;
    property CriticName: WideString read GetCriticName;
    property Description: WideString read GetDescription;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property HeadLine: WideString read GetHeadLine;
    property Priority: TMMMsgPriority read GetPriority write SetPriority;
    property Visible: Boolean read GetVisible write SetVisible;
  end;
  
  IMMToDoManager = interface (IMMDesignCritic)
    ['{9CCF71B3-5F2C-11D5-A509-0002B34B0C20}']
    procedure AddToDoItem; safecall;
  end;
  
  IMMCriticsNotifier = interface (IUnknown)
    ['{80E3CAE5-5B25-11D5-A500-0002B34B0C20}']
    procedure CriticChanged(Index: Integer); safecall;
    procedure Destroyed; safecall;
  end;
  
  IMMDesignCriticManager = interface (IUnknown)
    ['{80E3CAE6-5B25-11D5-A500-0002B34B0C20}']
    function AddCritic(const Critic: IMMDesignCritic): Integer; safecall;
    function AddNotifier(Notifier: IMMCriticsNotifier): Integer; safecall;
    procedure BeginUpdate; safecall;
    procedure CriticChanged(const Critic: IMMDesignCritic); safecall;
    procedure EndUpdate; safecall;
    function FindCritic(const CriticID: WideString; var Index: Integer): Boolean; 
            safecall;
    function GetCriticCount: Integer; safecall;
    function GetCritics(Index: Integer): IMMDesignCritic; safecall;
    function GetToDoManager: IMMToDoManager; safecall;
    procedure HideCritics; safecall;
    procedure LoadCritics(const FileName: WideString); safecall;
    procedure Refresh; safecall;
    procedure RefreshClass(ID: Integer); safecall;
    procedure RefreshUnit(ID: Integer); safecall;
    procedure RemoveCritic(Index: Integer); safecall;
    procedure RemoveNotifier(Index: Integer); safecall;
    procedure RestoreDefaults; safecall;
    procedure SaveAsDefault; safecall;
    procedure SaveCritics(const FileName: WideString); safecall;
    procedure ShowCritics; safecall;
    property CriticCount: Integer read GetCriticCount;
    property Critics[Index: Integer]: IMMDesignCritic read GetCritics; default;
    property ToDoManager: IMMToDoManager read GetToDoManager;
  end;
  

  IMMMessage = interface (IUnknown)
    ['{80E3CAEA-5B25-11D5-A500-0002B34B0C20}']
    procedure Delete; safecall;
    function GetCategory: WideString; safecall;
    function GetContainer: Integer; safecall;
    function GetContainerName: WideString; safecall;
    function GetData: Integer; safecall;
    function GetHeadLine: WideString; safecall;
    function GetMsgType: TMMMessageType; safecall;
    function GetOwner: WideString; safecall;
    function GetPriority: TMMMsgPriority; safecall;
    function GetReference: IMMReference; safecall;
    function GetTaggedValueCount: Integer; safecall;
    function GetTaggedValueNames(Index: Integer): WideString; safecall;
    function GetTaggedValues(const Name: WideString): WideString; safecall;
    procedure Locate(DoShow: Boolean = False; DoFocus: Boolean = False); safecall;
    procedure ReferToEntity(const Entity: IUnknown); safecall;
    procedure ReferToNull; safecall;
    procedure ReferToSourceFile(const FileName: WideString; LineNr, Column: Integer); 
            safecall;
    procedure SetCategory(const Value: WideString); safecall;
    procedure SetData(Value: Integer); safecall;
    procedure SetHeadLine(const Value: WideString); safecall;
    procedure SetMsgType(Value: TMMMessageType); safecall;
    procedure SetPriority(Value: TMMMsgPriority); safecall;
    procedure SetTaggedValues(const Name: WideString; Value: WideString); safecall;
    property Category: WideString read GetCategory write SetCategory;
    property Container: Integer read GetContainer;
    property ContainerName: WideString read GetContainerName;
    property Data: Integer read GetData write SetData;
    property HeadLine: WideString read GetHeadLine write SetHeadLine;
    property MsgType: TMMMessageType read GetMsgType write SetMsgType;
    property Owner: WideString read GetOwner;
    property Priority: TMMMsgPriority read GetPriority write SetPriority;
    property Reference: IMMReference read GetReference;
    property TaggedValueCount: Integer read GetTaggedValueCount;
    property TaggedValueNames[Index: Integer]: WideString read GetTaggedValueNames;
    property TaggedValues[const Name: WideString]: WideString read GetTaggedValues write 
            SetTaggedValues;
  end;
  
  IMMMessageServer = interface (IUnknown)
    ['{80E3CAEB-5B25-11D5-A500-0002B34B0C20}']
    procedure BeginUpdate; safecall;
    procedure Clear; safecall;
    procedure CopyToClipboard; safecall;
    function CreateMessage(const Owner: WideString; Container: Integer): IMMMessage; 
            safecall;
    procedure Delete(Index: Integer); safecall;
    procedure DeleteCategory(const Category: WideString; Container: Integer = -1); 
            safecall;
    procedure DeleteContainer(Container: Integer); safecall;
    procedure DeleteOwner(const Owner: WideString; Container: Integer = -1); safecall;
    procedure EndUpdate; safecall;
    procedure ExportMessages(const FileName: WideString); safecall;
    function GetCount: Integer; safecall;
    function GetMessages(Index: Integer): IMMMessage; safecall;
    procedure HideMessages; safecall;
    procedure ImportMessages(const FileName: WideString); safecall;
    function IsUpdating: Boolean; safecall;
    function RegisterContainer(const Name: WideString): Integer;
    procedure SaveToFile(const FileName: WideString); safecall;
    procedure ShowMessages(FocusedContainer: Integer = MMMessagesContainer); safecall;
    procedure ShowMsgsCategory(const Category: WideString; InContainer: Integer = 
            AllContainers; FocusedContainer: Integer = MMMessagesContainer); safecall;
    procedure ShowMsgsOwner(const Owner: WideString; InContainer: Integer = AllContainers;
            FocusedContainer: Integer = MMMessagesContainer); safecall;
    property Count: Integer read GetCount;
    property Messages[Index: Integer]: IMMMessage read GetMessages; default;
  end;
  
  IMMCategoryManager = interface (IUnknown)
    ['{6E2A0D21-63D0-11D5-A513-0002B34B0C20}']
    function Add(const AName: WideString): Integer; safecall;
    function Assure(const AName: WideString): Integer; safecall;
    procedure Delete(AID: Integer); safecall;
    procedure ExportToFile(const FileName: WideString); safecall;
    function FindOnID(AID: Integer; var Index: Integer): Boolean; safecall;
    function FindOnName(const AName: WideString; var Index: Integer): Boolean; safecall;
    function GetCategory(Index: Integer): WideString; safecall;
    function GetCatID(Index: Integer): Integer; safecall;
    function GetCount: Integer; safecall;
    procedure ImportFromFile(const FileName: WideString); safecall;
    function IndexOfCat(const AName: WideString): Integer; safecall;
    procedure Rename(AID: Integer; NewName: WideString); safecall;
    property Category[Index: Integer]: WideString read GetCategory;
    property CategoryID[Index: Integer]: Integer read GetCatID;
    property Count: Integer read GetCount;
  end;
  
  {:
  AddMacro will add the macro and if a macro with that name already exists, provide a 
  default name.
  GetMacroCode and GetMacroParams will NOT auto create the macro if it does not exist
  SetMacroCode and SetMacroParams will auto create the macro if it does not exist (for 
  valid names)
  SetMacroData assumes a valid rename and will except if the new Name is invalid or 
  duplicate
  Be aware that changing a macro's name will most likely change it's order = index.
  => Don't rename macros in loops.
  Clear will clear all macros
  LoadFromfile and SaveToFile are intended only for the Environment Macros although
  they can be used on the Project macros too.
  }
  IMMMacroManager = interface (IUnknown)
    ['{0DEC4CD0-F41E-4CFF-A0F6-B8504D0DCD63}']
    procedure AddMacro(const Name, Params, Code: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    function FindMacro(const Name: WideString; var Index: Integer): Boolean; safecall;
    function GetCount: Integer; safecall;
    function GetMacroCode(const Name: WideString): WideString; safecall;
    procedure GetMacroData(Index: Integer; var Name, Params, Code: WideString); safecall;
    function GetMacroParams(const Name: WideString): WideString; safecall;
    procedure LoadFromFile(const FileName: WideString); safecall;
    procedure SaveToFile(const FileName: WideString); safecall;
    procedure SetMacroCode(const Name: WideString; const Value: WideString); safecall;
    procedure SetMacroData(Index: Integer; const Name, Params, Code: WideString); 
            safecall;
    procedure SetMacroParams(const Name: WideString; const Value: WideString); safecall;
    property Count: Integer read GetCount;
    property MacroCode[const Name: WideString]: WideString read GetMacroCode write 
            SetMacroCode;
    property MacroParams[const Name: WideString]: WideString read GetMacroParams write 
            SetMacroParams;
  end;
  
  IMMExtension = interface (IUnknown)
    ['{F4435341-4326-4DC9-8DD8-1E9E69C6A05E}']
    procedure Destroyed; safecall;
    function GetDescription: WideString; safecall;
    function GetExtensionID: WideString; safecall;
    property Description: WideString read GetDescription;
    property ExtensionID: WideString read GetExtensionID;
  end;
  
  IMMExecutableExtension = interface (IMMExtension)
    ['{601F9442-59AE-4C6B-A386-D9EC90D1461F}']
    procedure Execute; safecall;
  end;
  
  IMMHelpGenerator = interface (IMMExecutableExtension)
    ['{3A8240C2-7A07-4408-B1DE-B2C5E49DAF09}']
  end;
  
  IMMDefaultDocGenerator = interface (IMMExecutableExtension)
    ['{C7EB2829-6E44-431B-9CE6-C573F1CA65D9}']
  end;
  
  IMMExtAliasEditor = interface (IMMExecutableExtension)
    ['{04F55217-20B4-444D-A743-4E70F1041549}']
  end;

  TMMDocGenPhase = (dgpInterface, dgpImplementation);

  IMMSourceDocGenerationHook = interface (IMMExtension)
    ['{26B87B4B-AB41-4DE9-A769-2F97F7670C9D}']
    procedure FormatClassDoc(ClassBase: IMMClassifier; Phase: TMMDocGenPhase; var Doc:
            WideString); safecall;
    procedure FormatEventDoc(EventType: IMMEventType; var Doc: WideString); safecall;
    procedure FormatMemberDoc(Member: IMMMember; Phase: TMMDocGenPhase; var Doc:
            WideString); safecall;
    procedure FormatModuleDoc(Module: IMMUnit; var Doc: WideString); safecall;
  end;

  IMMSourceDocImportHook = interface (IMMExtension)
    ['{2F081351-B2D1-4F56-B164-2BD34DCCB1F9}']
    procedure AssignClassDoc(ClassBase: IMMClassifier; var Doc: wideString; var Handled:
            Boolean); safecall;
    procedure AssignEventDoc(EventType: IMMEventType; var Doc: wideString; var Handled:
            Boolean); safecall;
    procedure AssignMemberDoc(Member: IMMMember; var Doc: wideString; var Handled:
            Boolean); safecall;
    procedure AssignModuleDoc(Module: IMMUnit; var Doc: wideString; var Handled: Boolean);
            safecall;
  end;

  IMMClassAssocDefaults = interface (IMMExtension)
    ['{18BE167D-D242-446B-A9F4-AB5275546902}']
    procedure AssignDefaults(Association: IMMClassAssociation); safecall;
  end;

  {:
  IMMUnitGenerationHook can be registered to modify generated code
  just before it is written to disk. Do not invoke lengthy operations
  as this might be called frequently (up to 10/s per unit)
  If multiple hooks are installed they will be chained.
  Note that this hook is also called for all in-memory generations
  like IMMUnit.AsText and the internal difference engine.
  U is passed as information only. File U.UnitPath has not been
  written to disk yet - and as a consequence might not even exist yet.
  U.UnitPath might even be an invalid path.
  }
  IMMUnitGenerationHook = interface (IMMExtension)
    ['{38265EAA-1E0A-4E72-B9EF-35BB39FEAE93}']
    procedure UnitGenerated(const U: IMMUnit; var Code: WideString); safecall;
  end;

  {:
  IMMEntityGenerationHook can be registered to modify the formatting
  of entity declarations in the generated code. Do not invoke lengthy operations
  to avoid performance degradation.
  Only one EntityGenerationHook will be called, multiple hooks are not chained.
  The Entity formatting hook is invoked before the IMMUnitGenerationHook.
  The code passed to an IMMUnitGenerationHook is based on the formatting generated by the entity hook.
  }
  IMMEntityGenerationHook = interface(IMMExtension)
    ['{BCFBA9F1-C0B4-41F9-A25B-3ED87826A427}']
    procedure FormatClassDecl(const C: IMMClass; var Decl: WideString); safecall;
    procedure FormatEventTypeDecl(const E: IMMEventType; var Decl: WideString); safecall;
    procedure FormatFieldDecl(const F: IMMField; var Decl: WideString); safecall;
    procedure FormatInterfaceDecl(const C: IMMInterface; var Decl: WideString); safecall;
    procedure FormatMethodImplDecl(const M: IMMMethod; var Decl: WideString); safecall;
    procedure FormatMethodIntfDecl(const M: IMMMethod; var Decl: WideString); safecall;
    procedure FormatPropertyDecl(const P: IMMProperty; var Decl: WideString); safecall;
    procedure FormatRecordDecl(const R: IMMRecord; var Decl: WideString); safecall;
    procedure FormatResClauseDecl(const R: IMMResClause; var Decl: WideString); safecall;
  end;

  {:
  Register a CodeEditorNotifier extension to modify code before loading or before comitting
  For a method this is a section of code, not the entire method. Only user owned
  sections can be changed, as indicated by the AllowChange param.
  The Section param corresponds to the IMMMethod.Section index. The local code
  corresponds to Section = -1;
  For a unit this is the unit code as edited in the unit code editor.

  All registered IMMCodeEditorNotifier extensions are called in a chain.
  }
  IMMCodeEditorNotifier = interface(IMMExtension)
    ['{DA292308-AAE2-47CB-9EF5-70ED4135E3A0}']
    procedure BeforeCommit(var Code: WideString; const M: IMMMethod;
                           const Section: Integer; AllowChange: Boolean); safecall; overload;
    procedure BeforeCommit(var Code: WideString; const U: IMMUnit); safecall; overload;
    procedure BeforeLoading(var Code: WideString; const M: IMMMethod;
                            const Section: Integer; AllowChange: Boolean); safecall; overload;
    procedure BeforeLoading(var Code: WideString; const U: IMMUnit); safecall; overload;
  end;

  IMMCustomTabHost = interface (IUnknown)
    ['{9616D7B0-7380-434C-8E3C-0CD8F5E946D7}']
    {:
    Clicks the dialog's Cancel button
    }
    procedure ClickCancel; safecall;
    {:
    Clicks the dialog's OK button
    }
    procedure ClickOK; safecall;
    function GetValues(const Name: WideString): WideString; safecall;
    procedure SetValues(const Name: WideString; const Value: WideString); safecall;
    {:
    Returns the properties as currently entered in the MM tabs
    Name is depending on edited entity type.
    Examples are: 'DataName', 'Name' etc.
    Note that not all properties in a dialog might be accessible through this interface.
    }
    property Values[const Name: WideString]: WideString read GetValues write SetValues;
        default;
  end;

  {:
  Note that the entity passed for mmcdXYZSymbol and mmcdXYZAssociation is the
  class, interface, field or property as linked to that symbol / association.
  NOT the IMMShape related to the symbol.
  The SharedAssociation dialog passes an IMMClassAssociation.
  The project and environment option dialogs pass an IMMOptions.
  }
  TMMCustomizableDialog =
      (mmcdClass, mmcdInterface, mmcdField, mmcdMethod, mmcdProperty, mmcdEvent,
       mmcdClassSymbol, mmcdInterfaceSymbol, mmcdFieldAssociation, mmcdPropertyAssociation,
       mmcdSharedAssociation, mmcdEnvOptions, mmcdProjectOptions, mmcdRecord, mmcdRecordSymbol);

  IMMCustomTabHandler = interface (IUnknown)
    ['{19B43ED5-7808-4DEA-A178-8438FB0078E7}']
    {:
    AfterHide is called each time after the dialog has been opened, Gives an opportunity
    to release resources allocated in LoadSettings
    }
    procedure AfterHide(Data: Integer); safecall;
    {:
    ApplySettings is called if the dialog is closed and the user commits changes
    (= clicked OK). ApplySettings is also called if TabVisible set to False in
    LoadSettings
    }
    procedure ApplySettings(const Entity: IUnknown; Data: Integer); safecall;
    {:
    If the user is about the close the dialog by clicking OK you can avoid the dialog
    being closed by
    returning False in CloseQuery. DialogHandle can be used to use a parent handle for
    message boxes. CloseQuery is also called if TabVisible set to False in LoadSettings
    }
    function CloseQuery(DialogHandle: Hwnd; Data: Integer): Boolean; safecall;
    {:
    CreateTab is called once when the dialog is created.
    PageIndex is the 0 based destination page index. (The last expert loaded wins)
    This defaults to the currently last page.
    RequiredSize can be used to adjust the clientarea available on the tab by increasing
    the
    dialog's size. It defaults to the current tab's ClientRect.BottomRight.
    To increase the size of the dialog, adjust this as required.
    }
    procedure CreateTab(const Host: IMMCustomTabHost; TabControlHandle: HWnd; Data: Integer;
            var PageIndex: Integer; var RequiredSize: TPoint); safecall;
    {:
    Called just before the custom tab is destroyed. Drop all references to the
    owning IMMCustomTabHost and entities.
    }
    procedure Destroyed; safecall;
    {:
    Each time the dialog is invoked,  LoadSettings is called just before the dialog is
    shown
    }
    procedure LoadSettings(const Entity: IUnknown; var TabVisible: Boolean; Data: Integer);
            safecall;
    {:
    Called when the Tab is de-activated after the dialog has been shown and
    the user switches to another tab.
    If the custom tab shares attributes with the MM tabs,
    this is the moment to synchronize writing the current state using Sender.Values[]
    }
    procedure TabHide(const Host: IMMCustomTabHost); safecall;
    {:
    Called when the Tab is activated.
    If the custom tab shares attributes with the MM tabs,
    this is the moment to synchronize reading the current state using Sender.Values[]
    }
    procedure TabShow(const Host: IMMCustomTabHost); safecall;
  end;

  IMMToolServices = interface (IUnknown)
    ['{4494D380-D2DF-11D2-AA22-204C4F4F5020}']
    function AddCustomTab(Dialog: TMMCustomizableDialog; const Caption: WideString; const
            Handler: IMMCustomTabHandler; Data: Integer): Integer; safecall;
    function AddExpert(const Expert: IMMExpert): Integer; safecall;
    function AddExtension(const Extension: IMMExtension): Integer; safecall;
    function AddProjectNotifier(const Notifier: IMMProjectNotifier): Integer; safecall;
    function GetAliasManager: IMMAliasManager; safecall;
    function GetBaseRegistryKey: WideString; safecall;
    function GetCategoryManager: IMMCategoryManager; safecall;
    function GetClassAssocManager: IMMClassAssocManager; safecall;
    function GetCodeModel: IMMCodeModel; safecall;
    function GetCriticManager: IMMDesignCriticManager; safecall;
    function GetDiagramManager: IMMDiagramManager; safecall;
    function GetEnvMacros: IMMMacroManager; safecall;
    function GetEnvOptions: IMMOptions; safecall;
    function GetEventLibrary: IMMEventLibrary; safecall;
    function GetLicenseType: Integer; safecall;
    function GetMessageServer: IMMMessageServer; safecall;
    function GetNavigator: IMMNavigator; safecall;
    function GetParentHandle: HWND; safecall;
    function GetProjectMacros: IMMMacroManager; safecall;
    function GetProjectManager: IMMProjectManager; safecall;
    function GetUnitManager: IMMUnitManager; safecall;
    procedure RemoveCustomTab(Index: Integer); safecall;
    procedure RemoveExpert(Index: Integer); safecall;
    procedure RemoveExtension(Index: Integer); safecall;
    procedure RemoveProjectNotifier(Index: Integer); safecall;
    property AliasManager: IMMAliasManager read GetAliasManager;
    property CategoryManager: IMMCategoryManager read GetCategoryManager;
    property ClassAssocManager: IMMClassAssocManager read GetClassAssocManager;
    property CodeModel: IMMCodeModel read GetCodeModel;
    property CriticManager: IMMDesignCriticManager read GetCriticManager;
    property DiagramManager: IMMDiagramManager read GetDiagramManager;
    property EnvMacros: IMMMacroManager read GetEnvMacros;
    property EnvOptions: IMMOptions read GetEnvOptions;
    property EventLibrary: IMMEventLibrary read GetEventLibrary;
    property MessageServer: IMMMessageServer read GetMessageServer;
    property Navigator: IMMNavigator read GetNavigator;
    property ProjectMacros: IMMMacroManager read GetProjectMacros;
    property ProjectManager: IMMProjectManager read GetProjectManager;
    property UnitManager: IMMUnitManager read GetUnitManager;
  end;

  IMMV10ToolServices = interface (IMMToolServices)
    ['{CA1D1537-80F1-42FA-A2BD-35A71A6A311E}']
    function GetDiagramExplorerViews: IMMDiagramExplorerViews; safecall;
    property DiagramExplorerViews: IMMDiagramExplorerViews read GetDiagramExplorerViews;
  end;

  TIMMExpert = class (TInterfacedObject, IMMExpert)
  public
    procedure Destroyed; dynamic; safecall;
    procedure Execute(Index: Integer); dynamic; safecall;
    procedure ExecuteAction(Index: Integer); dynamic; safecall;
    function ExpertID: WideString; virtual; safecall; abstract;
    function GetActionCount: Integer; virtual; safecall;
    procedure GetActionData(Index: Integer; var Data: TMMActionData); virtual; safecall;
    function GetCustomImages(ImageIndexOffset: Integer; var Images: THandle): Boolean; 
            virtual; safecall;
    function GetCustomMenuData: WideString; dynamic; safecall;
    function GetCustomToolbarData: WideString; dynamic; safecall;
    function GetMenuPositions(Index: Integer): TMMMenuPosition; virtual; safecall;
    function GetMenuShortCuts(Index: Integer): TShortCut; virtual; safecall;
    function GetVerbCount: Integer; virtual; safecall;
    function GetVerbs(Index: Integer): WideString; virtual; safecall;
    property ActionCount: Integer read GetActionCount;
    property MenuPositions[Index: Integer]: TMMMenuPosition read GetMenuPositions;
    property MenuShortCuts[Index: Integer]: TShortCut read GetMenuShortCuts;
    property VerbCount: Integer read GetVerbCount;
    property Verbs[Index: Integer]: WideString read GetVerbs;
  end;

  TIMMNotifier = class (TInterfacedObject, IMMNotifier)
  public
    procedure Destroyed; virtual; safecall;
  end;

  TIMMProjectNotifier = class(TIMMNotifier, IMMNotifier, IMMProjectNotifier)
  public
    procedure AfterNew; virtual; safecall;
    procedure AfterOpen(const FileName: WideString); virtual; safecall;
    procedure AfterSave(const FileName: WideString); virtual; safecall;
    procedure AfterStartup; virtual; safecall;
    procedure BeforeNew(var Cancel: Boolean); virtual; safecall;
    procedure BeforeOpen(const FileName: WideString; var Cancel: Boolean); virtual;  safecall;
    procedure BeforeSave(const FileName: WideString; var Cancel: Boolean); virtual; safecall;
    procedure BeforeShutDown; virtual; safecall;
    procedure CommitEditors; virtual; safecall;
    procedure ExpertsLoaded; virtual; safecall;
  end;


var
  MMToolServices: IMMToolServices;

const
  MMExpertVersionProcName = 'MMExpertVersionProc';
  MMExpertEntryProcName = 'MMExpertEntryProc';
  MMExpertExitProcName = 'MMExpertExitProc';
  MMIDEVCSEntryProcName = 'MMIDEVCSEntryProc';

type
  TMMExpertVersionProc = function: LongInt; stdcall;
  TMMExpertEntryProc = procedure(const Srv: IMMToolServices); stdcall;
  TMMExpertExitProc = procedure; stdcall;
  TMMIDEVCSEntryProc = procedure(ParentHandle: HWND; out VCSExpert: IMMVCSExpert); stdcall;

function V9VisibilityToVisibility(const Value: TV9Visibility): TVisibility;

function VisibilityToV9Visibility(const Value: TVisibility): TV9Visibility;

implementation

function V9VisibilityToVisibility(const Value: TV9Visibility): TVisibility;
const
  Map: array[TV9Visibility] of TVisibility =
    (scDefault, scPrivate, scProtected, scPublic, scPublished,
     scAutomated, scStrictPrivate, scStrictProtected);
begin
  Result := Map[Value];
end;

function VisibilityToV9Visibility(const Value: TVisibility): TV9Visibility;
const
  Map: array[TVisibility] of TV9Visibility =
    (vis9Default, vis9StrictPrivate, vis9Private, vis9StrictProtected, vis9Protected,
     vis9Public, vis9Published, vis9Automated);
begin
  Result := Map[Value];
end;

{
*************************************** TIMMExpert ***************************************
}
procedure TIMMExpert.Destroyed;
begin
  // Called just before the expert is unloaded and the reference is released
end;

procedure TIMMExpert.Execute(Index: Integer);
begin
end;

procedure TIMMExpert.ExecuteAction(Index: Integer);
begin
end;

function TIMMExpert.GetActionCount: Integer;
begin
  Result := 0;
end;

procedure TIMMExpert.GetActionData(Index: Integer; var Data: TMMActionData);
begin
end;

function TIMMExpert.GetCustomImages(ImageIndexOffset: Integer; var Images: THandle): 
        Boolean;
begin
  Result := False;
end;

function TIMMExpert.GetCustomMenuData: WideString;
begin
  Result := '';
end;

function TIMMExpert.GetCustomToolbarData: WideString;
begin
  Result := '';
end;

function TIMMExpert.GetMenuPositions(Index: Integer): TMMMenuPosition;
begin
  Result := mpToolsMenu;
end;

function TIMMExpert.GetMenuShortCuts(Index: Integer): TShortCut;
begin
  Result := 0;
end;

function TIMMExpert.GetVerbCount: Integer;
begin
  Result := 0;
end;

function TIMMExpert.GetVerbs(Index: Integer): WideString;
begin
  Result := '';
end;

{ TIMMNotifier }

procedure TIMMNotifier.Destroyed;
begin
end;

{ TIMMProjectNotifier }

procedure TIMMProjectNotifier.AfterNew;
begin
end;

procedure TIMMProjectNotifier.AfterOpen(const FileName: WideString);
begin
end;

procedure TIMMProjectNotifier.AfterSave(const FileName: WideString);
begin
end;

procedure TIMMProjectNotifier.AfterStartup;
begin
end;

procedure TIMMProjectNotifier.BeforeNew(var Cancel: Boolean);
begin
end;

procedure TIMMProjectNotifier.BeforeOpen(const FileName: WideString; var Cancel: Boolean);
begin
end;

procedure TIMMProjectNotifier.BeforeSave(const FileName: WideString; var Cancel: Boolean);
begin
end;

procedure TIMMProjectNotifier.BeforeShutDown;
begin
end;

procedure TIMMProjectNotifier.CommitEditors;
begin
end;

procedure TIMMProjectNotifier.ExpertsLoaded;
begin
end;

end.
