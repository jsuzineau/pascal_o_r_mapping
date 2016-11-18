unit ufInstallation_Check;

{$mode objfpc}{$H+}

//La gestion du thread de la connections ssh2 provient du code du sshtest.pas
//trouvé sur le forum.lazarus.freepascal.org
interface

uses
    uBatpro_StringList,
    uuStrings,
    uEXE_INI,
    libssh2, blcksock,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
 ExtCtrls, LCLType;

type

 TInstallation_Check= class;
 TInstallation_Check_String_Proc=  procedure (_S: String) of object;

 { TfInstallation_Check }

 TfInstallation_Check
 =
  class(TForm)
    m: TMemo;
    Panel1: TPanel;
    s: TShape;
    procedure bFPCClick(Sender: TObject);
    procedure bLLClick(Sender: TObject);
    procedure bTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
   //
  private
   ic: TInstallation_Check;
   procedure Add_Line(_S: String);
  end;

 TthCommand= class;

 { TCommande_Ancetre }

 TCommande_Ancetre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                        _Commande: String);
    destructor Destroy; override;
  //Attributs
  private
    th: TthCommand;
    Add_Line: TInstallation_Check_String_Proc;
    Commande: String;

  //Lancement du thread
  public
    procedure Execute;
  //CallBack appelé à la fin du thread
  public
     procedure Commande_Terminated; virtual;  abstract;
  end;

 TIterateur_Commande_Ancetre
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TCommande_Ancetre);
    function  not_Suivant( var _Resultat: TCommande_Ancetre): Boolean;
  end;

 TslCommande_Ancetre
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
    function Iterateur: TIterateur_Commande_Ancetre;
    function Iterateur_Decroissant: TIterateur_Commande_Ancetre;
  end;

 { TCommande}

 TCommande
 =
  class( TCommande_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc; _Commande, _Tag: String);
    destructor Destroy; override;
  //Attributs
  private
    Tag: String;
  //CallBack appelé à la fin du thread
  public
     procedure Commande_Terminated; override;
  end;

 { TTraite_ll }

 TTraite_ll
 =
  class( TCommande_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                        _Repertoire: String);
    destructor Destroy; override;
  //Attributs
  public
    Repertoire: String;
  // Consolidation
  protected
    Rights: String;
    sOwner: String;
    Group: String;
    Info: String;
    procedure Calcule_Info; virtual;
  //CallBack appelé à la fin du thread
  public
     procedure Commande_Terminated; override;
  //Résultat
  public
    slResultat: TStringList;
    procedure Affiche_Resultat; virtual;
  //Succes
  public
    Succes: Boolean;
    procedure Calcule_Succes; virtual;
  end;

 { TVerifie_CHMOD_777 }

 TVerifie_CHMOD_777
 =
  class( TTraite_ll)
  // Consolidation
  protected
    procedure Calcule_Info; override;
  //Résultat
  public
    procedure Affiche_Resultat; override;
  //Succes
  public
    procedure Calcule_Succes; override;
  end;

 { TVerifie_Owner_Group }

 TVerifie_Owner_Group
 =
  class( TTraite_ll)
  //Gestion du cycle de vie
  public
    constructor Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                        _Repertoire, _OwnerConstraint, _GroupConstraint: String);
    destructor Destroy; override;
  //Attributs
  public
    OwnerConstraint, GroupConstraint: String;
  // Consolidation
  protected
    procedure Calcule_Info; override;
  //Résultat
  public
    procedure Affiche_Resultat; override;
  //Succes
  public
    procedure Calcule_Succes; override;
  end;

 { TInstallation_Check }

 TInstallation_Check
 =
  class
   //Gestion du cycle de vie
   public
     constructor Create( _Add_Line: TInstallation_Check_String_Proc);
     destructor Destroy; override;
  //Attributs
  public
    th: TthCommand;
    Add_Line: TInstallation_Check_String_Proc;
  //Résultat brut d'une commande
  public
    procedure Traite_Commande( _Commande: String;_Tag: String= '');
  //Listage des droits dans un répertoire
  public
    procedure Traite_ll( _Repertoire: String);
  //Vérification droits 777
  public
    procedure Verifie_CHMOD_777( _Repertoire: String);
  //Vérification propriétaire et groupe
  public
    procedure Verifie_Owner_Group( _Repertoire, _OwnerConstraint, _GroupConstraint: String);
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
    Hostname, Username, Password, Prompt: String;
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
     I: TIterateur_Commande_Ancetre;
     sl: TslCommande_Ancetre;
     procedure Ajoute_Commande( _Commande: TCommande_Ancetre);
     function Next_Command: Boolean;
   //Terminaison
   public
      Commande: TCommande_Ancetre;
      procedure Do_OnTerminated_interne;
      procedure Do_OnTerminated;
   //Tag
   public
     Tag: String;
   //Resultat
   public
     Resultat: String;
   end;

