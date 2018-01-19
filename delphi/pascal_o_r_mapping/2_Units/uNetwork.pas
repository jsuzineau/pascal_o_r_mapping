unit uNetwork;
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

interface

uses
    uForms,
    u_sys_,
    u_ini_,
    uBatpro_StringList,
    uuStrings,
    uClean,
    uEXE_INI,
    {$IFNDEF ANDROID}
    Windows, WinSock,
    {$ENDIF}
    SysUtils, Classes, IniFiles, Math, FMX.Dialogs;

type
 TTypeNetwork= (tn_application, tn_informix, tn_mysql);
 TNetwork
 =
  class
  //Gestion du cycle de vide
  public
    constructor Create( _TypeNetwork: TTypeNetwork= tn_application);
    destructor  Destroy; override;
  //Type d'instance de TNetwork
  public
    TypeNetwork: TTypeNetwork;
  //Fichier INI
  public
    INI: TINIFile;
  //Gestion de la liste de ports pour un hôte
  public
    slPorts_Instances: TBatpro_StringList;
    procedure Set_Ports_Instances;
    procedure Get_Ports_Instances;
  //Gestion d'un port donné
  public
    procedure AddPort   ( Port: String);
    procedure RemovePort( Port: String);
  //Hôte
  private
    function Get_Nom_Hote: String;
    procedure RemovePort_Interne(Port: String);
  public
    Nom_Hote: String;

  {$IFNDEF ANDROID}
  //Adresse IP principale
  public
    function IP_Principale: TInAddr;
  {$ENDIF}
  //Port de la machine courante
  public
    function GetPort: String;
  //Méthodes pour l'arreteur
  public
    procedure Get_Instances( _sl: TBatpro_StringList);
    procedure Remove_Instance( _Instance: String);
    procedure Efface;
  end;

var
   Network: TNetwork= nil;
   uNetWork_NomExecutable: String= '';
   
implementation

const
     uNetWork_inis_Ports_Instances= 'Ports des instances en cours d''exécution';

constructor TNetwork.Create( _TypeNetwork: TTypeNetwork);
var
   Nom: String;
begin
     TypeNetwork:= _TypeNetwork;
     Nom_Hote:= Get_Nom_Hote;
     uClean_NetWork_Nom_Hote:= Nom_Hote;
     Cree_EXE_INI_Poste;
     Nom:= ExtractFilePath( ParamStr(0))+'etc\_Configuration.ini';
     INI:= TIniFile.Create( Nom);
     slPorts_Instances:= TBatpro_StringList.Create;
end;

destructor TNetwork.Destroy;
begin
     Free_nil( slPorts_Instances);
     Free_nil( INI);
     inherited;
end;

function TNetWork.Get_Nom_Hote: String;
{$IFDEF ANDROID}
begin
     Result:= 'android';
end;
{$ELSE}
var
   hostname: array[0..2048] of AnsiChar;
   MessageSysteme: PChar;
begin
     if 0 <> gethostname( hostname, sizeof(hostname)-1)
     then
         begin
         FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                        FORMAT_MESSAGE_ALLOCATE_BUFFER,
                        nil, WSAGetLastError,
                        0, @MessageSysteme, 0, nil);
         uForms_ShowMessage(  'La fonction gethostname a échoué avec le message suivant:'+sys_N
                      +StrPas(MessageSysteme));
         end;
     Result:= StrPas( hostname);
end;
{$ENDIF}
procedure TNetWork.Set_Ports_Instances;
var
   I: Integer;
   Ports_Instances: String;
begin
     Ports_Instances:= sys_Vide;
     for I:= 0 to slPorts_Instances.Count-1
     do
       begin
       if Ports_Instances <> sys_Vide
       then
           Ports_Instances:= Ports_Instances + ';';
       Ports_Instances:= Ports_Instances + slPorts_Instances.Strings[ I];
       end;
     INI.WriteString( uNetWork_inis_Ports_Instances, Nom_Hote, Ports_Instances);
     INI.UpdateFile;
end;

procedure TNetWork.Get_Ports_Instances;
var
   Ports_Instances: String;
   Port: String;
