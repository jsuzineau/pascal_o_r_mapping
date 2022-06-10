unit uAndroid_Database;

{$mode delphi}

interface

uses
    uLog,
    uEXE_INI,
 Classes, SysUtils,Laz_And_Controls,AndroidWidget;

var
   EnvironmentDirPath: String= '';

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
procedure uAndroid_Database_Recree_Base( _jF: jForm; _Filename: String);

implementation

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
begin
     EnvironmentDirPath:= _jF.GetEnvironmentDirectoryPath( dirDatabase);
     uEXE_INI_init_android( EnvironmentDirPath);
end;

procedure uAndroid_Database_Recree_Base( _jF: jForm; _Filename: String);
begin
     uAndroid_Database_Traite_Environment( _jF);
     Log.PrintLn( 'uAndroid_Database_Assure_Copie: Avant CopyFromAssetsToEnvironmentDir('+_Filename+', '+EnvironmentDirPath+');');
     _jF.CopyFromAssetsToEnvironmentDir( _Filename, EnvironmentDirPath);
end;

end.