var
 fInstallation_Check: TfInstallation_Check;

implementation

{$R *.lfm}

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

     sl:= TslCommande_Ancetre.Create(ClassName+'.sl');
     I:= sl.Iterateur;

     IsLogin := True;
     IsPrompt:= False;
     Resultat:= '';
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

     inherited Destroy;
end;

function TthCommand.not_Login: Boolean;
var
   fingerprint:PAnsiChar;
   iFINGERPRINT:integer;
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
     Log_Add_Text( 'Host fingerprint ');
     iFINGERPRINT:=0;
     while fingerprint[iFINGERPRINT]<>#0
     do
       begin
       Log_Add_Text( inttohex(ord(fingerprint[iFINGERPRINT]),2)+':');
       iFINGERPRINT:=iFINGERPRINT+1;
       end;
     Log_Add_Text( #13#10);
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

procedure TthCommand.Ajoute_Commande(_Commande: TCommande_Ancetre);
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

{ TCommande_Ancetre }

constructor TCommande_Ancetre.Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                                      _Commande: String);
begin
     th      := _th;
     Add_Line:= _Add_Line;
     Commande:= _Commande;
end;

destructor TCommande_Ancetre.Destroy;
begin
     inherited Destroy;
end;

procedure TCommande_Ancetre.Execute;
begin
     th.Ajoute_Commande( Self);
end;

{ TIterateur_Commande_Ancetre }

function TIterateur_Commande_Ancetre.not_Suivant( var _Resultat: TCommande_Ancetre): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Commande_Ancetre.Suivant( var _Resultat: TCommande_Ancetre);
begin
     Suivant_interne( _Resultat);
end;

{ TslCommande_Ancetre }

constructor TslCommande_Ancetre.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TCommande_Ancetre);
end;

destructor TslCommande_Ancetre.Destroy;
begin
     inherited;
end;

class function TslCommande_Ancetre.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Commande_Ancetre;
end;

function TslCommande_Ancetre.Iterateur: TIterateur_Commande_Ancetre;
begin
     Result:= TIterateur_Commande_Ancetre( Iterateur_interne);
end;

function TslCommande_Ancetre.Iterateur_Decroissant: TIterateur_Commande_Ancetre;
begin
     Result:= TIterateur_Commande_Ancetre( Iterateur_interne_Decroissant);
end;

{ TCommande }

constructor TCommande.Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc; _Commande, _Tag: String);
begin
     inherited Create( _th, _Add_Line,_Commande);
     Tag:= _Tag;
end;

destructor TCommande.Destroy;
begin
     inherited Destroy;
end;

procedure TCommande.Commande_Terminated;
begin
     if th.IsLogin
     then
         Add_Line( th.slLog.Text)
     else
         begin
         Add_Line( Tag);
         Add_Line( th.Resultat);
         end;
     Free;
end;

{ TTraite_ll }

constructor TTraite_ll.Create( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                               _Repertoire: String);
begin
     Repertoire:= _Repertoire;
     inherited Create( _th, _Add_Line,'ll '+Repertoire);
     slResultat:= TStringList.Create;
end;

destructor TTraite_ll.Destroy;
begin
     FreeAndNil( slResultat);
     inherited Destroy;
end;

procedure TTraite_ll.Commande_Terminated;
var
   sl: TStringList;
   i: Integer;
   s: String;
begin
     if th.IsLogin
     then
         begin
         Add_Line( th.slLog.Text);
         exit;
         end;

     sl:= TStringList.Create;
     try
        sl.Text:= th.Resultat;
        //Suppression du prompt à la fin
        while
                 (sl.Count>0)
             and (sl[sl.Count-1] = th.Prompt)
        do
          sl.Delete( sl.Count-1); //le prompt

        sl.Delete( 1         ); //total
        sl.Delete( 0         ); //l'écho de la commande

(*
drwxrwxr-x  3 jean jean    4096 janv.  9  2016 analyseur_4gl
*)
        for i:= 0 to sl.Count-1
        do
          begin
          s:= sl[i];
          Rights:= StrToK( ' ', s);
          s:= TrimLeft( s);
          StrToK( ' ', s); //hardlinks #
          sOwner:= StrToK( ' ', s);
          Group:= StrToK( ' ', s);

          Delete(Rights, 1, 1);//on enlève le type de fichier : directory, link, fichier...

          Calcule_Info;
          if -1 = slResultat.IndexOf(Info) then slResultat.Add( Info);
          end;
     finally
            FreeAndNil( sl);
            end;

     Calcule_Succes;
     Affiche_Resultat;
     Free;
