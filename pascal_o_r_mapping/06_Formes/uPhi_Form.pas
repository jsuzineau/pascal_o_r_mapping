unit uPhi_Form;

{$mode delphi}

interface

uses
    uPhi,
 Classes, SysUtils, Forms, ExtCtrls;

procedure Phi_Form_Up_horizontal  ( _F: TForm);
procedure Phi_Form_Up_vertical    ( _F: TForm);
procedure Phi_Form_Down_horizontal( _F: TForm);
procedure Phi_Form_Down_vertical  ( _F: TForm);

type

 { ThPhi_Form }

 ThPhi_Form
 =
  class
  //Gestion  du cycle de vie
  public
    constructor Create( _F: TForm);
    destructor Destroy; override;
  //Attributs
  private
    F: TForm;
    t: TTimer;
    FormResize_running: Boolean;
    procedure tTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Do_resize;
  end;

implementation

procedure Phi_Form( _F: TForm; _Operation: TPhiSize_function);
var
   P: TPoint;
   Left, Top, Width, Height: Integer;
   dx, dy: Integer;
   dLeft, dTop: Integer;
   NewLeft  ,
   NewTop   ,
   NewWidth ,
   NewHeight: Integer;
begin
     Left  := _F.Left  ;
     Top   := _F.Top   ;
     Width := _F.Width ;
     Height:= _F.Height;

     P:= _Operation( Point( Width, Height));
     NewWidth := P.X;
     NewHeight:= P.Y;

     dx:= NewWidth  - Width ;
     dy:= NewHeight - Height;

     {$IFDEF LINUX}
       dLeft:= 0;
       dTop:=  0;
     {$ELSE}
       dLeft:= 0;
       dTop:=  0;
     {$ENDIF}

     NewLeft  := Left  + dLeft;
     NewTop   := Top   + dTop;

     _F.SetBounds( NewLeft, NewTop, NewWidth, NewHeight);
end;

procedure Phi_Form_Up_horizontal  ( _F: TForm);begin Phi_Form( _F, PhiSizeUp_horizontal  ); end;
procedure Phi_Form_Up_vertical    ( _F: TForm);begin Phi_Form( _F, PhiSizeUp_vertical    ); end;
procedure Phi_Form_Down_horizontal( _F: TForm);begin Phi_Form( _F, PhiSizeDown_horizontal); end;
procedure Phi_Form_Down_vertical  ( _F: TForm);begin Phi_Form( _F, PhiSizeDown_vertical  ); end;

constructor ThPhi_Form.Create( _F: TForm);
begin
     F:= _F;
     F.onResize:= FormResize;

     //t:= TTimer.Create( nil);
     t.OnTimer:= tTimer;

     FormResize_running:= False;
end;

destructor ThPhi_Form.Destroy;
begin
     //F.OnResize
     FreeAndnil( t);
end;

procedure ThPhi_Form.FormResize(Sender: TObject);
begin
     if FormResize_running then exit;
     try
        //Do_resize;
        t.Enabled:= False;
        t.Enabled:= True;
     finally
            FormResize_running:= False;
            end;
end;

procedure ThPhi_Form.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Do_resize;
end;

procedure ThPhi_Form.Do_resize;
begin
     Phi_Form_Up_horizontal( F);
end;

end.

