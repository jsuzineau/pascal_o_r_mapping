unit uSuppression;
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
    uClean,
    uBatpro_StringList,
    uVide,
    uPublieur,
    ubtInteger,
    ubtString,

    uBatpro_Element,
    uBatpro_Ligne,

  SysUtils, Classes;

type
 TSuppression
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TBatpro_Ligne_Class);
    destructor Destroy; override;
  //attributs
  public
    Classe_Elements: TBatpro_Ligne_Class;
    bl: TBatpro_Ligne;
    pAvant, p: TPublieur;
  //Général
  private
    procedure Supprime_interne( _btsCle: TbtString;
                                StringLists: array of TBatpro_StringList);
  public
    procedure Remove_from_StringList( StringList: TBatpro_StringList);
    procedure Remove_from_btString  ( btString  : TbtString         );
    procedure Execute( _btsCle: TbtString;
                       StringLists: array of TBatpro_StringList; var _bl);
    procedure Decharge_Seulement( _btsCle: TbtString;
                                  StringLists: array of TBatpro_StringList; var _bl);
  end;

implementation

{ TSuppression }

constructor TSuppression.Create( _Classe_Elements: TBatpro_Ligne_Class);
begin
     Classe_Elements:= _Classe_Elements;
     bl:= nil;
     pAvant:= TPublieur.Create( 'Suppression.pAvant');
     p:= TPublieur.Create( 'Suppression.p');
end;

destructor TSuppression.Destroy;
begin
     Free_nil( pAvant);
     Free_nil( p);
     inherited;
end;

procedure TSuppression.Remove_from_StringList( StringList: TBatpro_StringList);
begin
     StringList_EnleveObject( StringList, bl);
end;

procedure TSuppression.Remove_from_btString(btString: TbtString);
begin
     if btString = nil then exit;
     btString.Objet_Remove( bl);
end;

procedure TSuppression.Supprime_interne( _btsCle: TbtString;
                                         StringLists: array of TBatpro_StringList);
var
   I: Integer;
begin
     if Assigned( _btsCle) then _btsCle.Objet_Remove( bl);

     for I:= Low( StringLists) to High( StringLists)
     do
       Remove_from_StringList( StringLists[I]);

     p.Publie;
     bl:= nil;
end;

procedure TSuppression.Execute( _btsCle: TbtString;
                                StringLists: array of TBatpro_StringList; var _bl);
begin
     pAvant.Publie;

     bl:= TBatpro_Ligne( _bl);

     CheckClass( bl, Classe_Elements);
     if bl = nil then exit;

     if bl.Suppression_created
     then
         bl.Suppression.Publie;

     if bl.Delete_from_database
     then
         begin
         Supprime_interne( _btsCle, StringLists);
         bl_nil( _bl);
         end;
end;

procedure TSuppression.Decharge_Seulement( _btsCle: TbtString; StringLists: array of TBatpro_StringList; var _bl);
//On détruit en mémoire sans effacer de la base
begin
     bl:= TBatpro_Ligne( _bl);
     if bl = nil then exit;

     if not (bl is TBatpro_Ligne) then exit;//au cas où, pas sûr que çà marche

     Supprime_interne( _btsCle, StringLists);

     bl_nil( _bl);
end;

end.
