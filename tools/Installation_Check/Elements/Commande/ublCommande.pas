unit ublCommande;

{$mode objfpc}{$H+}

interface

uses
    u_sys_,
    uuStrings,
    uEXE_INI,
    uChamp,
    uBatpro_StringList,
    uBatpro_Element,
    uBatpro_Ligne,
 libssh2, blcksock,
 Classes, SysUtils;

type
    TInstallation_Check_String_Proc=  procedure (_S: String) of object;
    TthCommand= class;

    { TblCommande }

    TblCommande
    =
     class( TBatpro_Ligne)
     //Gestion du cycle de vie
     public
       constructor Create( _sl: TBatpro_StringList); reintroduce;

       destructor Destroy; override;
     //Initialisation
     public
       function Init( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                      _Commande: String; _Libelle: String=''): TblCommande;
     //Attributs
     protected
       th: TthCommand;
       Add_Line: TInstallation_Check_String_Proc;
       Commande: String;
       Libelle: String;
     //LED_Color
     public
       LED_Color: Integer;
       cLED_Color: TChamp;
     //Lancement du thread
     public
       procedure Execute;
     //CallBack appelé à la fin du thread
     public
        procedure Commande_Terminated; virtual;
     end;

    TIterateur_Commande
    =
     class( TIterateur)
     //Iterateur
     public
       procedure Suivant( var _Resultat: TblCommande);
       function  not_Suivant( var _Resultat: TblCommande): Boolean;
     end;

    TslCommande
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
       function Iterateur: TIterateur_Commande;
       function Iterateur_Decroissant: TIterateur_Commande;
     end;

    { TthCommand }

    TthCommand
    =
     class(TThread)
     //Gestion du cycle de vie
     public
       constructor Create( _Add_Line: TInstallation_Check_String_Proc);
       destructor Destroy; override;
     //Attributs
     private
       Add_Line: TInstallation_Check_String_Proc;
       Hostname, Username, Password: String;
     //Prompt
     public
       Prompt: String;
       lPrompt: Integer;
     //Gestion Connection
     private
       sock:TTCPBlockSocket;
       session:PLIBSSH2_SESSION;
       channel:PLIBSSH2_CHANNEL;
       ssend:string;
     //Méthodes
     protected
       procedure Execute; override;
     //Login
     private
       function not_Login: Boolean;
     //Lecture
     private
       IsLogin: Boolean;
       IsPrompt: Boolean;
     private
       function no_New_input: Boolean;
     //Gestion envoi
     private
       Wait_For_Command: Boolean;
       procedure Send( _S: String);
       procedure Process_Output;
     //Log
     private
       procedure Log_Add_Line(_S: String);
       procedure Log_Add_Text( _S: String);
     public
        slLog: TStringList;
     //Liste de commandes à exécuter
     public
       I: TIterateur_Commande;
       sl: TslCommande;
       procedure Ajoute_Commande( _Commande: TblCommande);
       function Next_Command: Boolean;
     //Terminaison
     public
        Commande: TblCommande;
        procedure Do_OnTerminated_interne;
        procedure Do_OnTerminated;
     //Tag
     public
       Tag: String;
     //Resultat
     public
       Resultat: String;
       slResultat: TStringList;
     //Ctrl+C pour arrêter
     public
       procedure Send_Ctrl_C;
     end;


implementation

{ TthCommand }

constructor TthCommand.Create( _Add_Line: TInstallation_Check_String_Proc);
begin
     Add_Line:= _Add_Line;
     HostName:= EXE_INI.Assure_String( 'HostName', '');
     UserName:= EXE_INI.Assure_String( 'UserName', '');
     PassWord:= EXE_INI.Assure_String( 'PassWord', '');
     Prompt  := EXE_INI.Assure_String( 'Prompt'  , '"(please quote the prompt)"');
     lPrompt:= Length( Prompt);

     slLog:= TStringList.Create;

     sl:= TslCommande.Create(ClassName+'.sl');
     I:= sl.Iterateur;

     IsLogin := True;
     IsPrompt:= False;
     Resultat:= '';
     slResultat:= TStringList.Create;
     Tag:= '';
     Commande:= nil;
     Wait_For_Command:= False;

     inherited Create(False);
