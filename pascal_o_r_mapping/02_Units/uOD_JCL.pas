unit uOD_JCL;
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
    DOM,
    uOOoStrings,
  SysUtils, Classes,  Math, fgl;

//Gestion JclSimpleXMLElem
procedure FullName_Split( _FullName: String; var NameSpace, Name: String);
function Name_from_FullName( _FullName: DOMString): DOMString;
function Elem_from_path( _e: TDOMNode; Path: String):TDOMNode;
function Cree_path     ( _e: TDOMNode; Path: String):TDOMNode;
function Assure_path   ( _e: TDOMNode; Path: String):TDOMNode;
function Text_from_path( _Root: TDOMNode; _Path: String): String;
function Assure_path_TextContent( _e: TDOMNode; _Path: String; _TextContent: String):TDOMNode;
procedure Delete_from_path( _e: TDOMNode; Path: String);

//Gestion tableur
function CellName_from_XY( X, Y: Integer): String;
procedure XY_from_CellName( CellName: String; var X, Y: Integer);

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;

//Gestion Properties
function Get_Property_Name( _e: TDOMNode; _NodeName: String): String;
function not_Get_Property( _e: TDOMNode;
                           _NodeName: String;
                           out _Value: String): Boolean;
function not_Get_Property_from_path( const _eRoot   : TDOMNode;
                                     const _Path    : String;
                                     const _NodeName: String;
                                     out   _Value   : String): Boolean;
function not_Test_Property( _e: TDOMNode;
                            _NodeName: String;
                            _Values: array of String): Boolean;
procedure Set_Property( _e: TDOMNode;
                        _NodeName, _Value: String);
procedure Delete_Property( _e: TDOMNode; _NodeName: String);

function double_from_StrCM( _sCM: String): double;//"0.635cm"
function StrCM_from_double( _d  : double): String;//"0.635cm"

//Gestion Items
function Cherche_Item( _eRoot: TDOMNode; _NodeName: String;
                       _Properties_Names ,
                       _Properties_Values: array of String;
                       _Property_Value_Case_Insensitive: Boolean= False): TDOMNode;
function Cherche_Item_Recursif( _eRoot: TDOMNode; _NodeName: String;
                                _Properties_Names ,
                                _Properties_Values: array of String;
                                _Property_Value_Case_Insensitive: Boolean= False): TDOMNode;
function Ensure_Item( _eRoot: TDOMNode; _NodeName: String;
                      _Properties_Names ,
                      _Properties_Values: array of String): TDOMNode;
function Add_Item( _eRoot: TDOMNode; _NodeName: String;
                      _Properties_Names,
                      _Properties_Values: array of String): TDOMNode;
procedure Copie_Item( _Source, _Cible: TDOMNode);

procedure RemoveChilds( _e:TDOMNode);

//
function Find_Node_by_PropertyName( _eRoot: TDOMNode;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): TDOMNode;
type
 TCherche_Items_Recursif_List= TFPGObjectList<TDOMNode>;

 { TCherche_Items_Recursif }

 TCherche_Items_Recursif
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _eRoot: TDOMNode; _NodeName: String;
                        _Properties_Names ,
                        _Properties_Values: array of String;
                        _Property_Value_Case_Insensitive: Boolean= False);
    destructor Destroy; override;
  //Attributs
  public
    l: TCherche_Items_Recursif_List;
  end;

implementation

//Gestion JclSimpleXMLElem

procedure FullName_Split( _FullName: String; var NameSpace, Name: String);
begin
     NameSpace:= StrToK( ':', _FullName);
     Name:= _FullName;
     if Name = '' //pas de :
     then
         begin
         Name:= NameSpace;
         NameSpace:= '';
         end;
end;

function Name_from_FullName( _FullName: DOMString): DOMString;
var
   NameSpace: DOMString;
begin
     NameSpace:= StrToK( ':', _FullName);
     Result:= _FullName;
     if Result = '' //pas de :
     then
         Result:= NameSpace;
end;

function Elem_from_path( _e: TDOMNode; Path: String):TDOMNode;
var
   sNode: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     sNode:= StrToK( '/', Path);

     Result:= _e.FindNode(sNode);
     Result:= Elem_from_path( Result, Path);
end;

function Cree_path( _e: TDOMNode; Path: String):TDOMNode;
var
   NodeName: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     NodeName:= StrToK( '/', Path);

     Result:= _e.AppendChild( _e.OwnerDocument.CreateElement(NodeName));
     Result:= Cree_path( Result, Path);
end;

function Assure_path   ( _e: TDOMNode; Path: String):TDOMNode;
var
   sNode: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     sNode:= StrToK( '/', Path);

     Result:= _e.FindNode(sNode);
     if nil = Result
     then
         Result:= _e.AppendChild( _e.OwnerDocument.CreateElement(sNode));

     Result:= Assure_path( Result, Path);
