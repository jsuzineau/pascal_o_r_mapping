unit ucBatpro_StringGrid;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    uWindows,
    u_sys_,
  Windows, Messages, SysUtils, Classes,
  DB, VCL.Grids;

type
 TBatpro_StringGrid
 =
  class( TStringGrid)
  //Général
  protected
    procedure DrawCell( ACol, ARow: Integer; ARect: TRect;
                        AState: TGridDrawState); //à revoir, n'existe pas en FMX
    //procedure TopLeftChanged; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    property LeftCol;
    property TopRow;
    procedure BeforeDestruction; override;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_StringGrid]);
end;

{ TBatpro_StringGrid }

constructor TBatpro_StringGrid.Create( AOwner: TComponent);
begin
     inherited;
end;

procedure TBatpro_StringGrid.DrawCell( ACol, ARow: Integer; ARect: TRect;
                                  AState: TGridDrawState);
{recopié de DBGrids, procedure WriteText, passage du format TAlignment
  au format d'alignement de DrawText de l'API Windows}
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
{fin recopie}
begin
     inherited;
end;

//procedure TBatpro_StringGrid.TopLeftChanged;
//begin
//     inherited;
//end;

procedure TBatpro_StringGrid.Loaded;
begin
     inherited;
end;

procedure TBatpro_StringGrid.BeforeDestruction;
begin
     inherited;
end;

end.

