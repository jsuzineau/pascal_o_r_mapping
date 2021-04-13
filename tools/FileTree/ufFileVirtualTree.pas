unit ufFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, ufFileTree, IniFiles, VirtualTrees;

type

 { TTreeData }

 TTreeData
 =
  class
  //Text
  public
    Text : String;
  //Key
  public
    Key  : String;
  //Value
  private
    FValue: String;
    FdValue: TDateTime;
    procedure SetValue (  _Value: String   );
    procedure SetdValue( _dValue: TDateTime);
  public
    property Value : String    read FValue  write SetValue ;
    property dValue: TDateTime read FdValue write SetdValue;
  //IsLeaf
  public
    IsLeaf: Boolean;
  end;

 { TfFileVirtualTree }

 TfFileVirtualTree
 =
  class(TForm)
   bGetChecked: TButton;
   bGetSelection: TButton;
   bfFileTree: TButton;
   bLoad_from_File: TButton;
   bOD: TButton;
   eFileName: TEdit;
   Label1: TLabel;
   lCompute_Aggregates: TLabel;
   m: TMemo;
   od: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    pb: TProgressBar;
    Splitter1: TSplitter;
    vst: TVirtualStringTree;
    procedure bfFileTreeClick(Sender: TObject);
    procedure bGetCheckedClick(Sender: TObject);
    procedure bGetSelectionClick(Sender: TObject);
    procedure bLoad_from_FileClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
     Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstInitNode(Sender: TBaseVirtualTree; ParentNode,
     Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    slFiles: TStringList;
    slNodes: TStringList;
    slTreeData: TStringList;
    procedure vst_addnode_from_key_value( _Key, _Value: String);
    function NewTreeData(_Text, _Key, _Value: String; _IsLeaf: Boolean): TTreeData;
    function NewNode_from_TreeData(_Parent: PVirtualNode; _td: TTreeData
     ): PVirtualNode;
    function Add_Leaf(_Parent: PVirtualNode; _Text, _Key, _Value: String): PVirtualNode;
    function Add_Node(_Parent: PVirtualNode; _Text: String): PVirtualNode;
    function TreeData_from_Node( _Node: PVirtualNode): TTreeData;
    procedure Compute_Aggregates;
  public
    function Get_Selected: String;
    function Get_Checked: String;
    procedure Load_from_File( _FileName: String);
  end;

var
 fFileVirtualTree: TfFileVirtualTree;

implementation

{$R *.lfm}

//duplicated for convenience from uuStrings.pas
function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

//duplicated for convenience from uuStrings.pas
{ Formate_Liste
Concatène les éléments de S en les séparant par la chaine Separateur
et retourne le résultat.
}
procedure Formate_Liste( var S: String; Separateur, Element: String); overload;
const sys_Vide=''; //duplicated for convenience from u_sys_.pas
begin
     if Element = sys_Vide then exit;

     if S <> sys_Vide
     then
         S:= S + Separateur;

     S:= S + Element;
end;

{ TTreeData }

procedure TTreeData.SetValue( _Value: String);
   function Colon_count( _Value: String): Integer;
   begin
        Result:= 0;
        while Pos(':',_Value) > 0
        do
          begin
          StrToK( ':',_Value);
          Inc(Result);
          end;
   end;
   procedure FdValue_from_FValue;
   var
      s: String;
   begin
        case Colon_count( FValue)
        of
          0: s:= '0:0:'+FValue;
          1: s:= '0:'  +FValue;
          2: s:=        FValue;
          end;
        if not TryStrToDateTime( s, FdValue)
        then
            FdValue:= 0;
   end;
begin
     FValue:= _Value;

     FdValue_from_FValue;
end;

procedure TTreeData.SetdValue( _dValue: TDateTime);
   procedure Strip_leading_zeroes;
   const
        s='0:';
   begin
        while 1=Pos(s, FValue)
        do
          Delete( FValue, 1, Length(s));
   end;
begin
     FdValue:= _dValue;

     FValue:= FormatDateTime( 'h:n:ss', FdValue);
     Strip_leading_zeroes;
end;


{ TfFileVirtualTree }

procedure TfFileVirtualTree.FormCreate(Sender: TObject);
begin
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slFiles);
     FreeAndNil( slNodes);
     FreeAndNil( slTreeData);//todo: TTreeData not freed( may be freed by vst ?)
