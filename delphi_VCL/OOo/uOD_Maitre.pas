unit uOD_Maitre;
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
    u_sys_,

    uBatpro_Ligne,

    uOD,

    SysUtils, Classes;

type
 TOD_Maitre
 =
  class( TOD)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  protected
    Maitres_Titre: array of String;
    Maitres_bl   : array of TBatpro_Ligne;
    procedure Init; override;
    procedure Ajoute_Maitre( _Titre: String; _bl: TBatpro_Ligne);
  end;

implementation

{ TOD_Maitre }

constructor TOD_Maitre.Create;
begin
     inherited;
end;

destructor TOD_Maitre.Destroy;
begin
     inherited;
end;

procedure TOD_Maitre.Init;
begin
     inherited;
     SetLength( Maitres_Titre    , 0);
     SetLength( Maitres_bl       , 0);
end;

procedure TOD_Maitre.Ajoute_Maitre( _Titre: String; _bl: TBatpro_Ligne);
begin
     SetLength( Maitres_Titre, Length( Maitres_Titre)+1);
     SetLength( Maitres_bl   , Length( Maitres_bl   )+1);

     Maitres_Titre[ High( Maitres_Titre)]:= _Titre;
     Maitres_bl   [ High( Maitres_bl   )]:= _bl   ;
end;

end.
