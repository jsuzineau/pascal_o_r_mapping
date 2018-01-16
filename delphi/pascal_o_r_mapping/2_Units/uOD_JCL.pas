unit uOD_JCL;
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
    JclSimpleXml,
    uOOoStrings,
  Windows, SysUtils, Classes, FMX.Forms, FMX.Dialogs;

//Gestion JclSimpleXMLElem
procedure FullName_Split( _FullName: String; var NameSpace, Name: String);
function Name_from_FullName( _FullName: String): String;
function Elem_from_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
function Cree_path     ( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
function Assure_path   ( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
function Text_from_path( _Root: TJclSimpleXMLElem; _Path: String): String;

//Gestion Properties
function Get_Property_Name( _e: TJclSimpleXMLElem; _FullName: String): String;
function not_Get_Property( _e: TJclSimpleXMLElem;
                           _FullName: String;
                           out _Value: String): Boolean;
function not_Get_Property_from_path( const _eRoot   : TJclSimpleXMLElem;
                                     const _Path    : String;
                                     const _FullName: String;
                                     out   _Value   : String): Boolean;
function not_Test_Property( _e: TJclSimpleXMLElem;
                            _FullName: String;
                            _Values: array of String): Boolean;
procedure Set_Property( _e: TJclSimpleXMLElem;
                        _Fullname, _Value: String);
procedure Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);

function double_from_StrCM( _sCM: String): double;//"0.635cm"
function StrCM_from_double( _d  : double): String;//"0.635cm"

//Gestion Items
function Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                       _Properties_Names ,
                       _Properties_Values: array of String): TJclSimpleXMLElem;
function Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                _Properties_Names ,
                                _Properties_Values: array of String): TJclSimpleXMLElem;
function Ensure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                      _Properties_Names ,
                      _Properties_Values: array of String): TJclSimpleXMLElem;
function Add_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                      _Properties_Names,
                      _Properties_Values: array of String): TJclSimpleXMLElem;
procedure Copie_Item( _Source, _Cible: TJclSimpleXMLElem);

procedure RemoveChilds( _e: TJclSimpleXMLElem);

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

function Name_from_FullName( _FullName: String): String;
var
   NameSpace: String;
begin
     NameSpace:= StrToK( ':', _FullName);
     Result:= _FullName;
     if Result = '' //pas de :
     then
         Result:= NameSpace;
end;

function Elem_from_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
var
   sNode: String;
   Name: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     sNode:= StrToK( '/', Path);
     Name:= Name_from_FullName( sNode);
     Result:= _e.Items.ItemNamed[ Name];
     Result:= Elem_from_path( Result, Path);
end;

function Cree_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
var
   FullName: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     FullName:= StrToK( '/', Path);
     Result:= _e.Items.Add( FullName);
     Result:= Cree_path( Result, Path);
end;

function Assure_path   ( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( _e, Path);
     if Result = nil
     then
         Result:= Cree_path( _e, Path);
end;

function Text_from_path( _Root: TJclSimpleXMLElem; _Path: String): String;
var
   e: TJclSimpleXMLElem;
begin
     Result:= '';

     e:= Elem_from_path( _Root, _Path);
     if e= nil then exit;

     Result:= e.Value;
end;

//Gestion Properties

function Get_Property_Name( _e: TJclSimpleXMLElem; _FullName: String): String;
var
   _e_NameSpace: String;
   Name: String;
begin
     _e_NameSpace:= _e.NameSpace;
     if _e_NameSpace = ''
     then
         Result:= _FullName
     else
         begin
         Name:= Name_from_FullName( _FullName);
         Result:= Name;
         end;
end;

function not_Get_Property( _e: TJclSimpleXMLElem;
                           _FullName: String;
                           out _Value: String): Boolean;
var
   PropertyName: String;
   p: TJclSimpleXMLProp;
begin
     Result:= _e = nil;
     if Result then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);

     p:= _e.Properties.ItemNamed[ PropertyName];

     Result:= p = nil;
     if Result then exit;

     _Value:= p.Value;
end;

function not_Get_Property_from_path( const _eRoot   : TJclSimpleXMLElem;
                                     const _Path    : String;
                                     const _FullName: String;
                                     out   _Value   : String): Boolean;
var
   e: TJclSimpleXMLElem;
