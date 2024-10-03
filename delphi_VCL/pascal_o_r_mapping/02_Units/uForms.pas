unit uForms;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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

//Duplication de uOD_Forms,
//pour ne pas bloquer le paquet pOOoDelphiReportEngine en mémoire dans Delphi
//dans la palette de composants ( empêche la recompilation )
{$IFDEF FPC}
{$DEFINE uForms_console}
{$ENDIF}

interface

uses
    uClean,
    uBatpro_StringList;

type
 TuForms_Contexte
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion de chargement de paquets
  private
    function Paquet_Trouve( _NomPaquet: String): Boolean;
    procedure Ajoute_Paquet( _NomPaquet: String);
  public
    slPaquets: TBatpro_StringList;
    function Paquet_Charge( _NomPaquet: String): Boolean;
  end;

function uForms_EXE_Name: String;

var
   uForms_pBatpro_Login_Path: String = '';
   uForms_pBatpro_EXE_ou_DLL_Path: String = '';

procedure uForms_ProcessMessages;

procedure uForms_Terminate;
function  uForms_Terminated: Boolean;

procedure uForms_Set_Hint( _S: String);

function  uForms_Title: string;

procedure uForms_CancelHint;

procedure uForms_ShowMessage( _S: String);

procedure uForms_MessageBox( _Caption, _Prompt: String);
function uForms_Message_Yes( _Caption, _Prompt: String; _Default_No: Boolean= False): Boolean;

function uForms_Charge_Paquet( NomPaquet: String): Boolean;

function uForms_Variables_d_environnement: String;

function uForms_Lance_Programme( EXE_FileName: String; Parametres: String = ''): Boolean;

implementation

{$IFDEF uForms_console}
{$ELSE}
uses
    Windows, SysUtils,VCL.Forms, VCL.Dialogs;
{$ENDIF}

var
   uForms_Contexte: TuForms_Contexte= nil;

{ TuForms_Contexte }

constructor TuForms_Contexte.Create;
begin
     //Gestion de chargement de paquets
     slPaquets:= TBatpro_StringList.Create;
end;

destructor TuForms_Contexte.Destroy;
begin
     //Gestion de chargement de paquets
     Free_nil( slPaquets);

     inherited;
end;

function TuForms_Contexte.Paquet_Trouve( _NomPaquet: String): Boolean;
begin
     Result:= -1 <> slPaquets.IndexOf( _NomPaquet);
end;

procedure TuForms_Contexte.Ajoute_Paquet(_NomPaquet: String);
begin
     if Paquet_Trouve( _NomPaquet) then exit;
     slPaquets.Add( _NomPaquet);
end;

function TuForms_Contexte.Paquet_Charge( _NomPaquet: String): Boolean;
begin
     Result:= Paquet_Trouve( _NomPaquet);
     if Result then exit;
end;

{$IFDEF uForms_console}
procedure uForms_ProcessMessages;
begin

end;
procedure uForms_Terminate;
begin
     Halt;
end;

function  uForms_Terminated: Boolean;
begin
     Result:= False;
end;

procedure uForms_Set_Hint( _S: String);
begin
     WriteLn( 'uForms_Set_Hint: '+_S);
end;

function  uForms_Title: string;
begin
     Result:= uForms_EXE_Name;
end;

procedure uForms_CancelHint;
begin
     WriteLn( 'uForms_CancelHint');
end;

procedure uForms_ShowMessage( _S: String);
begin
     WriteLn( 'uForms_ShowMessage: ');
     WriteLn( _S);
     WriteLn;
end;

procedure uForms_MessageBox( _Caption, _Prompt: String);
begin
     WriteLn( 'uForms_MessageBox: ');
     WriteLn( _Caption);
     WriteLn( _Prompt);
     WriteLn;
end;

function uForms_Message_Yes( _Caption, _Prompt: String; _Default_No: Boolean= False): Boolean;
begin
     WriteLn( 'uForms_Message_Yes: ');
     WriteLn( _Caption);
     WriteLn( _Prompt);
     WriteLn;
     Result:= false;
end;

function uForms_Charge_Paquet( NomPaquet: String): Boolean;
begin
     Result:= True;
end;

function uForms_Variables_d_environnement: String;
begin
     Result:= '';
end;

function uForms_Lance_Programme( EXE_FileName: String; Parametres: String = ''): Boolean;
begin
     Result:= True;
end;

{$ELSE}
procedure uForms_ProcessMessages;
begin
     Application.ProcessMessages;
