unit ufBatpro_Desk;
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
    uClean,
    uBatpro_StringList,
  Windows, Messages, SysUtils, Variants, Classes,
  System.UITypes, System.Actions,
  FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.ActnList,
  FMX.Types, Vcl.ExtCtrls, Vcl.ActnList;

type
 TfBatpro_Form_Ancetre
 =
  class(TForm)
  //Accés à la liste d'actions
  protected
    function ActionList: FMX.ActnList.TActionList; virtual; abstract;
  end;
 Tprocedure_AUTOEXEC= procedure of object;
 TfBatpro_Desk
 =
  class(TForm)
    tCreate: FMX.Types.TTimer;
    al: FMX.ActnList.TActionList;
    procedure FormCreate(Sender: TObject);
    procedure tCreateTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure WndProc(var Message: TMessage); //override;
  //Dimensionnement                                                .
  public
    procedure Centre_sur_WORKAREA( _Width, _Height: Integer);
    procedure Dimensionne_sur_WORKAREA;
  //FenetreCourante
  private
    FFenetreCourante: TfBatpro_Form_Ancetre;
    procedure SetFenetreCourante(const Value: TfBatpro_Form_Ancetre);
  public
    property FenetreCourante: TfBatpro_Form_Ancetre read FFenetreCourante write SetFenetreCourante;
  //Gestion des actions
  published
    procedure aldkActionExecute(Sender: TObject);
  private
    procedure ActionList_Vide;
    procedure ActionList_from_FenetreCourante;
  //Gestion de l'AUTOEXEC
  public
    AUTOEXEC_actif: Boolean;
    swm_AUTOEXEC: String;
    wm_AUTOEXEC: Integer;
    procedure_AUTOEXEC: Tprocedure_AUTOEXEC;
    procedure Init_AUTOEXEC( _procedure_AUTOEXEC: Tprocedure_AUTOEXEC; _swm_AUTOEXEC: String);
  end;

var
   Batpro_Desk: Boolean= False;
   fBatpro_Desk: TfBatpro_Desk;
   ufBatpro_Desk_fMainWindow_Execute: function :Boolean of object= nil;
   ufBatpro_Desk_GetMainWindow: function :TfBatpro_Form_Ancetre = nil;

implementation

{$R *.fmx}

procedure TfBatpro_Desk.FormCreate(Sender: TObject);
begin
     //tCreate.Enabled:= True;
     tCreateTimer( Self);
     AUTOEXEC_actif:= False;
     procedure_AUTOEXEC:= nil;
end;

procedure TfBatpro_Desk.Centre_sur_WORKAREA( _Width, _Height: Integer);
var
   WorkArea: TRect;
   W, H: Integer;
begin

     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     W:= WorkArea.Right  - WorkArea.Left;
     H:= WorkArea.Bottom - WorkArea.Top ;
     Left:= WorkArea.Left + (W - _Width ) div 2;
     Top := WorkArea.Top  + (H - _Height) div 2;
     Width := _Width ;
     Height:= _Height;
end;

procedure TfBatpro_Desk.Dimensionne_sur_WORKAREA;
var
   WorkArea: TRect;
   W, H: Integer;
begin
     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     W:= WorkArea.Right  - WorkArea.Left;
     H:= WorkArea.Bottom - WorkArea.Top ;
     Left  := WorkArea.Left;
     Top   := WorkArea.Top ;
     Width := W;
     Height:= H;
end;

procedure TfBatpro_Desk.tCreateTimer(Sender: TObject);
begin
     tCreate.Enabled:= False;

     if Assigned( ufBatpro_Desk_GetMainWindow)
     then
         ufBatpro_Desk_GetMainWindow;
         
     if Assigned( ufBatpro_Desk_fMainWindow_Execute)
     then
         ufBatpro_Desk_fMainWindow_Execute;
end;

procedure TfBatpro_Desk.FormClose( Sender: TObject; var Action: TCloseAction);
begin
     if Assigned( FenetreCourante)
     then
         begin
         FenetreCourante.Hide;
         //FenetreCourante.ManualFloat( Rect(0,0,FenetreCourante.UndockWidth, FenetreCourante.UndockHeight));
         FenetreCourante:= nil;
         end;
end;

procedure TfBatpro_Desk.ActionList_Vide;
var
   I: Integer;
   a: TContainedAction;
begin
     while al.ActionCount > 0
     do
       begin
       a:= al.Actions[ 0];
       if a = nil then continue;

       a.ActionList:= nil;
       RemoveComponent( a);
       Free_nil( a);
       end;
end;

procedure TfBatpro_Desk.aldkActionExecute(Sender: TObject);
var
   a, aFenetreCourante: TAction;
begin
     if Affecte_( a  , TAction, Sender)                   then exit;
     if Affecte_( aFenetreCourante, TAction, TObject(Pointer( a.Tag))) then exit;

     if aFenetreCourante.Visible then aFenetreCourante.Execute;
end;

procedure TfBatpro_Desk.ActionList_from_FenetreCourante;
var
   ActionList: FMX.ActnList.TActionList;
   I: Integer;
   a: FMX.ActnList.TAction;
   aFenetreCourante: TContainedAction;
begin
     if nil = FenetreCourante then exit;

     ActionList:= FenetreCourante.ActionList;

     for I:= 0 to ActionList.ActionCount-1
     do
       begin
       aFenetreCourante:= ActionList.Actions[ I];
       if aFenetreCourante = nil then continue;

       a:= FMX.ActnList.TAction.Create( Self);
       if a= nil then continue;

       a.Assign( aFenetreCourante);

       a.ActionList:= al;
       a.Tag:= Integer(Pointer(aFenetreCourante));
       a.OnExecute:= aldkActionExecute;
       end;
end;

procedure TfBatpro_Desk.SetFenetreCourante( const Value: TfBatpro_Form_Ancetre);
begin
     ActionList_Vide;
     FFenetreCourante:= Value;
     ActionList_from_FenetreCourante;
end;

procedure TfBatpro_Desk.Init_AUTOEXEC( _procedure_AUTOEXEC: Tprocedure_AUTOEXEC;
                                       _swm_AUTOEXEC: String);
begin
     procedure_AUTOEXEC:= _procedure_AUTOEXEC;
     swm_AUTOEXEC       := _swm_AUTOEXEC       ;

     wm_AUTOEXEC:= RegisterWindowMessage( PChar( swm_AUTOEXEC));

     AUTOEXEC_actif:= Assigned( procedure_AUTOEXEC);
end;

procedure TfBatpro_Desk.WndProc(var Message: TMessage);
begin
     inherited;

     if not AUTOEXEC_actif                then exit;
     if wm_AUTOEXEC <> Message.Msg        then exit;
     if not Assigned( procedure_AUTOEXEC) then exit;

     procedure_AUTOEXEC;
end;

end.