end;

destructor TthCommand.Destroy;
begin
     libssh2_channel_free(channel);
     libssh2_session_disconnect(session,'Thank you for using sshtest');
     libssh2_session_free(session);
     sock.Free;

     FreeAndNil( sl);
     FreeAndNil( slLog);
     FreeAndNil(slResultat);

     inherited Destroy;
end;

function TthCommand.not_Login: Boolean;
var
   fingerprint:PAnsiChar;
   iFINGERPRINT:integer;
   sFINGERPRINT: String;
begin
     Result:= True;

     sock := TTCPBlockSocket.Create;
     sock.Connect(Hostname,'22');
     if sock.LastError<>0
     then
         begin
         Log_Add_Line('Cannot connect');
         Add_Line( slLog.Text);
         exit;
         end;

     session := libssh2_session_init();
     if libssh2_session_startup(session, sock.Socket)<>0
     then
         begin
         Log_Add_Line( 'Cannot establishing SSH session');
         Add_Line( slLog.Text);
         exit;
         end;

     fingerprint := libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1);
     sFINGERPRINT:= '';
     iFINGERPRINT:=0;
     while fingerprint[iFINGERPRINT]<>#0
     do
       begin
       sFINGERPRINT:= sFINGERPRINT+ inttohex(ord(fingerprint[iFINGERPRINT]),2)+':';
       iFINGERPRINT:=iFINGERPRINT+1;
       end;
     Log_Add_Line( 'Host fingerprint '+sFINGERPRINT);
     Log_Add_Line( 'Assuming known host...');
     if libssh2_userauth_password(session, pchar(Username), pchar(Password))<>0
     then
         begin
         Log_Add_Line('Authentication by password failed');
         Add_Line( slLog.Text);
         exit;
         end;
     Log_Add_Line('Authentication succeeded');
     channel := libssh2_channel_open_session(session);
     if not assigned(channel)
     then
         begin
         Log_Add_Line('Cannot open session');
         Add_Line( slLog.Text);
         exit;
         end;
     if libssh2_channel_request_pty(channel, 'vanilla')<>0
     then
         begin
         Log_Add_Line('Cannot obtain pty');
         Add_Line( slLog.Text);
         exit;
         end;
     if libssh2_channel_shell(channel)<>0
     then
         begin
         Log_Add_Line('Cannot open shell');
         Add_Line( slLog.Text);
         exit;
         end;

     libssh2_channel_set_blocking(channel,0);

     Result:= False;
end;

function TthCommand.no_New_input: Boolean;
const
     Buffer_Size=10000;
var
  Used:integer;
  S: String;
var
   iDerniereLigne: Integer;
   sDerniereLigne: String;
begin
     Result:= True;

     SetLength( S, Buffer_Size+1);
     Used:=libssh2_channel_read(channel,@S[1],Buffer_Size);
     Result:= Used <= 0;
     if Result then exit;

     SetLength( S, Used);

     Resultat:= Resultat+S;
     Log_Add_Text( S);
     iDerniereLigne:= slLog.Count-1;
     IsPrompt:= 0 <= iDerniereLigne;
     if IsPrompt
     then
         begin
         sDerniereLigne:= slLog.Strings[ iDerniereLigne];
         IsPrompt:= sDerniereLigne = Prompt;
         end;
     if IsPrompt
     then
         if IsLogin
         then
             begin
             Add_Line( slLog.Text);
             IsLogin:= False;
             Resultat:= '';
             Wait_For_Command:= True;
             end
         else
             begin
             while Prompt = Copy(Resultat, Length(Resultat)-lPrompt+1, lPrompt)
             do
               Delete( Resultat, Length(Resultat)-lPrompt+1, lPrompt);
             slResultat.Text:= Resultat;
             Do_OnTerminated;
             end;
