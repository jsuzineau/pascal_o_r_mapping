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
  ExtCtrls, StdCtrls, Spin, ComCtrls, lclvlc, vlc;

type

 { TfjsPaneurythmie }

 TfjsPaneurythmie
 =
  class(TForm)
    bOptions: TButton;
    bStop: TButton;
    cbDeboucler: TCheckBox;
    cbVerrouiller: TCheckBox;
    dsb: TDockableScrollbox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lVerrouille: TLabel;
    lDuree: TLabel;
    lTemps: TLabel;
    lTemps_pbMouseMove: TLabel;
    m: TMemo;
    Panel2: TPanel;
    pc: TPageControl;
    Panel1: TPanel;
    pb: TProgressBar;
    seAudioVolume: TSpinEdit;
    tsLog: TTabSheet;
    tsPrincipal: TTabSheet;
    tCreate: TTimer;
    t: TTimer;
    vlc: TLCLVLCPlayer;
    procedure bOptionsClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure cbVerrouillerChange(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure pbMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
    procedure pbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure seAudioVolumeChange(Sender: TObject);
    procedure tCreateTimer(Sender: TObject);
    procedure tTimer(Sender: TObject);
    procedure vlcEOF(Sender: TObject);
    procedure vlcLengthChanged(_Sender: TObject; const _time: TDateTime);
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
  //durée
  private
    duree: TDateTime;
  //Stop
  private
    StopClicked: Boolean;
  //Verrouillage
  private
    function Verrouille: Boolean;
    procedure lVerrouille_Color_Toggle;
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
     if Verrouille then exit;
     StopClicked:= True;
     vlc.Stop;
end;

procedure TfjsPaneurythmie.dsbSelect(Sender: TObject);
begin
     if Verrouille then exit;
     dsb.Get_bl( blMedia);
     _from_Media;
end;

procedure TfjsPaneurythmie.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose:= not Verrouille;
end;

procedure TfjsPaneurythmie._from_Media;
begin
     StopClicked:= False;
     vlc.PlayFile(blMedia.NomFichier);
     Volume_from_VLC;
     cbVerrouiller.Checked:= blMedia.Verrouiller;
end;

procedure TfjsPaneurythmie.vlcOpening(Sender: TObject);
begin
     m.Lines.Add( 'Opening');
     m.Lines.Add( 'AudioTrackCount: %d',[vlc.AudioTrackCount]);
     m.Lines.Add( 'AudioTrackDescriptions[0]: %s',[vlc.AudioTrackDescriptions[0]]);
     m.Lines.Add( 'AudioDelay: %d',[vlc.AudioDelay]);
     m.Lines.Add( 'VideoLength: %d ms',[vlc.VideoLength]);
     m.Lines.Add( 'VideoDuration: %s',[FormatDateTime( 'hh:nn:ss', vlc.VideoDuration)]);
end;

procedure TfjsPaneurythmie.vlcPlaying(Sender: TObject);
begin
     m.Lines.Add( 'Playing');
end;

procedure TfjsPaneurythmie.vlcPositionChanged( _Sender: TObject;const _Pos: Double);
begin
     //lPourcent.Caption:= Format('%f %%',[_Pos*100]);
     pb.Position:= Trunc(_Pos*1000);
end;

procedure TfjsPaneurythmie.vlcStop(Sender: TObject);
begin
     m.Lines.Add( 'Stop');
     Boucler:= blMedia.Boucler and not StopClicked;
     cbVerrouiller.Checked:= False;
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

procedure TfjsPaneurythmie.vlcLengthChanged( _Sender: TObject; const _time: TDateTime);
begin
     duree:= _time;
     m.Lines.Add( 'LengthChanged : '+FormatDateTime( 'hh:nn:ss', _time));
     lDuree.Caption:= FormatDateTime( '/ hh:nn:ss', duree);
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

procedure TfjsPaneurythmie.pbMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   temps: TDatetime;
begin
     if Verrouille then exit;

     temps:= duree*x/pb.ClientWidth;
     m.Lines.Add( 'pbMouseDown x:%d y: %d  %f %%',[x, y, x*100/pb.ClientWidth]);
     vlc.VideoPosition:= Trunc(temps*24*3600*1000);
end;

procedure TfjsPaneurythmie.pbMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
   temps: TDatetime;
begin
     temps:= duree*x/pb.ClientWidth;
     lTemps_pbMouseMove.Caption:= FormatDateTime( 'hh:nn:ss', temps);
end;

procedure TfjsPaneurythmie.cbVerrouillerChange(Sender: TObject);
begin
     lVerrouille.Visible:= False;
end;

function TfjsPaneurythmie.Verrouille: Boolean;
begin
     Result:= cbVerrouiller.Checked;
     lVerrouille.Visible:= Result;
     lVerrouille_Color_Toggle;
end;

procedure TfjsPaneurythmie.lVerrouille_Color_Toggle;
begin
     if lVerrouille.Font.Color = clRed
     then
         lVerrouille.Font.Color:= clGreen
     else
         lVerrouille.Font.Color:= clRed;
end;


end.


