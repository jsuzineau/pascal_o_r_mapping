unit uAudacity;

{$mode Delphi}

interface

uses
    uClean,
    {$IFDEF UNIX} BaseUnix,{$ENDIF}
 Classes, SysUtils;

type
    TOnLog=  procedure ( _s: String) of object;
    { TAudacity }
    TAudacity
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create;
       destructor Destroy; override;
     //Méthodes
     private
       class function   _to_name:String;
       class function _from_name:String;
       procedure Log( _s: String);
     public
       OnLog: TOnLog;
       _to, _from: Text;
       Ouvert: Boolean;
       BatchCommand_finished: String;
       procedure Ouvrir;
       procedure Fermer;
       procedure Send_command( _command: String);
       function Get_response: string;
       procedure do_command( _command: String);
       procedure Test;
       function Log_Ferme: Boolean;
       procedure Select_seconds( _Start, _End: double);
       procedure ChangeTempo( _Percentage: double; _SBSMS: Boolean= False);
       procedure Play;
       procedure Test_Select_seconds;
     end;

implementation

{ TAudacity }

constructor TAudacity.Create;
begin
     OnLog:= nil;
     Ouvert:= False;
     AssignFile( _to  , _to_name  );
     AssignFile( _from, _from_name);
end;

destructor TAudacity.Destroy;
begin
     Fermer;
     inherited Destroy;
end;

class function TAudacity._to_name: String;
begin
     Result
     :=
       {$IFDEF MSWINDOWS}
         '\\.\pipe\ToSrvPipe'
       {$ELSE}
       '/tmp/audacity_script_pipe.to.'+IntToStr( FpGetuid)
       {$ENDIF};
end;

class function TAudacity._from_name: String;
begin
     Result
     :=
       {$IFDEF MSWINDOWS}
         '\\.\pipe\FromSrvPipe'
       {$ELSE}
       '/tmp/audacity_script_pipe.from.'+IntToStr( FpGetuid)
       {$ENDIF};
end;

procedure TAudacity.Log(_s: String);
begin
     if nil = @OnLog then exit;

     OnLog( _s);
end;

function TAudacity.Log_Ferme: Boolean;
begin
     Result:= not Ouvert;
     if Ouvert then exit;

     Log('Fermé');
end;

procedure TAudacity.Ouvrir;
begin
     Fermer;

     try
        Rewrite( _to  );
     except
           on Exception
           do
             begin
             Log('Echec à l''ouverture de '+_to_name);
             exit;
             end;
           end;
     try
        Reset  ( _from);
     except
           on Exception
           do
             begin
             CloseFile( _to);
             Log('Echec à l''ouverture de '+_from_name);
             end;
           end;

     Ouvert:= True;
end;

procedure TAudacity.Fermer;
begin
     if not Ouvert then exit;

     CloseFile( _to  );
     CloseFile( _from);
     Ouvert:= False;
     Log('Fermé');
end;

procedure TAudacity.Send_command( _command: String);
begin
     if Log_Ferme then exit;

     WriteLn( _to, _command);
     Flush( _to);
end;

function TAudacity.Get_response: string;
var
   Line: String;
   function process_BatchCommand_finished: Boolean;
   const
        s_BatchCommand_finished='BatchCommand finished:';
   begin
        Result:= 1 = Pos( s_BatchCommand_finished, Line);
        if not Result then exit;

        BatchCommand_finished
        :=
          Copy( Line,
                1+Length(s_BatchCommand_finished),
                Length(Line));
   end;
begin
     Result:= '';
     Line:= '';
     BatchCommand_finished:= '';

     if Log_Ferme then exit;

     while True
     do
       begin
       Readln( _from, Line);
       if ('' = Line) and ('' <> Result) then break;
       if process_BatchCommand_finished  then continue;
       Result:= Result + LineEnding + Line;
       end;
end;

procedure TAudacity.do_command(_command: String);
var
   response: String;
begin
     if Log_Ferme then exit;

     Log( 'Sent: '+_command);
     Send_command( _command);

     Log( 'Received: ');
     response:= Get_response;
     Log( response);
     Log( 'BatchCommand finished value : '+BatchCommand_finished);
end;

procedure TAudacity.Test;
begin
     if Log_Ferme then exit;

     do_command('Help: Command=Help');
     do_command('Help: Command="GetInfo"');
     do_command('Help:');
end;

procedure TAudacity.Select_seconds(_Start, _End: double);
begin
     //Send_command('Select:End="4327,532" Mode="Set" RelativeTo="ProjectStart" Start="4324,918"');
     do_command(Format('Select:End="%.3f" Mode="Set" RelativeTo="ProjectStart" Start="%.3f"', [_End, _Start]));
end;

procedure TAudacity.ChangeTempo( _Percentage: double; _SBSMS: Boolean);
begin
     do_command( Format( 'ChangeTempo:Percentage="%.3f" SBSMS="%s"',
                           [
                           _Percentage,
                           BoolToStr( _SBSMS, 'True', 'False')
                           ]));
end;

procedure TAudacity.Play;
begin
     do_command( 'Play:');
end;

procedure TAudacity.Test_Select_seconds;
begin
     //Send_command('Select:End="4327,532" Mode="Set" RelativeTo="ProjectStart" Start="4324,918"');

     Select_seconds( 4324.918, 4327.532);
end;

initialization
finalization
end.

