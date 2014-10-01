{-
ModelMaker 7 code
Copyright (C) 1994-2004
ModelMaker Tools
http://www.modelmakertools.com

No part of this code may be used or copied without
written permission of ModelMaker Tools
}

unit MMEngineDefs;

interface

uses Classes, SysUtils;

const
// CodeModel entities have unique ID's ID's can have any integer Value. Typically >=0
  IDInvalid         = -1; // Invalid ID or None ID.
  IDUser            = -2; // User ID, used to identify user owned entities
//  Diagrams and symbols use ID's numbered [1..> Any ID <=0 is an invalid diagram
  IDNoDiagram       = 0;

// UnspecifiedCustomOrder, used in IMMMember.CustomOrder and IMMMethod.CustomImplOrder
  UnspecifiedCustomOrder = 0;

  ModelMakerVersion = 7;
  MidexVersion      = 2;
  MMUXVersion       = 1;
  MMSDVVersion      = 1;

// The MM 5 base key - exists only for backward compatibility
// ModelMaker Explorer and MM 6/7 should use new keys
  MM5BaseRegistryKey = 'Software\Babs\ModelMaker\5.0'; { obsolete }
// Use the Expert registry key offset to store expert related settings, for example
// MMBaseExpertRegistryKey + '\MyExpert'
  MM5BaseExpertRegistryKey = MM5BaseRegistryKey + '\Experts'; { obsolete }

// ModelMaker [6..n> and ModelMaker Code Explorer (Midex) [1..n> registry base keys
  ModelMakerRegRootKey = 'Software\ModelMaker';
  ModelMakerRegSharedKey = ModelMakerRegRootKey + '\Shared';
  ModelMakerRegTemplatesKey = ModelMakerRegSharedKey + '\Templates';
  MideXRegRootKey = ModelMakerRegRootKey + '\MideX';
  MMRegRootKey = ModelMakerRegRootKey + '\ModelMaker';
  MMUXRegRootKey = ModelMakerRegRootKey + '\MMUX';
  MMSDVRegRootKey = ModelMakerRegRootKey + '\MMSDV';

function MMBaseRegistryKey(Version: Integer = ModelMakerVersion): string;

function MMBaseExpertRegistryKey(Version: Integer = ModelMakerVersion): string;

function MideXBaseRegistryKey(Version: Integer = MideXVersion): string;

function MMUXBaseRegistryKey(Version: Integer = MMUXVersion): string;

function MMSDVBaseRegistryKey(Version: Integer = MMSDVVersion): string;

type
  // Delphi 6 compiler hint/warning
  THintDirective = (hdDeprecated, hdPlatform, hdLibrary, hdExperimental);
  THintDirectives = set of THintDirective;

  TClassPersistency = (cpAutoDetect, cpTransient, cpPersistent, cpEmbedded);

  TEntityType = (tyNone, tyClass, tyMember, tyUnit, tyEventType, tyDiagram);
  TEntityTypes = set of TEntityType;

  // allows the use of case statements with IMMMember.MemberType
  TMemberType = (cpResClause, cpField, cpMethod, cpProperty, cpEvent);
  TMemberTypes = set of TMemberType;

  TVisibility = (scDefault, scStrictPrivate, scPrivate, scStrictProtected, scProtected,
                 scPublic, scPublished, scAutomated);
  TVisibilities = set of TVisibility;

  TMethodKind = (mkConstructor, mkDestructor, mkProcedure, mkFunction, mkOperator);
  TMethodKinds = set of TMethodKind;

  // BindingKind bkAbstract is obsolete from toolsapi v7 onwards.
  // Use bkVirtual, bkDynamic or bkOverride and combine it with the
  // IMMMethod.IsAbstract property to specify abstract methods.
  // Setting a binding to bkAbstract will effect in setting bkVirtual and setting IsAbstract := True
  // Reading the binding for a virtual abstract method will return bkVirtual. NOT bkAbstract

  TBindingKind = (bkStatic, bkVirtual, bkAbstract, bkOverride, bkDynamic, bkMessage);
  TBindingKinds = set of TBindingKind;

  TCallConvention = (ccDefault, ccRegister, ccPascal, ccCDecl, ccStdCall, ccExport,
                     ccSafeCall, ccFar);

  // state of sections of code and local vars in methods and units
  TSectionState = (ssReadWrite, ssReadOnly);

  // property default specifier, the actual default value must be specified for dsDefault
  TDefaultSpecifier = (dsUnspecified, dsDefault, dsNoDefault);

  // read write access specifiers for properties
  TRWAccessEx = (rwNone, rwField, rwMethod, rwCustom);
  // In ModelMaker 5.x only these values are available
  TRWAccess = rwNone..rwMethod;

  TFieldKind = (fkInstance, fkStatic, fkConst);
  TFieldKinds = set of TFieldKind;


  TMMProcDirective = (prdForward, prdExternal, prdOverload, prdUnsafe);
  TMMProcDirectives = set of TMMProcDirective;

  TInterfaceRoot = (irIInterface, irIUnknown);

