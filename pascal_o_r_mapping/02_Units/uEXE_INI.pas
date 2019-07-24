unit uEXE_INI;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uForms,
    uClean,
    u_sys_,
    u_ini_,
    u_db_,
    uuStrings,
    uBatpro_StringList,
  SysUtils, Classes,
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  JCLWin32,
  JCLShell,
  {$ENDIF}
  INIFiles;

type

 { TEXE_INIFile }

 TEXE_INIFile
 =
  class( TINIFile)
  //Gestion du cycle de vie
  public
    constructor Create(const AFileName: string; AEscapeLineFeeds : Boolean = False); overload; override;
    destructor Destroy; override;
  //ToolTip
  private
    function GetToolTip(Index: String): Boolean;
    procedure SetToolTip(Index: String; Value: Boolean);
  public
    property ToolTip[ Index: String]: Boolean read GetToolTip write SetToolTip;
    procedure Reset_ToolTips;
 //ValueList
 public
    procedure ValueList_to_Section( Section: String; ValueList: TStrings);
    procedure Section_to_ValueList(Section: String; ValueList: TStrings);
  //Mode autonome
  private
    function GetDelphi_autonome: Boolean;
    procedure SetDelphi_autonome( const Value: Boolean);
  public
    property Delphi_autonome: Boolean read GetDelphi_autonome write SetDelphi_autonome;
  //Utiliser_OD
  private
    function GetUtiliser_OD: Boolean;
    procedure SetUtiliser_OD(const Value: Boolean);
  public
    property Utiliser_OD: Boolean read GetUtiliser_OD write SetUtiliser_OD;
  //Chemins
  private
    function  GetChemin( Key: String): String;
    procedure SetChemin( Key: String; Value: String);
  public
    property Chemin[ Key:String]: String read GetChemin write SetChemin;
  //Chemin Global
  private
    function  GetChemin_Global: String;
    procedure SetChemin_Global( Value: String);
  public
    property Chemin_Global: String read GetChemin_Global write SetChemin_Global;
  //Chemin Local
  private
    function  GetChemin_Local: String;
    procedure SetChemin_Local( Value: String);
  public
    property Chemin_Local: String read GetChemin_Local write SetChemin_Local;
    function Chemin_Local_Program_Files( _NomApplication: String): String;
    function Chemin_Local_from_NomApplication( _NomApplication: String): String;
  //OS
  public
    os: String;
  //Utilitaires
  public
    function Assure_String( _iniKey: String; _iniDefault: String= ''): String;
    function Assure_Double( _iniKey: String; _iniDefault: Double= 0 ): Double;
  end;

const
     inis_Options= 'Options';

function EXE_INI_Global: TEXE_INIFile;
function EXE_INI       : TEXE_INIFile;
function EXE_INI_Poste : TEXE_INIFile;

procedure Cree_EXE_INI_Poste;//doit être appelé depuis uNetwork pour que
                             //le nom de poste soit renseigné.

function uEXE_INI_ListeParametres: String;

function uEXE_INI_INI_from_EXE( _EXE: String): String;

function  uEXE_INI_GetString( INI, Section, Key, Default: String): String;
procedure uEXE_INI_SetString( INI, Section, Key, Value: String);
function  uEXE_INI_GetInteger( INI, Section, Key: String; Default: Integer): Integer;
procedure uEXE_INI_SetInteger( INI, Section, Key: String; Value  : Integer);

procedure uEXE_INI_init_android( _EnvironmentDirPath: String);

function DumpCallStack: String;

implementation

function uEXE_INI_ListeParametres: String;
var
   I: Integer;
begin
     Result:= '';
     for I:= 1 to ParamCount
     do
       Formate_Liste( Result, ' ', ParamStr( I));
end;

const
     BufferSize= 1024;
var
   Buffer: PChar;

function uEXE_INI_INI_from_EXE( _EXE: String): String;
var
   Repertoire_de_etc: String;
begin
     Repertoire_de_etc:= uClean_ETC_from_EXE( _EXE);
     Result:= Repertoire_de_etc+PathDelim+'_Configuration.ini';
end;

{$IFNDEF FPC}
function uEXE_INI_GetString( INI, Section, Key, Default: String): String;
begin
     FillChar( Buffer^, BufferSize, 0);
     GetPrivateProfileString( PChar(Section), PChar(Key), PChar(Default),
                              Buffer, BufferSize, PChar(INI));
     Result:= StrPas( Buffer);
end;

