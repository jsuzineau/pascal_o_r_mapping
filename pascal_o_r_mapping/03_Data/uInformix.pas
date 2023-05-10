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
    uDataUtilsF,
    uMySQL,//juste pour fonction crypto
    uEXE_INI,
    ujsDataContexte,
    uInformix_Column,

    ufAccueil_Erreur,

    {$IFNDEF FPC}
    Windows, Messages,
    {$ENDIF}
    //Dialogs, Forms,
    SysUtils, Registry, SQLDB, odbcconn;

type

	{ TInformix }

 TInformix
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    procedure Ecrit     ( NomValeur: String; Valeur: String; Crypter: Boolean= False);
    function  Lit_simple( NomValeur: String; Crypter: Boolean= False): String;
    procedure Lecture_simple;
  public
    procedure Ecrire; override;
  //Transaction
  protected
    function Cree_SQLTransaction: TSQLTransaction; override;
  //Connexion
  protected
    function Cree_SQLConnection: TSQLConnection; override;
  //HostName
  private
    procedure Set_INFORMIXSERVER(Value: String);
  protected
    procedure SetHostName(const Value: String); override;
  //Attributs
  public
    procedure Efface;
    function Vide: Boolean;
  {$IFNDEF FPC}
  //initialisation à partir d'une Database
  public
    procedure _from_sqlc( _sqlc: TDatabase);
  {$ENDIF}
  //Appel utilitaires
  public
    procedure SetNet32;
    procedure DBPing;
  //Attributs de connexion
  private
    sqltSYSMASTER: TSQLTransaction;
    sqlqSYSDATABASES: TSQLQuery;
  public
    sqlcSYSMASTER: TSQLConnection;
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  //méthodes pour schémateur
  private
    procedure Champ_Cherche_Requete( _Table, _Champ: String);
  public
    function Table_Cherche( _Table               : String): Boolean; override;
    function Index_Cherche( _Table, _Index       : String): Boolean; override;
    function Champ_Cherche( _Table, _Champ       : String): Boolean; override;
    function Champ_Type_Cherche( _Table, _Champ, _Type: String): Boolean; override;
    function Champ_Type_Defaut_Cherche( _Table, _Champ, _Type, _Defaut: String): Boolean; override;
  end;

const
     inis_informix= 'informix';

implementation


{ TInformix }

constructor TInformix.Create( _SGBD: TSGBD);
begin
     inherited Create( _SGBD);

     sqltSYSMASTER:= Cree_SQLTransaction;

     sqlcSYSMASTER:= Cree_SQLConnection;
     sqlcSYSMASTER.Transaction:= sqltSYSMASTER;
     sqlcSYSMASTER.DatabaseName:= 'sysmaster';

     sqlqSYSDATABASES:= TSQLQuery.Create(nil);
     sqlqSYSDATABASES.SQL.Text:= 'select * from sysdatabases where name <> "sysmaster" and name <> "sysutils"';
     sqlqSYSDATABASES.Transaction:= sqltSYSMASTER;

     pSGBDChange.Abonne( Self, Lecture_simple);
     Lecture_simple;

end;

destructor TInformix.Destroy;
begin
     pSGBDChange.DesAbonne( Self, Lecture_simple);

     FreeAndnil( sqlqSYSDATABASES);
     FreeAndnil( sqlcSYSMASTER);
     FreeAndnil( sqltSYSMASTER);
     inherited;
end;

function TInformix.Cree_SQLTransaction: TSQLTransaction;
begin
     Result:= TSQLTransaction.Create( nil);
end;

function TInformix.Cree_SQLConnection: TSQLConnection;
begin
		   Result:= TODBCConnection.Create(nil);
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
     inherited Ecrire;

     Ecrit( regv_HostName , HostName );
     Ecrit( regv_Database , DataBase );
     Ecrit( regv_User_Name, User_Name);
     Ecrit( regv_PassWord , PassWord , True);
end;

function TInformix.Lit_simple( NomValeur: String; Crypter: Boolean): String;
var
   ValeurBrute: String;
begin
     if Registry_Informix.ValueExists( NomValeur)
     then
         ValeurBrute:= Registry_Informix.ReadString( NomValeur)
     else
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
        Registry_Informix.WriteString( NomValeur, ValeurBrute);
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
     {$IFNDEF FPC}
     if Modifie
     then
         SendNotifyMessage( HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(Pointer(PChar('Environment'))));
     {$ENDIF}    
end;

procedure TInformix.SetHostName(const Value: String);
begin
     inherited SetHostName( Value);
     Set_INFORMIXSERVER( HostName);
end;

{$IFNDEF FPC}
procedure TInformix._from_sqlc( _sqlc: TDatabase);
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
{$ENDIF}

procedure TInformix.SetNet32;
begin
     {$IFNDEF FPC}
     WinExec( PChar('C:\informix_client\bin\setnet32.exe'), SW_SHOWNORMAL);
     {$ENDIF}
end;

procedure TInformix.DBPing;
begin
     {$IFNDEF FPC}
     WinExec( PChar('C:\informix_client\bin\dbping.exe'), SW_SHOWNORMAL);
     {$ENDIF}
end;

procedure TInformix.Prepare;
begin
     inherited Prepare;

     Database_indefinie:= DataBase = sys_Vide;
     if Database_indefinie
     then
         DataBase:= 'sysmaster'
     else
         Database_indefinie:= DataBase = 'sysmaster';

     Ouvrable
     :=
       //    (Informix.HostName  <> sys_Vide)
       //and (Informix.User_Name <> sys_Vide)
       (*and*) (Database  <> sys_Vide);


     sqlc.DatabaseName:= Database;
     //WriteParam( 'HostName' , Informix.HostName );
     //WriteParam( 'User_Name', Informix.User_Name);
     //WriteParam( 'Password' , Informix.Password );
     //WriteParam( 'DataBase' , Informix.Database );
