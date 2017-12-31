unit uVersion;
{Copyright © 1998, 1999 Jean SUZINEAU}
interface

{$IFDEF MSWINDOWS}
uses
    uWinUtils,
  WinProcs, WinTypes, SysUtils, Math;
{$ENDIF}

const
     uVersion_non_disponible= '< non-disponible >';

function GetVersionProgramme: String;

{$IFDEF MSWINDOWS}
function GetVersionModule( Module: HModule): String;

function nGetVersionFichier( Fichier: String): TVSFixedFileInfo;
{$ENDIF}
function GetVersionFichier( Fichier: String): String;

{$IFDEF MSWINDOWS}
function nGetVersionProgramme: TVSFixedFileInfo;

function sFormate_Version( Version: TVSFixedFileInfo): String;
{$ENDIF}

function CompareVersions( _Fichier1, _Fichier2: String): Integer; //-1 si 1 < 2
                                                                  // 0 si 1 = 2
                                                                  //+1 si 1 > 2
implementation

{$IFDEF MSWINDOWS}
function nGetVersionFichier( Fichier: String): TVSFixedFileInfo;
var
   VersionInfo: Pointer;
   VersionInfoSize: DWORD;
   inutile_mais_requis: DWORD;

   Value: Pointer;
   ValueSize: UINT;
begin
     FillChar( Result, SizeOf( Result), 0);

     VersionInfoSize
     :=
       GetFileVersionInfoSize( PChar(Fichier), inutile_mais_requis);
     if VersionInfoSize = 0 then exit;

     GetMem( VersionInfo, VersionInfoSize);
        if GetFileVersionInfo(PChar(Fichier),0,VersionInfoSize, VersionInfo)
        then
            if VerQueryValue( VersionInfo, '\', Value, ValueSize)
            then
                Move( Value^, Result, ValueSize);
     FreeMem( VersionInfo, VersionInfoSize);
end;

function GetVersionFichier( Fichier: String): String;
var
   VersionInfo: Pointer;
   VersionInfoSize: DWORD;
   inutile_mais_requis: DWORD;

   Value: Pointer;
   ValueSize: UINT;

   Version: TVSFixedFileInfo;
begin
     VersionInfoSize
     :=
       GetFileVersionInfoSize( PChar(Fichier), inutile_mais_requis);
     if VersionInfoSize = 0
     then
         begin
         Result:= uVersion_non_disponible;
         //TraiteLastError( 'uVersion.GetVersionFichier: VersionInfoSize = 0, ');
         exit;
         end;

     GetMem( VersionInfo, VersionInfoSize);
        if GetFileVersionInfo(PChar(Fichier),0,VersionInfoSize, VersionInfo)
        then
            if VerQueryValue( VersionInfo, '\', Value, ValueSize)
            then
                begin
                Move( Value^, Version, ValueSize);
                Result
                :=
                  Format( '%d.%d.%d.%d',
                          [
                          HiWord(Version.dwFileVersionMS),
                          LoWord(Version.dwFileVersionMS),
                          HiWord(Version.dwFileVersionLS),
                          LoWord(Version.dwFileVersionLS)
                          ]
                          );
                end
            else
                Result:= '< non-spécifiée >'
        else
            Result:= '< non-spécifiée >';
     FreeMem( VersionInfo, VersionInfoSize);
end;

function GetVersionModule( Module: HModule): String;
var
   Fichier: String;
   Taille, Lus: Integer;
begin
     Taille:= 1024;
     Lus:= Taille;
     while Lus >= Taille-1
     do
       begin
       Inc( Taille, 8);
       SetLength( Fichier, Taille);
       Lus:= GetModuleFileName( Module, PChar(Fichier), Taille);
       end;
     SetLength( Fichier, Lus);

     Result
     :=
       Format( '%-16s, %s',
               [
               ExtractFileName(Fichier),
               GetVersionFichier( Fichier)
               ]);
end;

function GetVersionProgramme: String;
begin
     Result:= GetVersionFichier( ParamStr(0));
end;

function nGetVersionProgramme: TVSFixedFileInfo;
begin
     Result:= nGetVersionFichier( ParamStr(0));
end;

function sFormate_Version( Version: TVSFixedFileInfo): String;
begin
     Result
     :=
       Format( '%d.%d.%d.%d',
               [
               HiWord(Version.dwFileVersionMS),
               LoWord(Version.dwFileVersionMS),
               HiWord(Version.dwFileVersionLS),
               LoWord(Version.dwFileVersionLS)
               ]
               );
end;

function CompareVersions( _Fichier1, _Fichier2: String): Integer; //-1 si 1 < 2
                                                                  // 0 si 1 = 2
                                                                  //+1 si 1 > 2
var
   v1, v2: TVSFixedFileInfo;
   procedure TraiteNiveau( _dw1, _dw2: DWORD);
   var
      delta: Int64;
   begin
        delta:= _dw1 - _dw2;
        Result:= Sign( delta);
   end;
begin
     v1:= nGetVersionFichier( _Fichier1);
     v2:= nGetVersionFichier( _Fichier2);

     TraiteNiveau( v1.dwFileVersionMS, v2.dwFileVersionMS);
     if Result <> 0 then exit;

     TraiteNiveau( v1.dwFileVersionLS, v2.dwFileVersionLS);
end;
{$ELSE}

function GetVersionProgramme: String;
begin
     Result:= '';
end;

function GetVersionFichier( Fichier: String): String;
begin
     Result:= '';
end;

function CompareVersions( _Fichier1, _Fichier2: String): Integer; //-1 si 1 < 2
                                                                  // 0 si 1 = 2
                                                                  //+1 si 1 > 2
begin
     Result:= '';
end;
{$ENDIF}


end.
