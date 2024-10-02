unit uEXE_INI_Global;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uForms,
    uEXE_INI,
 Classes, SysUtils;

function EXE_INI_Global: TEXE_INIFile;

procedure uEXE_INI_Global_init_android( _EnvironmentDirPath: String);

implementation

var
   FEXE_INI_Global: TEXE_INIFile= nil;
   EXE_INI_Global_Nom: String = '';

function EXE_INI_Global: TEXE_INIFile; begin EXE_INI_interne( Result, FEXE_INI_Global, EXE_INI_Global_Nom); end;

procedure uEXE_INI_Global_init;
begin
     if uEXE_INI_Special
     then
         EXE_INI_Global_Nom:= EXE_INI_Nom
     else
         EXE_INI_Global_Nom:= EXE_INI.Chemin_Global+'etc'+PathDelim+'_Configuration.ini';

     //uClean_Log( 'uEXE_INI initialization: EXE_INI_Global Nom = >'+EXE_INI_Global_Nom+'<');
end;

procedure uEXE_INI_Global_init_android( _EnvironmentDirPath: String);
begin
     EXE_INI_Global_Nom:= IncludeTrailingPathDelimiter( _EnvironmentDirPath)+'_Configuration.ini';
end;
initialization
              {$ifndef android}
              uEXE_INI_Global_init;
              {$endif}
finalization
            Free_nil( FEXE_INI_Global);
end.

