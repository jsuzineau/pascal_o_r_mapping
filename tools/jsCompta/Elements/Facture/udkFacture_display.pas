unit udkFacture_display;
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
    upoolFacture,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkFacture_display_Copy_to_current=0;

type

 { TdkFacture_display }

 TdkFacture_display
 =
  class(TDockable)
  clAnnee: TChamp_Label;
  clNumeroDansAnnee: TChamp_Label;
  clDate: TChamp_Label;
  clidClient: TChamp_Label;
  clNom: TChamp_Label;
  clNbHeures: TChamp_Label;
  clMontant: TChamp_Label;
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
   blFacture: TblFacture;
 end;

implementation

{$R *.lfm}

{ TdkFacture_display }

constructor TdkFacture_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkFacture_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture, TblFacture, Value);

     Champs_Affecte( blFacture, [clAnnee,clNumeroDansAnnee,clDate,clidClient,clNom,clNbHeures,clMontant]);
end;

procedure TdkFacture_display.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Facture ?',
                                'Suppression de Facture',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolFacture .Supprimer( blFacture );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkFacture_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkFacture_display.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkFacture_display_Copy_to_current);
end;

end.

