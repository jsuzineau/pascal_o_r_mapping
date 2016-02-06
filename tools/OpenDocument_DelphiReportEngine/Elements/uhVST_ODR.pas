unit uhVST_ODR;
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uBatpro_StringList,
    uuStrings,
    uVide,

  Classes, SysUtils, Controls, VirtualTrees;

type

 { ThVST_ODR_Ligne }

 ThVST_ODR_Ligne
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Key, _Value: String);
    destructor Destroy; override;
  //Attributs
  public
    Key: String;
    Value: String;
  end;

 TIterateur_hVST_ODR_Ligne
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: ThVST_ODR_Ligne);
    function  not_Suivant( out _Resultat: ThVST_ODR_Ligne): Boolean;
  end;

 TslhVST_ODR_Ligne
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_hVST_ODR_Ligne;
    function Iterateur_Decroissant: TIterateur_hVST_ODR_Ligne;
  end;

 { ThVST_ODR }

 ThVST_ODR
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _vst: TVirtualStringTree);
    destructor Destroy; override;
  //vst
  private
    procedure vstGetText( Sender: TBaseVirtualTree;
                          Node: PVirtualNode;
                          Column: TColumnIndex;
                          TextType: TVSTTextType;
                          var CellText: String);
  public
    vst: TVirtualStringTree;
  //Liste des descripteurs de lignes
  private
    slhVST_ODR_Ligne: TslhVST_ODR_Ligne;
    function New_Line( _Key, _Value: String): ThVST_ODR_Ligne;
    function Line_from_Node( _Node: PVirtualNode): ThVST_ODR_Ligne;
    function New_Node_from_Line( _Parent: PVirtualNode; _Line: ThVST_ODR_Ligne): PVirtualNode;
  //Remplissage
  public
   procedure Clear;
   function Ajoute_Ligne(_Node: PVirtualNode; _Key: String; _Value: String= ''): PVirtualNode;
   function Key_from_Node( _Node: PVirtualNode): String;
   function Value_from_Node( _Node: PVirtualNode): String;
   function Cle_from_Node( _Node: PVirtualNode): String;
   procedure Node_set_Key( _Node: PVirtualNode; _Value: String);
   function Racine_from_Node( _Node: PVirtualNode): String;
   function HasValue( _Node: PVirtualNode): Boolean;
  end;

implementation

{ ThVST_ODR_Ligne }

constructor ThVST_ODR_Ligne.Create( _Key, _Value: String);
begin
     inherited Create;

     Key  := _Key;
     Value:= _Value;
end;

destructor ThVST_ODR_Ligne.Destroy;
begin
     inherited Destroy;
end;

{ TIterateur_hVST_ODR_Ligne }

function TIterateur_hVST_ODR_Ligne.not_Suivant( out _Resultat: ThVST_ODR_Ligne): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_hVST_ODR_Ligne.Suivant( out _Resultat: ThVST_ODR_Ligne);
begin
     Suivant_interne( _Resultat);
end;

{ TslhVST_ODR_Ligne }

constructor TslhVST_ODR_Ligne.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, ThVST_ODR_Ligne);
end;

destructor TslhVST_ODR_Ligne.Destroy;
begin
     inherited;
end;

class function TslhVST_ODR_Ligne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_hVST_ODR_Ligne;
end;

function TslhVST_ODR_Ligne.Iterateur: TIterateur_hVST_ODR_Ligne;
begin
     Result:= TIterateur_hVST_ODR_Ligne( Iterateur_interne);
end;

function TslhVST_ODR_Ligne.Iterateur_Decroissant: TIterateur_hVST_ODR_Ligne;
begin
     Result:= TIterateur_hVST_ODR_Ligne( Iterateur_interne_Decroissant);
end;

{ ThVST_ODR }

constructor ThVST_ODR.Create( _vst: TVirtualStringTree);
begin
     vst:= _vst;

     vst.NodeDataSize:= SizeOf( Pointer);
     vst.RootNodeCount:= 0;
     with vst.Header do Options:= Options + [hoVisible];

     vst.OnGetText    := vstGetText;

     slhVST_ODR_Ligne:= TslhVST_ODR_Ligne.Create( ClassName+'.slhVST_ODR_Ligne');
end;

