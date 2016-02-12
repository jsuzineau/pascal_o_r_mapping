unit utcLongFileName;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, fpcunit, testutils, testregistry, Windows, LazUTF8,
 FileUtil;

type

 { TtcLongFileName }

 TtcLongFileName= class(TTestCase)
 protected
  Court: String;
  Long : String;
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure Test_FPC_GetTempDir;
  procedure Test_windows_GetTempPathW;
  procedure Test_GetLongName;
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

function GetLongPathNameW(ShortPathName: PWideChar; LongPathName: PWideChar;
    cchBuffer: Integer): Integer; stdcall; external 'kernel32.dll' name 'GetLongPathNameW';

function ExtractLongPathName(const ShortName: WideString): string;
var
   ws: WideString;
begin
     SetLength( ws, GetLongPathNameW( PWideChar(ShortName), nil, 0));
     if 0 = Length(ws)
     then
         begin
         Result:= 'windows.GetLongPathNameW: '+sGetLastError;
         exit;
         end;
     SetLength(ws, GetLongPathNameW( PWideChar(ShortName), PWideChar(ws), Length(ws)));
     Result:= UTF16ToUTF8( ws);
end;

function ExtractTempDir: string;
var
   ws: WideString;
begin
     SetLength( ws, windows.GetTempPathW( 0, nil));
     if 0 = Length(ws)
     then
         begin
         Result:= 'Echec de windows.GetTempPathW: '+sGetLastError;
         exit;
         end;
     SetLength(ws, GetTempPathW( Length(ws), PWideChar(ws)));
     Result:= UTF16ToUTF8( ws);
end;

{ change to long filename if successful DOS call PM }
function GetLongName(var p : String) : boolean;

var
  SR: TSearchRec;
  FullFN, FinalFN, TestFN: string;
  Found: boolean;
  SPos: byte;
begin
     if Length (P) = 0
     then
         GetLongName := false
     else
         begin
         FullFN := ExpandFileName (P); (* Needed to be done at the beginning to get proper case for all parts *)
         SPos := 1;
         if (Length (FullFN) > 2)
         then
             if (FullFN [2] = DriveSeparator)
             then
                 SPos := 4
             else
                 if (FullFN [1] = DirectorySeparator) and (FullFN [2] = DirectorySeparator)
                 then
                     begin
                     SPos := 3;
                     while (Length (FullFN) > SPos) and (FullFN [SPos] <> DirectorySeparator)
                     do
                       Inc (SPos);
                     if SPos >= Length (FullFN)
                     then
                         SPos := 1
                     else
                         begin
                         Inc (SPos);
                         while (Length (FullFN) >= SPos) and (FullFN [SPos] <> DirectorySeparator)
                         do
                           Inc (SPos);
                         if SPos <= Length (FullFN)
                         then
                             Inc (SPos);
                         end;
                     end;
         FinalFN := Copy (FullFN, 1, Pred (SPos));
         Delete (FullFN, 1, Pred (SPos));
         Found := true;
         while (FullFN <> '') and Found
         do
           begin
           SPos := Pos (DirectorySeparator, FullFN);
           TestFN := Copy (FullFN, 1, Pred (SPos));
           Delete (FullFN, 1, Pred (SPos));
           if 0 <> SysUtils.FindFirst (FinalFN + TestFN, faAnyFile, SR)
           then
               Found := false
           else
               begin
               FinalFN := FinalFN + SR.Name;
               if (FullFN <> '') and (FullFN [1] = DirectorySeparator)
               then
                   begin
                   FinalFN := FinalFN + DirectorySeparator;
                   Delete (FullFN, 1, 1);
                   end;
               end;
           SysUtils.FindClose (SR);
           end;
         if Found
         then
             begin
             GetLongName := true;
             P := FinalFN;
             end
         else
             GetLongName := false
         end;
end;

procedure TtcLongFileName.Test_FPC_GetTempDir;
begin
     Fail( 'FPC GetTempDir: '+GetTempDir);
end;

procedure TtcLongFileName.Test_windows_GetTempPathW;
begin
     Fail( 'windows.GetTempPathW: '+ExtractTempDir);
end;

procedure TtcLongFileName.SetUp;
begin
     //Court:= Sysutils.GetTempFileName( GetTempDir,'truc');
     Court:= Sysutils.GetTempFileName( ExtractTempDir,'truc');
     String_to_File( Court, 'test');
     if not FileExists( Court)
     then
         Fail( 'Fichier temporaire non créé '+Court);
end;

procedure TtcLongFileName.Test_GetLongName;
begin
     Long:= Court;
     if not GetLongName( Long)
     then
         Fail( 'Echec de GetLongName: '+sGetLastError);

     Fail(  'GetLongName basé sur FindFirst : '#13#10
           +'Court: '+Court+#13#10
           +'Long : '+Long);
end;

procedure TtcLongFileName.TestHookUp;
begin
     Long:= ExtractLongPathName( Court);

     Fail(  'windows.GetLongPathNameW : '#13#10
           +'Court: '+Court+#13#10
           +'Long : '+Long);
end;

procedure TtcLongFileName.TearDown;
begin

end;

initialization

 RegisterTest(TtcLongFileName);
end.

