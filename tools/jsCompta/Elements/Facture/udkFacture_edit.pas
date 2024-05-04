unit udkFacture_edit;
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

    ublFacture,

    uodFacture,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType, LCLIntf, StdCtrls;

type

 { TdkFacture_edit }

 TdkFacture_edit
 =
  class(TDockable)
  bDate: TButton;
  bodFacture: TBitBtn;
  bodFacture_Modele: TButton;
  ceAnnee: TChamp_Edit;
  ceid: TChamp_Edit;
  ceNumero: TChamp_Edit;
  ceNumeroDansAnnee: TChamp_Edit;
  ceDate: TChamp_Edit;
  ceClient_id: TChamp_Edit;
  ceNom: TChamp_Edit;
  ceNbHeures: TChamp_Edit;
  ceMontant: TChamp_Edit;
  clkcbClient: TChamp_Lookup_ComboBox;

  sbNom_from_: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure bDateClick(Sender: TObject);
  procedure bodFactureClick(Sender: TObject);
  procedure bodFacture_ModeleClick(Sender: TObject);
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbNom_from_Click(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blFacture: TblFacture;
 end;

implementation

{$R *.lfm}

{ TdkFacture_edit }

constructor TdkFacture_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( ceAnnee, 'Annee', 'Annee');
     Ajoute_Colonne( ceNumeroDansAnnee, 'NumeroDansAnnee', 'NumeroDansAnnee');
     Ajoute_Colonne( ceNumero, 'Numero', 'Numero');
     Ajoute_Colonne( ceDate, 'Date', 'Date');
     Ajoute_Colonne( ceClient_id, 'Client_id', 'Client_id');
     Ajoute_Colonne( ceNom, 'Nom', 'Nom');
     Ajoute_Colonne( ceNbHeures, 'NbHeures', 'NbHeures');
     Ajoute_Colonne( ceMontant, 'Montant', 'Montant');

     Ajoute_Colonne( clkcbClient, 'Client', 'Client');

end;

destructor TdkFacture_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture, TblFacture, Value);

     Champs_Affecte( blFacture,[ ceid]);
     Champs_Affecte( blFacture,[ ceAnnee,ceNumeroDansAnnee,ceNumero,ceDate,ceClient_id,ceNom,ceNbHeures,ceMontant]);
     Champs_Affecte( blFacture,[ clkcbClient]);
end;

procedure TdkFacture_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Facture ?',
                                'Suppression de Facture',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolFacture .Supprimer( blFacture );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkFacture_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkFacture_edit.bDateClick(Sender: TObject);
begin
     blFacture.Date_from_Now;
end;

procedure TdkFacture_edit.bodFactureClick(Sender: TObject);
var
   odFacture: TodFacture;
   Resultat: String;
begin
     odFacture:= TodFacture.Create;
     try
        odFacture.Init( blFacture);
        Resultat:= odFacture.Visualiser;
     finally
            FreeAndNil( odFacture);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TdkFacture_edit.bodFacture_ModeleClick(Sender: TObject);
var
   odFacture: TodFacture;
   Resultat: String;
begin
     odFacture:= TodFacture.Create;
     try
        odFacture.Init( blFacture);
        Resultat:= odFacture.Editer_Modele_Impression;
     finally
            FreeAndNil( odFacture);
            end;
end;


procedure TdkFacture_edit.sbNom_from_Click(Sender: TObject);
begin
     blFacture.Nom_from_;
end;

end.

