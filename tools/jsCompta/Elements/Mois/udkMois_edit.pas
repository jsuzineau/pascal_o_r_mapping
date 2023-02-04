unit udkMois_edit;
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

    ublMois,
    upoolMois,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkMois_edit_Copy_to_current=0;

type

 { TdkMois_edit }

 TdkMois_edit
 =
  class(TDockable)
  ceAnnee: TChamp_Edit;
  ceMois: TChamp_Edit;
  ceMontant: TChamp_Edit;
  ceDeclare: TChamp_Edit;
  ceURSSAF: TChamp_Edit;
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
   blMois: TblMois;
 end;

implementation

{$R *.lfm}

{ TdkMois_edit }

constructor TdkMois_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( ceAnnee, 'Annee', 'Annee');
     Ajoute_Colonne( ceMois, 'Mois', 'Mois');
     Ajoute_Colonne( ceMontant, 'Montant', 'Montant');
     Ajoute_Colonne( ceDeclare, 'Declare', 'Declare');
     Ajoute_Colonne( ceURSSAF, 'URSSAF', 'URSSAF');

//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkMois_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkMois_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blMois, TblMois, Value);

     Champs_Affecte( blMois,[ ceAnnee,ceMois,ceMontant,ceDeclare,ceURSSAF]);
     Champs_Affecte( blMois,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkMois_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Mois ?',
                                'Suppression de Mois',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolMois .Supprimer( blMois );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkMois_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkMois_edit.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkMois_edit_Copy_to_current);
end;

end.

