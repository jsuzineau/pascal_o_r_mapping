unit ufOpenSCAD_from_Eagle_File;

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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }
{$mode objfpc}{$H+}

interface

uses
    uOD_JCL,
    uuStrings,
    uCircle,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
 StdCtrls, ExtCtrls,DOM, XMLRead, XMLWrite,strutils;

type

 { TfOpenSCAD_from_Eagle_File }

 TfOpenSCAD_from_Eagle_File
 =
  class(TForm)
   eLayer: TEdit;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   leBoard_Shape_Library_Name: TLabeledEdit;
   leLIBRARIES_PATH: TLabeledEdit;
   leBoard_Shape_Package_Name: TLabeledEdit;
   mBOARD_SHAPE: TMemo;
   mBoard_Shape_Library: TMemo;
    mEagle_File: TMemo;
    mBoard_Shape_package: TMemo;
    mHOLE_LIST: TMemo;
    mLIBRARIES: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pc: TPageControl;
    sb: TStatusBar;
    Splitter1: TSplitter;
    t: TTimer;
    tsBoard_Shape_Library: TTabSheet;
    tsHOLE_LIST: TTabSheet;
    tsLIBRARIES: TTabSheet;
    tsEagle_File: TTabSheet;
    tsBoard_Shape_Package: TTabSheet;
    procedure eLayerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure leBoard_Shape_Package_NameChange(Sender: TObject);
    procedure leLIBRARIES_PATHChange(Sender: TObject);
    procedure leBoard_Shape_Library_NameChange(Sender: TObject);
    procedure tTimer(Sender: TObject);
  //General
  private
    procedure Clear;
    procedure m_from_xml( _m: TMemo; _xml: TXMLDocument);
    procedure m_from_dn( _m: TMemo; _dn: TDOMNode);
  //Refresh Methods
  private
    procedure tsEagle_File_Refresh;
    procedure tsLIBRARIES_Refresh;
    procedure tsBoard_Shape_Library_Refresh;
    procedure tsBoard_Shape_Package_Refresh;
    procedure tsHOLE_LIST_Refresh;
    procedure Node_to_HOLE_LIST( _Root: TDOMNode);
    procedure Board_Plain_to_HOLE_LIST;
  //Eagle File
  private
    Eagle_FileName: String;
    xmlEagle_File: TXMLDocument;
  //libraries
  private
    dnLIBRARIES: TDOMNode;
  //librairie of board shape
  private
    dnBoard_Shape_Library: TDOMNode;
  //packages of librairie of board shape
  private
    dnBoard_Shape_Packages: TDOMNode;
  //package of board shape
  private
    dnBoard_Shape_Package: TDOMNode;
  //Layer
  private
    BoardLayer: String;
  //Hole List
  private
     procedure Add_hole_from_node( _dn: TDOMNode);
  //Board Shape Point
  private
     procedure Add_Board_Shape_Point_from_node( _dn: TDOMNode);
  end;

var
 fOpenSCAD_from_Eagle_File: TfOpenSCAD_from_Eagle_File;

implementation

{$R *.lfm}

{ TfOpenSCAD_from_Eagle_File }

procedure TfOpenSCAD_from_Eagle_File.FormCreate(Sender: TObject);
begin
     xmlEagle_File:= nil;
     Clear;
end;

procedure TfOpenSCAD_from_Eagle_File.eLayerChange(Sender: TObject);
begin
     BoardLayer:= eLayer.Text;
     tsHOLE_LIST_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.FormDestroy(Sender: TObject);
begin
     Clear;
end;

procedure TfOpenSCAD_from_Eagle_File.Clear;
begin
     dnLIBRARIES:= nil;
     FreeAndNil( xmlEagle_File);
     mEagle_File.Clear;
     mLIBRARIES.Clear;;
     mBoard_Shape_Library.Clear;
     mBoard_Shape_package.Clear;
     mHOLE_LIST.Clear;
     mBOARD_SHAPE.Clear;
end;

procedure TfOpenSCAD_from_Eagle_File.m_from_xml( _m: TMemo; _xml: TXMLDocument);
var
   ms: TMemoryStream;
begin
     ms:= TMemoryStream.Create;
     try
        WriteXML( _xml, ms);
        ms.Position:= 0;
        _m.Lines.LoadFromStream( ms);
     finally
            FreeAndNil( ms);
            end;

