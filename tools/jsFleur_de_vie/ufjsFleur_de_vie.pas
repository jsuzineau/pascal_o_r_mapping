unit ufjsFleur_de_vie;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
 Spin, uFleur_de_vie;

type
 { TthCalcul }

 TthCalcul
 =
  class( TThread)
  public
    constructor Create( _I_Start: Integer);
  protected
    procedure T( _Rayon: Integer);
    procedure Execute; override;
  //Display
  private
    Display_S: String;
    procedure Do_Display;
    procedure Display( _Display_S: String);
  //Display_Clear
  private
    procedure Do_Display_Clear;
    procedure Display_Clear;
  //I_Start
  private
    I_Start: Integer;
  end;

 { TfjsFleur_de_vie }

 TfjsFleur_de_vie
 =
  class(TForm)
   bStart: TButton;
   fseE: TFloatSpinEdit;
    m: TMemo;
    Panel1: TPanel;
    seI_Start: TSpinEdit;
    procedure bStartClick(Sender: TObject);
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

{ TthCalcul }

constructor TthCalcul.Create(_I_Start: Integer);
begin
     I_Start:= _I_Start;
     FreeOnTerminate:= True;;
     inherited Create( True);
end;

procedure TthCalcul.Do_Display;
begin
     fjsFleur_de_vie.m.Lines.Add( Display_S);
end;

procedure TthCalcul.Display(_Display_S: String);
begin
     Display_S:= _Display_S;
     Synchronize( @Do_Display);
end;

procedure TthCalcul.Do_Display_Clear;
begin
     fjsFleur_de_vie.m.Clear;
end;

procedure TthCalcul.Display_Clear;
begin
     Synchronize( @Do_Display_Clear);
end;

procedure TthCalcul.T(_Rayon: Integer);
var
   N: Int64;
   S: String;
   Dimension: double;
begin
     N:= Fleur_de_vie_NbSpheres_from_Rayon( _Rayon, fjsFleur_de_vie.m);
     if _Rayon = 1
     then
         Dimension:= 0
     else
         Dimension:= ln(N)/ln(_Rayon+1);
     S:= Format('R=%3d,  N=%7d, ln(N)/ln(R)=%f',[_Rayon, N, Dimension]);
     Display( S);
end;

procedure TthCalcul.Execute;
var
   I: Integer;
begin
     Display_Clear;
     I:= I_Start;
     repeat
           T(I);
           Inc( I);
     until Terminated;
end;

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
     if Assigned(th) then th.Terminate;

     I_Start:= seI_Start.Value;
     E:= fseE.Value;
     th:= TthCalcul.Create( I_Start);
     if Assigned(th.FatalException)
     then
         raise th.FatalException;

     th.start;
end;


end.

