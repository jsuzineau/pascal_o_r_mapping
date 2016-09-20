unit uHTTP_Interface;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    uClean,
    uuStrings,
    uBatpro_StringList,
    uBatpro_Element,
    uPublieur,
    uLog,
    uEXE_INI,
 {$ifdef fpc}
 {fglExt,} blcksock, sockets, Synautil, fphttpclient,
 {$endif}
 Classes, SysUtils,process;

type

 { THTTP_Interface }

 THTTP_Interface
 =
  class( TThread)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    S: TTCPBlockSocket;
    Racine: String;
    slPool: Tslpool_Ancetre_Ancetre;
  //méthodes d'envoi de données
  public
    procedure Send_Data(_Content_type, _Data: String);
    procedure Send_HTML(_HTML: String);
    procedure Send_JSON(_JSON: String);
    procedure Send_JS(_JS: String);
    procedure Send_CSS(_CSS: String);
    procedure Send_WOFF(_WOFF: String);
    procedure Send_WOFF2(_WOFF2: String);
    procedure Send_MIME_from_Extension(_S, _Extension: String);
    function MIME_from_Extension( _Extension: String): String;
    procedure Send_Not_found;
    procedure Traite_racine;
  //enregistrement d'un pool
  private
    procedure Traite_pool;
  public
    procedure Register_pool( _pool: Tpool_Ancetre_Ancetre);
  //gestion de callbacks
  private
    function Traite_slP_slO: Boolean;
  public
    slP: TslAbonnement_Procedure;
    slO: TslAbonnement_Objet;
  //Traitement des appels
  public
    uri: String;
    function Prefixe( _Prefixe: String): Boolean;
    procedure Traite( _uri: String);
  //Gestion de l'exécution, partie commune
  private
    ListenerSocket, ConnectionSocket: TTCPBlockSocket;
    procedure AttendConnection(ASocket: TTCPBlockSocket);
    procedure Terminaison;
  private
     Execute_Running: Boolean;
  protected
     procedure Execute; override;
  public
    //Terminated: Boolean;
    function URL: String;
    function Initialisation: String;
    function Init: String;
    procedure fgl_LaunchURL( _URL: String);
  //Gestion de l'exécution monotâche
  public
    procedure Run;
  //Validation pour le PortMapper
  public
    procedure Traite_Validation;
  end;

function HTTP_Interface: THTTP_Interface;

function http_getS( _URL: String): String;

const
     port_http_PortMapper= '1500';

procedure Assure_http_PortMapper;

implementation

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

function http_getS( _URL: String): String;
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

function http_Port_Valide( _Port: String): Boolean;
var
   URL: String;
begin
     URL:= 'http://localhost:'+_Port+'/'+s_Validation;
     Result:= s_Validation_Response = http_getS( URL);
end;

function http_PortMapper_OK: boolean;
begin
     Result:= http_Port_Valide( port_http_PortMapper);
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

procedure Lance_http_PortMapper;
const
     Attente_secondes=10;
var
   Repertoire: String;
   NomFichier: String;
   procedure Attente_lancement;
   const
        Test_par_seconde=4;
        Temporisation_ms= 1000{ms} div Test_par_seconde;
   var
      I: Integer;
   begin
        for I:= 0 to Attente_secondes*Test_par_seconde
        do
          begin
          if http_PortMapper_OK then break;
          Sleep( Temporisation_ms);
          end;
   end;
   procedure Compose_NomFichier;
   const
        inik_http_PortMapper= 'http_PortMapper';
        NomExecutable
        =
         {$IFDEF LINUX}
           'http_PortMapper'
         {$ELSE}
           'http_PortMapper.exe'
         {$ENDIF}
         ;
   begin
        NomFichier:= EXE_INI.ReadString( inis_Options,inik_http_PortMapper,'#');
        if '#' <> NomFichier then exit;

        Repertoire:= IncludeTrailingPathDelimiter(GetCurrentDir);
        Log.Println('Lance_http_PortMapper: Repertoire:'+Repertoire);
        NomFichier:= Repertoire+NomExecutable;
        EXE_INI.WriteString(inis_Options,inik_http_PortMapper,NomFichier);
   end;
begin
     Compose_NomFichier;
     Log.Println('Lance_http_PortMapper: NomFichier:'+NomFichier);

     {$IFDEF LINUX}
       //Execute_par_Run_Command(NomFichier);
       Execute_par_TProcess_et_bash(NomFichier);
     {$ELSE}
       Execute_par_TProcess( NomFichier);
     {$ENDIF}
     Attente_lancement;