end;

function Assure_path_TextContent( _e: TDOMNode; _Path: String; _TextContent: String):TDOMNode;
begin
     Result:= Assure_path( _e, _Path);
     Result.TextContent:= _TextContent;
end;

procedure Delete_from_path( _e: TDOMNode; Path: String);
var
   Trash: TDOMNode;
begin
     Trash:= Elem_from_path( _e, Path);
     FreeAndNil( Trash);
end;

function Text_from_path( _Root: TDOMNode; _Path: String): String;
var
   e: TDOMNode;
begin
     Result:= '';

     e:= Elem_from_path( _Root, _Path);
     if e= nil then exit;

     Result:= e.TextContent;
end;

//Gestion tableur

function CellName_from_XY( X, Y: Integer): String;
   procedure Traite_X;
   var
      ln26: Integer;
      I: Integer;
      Value: Integer;
      Power26: Integer;
      Digit: Integer;
      procedure TraiteDigit;
      begin
           Result:= Result + Chr(Ord('A')+Digit-1);
      end;
   begin
        Value:= X+1;
        ln26:= Trunc( LogN( 26, Value));
        for I:= ln26 downto 0
        do
          begin
          Power26:= Trunc( IntPower( 26, I));
          Digit:= Value div Power26;
          Value:= Value mod Power26;
          TraiteDigit;
          end;
   end;
   procedure Traite_Y;
   begin
        Result:=  Result + IntToStr(Y+1);
   end;
begin
     Result:= '';
     Traite_X;
     Traite_Y;
end;

type
  EXY_from_CellName_Exception= class( Exception);

procedure XY_from_CellName( CellName: String; var X, Y: Integer);
var
   I: Integer;
   sX, sY: String;
   procedure Traite_sX;
   var
      LsX: Integer;
      J: Integer;
      C: Char;
      Value: Integer;
   begin
        X:= 0;
        LsX:= Length( sX);
        for J:= 0 to LsX-1
        do
          begin
          C:= sX[ LsX-J];
          Value:= Ord(C)-Ord('A')+1;
          X:= X + Trunc(Value * IntPower( 26, J));
          end;
   end;
   procedure Traite_sY;
   begin
        if not TryStrToInt( sY, Y)
        then
            raise EXY_from_CellName_Exception
                  .
                   Create(  'La syntaxe du numéro de ligne ('+sY+') '
                           +'est incorrecte dans '
                           +'la référence de cellule ('+CellName+')');
   end;
begin
     CellName:= UpperCase( CellName);
     sX:= '';
     sY:= '';
     I:= 1;
     while     (I < Length(CellName))
           and (CellName[I] in ['A'..'Z'])
     do
       Inc( I);
     sX:= Copy( CellName, 1, I-1);
     sY:= Copy( CellName, I, Length(CellName));

     Traite_sX;
     Traite_sY;
     Dec(X);
     Dec(Y);
end;

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;
begin
     Result:=  CellName_from_XY( Left , Top   )
              +':'
              +CellName_from_XY( Right, Bottom);
end;
//Gestion Properties

function Get_Property_Name( _e: TDOMNode; _NodeName: String): String;
begin
     Result:= _NodeName;
end;

function not_Get_Property( _e: TDOMNode;
                           _NodeName: String;
                           out _Value: String): Boolean;
var
   PropertyName: String;
   p: TDOMNode;
begin
     Result:= _e = nil;
     if Result then exit;

     PropertyName:= Get_Property_Name( _e, _NodeName);

     p:= _e.Attributes.GetNamedItem( PropertyName);

     Result:= p = nil;
     if Result then exit;

     _Value:= p.NodeValue;
end;

function not_Get_Property_from_path( const _eRoot   : TDOMNode;
                                     const _Path    : String;
                                     const _NodeName: String;
                                     out   _Value   : String): Boolean;
var
   e: TDOMNode;
begin
     e:= Elem_from_path( _eRoot, _Path);
     Result:= e = nil;
     if Result then exit;

     Result:= not_Get_Property( e, _NodeName, _Value);
end;

function not_Test_Property( _e: TDOMNode;
                            _NodeName: String;
                            _Values: array of String): Boolean;
var
   Value: String;
   I: Integer;
begin
     Result:= not_Get_Property( _e, _NodeName, Value);
     if Result then exit;

     Result:= True;
     for I:= Low( _Values) to High( _Values)
     do
       begin
       Result:= Value <> _Values[ I];
       if not Result then break;
       end;
end;

procedure Set_Property( _e: TDOMNode;
                        _NodeName, _Value: String);
var
   e: TDOMElement;
   PropertyName: String;
