unit uContexteClasse;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    uGenerateur_de_code_Ancetre,
  SysUtils, Classes;

type

 { TContexteClasse }

 TContexteClasse
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _g: TGenerateur_de_code_Ancetre; _Nom_de_la_table: String; _NbChamps: Integer);
    destructor Destroy; override;
  //Attributs
  public
    g: TGenerateur_de_code_Ancetre;
    Nom_de_la_table: String;
    Nom_de_la_classe: String;
    NomTableMinuscule: String;
    NbChamps: Integer;

    nfLibelle : String;

    slCle: TStringList;
    slLibelle :TStringList;
    slIndex   :TStringList;
  end;

implementation

{ TContexteClasse }

constructor TContexteClasse.Create( _g: TGenerateur_de_code_Ancetre; _Nom_de_la_table: String; _NbChamps: Integer);
var
   nfCle: String;
   nfIndex   : String;
begin
     g:= _g;
     Nom_de_la_table := _Nom_de_la_table;
     Nom_de_la_classe:= UpperCase( Nom_de_la_table);
     NomTableMinuscule:= LowerCase( Nom_de_la_table);
     NbChamps:= _NbChamps;

     slCle:= TStringList.Create;
     nfCle:= g.sRepParametres+Nom_de_la_table+'.Cle.txt';
     if FileExists( nfCle)
     then
         slCle.LoadFromFile( nfCle)
     else
         slCle.SaveToFile( nfCle);

     //Gestion du libellé
     slLibelle:= TStringList.Create;
     nfLibelle:= g.sRepParametres+Nom_de_la_classe+'.libelle.txt';
     if FileExists( nfLibelle)
     then
         slLibelle.LoadFromFile( nfLibelle)
     else
         slLibelle.SaveToFile( nfLibelle);

end;

destructor TContexteClasse.Destroy;
begin
     FreeAndNil( slCle);
     FreeAndNil( slLibelle);
     inherited Destroy;
end;

end.
