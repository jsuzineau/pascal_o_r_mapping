unit udkFacture_Ligne_edit;
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

    ublFacture_Ligne,
    upoolFacture_Ligne,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkFacture_Ligne_edit_Copy_to_current=0;

type

 { TdkFacture_Ligne_edit }

 TdkFacture_Ligne_edit
 =
  class(TDockable)
  ceFacture_id: TChamp_Edit;
  ceDate: TChamp_Edit;
  ceLibelle: TChamp_Edit;
  ceNbHeures: TChamp_Edit;
  cePrix_unitaire: TChamp_Edit;
  ceMontant: TChamp_Edit;
  clkcbFacture: TChamp_Lookup_ComboBox;

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
   blFacture_Ligne: TblFacture_Ligne;
 end;

implementation

{$R *.lfm}

{ TdkFacture_Ligne_edit }

constructor TdkFacture_Ligne_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( ceDate, 'Date', 'Date');
     Ajoute_Colonne( ceLibelle, 'Libelle', 'Libelle');
     Ajoute_Colonne( ceNbHeures, 'NbHeures', 'NbHeures');
     Ajoute_Colonne( cePrix_unitaire, 'Prix_unitaire', 'Prix_unitaire');
     Ajoute_Colonne( ceMontant, 'Montant', 'Montant');
end;

destructor TdkFacture_Ligne_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_Ligne_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture_Ligne, TblFacture_Ligne, Value);

     Champs_Affecte( blFacture_Ligne,[ ceFacture_id,ceDate,ceLibelle,ceNbHeures,cePrix_unitaire,ceMontant]);
     Champs_Affecte( blFacture_Ligne,[ clkcbFacture]);
end;

procedure TdkFacture_Ligne_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Facture_Ligne ?',
                                'Suppression de Facture_Ligne',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolFacture_Ligne .Supprimer( blFacture_Ligne );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkFacture_Ligne_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkFacture_Ligne_edit.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkFacture_Ligne_edit_Copy_to_current);
end;

end.

