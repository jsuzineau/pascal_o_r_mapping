unit uHTTP_Interface;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014,2018 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uForms,
    uClean,
    uMimeType,
    uChrono,
    uuStrings,
    uBatpro_StringList,
    uBatpro_Element,
    uPublieur,
    uLog,
    uEXE_INI,
    uOD_Temporaire,
 {$ifdef fpc}
 fglExt,blcksock, sockets, Synautil,process,
   {$ifdef android}
   Laz_And_Controls,
   {$else}
     fphttpclient,
   {$endif}
 {$endif}
 Classes, SysUtils;

type
 THTTP_Interface_thread = class;

 THTTP_Interface= class;
 TslHTTP_Interface= class;

 { THTTP_Interfaces }

 THTTP_Interfaces
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Liste des interfaces
  public
    sl: TslHTTP_Interface;
    procedure Ajoute( _hi: THTTP_Interface);
    procedure Enleve( _hi: THTTP_Interface);
    function _from_Name( _Name: String): THTTP_Interface;
  //Attributs
  public
    slPool: Tslpool_Ancetre_Ancetre;
  //enregistrement d'un pool
  public
    procedure Register_pool( _pool: Tpool_Ancetre_Ancetre);
  //Gestion multitâche
  public
    procedure Verification_http_inactif;
  //LaunchURL_Callback
  public
    slLaunchURL_Callback: TStringList;
    procedure Set_LaunchURL_Callback( _Name, _Value: String);
    function LaunchURL_Callback( _Name: String): String;
  end;

 { THTTP_Interface }

 THTTP_Interface
 =
  class( THTTP_Interface_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String);
    destructor Destroy; override;
  //Attributs
  public
    Name: String;
    S: TTCPBlockSocket;
    DocumentRoot: String;
    Racine: String;
  //Gestion de fichiers
  private
    function Traite_Prefixe_Fichier( _Prefixe: String): Boolean;
    function Content_type_from_NomFichier( _NomFichier: String): String;
  //méthodes d'envoi de données
  private
    procedure Send_Header( _Content_type: String; _Content_Length: Integer; _Filename: String= '');
  public
    procedure Send_Data(_Content_type, _Data: String);           override;
    procedure Send_Fichier( _NomFichier: String);                override;
    procedure Send_HTML(_HTML: String);                          override;
    procedure Send_JSON(_JSON: String);                          override;
    procedure Send_Text(_Text: String);                          override;
    procedure Send_JS(_JS: String);                              override;
    procedure Send_CSS(_CSS: String);                            override;
    procedure Send_WOFF(_WOFF: String);                          override;
    procedure Send_WOFF2(_WOFF2: String);                        override;
    procedure Send_ICO(_ICO: String);                            override;
    procedure Send_MIME_from_Extension(_S, _Extension: String);  override;
    procedure Send_Not_found;                                    override;
    procedure Traite_fichier( _NomFichier: String); overload;
    procedure Traite_racine;
    procedure Traite_fichier; overload;
  //Traitement d'un pool
  private
    function Traite_pool: Boolean;
  //gestion de callbacks
  private
    function Traite_slP_slO: Boolean;
  public
    slP: TslAbonnement_Procedure;
    slO: TslAbonnement_Objet;
  //Gestion de la racine
  public
    procedure Init_from_ClassName( _ClassName: String; _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
  //Traitement des appels
  public
    function Prefixe( _Prefixe: String): Boolean; override;
    procedure Traite;
  //Traitement du Chrono
  private
    function Traite_Chrono: Boolean;
  //URL_Externe
  private
    URL_Externe: String;
    procedure URL_Externe_from_ini;
  //Gestion de l'exécution
  private
    ListenerSocket, ConnectionSocket: TTCPBlockSocket;
    procedure AttendConnection(ASocket: TTCPBlockSocket);
    procedure Loop_body;
    procedure Loop_end;
    procedure do_fgl_call_LaunchURL( _CallBack: String);
  public
    Terminated: Boolean;

    Modal: Boolean;
    Execute_LaunchURL: Boolean;
    Port: Integer;
    sPort: String;
    URL: String;
    URL_interne: String;
    function Init( _IP: String='127.0.0.1'; _Port: Integer=0): String;
    procedure Run( _Modal: Boolean= True);
    procedure LaunchURL;
    function Test_Port( _Port: Integer):Boolean;
  //Ouvrir_hors_Web_component
  private
    Ouvrir_hors_Web_component: Boolean;
    procedure Lire_Ouvrir_hors_Web_component;
    procedure Ouverture_hors_Web_component;

  //Gestion multitâche
  public
    th: THTTP_Interface_thread;
    procedure Verification_http_inactif;
    procedure Synchronize( _Method: TThreadMethod);
  //version "synchronize" de fgl_putfile
  private
    fgl_putfile_interne_CriticalSection: TRTLCriticalSection;
    fgl_putfile_interne_NomFichier_cote_serveur: String;
    fgl_putfile_interne_NomFichier_cote_client : String;
    procedure fgl_putfile_interne;
  public
    procedure fgl_putfile( _NomFichier_cote_serveur, _NomFichier_cote_client: String);
  //lg_HTTP_Interface_Terminate
  private
    procedure do_lg_HTTP_Interface_Terminate;
  public
    procedure lg_HTTP_Interface_Terminate;
  //version "synchronize" de fgl_putfile
  private
    lg_Traite_Fichier_Genere_interne_CriticalSection: TRTLCriticalSection;
    lg_Traite_Fichier_Genere_Fonction: String;
    lg_Traite_Fichier_Genere_Fichier_genere: String;
    procedure lg_Traite_Fichier_Genere_interne;
  public
    procedure lg_Traite_Fichier_Genere( _Fonction, _Fichier_genere: String);
  //LaunchURL_Callback
  private
   function  GetLaunchURL_Callback: String;
   procedure SetLaunchURL_Callback(_Value: String);
  public
    property LaunchURL_Callback: String read GetLaunchURL_Callback write SetLaunchURL_Callback;
  //Gestion des requêtes multi-origine Cross-Origin Request CORS
  //valeur de l'entête Access-Control-Allow-Origin,
  // * en dev,
  // à restreindre en prod: Access-Control-Allow-Origin: https://developer.mozilla.org
  private
    procedure Charge_CORS_Value;
  public
    CORS_Value: String;
  end;

  TIterateur_HTTP_Interface
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: THTTP_Interface);
    function  not_Suivant( var _Resultat: THTTP_Interface): Boolean;
  end;

 TslHTTP_Interface
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_HTTP_Interface;
    function Iterateur_Decroissant: TIterateur_HTTP_Interface;
  end;

 THTTP_Interface_thread
 =
  class(TThread)
  //Gestion du cycle de vie
  public
    constructor Create;
  //Méthodes
  protected
    procedure Execute; override;
  //Attributs
  public
    hi: THTTP_Interface;
  end;

