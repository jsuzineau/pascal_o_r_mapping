unit udkTexte_display_1;
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

    ublTexte,
    upoolTexte,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkTexte_display_Copy_to_current=0;
var
   //udkTexte_display_1_Field='Cyrillique';//Translitteration //Francais
   udkTexte_display_1_Field:String='Translitteration';//Francais

type

 { TdkTexte_display_1 }

 TdkTexte_display_1
 =
  class(TDockable)
  cl: TChamp_Label;
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
   blTexte: TblTexte;
 end;

implementation

{$R *.lfm}

{ TdkTexte_display }

constructor TdkTexte_display_1.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkTexte_display_1.Destroy;
begin
     inherited Destroy;
end;

procedure TdkTexte_display_1.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blTexte, TblTexte, Value);

     cl.Field:= udkTexte_display_1_Field;
     Champs_Affecte( blTexte, [cl]);
end;

procedure TdkTexte_display_1.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Texte ?',
                                'Suppression de Texte',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolTexte .Supprimer( blTexte );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkTexte_display_1.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkTexte_display_1.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkTexte_display_Copy_to_current);
end;

end.