end;

procedure TInformix.Ouvre_db;
begin
		   inherited Ouvre_db;
     if not Ouvert then exit;

     if Ouvre_SQLConnection( sqlcSYSMASTER) // liste des bases informix
     then
         if RefreshQuery( sqlqSYSDATABASES)
         then
             sqlqSYSDATABASES.Locate('name', DataBase, []);
end;

procedure TInformix.Ferme_db;
begin
		   inherited Ferme_db;
     sqlqSYSDATABASES.Close;
     sqlcSYSMASTER   .Close;
end;

procedure TInformix.Keep_Connection;
begin
     inherited Keep_Connection;

     sqlcSYSMASTER.KeepConnection:= True;
     Ouvre_SQLConnection( sqlcSYSMASTER);
end;

procedure TInformix.Do_not_Keep_Connection;
begin
     inherited Do_not_Keep_Connection;

     sqlcSYSMASTER.KeepConnection:= False;
     sqlcSYSMASTER.Connected:= False;
end;

function TInformix.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:=
 'select                                                                   '+LineEnding
+'      dbinfo(''sqlca.sqlerrd1'')                                         '+LineEnding
+'-- le from et le where sont là juste pour qu informix accepte la requete '+LineEnding
+'from                                                                     '+LineEnding
+'    systables                                                            '+LineEnding
+'where                                                                    '+LineEnding
+'     tabid =1                                                            '+LineEnding;
     Contexte.Integer_from( SQL, Result);
end;

function TInformix.Table_Cherche(_Table: String): Boolean;
var
   SQL: String;
begin
     SQL
     :=
        'select                 '+LineEnding
       +'      *                '+LineEnding
       +'from                   '+LineEnding
       +'    systables          '+LineEnding
       +'where                  '+LineEnding
       +'     tabname = :tabname'+LineEnding
       ;
     Contexte.SQL:= SQL;
     with Contexte.Params
     do
       ParamByName( 'tabname').AsString:= _Table;
     Result:= Contexte.Execute_and_Result_not_empty;
end;

function TInformix.Index_Cherche(_Table, _Index: String): Boolean;
var
   SQL: String;
begin
     SQL
     :=
        'select                                       '+LineEnding
       +'      sysindexes.*                           '+LineEnding
       +'from                                         '+LineEnding
       +'    sysindexes                               '+LineEnding
       +'where                                        '+LineEnding
       +'         (sysindexes.idxname = :idxname)     '+LineEnding
       +'     and ( sysindexes.tabid in               '+LineEnding
       +'           (                                 '+LineEnding
       +'           select                            '+LineEnding
       +'                 systables.tabid             '+LineEnding
       +'           from                              '+LineEnding
       +'               systables                     '+LineEnding
       +'           where                             '+LineEnding
       +'                systables.tabname = :tabname '+LineEnding
       +'           )                                 '+LineEnding
       +'         )                                   '+LineEnding
       ;
     Contexte.SQL:= SQL;
     with Contexte.Params
     do
       begin
       ParamByName( 'tabname').AsString:= _Table;
       ParamByName( 'idxname').AsString:= _Index;
       end;
     Result:= Contexte.Execute_and_Result_not_empty;
end;

procedure TInformix.Champ_Cherche_Requete(_Table, _Champ: String);
var
   SQL: String;
begin
     SQL
     :=
        'select                                                                    '
       +'      rowid,*                                                             '
       +'from                                                                      '
       +'    syscolumns                                                            '
       +'where                                                                     '
       +'         (tabid in (select tabid from systables where tabname = :tabname))'
       +'     and (colname = :colname)                                             '
       ;
     Contexte.SQL:= SQL;
     with Contexte.Params
     do
       begin
       ParamByName( 'tabname').AsString:= _Table;
       ParamByName( 'colname').AsString:= _Champ;
       end;
end;

function TInformix.Champ_Cherche(_Table, _Champ: String): Boolean;
begin
     Champ_Cherche_Requete( _Table, _Champ);
     Result:= Contexte.Execute_and_Result_not_empty;
end;

function TInformix.Champ_Type_Cherche(_Table, _Champ, _Type: String): Boolean;
var
   coltype  : Integer; cCOLTYPE  : TjsDataContexte_Champ;
   collength: Integer; cCOLLENGTH: TjsDataContexte_Champ;
   ic: TInformix_Column;
begin
     Champ_Cherche_Requete( _Table, _Champ);
     try
        Result:= Contexte.Execute_and_Result_not_empty_dont_close;
        if not Result then exit;

        cCOLTYPE  := Contexte.Find_Champ( 'coltype'  );
        if nil = cCOLTYPE then exit;

        cCOLLENGTH:= Contexte.Find_Champ( 'collength');
        if nil = cCOLLENGTH then exit;

        coltype  := cCOLTYPE  .asInteger;
        collength:= cCOLLENGTH.asInteger;
     finally
            Contexte.Close;
            end;

     _Type:= UpperCase( _Type);
     ic:= TInformix_Column.Create;
     try
        ic.Set_To( coltype, collength);
        Result:= ic.SQL = _Type;
     finally
            Free_nil( ic);
            end;
end;


function TInformix.Champ_Type_Defaut_Cherche( _Table, _Champ, _Type, _Defaut: String): Boolean;
begin
     Result:= Champ_Type_Cherche( _Table, _Champ, _Type);
end;

end.