begin
     if _e = nil                then exit;
     if not (_e is TDOMElement) then exit;

     e:= TDOMElement(_e);
     PropertyName:= Get_Property_Name( _e, _NodeName);
     e.SetAttribute( PropertyName, _Value);
end;

procedure Delete_Property( _e: TDOMNode; _NodeName: String);
var
   e: TDOMElement;
   PropertyName: String;
begin
     if _e = nil then exit;
     if not (_e is TDOMElement) then exit;

     e:= TDOMElement(_e);
     PropertyName:= Get_Property_Name( _e, _NodeName);

     e.RemoveAttribute( PropertyName);
end;

//Gestion Items

//Find_Node_by_PropertyName = Cherche_Item sans contrainte sur NodeName
function Find_Node_by_PropertyName( _eRoot: TDOMNode;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): TDOMNode;
var
   I: Integer;
   e: TDOMNode;
   iProperties: Integer;
   Properties_Values: array of String;
   Arreter: Boolean;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.ChildNodes.Count - 1
     do
       begin
       e:= _eRoot.ChildNodes.Item[ I];
       if e = nil                 then continue;

       Arreter:= False;
       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         Arreter
         :=
           not_Get_Property( e,
                             _Properties_Names [iProperties],
                              Properties_Values[iProperties]
                             );
         if Arreter
         then
             break;
         end;
       if Arreter then continue;

       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         Arreter
         :=
              _Properties_Values[ iProperties]
           <>  Properties_Values[ iProperties];
         if Arreter
         then
             break;
         end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;

function Cherche_Item( _eRoot: TDOMNode; _NodeName: String;
                       _Properties_Names ,
                       _Properties_Values: array of String;
                       _Property_Value_Case_Insensitive: Boolean= False): TDOMNode;
var
   I: Integer;
   e: TDOMNode;
   iProperties: Integer;
   Properties_Values: array of String;
   _Property_Value,
    Property_Value: String;
   Arreter: Boolean;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.ChildNodes.Count - 1
     do
       begin
       e:= _eRoot.ChildNodes.Item[ I];
       if e = nil                 then continue;
       if e.NodeName <> _NodeName then continue;

       Arreter:= False;
       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         Arreter
         :=
           not_Get_Property( e,
                             _Properties_Names [iProperties],
                              Properties_Values[iProperties]
                             );
         if Arreter
         then
             break;
         end;
       if Arreter then continue;

       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         _Property_Value:= _Properties_Values[ iProperties];
          Property_Value:=  Properties_Values[ iProperties];

         if _Property_Value_Case_Insensitive
         then
             begin
             _Property_Value:= LowerCase( _Property_Value);
              Property_Value:= LowerCase(  Property_Value);
             end;

         Arreter:= _Property_Value <>  Property_Value;
         if Arreter then break;
         end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;

function Cherche_Item_Recursif( _eRoot: TDOMNode; _NodeName: String;
                                _Properties_Names ,
                                _Properties_Values: array of String;
                                _Property_Value_Case_Insensitive: Boolean= False): TDOMNode;
var
   I: Integer;
   e: TDOMNode;
   Properties_Values: array of String;
   _Property_Value,
    Property_Value: String;
   Arreter: Boolean;
   procedure Traite_Properties;
   var
      iProperties: Integer;
   begin
        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          Arreter
          :=
            not_Get_Property( e,
                              _Properties_Names [iProperties],
                               Properties_Values[iProperties]
                              );
          if Arreter then break;
          end;
        if Arreter then exit;

        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          _Property_Value:= _Properties_Values[ iProperties];
           Property_Value:=  Properties_Values[ iProperties];

          if _Property_Value_Case_Insensitive
          then
              begin
              _Property_Value:= LowerCase( _Property_Value);
               Property_Value:= LowerCase(  Property_Value);
              end;

          Arreter:= _Property_Value <>  Property_Value;
          if Arreter then break;
          end;
   end;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.ChildNodes.Count - 1
     do
       begin
       e:= _eRoot.ChildNodes.Item[ I];
       if e = nil                 then continue;

       Arreter:= False;
       if e.NodeName = _NodeName
       then
           Traite_Properties
       else
           begin
           e:= Cherche_Item_Recursif( e, _NodeName, _Properties_Names, _Properties_Values);
           Arreter:= e = nil;
           end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;


function Ensure_Item( _eRoot: TDOMNode; _NodeName: String;
                      _Properties_Names ,
                      _Properties_Values: array of String): TDOMNode;
begin
     Result:= Cherche_Item( _eRoot, _NodeName, _Properties_Names, _Properties_Values);
     if Assigned( Result) then exit;

     Result:= Add_Item( _eRoot, _NodeName, _Properties_Names, _Properties_Values);
