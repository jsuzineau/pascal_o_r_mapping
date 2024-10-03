unit ubtInteger;
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
    uskInteger,
    SysUtils, Classes;

type
 TbtiInteger= TskiInteger;
 TbtInteger = TskInteger;
 (*
 TbtiInteger
 =
  class(TBinary_TreeItem)
  //Attributs
  public
    Valeur: Integer;
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

 TbtInteger
 =
  class( TBinary_Tree)
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TClass);
    destructor Destroy; override;
  //Méthodes
  public
    function  Ajoute( _Valeur: Integer; _Objet: TObject):Boolean;
    function  Enleve( _Valeur: Integer):Boolean;
    function  Object_from_Valeur( _Valeur: Integer): TObject;
    procedure Element_from_Valeur( var _Resultat; _Valeur: Integer);
    function  Contient( _Valeur: Integer): Boolean;
  end;
*)
implementation
(*
{ TbtiInteger }

function TbtiInteger.Compare( a: TBinary_TreeItem): Shortint;
    // a < self :-1  a=self :0  a > self :+1
var
   bti: TbtiInteger;
begin
     Affecte( bti, TbtiInteger, a);

          if bti = nil            then Result:=  0
     else if bti.Valeur < Valeur  then Result:= -1
     else if bti.Valeur = Valeur  then Result:=  0
     else                              Result:= +1;

end;

procedure TbtiInteger.MoveTo(ToA: TBinary_TreeItem);
var
   bti: TbtiInteger;
begin
     inherited;
     Affecte( bti, TbtiInteger, ToA);

     if Assigned( bti)
     then
         bti.Valeur:= Valeur;
end;

function TbtiInteger.Libelle_interne: String;
begin
     Result:= IntToStr( Valeur);
end;

{ TbtInteger }

constructor TbtInteger.Create( _Classe_Elements: TClass);
begin
     inherited Create( _Classe_Elements, TbtiInteger);
end;

destructor TbtInteger.Destroy;
begin
     inherited;
end;

function TbtInteger.Ajoute( _Valeur: Integer; _Objet: TObject): Boolean;
var
   item: TbtiInteger;
begin
     item:= TbtiInteger.Create;
     item.Valeur:= _Valeur;
     item.Objet := _Objet;
     Result:= Add( item);
end;

function TbtInteger.Enleve(_Valeur: Integer): Boolean;
var
   item: TbtiInteger;
begin
     item:= TbtiInteger.Create;
     item.Valeur:= _Valeur;
     Result:= Remove( item);
end;

function TbtInteger.Contient( _Valeur: Integer): Boolean;
var
   item: TbtiInteger;
   Trouve: TBinary_TreeItem;
begin
     item:= TbtiInteger.Create;
     item.Valeur:= _Valeur;
     Trouve:= Search( Item);

     uBatpro_StringList.CheckClass( Trouve, TbtiInteger);

     Result:= Assigned( Trouve);
end;

function TbtInteger.Object_from_Valeur( _Valeur: Integer): TObject;
var
   item: TbtiInteger;
   Trouve: TBinary_TreeItem;
   bti: TbtiInteger;
begin
     item:= TbtiInteger.Create;
     item.Valeur:= _Valeur;
     Trouve:= Search( Item);
     if Affecte( bti, TbtiInteger, Trouve)
     then
         Result:= bti.Objet
     else
         Result:= nil;
end;

procedure TbtInteger.Element_from_Valeur(var _Resultat; _Valeur: Integer);
begin
     TObject( _Resultat):= Object_from_Valeur( _Valeur);
     CheckClass( _Resultat);
end;
*)
end.

