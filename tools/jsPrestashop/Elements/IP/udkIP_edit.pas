unit udkIP_edit;
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

    ublIP,
    upoolIP,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Lookup_ComboBox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType, LCLIntf;

const
     udkIP_edit_Copy_to_current=0;

type

 { TdkIP_edit }

 TdkIP_edit
 =
  class(TDockable)
  ceip: TChamp_Edit;
  ceip_address: TChamp_Edit;
  cenb: TChamp_Edit;
  cedebut: TChamp_Edit;
  cefin: TChamp_Edit;
//Pascal_udk_edit_declaration_pas
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
   blIP: TblIP;
 end;

implementation

{$R *.lfm}

{ TdkIP_edit }

constructor TdkIP_edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( ceip_address, 'ip_address', 'ip_address');
     Ajoute_Colonne( ceip, 'ip', 'ip');
     Ajoute_Colonne( cenb, 'nb', 'nb');
     Ajoute_Colonne( cedebut, 'debut', 'debut');
     Ajoute_Colonne( cefin, 'fin', 'fin');

//Details_Pascal_udk_edit_Create_AjouteColonne_pas
end;

destructor TdkIP_edit.Destroy;
begin
     inherited Destroy;
end;

procedure TdkIP_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blIP, TblIP, Value);

     Champs_Affecte( blIP,[ ceip_address,ceip,cenb,cedebut,cefin]);
     Champs_Affecte( blIP,[ {Details_Pascal_udk_edit_component_list_pas}]);
end;

procedure TdkIP_edit.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer IP ?',
                                'Suppression de IP',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolIP .Supprimer( blIP );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkIP_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkIP_edit.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkIP_edit_Copy_to_current);
     OpenDocument('https://cloudfilt.com/ip-reputation/lookup?ip='+blIP.ip);

end;

end.

