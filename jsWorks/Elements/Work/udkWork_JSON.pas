unit udkWork_JSON;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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

    ublWork,
    upoolWork,

    upoolJSON,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    ucChamp_Memo, Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
    Dialogs, Buttons, LCLType, ExtCtrls, StdCtrls;

const
     udkWork_JSON_Capture=0;

type

 { TdkWork_JSON }

 TdkWork_JSON
 =
  class(TDockable)
  bCapture: TButton;
  clBeginning: TChamp_Label;
  clEnd_: TChamp_Label;
  cmDescription: TChamp_Memo;
  Panel1: TPanel;
  procedure bCaptureClick(Sender: TObject);
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blJSON: TblJSON;
 end;

implementation

{$R *.lfm}

{ TdkWork_JSON }

constructor TdkWork_JSON.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkWork_JSON.Destroy;
begin
     inherited Destroy;
end;

procedure TdkWork_JSON.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blJSON, TblJSON, Value);

     Champs_Affecte( blJSON, [clBeginning,clEnd_,cmDescription]);
end;

procedure TdkWork_JSON.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkWork_JSON.bCaptureClick(Sender: TObject);
begin
     Envoie_Message( udkWork_JSON_Capture);
end;


end.

