unit ufjsReiki;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TfjsReiki = class(TForm)
    g: TProgressBar;
    t: TTimer;
    l: TLabel;
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
  end;

var
  fjsReiki: TfjsReiki;

implementation

{$R *.lfm}

procedure TfjsReiki.FormCreate(Sender: TObject);
begin
     Debut:= Now;
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

end.
