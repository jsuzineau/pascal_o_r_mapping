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
  ExtCtrls, StdCtrls, Spin, lclvlc, vlc;

type

 { TfjsPaneurythmie }

 TfjsPaneurythmie
 =
  class(TForm)
    bOptions: TButton;
    bStop: TButton;
    cbDeboucler: TCheckBox;
    dsb: TDockableScrollbox;
    lTemps: TLabel;
    lPourcent: TLabel;
    m: TMemo;
    Panel1: TPanel;
    seAudioVolume: TSpinEdit;
    tCreate: TTimer;
    t: TTimer;
    vlc: TLCLVLCPlayer;
    procedure bOptionsClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seAudioVolumeChange(Sender: TObject);
    procedure tCreateTimer(Sender: TObject);
    procedure tTimer(Sender: TObject);
    procedure vlcEOF(Sender: TObject);
    procedure vlcOpening(Sender: TObject);
    procedure vlcPlaying(Sender: TObject);
    procedure vlcPositionChanged(_Sender: TObject; const _Pos: Double);
    procedure vlcStop(Sender: TObject);
    procedure vlcTimeChanged(_Sender: TObject; const _time: TDateTime);
  //Rafraichissement
  protected
    procedure _from_pool;
    procedure Volume_from_VLC;
  //Media
  private
    blMedia: TblMedia;
    Boucler: Boolean;
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
     Boucler:= False;
end;

procedure TfjsPaneurythmie.seAudioVolumeChange(Sender: TObject);
begin
     vlc.AudioVolume:= seAudioVolume.Value;
end;

procedure TfjsPaneurythmie.tCreateTimer(Sender: TObject);
begin
     tCreate.Enabled:= False;
     m.Clear;
     Volume_from_VLC;
     _from_pool;
end;

procedure TfjsPaneurythmie._from_pool;
begin
     dsb.sl:= poolMedia.slFiltre;
end;

procedure TfjsPaneurythmie.Volume_from_VLC;
begin
     seAudioVolume.Value:= vlc.AudioVolume;
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
     vlc.PlayFile(blMedia.NomFichier);
     Volume_from_VLC;
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
     lPourcent.Caption:= Format('%f %%',[_Pos*100]);
end;

procedure TfjsPaneurythmie.vlcStop(Sender: TObject);
begin
     m.Lines.Add( 'Stop');
     Boucler:= blMedia.Boucler;
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

procedure TfjsPaneurythmie.tTimer(Sender: TObject);
begin
     if Boucler
     then
         begin
         Boucler:= False;
         if cbDeboucler.Checked
         then
             cbDeboucler.Checked:= False
         else
             begin
             m.Lines.Add( 'Bouclage');
             _from_Media;
             end;
         end;
end;

end.

