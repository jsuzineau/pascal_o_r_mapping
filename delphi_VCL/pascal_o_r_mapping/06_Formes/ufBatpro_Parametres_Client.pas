unit ufBatpro_Parametres_Client;
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
  uClean,
  uuStrings,
  uOD_Forms,
  Windows, Messages, SysUtils, Variants, Classes, VCL.Graphics, VCL.Controls, VCL.Forms,
  VCL.Dialogs, Registry, VCL.StdCtrls, WinSock, VCL.ExtCtrls;

type
 TfBatpro_Parametres_Client
 =
  class(TForm)
    m: TMemo;
    Panel1: TPanel;
    bSaveAs: TButton;
    sd: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure bSaveAsClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
   FfBatpro_Parametres_Client: TfBatpro_Parametres_Client= nil;

function fBatpro_Parametres_Client: TfBatpro_Parametres_Client;

implementation

{$R *.dfm}

function fBatpro_Parametres_Client: TfBatpro_Parametres_Client;
begin
     Clean_Get( result, FfBatpro_Parametres_Client, TfBatpro_Parametres_Client);
end;

procedure TfBatpro_Parametres_Client.FormShow(Sender: TObject);
const
     regk_INFORMIXSERVER= 'INFORMIXSERVER';
var
   sData: TWSAData;
   r: TRegistry;
   procedure Traite( Racine: HKEY; sRacine,Cle: String);
   var
      S: String;
      function Value_String( _ValueName: String): String;
      begin
           Result:= _ValueName + ' = >';
           if r.ValueExists( _ValueName)
           then
               Result:= Result + r.ReadString( _ValueName)
           else
               Result:= Result + 'Valeur non définie';
           Result:= Result + '<';
      end;
   begin
        S:= sRacine+Cle;
        S:= Fixe_Min( S, 80);
        S:= S+' : ';
        r.RootKey:= Racine;
        if r.OpenKey( Cle, True)
        then
            S:= S + Value_String( regk_INFORMIXSERVER)
        else
            S:= S + 'Echec de l''ouverture de la clé';
        m.Lines.Add( S);
   end;
   procedure Traite_Valeurs( Racine: HKEY; sRacine,Cle: String);
   var
      S: String;
      function Value_String( _ValueName: String): String;
      begin
           Result:= _ValueName + ' = >';
           if r.ValueExists( _ValueName)
           then
               Result:= Result + r.ReadString( _ValueName)
           else
               Result:= Result + 'Valeur non définie';
           Result:= Result + '<';
      end;
      procedure Ajoute_Valeurs;
      var
         sl: TStringList;
         I: Integer;
      begin
           sl:= TStringList.Create;
           try
              r.GetValueNames( sl);
              for I:= 0 to sl.Count - 1
              do
                begin
                m.Lines.Add( '   '+Value_String( sl[I]));
                end;
           finally
                  Free_nil( sl);
                  end;
      end;
   begin
        r.RootKey:= Racine;
        if r.OpenKey( Cle, True)
        then
            begin
            S:= sRacine+Cle;
            S:= Fixe_Min( S, 80);
            S:= S+' : ';
            m.Lines.Add( S);
            Ajoute_Valeurs;
            end;
   end;
   procedure TraitePort( NomPort: String);
   var
      port: PServEnt;
      S: String;
      MessageSysteme: PChar;
      nPORT: Integer;
      sPORT: String;
      Aliases: String;
   begin
        S:= Fixe_Min( NomPort, 10) + '=>';
        port:= getservbyname( PAnsiChar(NomPort), nil);
        if port = nil
        then
            begin
            FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                           FORMAT_MESSAGE_ALLOCATE_BUFFER,
                           nil, GetLastError,
                           0, @MessageSysteme, 0, nil);
            S:= S + 'Échec de getservbyname: '+StrPas(MessageSysteme);
            end
        else
            begin
            nPORT:= ntohs(port.s_port);
            sPORT:= IntTostr( nPORT);
            sPORT:= Espaces(5-Length(sPORT))+sPORT;
            S
            :=
                S
              + Fixe_Min( StrPas( port.s_name), 10)+':'
              + sPORT
              +','+ Fixe_Min( StrPas( port.s_proto), 5);
            Aliases:= StrPas( port.s_aliases^);
            if Aliases <> ''
            then
                Aliases:= ', aliases:'+Aliases;
            S:= S+ Aliases;
            end;

        S:= S + '<';
        m.Lines.Add( S);
   end;
begin
     sd.InitialDir:= ExtractFilePath( uOD_Forms_EXE_Name)+'etc\';

     WSAStartup($202, sData);
     m.Lines.Clear;
     try
        r:= TRegistry.Create;

        m.Lines.Add( 'DÉFINITIONS DE INFORMIX_SERVER');
        m.Lines.Add( '');
        Traite( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\System\CurrentControlSet\Control\Session Manager\Environment');
        Traite( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Informix\Environment');
        Traite( HKEY_CURRENT_USER , 'HKEY_CURRENT_USER ',
                '\Software\Informix\Environment');

        m.Lines.Add( '');
        m.Lines.Add( '');
        m.Lines.Add( 'PARAMÈTRES INFORMIX');
        m.Lines.Add( '');
        Traite_Valeurs( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Informix\Environment');
        Traite_Valeurs( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Informix\SqlHosts\ows');
        Traite_Valeurs( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Informix\SqlHosts\ows2');
        Traite_Valeurs( HKEY_CURRENT_USER , 'HKEY_CURRENT_USER ',
                '\Software\Informix\Environment');
        Traite_Valeurs( HKEY_CURRENT_USER , 'HKEY_CURRENT_USER ',
                '\Software\Informix\Environment');

        m.Lines.Add( '');
        m.Lines.Add( '');
        m.Lines.Add( 'PARAMÈTRES BATPRO');
        m.Lines.Add( '');
        Traite_Valeurs( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Batpro\Informix');
        Traite_Valeurs( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Batpro\MySQL');

        m.Lines.Add( '');
        m.Lines.Add( '');
        m.Lines.Add( 'PORTS');
        m.Lines.Add( '');
        TraitePort( 'http');
        TraitePort( 'ftp' );
        TraitePort( 'turbo');
        TraitePort( 'turbo2');
     finally
            FreeAndNil( r);
            end;
end;

procedure TfBatpro_Parametres_Client.bSaveAsClick(Sender: TObject);
begin
     if sd.Execute
     then
         m.Lines.SaveToFile( sd.FileName);
end;

initialization
finalization
              Clean_Destroy( FfBatpro_Parametres_Client);
end.
