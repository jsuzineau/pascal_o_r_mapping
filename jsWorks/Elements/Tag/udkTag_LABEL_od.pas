unit udkTag_LABEL_od;
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
    ublTag,
    uDockable,
    uodTag,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TdkTag_LABEL_od }

 TdkTag_LABEL_od
 =
  class(TDockable)
   bOD: TButton;
    clName: TChamp_Label;
    procedure bODClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blTag: TblTag;
 end;

implementation

{$R *.lfm}

{ TdkTag_LABEL_od }

constructor TdkTag_LABEL_od.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     //Ajoute_Colonne( clName, 'Nom', 'Name');
end;

destructor TdkTag_LABEL_od.Destroy;
begin
 inherited Destroy;
end;

procedure TdkTag_LABEL_od.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blTag, TblTag, Value);

     Champs_Affecte( blTag, [clName]);
     if nil = blTag
     then
         Color:= clWhite
     else
         Color:= blTag.Couleur;
end;

procedure TdkTag_LABEL_od.FormClick(Sender: TObject);
begin
     inherited;
end;

procedure TdkTag_LABEL_od.bODClick(Sender: TObject);
begin
     if  blTag = nil then exit;

     odTag.Previsualiser:= True;
     odTag.Init( blTag);
     odTag.Visualiser;
end;

end.

