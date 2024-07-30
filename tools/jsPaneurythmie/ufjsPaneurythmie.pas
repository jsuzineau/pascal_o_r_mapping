unit ufjsPaneurythmie;

{$mode objfpc}{$H+}

interface

uses
  uPhi_Form,
  udmDatabase,
  ublMedia,
  upoolMedia,
  udkMedia_Display,
  ufMedia_dsb,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,  ucDockableScrollbox,
  ExtCtrls, StdCtrls, lclvlc, vlc;

type

 { TfjsPaneurythmie }

 TfjsPaneurythmie
 =
  class(TForm)
    bOptions: TButton;
    bStop: TButton;
    dsb: TDockableScrollbox;
    lTemps: TLabel;
    lPourcent: TLabel;
    m: TMemo;
    Panel1: TPanel;
    tCreate: TTimer;
    vlc: TLCLVLCPlayer;
    vlc_liste: TVLCMediaListPlayer;
    procedure bOptionsClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tCreateTimer(Sender: TObject);
    procedure vlcEOF(Sender: TObject);
    procedure vlcOpening(Sender: TObject);
    procedure vlcPlaying(Sender: TObject);
    procedure vlcPositionChanged(_Sender: TObject; const _Pos: Double);
    procedure vlcStop(Sender: TObject);
    procedure vlcTimeChanged(_Sender: TObject; const _time: TDateTime);
  //Rafraichissement
  protected
    procedure _from_pool;
  //Media
  private
    blMedia: TblMedia;
    procedure _from_Media;
  end;

var
 fjsPaneurythmie: TfjsPaneurythmie;

implementation

{$R *.lfm}

{ TfjsPaneurythmie }

procedure TfjsPaneurythmie.FormCreate(Sender: TObject);
begin
     Caption:= Caption+' - '+dmDatabase.jsDataConnexion.Base_sur;
     ThPhi_Form.Create( Self);
     dsb.Classe_dockable:= TdkMedia_Display;
     dsb.Classe_Elements:= TblMedia;
     poolMedia.ToutCharger;
     tCreate.Enabled:= True;
end;

procedure TfjsPaneurythmie.tCreateTimer(Sender: TObject);
begin
     tCreate.Enabled:= False;
     _from_pool;
end;

procedure TfjsPaneurythmie._from_pool;
begin
     dsb.sl:= poolMedia.slFiltre;
end;

procedure TfjsPaneurythmie.bOptionsClick(Sender: TObject);
begin
     fMedia_dsb.Execute;
end;

procedure TfjsPaneurythmie.bStopClick(Sender: TObject);
begin
     vlc.Stop;
end;

procedure TfjsPaneurythmie.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blMedia);
     _from_Media;
end;

procedure TfjsPaneurythmie._from_Media;
begin
     m.Clear;
     vlc.PlayFile(blMedia.NomFichier);
end;

procedure TfjsPaneurythmie.vlcOpening(Sender: TObject);
begin
     m.Lines.Add( 'Opening');
end;

procedure TfjsPaneurythmie.vlcPlaying(Sender: TObject);
begin
     m.Lines.Add( 'Playing');
end;

procedure TfjsPaneurythmie.vlcPositionChanged( _Sender: TObject;const _Pos: Double);
begin
     //lTemps.Caption:= FormatFloat( '',APos);
     //m.Lines.Add( 'PositionChanged: %f', [ _Pos]);
     lPourcent.Caption:= Format('%f %%',[_Pos*100]);
end;

procedure TfjsPaneurythmie.vlcStop(Sender: TObject);
begin
     m.Lines.Add( 'Stop');
     if nil = blMedia then exit;
     if blMedia.Boucler
     then
         begin
         vlc.Stop;
         _from_Media;
         end;
end;

procedure TfjsPaneurythmie.vlcTimeChanged(_Sender: TObject;
 const _time: TDateTime);
begin
     lTemps.Caption:= FormatDateTime( 'hh:nn:ss', _time);
end;

procedure TfjsPaneurythmie.vlcEOF(Sender: TObject);
begin
     m.Lines.Add( 'EOF');
end;

end.

