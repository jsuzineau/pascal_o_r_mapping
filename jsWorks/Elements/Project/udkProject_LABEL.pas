unit udkProject_LABEL;
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
    ublProject,
    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

 { TdkProject_LABEL }

 TdkProject_LABEL
 =
  class(TDockable)
    clName: TChamp_Label;
    procedure FormClick(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blProject: TblProject;
 end;

implementation

{$R *.lfm}

{ TdkProject_LABEL }

constructor TdkProject_LABEL.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( clName, 'Nom', 'Name');
end;

destructor TdkProject_LABEL.Destroy;
begin
 inherited Destroy;
end;

procedure TdkProject_LABEL.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blProject, TblProject, Value);

     Champs_Affecte( blProject, [clName]);
end;

procedure TdkProject_LABEL.FormClick(Sender: TObject);
begin
     inherited;
end;

end.

