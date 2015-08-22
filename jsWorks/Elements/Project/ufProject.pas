unit ufProject;
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
    ublProject,
    upoolProject,
    udkProject_EDIT,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 ucDockableScrollbox;

type

 { TfProject }

 TfProject = class(TForm)
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

var
 fProject: TfProject;

implementation

{$R *.lfm}

{ TfProject }

constructor TfProject.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);
     dsb.Classe_dockable:= TdkProject_EDIT;
     dsb.Classe_Elements:= TblProject;
end;

destructor TfProject.Destroy;
begin
     inherited Destroy;
end;

function TfProject.Execute: Boolean;
begin
     t.Enabled:= True;
     Result:= ShowModal = mrOK;
end;

procedure TfProject.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     dsb.sl:= poolProject.slT;
end;

procedure TfProject.dsbNouveau(Sender: TObject);
var
   bl: TblProject;
begin
     poolProject.Nouveau_Base( bl);
     dsb.sl:= poolProject.slT;
     dsb.Goto_bl( bl);
end;

end.

