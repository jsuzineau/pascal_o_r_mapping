unit ufjsKaraoke;

{$mode objfpc}{$H+}

interface

uses
    udmDatabase,
    upooltexte,
    ufTexte_dsb,
    ufChargement,
    ufTiming_record,
    ufTiming_Play,
    ufTiming_dsb,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

 { TfjsKaraoke }

 TfjsKaraoke = class(TForm)
  bChargement: TButton;
  bTexte: TButton;
  bRecord: TButton;
  bPlay: TButton;
  bTiming: TButton;
  l1: TLabel;
  l2: TLabel;
  l3: TLabel;
  l4: TLabel;
  t: TTimer;
  tShow: TTimer;
  procedure bChargementClick(Sender: TObject);
  procedure bPlayClick(Sender: TObject);
  procedure bRecordClick(Sender: TObject);
  procedure bTexteClick(Sender: TObject);
  procedure bTimingClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure tShowTimer(Sender: TObject);
  procedure tTimer(Sender: TObject);
 private
   const texte: array of string
   =
    (
//123456789012345678901234567890123456789012345678901234567890123456789
//         1         2         3         4         5         6
     '1',
     '12',
     '123',
     '1234',
     '12345',
     '123456',
     '1234567',
     '12345678',
     '123456789',
     '1234567890',
     '12345678901',
     '123456789012',
     '1234567890123',
     '12345678901234',
     '123456789012345',
     '1234567890123456',
     '12345678901234567',
     '123456789012345678',
     '1234567890123456789',
     '12345678901234567890',
     '123456789012345678901',
     '1234567890123456789012',
     '12345678901234567890123',
     '123456789012345678901234',
     '1234567890123456789012345',
     '12345678901234567890123456',
     '123456789012345678901234567',
     '1234567890123456789012345678',
     '12345678901234567890123456789',
     '123456789012345678901234567890',
     '1234567890123456789012345678901',
     '12345678901234567890123456789012',
     '123456789012345678901234567890123',
     '1234567890123456789012345678901234',
     '12345678901234567890123456789012345',
     '123456789012345678901234567890123456',
     '1234567890123456789012345678901234567',
     '12345678901234567890123456789012345678',
     '123456789012345678901234567890123456789',
     '1234567890123456789012345678901234567890'
    );
 private
   i: Integer;
 end;

var
 fjsKaraoke: TfjsKaraoke;

implementation

{$R *.lfm}

{ TfjsKaraoke }

procedure TfjsKaraoke.FormCreate(Sender: TObject);
begin
     Caption:= Caption+' - '+dmDatabase.jsDataConnexion.Base_sur;
     pooltexte.ToutCharger;

     i:= Low(texte);
end;

procedure TfjsKaraoke.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfjsKaraoke.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     bPlay.Click;
     Left:= 0;
end;

procedure TfjsKaraoke.tTimer(Sender: TObject);
var
   i1:Integer;
   i2:Integer;
   i3:Integer;
   i4:Integer;
begin
     i1:= (i  ) mod Length( texte);
     i2:= (i+1) mod Length( texte);
     i3:= (i+2) mod Length( texte);
     i4:= (i+3) mod Length( texte);

     l1.Caption:= texte[i1];
     l2.Caption:= texte[i2];
     l3.Caption:= texte[i3];
     l4.Caption:= texte[i4];

     l1.Left:= 0; l1.Top:= 0;
     l2.Left:= 0; l2.Top:= l1.Top+l1.Height;
     l3.Left:= 0; l3.Top:= l2.Top+l2.Height;
     l4.Left:= 0; l4.Top:= l3.Top+l3.Height;

     Inc(i);
end;

procedure TfjsKaraoke.bChargementClick(Sender: TObject);
begin
     fChargement.Show;
end;

procedure TfjsKaraoke.bTexteClick(Sender: TObject);
begin
     fTexte_dsb.Execute;
end;

procedure TfjsKaraoke.bTimingClick(Sender: TObject);
begin
     fTiming_dsb.Execute;
end;

procedure TfjsKaraoke.bRecordClick(Sender: TObject);
begin
     fTiming_record.Execute;
end;

procedure TfjsKaraoke.bPlayClick(Sender: TObject);
begin
     fTiming_Play.Execute;
end;

end.

