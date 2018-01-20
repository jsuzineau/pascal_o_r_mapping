unit uInformix;
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
    uForms,
    uClean,
    u_sys_,
    uRegistry,
    uSGBD,
    uMySQL,//juste pour fonction crypto
    uEXE_INI,

    ufAccueil_Erreur,

    {$IFDEF MSWINDOWS}
    Windows, Messages, Registry,
    {$ENDIF}
    //FMX.Dialogs, FMX.Forms,
    SysUtils, SQLExpr;

type
 TInformix
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    procedure Ecrit     ( NomValeur: String; Valeur: String; Crypter: Boolean= False);
    function  Lit_simple( NomValeur: String; Crypter: Boolean= False): String;
    procedure Lecture_simple;
  public
    procedure Ecrire;
  //Attributs
  private
    FHostName : String;
    procedure Set_INFORMIXSERVER(Value: String);
    procedure SetHostName(const Value: String);
  public
    property HostName: String read FHostName write SetHostName;
  public
    DataBase : String;
    User_Name: String;
    Password : String;
    procedure Efface;
    function Vide: Boolean;
  //initialisation à partir d'une SQLConnection
  public
    procedure _from_sqlc( _sqlc: TSQLConnection);
  //Appel utilitaires
  public
    procedure SetNet32;
    procedure DBPing;
  end;

var
   Informix: TInformix;

const
     inis_informix= 'informix';

implementation


{ TInformix }

constructor TInformix.Create;
begin
     inherited;
     FHostName:= sys_Vide;
     DataBase := sys_Vide;
     User_Name:= sys_Vide;
     Password := sys_Vide;

     pSGBDChange.Abonne( Self, Lecture_simple);
     Lecture_simple;
end;

destructor TInformix.Destroy;
begin
     pSGBDChange.DesAbonne( Self, Lecture_simple);
     inherited;
end;

procedure TInformix.Lecture_simple;
begin
     if SGBD <> sgbd_Informix then exit;
     Initialise_Registry_Informix;

     HostName := Lit_simple( regv_HostName );
     DataBase := Lit_simple( regv_Database );
     User_Name:= Lit_simple( regv_User_Name);
     PassWord := Lit_simple( regv_PassWord , True);
end;

procedure TInformix.Ecrire;
begin
     Ecrit( regv_HostName , HostName );
     Ecrit( regv_Database , DataBase );
     Ecrit( regv_User_Name, User_Name);
     Ecrit( regv_PassWord , PassWord , True);
end;

function TInformix.Lit_simple( NomValeur: String; Crypter: Boolean): String;
var
   ValeurBrute: String;
begin
     {$IFDEF MSWINDOWS}
     if Registry_Informix.ValueExists( NomValeur)
     then
         ValeurBrute:= Registry_Informix.ReadString( NomValeur)
     else
     {$ENDIF}
         ValeurBrute:= EXE_INI.ReadString( inis_informix, NomValeur, sys_Vide);

     if Crypter
     then
         Result:= Crypto( ValeurBrute)
     else
         Result:= ValeurBrute;
end;

procedure TInformix.Ecrit( NomValeur: String; Valeur: String; Crypter: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TInformix.Ecrit: NomValeur est vide');

     if Crypter
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_informix, NomValeur, ValeurBrute);
     try
        Initialise_Registry_Informix;
        {$IFDEF MSWINDOWS}
        Registry_Informix.WriteString( NomValeur, ValeurBrute);
        {$ENDIF}
     except
           on E: Exception
           do
             uForms_ShowMessage( E.Message);
           end;

end;

procedure TInformix.Efface;
begin
     Hostname:= sys_Vide;
end;

function TInformix.Vide: Boolean;
begin
     Result:= Hostname = sys_Vide;
end;

procedure TInformix.Set_INFORMIXSERVER(Value: String);
{$IFNDEF MSWINDOWS}
begin

end;
{$ELSE}
const
     regk_INFORMIXSERVER= 'INFORMIXSERVER';
var
   r: TRegistry;
   Modifie: Boolean;
   //wmsc: TWMSettingChange;
   procedure Traite( Racine: HKEY; sRacine: String; Cle: String; ForceCreation: Boolean= False);
   var
      Traiter: Boolean;
   begin
        r.RootKey:= Racine;
        if r.OpenKey( Cle, True)
        then
            begin
            if r.ValueExists( regk_INFORMIXSERVER)
            then
                Traiter:= Value <> r.ReadString( regk_INFORMIXSERVER)
            else
                Traiter:= ForceCreation;

            if Traiter
            then
                try
                   Modifie
                   :=
                        Modifie
                     or (Value <> r.ReadString( regk_INFORMIXSERVER));
                   r.WriteString( regk_INFORMIXSERVER, Value);
                except
                      on Exception
                      do
                        begin
                        fAccueil_Erreur(  'TInformix.Set_INFORMIXSERVER:'#13#10
                                         +' Impossible d''écrire dans la base de registre'#13#10
                                         +'  Racine: '+sRacine+#13#10
                                         +'  Clé   : '+Cle    +#13#10
                                         +'  Valeur: '+Value  +#13#10
                                         +'Peut-être que vous n''avez pas les droits d''écriture,'#13#10
                                         +'dans ce cas il suffit de vous connecter en administrateur '#13#10
                                         +'sur cette machine et de lancer une fois Batpro_Editions.');
                        end;
                      end;
            end;
   end;
begin
     if SGBD <> sgbd_Informix then exit;

     Modifie:= False;

     //Mise à jour dans la base de registre
     try
        r:= TRegistry.Create;

        Traite( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\System\CurrentControlSet\Control\Session Manager\Environment');
        Traite( HKEY_LOCAL_MACHINE, 'HKEY_LOCAL_MACHINE',
                '\SOFTWARE\Informix\Environment', True);
        Traite( HKEY_CURRENT_USER, 'HKEY_CURRENT_USER',
                '\Software\Informix\Environment');
     finally
            FreeAndNil( r);
            end;
     //On prévient les applications que çà a changé
     //wmsc.Msg:= WM_SETTINGCHANGE;
     //wmsc.Flag:= 0;
     //wmsc.Section:= PChar('Environment');
     if Modifie
     then
         SendNotifyMessage( HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(Pointer(PChar('Environment'))));
end;
{$ENDIF}

procedure TInformix.SetHostName(const Value: String);
begin
     FHostName:= Value;
     Set_INFORMIXSERVER( HostName);
end;

procedure TInformix._from_sqlc( _sqlc: TSQLConnection);
var
   NewHostName: String;
     function Valeur( Keyname: String): String;
     begin
          Result:= _sqlc.Params.Values[ Keyname];
     end;
begin
     NewHostName:= Valeur( 'HostName' );
     if HostName <> NewHostName
     then
         HostName := NewHostName;
     Database := Valeur( 'DataBase' );
     User_Name:= Valeur( 'User_Name');
     Password := Valeur( 'Password' );
end;

procedure TInformix.SetNet32;
begin
     {$IFDEF MSWINDOWS}
     WinExec( PAnsiChar('C:\informix_client\bin\setnet32.exe'), SW_SHOWNORMAL);
     {$ENDIF}
end;

procedure TInformix.DBPing;
begin
     {$IFDEF MSWINDOWS}
     WinExec( PAnsiChar('C:\informix_client\bin\dbping.exe'), SW_SHOWNORMAL);
     {$ENDIF}
end;

initialization
              Informix:= TInformix.Create;
finalization
              Free_nil( Informix);
end.
