unit uEXE_INI;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
  {$IFDEF MSWINDOWS}
  Windows,
  JCLWin32,
  JCLShell,
  {$ENDIF}
  INIFiles;

type
 TEXE_INIFile
 =
  class( TINIFile)
  private
    function GetToolTip(Index: String): Boolean;
    procedure SetToolTip(Index: String; Value: Boolean);
  public
    property ToolTip[ Index: String]: Boolean read GetToolTip write SetToolTip;
    procedure Reset_ToolTips;

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
    procedure SetChemin( Key, Value  : String);
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
  end;

var
   EXE_INI_Global: TEXE_INIFile= nil;
   EXE_INI       : TEXE_INIFile= nil;
   EXE_INI_Poste : TEXE_INIFile= nil;

procedure Cree_EXE_INI_Poste;//doit être appelé depuis uNetwork pour que
                             //le nom de poste soit renseigné.

function uEXE_INI_ListeParametres: String;

function uEXE_INI_INI_from_EXE( _EXE: String): String;

function  uEXE_INI_GetString( INI, Section, Key, Default: String): String;
procedure uEXE_INI_SetString( INI, Section, Key, Value: String);
function  uEXE_INI_GetInteger( INI, Section, Key: String; Default: Integer): Integer;
procedure uEXE_INI_SetInteger( INI, Section, Key: String; Value  : Integer);

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

{$IFDEF MSWINDOWS}
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
     Utiliser_OD_IOO:= EXE_INI.ReadBool( 'Options', 'Utiliser_OD_IOO', False);
     Result:= EXE_INI.ReadBool( 'Options', 'Utiliser_OD', Utiliser_OD_IOO);
end;

procedure TEXE_INIFile.SetUtiliser_OD(const Value: Boolean);
begin
     EXE_INI.WriteBool( 'Options', 'Utiliser_OD', Value);
end;

procedure Cree_EXE_INI_Poste;
var
   NomPoste: String;
begin
     NomPoste
     :=
         ExtractFilePath( uForms_EXE_Name)
       + 'etc'+PathDelim+'_Configuration.'
       + uClean_NetWork_Nom_Hote
       + '.ini';

     EXE_INI_Poste:= TEXE_INIFile.Create( NomPoste);
end;

function TEXE_INIFile.GetChemin(Key: String): String;
begin
     Result:= ReadString( 'Options', Key, '@');
     if Result = '@'
     then
         begin
         Chemin[ Key]:= '';
         Result:= '';
         end;

end;

procedure TEXE_INIFile.SetChemin(Key, Value: String);
begin
     WriteString( 'Options', Key, Value);
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

             {$IFDEF MSWINDOWS}
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
     {$IFDEF MSWINDOWS}
     sChemin_Program_files:= GetSpecialFolderLocation( CSIDL_PROGRAM_FILES);
     {$ELSE}
     sChemin_Program_files:= PathDelim+'opt'+PathDelim;
     {$ENDIF}
     sChemin_Program_files:= IncludeTrailingPathDelimiter( sChemin_Program_files);

     Result:= sChemin_Program_files+'Batpro'+PathDelim+_NomApplication+PathDelim;
end;

function TEXE_INIFile.Chemin_Local_from_NomApplication( _NomApplication: String): String;
begin
     //Result:= Chemin_Local_Program_Files( _NomApplication);
     Result:= Chemin_Local;
end;

var
   Nom: String;
   ExeFileName: String;
   Special: Boolean;
   Nom_global: String;
   ModuleName: String;
initialization
              Buffer:= StrAlloc( BufferSize);

              {$IFDEF FPC}
              if Trim(uForms_EXE_Name) = ''
              then
                  WriteLn( StdErr,'uEXE_INI initialization: uForms_EXE_Name = >'+uForms_EXE_Name+'<');
              {$ENDIF}
              ExeFileName:= UpperCase( ExtractFileName( uForms_EXE_Name));
              Special
              :=
                    ('BATPRO~1.EXE'       = ExeFileName) //Batpro_Copieur
                 or ('BATPRO_ICONES.EXE'  = ExeFileName)
                 or (('BATPRO_COPIEUR.EXE' = ExeFileName) and (ParamCount = 0));
              if Special
              then
                  begin
                  if    ('BATPRO~1.EXE'       = ExeFileName) //Batpro_Copieur
                     or (('BATPRO_COPIEUR.EXE' = ExeFileName) and (ParamCount = 0))
                  then
                      Nom:= ExtractFilePath( uForms_EXE_Name)+'Batpro_Copieur_Application.ini'
                  else
                      Nom:= ChangeFileExt( uForms_EXE_Name, '.ini');
                  end
              else
                  begin
                  Nom:= uEXE_INI_INI_from_EXE( uForms_EXE_Name);
                  if not FileExists( Nom)
                  then
                      begin
                      ModuleName:= GetModuleName( HInstance);

                      if ModuleName <> ''
                      then
                          Nom:= uEXE_INI_INI_from_EXE( ModuleName);
                      end;
                  end;

              {$IFDEF FPC}
              if 1= pos( PathDelim+'etc', Nom)
              then
                  Nom:= '~'+Nom;
              //WriteLn( StdErr, 'uEXE_INI initialization: EXE_INI Nom = >'+Nom+'<');
              {$ENDIF}
              EXE_INI:= TEXE_INIFile.Create( Nom);

              if Special
              then
                  Nom_global:= Nom
              else
                  Nom_global:= EXE_INI.Chemin_Global+'etc'+PathDelim+'_Configuration.ini';

              {$IFDEF FPC}
              //WriteLn( StdErr,'uEXE_INI initialization: EXE_INI_Global Nom = >'+Nom_global+'<');
              {$ENDIF}
              EXE_INI_Global:= TEXE_INIFile.Create( Nom_global);
finalization
              Free_nil( EXE_INI_Global);
              EXE_INI.UpdateFile;
              Free_nil( EXE_INI);

              if Assigned( EXE_INI_Poste)
              then
                  EXE_INI_Poste.UpdateFile;
              Free_nil( EXE_INI_Poste);
              StrDispose( Buffer);
end.