destructor ThVST_ODR.Destroy;
begin
     Free_nil( slhVST_ODR_Ligne);
     vst.OnInitNode   := nil;
     vst.OnGetText    := nil;
     vst.OnHeaderClick:= nil;
     inherited Destroy;
end;

function ThVST_ODR.New_Line( _Key, _Value: String): ThVST_ODR_Ligne;
begin
     Result:= ThVST_ODR_Ligne.Create( _Key, _Value);
     slhVST_ODR_Ligne.AddObject( _Key, Result);
end;

function ThVST_ODR.New_Node_from_Line( _Parent: PVirtualNode; _Line: ThVST_ODR_Ligne): PVirtualNode;
begin
     Result:= vst.AddChild( _Parent, Pointer(_Line));
end;

function ThVST_ODR.Line_from_Node( _Node: PVirtualNode): ThVST_ODR_Ligne;
var
   po: ^TObject;
begin
     Result:= nil;
     if nil = _Node then exit;

     po:= vst.GetNodeData( _Node);
     Affecte( Result, ThVST_ODR_Ligne, po^);
end;

function ThVST_ODR.Key_from_Node( _Node: PVirtualNode): String;
var
   L: ThVST_ODR_Ligne;
begin
     Result:= '';

     L:= Line_from_Node( _Node);
     if nil = L then exit;

     Result:= L.Key;
end;

function ThVST_ODR.Value_from_Node(_Node: PVirtualNode): String;
var
   L: ThVST_ODR_Ligne;
begin
     Result:= '';

     L:= Line_from_Node( _Node);
     if nil = L then exit;

     Result:= L.Value;
end;

function ThVST_ODR.Cle_from_Node(_Node: PVirtualNode): String;
begin
     if _Node = nil
     then
         Result:= ''
     else
         begin
         if _Node^.Parent = nil
         then // Cas terminal
             Result:= ''
         else // Appel récursif
             Result:= Cle_from_Node( _Node^.Parent) + '_';
         Result:= Result + Key_from_Node( _Node);
         end;
end;

procedure ThVST_ODR.Node_set_Key(_Node: PVirtualNode; _Value: String);
var
   L: ThVST_ODR_Ligne;
begin
     L:= Line_from_Node( _Node);
     if nil = L then exit;

     L.Value:= _Value;
end;

function ThVST_ODR.Racine_from_Node(_Node: PVirtualNode): String;
begin
     if    (_Node         = nil)
        or (_Node^.Parent = nil)
     then
         Result:= ''
     else
         Result:= Cle_from_Node( _Node^.Parent);
end;

function ThVST_ODR.HasValue(_Node: PVirtualNode): Boolean;
begin
     if _Node = nil
     then
         Result:= False
     else
         Result:= '' <> Value_from_Node( _Node)
end;

procedure ThVST_ODR.Clear;
  procedure Cree_Colonnes;
  var
     vtc: TVirtualTreeColumn;
  begin
       if True//Tri.slSousDetails.Count > 0
       then
           begin
           vtc:= vst.Header.Columns.Add;
           vtc.Text:= '';
           vtc.MinWidth:= 100;
           end;
  end;
begin
     vst.Clear;
     vst.Header.Columns.Clear;
     Vide_StringList( slhVST_ODR_Ligne);

     Cree_Colonnes;
end;

function ThVST_ODR.Ajoute_Ligne( _Node: PVirtualNode; _Key: String; _Value: String= ''): PVirtualNode;
var
   hVST_ODR_Ligne: ThVST_ODR_Ligne;
begin
     hVST_ODR_Ligne:= New_Line( _Key, _Value);

     Result:= New_Node_from_Line( _Node, hVST_ODR_Ligne);
end;

procedure ThVST_ODR.vstGetText( Sender: TBaseVirtualTree;
                            Node: PVirtualNode;
                            Column: TColumnIndex;
                            TextType: TVSTTextType;
                            var CellText: String);
var
   hVST_ODR_Ligne: ThVST_ODR_Ligne;

   procedure Traite_Colonne_0;
   var
      Value: String;
   begin
        CellText:= hVST_ODR_Ligne.Key;

        Value:= hVST_ODR_Ligne.Value;
        if ''<>Value
        then
            CellText:= CellText+'='+Value;
   end;
begin
     CellText:= '';
     hVST_ODR_Ligne:= Line_from_Node( Node);
     if nil = hVST_ODR_Ligne  then exit;

     Traite_Colonne_0;
 end;

end.