procedure uEXE_INI_SetString( INI, Section, Key, Value: String);
begin
     WritePrivateProfileString( PChar(Section), PChar(Key), PChar(Value),
                                PChar(INI));
end;
{$ELSE}
function uEXE_INI_GetString( INI, Section, Key, Default: String): String;
var
   i: TINIFile;
begin
     i:= TINIFile.Create( INI);
     try
        Result:= i.ReadString( Section, Key, Default);
     finally
            Free_nil( i);
            end;
end;

procedure uEXE_INI_SetString( INI, Section, Key, Value: String);
var
   i: TINIFile;
begin
     i:= TINIFile.Create( INI);
     try
        i.WriteString( Section, Key, Value);
     finally
            Free_nil( i);
            end;
end;
{$ENDIF}

function  uEXE_INI_GetInteger( INI, Section, Key: String; Default: Integer): Integer;
var
   S: String;
begin
     S:= IntToStr( Default);

     S:= uEXE_INI_GetString( INI, Section, Key, S);

     Result:= StrToInt( S);
end;

procedure uEXE_INI_SetInteger( INI, Section, Key: String; Value  : Integer);
var
   S: String;
begin
     S:= IntToStr( Value);

     uEXE_INI_SetString( INI, Section, Key, S);
end;

{ TEXE_INIFile }

var
   FEXE_INI_Global: TEXE_INIFile= nil;
   FEXE_INI       : TEXE_INIFile= nil;
   FEXE_INI_Poste : TEXE_INIFile= nil;

   EXE_INI_Global_Nom: String = '';
   EXE_INI_Nom       : String = '';
   EXE_INI_Poste_Nom : String = '';

 {taken from Freepascal documentation}
 function DumpCallStack: String;
 var
   I: Longint;
   prevbp: Pointer;
   CallerFrame,
   CallerAddress,
   bp: Pointer;
   Report: string;
 const
   MaxDepth = 20;
 begin
       Report := '';
       bp := get_frame;
       // This trick skip SendCallstack item
       // bp:= get_caller_frame(get_frame);
       try
         prevbp := bp - 1;
         I := 0;
         while bp > prevbp do begin
            CallerAddress := get_caller_addr(bp);
            CallerFrame := get_caller_frame(bp);
            if (CallerAddress = nil) then
              Break;
            Report := Report + BackTraceStrFunc(CallerAddress) + LineEnding;
            Inc(I);
            if (I >= MaxDepth) or (CallerFrame = nil) then
              Break;
            prevbp := bp;
            bp := CallerFrame;
          end;
        except
          { prevent endless dump if an exception occured }
        end;
        Result:= Report;
 end;

