unit udkFacture_Ligne_display_Facture_Nouveau;
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

    ublFacture_Ligne,
    upoolFacture_Ligne,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Memo, Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
    Dialogs, Buttons, LCLType,Clipbrd;

type

 { TdkFacture_Ligne_display_Facture_Nouveau }

 TdkFacture_Ligne_display_Facture_Nouveau
 =
  class(TDockable)
  cmDate: TChamp_Memo;
  clNbHeures: TChamp_Label;
  clPrix_unitaire: TChamp_Label;
  clMontant: TChamp_Label;
  cmLibelle: TChamp_Memo;
  sbCopy: TSpeedButton;
  procedure cmLibelleEnter(Sender: TObject);
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbCopyClick(Sender: TObject);
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

{ TdkFacture_Ligne_display_Facture_Nouveau }

constructor TdkFacture_Ligne_display_Facture_Nouveau.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkFacture_Ligne_display_Facture_Nouveau.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_Ligne_display_Facture_Nouveau.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture_Ligne, TblFacture_Ligne, Value);

     Champs_Affecte( blFacture_Ligne, [cmDate,cmLibelle,clNbHeures,clPrix_unitaire,clMontant]);
end;

procedure TdkFacture_Ligne_display_Facture_Nouveau.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkFacture_Ligne_display_Facture_Nouveau.cmLibelleEnter(Sender: TObject);
begin
     if nil = blFacture_Ligne then exit;
     Clipboard.AsText:= blFacture_Ligne.Libelle;
end;

procedure TdkFacture_Ligne_display_Facture_Nouveau.sbCopyClick(Sender: TObject);
begin
     if nil = blFacture_Ligne then exit;
     Clipboard.AsText:= blFacture_Ligne.Libelle;
end;

end.