end;

procedure TfOpenSCAD_from_Eagle_File.m_from_dn(_m: TMemo; _dn: TDOMNode);
var
   ms: TMemoryStream;
begin
     ms:= TMemoryStream.Create;
     try
        WriteXML( _dn, ms);
        ms.Position:= 0;
        _m.Lines.LoadFromStream( ms);
     finally
            FreeAndNil( ms);
            end;

end;

procedure TfOpenSCAD_from_Eagle_File.tTimer(Sender: TObject);
begin
     t.Enabled:= False;

     if ParamCount < 1 then exit;
     Eagle_FileName:= ParamStr(1);

     tsEagle_File_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.FormDropFiles( Sender: TObject; const FileNames: array of String);
begin
     if Length(FileNames) < 1 then exit;
     Eagle_FileName:= FileNames[0];

     tsEagle_File_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.tsEagle_File_Refresh;
begin
     pc.ActivePage:= tsEagle_File;
     Clear;
     Caption:= ExtractFileName(Eagle_FileName)+'   in   '+Eagle_FileName;
     ReadXMLFile( xmlEagle_File, Eagle_FileName);
     m_from_xml(mEagle_File, xmlEagle_File);
     if mEagle_File.Lines.Count = 0 then exit;

     tsLIBRARIES_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.tsLIBRARIES_Refresh;
begin
     pc.ActivePage:= tsLIBRARIES;
     dnLIBRARIES:= Elem_from_path( xmlEagle_File.DocumentElement, leLIBRARIES_PATH.Text);
     if nil = dnLIBRARIES then exit;

     m_from_dn( mLIBRARIES, dnLIBRARIES);
     tsBoard_Shape_Library_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.tsBoard_Shape_Library_Refresh;
begin
     pc.ActivePage:= tsBoard_Shape_Library;

     dnBoard_Shape_Library:= Cherche_Item( dnLIBRARIES, 'library', ['name'], [leBoard_Shape_Library_Name.Text]);
     if nil = dnBoard_Shape_Library then exit;

     m_from_dn( mBoard_Shape_Library, dnBoard_Shape_Library);

     dnBoard_Shape_Packages:= Elem_from_path( dnBoard_Shape_Library, 'packages');
     if nil = dnBoard_Shape_Packages then exit;

     tsBoard_Shape_Package_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.tsBoard_Shape_Package_Refresh;
begin
     pc.ActivePage:= tsBoard_Shape_Package;

     dnBoard_Shape_Package:= Cherche_Item( dnBoard_Shape_Packages, 'package', ['name'], [leBoard_Shape_Package_Name.Text]);
     if nil = dnBoard_Shape_Package then exit;

     m_from_dn( mBoard_Shape_package, dnBoard_Shape_Package);
     tsHOLE_LIST_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.tsHOLE_LIST_Refresh;
begin
     pc.ActivePage:= tsHOLE_LIST;
     mHOLE_LIST.Clear;
     mBOARD_SHAPE.Clear;
     Board_Plain_to_HOLE_LIST;
     Node_to_HOLE_LIST( dnBoard_Shape_Package);
end;

procedure TfOpenSCAD_from_Eagle_File.Board_Plain_to_HOLE_LIST;
var
   dnBoard_Plain: TDOMNode;
begin
     dnBoard_Plain:= Elem_from_path( xmlEagle_File.DocumentElement, 'drawing/board/plain');
     if nil = dnBoard_Plain then exit;

     Node_to_HOLE_LIST( dnBoard_Plain);
end;

procedure TfOpenSCAD_from_Eagle_File.Node_to_HOLE_LIST(_Root: TDOMNode);
var
   dn: TDOMNode;
begin
     if nil = _Root then exit;

     dn:= _Root.FirstChild;
     while Assigned( dn)
     do
       begin
            if 'hole' = dn.NodeName then Add_hole_from_node( dn)
       else if 'wire' = dn.NodeName then Add_Board_Shape_Point_from_node( dn);

       dn:= dn.NextSibling;
       end;
end;

procedure TfOpenSCAD_from_Eagle_File.Add_hole_from_node( _dn: TDOMNode);
var
   x, y, drill: String;
   sOpenSCAD: String;
   iLast_Line: Integer;
