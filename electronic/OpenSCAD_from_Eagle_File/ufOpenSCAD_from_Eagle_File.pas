unit ufOpenSCAD_from_Eagle_File;

{$mode objfpc}{$H+}

interface

uses
    uOD_JCL,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
 StdCtrls, ExtCtrls,DOM, XMLRead, XMLWrite;

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
   x1, y1, x2, y2, curve, width_,layer: String;
   iLast_Line: Integer;
   procedure Add_xy( _x, _y: String; _Virgule: Boolean= False);
   var
      sOpenSCAD: String;
   begin
        sOpenSCAD:= '['+_x+', '+_y+']';
        if _Virgule
        then
            sOpenSCAD:= sOpenSCAD + ','
        else
            sOpenSCAD:= sOpenSCAD+'/*curve:'+curve+',width:'+width_+'*/';
        mBOARD_SHAPE.Lines.Add( sOpenSCAD);
   end;
begin
     if not_Get_Property( _dn, 'x1'    , x1    ) then exit;
     if not_Get_Property( _dn, 'x2'    , x2    ) then exit;
     if not_Get_Property( _dn, 'y1'    , y1    ) then exit;
     if not_Get_Property( _dn, 'y2'    , y2    ) then exit;
     if not_Get_Property( _dn, 'curve' , curve ) then exit;
     if not_Get_Property( _dn, 'width' , width_) then exit;
     if not_Get_Property( _dn, 'layer' , layer ) then exit;
     if (''<>BoardLayer) and (layer <> BoardLayer) then exit;

     iLast_Line:= mBOARD_SHAPE.Lines.Count-1;
     if iLast_Line < 0
     then
         Add_xy( x1, y1, True)
     else
         mBOARD_SHAPE.Lines.Strings[iLast_Line]:= mBOARD_SHAPE.Lines.Strings[iLast_Line]+',';

     Add_xy( x2, y2);
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

