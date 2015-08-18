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
 StdCtrls, Buttons, ExtCtrls,LCLIntf;

type

 { TfTemps }

 TfTemps
 =
 class(TForm)
  b0_Now: TButton;
  bOK: TBitBtn;
  bSession: TButton;
  bTo_log: TButton;
  deDebut: TDateEdit;
  deFin: TDateEdit;
  ds: TDockableScrollbox;
  Label1: TLabel;
  Label2: TLabel;
  Panel1: TPanel;
  procedure b0_NowClick(Sender: TObject);
  procedure bOKClick(Sender: TObject);
  procedure bSessionClick(Sender: TObject);
  procedure bTo_logClick(Sender: TObject);
  procedure dsClick(Sender: TObject);
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
var
   Resultat: String;
begin
     odWork_from_Period.Init( deDebut.Date, deFin.Date);
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.bSessionClick(Sender: TObject);
begin
     hdmSession.Execute( deDebut.Date, deFin.Date);
     ds.sl:= hdmSession.sl;
end;

procedure TfTemps.bTo_logClick(Sender: TObject);
begin
     hdmSession.To_log;
end;

procedure TfTemps.dsClick(Sender: TObject);
begin

end;

procedure TfTemps.b0_NowClick(Sender: TObject);
var
   Resultat: String;
begin
     odWork_from_Period.Init( 0, Now);
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
finalization
            Clean_Destroy( FfTemps);
end.
