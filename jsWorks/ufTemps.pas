unit ufTemps;

{$mode delphi}

interface

uses
    uClean,
    ucDockableScrollbox,

    ublTag,
    upoolTag,
    udkTag_LABEL_od,

    uodWork_from_Period,

    uodSession,
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
  bodSession: TButton;
  cbRestreindre_a_un_Tag: TCheckBox;
  deDebut: TDateEdit;
  deFin: TDateEdit;
  ds: TDockableScrollbox;
  dsbTag: TDockableScrollbox;
  Label1: TLabel;
  Label2: TLabel;
  Panel1: TPanel;
  procedure b0_NowClick(Sender: TObject);
  procedure bodSessionClick(Sender: TObject);
  procedure bOKClick(Sender: TObject);
  procedure bSessionClick(Sender: TObject);
  procedure bTo_logClick(Sender: TObject);
  procedure cbRestreindre_a_un_TagClick(Sender: TObject);
  procedure dsClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
   function idTag: Integer;
 public
   hdmSession: ThdmSession;
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

     dsbTag.Classe_dockable:= TdkTag_LABEL_od;
     dsbTag.Classe_Elements:= TblTag;

     hdmSession:= ThdmSession.Create;
end;

procedure TfTemps.FormDestroy(Sender: TObject);
begin
     Free_nil( hdmSession);
end;

function TfTemps.idTag: Integer;
var
   blTag: TblTag;
begin
     Result:= 0;

     if not cbRestreindre_a_un_Tag.Checked then exit;

     dsbTag.Get_bl( blTag);
     if nil = blTag then exit;

     Result:= blTag.id;
end;

procedure TfTemps.bOKClick(Sender: TObject);
var
   Resultat: String;
begin
     odWork_from_Period.Init( deDebut.Date, deFin.Date, idTag);
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.bSessionClick(Sender: TObject);
begin
     ds.sl:= nil;
     hdmSession.Execute( deDebut.Date, deFin.Date, idTag);
     ds.sl:= hdmSession.sl;
end;

procedure TfTemps.bTo_logClick(Sender: TObject);
begin
     hdmSession.To_log;
end;

procedure TfTemps.cbRestreindre_a_un_TagClick(Sender: TObject);
begin
     if not cbRestreindre_a_un_Tag.Checked then exit;

     poolTag.ToutCharger;
     poolTag.TrierFiltre;
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfTemps.dsClick(Sender: TObject);
begin

end;

procedure TfTemps.b0_NowClick(Sender: TObject);
var
   Resultat: String;
begin
     odWork_from_Period.Init( 0, Now, idTag);
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.bodSessionClick(Sender: TObject);
var
   Resultat: String;
begin
     odSession.Init( hdmSession);
     Resultat:= odSession.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
finalization
            Clean_Destroy( FfTemps);
end.

