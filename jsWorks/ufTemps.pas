unit ufTemps;

{$mode delphi}

interface

uses
    uClean,
    uodWork_from_Period,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
 StdCtrls, Buttons;

type

 { TfTemps }

 TfTemps
 =
 class(TForm)
  bOK: TBitBtn;
  b0_Now: TButton;
  deFin: TDateEdit;
  deDebut: TDateEdit;
  Label1: TLabel;
  Label2: TLabel;
  procedure b0_NowClick(Sender: TObject);
  procedure bOKClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
 public
 end;

function fTemps: TfTemps;

implementation

{$R *.lfm}

{ TfTemps }

var
   FfTemps: TfTemps= nil;

function fTemps: TfTemps;
begin
     Clean_Get( Result, FfTemps, TfTemps);
end;

procedure TfTemps.FormCreate(Sender: TObject);
begin
     deDebut.Date:= Date;
     deFin  .Date:= deDebut.Date;
end;

procedure TfTemps.bOKClick(Sender: TObject);
begin
     odWork_from_Period.Init( deDebut.Date, deFin.Date);
     SysUtils.ExecuteProcess( '/usr/bin/libreoffice', [odWork_from_Period.Visualiser]);
end;

procedure TfTemps.b0_NowClick(Sender: TObject);
begin
     odWork_from_Period.Init( 0, Now);
     SysUtils.ExecuteProcess( '/usr/bin/libreoffice', [odWork_from_Period.Visualiser]);
end;

initialization
finalization
            Clean_Destroy( FfTemps);
end.

