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
const
     permission_READ_EXTERNAL_STORAGE_request_code=2001;//valeur arbitraire pour test dans évènement
     permission_WRITE_EXTERNAL_STORAGE_request_code=2002;//valeur arbitraire pour test dans évènement

procedure uAndroid_Database_require_permission_READ_EXTERNAL_STORAGE( _jF: jForm);
procedure uAndroid_Database_require_permission_WRITE_EXTERNAL_STORAGE( _jF: jForm);

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
procedure uAndroid_Database_from_Assets( _jF: jForm; _Source, _Cible: String);
procedure uAndroid_Database_from_Downloads( _jF: jForm; _Source, _Cible: String);
procedure uAndroid_Database_to_Downloads( _jF: jForm; _Source, _Cible: String);

implementation

procedure uAndroid_Database_Traite_Environment( _jF: jForm);
begin
     DatabasesDir:= _jF.GetEnvironmentDirectoryPath( dirDatabase);
     DownloadsDir:= _jF.GetEnvironmentDirectoryPath( dirDownloads);
     Log.PrintLn( 'uAndroid_Database_Traite_Environment: DatabasesDir:'+DatabasesDir+', DownloadsDir: '+DownloadsDir);

     uEXE_INI_init_android( DatabasesDir);
end;

procedure uAndroid_Database_from_Assets( _jF: jForm; _Source, _Cible: String);
begin
     uAndroid_Database_Traite_Environment( _jF);
     Log.PrintLn( 'uAndroid_Database_from_Assets: Avant CopyFromAssetsToEnvironmentDir('+_Source+', '+_Cible+', '+DatabasesDir+');');
     _jF.CopyFromAssetsToEnvironmentDir( _Source, DatabasesDir);
     _jF.CopyFile( IncludeTrailingPathDelimiter( DatabasesDir)+_Source,
                   IncludeTrailingPathDelimiter( DatabasesDir)+_Cible );
     _jF.DeleteFile(IncludeTrailingPathDelimiter( DatabasesDir)+_Source);
end;

procedure uAndroid_Database_require_permission_READ_EXTERNAL_STORAGE( _jF: jForm);
begin
     //if not IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE')
     if not _jF.IsRuntimePermissionGranted('android.permission.READ_EXTERNAL_STORAGE')
     then
         _jF.RequestRuntimePermission( 'android.permission.READ_EXTERNAL_STORAGE',
                                       permission_READ_EXTERNAL_STORAGE_request_code)
     else
         Log.PrintLn( 'uAndroid_Database_from_Downloads: permission android.permission.READ_EXTERNAL_STORAGE OK');
end;
procedure uAndroid_Database_require_permission_WRITE_EXTERNAL_STORAGE( _jF: jForm);
begin
     if not _jF.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE')
     then
         _jF.RequestRuntimePermission( 'android.permission.WRITE_EXTERNAL_STORAGE',
                                       permission_WRITE_EXTERNAL_STORAGE_request_code)
     else
         Log.PrintLn( 'uAndroid_Database_from_Downloads: permission android.permission.WRITE_EXTERNAL_STORAGE OK');
end;

procedure uAndroid_Database_from_Downloads( _jF: jForm; _Source, _Cible: String);
var
   Source, Cible: String;
begin
     uAndroid_Database_require_permission_READ_EXTERNAL_STORAGE( _jF);

     //iniconfig:= TInifile.Create(_jF.GetEnvironmentDirectoryPath(dirSdCard)+ '/' + 'AppConfig.txt');
     //_jF.GetEnvironmentDirectoryPath();
     uAndroid_Database_Traite_Environment( _jF);
     Source:= IncludeTrailingPathDelimiter( DownloadsDir)+_Source;
     Cible := IncludeTrailingPathDelimiter( DatabasesDir)+_Cible;
     Log.PrintLn( 'uAndroid_Database_from_Downloads: Avant CopyFile('+Source+', '+Cible+');');
     _jF.CopyFile( Source, Cible);
end;

procedure uAndroid_Database_to_Downloads( _jF: jForm; _Source, _Cible: String);
var
   Source, Cible: String;
   procedure Calcule_Cible;
   var
      I: Integer;
   begin
        I:= 1;
        Cible := IncludeTrailingPathDelimiter( DownloadsDir)+_Cible;
        while FileExists( Cible)
        do
          begin
          Cible
          :=
              IncludeTrailingPathDelimiter( DownloadsDir)
            + ChangeFileExt( _Cible, '')+'('+IntToStr(I)+').'+ExtractFileExt(_Cible);
          Inc( I);
          end;
   end;

begin
     uAndroid_Database_require_permission_WRITE_EXTERNAL_STORAGE( _jF);

     uAndroid_Database_Traite_Environment( _jF);
     Source:= IncludeTrailingPathDelimiter( DatabasesDir)+_Source;
     Calcule_Cible;
     Log.PrintLn( 'uAndroid_Database_from_Downloads: Avant CopyFile('+Source+', '+Cible+');');
     _jF.CopyFile( Source, Cible);
end;

end.