const
     uHTTP_Interface_DefaultLaunchURL_Callback='affiche_url';
     uHTTP_Interface_Socket_TimeOut= 1000;
     uHTTP_Interface_Loop_body_TimeOut=1000;
     uHTTP_Interface_Terminer_Sleep=uHTTP_Interface_Loop_body_TimeOut+4000;//+ 4 secondes au pif

function HTTP_Interfaces: THTTP_Interfaces;
function HTTP_Interface: THTTP_Interface;

function blHTTP_Interface_from_sl_sCle( sl: TBatpro_StringList; sCle: String): THTTP_Interface;

function fgl_check_synchronize( n:integer): integer; cdecl;
function fgl_http_fermer( n:integer): integer; cdecl;
function fgl_http_set_launchurl_callback( n:integer): integer; cdecl;
function fgl_ouverture_hors_web_component( n:integer): integer; cdecl;

function http_getS( _URL: String): String;

implementation

function fgl_check_synchronize( n:integer): integer; cdecl;
begin
     //Log.PrintLn(  'uHTTP_Interface.fgl_check_synchronize');
     CheckSynchronize();
     Result:=  0;
end;

function fgl_http_set_launchurl_callback( n:integer): integer; cdecl;
var
   LaunchURL_Callback: String;
   Name: String;
   hi: THTTP_Interface;
begin
     LaunchURL_Callback:= popString;
     Name:= popString;
     Result:= 0;

     HTTP_Interfaces.Set_LaunchURL_Callback( Name, LaunchURL_Callback);
end;

function fgl_http_fermer( n:integer): integer; cdecl;
var
   Name: String;
   hi: THTTP_Interface;
begin
     Name:= popString;
     Result:=  0;

     hi:= HTTP_Interfaces._from_Name( Name);
     if nil = hi then exit;

     Log.PrintLn(  'uHTTP_Interface.fgl_http_fermer("'+Name+'"): Arrêt du http');
     hi.Terminated:= True;
end;

function fgl_ouverture_hors_web_component( n:integer): integer; cdecl;
var
   Name: String;
   hi: THTTP_Interface;
begin
     Name:= popString;
     Result:=  0;

     hi:= HTTP_Interfaces._from_Name( Name);
     if nil = hi then exit;

     hi.Ouverture_hors_Web_component;
end;

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

function http_getS( _URL: String): String;
{$ifdef android}
  type TFPHttpClient= jHttpClient;
{$endif}
var
   c: TFPHttpClient;
begin
     try
        c:= TFPHttpClient.Create( nil);
        try
           Result:= c.Get( _URL);
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             //Log.Println( 'http_getS( '+_URL+'): '+E.Message);
             end;
           end;

     //Log.Println( 'http_getS( '+_URL+')= ');
     //Log.Println('################');
     //Log.Println( Result);
     //Log.Println('################')
end;

procedure Execute_par_Run_Command( _Nom_Executable:String);
var
   Resultat: ansistring;
begin
     if RunCommand('/bin/bash',['-c',_Nom_Executable+' &'],Resultat)
     then
         Log.Println('Execute_par_Run_Command( '+_Nom_Executable+'):'+Resultat);
end;

procedure Execute_par_TProcess_et_bash( _Nom_Executable:String);
var
   p: TProcess;
   I: Integer;
begin
     p := TProcess.Create(nil);
     try
        p.InheritHandles := False;
        p.Options := [];
        p.ShowWindow := swoShow;

        // Copy default environment variables including DISPLAY variable for GUI application to work
        for I := 1 to GetEnvironmentVariableCount do
          p.Environment.Add(GetEnvironmentString(I));

        p.Executable := '/bin/bash';
        p.Parameters.Add('-c');
        p.Parameters.Add(_Nom_Executable+' &');
        p.Execute;
     finally
            p.Free;
            end;
