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
  ExtCtrls, StdCtrls, Spin, ComCtrls, EditBtn, lclvlc, vlc;

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
    te: TTimeEdit;
    tAlarme: TTimer;
    tVLC_Synchronize: TTimer;
    tsLog: TTabSheet;
    tsPrincipal: TTabSheet;
    tShow: TTimer;
    vlc: TLCLVLCPlayer;
    procedure bOptionsClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure cbVerrouillerChange(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pbMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure seAudioVolumeChange(Sender: TObject);
    procedure tAlarmeTimer(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
    procedure tVLC_SynchronizeTimer(Sender: TObject);
    procedure vlcOpening(Sender: TObject);
    procedure vlcPlaying(Sender: TObject);
    procedure vlcPositionChanged(_Sender: TObject; const _Pos: Double);
    procedure vlcStop(Sender: TObject);
    procedure vlcTimeChanged(_Sender: TObject; const _time: TDateTime);
    procedure vlcEOF(Sender: TObject);
    procedure vlcLengthChanged(_Sender: TObject; const _time: TDateTime);
  //Rafraichissement
  protected
    procedure _from_pool;
    procedure Volume_from_VLC;
  //Media
  private
    blMedia: TblMedia;
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
  // vlc thread synchronisation
  //procedure vlcOpening(Sender: TObject);
  private
    vlcOpening_fired: Boolean;
    procedure Do_vlcOpening;
  //procedure vlcPlaying(Sender: TObject);
  private
    vlcPlaying_fired: Boolean;
    procedure Do_vlcPlaying;
  //procedure vlcPositionChanged(_Sender: TObject; const _Pos: Double);
  private
    vlcPositionChanged_fired: Boolean;
    vlcPositionChanged_Pos: Double;
    procedure Do_vlcPositionChanged;
  //procedure vlcStop(Sender: TObject);
  private
    vlcStop_fired: Boolean;
    procedure Do_vlcStop;
  //procedure vlcTimeChanged(_Sender: TObject; const _time: TDateTime);
  private
    vlcTimeChanged_fired: Boolean;
    vlcTimeChanged_time: TDateTime;
    procedure Do_vlcTimeChanged;
  //procedure vlcEOF(Sender: TObject);
  private
    vlcEOF_fired: Boolean;
    procedure Do_vlcEOF;
  //procedure vlcLengthChanged(_Sender: TObject; const _time: TDateTime);
  private
    vlcLengthChanged_fired: Boolean;
    vlcLengthChanged_time: TDateTime;
    procedure Do_vlcLengthChanged;
  //Ajustement position / duree / heurefin
  private
    procedure Position_from_Duree_HeureFin;
  //Alarme
  private
    Alarme_running: Boolean;
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

     vlcOpening_fired        := False;
     vlcPlaying_fired        := False;
     vlcPositionChanged_fired:= False;
     vlcStop_fired           := False;
     vlcTimeChanged_fired    := False;
     vlcEOF_fired            := False;
     vlcLengthChanged_fired  := False;
end;

procedure TfjsPaneurythmie.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfjsPaneurythmie.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     m.Clear;
     seAudioVolume.Value:= 100;
     _from_pool;
end;

procedure TfjsPaneurythmie.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose:= not Verrouille;
end;

procedure TfjsPaneurythmie.seAudioVolumeChange(Sender: TObject);
begin
     vlc.AudioVolume:= seAudioVolume.Value;
end;

procedure TfjsPaneurythmie.tAlarmeTimer(Sender: TObject);
var
   delta: double;
begin
     if blMedia = nil then exit;

     delta:= Frac(Now)-Frac(te.Time);
     if (0 <= delta)and(delta<=2/(24*60))// moins de 2 min aprés l'alarme
     then
         begin
         if not Alarme_running
         then
             begin
             Alarme_running:= True;
             te.Hide;
             _from_Media;
             end;
         end
     else
         begin
         if Alarme_running
         then
             te.Show;
         Alarme_running:= False;
         end;
end;

procedure TfjsPaneurythmie._from_pool;
begin
     dsb.sl:= poolMedia.slFiltre;
end;

procedure TfjsPaneurythmie.Volume_from_VLC;
begin
     if 0 = vlc.AudioVolume then vlc.AudioVolume:=100;
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
     blMedia.Prepare_Liste;
     _from_Media;
end;

procedure TfjsPaneurythmie._from_Media;
begin
     StopClicked:= False;
     vlc.PlayFile(blMedia.NomFichier_from_Liste);
     Volume_from_VLC;
     cbVerrouiller.Checked:= blMedia.Verrouiller;
end;

procedure TfjsPaneurythmie.Do_vlcOpening;
begin
     vlcOpening_fired:= False;
     m.Lines.Add( 'Opening');
     m.Lines.Add( 'AudioTrackCount: %d',[vlc.AudioTrackCount]);
     m.Lines.Add( 'AudioTrackDescriptions[0]: %s',[vlc.AudioTrackDescriptions[0]]);
     m.Lines.Add( 'AudioDelay: %d',[vlc.AudioDelay]);
     m.Lines.Add( 'VideoLength: %d ms',[vlc.VideoLength]);
     m.Lines.Add( 'VideoDuration: %s',[FormatDateTime( 'hh:nn:ss', vlc.VideoDuration)]);
end;

procedure TfjsPaneurythmie.vlcOpening(Sender: TObject);
begin
     vlcOpening_fired:= True;
end;

procedure TfjsPaneurythmie.Do_vlcPlaying;
begin
     vlcPlaying_fired:= False;
     m.Lines.Add( 'Playing');
end;

procedure TfjsPaneurythmie.vlcPlaying(Sender: TObject);
begin
     vlcPlaying_fired:= True;
end;

procedure TfjsPaneurythmie.Do_vlcPositionChanged;
begin
     vlcPositionChanged_fired:= False;
     //lPourcent.Caption:= Format('%f %%',[_Pos*100]);
     pb.Position:= Trunc(vlcPositionChanged_Pos*1000);
end;

procedure TfjsPaneurythmie.vlcPositionChanged( _Sender: TObject;const _Pos: Double);
begin
     vlcPositionChanged_Pos:= _Pos;
     vlcPositionChanged_fired:= True;
end;

procedure TfjsPaneurythmie.Do_vlcStop;
begin
     vlcStop_fired:= False;
     m.Lines.Add( 'Stop');
     if cbDeboucler.Checked
     then
         cbDeboucler.Checked:= False
     else
         if blMedia.Boucler and not StopClicked
         then
             begin
             m.Lines.Add( 'Bouclage');
             _from_Media;
             end;
     cbVerrouiller.Checked:= False;
end;

procedure TfjsPaneurythmie.vlcStop(Sender: TObject);
begin
     vlcStop_fired:= True;
end;

procedure TfjsPaneurythmie.Do_vlcTimeChanged;
begin
     vlcTimeChanged_fired:= False;
     lTemps.Caption:= FormatDateTime( 'hh:nn:ss', vlcTimeChanged_time);
end;

procedure TfjsPaneurythmie.vlcTimeChanged(_Sender: TObject;const _time: TDateTime);
begin
     vlcTimeChanged_time:= _time;
     vlcTimeChanged_fired:= True;
end;

procedure TfjsPaneurythmie.Do_vlcEOF;
begin
     vlcEOF_fired:=  False;
     m.Lines.Add( 'EOF');
end;

procedure TfjsPaneurythmie.vlcEOF(Sender: TObject);
begin
     vlcEOF_fired:=  True;
end;

procedure TfjsPaneurythmie.Do_vlcLengthChanged;
begin
     vlcLengthChanged_fired:= False;
     duree:= vlcLengthChanged_time;
     m.Lines.Add( 'LengthChanged : '+FormatDateTime( 'hh:nn:ss', vlcLengthChanged_time));
     lDuree.Caption:= FormatDateTime( '/ hh:nn:ss', duree);
     if blMedia.Boucler
     then
         Position_from_Duree_HeureFin;
end;

procedure TfjsPaneurythmie.Position_from_Duree_HeureFin;
var
   HeureFin, Heure: TDateTime;
   Restant: TDateTime;
   temps: TDateTime;
begin
     HeureFin:= Frac(blMedia.HeureFin);
     Heure   := Frac(Now             );

     if HeureFin <= Heure then HeureFin:= HeureFin+1;

     Restant:= HeureFin-Heure;
     if (Restant < duree) or not blMedia.Is_Liste
     then
         begin
         temps:= (1-Frac(Restant / duree))*duree;
         vlc.VideoPosition:= Trunc(temps*24*3600*1000);
         end;
end;

procedure TfjsPaneurythmie.vlcLengthChanged( _Sender: TObject; const _time: TDateTime);
begin
     vlcLengthChanged_time:= _time;
     vlcLengthChanged_fired:= True;
end;

procedure TfjsPaneurythmie.tVLC_SynchronizeTimer(Sender: TObject);
begin
     if vlcOpening_fired         then Do_vlcOpening;
     if vlcPlaying_fired         then Do_vlcPlaying;
     if vlcPositionChanged_fired then Do_vlcPositionChanged;
     if vlcStop_fired            then Do_vlcStop;
     if vlcTimeChanged_fired     then Do_vlcTimeChanged;
     if vlcEOF_fired             then Do_vlcEOF;
     if vlcLengthChanged_fired   then Do_vlcLengthChanged;
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


