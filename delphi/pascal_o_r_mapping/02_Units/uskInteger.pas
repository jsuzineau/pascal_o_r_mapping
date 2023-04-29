unit uskInteger;
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
    uSkipList,
    SysUtils, Classes;

type
 TskiInteger
 =
  class(TSkipList_Item)
  //Gestion du cycle de vie
  public
    constructor Create( _Key: Pointer; _Value: TObject); override;
    destructor Destroy; override;
  //Attributs
  public
    Cle: Integer;
  //Clé
  public
    function Key: Pointer; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  //Libelle
  protected
    function Libelle_interne: String; override;
  end;

 TskInteger
 =
  class( TSkipList)
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TClass;
                        _Nom: String= '');
    destructor Destroy; override;
  //Méthodes
  public
    function  Ajoute( _Cle: Integer; _Objet: TObject):Boolean;
    function  Enleve( _Cle: Integer):Boolean;
    function  Value_from_Cle( _Cle: Integer): TObject;
    procedure Element_from_Cle( var _Resultat; _Cle: Integer);
    function  Contient( _Cle: Integer): Boolean;
  end;

implementation

{ TskiInteger }

constructor TskiInteger.Create( _Key: Pointer; _Value: TObject);
begin
     inherited Create( _Key, _Value);
     Cle:= PInteger(_Key)^;
end;

destructor TskiInteger.Destroy;
begin

     inherited;
end;

function TskiInteger.Compare( _Key: Pointer): Shortint;
    // a < self :-1  a=self :0  a > self :+1
var
   I: PInteger;
begin

     I:= PInteger( _Key);

          if I  =  nil then Result:= -1
     else if I^ < Cle  then Result:= -1
     else if I^ = Cle  then Result:=  0
     else                   Result:= +1;

end;

function TskiInteger.Libelle_interne: String;
begin
     Result:= IntToStr( Cle);
end;

function TskiInteger.Key: Pointer;
begin
     Result:= @Cle;
end;

{ TskInteger }

constructor TskInteger.Create( _Classe_Elements: TClass;
                               _Nom: String= '');
begin
     inherited Create( _Classe_Elements, TskiInteger, _Nom);
end;

destructor TskInteger.Destroy;
begin
     inherited;
end;

function TskInteger.Ajoute( _Cle: Integer; _Objet: TObject): Boolean;
begin
     Insert( @_Cle, _Objet);
     Result:= True;
end;

function TskInteger.Enleve(_Cle: Integer): Boolean;
begin
     Delete( @_Cle);
     Result:= True;
end;

function TskInteger.Contient( _Cle: Integer): Boolean;
begin
     Result:= nil <> Search( @_Cle);
end;

function TskInteger.Value_from_Cle( _Cle: Integer): TObject;
var
   Trouve: TSkipList_Item;
begin
     Result:= nil;

     Trouve:= Search( @_Cle);
     if Trouve = nil then exit;

     Result:= Trouve.Value;
end;

procedure TskInteger.Element_from_Cle(var _Resultat; _Cle: Integer);
begin
     TObject( _Resultat):= Value_from_Cle( _Cle);
     CheckClass( _Resultat);
end;

end.

