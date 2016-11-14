unit ufInstallation_Check;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uEXE_INI,
    libssh2, blcksock,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
 ExtCtrls, tlntsend, LCLType;

type
    TthCommand= class;

 { TfInstallation_Check }

 TfInstallation_Check
 =
  class(TForm)
   bLL: TButton;
    m: TMemo;
    Panel1: TPanel;
    procedure bLLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
   //
  private
   procedure Add_Text(_S: String);
   procedure Add_Line(_S: String);
   procedure Traite_ll(_Repertoire: String);
   procedure Traite_ll_Resultat( _Resultat: String);
   procedure ll_Done( _th: TthCommand);
  end;

 { TthCommand }
 TthCommand_Termainated= procedure ( _th: TthCommand) of object;

 TthCommand
 =
  class(TThread)
  //Gestion du cycle de vie
  public
    constructor Create( _Hostname, _Username, _Password, _Prompt, _Commande: String;
                        _OnTerminated: TthCommand_Termainated);
    destructor Destroy; override;
  //Attributs
   private
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
     procedure Add_Line(_S: String);
     procedure Add_Text( _S: String);
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
      OnTerminated: TthCommand_Termainated;
      procedure Do_OnTerminated_interne;
      procedure Do_OnTerminated;
   //Resultat
   public
     Resultat: String;
   end;

var
 fInstallation_Check: TfInstallation_Check;

implementation

{$R *.lfm}

{ TthCommand }

constructor TthCommand.Create( _Hostname, _Username, _Password, _Prompt, _Commande: String;
                               _OnTerminated: TthCommand_Termainated);
begin
     Hostname:= _Hostname;
     Username:= _Username;
     Password:= _Password;
     Prompt  := _Prompt  ;
     Commande:= _Commande;
     OnTerminated:= _OnTerminated;

     slLog:= TStringList.Create;
     IsPrompt:= False;
     IsLogin := True;
     Resultat:= '';
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
         Add_Line('Cannot connect');
         Do_OnTerminated;
         exit;
         end;

     session := libssh2_session_init();
     if libssh2_session_startup(session, sock.Socket)<>0
     then
         begin
         Add_Line( 'Cannot establishing SSH session');
         Do_OnTerminated;
         exit;
         end;

     fingerprint := libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1);
     Add_Text( 'Host fingerprint ');
     i:=0;
     while fingerprint[i]<>#0
     do
       begin
       Add_Text( inttohex(ord(fingerprint[i]),2)+':');
       i:=i+1;
       end;
     Add_Text( #13#10);
     Add_Line( 'Assuming known host...');
     if libssh2_userauth_password(session, pchar(Username), pchar(Password))<>0
     then
         begin
         Add_Line('Authentication by password failed');
         Do_OnTerminated;
         exit;
         end;
     Add_Line('Authentication succeeded');
     channel := libssh2_channel_open_session(session);
     if not assigned(channel)
     then
         begin
         Add_Line('Cannot open session');
         Do_OnTerminated;
         exit;
         end;
     if libssh2_channel_request_pty(channel, 'vanilla')<>0
     then
         begin
         Add_Line('Cannot obtain pty');
         Do_OnTerminated;
         exit;
         end;
     if libssh2_channel_shell(channel)<>0
     then
         begin
         Add_Line('Cannot open shell');
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

procedure TthCommand.Add_Line(_S: String);
begin
     slLog.Add( _S);
end;

procedure TthCommand.Add_Text(_S: String);
begin
     with slLog do Text:= Text + _S;
end;

procedure TthCommand.Traite_Reception( _S: String);
var
   iDerniereLigne: Integer;
   sDerniereLigne: String;
begin
     Resultat:= Resultat+_S;
     Add_Text( _S);
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

{ TfInstallation_Check }

procedure TfInstallation_Check.FormCreate(Sender: TObject);
begin
end;

procedure TfInstallation_Check.FormDestroy(Sender: TObject);
begin
end;

procedure TfInstallation_Check.Add_Text( _S: String);
begin
     m.Lines.add( _S);
end;

procedure TfInstallation_Check.Add_Line( _S: String);
begin
     m.Lines.add( _S);
end;

procedure TfInstallation_Check.Traite_ll( _Repertoire: String);
var
   HostName, UserName, Password, Prompt: String;
begin
     HostName:= EXE_INI.Assure_String( 'HostName', '');
     UserName:= EXE_INI.Assure_String( 'UserName', '');
     PassWord:= EXE_INI.Assure_String( 'PassWord', '');
     Prompt  := EXE_INI.Assure_String( 'Prompt'  , '"(please quote the prompt)"');

     TthCommand.Create( HostName,
                        UserName,
                        PassWord,
                        Prompt  ,
                        'll '+_Repertoire,
                        @ll_Done);
end;

procedure TfInstallation_Check.Traite_ll_Resultat( _Resultat: String);
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
     //Add_Line( 'Retour commande brut:');
     //Add_Line( _Resultat);
     sl:= TStringList.Create;
     slResultat:= TStringList.Create;
     try
        sl.Text:= _Resultat;
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
        Add_Line( 'consolidation droits ll:');
        slResultat.Sort;
        Add_Line( slResultat.Text);
        Add_Line( 'fin consolidation droits ll:');
     finally
            FreeAndNil( sl);
            end;

end;

procedure TfInstallation_Check.ll_Done( _th: TthCommand);
begin
     if _th.IsLogin
     then
         Add_Line( _th.slLog.Text)
     else
         Traite_ll_Resultat( _th.Resultat);
    //FreeAndNil( _th);
end;

procedure TfInstallation_Check.bLLClick(Sender: TObject);
begin
     Traite_ll( './');
end;

end.