end;

function TfFileVirtualTree.NewTreeData( _Text, _Key, _Value: String; _IsLeaf: Boolean): TTreeData;
begin
     Result:= TTreeData.Create;
     Result.Text := _Text;
     Result.Key  := _Key;
     Result.Value:= _Value;
     Result.IsLeaf:= _IsLeaf;
     slTreeData.AddObject( _Key, Result);
end;

procedure TfFileVirtualTree.bLoad_from_FileClick(Sender: TObject);
begin
     Load_from_File( eFileName.Text);
end;

procedure TfFileVirtualTree.bODClick(Sender: TObject);
begin
     od.FileName:= eFileName.Text;
     if od.Execute
     then
         eFileName.Text:= od.FileName;
end;

procedure TfFileVirtualTree.Load_from_File( _FileName: String);
   procedure slFiles_from_ini_file;
   var
      ini: TINIFile;
   begin
        ini:= TINIFile.Create( _FileName);
        try
           ini.ReadSectionRaw( 'Files', slFiles);
        finally
               FreeAndNil( ini);
               end;
   end;
   procedure tv_from_slFiles;
   var
      i: Integer;
      Key, Value: String;
   begin
        pb.Min:= -1;
        pb.Max:= slFiles.Count-1;
        for i:= 0 to slFiles.Count-1
        do
          begin
          Key  := slFiles.Names         [ i];
          Value:= slFiles.ValueFromIndex[ i];

          vst_addnode_from_key_value( Key, Value);
          pb.Position:= i;
          end;
        lCompute_Aggregates.Show;
        Application.ProcessMessages;
        Compute_Aggregates;
        lCompute_Aggregates.Hide;
   end;
begin
     slFiles:= TStringList.Create;
     slFiles_from_ini_file;
     slNodes:= TStringList.Create;
     slTreeData:= TStringList.Create;
     tv_from_slFiles;
end;

function TfFileVirtualTree.NewNode_from_TreeData( _Parent: PVirtualNode; _td: TTreeData): PVirtualNode;
begin
     Result:= vst.AddChild( _Parent, Pointer(_td));
end;

function TfFileVirtualTree.Add_Leaf( _Parent: PVirtualNode; _Text, _Key, _Value: String): PVirtualNode;
var
   td: TTreeData;
begin
     td:= NewTreeData( _Text, _Key, _Value, True);
     Result:= NewNode_from_TreeData( _Parent, td);
end;

function TfFileVirtualTree.Add_Node(_Parent: PVirtualNode; _Text: String): PVirtualNode;
var
   td: TTreeData;
begin
     td:= NewTreeData( _Text, '', '', False);
     Result:= NewNode_from_TreeData( _Parent, td);
end;

function TfFileVirtualTree.TreeData_from_Node(_Node: PVirtualNode): TTreeData;
var
   po: ^TObject;
begin
     Result:= nil;
     if nil = _Node then exit;

     po:= vst.GetNodeData( _Node);
     if po = nil then exit;

     if not (po^ is TTreeData) then exit;
     Result:= TTreeData(po^)
end;

procedure TfFileVirtualTree.vst_addnode_from_key_value(_Key, _Value: String);
const
     Separator='\';
var
   sTreePath: String;
   procedure Recursif( Root: String; Parent: PVirtualNode);
   var
      s, sCle: String;
      i: Integer;
      Node: PVirtualNode;
   begin
        s:= StrTok( Separator, sTreePath);
        if sTreePath = ''
        then             //terminal case for recursion, add Value
            s:= s;

        sCle:= Root;
        Formate_Liste( sCle, Separator, s);
        i:= slNodes.IndexOf( sCle);
        if i = -1
        then
            begin
            if sTreePath = ''
            then
                Node:= Add_leaf( Parent, s, _Key, _Value)
            else
                Node:= Add_Node( Parent, s);

            slNodes.AddObject( sCle, TObject(Node));
            end
        else
            Node:= PVirtualNode( slNodes.Objects[i]);

        if sTreePath = ''
        then //terminal case for recursion
            begin
            end
        else
            Recursif( sCle, Node);
   end;