end;

procedure Execute_par_TProcess( _Nom_Executable:String);
var
   p: TProcess;
   I: Integer;
begin
     p := TProcess.Create(nil);
     try
        p.InheritHandles := False;
        p.Options := [];
        p.ShowWindow := swoShow;

        // Copy default environment variables including DISPLAY variable for GUI application to work
        for I := 1 to GetEnvironmentVariableCount do
          p.Environment.Add(GetEnvironmentString(I));

        p.Executable := _Nom_Executable;
        p.Execute;
     finally
            p.Free;
            end;
end;

{ THTTP_Interfaces }

var
   FHTTP_Interfaces: THTTP_Interfaces= nil;

function HTTP_Interfaces: THTTP_Interfaces;
begin
     if nil = FHTTP_Interfaces
     then
         FHTTP_Interfaces:= THTTP_Interfaces.Create;
     Result:= FHTTP_Interfaces;
end;

constructor THTTP_Interfaces.Create;
begin
     Log.PrintLn( 'THTTP_Interfaces.Create: début');
     slPool:= Tslpool_Ancetre_Ancetre.Create( ClassName+'.slPool');
     sl:= TslHTTP_Interface.Create( ClassName+'.sl');
     slLaunchURL_Callback:= TStringList.Create;
end;

destructor THTTP_Interfaces.Destroy;
begin
     Free_nil( slLaunchURL_Callback);
     Free_nil( sl);
     Free_nil( slPool);
     inherited Destroy;
end;

procedure THTTP_Interfaces.Ajoute( _hi: THTTP_Interface);
begin
     if nil = _hi then exit;

     sl.AddObject( _hi.Name, _hi);
end;

procedure THTTP_Interfaces.Enleve(_hi: THTTP_Interface);
var
   I: Integer;
begin
     I:= sl.IndexOfObject( _hi);
     if -1 = I then exit;
     sl.Delete(I);
end;

function THTTP_Interfaces._from_Name( _Name: String): THTTP_Interface;
begin
     Result:= blHTTP_Interface_from_sl_sCle( sl, _Name);
     if Assigned( Result) then exit;

     Log.PrintLn( 'HTTP_Interfaces._from_Name: HTTP_Interface non trouvé pour Name = '+_Name);
end;

procedure THTTP_Interfaces.Register_pool(_pool: Tpool_Ancetre_Ancetre);
var
   pool_sCle: String;
begin
     pool_sCle:= _pool.NomTable_public;
     if -1 = slPool.IndexOf( pool_sCle)
     then
         slPool.AddObject( pool_sCle, _pool);
end;

procedure THTTP_Interfaces.Verification_http_inactif;
var
   I: TIterateur_HTTP_Interface;
   hi: THTTP_Interface;
begin
     Log.PrintLn( 'HTTP_Interfaces.Verification_http_inactif; début');
     I:= sl.Iterateur;
     Log.PrintLn( 'HTTP_Interfaces.Verification_http_inactif; avant while I.Continuer');
     while I.Continuer
     do
       begin
       Log.PrintLn( 'HTTP_Interfaces.Verification_http_inactif; avant if I.not_Suivant( hi) then continue;');
       if I.not_Suivant( hi) then continue;

       Log.PrintLn( 'HTTP_Interfaces.Verification_http_inactif; avant hi.Verification_http_inactif;');
       hi.Verification_http_inactif;
       end;
     Log.PrintLn( 'HTTP_Interfaces.Verification_http_inactif; fin');
end;

procedure THTTP_Interfaces.Set_LaunchURL_Callback( _Name, _Value: String);
begin
     slLaunchURL_Callback.Values[_Name]:= _Value;
     Log.PrintLn( 'HTTP_Interfaces.Set_LaunchURL_Callback( '+_Name+', '+_Value+')');
end;

function THTTP_Interfaces.LaunchURL_Callback( _Name: String): String;
var
   I: Integer;
begin
     I:= slLaunchURL_Callback.IndexOfName( _Name);
     if -1 = I
     then
         Result:= uHTTP_Interface_DefaultLaunchURL_Callback
     else
         Result:= slLaunchURL_Callback.ValueFromIndex[ I];
end;

{ TIterateur_HTTP_Interface }

function TIterateur_HTTP_Interface.not_Suivant( var _Resultat: THTTP_Interface): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_HTTP_Interface.Suivant( var _Resultat: THTTP_Interface);
begin
     Suivant_interne( _Resultat);
end;

{ TslHTTP_Interface }

constructor TslHTTP_Interface.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, THTTP_Interface);
end;

destructor TslHTTP_Interface.Destroy;
begin
     inherited;
end;

class function TslHTTP_Interface.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_HTTP_Interface;
end;

function TslHTTP_Interface.Iterateur: TIterateur_HTTP_Interface;
begin
     Result:= TIterateur_HTTP_Interface( Iterateur_interne);
end;

function TslHTTP_Interface.Iterateur_Decroissant: TIterateur_HTTP_Interface;
begin
     Result:= TIterateur_HTTP_Interface( Iterateur_interne_Decroissant);
end;

{ THTTP_Interface }

var
   FHTTP_Interface: THTTP_Interface= nil;

