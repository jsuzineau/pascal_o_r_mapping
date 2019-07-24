program sshtest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  sysutils,classes,
  libssh2,blcksock;

type

  { TMyThread }

  TReadThread=class(TThread)
    private
      FChannel:PLIBSSH2_CHANNEL;
    protected
      procedure Execute; override;
    public
      constructor Create(channel:PLIBSSH2_CHANNEL);
    end;

var
  sock:TTCPBlockSocket;
  session:PLIBSSH2_SESSION;
  fingerprint:PAnsiChar;
  password,s,ssend:string;
  channel:PLIBSSH2_CHANNEL;
  i:integer;
  ReadThread:TReadThread;
  bNewString:boolean;

{ TReadThread }

procedure TReadThread.Execute;
var
  buf:array[0..10000] of char;
  len:integer;
begin
  libssh2_channel_set_blocking(channel,0);
  while not Terminated do
    begin
    len:=libssh2_channel_read(channel,buf,10000);
    if len>0 then
      begin
      write(copy(buf,1,len));
      end
    else if bNewString then
      begin
      libssh2_channel_write(channel,pchar(ssend),length(ssend));
      bNewString:=false;
      end
    else
      sleep(1000);
    end;
end;

constructor TReadThread.Create(channel: PLIBSSH2_CHANNEL);
begin
  inherited Create(true);
  FChannel:=channel;
end;

begin
  if Paramcount<2 then
    begin
    writeln('Usage: ',paramstr(0),' user ip');
    exit;
    end;
  sock := TTCPBlockSocket.Create;
  sock.Connect(paramstr(2),'22');
  if sock.LastError=0 then
    begin
    session := libssh2_session_init();
    if libssh2_session_startup(session, sock.Socket)<>0 then
      begin
      writeln('Cannot establishing SSH session');
      exit;
      end;
    fingerprint := libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1);
    write('Host fingerprint ');
    i:=0;
    while fingerprint[i]<>#0 do
      begin
      write(inttohex(ord(fingerprint[i]),2),':');
      i:=i+1;
      end;
    writeln;
    writeln('Assuming known host...');
    write('Password for ', paramstr(1),' : ');
    readln(password);
    if libssh2_userauth_password(session, pchar(paramstr(1)), pchar(password))<>0 then
      begin
      writeln('Authentication by password failed');
      exit;
      end;
    writeln('Authentication succeeded');
    channel := libssh2_channel_open_session(session);
    if not assigned(channel) then
      begin
      writeln('Cannot open session');
      exit;
      end;
    if libssh2_channel_request_pty(channel, 'vanilla')<>0 then
      begin
      writeln('Cannot obtain pty');
      exit;
      end;
    if libssh2_channel_shell(channel)<>0 then
      begin
      writeln('Cannot open shell');
      exit;
      end;
    ReadThread:=TReadThread.Create(channel);
    ReadThread.Resume;
    while true do
      begin
      readln(s);
      if s='exit' then
        break;
      ssend:=s+LineEnding;
      bNewString:=true;
      end;
    ReadThread.Terminate;
    libssh2_channel_free(channel);
    libssh2_session_disconnect(session,'Thank you for using sshtest');
    libssh2_session_free(session);
    sock.Free;
    end
  else
    writeln('Cannot connect');
end.

