unit udmSMTP;
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
    uClean,
    uEXE_INI,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, uOD_Forms, Dialogs,
  ExtCtrls, ActnList, ComCtrls, IniFiles,
  IdBaseComponent, IdComponent, IdTCPServer, IdCmdTCPServer, IdFTPList,
  IdExplicitTLSClientServerBase, IdFTPServer, StdCtrls, IdFTPListOutput,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTPBase, IdSMTP,
  IdMessageCoder, IdMessageCoderMIME, IdMessage,IdCommandHandlers, Buttons,
  IdCmdTCPClient, IdContext, IdServerIOHandler, IdSSL,
  IdSSLOpenSSL,IdIOHandler, IdSchedulerOfThread, IdYarn;

type
 TdmSMTP
 =
  class(TDataModule)
    Message: TIdMessage;
    smtp: TIdSMTP;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  //Interface d'envoi de mail
  public
    function EnvoiMail( Message: TIdMessage): Boolean;
  //Expéditeur par défaut
  public
    Default_From: String;
  //Ecriture des parametres
  private
    procedure _to_ini;
  end;

function dmSMTP: TdmSMTP;

implementation

{$R *.dfm}

var
   FdmSMTP: TdmSMTP;

function dmSMTP: TdmSMTP;
begin
     Clean_Get( Result, FdmSMTP, TdmSMTP);
end;

{ TdmSMTP }

procedure TdmSMTP.DataModuleCreate(Sender: TObject);
begin
     inherited;
     smtp.Host    := EXE_INI.ReadString ( 'smtp', 'host'    , '#');
     smtp.UserName:= EXE_INI.ReadString ( 'smtp', 'UserName', '' );
     smtp.Password:= EXE_INI.ReadString ( 'smtp', 'Password', '' );
     smtp.Port    := EXE_INI.ReadInteger( 'smtp', 'Port'    , 25 );
     smtp.HeloName:= EXE_INI.ReadString ( 'smtp', 'HeloName', '' );

     Default_From:= EXE_INI.ReadString ( 'smtp', 'Default_From', ''            );

     if smtp.Host = '#'
     then
         begin
         smtp.Host:='saisissez le serveur smtp ici';
         _to_ini;
         end;

     if smtp.Username = ''
     then
         smtp.AuthType:= atNone
     else
         smtp.AuthType:= atDefault;
     smtp.MailAgent:= ChangeFileExt( ExtractFileName( uOD_Forms_EXE_Name), '');
end;

procedure TdmSMTP.DataModuleDestroy(Sender: TObject);
begin
     //
     inherited;
end;

procedure TdmSMTP._to_ini;
begin
     EXE_INI.WriteString ( 'smtp', 'host'    , smtp.Host    );
     EXE_INI.WriteString ( 'smtp', 'UserName', smtp.UserName);
     EXE_INI.WriteString ( 'smtp', 'Password', smtp.Password);
     EXE_INI.WriteInteger( 'smtp', 'Port'    , smtp.Port    );
     EXE_INI.WriteString ( 'smtp', 'HeloName', smtp.HeloName);

     EXE_INI.WriteString ( 'smtp', 'Default_From', Default_From);
end;

function TdmSMTP.EnvoiMail( Message: TIdMessage): Boolean;
begin
     smtp.Connect;
     try
        if Message.From.Address = ''
        then
            Message.From.Address:= Default_From;
        smtp.Send( Message);
     finally
            smtp.Disconnect;
            end;
     Result:= True;
end;

initialization
finalization
              Clean_Destroy( FdmSMTP);
end.

