unit udkMedia_edit;
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
    uDataUtilsU,

    ublMedia,
    upoolMedia,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox, ucChamp_CheckBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

type

 { TdkMedia_edit }

 TdkMedia_edit
 =
  class(TDockable)
  ceTitre: TChamp_Edit;
  ceNomFichier: TChamp_Edit;
  cbBoucler: TChamp_CheckBox;
  cbVerrouiller: TChamp_CheckBox;
  ceHeureFin: TChamp_Edit;
  od: TOpenDialog;
//Pascal_udk_edit_declaration_pas
  sbNomFichier: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure ceHeureFinMouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbNomFichierClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blMedia: TblMedia;
 end;

implementation

{$R *.lfm}

{ TdkMedia_edit }

constructor TdkMedia_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     //Ajoute_Colonne( ceTitre, 'Titre', 'Titre');
     //Ajoute_Colonne( ceNomFichier, 'NomFichier', 'NomFichier');
     //Ajoute_Colonne( cbBoucler, 'Boucler', 'Boucler');
     //Ajoute_Colonne( cbVerrouiller, 'Verrouiller', 'Verrouiller');

//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkMedia_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkMedia_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blMedia, TblMedia, Value);

     Champs_Affecte( blMedia,[ ceTitre,ceNomFichier,cbBoucler,cbVerrouiller,ceHeureFin]);
     Champs_Affecte( blMedia,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkMedia_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Media ?',
                                'Suppression de Media',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolMedia .Supprimer( blMedia );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkMedia_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkMedia_edit.ceHeureFinMouseDown(Sender: TObject;
 Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     if mbRight <> Button then exit;
     blMedia.cHeureFin.asDatetime:= Now;
end;

procedure TdkMedia_edit.sbNomFichierClick(Sender: TObject);
begin
     if nil = blMedia then exit;
     od.FileName:= blMedia.NomFichier;
     if od.Execute
     then
         blMedia.cNomFichier.Chaine:= od.FileName;
end;

end.