function HTTP_Interface: THTTP_Interface;
begin
     if nil = FHTTP_Interface
     then
         FHTTP_Interface:= THTTP_Interface.Create( 'HTTP_Interface');
     Result:= FHTTP_Interface;
end;

function blHTTP_Interface_from_sl_sCle( sl: TBatpro_StringList; sCle: String): THTTP_Interface;
begin
     _Classe_from_sl_sCle( Result, THTTP_Interface, sl, sCle);
end;

constructor THTTP_Interface.Create( _Name: String);
begin
     Name:= _Name;
     Terminated:= True;

     S:= nil;
     DocumentRoot:= IncludeTrailingPathDelimiter( uClean_HTML_from_EXE( uClean_EXE_Name));
     Racine:= '';
     slP   := TslAbonnement_Procedure.Create( ClassName+'.slP');
     slO   := TslAbonnement_Objet    .Create( ClassName+'.slO');

     URL_Externe_from_ini;

     Lire_Ouvrir_hors_Web_component;

     th:= nil;
     Modal:= True;
     InitCriticalSection( fgl_putfile_interne_CriticalSection);
     InitCriticalSection( lg_Traite_Fichier_Genere_interne_CriticalSection);

     Charge_CORS_Value;

     HTTP_Interfaces.Ajoute(Self);
end;

destructor THTTP_Interface.Destroy;
begin
     HTTP_Interfaces.Enleve( Self);

     DoneCriticalSection( lg_Traite_Fichier_Genere_interne_CriticalSection);
     DoneCriticalSection( fgl_putfile_interne_CriticalSection);
     Free_nil( slP   );
     Free_nil( slO   );
     inherited Destroy;
end;

procedure THTTP_Interface.Lire_Ouvrir_hors_Web_component;
var
   Identifier: String;
   sOuvrir_hors_Web_component: String;
begin
     Ouvrir_hors_Web_component:= False;

     Identifier:= EXE_INI.os+ClassName+'.Ouvrir_hors_Web_component';
     sOuvrir_hors_Web_component
     :=
       EXE_INI.ReadString( 'Options', Identifier, '#');
     if '#' = sOuvrir_hors_Web_component
     then
         EXE_INI.WriteString( 'Options', Identifier, '0')
     else
         Ouvrir_hors_Web_component:= '1' = sOuvrir_hors_Web_component;

end;