end;

procedure TTraite_ll.Calcule_Info;
begin
     Info:= Rights + ' '+ sOwner + ' ' + Group;
end;

procedure TTraite_ll.Calcule_Succes;
begin
     Succes:= True;
end;

procedure TTraite_ll.Affiche_Resultat;
begin
     Add_Line( 'consolidation droits ll sur '+Repertoire+':');
     slResultat.Sort;
     Add_Line( slResultat.Text);
     Add_Line( 'fin consolidation droits ll:');
     //Add_Line( 'Retour commande brut:');
     //Add_Line( _Resultat);
     //Add_Line( 'Fin Retour commande brut');
end;

{ TVerifie_CHMOD_777 }

procedure TVerifie_CHMOD_777.Calcule_Info;
begin
     Info:= Rights;
end;

procedure TVerifie_CHMOD_777.Calcule_Succes;
begin
     Succes:= slResultat.Count = 1;
     if not Succes then exit;

     Succes:= slResultat[0] = 'rwxrwxrwx';//777
end;

procedure TVerifie_CHMOD_777.Affiche_Resultat;
begin
     Add_Line( BoolToStr( Succes, 'Succés',
                                  'Echec ')
               +' vérification droits 777 sur '+Repertoire);
end;

{ TVerifie_Owner_Group }

constructor TVerifie_Owner_Group.Create( _th: TthCommand;
                                         _Add_Line: TInstallation_Check_String_Proc;
                                         _Repertoire, _OwnerConstraint, _GroupConstraint: String);
begin
     inherited Create( _th, _Add_Line, _Repertoire);
     OwnerConstraint:= _OwnerConstraint;
     GroupConstraint:= _GroupConstraint;
end;

destructor TVerifie_Owner_Group.Destroy;
begin
     inherited Destroy;
end;

procedure TVerifie_Owner_Group.Calcule_Info;
begin
     Info:= sOwner + ' ' + Group;
end;

procedure TVerifie_Owner_Group.Calcule_Succes;
begin
     Succes:= slResultat.Count = 1;
     if not Succes then exit;

     Succes:= slResultat[0] = OwnerConstraint + ' ' + GroupConstraint;
end;

procedure TVerifie_Owner_Group.Affiche_Resultat;
begin
     Add_Line( BoolToStr( Succes, 'Succcés',
                                  'Echec  ')
               +' vérification propriétaire '+OwnerConstraint + ' groupe ' + GroupConstraint+' sur '+Repertoire);
end;

{ TInstallation_Check }

constructor TInstallation_Check.Create( _Add_Line: TInstallation_Check_String_Proc);
begin
     Add_Line:= _Add_Line;
     th:= TthCommand.Create( Add_Line);
end;

destructor TInstallation_Check.Destroy;
begin
     th.FreeOnTerminate:= True;
     inherited Destroy;
end;

procedure TInstallation_Check.Traite_Commande( _Commande: String; _Tag: String= '');
begin
     TCommande.Create( th, Add_Line, _Commande, _Tag).Execute;
end;

procedure TInstallation_Check.Traite_ll( _Repertoire: String);
begin
     TTraite_ll.Create( th, Add_Line, _Repertoire).Execute;
end;

procedure TInstallation_Check.Verifie_CHMOD_777( _Repertoire: String);
begin
     TVerifie_CHMOD_777.Create( th, Add_Line, _Repertoire).Execute;
end;

procedure TInstallation_Check.Verifie_Owner_Group( _Repertoire, _OwnerConstraint, _GroupConstraint: String);
begin
     TVerifie_Owner_Group.Create( th, Add_Line, _Repertoire, _OwnerConstraint, _GroupConstraint).Execute;
end;

{ TfInstallation_Check }

procedure TfInstallation_Check.FormCreate(Sender: TObject);
begin
     ic:= TInstallation_Check.Create( @Add_Line);
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_777');
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_differents');
     ic.Verifie_Owner_Group( './tmp/test_ll/non_partage','jean','jean');
     ic.Verifie_Owner_Group( './tmp/test_ll/partage','jean','jean');
     ic.Traite_Commande( 'fpc -v', 'Version de FreePascal');
     ic.Traite_ll( './');
end;

procedure TfInstallation_Check.FormDestroy(Sender: TObject);
begin
     FreeAndNil( ic);
end;

procedure TfInstallation_Check.Add_Line( _S: String);
begin
     m.Lines.add( _S);
end;

procedure TfInstallation_Check.bLLClick(Sender: TObject);
begin
end;

procedure TfInstallation_Check.bTestClick(Sender: TObject);
begin
end;

procedure TfInstallation_Check.bFPCClick(Sender: TObject);
begin
end;

end.