end;

procedure Assure_http_PortMapper;
begin
     if http_PortMapper_OK then exit;

     Lance_http_PortMapper;
end;

{ THTTP_Interface }

var
   FHTTP_Interface: THTTP_Interface= nil;

function HTTP_Interface: THTTP_Interface;
begin
     if nil = FHTTP_Interface
     then
         FHTTP_Interface:= THTTP_Interface.Create;
     Result:= FHTTP_Interface;
end;

constructor THTTP_Interface.Create;
begin
     inherited Create( True);
     FreeOnTerminate:= False;

     S:= nil;
     Racine:= '';
     slPool:= Tslpool_Ancetre_Ancetre.Create( ClassName+'.slPool');
     slP   := TslAbonnement_Procedure.Create( ClassName+'.slP');
     slO   := TslAbonnement_Objet    .Create( ClassName+'.slO');

     slO.Ajoute( 'Validation', Self, Traite_Validation);

     Execute_Running:= False;
end;

destructor THTTP_Interface.Destroy;
begin
     Terminate;

     Terminaison;
     Free_nil( slPool);
     Free_nil( slP   );
     Free_nil( slO   );
     inherited Destroy;
end;

procedure THTTP_Interface.Send_Data( _Content_type, _Data: String);
begin
     S.SendString('HTTP/1.0 200' + CRLF);
     S.SendString('Content-type: '+_Content_type + CRLF);
     S.SendString('Content-length: ' + IntTostr(Length(_Data)) + CRLF);
     S.SendString('Connection: close' + CRLF);
     S.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
     S.SendString('Server: http_jsWorks' + CRLF);
     S.SendString('' + CRLF);

    //  if S.lasterror <> 0 then HandleError;

     S.SendString(_Data);
end;

procedure THTTP_Interface.Send_HTML( _HTML: String);
begin
     Send_Data( 'Text/Html', _HTML);
end;

procedure THTTP_Interface.Send_JSON( _JSON: String);
begin
     Send_Data( 'text/json;charset=utf-8', _JSON);
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

function THTTP_Interface.MIME_from_Extension(_Extension: String): String;
begin
     Result:= '';

          if '.svg' = _Extension then Result:= 'image/svg+xml'
     else if '.eot' = _Extension then Result:= 'application/vnd.ms-fontobject'
     else if '.ttf' = _Extension then Result:= 'application/x-font-truetype';

end;

procedure THTTP_Interface.Send_MIME_from_Extension( _S, _Extension: String);
var
   MIME: String;
