unit ubtString;
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
    u_sys_,
    //uBinary_Tree,
    uskString,
    SysUtils, Classes;

type
 TbtiString= TskiString;
 TbtString= TskString;
(*
 TbtiString
 =
  class(TBinary_TreeItem)
  //Attributs
  public
    Valeur: String;
  //Comparaison
  public
    function  Compare( a:TBinary_TreeItem):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  //Déplacement
  public
    procedure MoveTo( ToA:TBinary_TreeItem);  override;
  //Libelle
  protected
    function Libelle_interne: String; override;
  end;

 TbtString
 =
  class( TBinary_Tree)
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TClass);
    destructor Destroy; override;
  //Méthodes
  public
    function Ajoute( _Valeur: String; _Objet: TObject):Boolean;
    function Enleve( _Valeur: String):Boolean;
    function Object_from_Valeur( _Valeur: String): TObject;
    procedure Element_from_Valeur( var _Resultat; _Valeur: String);
    function  Contient( _Valeur: String): Boolean;
  end;
*)
implementation
(*
{ TbtiString }

function TbtiString.Compare( a: TBinary_TreeItem): Shortint;
    // a < self :-1  a=self :0  a > self :+1
var
   bti: TbtiString;
begin
     Affecte( bti, TbtiString, a);

          if bti = nil            then Result:=  0
     else if bti.Valeur < Valeur  then Result:= -1
     else if bti.Valeur = Valeur  then Result:=  0
     else                              Result:= +1;

end;

procedure TbtiString.MoveTo(ToA: TBinary_TreeItem);
var
   bti: TbtiString;
begin
     inherited;
     Affecte( bti, TbtiString, ToA);

     if Assigned( bti)
     then
         bti.Valeur:= Valeur;
end;

function TbtiString.Libelle_interne: String;
begin
     Result:= Valeur;
end;

{ TbtString }

constructor TbtString.Create(_Classe_Elements: TClass);
begin
     inherited Create( _Classe_Elements, TbtiString);
end;

destructor TbtString.Destroy;
begin
     inherited;
end;

function TbtString.Ajoute( _Valeur: String; _Objet: TObject): Boolean;
var
   item: TbtiString;
begin
     item:= TbtiString.Create;
     item.Valeur:= _Valeur;
     item.Objet := _Objet;
     Result:= Add( item);
end;

function TbtString.Enleve(_Valeur: String): Boolean;
var
   item: TbtiString;
begin
     item:= TbtiString.Create;
     item.Valeur:= _Valeur;
     Result:= Remove( item);
end;

function TbtString.Contient( _Valeur: String): Boolean;
var
   item: TbtiString;
   Trouve: TBinary_TreeItem;
begin
     item:= TbtiString.Create;
     item.Valeur:= _Valeur;
     Trouve:= Search( Item);
     uBatpro_StringList.CheckClass( Trouve, TbtiString);

     Result:= Assigned( Trouve);
end;

function TbtString.Object_from_Valeur(_Valeur: String): TObject;
var
   item: TbtiString;
   Trouve: TBinary_TreeItem;
   bti: TbtiString;
begin
     item:= TbtiString.Create;
     item.Valeur:= _Valeur;
     Trouve:= Search( Item);

     if Affecte( bti, TbtiString, Trouve)
     then
         Result:= bti.Objet
     else
         Result:= nil;
end;

procedure TbtString.Element_from_Valeur(var _Resultat; _Valeur: String);
begin
     TObject( _Resultat):= Object_from_Valeur( _Valeur);
     CheckClass( _Resultat);
end;
*)
end.
