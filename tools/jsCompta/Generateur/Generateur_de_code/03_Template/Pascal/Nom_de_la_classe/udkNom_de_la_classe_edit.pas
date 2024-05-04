unit udkNom_de_la_classe_edit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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

    ublNom_de_la_classe,
    upoolNom_de_la_classe,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkNom_de_la_classe_edit_Copy_to_current=0;

type

 { TdkNom_de_la_classe_edit }

 TdkNom_de_la_classe_edit
 =
  class(TDockable)
//pattern_udk_edit_components_declaration_pas
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
   blNom_de_la_classe: TblNom_de_la_classe;
 end;

implementation

{$R *.lfm}

{ TdkNom_de_la_classe_edit }

constructor TdkNom_de_la_classe_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
//Pascal_udk_edit_components_Create_AjouteColonne
//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkNom_de_la_classe_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkNom_de_la_classe_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blNom_de_la_classe, TblNom_de_la_classe, Value);

     Champs_Affecte( blNom_de_la_classe,[ {pattern_udk_edit_components_list_pas}]);
     Champs_Affecte( blNom_de_la_classe,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkNom_de_la_classe_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Nom_de_la_classe ?',
                                'Suppression de Nom_de_la_classe',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolNom_de_la_classe .Supprimer( blNom_de_la_classe );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkNom_de_la_classe_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkNom_de_la_classe_edit.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkNom_de_la_classe_edit_Copy_to_current);
end;

end.