begin
     if not_Get_Property( _dn, 'x'    , x    ) then exit;
     if not_Get_Property( _dn, 'y'    , y    ) then exit;
     if not_Get_Property( _dn, 'drill', drill) then exit;

     iLast_Line:= mHOLE_LIST.Lines.Count-1;
     if  iLast_Line >= 0
     then
         mHOLE_LIST.Lines.Strings[iLast_Line]:= mHOLE_LIST.Lines.Strings[iLast_Line]+',';

     sOpenSCAD:= '['+x+', '+y+'/*drill: '+drill+'*/]';
     mHOLE_LIST.Lines.Add( sOpenSCAD);
end;

procedure TfOpenSCAD_from_Eagle_File.Add_Board_Shape_Point_from_node( _dn: TDOMNode);
var
   has_not_curve: Boolean;
   x1, y1, x2, y2, curve, width_,layer: String;
   iLast_Line: Integer;
   cas: String;
   procedure Add_xy( _x, _y: String; _Virgule: Boolean= False);
   var
      sOpenSCAD: String;
   begin
        sOpenSCAD:= '['+_x+', '+_y+']';
        if _Virgule
        then
            sOpenSCAD:= sOpenSCAD + ','
        else
            sOpenSCAD:= sOpenSCAD+'/*'+IfThen(has_not_curve, '', 'curve:'+curve+',')+'width:'+width_+',layer:'+layer+', case: '+cas+'*/';
        mBOARD_SHAPE.Lines.Add( sOpenSCAD);
   end;
   function double_from_xmlstring( _xmlstring: String): double;
   var
      Erreur: Integer;
   begin
        Val( _xmlstring, Result, Erreur);
        if Erreur > 0 then Result:= 0;
   end;
   function xmlstring_from_double( _double: double): String;
   begin
        str( _double:10:2, Result);
   end;
   procedure Traite_arc;
   const NbPoints=10;
   var
      C: TCircle;
      I: Integer;
   begin
        C
        :=
          TCircle.Create(
                          double_from_xmlstring(x1),
                          double_from_xmlstring(y1),
                          double_from_xmlstring(x2),
                          double_from_xmlstring(y2),
                          double_from_xmlstring(curve)
                          );
        try
           cas:= C.cas+' x1: '+x1+' y1: '+y1+' x2: '+x2+' y2: '+y2;
           C.Calcul( NbPoints);
           for I:= low(c.x) to High( C.x)
           do
             Add_xy(
                     xmlstring_from_double( C.x[I]),
                     xmlstring_from_double( C.y[I]),
                     I<High( C.x));
        finally
               FreeAndNil( C);
               end;
   end;
begin
     if not_Get_Property( _dn, 'x1'    , x1    ) then exit;
     if not_Get_Property( _dn, 'x2'    , x2    ) then exit;
     if not_Get_Property( _dn, 'y1'    , y1    ) then exit;
     if not_Get_Property( _dn, 'y2'    , y2    ) then exit;
     has_not_curve:= not_Get_Property( _dn, 'curve' , curve );
     if not_Get_Property( _dn, 'width' , width_) then exit;
     if not_Get_Property( _dn, 'layer' , layer ) then exit;
     if (''<>BoardLayer) and (layer <> BoardLayer) then exit;

     iLast_Line:= mBOARD_SHAPE.Lines.Count-1;
     if iLast_Line < 0
     then
         begin
         cas:= 'start';
         Add_xy( x1, y1, True);
         end
     else
         mBOARD_SHAPE.Lines.Strings[iLast_Line]:= mBOARD_SHAPE.Lines.Strings[iLast_Line]+',';

     if has_not_curve
     then
         begin
         cas:= 'no curve';
         Add_xy( x2, y2);
         end
     else
         Traite_arc;
end;

procedure TfOpenSCAD_from_Eagle_File.leLIBRARIES_PATHChange(Sender: TObject);
begin
     tsLIBRARIES_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.leBoard_Shape_Library_NameChange(Sender: TObject);
begin
     tsBoard_Shape_Library_Refresh;
end;

procedure TfOpenSCAD_from_Eagle_File.leBoard_Shape_Package_NameChange( Sender: TObject);
begin
     tsBoard_Shape_Package_Refresh;
end;

end.

