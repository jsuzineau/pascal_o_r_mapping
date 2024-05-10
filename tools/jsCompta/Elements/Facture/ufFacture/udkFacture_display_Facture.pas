unit udkFacture_display_Facture;
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

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

type

 { TdkFacture_display_Facture }

 TdkFacture_display_Facture
 =
  class(TDockable)
  clNom: TChamp_Label;
  sbDetruire: TSpeedButton;
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

{ TdkFacture_display_Facture }

constructor TdkFacture_display_Facture.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkFacture_display_Facture.Destroy;
begin
     inherited Destroy;
end;

procedure TdkFacture_display_Facture.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blFacture, TblFacture, Value);

     Champs_Affecte( blFacture, [clNom]);
end;

procedure TdkFacture_display_Facture.sbDetruireClick(Sender: TObject);
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

end.