procedure EXE_INI_interne( out _Resultat: TEXE_INIFile; var _FEXE_INI: TEXE_INIFile; _Nom: String);
begin
     if nil = _FEXE_INI
     then
         begin
         if '' = _Nom
         then
             begin
             {$ifdef android}
             WriteLn( 'uEXE_INI.EXE_INI_interne: nom non initialisé: '#13#10+DumpCallStack);
             {$endif}
             uForms_ShowMessage( 'uEXE_INI.EXE_INI_interne: nom non initialisé: '#13#10+DumpCallStack);
             end
         else
             _FEXE_INI:= TEXE_INIFile.Create( _Nom);
         end;
     _Resultat:= _FEXE_INI;
end;

function EXE_INI_Global: TEXE_INIFile; begin EXE_INI_interne( Result, FEXE_INI_Global, EXE_INI_Global_Nom); end;
function EXE_INI       : TEXE_INIFile; begin EXE_INI_interne( Result, FEXE_INI       , EXE_INI_Nom       ); end;
function EXE_INI_Poste : TEXE_INIFile; begin EXE_INI_interne( Result, FEXE_INI_Poste , EXE_INI_Poste_Nom ); end;

constructor TEXE_INIFile.Create( const AFileName: string; AEscapeLineFeeds: Boolean);
begin
     inherited Create(AFileName, AEscapeLineFeeds);
     os
     :=
     {$IFDEF LINUX}
       'Linux.'
     {$ELSE}
       'Windows.'
     {$ENDIF};
end;

destructor TEXE_INIFile.Destroy;
begin
     inherited Destroy;
end;

function TEXE_INIFile.GetToolTip(Index: String): Boolean;
begin
     Result:= ReadBool( inis_ToolTips, Index, False);
end;

procedure TEXE_INIFile.SetToolTip(Index: String; Value: Boolean);
begin
     WriteBool( inis_ToolTips, Index, Value);
end;

procedure TEXE_INIFile.Reset_ToolTips;
begin
     EraseSection( inis_ToolTips);
end;

procedure TEXE_INIFile.ValueList_to_Section( Section: String; ValueList: TStrings);
var
   I: Integer;
begin
     if SectionExists( Section)
     then
         EraseSection( Section);
     for I:= 0 to ValueList.Count - 1
     do
       WriteString( Section, ValueList.Names[I], ValueList.ValueFromIndex[I]);
end;

procedure TEXE_INIFile.Section_to_ValueList( Section: String;
                                             ValueList: TStrings);
var
   sl: TBatpro_StringList;
   I: Integer;
   Cle: String;
begin
     ValueList.Clear;

     sl:= TBatpro_StringList.Create;
     try
        ReadSection( Section, sl);
        for I := 0 to sl.Count - 1
        do
          begin
          Cle:= sl.Strings[ I];
          ValueList.Values[Cle]:= ReadString( Section, Cle, sys_Vide);
          end;
     finally
            Free_nil( sl);
            end;
end;

function TEXE_INIFile.GetDelphi_autonome: Boolean;
begin
     Result:= ReadBool( ini_Options, ini_Delphi_autonome, False);
end;

procedure TEXE_INIFile.SetDelphi_autonome(const Value: Boolean);
begin
     WriteBool( ini_Options, ini_Delphi_autonome, Value);
end;

function TEXE_INIFile.GetUtiliser_OD: Boolean;
var
   Utiliser_OD_IOO: Boolean;
begin
     Utiliser_OD_IOO:= EXE_INI.ReadBool( inis_Options, 'Utiliser_OD_IOO', False);
     Result:= EXE_INI.ReadBool( inis_Options, 'Utiliser_OD', Utiliser_OD_IOO);
end;

procedure TEXE_INIFile.SetUtiliser_OD(const Value: Boolean);
begin
     EXE_INI.WriteBool( inis_Options, 'Utiliser_OD', Value);
end;

procedure Cree_EXE_INI_Poste;
begin
     {$ifndef android}
     EXE_INI_Poste_Nom
     :=
         ExtractFilePath( uForms_EXE_Name)
       + 'etc'+PathDelim+'_Configuration.'
       + uClean_NetWork_Nom_Hote
       + '.ini';
     {$endif}
end;

function TEXE_INIFile.GetChemin(Key: String): String;
begin
     Result:= ReadString( inis_Options, Key, '@');
     if Result = '@'
     then
         begin
         Chemin[ Key]:= '';
         Result:= '';
         end;

end;

procedure TEXE_INIFile.SetChemin( Key: String; Value: String);
begin
     WriteString( inis_Options, Key, Value);
end;

function TEXE_INIFile.GetChemin_Global: String;
begin
     Result:= Chemin[ 'Chemin_Global'];
     if Result <> ''
     then
         begin
         Result:= IncludeTrailingPathDelimiter( Result);
         exit;
         end;

     Result:= ExtractFilePath( uForms_EXE_Name);
end;

procedure TEXE_INIFile.SetChemin_Global(Value: String);
begin
     Chemin[ 'Chemin_Global']:= Value;
end;

function TEXE_INIFile.GetChemin_Local: String;
     procedure Traite_Nouveau;
     var
        ExeFileName: String;
        function not_Traite_Racine( _Racine: String;
                                    out _Chemin_Resultat: String): Boolean;
        var
           Racine_Uppercase: String;
        begin
             Racine_Uppercase:= UpperCase( _Racine);
             Result:= 1 <> Pos( Racine_Uppercase, ExeFileName);
             if Result then exit;

             {$IFNDEF FPC}
             _Chemin_Resultat:= 'C:'+PathDelim+'batpro'+PathDelim+_Racine+PathDelim;
             {$ELSE}
             _Chemin_Resultat:= '~'+PathDelim+'batpro'+PathDelim+_Racine+PathDelim;
             {$ENDIF}
        end;
     begin
          ExeFileName:= UpperCase( ExtractFileName( uForms_EXE_Name));
               if not_Traite_Racine( 'Batpro_Editions', Result)
          then    not_Traite_Racine( 'Batpro_Planning', Result);
     end;
begin
     Result:= Chemin[ 'Chemin_Local'];
     if Result = ''
     then
         Traite_Nouveau
     else
         Result:= IncludeTrailingPathDelimiter( Result);
end;

procedure TEXE_INIFile.SetChemin_Local(Value: String);
begin
     Chemin[ 'Chemin_Local']:= Value;
end;

function TEXE_INIFile.Chemin_Local_Program_Files( _NomApplication: String): String;
var
   sChemin_Program_files: String;
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     sChemin_Program_files:= GetSpecialFolderLocation( CSIDL_PROGRAM_FILES);
     {$ELSE}
     {$IFNDEF FPC}
     sChemin_Program_files:= 'C:'+PathDelim+'Program Files'+PathDelim;
     {$ELSE}
     sChemin_Program_files:= PathDelim+'opt'+PathDelim;
     {$ENDIF}
     {$ENDIF}
     sChemin_Program_files:= IncludeTrailingPathDelimiter( sChemin_Program_files);

     Result:= sChemin_Program_files+'Batpro'+PathDelim+_NomApplication+PathDelim;
end;

function TEXE_INIFile.Chemin_Local_from_NomApplication( _NomApplication: String): String;
begin
     //Result:= Chemin_Local_Program_Files( _NomApplication);
     Result:= Chemin_Local;
end;

function TEXE_INIFile.Assure_String( _iniKey: String; _iniDefault: String): String;
var
   iniKey: String;
begin
     iniKey:= os+_iniKey;
     Result:= ReadString( inis_Options, iniKey, '#');
     if '#' = Result
     then
         begin
         Result:= _iniDefault;
         WriteString( inis_Options, iniKey, Result);
         end;
end;

function TEXE_INIFile.Assure_Double( _iniKey: String; _iniDefault: Double): Double;
var
   siniDefault: String;
   sResult: String;
   Code: Integer;
begin
     Str( _iniDefault, siniDefault);
     sResult:= Assure_String( _iniKey, siniDefault);
     Val( sResult, Result, Code);
     if 0 <> Code
     then
         Result:= _iniDefault;
end;

procedure uEXE_INI_init;
var
   ExeFileName: String;
   Special: Boolean;
   ModuleName: String;
begin
     if Trim(uForms_EXE_Name) = ''
     then
         uClean_Log( 'uEXE_INI initialization: uForms_EXE_Name = >'+uForms_EXE_Name+'<');
     ExeFileName:= UpperCase( ExtractFileName( uForms_EXE_Name));
     Special
     :=
           ('BATPRO~1.EXE'      = ExeFileName) //Batpro_Copieur
        or ('BATPRO_ICONES.EXE' = ExeFileName);
     if Special
     then
         begin
         if 'BATPRO~1.EXE' = ExeFileName //Batpro_Copieur
         then
             EXE_INI_Nom:= ExtractFilePath( uForms_EXE_Name)+'Batpro_Copieur_Application.ini'
         else
             EXE_INI_Nom:= ChangeFileExt( uForms_EXE_Name, '.ini');
         end
     else
         begin
         EXE_INI_Nom:= uEXE_INI_INI_from_EXE( uForms_EXE_Name);
         if not FileExists( EXE_INI_Nom)
         then
             begin
             ModuleName:= GetModuleName( HInstance);

             if ModuleName <> ''
             then
                 EXE_INI_Nom:= uEXE_INI_INI_from_EXE( ModuleName);
             end;
         end;

     {$IFDEF LINUX}
     if 1= pos( PathDelim+'etc', EXE_INI_Nom)
     then
         EXE_INI_Nom:= '~'+EXE_INI_Nom;
     //uClean_Log( 'uEXE_INI initialization: EXE_INI Nom = >'+Nom+'<');
     {$ENDIF}

     if Special
     then
         EXE_INI_Global_Nom:= EXE_INI_Nom
     else
         EXE_INI_Global_Nom:= EXE_INI.Chemin_Global+'etc'+PathDelim+'_Configuration.ini';

     //uClean_Log( 'uEXE_INI initialization: EXE_INI_Global Nom = >'+EXE_INI_Global_Nom+'<');
end;

procedure uEXE_INI_init_android( _EnvironmentDirPath: String);
begin
     EXE_INI_Nom       := IncludeTrailingPathDelimiter( _EnvironmentDirPath)+'_Configuration.ini';
     EXE_INI_Global_Nom:= EXE_INI_Nom;
     EXE_INI_Poste_Nom := EXE_INI_Nom;
end;
initialization
              Buffer:= StrAlloc( BufferSize);

              {$ifndef android}
              uEXE_INI_init;
              {$endif}
finalization
              Free_nil( FEXE_INI_Global);
              FEXE_INI.UpdateFile;
              Free_nil( FEXE_INI);

              if Assigned( FEXE_INI_Poste)
              then
                  FEXE_INI_Poste.UpdateFile;
              Free_nil( FEXE_INI_Poste);
              StrDispose( Buffer);
end.

