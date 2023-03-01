unit udkPiece_display;
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

 { TdkPiece_display }

 TdkPiece_display
 =
  class(TDockable)
  clDate: TChamp_Label;
  clFacture_Montant_s: TChamp_Label;
  clFacture_Nom: TChamp_Label;
  clNumero: TChamp_Label;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blPiece: TblPiece;
 end;

implementation

{$R *.lfm}

{ TdkPiece_display }

constructor TdkPiece_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( clNumero, 'Numero');
     Ajoute_Colonne( clDate  , 'Date'  );
     Ajoute_Colonne( clFacture_Nom      , 'Facture_Nom'      );
     Ajoute_Colonne( clFacture_Montant_s, 'Facture_Montant_s');
end;

destructor TdkPiece_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkPiece_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blPiece, TblPiece, Value);
     //if Assigned( blPiece)
     //then
     //    blPiece.Facture_Aggrege;
     Champs_Affecte( blPiece,[clDate,clNumero,clFacture_Nom,clFacture_Montant_s]);
end;

procedure TdkPiece_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

