unit udkTiming_edit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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

    ublTiming,
    upoolTiming,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkTiming_edit_Copy_to_current=0;

type

 { TdkTiming_edit }

 TdkTiming_edit
 =
  class(TDockable)
  cet: TChamp_Edit;
  ceTexte_id: TChamp_Edit;
  clTexte: TChamp_Label;
//Pascal_udk_edit_declaration_pas
  sbCopy_to_current: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
   blTiming: TblTiming;
 end;

implementation

{$R *.lfm}

{ TdkTiming_edit }

constructor TdkTiming_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( cet, 't', 't');
     Ajoute_Colonne( ceTexte_id, 'idTexte', 'idTexte');

//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkTiming_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkTiming_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blTiming, TblTiming, Value);

     Champs_Affecte( blTiming,[ cet,ceTexte_id,clTexte]);
     Champs_Affecte( blTiming,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkTiming_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Timing ?',
                                'Suppression de Timing',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolTiming .Supprimer( blTiming );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkTiming_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkTiming_edit.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkTiming_edit_Copy_to_current);
end;

end.