procedure THTTP_Interface.Init_from_ClassName(_ClassName: String; _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
begin
     Racine:= _ClassName;
     if Racine = '' then exit;

     if 'T' = UpperCase( Racine[1])
     then
         Delete( Racine, 1, 1);

     Log.PrintLn('Racine='+Racine);
     slO.Ajoute( Racine, _Objet, _Proc);
end;

procedure THTTP_Interface.Send_Header( _Content_type: String;
                                       _Content_Length: Integer; _Filename: String= '');
begin
     Log.Println( ClassName+'.Send_Header( '+_Content_type+', '+IntToStr(_Content_Length)+', '+_Filename+')');
     S.SendString('HTTP/1.0 200' + CRLF);
     if _Content_type <> ''
     then
         S.SendString('Content-type: '+_Content_type + CRLF);
     if _Filename <> ''
     then
         S.SendString('Content-Disposition: attachment; filename="'+ExtractFileName(_Filename)+'"'+CRLF);
     S.SendString('Content-length: ' + IntTostr( _Content_Length) + CRLF);
     S.SendString('Connection: close' + CRLF);
     S.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
     S.SendString('Server: http_jsWorks' + CRLF);

     S.SendString('Access-Control-Allow-Origin: '+CORS_Value + CRLF);
     //d'aprés https://developer.mozilla.org/fr/docs/Web/HTTP/Headers/Access-Control-Allow-Origin#CORS_et_le_cache
     if '*'<>CORS_Value
     then
         begin
         S.SendString('Vary: Origin'+ CRLF);
         //d'aprés https://developer.mozilla.org/fr/docs/Web/HTTP/Headers/Origin#Syntaxe
         S.SendString('Origin: '+ CRLF); //il faudrait peut-être mettre le domaine de l'appelant
         end;

     S.SendString('' + CRLF);
     //  if S.lasterror <> 0 then HandleError;
end;

procedure THTTP_Interface.Send_Data( _Content_type, _Data: String);
var
   Morceau: String;
begin
     Send_Header( _Content_type, Length(_Data));

     //découpage en kilo-octets
     while Length(_Data) > 0
     do
       begin
       Morceau:= StrReadString(_Data, 1024);
       S.SendString(Morceau);
       end;
end;

procedure THTTP_Interface.Send_Fichier( _NomFichier: String);
   procedure Traite;
   var
      Content_type: String;
      Contenu_Fichier: String;
   begin
        Content_type   :=Content_type_from_NomFichier( _NomFichier);
        Contenu_Fichier:= String_from_File( _NomFichier);
        Send_Data( Content_type, Contenu_Fichier);
   end;
begin
     Log.PrintLn( ClassName+'.Send_Fichier('''+_NomFichier+''')');
     if FileExists( _NomFichier)
     then
         Traite
     else
         Send_Not_found;
end;

procedure THTTP_Interface.Send_HTML( _HTML: String);
begin
     Send_Data( 'text/html', _HTML);
end;

procedure THTTP_Interface.Send_JSON( _JSON: String);
begin
     //Send_Data( 'text/json;charset=utf-8', _JSON);
     Send_Data( 'application/json;charset=utf-8', _JSON);
     //Send_Data( 'text/json;charset=iso-8859-1', _JSON);
     //Send_Data( 'text/json', _JSON);
end;

procedure THTTP_Interface.Send_Text(_Text: String);
begin
     Send_Data( 'text/plain;charset=utf-8', _Text);
end;

procedure THTTP_Interface.Send_JS(_JS: String);
begin
     Send_Data( 'text/js;charset=utf-8', _JS);
end;

procedure THTTP_Interface.Send_CSS(_CSS: String);
begin
     Send_Data( 'text/css;charset=utf-8', _CSS);
end;

procedure THTTP_Interface.Send_WOFF(_WOFF: String);
begin
     Send_Data( 'application/font-woff', _WOFF);
end;

procedure THTTP_Interface.Send_WOFF2(_WOFF2: String);
begin
     Send_Data( 'font/woff2', _WOFF2);
end;

procedure THTTP_Interface.Send_ICO(_ICO: String);
begin
     Send_Data( 'image/x-icon', _ICO);
end;

procedure THTTP_Interface.Send_MIME_from_Extension( _S, _Extension: String);
     function not_Traite_MIME: Boolean;
     var
        MimeType: String;
     begin
          MimeType:= MimeType_from_Extension( _Extension);
          Result:= '' = MimeType;
          if Result then exit;

          Send_Data( MimeType, _S);
     end;
begin
          if '.html'  = _Extension then Send_HTML ( _S)
     else if '.js'    = _Extension then Send_JS   ( _S)
     else if '.json'  = _Extension then Send_JSON ( _S)
     else if '.css'   = _Extension then Send_CSS  ( _S)
     else if '.map'   = _Extension then Send_JS   ( _S)
     else if '.woff'  = _Extension then Send_WOFF ( _S)
     else if '.woff2' = _Extension then Send_WOFF2( _S)
     else if '.ico'   = _Extension then Send_ICO  ( _S)
     else if not not_Traite_MIME
     then
         begin
         Send_HTML( _S);
         Log.PrintLn( '#### Extension inconnue '+_Extension+' pour :'#13#10+uri);
         end;
end;

procedure THTTP_Interface.Send_Not_found;
begin
     Log.PrintLn( ClassName+'.Send_Not_found');
     S.SendString('HTTP/1.0 404' + CRLF);
end;

function THTTP_Interface.Content_type_from_NomFichier( _NomFichier: String): String;
begin
     Result:= MimeType_from_Extension( ExtractFileExt( _NomFichier));
end;

procedure THTTP_Interface.Traite_fichier( _NomFichier: String);
var
   Chemin: String;
begin
     DoDirSeparators( _NomFichier);
     Chemin:= DocumentRoot+Racine+DirectorySeparator+_NomFichier;
     //WriteLn( 'THTTP_Interface.Traite_fichier, Racine= '+Racine+'  Chemin= '+Chemin);
     if FileExists( Chemin)
     then
         Send_Fichier( Chemin)
     else
         Send_Not_found;
end;

procedure THTTP_Interface.Traite_racine;
begin
     Traite_fichier( 'index.html');
end;

procedure THTTP_Interface.Traite_fichier;
begin
     Log.PrintLn( ClassName+'.Traite_fichier: '+uri+' OK');
     Traite_fichier( uri);
end;

function THTTP_Interface.Prefixe( _Prefixe: String): Boolean;
var
   Prefixe_lowercase: String;
   Longueur: Integer;
begin
     Prefixe_lowercase:= LowerCase( _Prefixe);

     Result:= 1=Pos( Prefixe_lowercase, uri_lowercase);
     if not Result then exit;

     Longueur:= Length( _Prefixe);
     Delete( uri          , 1, Longueur);
     Delete( uri_lowercase, 1, Longueur);
end;

function THTTP_Interface.Traite_slP_slO: Boolean;
   function Traite_slP: Boolean;
   var
      I: Integer;
      ap: TAbonnement_Procedure;
   begin
        Log.PrintLn( ClassName+'.Traite_slP_slO: Traite_slP');
        Result:= False;
        for I:= 0 to slP.Count - 1
        do
          begin
          if not Prefixe( slP[I]) then continue;

          ap:= Abonnement_Procedure_from_sl( slP, I);
          if nil = ap then continue;

          Log.PrintLn( ClassName+'.Traite_slP_slO: Traite_slP '+slP[I]+' OK');

          ap.DoProc;
          Result:= True;
          exit; //Sortie normale
          end;
   end;
   function Traite_slO: Boolean;
   var
      I: Integer;
      ao: TAbonnement_Objet;
   begin
        Log.PrintLn( ClassName+'.Traite_slP_slO: Traite_slO');
        Result:= False;
        for I:= 0 to slO.Count - 1
        do
          begin
          if not Prefixe( slO[I]) then continue;

          ao:= Abonnement_Objet_from_sl( slO, I);
          if nil = ao then continue;

          Log.PrintLn( ClassName+'.Traite_slP_slO: Traite_slO '+slO[I]+' OK');

          ao.DoProc;
          Result:= True;
          exit; //Sortie normale
          end;
   end;
begin
     Result:= Traite_slP;
     if Result then exit;

     Result:= Traite_slO;
     if Result then exit;
end;

function THTTP_Interface.Traite_Prefixe_Fichier( _Prefixe: String): Boolean;
begin
     Result:= Prefixe( _Prefixe);
     if not Result then exit;

     Log.PrintLn( ClassName+'.Traite_Prefixe_Fichier '+_Prefixe+' OK');

     Traite_fichier(_Prefixe+uri);
end;

function THTTP_Interface.Traite_pool: Boolean;
var
   I: TIterateur_pool_Ancetre_Ancetre;
   pool: Tpool_Ancetre_Ancetre;
begin
     Result:= False;
     I:= HTTP_Interfaces.slPool.Iterateur;

     while I.Continuer
     do
       begin
       if I.not_Suivant( pool) then continue;

       if not Prefixe( pool.NomTable_public) then continue;

       Log.PrintLn( ClassName+'.Traite_pool '+pool.NomTable_public+' OK');
       Result:= pool.Traite_HTTP( Self);
       if Result then exit;
       end;
end;

function THTTP_Interface.Traite_Chrono: Boolean;
begin
     Result:= Prefixe( 'Chrono');
     if not Result then exit;

     Log.PrintLn( ClassName+'.Traite_Chrono OK');
     Send_JSON( '"'+Chrono.Get_Liste+'"');
end;

procedure THTTP_Interface.Traite;
begin
     Log.PrintLn( ClassName+'.Traite '+uri+' début');
     //WriteLn('THTTP_Interface.Traite uri='+uri);

     StrTok( '/', uri);

     uri_lowercase:= LowerCase( uri);

     if '' = uri
     then
         Traite_racine
     else if not Traite_Prefixe_Fichier( 'image/')
     then if not Traite_Prefixe_Fichier( 'js/')
     then if not Traite_Prefixe_Fichier( 'css/')
     then if not Traite_slP_slO
     then if not Traite_pool
     then if not Traite_Chrono
     then        Traite_fichier;
     Log.PrintLn( ClassName+'.Traite '+uri+' fin');
end;

procedure THTTP_Interface.URL_Externe_from_ini;
var
   inik_URL_Externe: String;
begin
     inik_URL_Externe:= EXE_INI.os+'URL_Externe';

     URL_Externe:= EXE_INI.ReadString( 'Options', inik_URL_Externe, '#');
     if '#' = URL_Externe
     then
         begin
         URL_Externe:= EXE_INI.ReadString( 'Options', 'URL_Externe', '#');
         if '#' = URL_Externe
         then
             URL_Externe:= 'http://localhost:1500/';
         EXE_INI.WriteString( 'Options', inik_URL_Externe, URL_Externe);
         end;
end;

procedure THTTP_Interface.AttendConnection(ASocket: TTCPBlockSocket);
var
   timeout: integer;
   s: string;
   method, protocol: string;
   OutputDataString: string;
   ResultCode: integer;
   Content_Length: Integer;
   Has_Body: Boolean;
   function Prefixe( _Prefixe: String): Boolean;
   begin
        Result:= 1=Pos( _Prefixe,uri);
        if not Result then exit;
        StrTok( _Prefixe, uri);
   end;
   procedure Traite_Content_Length;
   var
      sContent_Length: String;
   begin
        StrToK( ':', s);
        sContent_Length:= Trim( s);
        Log.PrintLn('Valeur content-length:>'+sContent_Length+'<');

        Has_Body:= TryStrToInt( sContent_Length, Content_Length);
        Log.PrintLn('Valeur Has_Body: '+BoolToStr( Has_Body, True));
   end;
   procedure RecvBody;
   begin
        body:= ASocket.RecvBufferStr( Content_Length,
                                      uHTTP_Interface_Socket_TimeOut);
        Log.PrintLn('Body:');
        Log.PrintLn( body);
   end;
begin
     Self.S:= ASocket;

     Log.PrintLn('Socket remote: '+ASocket.GetRemoteSinIP+':'+IntToStr(ASocket.GetRemoteSinPort));
     Log.PrintLn('Socket local : '+ASocket.GetLocalSinIP +':'+IntToStr(ASocket.GetLocalSinPort ));
     timeout := 120000;

     Log.PrintLn('Received headers+document from browser:');

     //read request line
     s := ASocket.RecvString(timeout);
     Log.PrintLn(s);
     method  := fetch(s, ' ');
     uri     := fetch(s, ' ');
     protocol:= fetch(s, ' ');
     body:= '';
     Has_Body:= False;

     //read request headers
     repeat
           s:= ASocket.RecvString(Timeout);
           Log.PrintLn(s);
           if 1 = Pos('content-length', LowerCase(s))
           then
               Traite_Content_Length;
     until (s = '');

     Log.PrintLn('headers received');

     if Has_Body
     then
         RecvBody;

     Synchronize( Traite); //modifié avec Synchronize pour utilisation dans jsWorks
end;

procedure THTTP_Interface.Verification_http_inactif;
begin
     Log.PrintLn( 'HTTP_Interface.Verification_http_inactif; début Name='+Name);
     if not Terminated
     then
         begin
         Terminated:= True;
         Sleep( uHTTP_Interface_Terminer_Sleep);
         end;

     if Assigned( th)
     then
         Log.PrintLn(  ClassName+'.Verification_http_inactif: risque de plantage, '
                      +'le thread http est affecté, peut-être que '
                      +'la fonction fgl_http_fermer() n''a pas été appelée dans le 4gl'
                      +'à la fermeture de la dernière interface html d''une fonction freepascal');
end;

procedure THTTP_Interface.Synchronize( _Method: TThreadMethod);
begin
     if Modal
     then
         _Method()
     else
         if Assigned(th)
         then
             th.Synchronize( _Method);
end;

procedure THTTP_Interface.fgl_putfile_interne;
begin
     Log.PrintLn(  ClassName+'.fgl_putfile_interne: avant exécution synchronisée de fgl_putfile');
     fglExt.fgl_putfile( fgl_putfile_interne_NomFichier_cote_serveur,
                         fgl_putfile_interne_NomFichier_cote_client );
     Log.PrintLn(  ClassName+'.fgl_putfile_interne: aprés exécution synchronisée de fgl_putfile');
     fgl_putfile_interne_NomFichier_cote_serveur:= '';
end;

procedure THTTP_Interface.fgl_putfile( _NomFichier_cote_serveur, _NomFichier_cote_client: String);
begin
     Log.PrintLn(  ClassName+'.fgl_putfile: avant EnterCriticalsection');
     EnterCriticalsection( fgl_putfile_interne_CriticalSection);
     try
        fgl_putfile_interne_NomFichier_cote_serveur:= _NomFichier_cote_serveur;
        fgl_putfile_interne_NomFichier_cote_client := _NomFichier_cote_client ;

        Log.PrintLn(  ClassName+'.fgl_putfile: avant Synchronize');
        Synchronize( fgl_putfile_interne);
     finally
            Log.PrintLn(  ClassName+'.fgl_putfile: avant LeaveCriticalsection');
            LeaveCriticalsection( fgl_putfile_interne_CriticalSection);
            end;
     Log.PrintLn(  ClassName+'.fgl_putfile: fin');
end;

procedure THTTP_Interface.do_lg_HTTP_Interface_Terminate;
begin
     fglExt.lg_HTTP_Interface_Terminate;
end;

procedure THTTP_Interface.lg_HTTP_Interface_Terminate;
begin
     Synchronize( do_lg_HTTP_Interface_Terminate);
end;

procedure THTTP_Interface.lg_Traite_Fichier_Genere_interne;
begin
     Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere_interne: avant exécution synchronisée de lg_Traite_Fichier_Genere');
     fglExt.lg_Traite_Fichier_Genere( lg_Traite_Fichier_Genere_Fonction,
                                      lg_Traite_Fichier_Genere_Fichier_genere );
     Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere_interne: aprés exécution synchronisée de lg_Traite_Fichier_Genere');
     lg_Traite_Fichier_Genere_Fichier_genere:= '';
end;

procedure THTTP_Interface.lg_Traite_Fichier_Genere( _Fonction, _Fichier_genere: String);
begin
     Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere: avant EnterCriticalsection');
     EnterCriticalsection( lg_Traite_Fichier_Genere_interne_CriticalSection);
     try
        lg_Traite_Fichier_Genere_Fonction      := _Fonction;
        lg_Traite_Fichier_Genere_Fichier_genere:= _Fichier_genere ;

        Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere: avant Synchronize');
        Synchronize( lg_Traite_Fichier_Genere_interne);
     finally
            Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere: avant LeaveCriticalsection');
            LeaveCriticalsection( lg_Traite_Fichier_Genere_interne_CriticalSection);
            end;
     Log.PrintLn(  ClassName+'.lg_Traite_Fichier_Genere: fin');
end;

function THTTP_Interface.GetLaunchURL_Callback: String;
begin
     Result:= HTTP_Interfaces.LaunchURL_Callback( Name);
end;

procedure THTTP_Interface.SetLaunchURL_Callback( _Value: String);
begin
     HTTP_Interfaces.Set_LaunchURL_Callback( Name, _Value);
end;

procedure THTTP_Interface.Charge_CORS_Value;
//Gestion des requêtes multi-origine Cross-Origin Request CORS
//valeur de l'entête Access-Control-Allow-Origin,
// * en dev,
// à restreindre en prod: Access-Control-Allow-Origin: https://developer.mozilla.org
const
    inik_CORS='THTTP_Interface.Access-Control-Allow-Origin_CORS';
begin
     CORS_Value:= EXE_INI.ReadString( inis_Options, inik_CORS, '#');
     if '#' = CORS_Value
     then
         begin
         CORS_Value:= 'http://localhost:4200';//l'url utilisée par ng serve pour mise au point Angular
         EXE_INI.WriteString( inis_Options, inik_CORS, CORS_Value);
         end;
end;

function THTTP_Interface.Test_Port( _Port: Integer): Boolean;
var
   s: TTCPBlockSocket;
begin
     Result:= False;
     s:= TTCPBlockSocket.Create;
     try
        s.CreateSocket;
        s.setLinger(true,10);
        s.bind('0.0.0.0',IntToStr( _Port));
        s.Listen;

        Result:= _Port = s.GetLocalSinPort;
     finally
            FreeAndnil( s);
            end;
end;

function THTTP_Interface.Init( _IP: String='127.0.0.1'; _Port: Integer=0): String;
begin
     Verification_http_inactif;

     Terminated:= False;

     ListenerSocket  := TTCPBlockSocket.Create;
     ConnectionSocket:= TTCPBlockSocket.Create;

     ListenerSocket.CreateSocket;
     ListenerSocket.setLinger(true,10);
     //ListenerSocket.bind('0.0.0.0','1500');
     //ListenerSocket.bind('127.0.0.1','0');
     ListenerSocket.bind(_IP,IntToStr(_Port));
     ListenerSocket.listen;
     Port:= ListenerSocket.GetLocalSinPort;
     sPort:=IntToStr(Port);
     URL_interne:='http://'+_IP+':'+sPort+'/';
     URL:= URL_Externe+sPort+'/';
     Result:= URL;
     Execute_LaunchURL:= True;
end;

procedure THTTP_Interface.Loop_body;
var
   LastError: Integer;
begin
     if False//Execute_LaunchURL   //désactivé en dehors d'Adibat
     then
         if Modal
         then
             LaunchURL
         else
             Synchronize( LaunchURL);

     if not ListenerSocket.canread( uHTTP_Interface_Loop_body_TimeOut) then exit;

     ConnectionSocket.Socket := ListenerSocket.accept;
     LastError:= ConnectionSocket.lasterror;
     if 0 <> LastError
     then
         Log.PrintLn('Attending Connection. Error code (0=Success): '+IntToStr(LastError));
     AttendConnection(ConnectionSocket);
     ConnectionSocket.CloseSocket;
end;

procedure THTTP_Interface.Loop_end;
begin
     FreeAndNil( ListenerSocket  );
     FreeAndNil( ConnectionSocket);
     HTTP_Interfaces.Set_LaunchURL_Callback( Name, uHTTP_Interface_DefaultLaunchURL_Callback);
     Log.PrintLn('http_run terminé');
end;

{ début THTTP_Interface_thread}
constructor THTTP_Interface_thread.Create;
begin
     hi:= nil;
     FreeOnTerminate := True;
     inherited Create(True);
end;

procedure THTTP_Interface_thread.Execute;
begin
     if hi = nil
     then
         begin
         exit;
         end;
     while not (Terminated or hi.Terminated)
     do
       hi.Loop_body;

     hi.Loop_end;
     if hi.th = Self then hi.th:= nil;
end;

{ fin THTTP_Interface_thread}

procedure THTTP_Interface.Run( _Modal: Boolean= True);
    procedure Cas_Modal;
    begin
         Log.PrintLn(  ClassName+'.Run::Cas_Modal: Début exécution en monotâche');
         while not Terminated
         do
           Loop_body;
         Loop_end;
    end;
    procedure Cas_Multitache;
    begin
         Log.PrintLn(  ClassName+'.Run::Cas_Multitache: Début exécution en multithread');
         th:= THTTP_Interface_thread.Create;
         Log.PrintLn(  ClassName+'.Run::Cas_Multitache: aprés création thread secondaire');
         th.hi:= Self;
         th.Start;
         Log.PrintLn(  ClassName+'.Run::Cas_Multitache: aprés démarrage thread secondaire');
    end;
begin
     Modal:= _Modal;
     if Modal
     then
         Cas_Modal
     else
         Cas_Multitache;
end;

procedure THTTP_Interface.do_fgl_call_LaunchURL(_CallBack: String);
begin
     {$IFDEF FPC}
     Log.PrintLn('uHTTP_Interface.LaunchURL: avant fgl_call( '''+_CallBack+''', 1); '+URL);
     pushString( URL);
     fgl_call( PChar(_CallBack), 1);
     Log.PrintLn('uHTTP_Interface.LaunchURL: aprés fgl_call( '''+_CallBack+''', 1); '+URL);
     {$ENDIF}
end;

procedure THTTP_Interface.Ouverture_hors_Web_component;
begin
     do_fgl_call_LaunchURL( uHTTP_Interface_DefaultLaunchURL_Callback);
end;

procedure THTTP_Interface.LaunchURL;
   procedure Traite_fgl;
   var
      LaunchURL_Callback: String;
   begin
        LaunchURL_Callback:= HTTP_Interfaces.LaunchURL_Callback( Name);
        //provisoire, appel du callback qui ouvre un nouvel onglet
        //si le callback défini n'est pas le callback par défaut (cas webcomponent)
        Log.PrintLn('uHTTP_Interface.LaunchURL: LaunchURL_Callback='+LaunchURL_Callback);
        Log.PrintLn('uHTTP_Interface.LaunchURL: uHTTP_Interface_DefaultLaunchURL_Callback='+uHTTP_Interface_DefaultLaunchURL_Callback);
        if     Ouvrir_hors_Web_component
           and (uHTTP_Interface_DefaultLaunchURL_Callback <> LaunchURL_Callback)
        then
            Ouverture_hors_Web_component;

        //Appel du callback défini
        do_fgl_call_LaunchURL( LaunchURL_Callback);
   end;
   procedure Traite_direct;
   begin
        Log.PrintLn('uHTTP_Interface.LaunchURL: ShowURL( URL); '+URL);
        ShowURL( URL);
   end;
begin
     Execute_LaunchURL:= False;
     {$IFDEF LINUX}
     Traite_fgl;
     {$ELSE}
     //Traite_direct;
     Traite_fgl;
     {$ENDIF}
end;


initialization

finalization
            FreeAndNil( FHTTP_Interface);
end.