begin
     MIME:= MIME_from_Extension( _Extension);
          if MIME <> ''            then Send_Data( MIME, _S)
     else if '.html'  = _Extension then Send_HTML ( _S)
     else if '.js'    = _Extension then Send_JS   ( _S)
     else if '.json'  = _Extension then Send_JSON ( _S)
     else if '.css'   = _Extension then Send_CSS  ( _S)
     else if '.map'   = _Extension then Send_JS   ( _S)
     else if '.woff'  = _Extension then Send_WOFF ( _S)
     else if '.woff2' = _Extension then Send_WOFF2( _S)
     else
         begin
         Send_HTML( _S);
         Log.PrintLn( '#### Extension inconnue '+_Extension+' pour :'#13#10+uri);
         end;
end;

procedure THTTP_Interface.Send_Not_found;
begin
     S.SendString('HTTP/1.0 404' + CRLF);
end;

procedure THTTP_Interface.Traite_racine;
var
   sl: TStringList;
begin
     sl:= TStringList.Create;
     sl.LoadFromFile( Racine);
     Send_HTML( sl.Text);
     FreeAndNil( sl);
end;

procedure THTTP_Interface.Register_pool(_pool: Tpool_Ancetre_Ancetre);
begin
     slPool.AddObject( _pool.NomTable_public, _pool);
end;

function THTTP_Interface.Prefixe( _Prefixe: String): Boolean;
begin
     Result:= 1=Pos( _Prefixe, uri);
     if not Result then exit;
     StrTok( _Prefixe, uri);
end;

function THTTP_Interface.Traite_slP_slO: Boolean;
   function Traite_slP: Boolean;
   var
      I: Integer;
      ap: TAbonnement_Procedure;
   begin
        Result:= False;
        for I:= 0 to slP.Count - 1
        do
          begin
          if not Prefixe( slP[I]) then continue;

          ap:= Abonnement_Procedure_from_sl( slP, I);
          if nil = ap then continue;

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
        Result:= False;
        for I:= 0 to slO.Count - 1
        do
          begin
          if not Prefixe( slO[I]) then continue;

          ao:= Abonnement_Objet_from_sl( slO, I);
          if nil = ao then continue;

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

procedure THTTP_Interface.Traite_pool;
var
   I: TIterateur_pool_Ancetre_Ancetre;
   pool: Tpool_Ancetre_Ancetre;
begin
     I:= slPool.Iterateur;

     while I.Continuer
     do
       begin
       if I.not_Suivant( pool) then continue;

       if not Prefixe( pool.NomTable_public) then continue;

       if not pool.Traite_HTTP
       then
           Send_Not_found;
       exit; //Sortie normale
       end;

     Send_Not_found; //Erreur, aucun pool trouvé
end;

procedure THTTP_Interface.Traite( _uri: String);
begin
     uri:= _uri;

     StrTok( '/', uri);
     if '' = uri
     then
         Traite_racine
     else if not Traite_slP_slO
     then
         Traite_pool  ;
end;

procedure THTTP_Interface.AttendConnection(ASocket: TTCPBlockSocket);
var
   timeout: integer;
   s: string;
   method, uri, protocol: string;
   OutputDataString: string;
   ResultCode: integer;
   function Prefixe( _Prefixe: String): Boolean;
   begin
        Result:= 1=Pos( _Prefixe,uri);
        if not Result then exit;
        StrTok( _Prefixe, uri);
   end;
begin
     Self.S:= ASocket;

     timeout := 120000;

     Log.PrintLn('Received headers+document from browser:');

     //read request line
     s := ASocket.RecvString(timeout);
     Log.PrintLn(s);
     method := fetch(s, ' ');
     uri := fetch(s, ' ');
     protocol := fetch(s, ' ');

     //read request headers
     repeat
           s:= ASocket.RecvString(Timeout);
           Log.PrintLn(s);
     until s = '';

     // Now write the document to the output stream
     Traite( uri);
end;

function THTTP_Interface.URL: String;
var
   IP: String;
   Port: Integer;
begin
     Result:= '';
     if nil = ListenerSocket then exit;

     IP:= 'localhost';//provisoire à revoir
     //Port:= '1500';
     Port:= ListenerSocket.GetLocalSinPort;
     Result:= 'http://'+IP+':'+IntToStr(Port)+'/';
     Log.Println( ClassName+'.URL= '+Result);
end;

function THTTP_Interface.Initialisation: String;
begin
     ListenerSocket  := TTCPBlockSocket.Create;
     ConnectionSocket:= TTCPBlockSocket.Create;

     ListenerSocket.CreateSocket;
     ListenerSocket.setLinger(true,10);
     //ListenerSocket.bind('0.0.0.0','1500');
     ListenerSocket.bind('localhost','0');
     ListenerSocket.listen;

     Result:= URL;
end;

procedure THTTP_Interface.Terminaison;
begin
     while Execute_Running
     do
       Sleep( 1000);
     FreeAndNil( ListenerSocket  );
     FreeAndNil( ConnectionSocket);
end;

procedure THTTP_Interface.Execute;
begin
     if nil = ListenerSocket then exit;

     try
        Execute_Running:= True;
        repeat
          if not ListenerSocket.canread( 1000) then continue;

          ConnectionSocket.Socket := ListenerSocket.accept;
          Log.PrintLn('Attending Connection. Error code (0=Success): '+IntToStr(ConnectionSocket.lasterror));
          AttendConnection(ConnectionSocket);
          ConnectionSocket.CloseSocket;
        until Terminated;
     finally
            Execute_Running:= False;
            end;
end;

function THTTP_Interface.Init: String;
begin
     Terminaison;

     Assure_http_PortMapper;

     Result:= Initialisation;

     fgl_LaunchURL( Result);
end;

procedure THTTP_Interface.Run;
begin
     Execute;
end;

procedure THTTP_Interface.fgl_LaunchURL(_URL: String);
var
   lpstrURL: PChar;
   buff: array[0..2048] of Char;
begin
     {$IFDEF FPC}
     lpstrURL:= PChar( _URL);

     StrCopy(  buff, lpstrURL);
     //pushquote( buff,sizeof(buff));
     //fgl_call( 'affiche_url', 1);
     {$ENDIF}
end;

procedure THTTP_Interface.Traite_Validation;
begin
     Send_JSON( 'pascal_o_r_mapping');
end;


initialization

finalization
            FreeAndNil( FHTTP_Interface);
end.

