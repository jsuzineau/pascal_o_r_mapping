unit udkClient_edit;
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

    ublClient,
    upoolClient,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;


type

 { TdkClient_edit }

 TdkClient_edit
 =
  class(TDockable)
  ceNom: TChamp_Edit;
  ceAdresse_1: TChamp_Edit;
  ceAdresse_2: TChamp_Edit;
  ceAdresse_3: TChamp_Edit;
  ceCode_Postal: TChamp_Edit;
  ceVille: TChamp_Edit;
  ceTarif_horaire: TChamp_Edit;
//Pascal_udk_edit_declaration_pas
  sbAdresse1_from_Nom: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbAdresse1_from_NomClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blClient: TblClient;
 end;

implementation

{$R *.lfm}

{ TdkClient_edit }

constructor TdkClient_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( ceNom, 'Nom', 'Nom');
     (*
     Ajoute_Colonne( ceAdresse_1, 'Adresse_1', 'Adresse_1');
     Ajoute_Colonne( ceAdresse_2, 'Adresse_2', 'Adresse_2');
     Ajoute_Colonne( ceAdresse_3, 'Adresse_3', 'Adresse_3');
     Ajoute_Colonne( ceCode_Postal, 'Code_Postal', 'Code_Postal');
     Ajoute_Colonne( ceVille, 'Ville', 'Ville');
     Ajoute_Colonne( ceTarif_horaire, 'Tarif_horaire', 'Tarif_horaire');
     *)

//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkClient_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkClient_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blClient, TblClient, Value);

     Champs_Affecte( blClient,[ ceNom,ceAdresse_1,ceAdresse_2,ceAdresse_3,ceCode_Postal,ceVille,ceTarif_horaire]);
     Champs_Affecte( blClient,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkClient_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Client ?',
                                'Suppression de Client',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolClient .Supprimer( blClient );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkClient_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkClient_edit.sbAdresse1_from_NomClick(Sender: TObject);
begin
     if nil = blClient then exit;
     blClient.Adresse_1_from_Nom;
end;

end.

