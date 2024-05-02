unit ufjsReiki;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type

  { TfjsReiki }

  TfjsReiki = class(TForm)
   bRestart: TButton;
    g: TProgressBar;
    Panel1: TPanel;
    t: TTimer;
    l: TLabel;
    procedure bRestartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tTimer(Sender: TObject);
  private
    { Déclarations privées }
    Nb: Integer;
    Debut: TDateTime;
    Secondes: Integer;
    procedure Sonner;
  public
    { Déclarations publiques }
    procedure Start;
  end;

var
  fjsReiki: TfjsReiki;

implementation

{$R *.lfm}

procedure TfjsReiki.Start;
begin
     Debut:= Now;
end;

procedure TfjsReiki.FormCreate(Sender: TObject);
begin
     Start;
     Nb:= 300;
     g.Max:= Nb;
end;

procedure TfjsReiki.Sonner;
begin
     //MessageBeep( 0);
     Sysutils.Beep;
end;

procedure TfjsReiki.tTimer(Sender: TObject);
var
   Avancement: Integer;
begin
     Secondes:= Trunc( (Now-Debut) * 24 * 3600);
     Avancement:= Secondes mod Nb;
     g.Position:= Avancement;
     if Avancement < 10 then Sonner;
     l.Caption:= Format( '%d min %d sec',
                         [
                         Secondes div 60,
                         Secondes mod 60]);
end;

procedure TfjsReiki.bRestartClick(Sender: TObject);
begin
     Start;
end;

end.