begin
     e:= Elem_from_path( _eRoot, _Path);
     Result:= e = nil;
     if Result then exit;

     Result:= not_Get_Property( e, _FullName, _Value);
end;

function not_Test_Property( _e: TJclSimpleXMLElem;
                            _FullName: String;
                            _Values: array of String): Boolean;
var
   Value: String;
   I: Integer;
begin
     Result:= not_Get_Property( _e, _FullName, Value);
     if Result then exit;

     Result:= True;
     for I:= Low( _Values) to High( _Values)
     do
       begin
       Result:= Value <> _Values[ I];
       if not Result then break;
       end;
end;

procedure Set_Property( _e: TJclSimpleXMLElem;
                        _Fullname, _Value: String);
var
   PropertyName: String;
   p: TJclSimpleXMLProp;
begin
     if _e = nil then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);
     p:= _e.Properties.ItemNamed[ PropertyName];

     if Assigned( p)
     then
         p.Value:= _Value
     else
         _e.Properties.Add( _Fullname, _Value);
end;

procedure Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);
var
   PropertyName: String;
begin
     if _e = nil then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);

     _e.Properties.Delete( PropertyName);
end;

//Gestion Items

function Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                       _Properties_Names ,
                       _Properties_Values: array of String): TJclSimpleXMLElem;
var
   I: Integer;
   e: TJclSimpleXMLElem;
   iProperties: Integer;
   Properties_Values: array of String;
   Arreter: Boolean;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.Items.Count - 1
     do
       begin
       e:= _eRoot.Items.Item[ I];
       if e = nil                 then continue;
       if e.FullName <> _FullName then continue;

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

function Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                _Properties_Names ,
                                _Properties_Values: array of String): TJclSimpleXMLElem;
var
   I: Integer;
   e: TJclSimpleXMLElem;
   Properties_Values: array of String;
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
          Arreter
          :=
               _Properties_Values[ iProperties]
            <>  Properties_Values[ iProperties];
          if Arreter then break;
          end;
   end;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.Items.Count - 1
     do
       begin
       e:= _eRoot.Items.Item[ I];
       if e = nil                 then continue;

       Arreter:= False;
       if e.FullName = _FullName
       then
           Traite_Properties
       else
           begin
           e:= Cherche_Item_Recursif( e, _FullName, _Properties_Names, _Properties_Values);
           Arreter:= e = nil;
           end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;

function Ensure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                      _Properties_Names ,
                      _Properties_Values: array of String): TJclSimpleXMLElem;
begin
     Result:= Cherche_Item( _eRoot, _FullName, _Properties_Names, _Properties_Values);
     if Assigned( Result) then exit;

     Result:= Add_Item( _eRoot, _FullName, _Properties_Names, _Properties_Values);
end;

function Add_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                      _Properties_Names,
                      _Properties_Values: array of String): TJclSimpleXMLElem;
var
   iProperties: Integer;
begin
     Result:= _eRoot.Items.Add( _FullName);
     if Result = nil then exit;

     for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
     do
       Set_Property( Result,
                     _Properties_Names[ iProperties],
                     _Properties_Values[ iProperties]);
end;

procedure Copie_Item( _Source, _Cible: TJclSimpleXMLElem);
   procedure Copie_Properties;
   var
      iProperties: Integer;
      P: TJclSimpleXMLProp;
   begin
        for iProperties:= 0 to _Source.PropertyCount-1
        do
          begin
          P:= _Source.Properties.Item[ iProperties];
          if P = nil then continue;

          Set_Property( _Cible, P.FullName, P.Value);
          end;
   end;
   procedure Copie_Items;
   var
      I: Integer;
      eSource, eCible: TJclSimpleXMLElem;
   begin
        for I:= 0 to _Source.Items.Count - 1
        do
          begin
          eSource:= _Source.Items.Item[ I];
          if eSource = nil then continue;

          eCible:= _Cible.Items.Add( eSource.FullName);
          Copie_Item( eSource, eCible);
          end;
   end;
begin
     if _Source = nil then exit;
     if _Cible  = nil then exit;

     Copie_Properties;

     Copie_Items;

     _Cible.Value:= _Source.Value;
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

procedure RemoveChilds( _e: TJclSimpleXMLElem);
begin
     _e.Items.Clear;
end;

end.
