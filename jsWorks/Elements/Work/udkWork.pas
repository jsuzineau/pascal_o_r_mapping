unit udkWork ;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,

    ublTag,
    ublWork,
    upoolWork,

    udkWork_haTag_from_Description_LABEL,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkWork_Copy_to_current=0;

type

 { TdkWork }

 TdkWork
 =
  class(TDockable)
  clBeginning: TChamp_Label;
  clDescription: TChamp_Label;
  clName: TChamp_Label;
  sbCopy_to_current: TSpeedButton;
  sbDetruire: TSpeedButton;
  sbAddTag: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbAddTagClick(Sender: TObject);
  procedure sbCopy_to_currentClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blWork: TblWork;
 //
 private
   blTag: TblTag;
   procedure blTag_nil;
   procedure _from_blTag;
   procedure dsbWork_Tag_from_Description_from_ha;
 end;

implementation

{$R *.lfm}

{ TdkWork }

constructor TdkWork.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkWork.Destroy;
begin
     inherited Destroy;
end;

procedure TdkWork.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);
     if Assigned(blWork)
     then
         blWork.haTag_from_Description.pCharge.Desabonne( Self, dsbWork_Tag_from_Description_from_ha);

     Affecte( blWork, TblWork, Value);

     if Assigned(blWork)
     then
         blWork.haTag_from_Description.pCharge.Abonne( Self, dsbWork_Tag_from_Description_from_ha);
     Champs_Affecte( blWork, [clBeginning,clDescription]);

     dsbWork_Tag_from_Description_from_ha;
end;

procedure TdkWork.blTag_nil;
begin
     blTag:= nil;
     _from_blTag;
end;

procedure TdkWork._from_blTag;
begin
     Champs_Affecte( blTag, [clName]);
     if nil = blTag
     then
         clName.Color:= clWhite
     else
         clName.Color:= blTag.Couleur;
end;

procedure TdkWork.dsbWork_Tag_from_Description_from_ha;
begin
     if nil = blWork then exit;
     blTag:= blTag_from_sl( blWork.haTag_from_Description.sl, 0);
     _from_blTag;
end;

procedure TdkWork.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer la session ?',
                                'Suppression de Session',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolWork .Supprimer( blWork );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkWork.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkWork.sbAddTagClick(Sender: TObject);
begin
     if nil = blTag then exit;
     blWork.haTag_from_Description.Enleve( blTag);
     blWork.Tag( blTag);
     dsbWork_Tag_from_Description_from_ha;
end;

procedure TdkWork.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkWork_Copy_to_current);
end;

end.

