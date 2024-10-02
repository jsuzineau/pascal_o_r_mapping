unit ufType_Tag;
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

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean,
    ublType_Tag,
    upoolType_Tag,
    udkType_Tag_EDIT,
 Classes, SysUtils, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.ExtCtrls, FMX.Types, System.UITypes,
 ucDockableScrollbox, FMX.Controls.Presentation, FMX.StdCtrls;

type

 { TfType_Tag }

 TfType_Tag = class(TForm)
  dsb: TDockableScrollbox;
  t: TTimer;
  procedure dsbNouveau(Sender: TObject);
  procedure tTimer(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( TheOwner: TComponent); override;
    destructor Destroy; override;
  //Méthodes
  public
    function Execute: Boolean;
 end;

function fType_Tag: TfType_Tag;

implementation

{$R *.fmx}

{ TfType_Tag }

var
   FfType_Tag: TfType_Tag= nil;

function fType_Tag: TfType_Tag;
begin
     Clean_Get( Result, FfType_Tag, TfType_Tag);
end;

constructor TfType_Tag.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);
     dsb.Classe_dockable:= TdkType_Tag_EDIT;
     dsb.Classe_Elements:= TblType_Tag;
end;

destructor TfType_Tag.Destroy;
begin
     inherited Destroy;
end;

function TfType_Tag.Execute: Boolean;
begin
     t.Enabled:= True;
     Result:= ShowModal = mrOK;
end;

procedure TfType_Tag.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     poolType_Tag.ToutCharger;
     dsb.sl:= poolType_Tag.slT;
end;

procedure TfType_Tag.dsbNouveau(Sender: TObject);
var
   bl: TblType_Tag;
begin
     poolType_Tag.Nouveau_Base( bl);
     dsb.sl:= poolType_Tag.slT;
     dsb.Goto_bl( bl);
end;

end.

