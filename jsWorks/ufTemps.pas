unit ufTemps;

{$mode delphi}

interface

uses
    uClean, ucDockableScrollbox,
    uodWork_from_Period,
    ublSession,
    uhdmSession,
    udkSession,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
 StdCtrls, Buttons, ExtCtrls;

type

 { TfTemps }

 TfTemps
 =
 class(TForm)
  b0_Now: TButton;
  bOK: TBitBtn;
  bSession: TButton;
  deDebut: TDateEdit;
  deFin: TDateEdit;
  ds: TDockableScrollbox;
  Label1: TLabel;
  Label2: TLabel;
  Panel1: TPanel;
  procedure b0_NowClick(Sender: TObject);
  procedure bOKClick(Sender: TObject);
  procedure bSessionClick(Sender: TObject);
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

     ds.Classe_dockable:= TdkSession;
     ds.Classe_Elements:= TblSession;
end;

procedure TfTemps.bOKClick(Sender: TObject);
begin
     odWork_from_Period.Init( deDebut.Date, deFin.Date);
     SysUtils.ExecuteProcess( '/usr/bin/libreoffice', [odWork_from_Period.Visualiser]);
end;

procedure TfTemps.bSessionClick(Sender: TObject);
begin
     hdmSession.Execute( deDebut.Date, deFin.Date);
     ds.sl:= hdmSession.sl;
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

