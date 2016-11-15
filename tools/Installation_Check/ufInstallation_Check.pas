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
 TthCommand_Terminated= procedure ( _th: TthCommand) of object;

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
    HostName, UserName, Password, Prompt: String;
  //Listage des droits dans un répertoire
  private
    procedure Traite_ll_Done( _th: TthCommand);
  public
    procedure Traite_ll( _Add_Line: TInstallation_Check_String_Proc;
                         _Repertoire: String);
  //Résultat brut d'une commande
  private
    procedure Commande_Done( _th: TthCommand);
  public
    procedure Traite_Commande( _Add_Line: TInstallation_Check_String_Proc;
                               _Commande: String;
                               _Tag: String= '';
                               _OnTerminated: TthCommand_Terminated=nil);
  end;

 { TthCommand }

 TthCommand
 =
  class(TThread)
  //Gestion du cycle de vie
  public
    constructor Create( _Add_Line: TInstallation_Check_String_Proc;
                        _Hostname, _Username, _Password, _Prompt, _Commande, _Tag: String;
                        _OnTerminated: TthCommand_Terminated);
    destructor Destroy; override;
  //Attributs
   private
     Add_Line: TInstallation_Check_String_Proc;
     Hostname, Username, Password, Prompt, Commande: String;
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
      OnTerminated: TthCommand_Terminated;
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

constructor TthCommand.Create( _Add_Line: TInstallation_Check_String_Proc;
                               _Hostname, _Username, _Password, _Prompt, _Commande, _Tag: String;
                               _OnTerminated: TthCommand_Terminated);
begin
     Add_Line:= _Add_Line;
     Hostname:= _Hostname;
     Username:= _Username;
     Password:= _Password;
     Prompt  := _Prompt  ;
     Commande:= _Commande;
     Tag     := _Tag     ;
     OnTerminated:= _OnTerminated;

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
     sock.Connect(Hostname,'22');
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
     if libssh2_userauth_password(session, pchar(Username), pchar(Password))<>0
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
         IsPrompt:= sDerniereLigne = Prompt;
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
             while Prompt = Copy(Resultat, Length(Resultat)-Length(Prompt)+1, Length(Prompt))
             do
               Delete( Resultat, Length(Resultat)-Length(Prompt)+1, Length(Prompt));
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
     if Assigned( OnTerminated)
     then
         OnTerminated( Self);
end;

procedure TthCommand.Do_OnTerminated;
begin
     Synchronize( @Do_OnTerminated_interne);
end;

{ TInstallation_Check }

constructor TInstallation_Check.Create;
begin
     HostName:= EXE_INI.Assure_String( 'HostName', '');
     UserName:= EXE_INI.Assure_String( 'UserName', '');
     PassWord:= EXE_INI.Assure_String( 'PassWord', '');
     Prompt  := EXE_INI.Assure_String( 'Prompt'  , '"(please quote the prompt)"');
end;

destructor TInstallation_Check.Destroy;
begin
     inherited Destroy;
end;

procedure TInstallation_Check.Commande_Done( _th: TthCommand);
begin        //c'est manifestement à déplacer comme méthode de TthCommand
     if _th.IsLogin
     then
         _th.Add_Line( _th.slLog.Text)
     else
         begin
         _th.Add_Line( _th.Tag);
         _th.Add_Line( _th.Resultat);
         end;
    //FreeAndNil( _th);
end;

procedure TInstallation_Check.Traite_Commande( _Add_Line: TInstallation_Check_String_Proc;
                                               _Commande: String;
                                               _Tag: String= '';
                                               _OnTerminated: TthCommand_Terminated=nil);
begin
     if nil = _OnTerminated
     then
         _OnTerminated:= @Commande_Done;

     TthCommand.Create( _Add_Line,
                        HostName, UserName, PassWord, Prompt,
                        _Commande, _Tag, _OnTerminated);
end;

procedure TInstallation_Check.Traite_ll_Done( _th: TthCommand);
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
         _th.Add_Line( _th.slLog.Text);
         exit;
         end;

     sl:= TStringList.Create;
     slResultat:= TStringList.Create;
     try
        sl.Text:= _th.Resultat;
        //Suppression du prompt à la fin
        while
                 (sl.Count>0)
             and (sl[sl.Count-1] = Prompt)
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
        _th.Add_Line( 'consolidation droits ll sur '+_th.Tag+':');
        slResultat.Sort;
        _th.Add_Line( slResultat.Text);
        _th.Add_Line( 'fin consolidation droits ll:');
        //_th.Add_Line( 'Retour commande brut:');
        //_th.Add_Line( _Resultat);
        //_th.Add_Line( 'Fin Retour commande brut');
     finally
            FreeAndNil( sl);
            end;

     //FreeAndNil( _th);
end;

procedure TInstallation_Check.Traite_ll( _Add_Line: TInstallation_Check_String_Proc;
                                         _Repertoire: String);
begin
     Traite_Commande( _Add_Line, 'll '+_Repertoire, _Repertoire, @Traite_ll_Done);
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