begin
     sTreePath:= _Key;
     Recursif( '', nil);

end;

procedure TfFileVirtualTree.vstGetText( Sender: TBaseVirtualTree;
                                        Node: PVirtualNode;
                                        Column: TColumnIndex;
                                        TextType: TVSTTextType;
                                        var CellText: String);
var
   td: TTreeData;
begin
     td:= TreeData_from_Node( Node);
     case Column
     of
       0: CellText:= td.Text;
       1: CellText:= td.Value;
       end;
end;

procedure TfFileVirtualTree.vstInitNode( Sender: TBaseVirtualTree;
                                         ParentNode, Node: PVirtualNode;
                                         var InitialStates: TVirtualNodeInitStates);
begin
     Node^.CheckType:=ctCheckBox;
end;

procedure TfFileVirtualTree.vstChecked( Sender: TBaseVirtualTree; Node: PVirtualNode);
var // This ensures that all children follow the status checked/unchecked of the parent
   cs: TCheckState;
   procedure CheckChilds( _Parent: PVirtualNode);
   var
      vn: PVirtualNode;
   begin
        vn:= vst.GetFirstChild(_Parent);
        while nil <> vn
        do
          begin
          vn^.CheckState:= cs;
          CheckChilds( vn);
          vn:= vst.GetNextSibling(vn);
          end;
   end;
begin
     cs:= Node^.CheckState;
     CheckChilds( Node);
     vst.Refresh;
end;

procedure TfFileVirtualTree.Compute_Aggregates;
   function Compute_Childs( _Parent: PVirtualNode): TDateTime;
      procedure Compute_node_dValue;
      var
         td: TTreeData;
         Parent_dValue: TDateTime;
         vn: PVirtualNode;
         vn_dValue: TDateTime;
      begin
           Parent_dValue:= 0;
           vn:= vst.GetFirstChild(_Parent);
           while nil <> vn
           do
             begin
             vn_dValue:= Compute_Childs( vn);
             Parent_dValue:= Parent_dValue + vn_dValue;

             vn:= vst.GetNextSibling(vn);
             end;
           Result:= Parent_dValue;

           td:= TreeData_from_Node( _Parent);
           if Assigned( td)
           then
               td.dValue:= Parent_dValue;
      end;
      procedure Compute_leaf_dValue;
      var
         td: TTreeData;
      begin
           td:= TreeData_from_Node( _Parent);
           if nil =  td then exit;

           Result:= td.dValue;
      end;
   begin
        Result:= 0;
        if _Parent^.ChildCount = 0
        then
            Compute_leaf_dValue
        else
            Compute_node_dValue;
   end;
begin
     Compute_Childs( vst.RootNode);
end;

function TfFileVirtualTree.Get_Selected: String;
var
   vn: PVirtualNode;
   td: TTreeData;
begin
     Result:= '';
     vn:= vst.GetFirstSelected;
     while nil <> vn
     do
       begin
       td:= TreeData_from_Node( vn);
       if td.IsLeaf
       then
           Formate_Liste( Result, #13#10, td.Key+' '+td.Value);
       vn:= vst.GetNextSelected( vn);
       end;
end;

function TfFileVirtualTree.Get_Checked: String;
var
   vn: PVirtualNode;
   td: TTreeData;
begin
     Result:= '';
     vn:= vst.GetFirstChecked;
     while nil <> vn
     do
       begin
       td:= TreeData_from_Node( vn);
       if td.IsLeaf
       then
           Formate_Liste( Result, #13#10, td.Key+' '+td.Value);
       vn:= vst.GetNextChecked( vn);
       end;
end;

procedure TfFileVirtualTree.bGetSelectionClick(Sender: TObject);
begin
     m.Lines.Text:= Get_Selected;
end;

procedure TfFileVirtualTree.bGetCheckedClick(Sender: TObject);
begin
     m.Lines.Text:= Get_Checked;
end;

procedure TfFileVirtualTree.bfFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

