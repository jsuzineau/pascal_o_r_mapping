unit ucPanBMP;
{                 Copyright (c) 1996,1997  Jean SUZINEAU                       }
//2003 10 28: suppression des références à Curseurs et uChain pour insertion
//            dans Batpro_Composants

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, StdCtrls, Themes,
    ucImaTrs;

type
 TPanelBMPTransparent
 =
  class(TPanelTransparent)
  private
    { Déclarations privées }
    FCouleurTransparente: TColor;
    FBitmap: TBitmap;
    procedure SetCouleurTransparente(Value: TColor);
    procedure SetBitmap(Value: TBitmap);
  protected
    { Déclarations protégées }
    procedure Paint; override;
  public
    { Déclarations publiques }
    constructor Create(anOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
    procedure BitmapChanged(Sender: TObject);
    property CouleurTransparente
    :
     TColor
     read    FCouleurTransparente
     write   SetCouleurTransparente
     default clBlack;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
  end;

 TPanelBMP
 =
  class(TPanel)
  private
    { Déclarations privées }
    FBrush: TBrush;
    FBitmap: TBitmap;
    procedure SetBrush(Value: TBrush);
    procedure SetBitmap(Value: TBitmap);
  protected
    { Déclarations protégées }
    procedure Paint; override;
  public
    { Déclarations publiques }
    constructor Create(anOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
    procedure BitmapChanged(Sender: TObject);
    procedure StyleChanged(Sender: TObject);
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Brush: TBrush read FBrush write SetBrush;
  end;

 TGroupBoxBMP
 =
  class(TCustomControl)
  private
    FBrush: TBrush;
    FBitmap: TBitmap;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure SetBitmap(Value: TBitmap);
    procedure SetBrush(Value: TBrush);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground default True;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    procedure BitmapChanged(Sender: TObject);
    procedure StyleChanged(Sender: TObject);
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Brush: TBrush read FBrush write SetBrush;
  end;

procedure Register;

implementation

uses
    uClean;

procedure Register;
begin
     RegisterComponents( 'Batpro images',
                         [ TPanelBMPTransparent,
                           TPanelBMP,
                           TGroupBoxBMP]);
end;

{ TPanelBMPTransparent }

constructor TPanelBMPTransparent.Create(anOwner: TComponent);
begin
     inherited Create( anOwner);
     Width:= 10;
     Height:= 10;
     FBitmap:= TBitmap.Create;
     FBitmap.onChange:= BitmapChanged;
     FCouleurTransparente:= clBlack;
end;

destructor TPanelBMPTransparent.Destroy;
begin
     FBitmap.Free;
     inherited Destroy;
end;

procedure TPanelBMPTransparent.SetCouleurTransparente(Value: TColor);
begin
     if FCouleurTransparente <> Value
     then
         begin
         FCouleurTransparente:= Value;
         Invalidate;
         end;
end;

procedure TPanelBMPTransparent.SetBitmap(Value: TBitmap);
begin
     FBitmap.Assign( Value);
     FBitmap.onChange:= BitmapChanged;
     Invalidate;
end;

procedure TPanelBMPTransparent.BitmapChanged(Sender: TObject);
begin
     Invalidate;
     Width:= Bitmap.Width;
     Height:= Bitmap.Height;
end;

procedure TPanelBMPTransparent.Paint;
begin
     if csDesigning in ComponentState
     then
         with Canvas
         do
           begin
           Pen.Style := psDash;
           Brush.Style := bsClear;
           Rectangle(0, 0, Width, Height);
           end;
     DrawTransparentBitmap( Canvas.Handle, FBitmap.Handle,
                            0, 0, FCouleurTransparente);
     inherited Paint;
end;

{ TPanelBMP }

constructor TPanelBMP.Create(anOwner: TComponent);
begin
     inherited Create( anOwner);
     Width:= 10;
     Height:= 10;
     FBitmap:= TBitmap.Create;
     FBitmap.onChange:= BitmapChanged;
     FBrush := TBrush.Create;
     FBrush.OnChange := StyleChanged;
     WindowProc:= WndProc;
end;

destructor TPanelBMP.Destroy;
begin
     FBrush .Free;
     FBitmap.Free;
     inherited Destroy;
end;

procedure TPanelBMP.SetBitmap(Value: TBitmap);
begin
     FBitmap.Assign( Value);
     FBitmap.onChange:= BitmapChanged;
     Invalidate;
end;

procedure TPanelBMP.BitmapChanged(Sender: TObject);
begin
     Invalidate;
end;

procedure TPanelBMP.StyleChanged(Sender: TObject);
begin
     Invalidate;
end;

procedure TPanelBMP.Paint;
var
  Rect: TRect;
  FontHeight: Integer;
  Buff: Array[0..255] of char;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
begin
     if csDesigning in ComponentState
     then
         with Canvas
         do
           begin
           Pen.Style := psDash;
           Brush.Style := bsClear;
           Rectangle(0, 0, Width, Height);
           end;
     Rect := GetClientRect;
    with Canvas
    do
      begin
      Brush.Color := Color;
      Brush.Style := bsClear;
      Font := Self.Font;
      FontHeight := TextHeight('W');
      with Rect
      do
        begin
        Top := ((Bottom + Top) - FontHeight) div 2;
        Bottom := Top + FontHeight;
        end;
      end;
    DrawText( Handle, StrPCopy( Buff,
(*
              PChar(
*)
                              Caption),
              -1, Rect, (DT_EXPANDTABS or
              DT_VCENTER) or Alignments[Alignment]);

     Canvas.StretchDraw( ClientRect, FBitmap);
     Canvas.Brush.Assign( FBrush);
     Canvas.Rectangle( ClientRect);
end;

procedure TPanelBMP.SetBrush(Value: TBrush);
begin
     FBrush.Assign( Value);
end;

{ TGroupBoxBMP }

constructor TGroupBoxBMP.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     ControlStyle
     :=
       [ csAcceptsControls, csCaptureMouse, csClickEvents,
         csSetCaption, csDoubleClicks, csReplicatable, csParentBackground];
     Width := 185;
     Height := 105;
     FBitmap:= TBitmap.Create;
     FBitmap.onChange:= BitmapChanged;
     FBrush := TBrush.Create;
     FBrush.OnChange := StyleChanged;
end;

destructor TGroupBoxBMP.Destroy;
begin
     FBrush .Free;
     FBitmap.Free;
     inherited;
end;

procedure TGroupBoxBMP.SetBitmap(Value: TBitmap);
begin
     FBitmap.Assign( Value);
     FBitmap.onChange:= BitmapChanged;
     Invalidate;
end;

procedure TGroupBoxBMP.BitmapChanged(Sender: TObject);
begin
     Invalidate;
end;

procedure TGroupBoxBMP.StyleChanged(Sender: TObject);
begin
     Invalidate;
end;

procedure TGroupBoxBMP.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  Canvas.Font := Font;
  Inc(Rect.Top, Canvas.TextHeight('0'));
  InflateRect(Rect, -1, -1);
  if Ctl3d then InflateRect(Rect, -1, -1);
end;

procedure TGroupBoxBMP.CreateParams(var Params: TCreateParams);
begin
     inherited CreateParams(Params);
     with Params.WindowClass
     do
       style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TGroupBoxBMP.Paint;
var
  H: Integer;
  R: TRect;
  Flags: Longint;
  CaptionRect,
  OuterRect: TRect;
  Size: TSize;
  Box: TThemedButton;
  Details: TThemedElementDetails;
  OldBrush: TBrush;
begin
     Canvas.StretchDraw( ClientRect, FBitmap);

     OldBrush:= TBrush.Create;
     try
        OldBrush.Assign( Canvas.Brush);

        Canvas.Pen.Style:= psClear;
        Canvas.Brush.Assign( FBrush);
        Canvas.Font:= Self.Font;
        H := Canvas.TextHeight('0');
        R := Rect(0, H div 2 - 1, Width, Height);
        Canvas.Rectangle( R);
     finally
            Canvas.Brush.Assign( OldBrush);
            Free_nil( OldBrush);
            end;

     with Canvas
     do
       begin
       Font := Self.Font;

       if ThemeServices.ThemesEnabled
       then
           begin
           if Text <> ''
           then
               begin
               GetTextExtentPoint32(Handle, PChar(Text), Length(Text), Size);
               CaptionRect := Rect(0, 0, Size.cx, Size.cy);
               if not UseRightToLeftAlignment
               then
                   OffsetRect(CaptionRect, 8, 0)
               else
                   OffsetRect(CaptionRect, Width - 8 - CaptionRect.Right, 0);
               end
           else
               CaptionRect := Rect(0, 0, 0, 0);

           OuterRect := ClientRect;
           OuterRect.Top := (CaptionRect.Bottom - CaptionRect.Top) div 2;
           with CaptionRect
           do
             ExcludeClipRect(Handle, Left, Top, Right, Bottom);
           if Enabled
           then
               Box := tbGroupBoxNormal
           else
               Box := tbGroupBoxDisabled;
           Details := ThemeServices.GetElementDetails(Box);
           ThemeServices.DrawElement(Handle, Details, OuterRect);

           SelectClipRgn(Handle, 0);
           if Text <> ''
           then
               ThemeServices.DrawText( Handle, Details, Text, CaptionRect,
                                       DT_LEFT, 0);
           end
       else
           begin
           H := TextHeight('0');
           R := Rect(0, H div 2 - 1, Width, Height);
           if Ctl3D
           then
               begin
               Inc(R.Left);
               Inc(R.Top);
               Brush.Color := clBtnHighlight;
               FrameRect(R);
               OffsetRect(R, -1, -1);
               Brush.Color := clBtnShadow;
               end
           else
               Brush.Color := clWindowFrame;
           FrameRect(R);
           if Text <> ''
           then
               begin
               if not UseRightToLeftAlignment
               then
                   R := Rect(8, 0, 0, H)
               else
                   R := Rect(R.Right - Canvas.TextWidth(Text) - 8, 0, 0, H);
               Flags := DrawTextBiDiModeFlags(DT_SINGLELINE);
               DrawText( Handle, PChar(Text), Length(Text), R,
                         Flags or DT_CALCRECT);
               Brush.Color := Color;
               DrawText(Handle, PChar(Text), Length(Text), R, Flags);
               end;
           end;
       end;
end;

procedure TGroupBoxBMP.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SelectFirst;
      Result := 1;
    end else
      inherited;
end;

procedure TGroupBoxBMP.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
  Realign;
end;

procedure TGroupBoxBMP.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  Realign;
end;

procedure TGroupBoxBMP.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TGroupBoxBMP.SetBrush(Value: TBrush);
begin
     FBrush.Assign( Value);
end;

end.
