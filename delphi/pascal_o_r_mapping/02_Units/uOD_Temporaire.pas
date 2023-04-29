﻿unit uOD_Temporaire;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    uOD_Forms,
  {$IFDEF MSWINDOWS}
  Windows, FMX.Dialogs, ShellAPI,
  {$ENDIF}
  SysUtils, Classes, System.IOUtils;

type
 TOD_Temporaire
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Répertoire temporaire de l'application
  public
    RepertoireTemp: String;
  //Répertoire temporaire du système
  public
    function RepertoireSysteme: String;
  //création d'un fichier OD_Temporaire
  public
    function Nouveau_Fichier  ( Prefixe: String): String;
    function Nouveau_Extension( Prefixe, Extension: String): String;
    function Nouveau_ODT( Prefixe: String): String;
    function Nouveau_ODS( Prefixe: String): String;
    function Nouveau_PDF( Prefixe: String): String;
  //création d'un répertoire OD_Temporaire
  public
    function Nouveau_Repertoire( Prefixe: String): String;
  //Existence d'un répertoire
  public
    function RepertoireExiste( _Repertoire: String): Boolean;
  //Destruction d'un répertoire
  private
    procedure TraiteLastError( Messag: String);
  public
    function DetruitRepertoire( _Repertoire: String): Boolean;
  end;

var
   OD_Temporaire: TOD_Temporaire;

function ShowURL( URL: String): Boolean;

implementation

function ShowURL( URL: String): Boolean;
begin
     {$IFDEF MSWINDOWS}
     //Result:= 32 < ShellExecute( 0, 'open', 'iexplore', PChar(URL),nil,SW_SHOWNORMAL);
     Result:= 32 < ShellExecute( 0, 'open', PChar(URL),nil,nil,SW_SHOWNORMAL);
     //ShowMessage( 'ShowURL('+URL+')');
     {$ENDIF}
end;

{ TOD_Temporaire }

constructor TOD_Temporaire.Create;
begin
     inherited;
     RepertoireTemp:= RepertoireSysteme;
end;

destructor TOD_Temporaire.Destroy; 
begin
     inherited;
end;


function TOD_Temporaire.RepertoireSysteme: String;
begin
     Result:= System.IOUtils.TPath.GetTempPath;
end;

function TOD_Temporaire.Nouveau_Fichier( Prefixe: String): String;
begin
     //à revoir : le préfixe n'est pas pris en compte
     Result:= System.IOUtils.TPath.GetTempFileName;
end;

function TOD_Temporaire.Nouveau_Repertoire( Prefixe: String): String;
begin
     Result:= Nouveau_Fichier( Prefixe);
     Result:= ChangeFileExt( Result, '.DIR');
     CreateDir( Result);
end;

function TOD_Temporaire.Nouveau_Extension( Prefixe, Extension: String): String;
begin
     Result:= Nouveau_Fichier( Prefixe);
     Result:= ChangeFileExt( Result, Extension);
end;

function TOD_Temporaire.Nouveau_ODT( Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.odt');
end;

function TOD_Temporaire.Nouveau_ODS( Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.ods');
end;

function TOD_Temporaire.Nouveau_PDF(Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.pdf');
end;

function TOD_Temporaire.RepertoireExiste( _Repertoire: String): Boolean;
begin
     {$I-}
     ChDir( _Repertoire);
     Result:= IOResult = 0;
     {$I+}
end;

procedure TOD_Temporaire.TraiteLastError( Messag: String);
var
   MessageSysteme: PChar;
begin
     {$IFDEF MSWINDOWS}
     FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                    FORMAT_MESSAGE_ALLOCATE_BUFFER,
                    nil, GetLastError,
                    0, @MessageSysteme, 0, nil);
     {$ELSE}
     MessageSysteme:= nil;
     {$ENDIF}
     uOD_Forms_ShowMessage( Messag + StrPas(MessageSysteme));
end;

function TOD_Temporaire.DetruitRepertoire( _Repertoire: String): Boolean;
var
   SearchRec: TSearchRec;
   Found: Integer;
   NomFichier: String;
   NomTMP: String;
begin
     Result:= not RepertoireExiste( _Repertoire);
     if Result then exit;

     Result:= True;
     Found:= FindFirst( IncludeTrailingPathDelimiter(_Repertoire)+'*.*', faAnyFile, SearchRec);
     while (Found = 0) and Result
     do
       begin
       NomFichier:= ExtractFileName(SearchRec.Name);
       if     (NomFichier <> '.')
          and (NomFichier <> '..')
       then
           if 0 <> faDirectory and SearchRec.Attr
           then
               DetruitRepertoire( SearchRec.Name)
           else
               DeleteFile( SearchRec.Name);
       Found := FindNext(SearchRec);
       end;
     FindClose( SearchRec);

     RemoveDir( _Repertoire);
     //if not RemoveDir( _Repertoire)
     //then
     //    TraiteLastError( 'Echec à la suppression du répertoire '+_Repertoire+#13#10);
     NomTMP:= ChangeFileExt( _Repertoire, '.tmp');
     DeleteFile( NomTMP);
end;

initialization
              OD_Temporaire:= TOD_Temporaire.Create;
finalization
              FreeAndNil( OD_Temporaire);
end.