end;

procedure uForms_Terminate;
begin
     Application.Terminate;
end;

function  uForms_Terminated: Boolean;
begin
     Result:= Application.Terminated;
end;

procedure uForms_Set_Hint( _S: String);
begin
     Application.Hint:= _S;
end;

function  uForms_Title: string;
begin
     Result:= Application.Title;
end;

procedure uForms_CancelHint;
begin
     Application.CancelHint;
end;

procedure uForms_ShowMessage( _S: String);
begin
     ShowMessage( _S);
end;

procedure uForms_MessageBox( _Caption, _Prompt: String);
begin
     MessageBox( GetFocus,
                 PChar( _Prompt),
                 PChar( _Caption),
                 MB_OK);
end;
function uForms_Message_Yes( _Caption, _Prompt: String; _Default_No: Boolean= False): Boolean;
var
   Flags: Longint;
begin
     Flags:= MB_YESNO or MB_ICONQUESTION;
     if _Default_No
     then
         Flags:= Flags or MB_DEFBUTTON2;
     Result
     :=
       IDYES
       =
       MessageBox( GetFocus, PChar( _Prompt), PChar( _Caption), Flags);
end;

function uForms_Charge_Paquet( NomPaquet: String): Boolean;
var
   NomFichierPackage: String;
   FileFound: Boolean;
begin
     Result:= uForms_Contexte.Paquet_Charge( NomPaquet);
     if  Result then exit;

     NomFichierPackage:= ExtractFilePath( ParamStr(0)) + NomPaquet + '.bpl';
     FileFound:= FileExists( NomFichierPackage);
     if not FileFound
     then
         begin
         if uForms_pBatpro_Login_Path <> ''
         then
             begin
             NomFichierPackage:=   uForms_pBatpro_Login_Path
                                 + ExtractFileName( NomFichierPackage);
             FileFound:= FileExists( NomFichierPackage);
             if     FileFound
                and (0= Pos('C:\2_source\', ParamStr(0)))//= si on n'est pas sur la machine de développement
             then
                 uForms_ShowMessage( 'La fonctionnalité (use case) a été trouvée '+
                                    'dans le répertoire du paquet pBatpro_Login:'+#13#10+
                                    NomFichierPackage);
             end;
         end;
     if not FileFound
     then
         begin
         if uForms_pBatpro_EXE_ou_DLL_Path <> ''
         then
             begin
             NomFichierPackage:=   uForms_pBatpro_EXE_ou_DLL_Path
                                 + ExtractFileName( NomFichierPackage);
             FileFound:= FileExists( NomFichierPackage);
             if     FileFound
                and (0= Pos('C:\2_source\', ParamStr(0)))//= si on n'est pas sur la machine de développement
             then
                 uForms_ShowMessage( 'La fonctionnalité (use case) a été trouvée '+
                              'dans le répertoire de la DLL pour le GDC:'+#13#10+
                              NomFichierPackage);
             end;
         end;
     Result:= FileFound;
     if FileFound
     then
         Result:= LoadPackage( NomFichierPackage) <> 0;
end;

function uForms_Variables_d_environnement: String;
var
   ES: PChar;
   I: Integer;
   C: Char;
begin
     Result:= 'Variables d''environnement:'#13#10;

     ES:= GetEnvironmentStrings;
     if ES = nil then exit;
     try
        I:= 0;
        repeat
              C:= ES[I];
              if C = #0
              then
                  begin
                  Result:= Result + #13#10;
                  if ES[I+1] = #0 then exit;
                  end
              else
                  Result:= Result + C;
              Inc( I);
        until False;
     finally
            FreeEnvironmentStrings( ES);
            end;
end;

function uForms_Lance_Programme( EXE_FileName: String; Parametres: String = ''): Boolean;
var
   si: TStartupInfo;
   pi: TProcessInformation;
begin
     FillChar( si, SizeOf( si), 0);
     si.cb:= SizeOf( si);
     Parametres:= '"'+EXE_FileName+'" '+Parametres;
     Result:=
     CreateProcess( PChar( EXE_FileName), nil, nil, nil, False,
                            0, nil, nil, si, pi);
     if Result
     then
         WaitForInputIdle( pi.hProcess, INFINITE);
end;

{$ENDIF}

function uForms_EXE_Name: String;
begin
     Result:= uClean_EXE_Name;
end;

initialization
              uForms_Contexte:= TuForms_Contexte.Create;
finalization
              Free_nil( uForms_Contexte);
end.