end;

function Add_Item( _eRoot: TDOMNode; _NodeName: String;
                      _Properties_Names,
                      _Properties_Values: array of String): TDOMNode;
var
   iProperties: Integer;
begin
     Result:= Cree_path( _eRoot, _NodeName);
     if Result = nil then exit;

     for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
     do
       Set_Property( Result,
                     _Properties_Names[ iProperties],
                     _Properties_Values[ iProperties]);
end;

procedure Copie_Item( _Source, _Cible: TDOMNode);
   procedure Copie_Properties;
   var
      iProperties: Integer;
      P: TDOMNode;
   begin
        for iProperties:= 0 to _Source.Attributes.Length-1
        do
          begin
          P:= _Source.Attributes.Item[ iProperties];
          if P = nil then continue;

          Set_Property( _Cible, P.NodeName, P.NodeValue);
          end;
   end;
   procedure Copie_Items;
   var
      I: Integer;
      eSource, eCible: TDOMNode;
      eSource_NodeName: String;
      NewChild: TDOMNode;
   begin
        for I:= 0 to _Source.ChildNodes.Count - 1
        do
          begin
          eSource:= _Source.ChildNodes.Item[ I];
          if eSource = nil then continue;

          eSource_NodeName:= eSource.NodeName;
          if '#text' = eSource_NodeName
          then
              begin
              NewChild:= _Cible.OwnerDocument.CreateTextNode( eSource.NodeValue);
              eCible:= _Cible.AppendChild( NewChild);
              end
          else
              begin
              NewChild:= _Cible.OwnerDocument.CreateElement( eSource_NodeName);
              eCible:= _Cible.AppendChild( NewChild);
              Copie_Item( eSource, eCible);
              end;
          end;
   end;
begin
     if _Source = nil then exit;
     if _Cible  = nil then exit;

     Copie_Properties;

     Copie_Items;

     _Cible.NodeValue:= _Source.NodeValue;
end;

procedure RemoveChilds( _e:TDOMNode);
var
   child: TDOMNode;
   function Supprimer: Boolean;
   begin
        child:= _e.FirstChild;
        Result:= Assigned( child);
   end;
begin
     if _e = nil then exit;

     while Supprimer
     do
       FreeAndNil( child);

end;

function double_from_StrCM( _sCM: String): double;//"0.635cm"
var
   cm_debut, cm_longueur: Integer;
   Erreur: integer;
begin
     cm_debut   := Length(_sCM)-1;
     cm_longueur:= 2;
     if 'cm' = Copy( _sCM, cm_debut, cm_longueur)
     then
         Delete( _sCM, cm_debut, cm_longueur);
     Val( _sCM, Result, Erreur);
     if Erreur <> 0 then Result:= 0;
end;

function StrCM_from_double( _d: double): String;//"0.635cm"
begin
     Str( _d:8:3, Result);
     Result:= TrimLeft( Result) + 'cm';
end;


{ TCherche_Items_Recursif }

constructor TCherche_Items_Recursif.Create( _eRoot: TDOMNode;
                                            _NodeName: String;
                                            _Properties_Names, _Properties_Values: array of String;
                                            _Property_Value_Case_Insensitive: Boolean);
var
   I: Integer;
   e: TDOMNode;
   Properties_Values: array of String;
   _Property_Value,
    Property_Value: String;
   Arreter: Boolean;
   procedure Traite_Properties;
   var
      iProperties: Integer;
   begin
        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          Arreter
          :=
            not_Get_Property( e,
                              _Properties_Names [iProperties],
                               Properties_Values[iProperties]
                              );
          if Arreter then break;
          end;
        if Arreter then exit;

        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          _Property_Value:= _Properties_Values[ iProperties];
           Property_Value:=  Properties_Values[ iProperties];

          if _Property_Value_Case_Insensitive
          then
              begin
              _Property_Value:= LowerCase( _Property_Value);
               Property_Value:= LowerCase(  Property_Value);
              end;

          Arreter:= _Property_Value <>  Property_Value;
          if Arreter then break;
          end;
   end;
begin
     l:= TCherche_Items_Recursif_List.Create( False);

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.ChildNodes.Count - 1
     do
       begin
       e:= _eRoot.ChildNodes.Item[ I];
       if e = nil then continue;

       Arreter:= False;
       if e.NodeName = _NodeName
       then
           Traite_Properties
       else
           begin
           e:= Cherche_Item_Recursif( e, _NodeName, _Properties_Names, _Properties_Values);
           Arreter:= e = nil;
           end;
       if Arreter then continue;

       l.Add( e);
       end;
end;

destructor TCherche_Items_Recursif.Destroy;
begin
     FreeAndNil( l);
     inherited Destroy;
end;

end.