const
  AllBindings = [Low(TBindingKind)..High(TBindingKind)];
  AllVisibilities = [Low(TVisibility) .. High(TVisibility)];
  PrivateVisibilities = [scStrictPrivate, scPrivate];
  ProtectedVisibilities = [scStrictProtected, scProtected];
  PublicVisibilities = AllVisibilities - PrivateVisibilities - ProtectedVisibilities;
  FamilyVisibilities = AllVisibilities - PrivateVisibilities;
  AllMembers = [Low(TMemberType)..High(TMemberType)];
  AllMethodKinds = [Low(TMethodKind)..High(TMethodKind)];
  ReturnTypeMethodKinds = [mkFunction, mkOperator];
  AllHintDirectives = [Low(THintDirective)..High(THintDirective)];
  AllFieldKinds = [Low(TFieldKind)..High(TFieldKind)];
  InstanceFieldKinds = [fkInstance];

// C# visibility mapping
  cscDefault = scDefault;
  cscPrivate = scStrictPrivate;
  cscInternal = scPrivate;
  cscProtected = scStrictProtected;
  cscProtectedInternal = scProtected;
  cscPublic = scPublic;

  AllCSharpVisibilities = [cscDefault..cscPublic];


  InterfaceRootNames: array [TInterfaceRoot] of string =
    ('IInterface', 'IUnknown');

// Mapping of IMMModelPart options for all IMMModelPart descendants
// Options is a Word bit mask. Only specified values should be accessed.

// IMMClassifier option masks
  classPlaceHolder     = $1; // Mark this class as placeholder (no relation to code)
  classAbstract        = $2; // Mark this class as abstract (no relation to code)
  classPureAbstract    = $10;// Mark class as pure abstract class, only used in combination with classAbstract
  classForwardDecl     = $4; // Insert a foward declaration during unit code generation
  classExcludeCrWizard = $8; // exclude this class from background creational wizard
  classHidden          = $20;// Equals hidden property
  classPacked          = $40;// Equals "packed" directive for classes and records
  classSealed          = $80;// Equals a sealed class. Overrides classAbstract and classPureAbstract
  // classImported     = $4000; // reserved, Imported

// IMMField option masks
  fieldOwned           = $1; // Mark this field as owned (visualization in diagrams and Creational wizard)
  fieldReserved1       = $2; // Do not use
  fieldInitialize      = $4; // Mark this field as Initialized (visualization in diagrams and Creational wizard)
  fieldReserved2       = $8; // Do not use
  fieldHidden          = $10; // Equals hidden property
  fieldReserved3       = $20; // Do not use (property state field)
  // fieldImported     = $4000; // reserved, Imported

// IMMMethod option masks
  methodClassMethod           = $1; // method is a class method
  methodReserved1             = $2; //
  methodInheritanceRestricted = $4; // method signature is inheritance restricted
  methodAccessMethod          = $8; // method is a property access method
  methodReintroduce           = $10;// method has "reintroduce" specifier
  methodOverload              = $20;// method has "overload" specifier
  methodInstrumented          = $40;// method instrumentation is active
  // reserved $80..$400
  methodHidden                = $800;// Equals hidden property
  methodStatic                = $1000; // Static Class method
  methodUnsafe                = $2000; // Mark method unsafe
  // methodImported           = $4000; // reserved, Imported

// IMMProperty (and IMMEvent) option masks
  propArray           = $1;    // property is an array property
  propDefaultArray    = $2;    // property is default array property
  propReserved1       = $4;
  propReserved2       = $8;
  propReserved3       = $10;
  propOverride        = $20;   // property is property override
  propConstWritePar   = $40;   // property hs "const" write parameter
  propReserved4       = $80;
  propIndex           = $100;  // property is an indexed property
  propStored          = $200;  // property has "stored" specifier
  propReserved5       = $400;
  propReserved6       = $800;
  propHidden          = $1000;  // Equals hidden property
  propClassProperty   = $2000;  // Property is a class (non-instance) property
  // propImported     = $4000   // internally reserved (Imported)
  propMulticastEvent  = $8000;  // Property uses add/remove instead of read/write syntax

