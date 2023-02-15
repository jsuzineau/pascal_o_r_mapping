unit uPhi_Form;

{$mode objfpc}{$H+}

interface

uses
    uPhi,
 Classes, SysUtils, Forms;

procedure Phi_Form_Up_horizontal  ( _F: TForm);
procedure Phi_Form_Up_vertical    ( _F: TForm);
procedure Phi_Form_Down_horizontal( _F: TForm);
procedure Phi_Form_Down_vertical  ( _F: TForm);

implementation

procedure Phi_Form( _F: TForm; _Operation: TPhiSize_function);
var
   P: TPoint;
begin
     P.X:= _F.Width;
     P.Y:= _F.Height;
     P:= _Operation( P);
     _F.Width := P.X;
     _F.Height:= P.Y;
end;

procedure Phi_Form_Up_horizontal  ( _F: TForm);begin Phi_Form( _F, @PhiSizeUp_horizontal  ); end;
procedure Phi_Form_Up_vertical    ( _F: TForm);begin Phi_Form( _F, @PhiSizeUp_vertical    ); end;
procedure Phi_Form_Down_horizontal( _F: TForm);begin Phi_Form( _F, @PhiSizeDown_horizontal); end;
procedure Phi_Form_Down_vertical  ( _F: TForm);begin Phi_Form( _F, @PhiSizeDown_vertical  ); end;

end.