end;

procedure TthCommand.Process_Output;
begin
     if     Wait_For_Command
        and Next_Command
     then
         begin
         Wait_For_Command:= False;
         Send( Commande.Commande);
         end;
end;

procedure TthCommand.Execute;
begin
     FreeOnTerminate:= False;

     if not_Login then exit;
     while not Terminated
     do
       begin
       if no_New_input then Sleep( 1000);

       Process_Output;
       end;
end;

procedure TthCommand.Log_Add_Line(_S: String);
begin
     slLog.Add( _S);
end;

procedure TthCommand.Log_Add_Text(_S: String);
begin
     with slLog do Text:= Text + _S;
end;

procedure TthCommand.Ajoute_Commande(_Commande: TblCommande);
begin
     sl.AddObject( _Commande.Commande, _Commande);
end;

function TthCommand.Next_Command: Boolean;
begin
     Result:= I.Continuer;
     if not Result then exit;

     Result:= not I.not_Suivant( Commande);
     if not Result then exit;

     IsPrompt:= False;
     Resultat:= '';
     if Tag= '' then Tag:= Commande.Commande;
end;

procedure TthCommand.Send(_S: String);
begin
     ssend:= _S+LineEnding;
     libssh2_channel_write(channel,pchar(ssend),length(ssend));
end;

procedure TthCommand.Send_Ctrl_C;
begin
     Send( #3);
end;

procedure TthCommand.Do_OnTerminated_interne;
begin
     Commande.Commande_Terminated;
     I.Supprime_courant;
     Wait_For_Command:= True;
end;

procedure TthCommand.Do_OnTerminated;
begin
     Synchronize( @Do_OnTerminated_interne);
end;

{ TblCommande }

constructor TblCommande.Create(_sl: TBatpro_StringList);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Commande';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited Create( _sl, nil, nil);
     _sl.AddObject( '', Self);

     Champs.ChampDefinitions.NomTable:= 'Commande';

     //champs persistants

     cLibelle:= Ajoute_String( Libelle,'Libelle', False);
     cLED_Color:= Ajoute_Integer( LED_Color, 'LED_Color', False);
     LED_Color:= clBlack;
end;

destructor TblCommande.Destroy;
begin
     inherited Destroy;
end;

function TblCommande.Init( _th: TthCommand;
                           _Add_Line: TInstallation_Check_String_Proc;
                           _Commande: String; _Libelle: String
                           ): TblCommande;
begin
     th      := _th;
     Add_Line:= _Add_Line;
     Commande:= _Commande;
     Libelle := _Libelle;
     if '' = Libelle then Libelle:= Commande;
     Result:= Self;
end;

procedure TblCommande.Execute;
begin
     th.Ajoute_Commande( Self);
end;

procedure TblCommande.Commande_Terminated;
begin
     if th.IsLogin
     then
         Add_Line( th.slLog.Text)
     else
         begin
         cLED_Color.asInteger:= clLime;
         cLibelle.Chaine:=Libelle+': '+th.slResultat[1];
         Add_Line( Libelle);
         Add_Line( th.Resultat);
         end;
end;

{ TIterateur_Commande }

function TIterateur_Commande.not_Suivant( var _Resultat: TblCommande): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Commande.Suivant( var _Resultat: TblCommande);
begin
     Suivant_interne( _Resultat);
end;

{ TslCommande }

constructor TslCommande.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblCommande);
end;

destructor TslCommande.Destroy;
begin
     inherited;
end;

class function TslCommande.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Commande;
end;

function TslCommande.Iterateur: TIterateur_Commande;
begin
     Result:= TIterateur_Commande( Iterateur_interne);
end;

function TslCommande.Iterateur_Decroissant: TIterateur_Commande;
begin
     Result:= TIterateur_Commande( Iterateur_interne_Decroissant);
end;

end.

