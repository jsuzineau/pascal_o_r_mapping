unit ufInstallation_Check;

{$mode objfpc}{$H+}

interface

uses
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
   bLL: TButton;
   bFPC: TButton;
    m: TMemo;
    Panel1: TPanel;
    procedure bFPCClick(Sender: TObject);
    procedure bLLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
   //
  private
   ic: TInstallation_Check;
   procedure Add_Line(_S: String);
  end;

 TthCommand= class;

 { TContexte }

 TContexte
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    Hostname, Username, Password, Prompt: String;
    lPrompt: Integer;
  end;

 { TCommande_Ancetre }

 TCommande_Ancetre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc;
                        _Commande: String);
    destructor Destroy; override;
  //Attributs
  private
    c: TContexte;
    Add_Line: TInstallation_Check_String_Proc;
    Commande: String;

  //Lancement du thread
  public
    procedure Execute;
  //CallBack appelé à la fin du thread
  public
     procedure th_Terminated(  _th: TthCommand); virtual;  abstract;
  end;

 { TCommande}

 TCommande
 =
  class( TCommande_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc; _Commande, _Tag: String);
    destructor Destroy; override;
  //Attributs
  private
    Tag: String;
  //CallBack appelé à la fin du thread
  public
     procedure th_Terminated(  _th: TthCommand); override;
  end;

 { TTraite_ll }

 TTraite_ll
 =
  class( TCommande_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc;
                        _Repertoire: String);
    destructor Destroy; override;
  //Attributs
  public
    Repertoire: String;
  //CallBack appelé à la fin du thread
  public
     procedure th_Terminated(  _th: TthCommand); override;
  end;

 { TInstallation_Check }

 TInstallation_Check
 =
  class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
  //Attributs
  public
    c: TContexte;
  //Résultat brut d'une commande
  public
    procedure Traite_Commande( _Add_Line: TInstallation_Check_String_Proc;
                               _Commande: String;
                               _Tag: String= '');
  //Listage des droits dans un répertoire
  public
    procedure Traite_ll( _Add_Line: TInstallation_Check_String_Proc;
                         _Repertoire: String);
  end;

 { TthCommand }

 TthCommand
 =
  class(TThread)
  //Gestion du cycle de vie
  public
    constructor Create( _c: TContexte; _Commande: String;
                        _Commande_Done: TCommande_Ancetre);
    destructor Destroy; override;
  //Attributs
   private
     c: TContexte;
     Commande: String;
   private
     sock:TTCPBlockSocket;
     session:PLIBSSH2_SESSION;
     fingerprint:PAnsiChar;
     s,ssend:string;
     channel:PLIBSSH2_CHANNEL;
     i:integer;
   //Méthodes
   protected
     procedure Execute; override;
   //
   private
     procedure Log_Add_Line(_S: String);
     procedure Log_Add_Text( _S: String);
   public
      slLog: TStringList;
   //Etat
   private
     IsLogin: Boolean;
     IsPrompt: Boolean;
     procedure Traite_Reception( _S: String);

     procedure Send( _S: String);
   //Terminaison
   public
      Commande_Done: TCommande_Ancetre;
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

{ TContexte }

constructor TContexte.Create;
begin
     HostName:= EXE_INI.Assure_String( 'HostName', '');
     UserName:= EXE_INI.Assure_String( 'UserName', '');
     PassWord:= EXE_INI.Assure_String( 'PassWord', '');
     Prompt  := EXE_INI.Assure_String( 'Prompt'  , '"(please quote the prompt)"');
     lPrompt:= Length( Prompt);
end;

destructor TContexte.Destroy;
begin
     inherited Destroy;
end;

{ TthCommand }

constructor TthCommand.Create( _c: TContexte; _Commande: String;
                               _Commande_Done: TCommande_Ancetre);
begin
     c       := _c      ;
     Commande:= _Commande;
     Commande_Done:= _Commande_Done;

     slLog:= TStringList.Create;
     IsPrompt:= False;
     IsLogin := True;
     Resultat:= '';
     if Tag= '' then Tag:= Commande;
     inherited Create(False);
end;

destructor TthCommand.Destroy;
begin
     libssh2_channel_free(channel);
     libssh2_session_disconnect(session,'Thank you for using sshtest');
     libssh2_session_free(session);
     sock.Free;

     FreeAndNil( slLog);
     inherited Destroy;
end;

procedure TthCommand.Execute;
var
  buf:array[0..10000] of char;
  len:integer;
