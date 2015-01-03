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
    {$IFNDEF FPC}
    uAide,
    {$ENDIF}
    uNetWork,
    SysUtils, Classes;

type

 { TLog }

 TLog
 =
  class
  private
    NomFichier: String;
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
    procedure Print( S: String);
    procedure PrintLn( S: String);
    procedure Affiche;
  end;

function Log: TLog;

implementation

var
   FLog: TLog= nil;

function Log: TLog;
begin
     if FLog = nil
     then
         FLog:= TLog.Create;
     Result:= FLog;
end;

{ TLog }

constructor TLog.Create;
begin
     DateDebut:= Now;
     Date_Hier:= DateDebut-1;
     Repertoire:= Repertoire_from_Date( DateDebut);
     NomFichier:= Repertoire +Nom;
     ForceDirectories( Repertoire);
end;

destructor TLog.Destroy;
begin
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

procedure TLog.Print(S: String);
var
   T: Text;
begin
     try
        AssignFile( T, NomFichier);
        if FileExists( NomFichier)
        then
            Append( T)
        else
            ReWrite( T);

        WriteLn( T);
        WriteLn( T);
        WriteLn( T, FormatDateTime('dddddd","tt', Now)+' ###########################');
        WriteLn( T, S);

        Flush( T);
     finally
            CloseFile( T);
            end;
end;

procedure TLog.PrintLn(S: String);
var
   T: Text;
begin
     try
        AssignFile( T, NomFichier);
        if FileExists( NomFichier)
        then
            Append( T)
        else
            ReWrite( T);

        WriteLn( T, '>',S);
        {$IFDEF LINUX}
        WriteLn( S);
        {$ENDIF}

        Flush( T);
     finally
            CloseFile( T);
            end;
end;


procedure TLog.Affiche;
begin
     {$IFNDEF FPC}
     ShowURL( NomFichier);
     {$ENDIF}
end;

initialization
finalization
              Free_nil( FLog);
end.
