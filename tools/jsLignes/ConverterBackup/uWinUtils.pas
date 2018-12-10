unit uWinUtils;

// Copyright (C) Jean SUZINEAU 1997, 2000

interface

uses
    Windows;

procedure TraiteLastError( Messag: String);

function SelectionnneRepertoire( Parent: HWnd;
                                 Titre: String; var Path: String): Boolean;

implementation

uses
    Dialogs, SysUtils,
    ShlObj, ActiveX;

procedure TraiteLastError( Messag: String);
var
   MessageSysteme: PChar;
begin
     FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                    FORMAT_MESSAGE_ALLOCATE_BUFFER,
                    nil, GetLastError,
                    0, @MessageSysteme, 0, nil);
     ShowMessage( Messag + StrPas(MessageSysteme));
end;

(*
function GetIILfromPath( Parent: HWnd; Path: string): PItemIDList;
var
   DesktopFolder: IShellFolder;
   olePath: array[0..MAX_PATH] of WideChar;
   chEaten: ULONG;
   dwAttributes: ULONG;
begin
     if SUCCEEDED( SHGetDesktopFolder( DesktopFolder))
     then
         begin
         MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, PChar(Path), -1,
                              olePath, MAX_PATH);
         if Failed(
              DesktopFolder.ParseDisplayName( Parent,nil,olePath,
                                              chEaten,Result,dwAttributes))
         then
             Result:= nil;
         end;
end;
*)
(*
int CALLBACK BrowseCallbackProc(
    HWND hwnd,
    UINT uMsg,
    LPARAM lParam,
    LPARAM lpData
    );
*)
//function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
function BrowseCallbackProc( Wnd: HWND; uMsg: UINT; lPARAM: LPARAM;
                             lpData: LPARAM): Integer; stdcall;
begin
     Result:= 0;
     if uMsg = BFFM_INITIALIZED
     then
         PostMessage( Wnd, BFFM_SETSELECTION, 1, lpData);
end;

function SelectionnneRepertoire( Parent: HWnd; Titre: String; var Path: String): Boolean;
var
   bi: TBrowseInfoA;
   pIIL: PItemIDList;
   malloc: IMalloc;
   Display: PChar;
begin
     Result:= False;
     SHGetMalloc( malloc);
     Display:= malloc.Alloc( MAX_PATH+1);
       StrPCopy( Display, Path);
       bi.hwndOwner:= Parent;
       bi.pidlRoot:= nil;//GetIILfromPath(Parent, Path);
       bi.pszDisplayName:= Display;
       bi.lpszTitle:= PChar(Titre);
       bi.ulFlags:= 0;//$0010;//BIF_EDITBOX;
       bi.lpfn:= BrowseCallbackProc;
       bi.lParam:= Integer( Display);
       bi.iImage:=0;
       pIIL:= SHBrowseForFolder( bi);
       if pIIL <> nil
       then
           begin
           if SHGetPathFromIDList( pIIL, Display)
           then
               begin
               Path:= Display;
               Result:= True;
               end;
           end;
     malloc.Free( Display);
end;


end.



