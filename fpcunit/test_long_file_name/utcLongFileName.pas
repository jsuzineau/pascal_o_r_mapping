unit utcLongFileName;

{$mode objfpc}{$H+}

interface

uses

 Classes, SysUtils, fpcunit, testutils, testregistry, Windows, dos;

type

 TtcLongFileName= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;
 end;

implementation

function sGetLastError: String;
var
   MessageSysteme: PChar;
begin
FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                    FORMAT_MESSAGE_ALLOCATE_BUFFER,
                    nil, GetLastError,
                    0, @MessageSysteme, 0, nil);
     Result:= StrPas(MessageSysteme);
end;

procedure String_to_File( _FileName: String; _S: String);
var
   F: File;
begin
     if '' = _S then exit;

     AssignFile( F, _FileName);
     try
        ReWrite( F, 1);
        BlockWrite( F, _S[1], Length( _S));
     finally
            CloseFile( F);
            end;
end;

(*  ne marche pas
function GetLongPathName(ShortPathName: PChar; LongPathName: PChar;
    cchBuffer: Integer): Integer; stdcall; external 'kernel32.dll' name 'GetLongPathNameW';

function ExtractLongPathName(const ShortName: string): string;
begin
     SetLength(Result, GetLongPathName(PChar(ShortName), nil, 0));
     if 0 = Length(Result)
     then
         begin
         Result:= sGetLastError;
         exit;
         end;
     SetLength(Result, GetLongPathName(PChar(ShortName), PChar(Result), length(Result)));
end;
*)
procedure TtcLongFileName.TestHookUp;
var
   Court: String;
   Long: ShortString;
begin
     Court:= Sysutils.GetTempFileName( GetTempDir,'truc');
     String_to_File( Court, 'test');
     if not FileExists( Court)
     then
         Fail( 'Fichier temporaire non créé '+Court);

     //Court:= ExcludeTrailingPathDelimiter(GetTempDir);

     //Long:= ExtractLongPathName( Court);
     Long:= Court;
     if not Dos.GetLongName( Long)
     then
         Fail( 'Echec de Dos.GetLongName: '+sGetLastError);

     //if Length( Court) > Length( Long)
     //then
         Fail(  'Court: '+Court+#13#10
               +'Long : '+Long);
end;

procedure TtcLongFileName.SetUp;
begin

end;

procedure TtcLongFileName.TearDown;
begin

end;

initialization

 RegisterTest(TtcLongFileName);
end.

