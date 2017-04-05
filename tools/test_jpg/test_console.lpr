program test_console;

{$mode objfpc}{$H+}

uses
    uDimensions_from_pasjpeg,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, CustApp
 { you can add units after this };

type

 { TMyApplication }

 TMyApplication = class(TCustomApplication)
 protected
  procedure DoRun; override;
 public
  constructor Create(TheOwner: TComponent); override;
  destructor Destroy; override;
  procedure WriteHelp; virtual;
  procedure Test;
 end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
 ErrorMsg: String;
begin
 // quick check parameters
 ErrorMsg:=CheckOptions('h', 'help');
 if ErrorMsg<>'' then begin
  ShowException(Exception.Create(ErrorMsg));
  Terminate;
  Exit;
 end;

 // parse parameters
 if HasOption('h', 'help') then begin
  WriteHelp;
  Terminate;
  Exit;
 end;

 { add your program here }
 Test;
 // stop program loop
 Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
 inherited Create(TheOwner);
 StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
 inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
 { add your help code here }
 writeln('Usage: ', ExeName, ' -h');
end;

procedure TMyApplication.Test;
var
   d: TDimensions_from_pasjpeg;
begin
     d:= TDimensions_from_pasjpeg.Create( 'Test.jpg');
     try
        WriteLn( 'Dimensions_from_pasjpeg:');
        WriteLn( '  Largeur: '+ IntToStr( d.Width));
        WriteLn( '  Hauteur: '+ IntToStr( d.Height));
        WriteLn( '  Density_Units: '+ IntToStr( d.Density_units)+' '+d.sDensity_Units);
        WriteLn( '  X Density : '+IntToStr( d.Xdensity));
        WriteLn( '  Y Density : '+IntToStr( d.Ydensity));
        WriteLn( '  svgWidth : '+d.svgWidth);
        WriteLn( '  svgHeight: '+d.svgHeight);
        WriteLn( d.Test_Formate_cm);
     finally
            FreeAndNil( d);
            end;
end;

var
 Application: TMyApplication;
begin
 Application:=TMyApplication.Create(nil);
 Application.Title:='My Application';
 Application.Run;
 Application.Free;
end.