// IMMResClause option masks
  mrcHidden           = $10;   // Equals hidden (not visible) property
  // mrcImported      = $4000; // Reserved, imported

// generic utilities

function VisibilityStr(Visibility: TVisibility): string;

function CSharpVisibilityStr(Visibility: TVisibility): string;

function MethodKindStr(MethodKind: TMethodKind): String;

function StrToMethodKind(const S: string; var MethodKind: TMethodKind): Boolean;

function BindingKindStr(BindingKind: TBindingKind): String;

function StrToBindingKind(const S: string; var BindingKind: TBindingKind): Boolean;

function DefaultSpecStr(DefaultSpec: TDefaultSpecifier): string;

function StrToDefaultSpec(const S: string; var DefaultSpec: TDefaultSpecifier): Boolean;

function CallConventionStr(CallConv: TCallConvention): String;

function StrToCallConvention(const S: string; var CallConv: TCallConvention): Boolean;

function HintDirStr(H: THintDirective): string;

function CompressStrictVisibilities(const Value: TVisibilities): TVisibilities;

function ExpandStrictVisibilities(const Value: TVisibilities): TVisibilities;

function NearestVisibility(const Value: TVisibility; Filter: TVisibilities): TVisibility;

type
  EMMInterfaceError = class (Exception)
  end;

procedure InvalidInterface;

implementation

resourcestring
  SInvalidInterface = 'Invalid interface';


function MMBaseRegistryKey(Version: Integer = ModelMakerVersion): string;
begin
  if Version = 5 then
    Result := MM5BaseRegistryKey
  else
    Result := Format('%s\%d.0', [MMRegRootKey, Version]);
end;

function MMBaseExpertRegistryKey(Version: Integer = ModelMakerVersion): string;
begin
  if Version = 5 then
    Result := MM5BaseExpertRegistryKey
  else
    Result := Format('%s\%d.0\Experts', [MMRegRootKey, Version]);
end;

function MideXBaseRegistryKey(Version: Integer = MideXVersion): string;
begin
  Result := Format('%s\%d.0', [MideXRegRootKey, Version]);
end;

function MMUXBaseRegistryKey(Version: Integer = MMUXVersion): string;
begin
  Result := Format('%s\%d.0', [MMUXRegRootKey, Version]);
end;

function MMSDVBaseRegistryKey(Version: Integer = MMSDVVersion): string;
begin
  Result := Format('%s\%d.0', [MMSDVRegRootKey, Version]);
end;

{$IFDEF VER120}
function SameText(const S1, S2: string): Boolean;
begin
  Result := CompareText(S1, S2) = 0;
end;
{$ENDIF}
{$IFDEF VER110}
function SameText(const S1, S2: string): Boolean;
begin
  Result := CompareText(S1, S2) = 0;
end;
{$ENDIF}

function VisibilityStr(Visibility: TVisibility): string;
const
  VisStrs: array[TVisibility] of string =
    ('default', 'strict private', 'private', 'strict protected', 'protected', 'public', 'published', 'automated'); // do not localize
begin
  Result := VisStrs[Visibility];
end;

function CSharpVisibilityStr(Visibility: TVisibility): string;
begin
  case Visibility of
    scDefault: Result := 'default';
    cscPrivate: Result := 'private';
    cscInternal: Result := 'internal';
    cscProtected: Result := 'protected';
    cscProtectedInternal: Result := 'protected internal';
  else
    Result := 'public';
  end;
end;

function MethodKindStr(MethodKind: TMethodKind): string;
const
  KindStrs: array[TMethodKind] of string =
           ('constructor', 'destructor', 'procedure', 'function', 'operator'); // do not localize
begin
  Result := KindStrs[MethodKind];
end;

function StrToMethodKind(const S: string; var MethodKind: TMethodKind): Boolean;
begin
  Result := False;
  if Length(S) >= 8 then
    case Upcase(S[1]) of
      'C': begin
             Result := SameText(S, 'CONSTRUCTOR'); // do not localize
             if Result then MethodKind := mkConstructor;
           end;
      'D': begin
             Result := SameText(S, 'DESTRUCTOR'); // do not localize
             if Result then MethodKind:= mkDestructor;
           end;
      'F': begin
             Result := SameText(S, 'FUNCTION');  // do not localize
             if Result then MethodKind:= mkFunction;
           end;
      'O': begin
             Result := SameText(S, 'OPERATOR'); // do not localize
             if Result then MethodKind:= mkOperator;
           end;
      'P': begin
             Result := SameText(S, 'PROCEDURE'); // do not localize
             if Result then MethodKind := mkProcedure;
           end;
    end;
