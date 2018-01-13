unit ucBatpro_Button;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
  u_sys_,
  uClean,
  uBatpro_StringList,
  SysUtils, Classes, FMX.Controls, ExtCtrls, StdCtrls, FMX.Graphics, Windows, FMX.Forms;

type
 TBatpro_Button
 =
  class(TPanel)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Méthodes surchargées
  protected
    procedure Loaded; override;
  //Attributs
  public
    m: TMemo;
  //Gestion du Click
  private
    procedure mClick( Sender:TObject);
    procedure Gere_Click;
  protected
    procedure Click; override;
  //Gestion du Déplacement
  private
    FOnGoNext    : TNotifyEvent;
    FOnGoPrevious: TNotifyEvent;
    FwcNext     : TWinControl;
    FwcPrevious : TWinControl;
    procedure GoNext;
    procedure GoPrevious;
  published
    property OnGoNext     : TNotifyEvent      read FOnGoNext      write FOnGoNext    ;
    property OnGoPrevious : TNotifyEvent      read FOnGoPrevious  write FOnGoPrevious;
    property wcNext     : TWinControl      read FwcNext      write FwcNext     ;
    property wcPrevious : TWinControl      read FwcPrevious  write FwcPrevious ;
  //Gestion de l'état enfoncé
  private
    FDown: Boolean;
    procedure SetDown(const Value: Boolean);
  public
    procedure Releve_autres_boutons;
  published
    property Down: Boolean read FDown write SetDown;
  //Gestion clavier
  private
    procedure mKeyDown( Sender:TObject;var Key:Word;Shift:TShiftState);
  //Gestion aprés chargement
  public
    procedure Apres_Chargement;
  //Gestion de la focalisation
  protected
    procedure DoEnter; override;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_Button]);
end;

var
   slBatpro_Buttons: TBatpro_StringList= nil;
{ TBatpro_Button }

constructor TBatpro_Button.Create(AOwner: TComponent);
begin
     inherited;
     m:= TMemo.Create( Self);
     m.Parent:= Self;
     m.Color:= TColorRec.SysBtnFace;
     m.ReadOnly:= True;
     m.Align:= alClient;
     m.BorderStyle:= bsNone;
     BevelWidth:= 2;
     slBatpro_Buttons.AddObject( sys_Vide, Self);
end;

destructor TBatpro_Button.Destroy;
var
   iSelf: Integer;
begin
     iSelf:= slBatpro_Buttons.IndexOfObject( Self);
     if iSelf <> -1
     then
         slBatpro_Buttons.Delete( iSelf);
     inherited;
end;

procedure TBatpro_Button.Loaded;
begin
     inherited;
     Apres_Chargement;
end;

procedure TBatpro_Button.Apres_Chargement;
begin
     m.Text     := Caption;
     m.OnClick  := mClick;
     m.OnKeyDown:= mKeyDown;
     m.Cursor   := crArrow;
end;

procedure TBatpro_Button.GoNext;
begin
     if Assigned( OnGoNext)
     then
         OnGoNext( Self);
     if Assigned( wcNext)
     then
         wcNext.SetFocus;
end;

procedure TBatpro_Button.GoPrevious;
begin
     if Assigned( OnGoPrevious)
     then
         OnGoPrevious( Self);
     if Assigned( wcPrevious)
     then
         wcPrevious.SetFocus;
end;

procedure TBatpro_Button.SetDown(const Value: Boolean);
begin
     FDown := Value;
     if Down
     then
         BevelOuter:= bvLowered
     else
         BevelOuter:= bvRaised;
     Refresh;
end;

procedure TBatpro_Button.mKeyDown( Sender: TObject; var Key: Word;
                                  Shift: TShiftState);
begin
     case Key
     of
       VK_RETURN: Click;
       VK_UP    : GoPrevious;
       VK_DOWN  : GoNext;
       end
end;

procedure TBatpro_Button.Gere_Click;
begin
     Down:= True;
     Releve_autres_boutons;
end;

procedure TBatpro_Button.mClick(Sender: TObject);
begin
     Gere_Click;
end;

procedure TBatpro_Button.Releve_autres_boutons;
var
   I: Integer;
   o: TObject;
   bb: TBatpro_Button;
begin
     for I:= 0 to slBatpro_Buttons.Count-1
     do
       begin
       o:= slBatpro_Buttons.Objects[I];
       if     Assigned( o)
          and (o is TBatpro_Button)
       then
           begin
           bb:= TBatpro_Button( o);
           if     (bb <> Self)
              and (bb.Parent = Parent)
           then
               bb.Down:= False;
           end;
       end;
end;

procedure TBatpro_Button.DoEnter;
begin
     inherited;
     m.SetFocus;
end;

procedure TBatpro_Button.Click;
begin
     inherited;
     Gere_Click;
end;

initialization
              slBatpro_Buttons:= TBatpro_StringList.Create;
finalization
              Free_nil( slBatpro_Buttons);
end.