begin
     FreeOnTerminate:= False;

     sock := TTCPBlockSocket.Create;
     sock.Connect(c.Hostname,'22');
     if sock.LastError<>0
     then
         begin
         Log_Add_Line('Cannot connect');
         Do_OnTerminated;
         exit;
         end;

     session := libssh2_session_init();
     if libssh2_session_startup(session, sock.Socket)<>0
     then
         begin
         Log_Add_Line( 'Cannot establishing SSH session');
         Do_OnTerminated;
         exit;
         end;

     fingerprint := libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1);
     Log_Add_Text( 'Host fingerprint ');
     i:=0;
     while fingerprint[i]<>#0
     do
       begin
       Log_Add_Text( inttohex(ord(fingerprint[i]),2)+':');
       i:=i+1;
       end;
     Log_Add_Text( #13#10);
     Log_Add_Line( 'Assuming known host...');
     if libssh2_userauth_password(session, pchar(c.Username), pchar(c.Password))<>0
     then
         begin
         Log_Add_Line('Authentication by password failed');
         Do_OnTerminated;
         exit;
         end;
     Log_Add_Line('Authentication succeeded');
     channel := libssh2_channel_open_session(session);
     if not assigned(channel)
     then
         begin
         Log_Add_Line('Cannot open session');
         Do_OnTerminated;
         exit;
         end;
     if libssh2_channel_request_pty(channel, 'vanilla')<>0
     then
         begin
         Log_Add_Line('Cannot obtain pty');
         Do_OnTerminated;
         exit;
         end;
     if libssh2_channel_shell(channel)<>0
     then
         begin
         Log_Add_Line('Cannot open shell');
         Do_OnTerminated;
         exit;
         end;

     libssh2_channel_set_blocking(channel,0);
     while not Terminated
     do
       begin
       len:=libssh2_channel_read(channel,buf,10000);
            if len>0      then Traite_Reception(copy(buf,1,len))
       else                    sleep(1000);
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

procedure TthCommand.Traite_Reception( _S: String);
var
   iDerniereLigne: Integer;
   sDerniereLigne: String;
begin
     Resultat:= Resultat+_S;
     Log_Add_Text( _S);
     iDerniereLigne:= slLog.Count-1;
     IsPrompt:= 0 <= iDerniereLigne;
     if IsPrompt
     then
         begin
         sDerniereLigne:= slLog.Strings[ iDerniereLigne];
         IsPrompt:= sDerniereLigne = c.Prompt;
         end;

     if IsPrompt
     then
         if IsLogin
         then
             begin
             IsLogin:= False;
             Resultat:= '';
             Send( Commande);
             end
         else
             begin
             while c.Prompt = Copy(Resultat, Length(Resultat)-c.lPrompt+1, c.lPrompt)
             do
               Delete( Resultat, Length(Resultat)-c.lPrompt+1, c.lPrompt);
             Do_OnTerminated;
             Terminate;
             end;
end;

procedure TthCommand.Send(_S: String);
begin
     ssend:= _S+LineEnding;
     libssh2_channel_write(channel,pchar(ssend),length(ssend));
end;

procedure TthCommand.Do_OnTerminated_interne;
begin
     Commande_Done.th_Terminated( Self);
end;

procedure TthCommand.Do_OnTerminated;
begin
     Synchronize( @Do_OnTerminated_interne);
end;

{ TCommande_Ancetre }

constructor TCommande_Ancetre.Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc;
                                      _Commande: String);
begin
     c      := _c;
     Add_Line:= _Add_Line;
     Commande:= _Commande;
end;

destructor TCommande_Ancetre.Destroy;
begin
     inherited Destroy;
end;

procedure TCommande_Ancetre.Execute;
begin
     TthCommand.Create( c, Commande, Self);
end;

{ TCommande }

constructor TCommande.Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc; _Commande, _Tag: String);
begin
     inherited Create( _c, _Add_Line,_Commande);
     Tag:= _Tag;
end;

destructor TCommande.Destroy;
begin
     inherited Destroy;
end;

procedure TCommande.th_Terminated(_th: TthCommand);
begin
     if _th.IsLogin
     then
         Add_Line( _th.slLog.Text)
     else
         begin
         Add_Line( Tag);
         Add_Line( _th.Resultat);
         end;
    //FreeAndNil( _th);
end;

{ TTraite_ll }

constructor TTraite_ll.Create( _c: TContexte; _Add_Line: TInstallation_Check_String_Proc;
                               _Repertoire: String);
begin
     Repertoire:= _Repertoire;
     inherited Create( _c, _Add_Line,'ll '+Repertoire);
end;

destructor TTraite_ll.Destroy;
begin
     inherited Destroy;
end;

procedure TTraite_ll.th_Terminated( _th: TthCommand);
var
   sl: TStringList;
   slResultat: TStringList;
   i: Integer;
   s: String;
   Rights: String;
   sOwner: String;
   Group: String;
   Info: String;
begin
     if _th.IsLogin
     then
         begin
         Add_Line( _th.slLog.Text);
         exit;
         end;

     sl:= TStringList.Create;
     slResultat:= TStringList.Create;
     try
        sl.Text:= _th.Resultat;
        //Suppression du prompt à la fin
        while
                 (sl.Count>0)
             and (sl[sl.Count-1] = c.Prompt)
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

          Info:= Rights + ' '+ sOwner + ' ' + Group;
          if -1 = slResultat.IndexOf(Info) then slResultat.Add( Info);
          end;
        Add_Line( 'consolidation droits ll sur '+Repertoire+':');
        slResultat.Sort;
        Add_Line( slResultat.Text);
        Add_Line( 'fin consolidation droits ll:');
        //Add_Line( 'Retour commande brut:');
        //Add_Line( _Resultat);
        //Add_Line( 'Fin Retour commande brut');
     finally
            FreeAndNil( sl);
            end;

     //FreeAndNil( _th);
end;

{ TInstallation_Check }

constructor TInstallation_Check.Create;
begin
     c:= TContexte.Create;
end;

destructor TInstallation_Check.Destroy;
begin
     inherited Destroy;
end;

procedure TInstallation_Check.Traite_Commande( _Add_Line: TInstallation_Check_String_Proc;
                                               _Commande: String;
                                               _Tag: String= '');
begin
     TCommande.Create( c, _Add_Line, _Commande, _Tag).Execute;
end;

procedure TInstallation_Check.Traite_ll( _Add_Line: TInstallation_Check_String_Proc;
                                         _Repertoire: String);
begin
     TTraite_ll.Create( c, _Add_Line, _Repertoire).Execute;
end;

{ TfInstallation_Check }

procedure TfInstallation_Check.FormCreate(Sender: TObject);
begin
     ic:= TInstallation_Check.Create;
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
     ic.Traite_ll( @Add_Line, './');
end;

procedure TfInstallation_Check.bFPCClick(Sender: TObject);
begin
     ic.Traite_Commande( @Add_Line, 'fpc -v', 'Version de FreePascal');
end;

end.

