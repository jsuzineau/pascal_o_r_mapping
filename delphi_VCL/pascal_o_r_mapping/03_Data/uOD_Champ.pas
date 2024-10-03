unit uOD_Champ;
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
    SysUtils, Classes,
    uOpenDocument,
    uOD_BatproTextTableContext;

type

 { TOD_Champ }

 TOD_Champ
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _FieldName: String);
    destructor Destroy; override;
  //Attributs
  public
    FieldName: String;
    Debut, Fin: Integer;
    procedure SetDebutFin( _Debut, _Fin: Integer);
  //Persistance dans le document OpenOffice
  private
    function Nom_( Prefixe: String): String;
    function Nom_Debut( Prefixe: String): String;
    function Nom_Fin  ( Prefixe: String): String;
  public
    procedure Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
  end;

  TOD_Champ_array= array of TOD_Champ;

implementation

{ TOD_Champ }

constructor TOD_Champ.Create( _FieldName: String);
begin
     FieldName:= _FieldName;
     Debut    := 0;
     Fin      := 0;
end;

destructor TOD_Champ.Destroy;
begin

     inherited;
end;

procedure TOD_Champ.SetDebutFin(_Debut, _Fin: Integer);
begin
     Debut:= _Debut;
     Fin  := _Fin  ;
end;

function TOD_Champ.Nom_(Prefixe: String): String;
begin
     Result:= Prefixe+FieldName+'_';
end;

function TOD_Champ.Nom_Debut(Prefixe: String): String;
begin
     Result:= Nom_( Prefixe) + 'Debut';
end;

function TOD_Champ.Nom_Fin(Prefixe: String): String;
begin
     Result:= Nom_( Prefixe) + 'Fin' ;
end;

procedure TOD_Champ.Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
begin
     C.Assure_Parametre( Nom_Debut( Prefixe), IntToStr( Debut));
     C.Assure_Parametre( Nom_Fin  ( Prefixe), IntToStr( Fin  ));
end;

procedure TOD_Champ.to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
begin
     C.Ecrire( Nom_Debut( Prefixe), IntToStr( Debut));
     C.Ecrire( Nom_Fin  ( Prefixe), IntToStr( Fin  ));
end;

procedure TOD_Champ.from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
var
   Valeur_Debut: String;
   Valeur_Fin  : String;
begin
     Valeur_Debut:= C.Lire(Nom_Debut(Prefixe)); TryStrToInt(Valeur_Debut,Debut);
     Valeur_Fin  := C.Lire(Nom_Fin  (Prefixe)); TryStrToInt(Valeur_Fin  ,Fin  );
end;

end.