begin
     slPorts_Instances.Clear;
     Ports_Instances:= INI.ReadString( uNetWork_inis_Ports_Instances, Nom_Hote, sys_Vide);
     while Ports_Instances <> sys_Vide
     do
       begin
       Port:= StrToK( ';', Ports_Instances);
       slPorts_Instances.Add( Port);
       end;
end;

procedure TNetWork.RemovePort_Interne( Port: String);
var
   I: Integer;
begin
     repeat
           I:= slPorts_Instances.IndexOf( Port);
           if I <> -1
           then
               slPorts_Instances.Delete( I);
     until I = -1;
end;

procedure TNetWork.AddPort( Port: String);
begin
     Get_Ports_Instances;
     //avec RemovePort_Interne on enleve les hypothétiques doublons
     // (reste de plantage par exemple)
     //et on assure que le port sera ajouté en fin donc sélectionné par le GetPort
     RemovePort_Interne( Port);
     slPorts_Instances.Add( Port);
     Set_Ports_Instances;
end;

procedure TNetWork.RemovePort( Port: String);
begin
     Get_Ports_Instances;
     RemovePort_Interne( Port);
     Set_Ports_Instances;
end;

function  TNetWork.GetPort: String;
begin
     Get_Ports_Instances;
     with slPorts_Instances
     do
       if Count = 0
       then
           Result:= sys_Vide
       else
           Result:= Strings[ Count - 1];
end;

{$IFNDEF ANDROID}
procedure Init_WSA;
var
  LData: TWSAData;
begin
     WSAStartup($202, LData);
end;
{$ENDIF}

procedure TNetwork.Get_Instances( _sl: TBatpro_StringList);
var
   Section: TBatpro_StringList;
   I, J: Integer;
begin
     Section:= TBatpro_StringList.Create;
     try
        INI.ReadSection( uNetWork_inis_Ports_Instances, Section);
        for I:= 0 to Section.Count - 1
        do
          begin
          Nom_Hote:= Section[ I];
          Get_Ports_Instances;
          for J:= 0 to slPorts_Instances.Count - 1
          do
            _sl.Add( Nom_Hote + ':' + slPorts_Instances[J]);
          end;
     finally
            Free_nil( Section);
            end;
end;

procedure TNetwork.Remove_Instance( _Instance: String);
var
   Port: String;
begin
     Nom_Hote:= StrToK( ':', _Instance);
     Port    := _Instance;
     RemovePort( Port);
end;

procedure TNetwork.Efface;
begin
     INI.EraseSection( uNetWork_inis_Ports_Instances);
end;

{$IFNDEF ANDROID}
function TNetwork.IP_Principale: TInAddr;
var
   hostname: array[0..2048] of ansichar;
   MessageSysteme: PChar;
   HostEnt: PHostEnt;
   IP: PInAddr;
begin
     Result.S_addr:= 0;

     if 0 <> gethostname( hostname, sizeof(hostname)-1)
     then
         begin
         FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                        FORMAT_MESSAGE_ALLOCATE_BUFFER,
                        nil, WSAGetLastError,
                        0, @MessageSysteme, 0, nil);
         uForms_ShowMessage(  'La fonction gethostname a échoué avec le message suivant:'+sys_N
                       +StrPas(MessageSysteme));
         end
     else
         begin
         HostEnt:= gethostbyname( hostname);
         if HostEnt = nil
         then
             begin
             FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                            FORMAT_MESSAGE_ALLOCATE_BUFFER,
                            nil, WSAGetLastError,
                            0, @MessageSysteme, 0, nil);
             uForms_ShowMessage(  'La fonction gethostbyname a échoué avec le message suivant:'+sys_N
                          +StrPas(MessageSysteme));
             end
         else
             begin
             IP:= PInAddr(HostEnt.h_addr^);
             //Result:= StrPas(inet_ntoa( IP^));
             Result:= IP^;
             end;
         end;
end;
{$ENDIF}
initialization
              {$IFNDEF ANDROID}
              Init_WSA;
              {$ENDIF}
              uNetWork_NomExecutable:= UpperCase( ChangeFileExt( ExtractFileName( ParamStr(0)), sys_Vide));
              Network:= TNetwork.Create;
finalization
              Free_nil( Network);
end.




