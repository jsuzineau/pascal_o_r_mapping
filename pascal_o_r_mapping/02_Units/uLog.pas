unit uLog;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uBatpro_StringList,
    uClean,
    uForms,
    {$IFNDEF FPC}
    uAide,
    {$ENDIF}
    uNetWork,
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF LCL_FULLVERSION}
  LazUTF8, LCLIntf,
  {$ENDIF}
  SysUtils, Classes, syncobjs;

type

 { TLog }

 TLog
 =
  class
  private
    cs: TCriticalSection;
    NomFichier: String;
    function Ouvre( var _T: Text): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  public
    DateDebut: TDateTime;
    Date_Hier: TDateTime;
    Repertoire: String;
    function Nom: String;
    function  Repertoire_from_Date( _Date: TDateTime): String;
    function  Repertoire_Hier: String;
    procedure NomFichier_from_Repertoire;
    procedure Print( S: String);
    procedure PrintLn( S: String);
    procedure Affiche;
  end;

function Log: TLog;

function sGetLastError: String;

procedure TraiteLastError( Messag: String);

function Variables_d_environnement: String;

implementation

function sGetLastError: String;
{$IFDEF WINDOWS}
var
   MessageSysteme: PChar;
begin
     FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                         FORMAT_MESSAGE_ALLOCATE_BUFFER,
                         nil, GetLastError,
                         0, @MessageSysteme, 0, nil);
     Result:= StrPas(MessageSysteme);
end;
{$ELSE}
begin
     Result:= 'fonction uLog.sGetLastError non implémentée en dehors de Windows';
end;
{$ENDIF}

procedure TraiteLastError( Messag: String);
begin
     uForms_ShowMessage( Messag + sGetLastError);
end;

function Variables_d_environnement: String;
var
   I: Integer;
   sl: TStringList;
begin
     Result:= 'Variables d''environnement:'#13#10;
     sl:= TStringList.Create;
     try
       for I := 0 to GetEnvironmentVariableCount - 1
       do
         sl.Add( GetEnvironmentString(I));

       Result:= Result+sl.Text;
     finally
            FreeAndNil( sl);
            end;
end;

{ TLog }

var
   FLog: TLog= nil;

function Log: TLog;
begin
     if FLog = nil
     then
         FLog:= TLog.Create;
     Result:= FLog;
end;

constructor TLog.Create;
begin
     cs:= TCriticalSection.Create;

     DateDebut:= Now;
     Date_Hier:= DateDebut-1;
     Repertoire:= Repertoire_from_Date( DateDebut);
     ForceDirectories( Repertoire);

     NomFichier_from_Repertoire;
end;

destructor TLog.Destroy;
begin
     FreeAndNil( cs);
     inherited;
end;

function TLog.Repertoire_from_Date( _Date: TDateTime): String;
begin
     Result:= uClean_Log_Repertoire_from_Date( _Date);
end;

function TLog.Repertoire_Hier: String;
begin
     Result:= Repertoire_from_Date( Date_Hier);
end;

function TLog.Nom: String;
begin
     Result
     :=
       ChangeFileExt( ExtractFileName(uClean_EXE_Name),
                      '.'+uClean_NetWork_Nom_Hote+'.txt')
end;

procedure TLog.NomFichier_from_Repertoire;
begin
     NomFichier:= Repertoire +Nom;
end;

function TLog.Ouvre(var _T: Text): Boolean;
begin
     Result:= True;

     try
        AssignFile( _T, NomFichier);
        if FileExists( NomFichier)
        then
            Append( _T)
        else
            ReWrite( _T);
     except
           on E: Exception
           do
             begin
             Result:= False;
             {$IFDEF LINUX}
             WriteLn( UTF8ToConsole('Vérifiez peut-être les droits d''acccés'));
             WriteLn( UTF8ToConsole('Echec de l''ouverture du log: '+NomFichier));
             WriteLn( E.Message);
             {$ENDIF}
             {$IFDEF android}
             WriteLn( UTF8ToConsole('Vérifiez peut-être les droits d''acccés'));
             WriteLn( UTF8ToConsole('Echec de l''ouverture du log: '+NomFichier));
             WriteLn( E.Message);
             {$ENDIF}
             end;
           end;
end;

procedure TLog.Print(S: String);
   procedure Cas_Normal;
			var
			   T: Text;
   begin
        if not Ouvre( T) then exit;
        try
           WriteLn( T);
           WriteLn( T);
           WriteLn( T, FormatDateTime('dddddd","tt', Now)+' ###########################');
           WriteLn( T, S);

           Flush( T);
        finally
               CloseFile( T);
               end;
   end;
begin
     {$IFDEF android}
     WriteLn( UTF8ToConsole( S));
     exit;
     {$ENDIF}
     {$IFDEF LINUX}
     //WriteLn( UTF8ToConsole( S));
     {$ENDIF}

     cs.Acquire;
     try
        Cas_Normal;
     finally
            cs.Release;
            end;
end;

procedure TLog.PrintLn(S: String);
   procedure Cas_Normal;
			var
			   T: Text;
   begin
        if not Ouvre( T) then exit;
        try
           WriteLn( T, '>',S);
           Flush( T);
        finally
               CloseFile( T);
               end;
   end;
begin
     {$IFDEF android}
     WriteLn( UTF8ToConsole(S));
     exit;
     {$ENDIF}
     {$IFDEF LINUX}
     //WriteLn( UTF8ToConsole(S));
     {$ENDIF}
     cs.Acquire;
     try
        Cas_Normal;
     finally
            cs.Release;
            end;
end;


procedure TLog.Affiche;
begin
     {$IFDEF FPC}
       {$IFDEF LCL_FULLVERSION}
         OpenDocument( NomFichier);
       {$ELSE}
         //rien
       {$ENDIF}
     {$ELSE}
       ShowURL( NomFichier);
     {$ENDIF}
end;

initialization
finalization
              Free_nil( FLog);
end.
