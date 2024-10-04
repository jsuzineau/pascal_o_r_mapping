unit uPhi_Form;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uPhi,
 Classes, SysUtils, VCL.Forms, VCL.Stdctrls,
 {$IFDEF LINUX}
   ExtCtrls,
 {$ENDIF}
 System.Generics.Collections,
 System.UITypes, VCL.Graphics, System.Types;

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
    constructor Create( _F: TForm; _m: TMemo= nil);
    destructor Destroy; override;
  //Attributs
  private
    F: TForm;
    m: TMemo;

    {$IFDEF LINUX}
      t: TTimer;
    {$ENDIF}
    FormResize_running: Boolean;
    {$IFDEF LINUX}
      procedure t_Timer(Sender: TObject);
    {$ENDIF}
    procedure FormResize(Sender: TObject);
    procedure Do_resize;
    procedure Log_Top_Left( _S: String);
  end;
 TListe_hPhi_Form= TList<ThPhi_Form>;

var
   Liste_hPhi_Form: TListe_hPhi_Form= nil;

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

constructor ThPhi_Form.Create(_F: TForm; _m: TMemo);
begin
     F:= _F;
     F.onResize:= FormResize;

     m:= _m;

     {$IFDEF LINUX}
       t:= TTimer.Create( nil);
       t.Enabled:= False;
       t.OnTimer:= t_Timer;
       t.Interval:= 1000;
     {$ENDIF}

     FormResize_running:= False;
     Liste_hPhi_Form.Add( Self);

     Log_Top_Left( ClassName+'.Create:'+F.Name+': '+F.ClassName);
end;

destructor ThPhi_Form.Destroy;
begin
     //F.OnResize
     {$IFDEF LINUX}
       FreeAndnil( t);
     {$ENDIF}
end;

procedure ThPhi_Form.FormResize(Sender: TObject);
begin
     if FormResize_running then exit;
     try
        FormResize_running:= True;
        {$IFDEF LINUX}
          t.Enabled:= False;
          t.Enabled:= True;
        {$ELSE}
          Do_resize;
        {$ENDIF}
     finally
            FormResize_running:= False;
            end;
end;

{$IFDEF LINUX}
  procedure ThPhi_Form.t_Timer(Sender: TObject);
  begin
       t.Enabled:= False;
       Do_resize;
  end;
{$ENDIF}

procedure ThPhi_Form.Do_resize;
begin
     Log_Top_Left( 'Do_resize, début');
     Phi_Form_Up_horizontal( F);
     Log_Top_Left( 'Do_resize, fin');
end;

procedure ThPhi_Form.Log_Top_Left(_S: String);
begin
     if nil = m then exit;

     m.Lines.Add(_S);
     //m.Lines.Add('Left  : '+Format('%4d', [F.Left  ]));
     m.Lines.Add('Top   : '+Format('%4d', [F.Top   ]));
     //m.Lines.Add('Width : '+Format('%4d', [F.Width ]));
     m.Lines.Add('Height: '+Format('%4d', [F.Height]));
end;

initialization
              Liste_hPhi_Form:= TListe_hPhi_Form.Create;
finalization
            FreeAndNil( Liste_hPhi_Form);
end.

