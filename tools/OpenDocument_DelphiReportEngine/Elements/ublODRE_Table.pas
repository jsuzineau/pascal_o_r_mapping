unit ublODRE_Table;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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
    uODRE_Table,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB;

type

 { TblODRE_Table }

 TblODRE_Table
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //ODRE_Table
  public
    T: TODRE_Table;
    procedure Charge( _T: TODRE_Table);
  //Champs
  public
    property Nom: String read T.Nom write T.Nom;
  //Gestion de la clé
  public
    class function sCle_from_( _Nom: String): String;
    function sCle: String; override;
  end;

implementation

{ TblODRE_Table }

constructor TblODRE_Table.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
end;

destructor TblODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure TblODRE_Table.Charge( _T: TODRE_Table);
begin
     T:= _T;

     Ajoute_String( T.Nom, 'Nom');
end;

class function TblODRE_Table.sCle_from_( _Nom: String): String;
begin
     Result:= _Nom;
end;

function TblODRE_Table.sCle: String;
begin
     Result:= sCle_from_( T.Nom);
end;

end.

