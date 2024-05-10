unit udkPassage ;
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

    ublPassage,
    upoolPassage,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Memo, Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
    Dialogs, Buttons, LCLType;

const
     udkPassage_Applique    =0;
     udkPassage_GetSelection=1;
     udkPassage_Select_Play =2;

type

 { TdkPassage }

 TdkPassage
 =
  class(TDockable)
  cePourcentage: TChamp_Edit;
  cmNote: TChamp_Memo;
  cmTexte: TChamp_Memo;
  clDebut: TChamp_Label;
  clFin: TChamp_Label;
  clPage: TChamp_Label;
  sbApplique: TSpeedButton;
  sbDo_Selection: TSpeedButton;
  sbDetruire: TSpeedButton;
  sbGetSelection: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbAppliqueClick(Sender: TObject);
  procedure sbDo_SelectionClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
  procedure sbGetSelectionClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blPassage: TblPassage;
 end;

implementation

{$R *.lfm}

{ TdkPassage }

constructor TdkPassage.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkPassage.Destroy;
begin
     inherited Destroy;
end;


procedure TdkPassage.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blPassage, TblPassage, Value);

     Champs_Affecte( blPassage,
                     [clDebut, clFin, cePourcentage, clPage, cmTexte, cmNote]);
end;

procedure TdkPassage.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer le passage ?',
                                'Suppression de passage',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolPassage .Supprimer( blPassage );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkPassage.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkPassage.sbAppliqueClick(Sender: TObject);
begin
     Envoie_Message( udkPassage_Applique);
end;

procedure TdkPassage.sbGetSelectionClick(Sender: TObject);
begin
     Envoie_Message( udkPassage_GetSelection);
end;

procedure TdkPassage.sbDo_SelectionClick(Sender: TObject);
begin
     Envoie_Message( udkPassage_Select_Play);
end;


end.