end;

function BindingKindStr(BindingKind: TBindingKind): String;
const
  BindStrs: array[TBindingKind] of string =
        ('static', 'virtual', 'virtual', 'override', 'dynamic', 'message'); // do not localize
begin
  Result := BindStrs[BindingKind];
  // WARNING this function does NOT return Abstract as in virtual; abstract; or dynamic; abstract;
end;

function StrToBindingKind(const S: string; var BindingKind: TBindingKind): Boolean;
var
  B: TBindingKind;
begin
  for B := Low(TBindingKind) to High(TBindingKind) do
    if SameText(BindingKindStr(B), S) then
    begin
      Result := True;
      BindingKind := B;
      Exit;
    end;
  Result := False;
end;

function CallConventionStr(CallConv: TCallConvention): string;
const
  CallConvStrs: array[TCallConvention] of string =
     ('default', 'register', 'pascal', 'cdecl', 'stdcall', 'export', 'safecall', 'far'); // do not localize
begin
  Result := CallConvStrs[CallConv];
end;

function StrToCallConvention(const S: string; var CallConv: TCallConvention): Boolean;
var
  C: TCallConvention;
begin
  for C := Low(TCallConvention) to High(TCallConvention) do
    if SameText(S, CallConventionStr(C)) then
    begin
      Result := True;
      CallConv := C;
      Exit;
    end;
  Result := False;
end;

function DefaultSpecStr(DefaultSpec: TDefaultSpecifier): string;
const
   DefStrs: array[TDefaultSpecifier] of string = ('', 'default', 'no default'); // do not localize
begin
  Result := DefStrs[DefaultSpec];
end;

function StrToDefaultSpec(const S: string; var DefaultSpec: TDefaultSpecifier): Boolean;
var
  C: TDefaultSpecifier;
begin
  for C := Low(TDefaultSpecifier) to High(TDefaultSpecifier) do
    if SameText(S, DefaultSpecStr(C))then
    begin
      Result := True;
      DefaultSpec := C;
      Exit;
    end;
  Result := False;
end;

function HintDirStr(H: THintDirective): string;
const
  HintStrs: array[THintDirective] of string = ('deprecated', 'platform', 'library', 'experimental'); // do not localize
begin
  Result := HintStrs[H];
end;

function CompressStrictVisibilities(const Value: TVisibilities): TVisibilities;
begin
  // Combines scPrivate || scStrictPrivate into scPrivate, similar for scStrictProtected and scProtected.
  Result := ExpandStrictVisibilities(Value) - [scStrictPrivate, scStrictProtected];
end;

function ExpandStrictVisibilities(const Value: TVisibilities): TVisibilities;
begin
  Result := Value;
  // synchronizes private and strict private & protected and strict protected
  if scPrivate in Result then Include(Result, scStrictPrivate);
  if scStrictPrivate in Result then Include(Result, scPrivate);
  if scProtected in Result then Include(Result, scStrictProtected);
  if scStrictProtected in Result then Include(Result, scProtected);
end;

function NearestVisibility(const Value: TVisibility; Filter: TVisibilities): TVisibility;
begin
  Result := Value;
  if Result in Filter then Exit;
  if Result < scPublic then
  begin
    if Result = scStrictPrivate then Result := scPrivate;
    if Result in Filter then Exit;
    if Result = scStrictProtected then Result := scProtected;
    if Result in Filter then Exit;
    if Result = scProtected then Result := scPrivate;
    if Result in Filter then Exit;
  end
  else // remap >= Public
  begin
    while Result > scPublic do
    begin
      Dec(Result);
      if Result in Filter then Exit;
    end;
  end;
  Result := scDefault;
end;

procedure InvalidInterface;
begin
  raise EMMInterfaceError.Create(SInvalidInterface);
end;

{$IFOPT C+}
procedure CheckMethodKinds;
var
  MK: TMethodKind;
  M: TMethodKind;
begin
  for M := Low(M) to High(M) do
    Assert(StrToMethodKind(MethodKindStr(M), MK) and (M = MK));
end;

initialization
  CheckMethodKinds;
{$ENDIF}
end.
