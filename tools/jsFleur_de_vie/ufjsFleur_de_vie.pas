unit ufjsFleur_de_vie;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
 Spin, uFleur_de_vie;

type
 { TfjsFleur_de_vie }

 TfjsFleur_de_vie
 =
  class(TForm)
   bStart: TButton;
   bStop: TButton;
   fseE: TFloatSpinEdit;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
    m: TMemo;
    Panel1: TPanel;
    seI_Start: TSpinEdit;
    seMaxThreads: TSpinEdit;
    procedure bStartClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseEChange(Sender: TObject);
  private
    th: TthCalcul;
    procedure Calcule;
  public

  end;

var
 fjsFleur_de_vie: TfjsFleur_de_vie;

implementation

{$R *.lfm}

{ TfjsFleur_de_vie }

procedure TfjsFleur_de_vie.FormCreate(Sender: TObject);
begin
     th:= nil;
end;

procedure TfjsFleur_de_vie.bStartClick(Sender: TObject);
begin
     Calcule;
end;

procedure TfjsFleur_de_vie.fseEChange(Sender: TObject);
begin
     Calcule;
end;

procedure TfjsFleur_de_vie.Calcule;
var
   I_Start: Integer;
begin
     bStop .Show;
     bStart.Hide;

     if Assigned(th) then th.Terminate;

     I_Start:= seI_Start.Value;
     E:= fseE.Value;
     MaxThreads:= seMaxThreads.Value;
     th:= TthCalcul.Create( I_Start, m);
     if Assigned(th.FatalException)
     then
         raise th.FatalException;

     th.start;
end;

procedure TfjsFleur_de_vie.bStopClick(Sender: TObject);
begin
     if Assigned(th) then th.Terminate;
     th:= nil;
     bStop .Hide;
     bStart.Show;
end;


end.

