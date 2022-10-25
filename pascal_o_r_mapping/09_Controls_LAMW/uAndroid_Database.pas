unit uAndroid_Database;

{$mode delphi}

interface

uses
    uLog,
    uEXE_INI,
 Classes, SysUtils,Laz_And_Controls,AndroidWidget;

var
   DatabasesDir: String= '';
   DownloadsDir : String= '';

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
procedure uAndroid_Database_Recree_Base( _jF: jForm; _Filename: String);
procedure uAndroid_Database_from_Downloads( _jF: jForm; _Filename: String);

implementation

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
begin
     DatabasesDir:= _jF.GetEnvironmentDirectoryPath( dirDatabase);
     DownloadsDir:= _jF.GetEnvironmentDirectoryPath( dirDownloads);

     uEXE_INI_init_android( DatabasesDir);
end;

procedure uAndroid_Database_Recree_Base( _jF: jForm; _Filename: String);
begin
     uAndroid_Database_Traite_Environment( _jF);
     Log.PrintLn( 'uAndroid_Database_Recree_Base: Avant CopyFromAssetsToEnvironmentDir('+_Filename+', '+DatabasesDir+');');
     _jF.CopyFromAssetsToEnvironmentDir( _Filename, DatabasesDir);
end;

procedure uAndroid_Database_from_Downloads( _jF: jForm; _Filename: String);
var
   Source, Cible: String;
begin
     //iniconfig:= TInifile.Create(_jF.GetEnvironmentDirectoryPath(dirSdCard)+ '/' + 'AppConfig.txt');
     //_jF.GetEnvironmentDirectoryPath();
     uAndroid_Database_Traite_Environment( _jF);
     Source:= IncludeTrailingPathDelimiter( DownloadsDir)+_Filename;
     Cible := IncludeTrailingPathDelimiter( DatabasesDir)+_Filename;
     Log.PrintLn( 'uAndroid_Database_from_Downloads: Avant CopyFile('+Source+', '+Cible+');');
     _jF.CopyFile( Source, Cible);
end;

end.

