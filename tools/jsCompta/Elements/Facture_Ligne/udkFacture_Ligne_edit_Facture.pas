unit udkFacture_Ligne_edit_Facture;
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
    ucChamp_Lookup_ComboBox, ucChamp_Memo,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType,Clipbrd;

type

 { TdkFacture_Ligne_edit_Facture }

 TdkFacture_Ligne_edit_Facture
 =
  class(TDockable)
  ceNbHeures: TChamp_Edit;
  cePrix_unitaire: TChamp_Edit;
  ceMontant: TChamp_Edit;
  cmDate: TChamp_Memo;
  cmLibelle: TChamp_Memo;

  sbDetruire: TSpeedButton;
  procedure cmLibelleEnter(Sender: TObject);
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

{ TdkFacture_Ligne_edit_Facture }

constructor TdkFacture_Ligne_edit_Facture.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( cmDate, 'Date', 'Date');
     Ajoute_Colonne( cmLibelle, 'Libelle', 'Libelle');
     Ajoute_Colonne( ceNbHeures, 'NbHeures', 'NbHeures');
     Ajoute_Colonne( cePrix_unitaire, 'Prix_unitaire', 'Prix_unitaire');
     Ajoute_Colonne( ceMontant, 'Montant', 'Montant');
end;

destructor TdkFacture_Ligne_edit_Facture.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_Ligne_edit_Facture.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture_Ligne, TblFacture_Ligne, Value);

     Champs_Affecte( blFacture_Ligne,[ cmDate,cmLibelle,ceNbHeures,cePrix_unitaire,ceMontant]);
end;

procedure TdkFacture_Ligne_edit_Facture.sbDetruireClick(Sender: TObject);
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

procedure TdkFacture_Ligne_edit_Facture.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkFacture_Ligne_edit_Facture.cmLibelleEnter(Sender: TObject);
begin
     if nil = blFacture_Ligne         then exit;
     if '' <> blFacture_Ligne.Libelle then exit;

     //blFacture_Ligne.cLibelle.asString:= Clipboard.AsText;
     cmLibelle.Lines.Text:= Clipboard.AsText;
end;

end.

