unit uAndroid_Database;

{$mode delphi}

interface

uses
    uLog,
    uEXE_INI,
 Classes, SysUtils,Laz_And_Controls,AndroidWidget;

var
   Filename          : String= 'jsWorks.sqlite';
   EnvironmentDirPath: String= '';

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
procedure uAndroid_Database_Recree_Base( _jF: jForm);

implementation

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
begin
     EnvironmentDirPath:= _jF.GetEnvironmentDirectoryPath( dirDatabase);
     uEXE_INI_init_android( EnvironmentDirPath);
end;

procedure uAndroid_Database_Recree_Base( _jF: jForm);
begin
     uAndroid_Database_Traite_Environment( _jF);
     Log.PrintLn( 'uAndroid_Database_Assure_Copie: Avant CopyFromAssetsToEnvironmentDir('+Filename+', '+EnvironmentDirPath+');');
     _jF.CopyFromAssetsToEnvironmentDir(Filename, EnvironmentDirPath);
end;

end.

