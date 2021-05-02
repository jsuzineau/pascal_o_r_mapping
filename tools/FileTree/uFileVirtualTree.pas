unit uFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
 Classes, SysUtils, IniFiles, VirtualTrees, ComCtrls, StdCtrls, Forms, Math, StrUtils;

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

 { ThVirtualStringTree }

 ThVirtualStringTree // VirtualStringTree handler
 =
  class
  //Life cycle management
  public
    constructor Create( _has_check_boxes: Boolean; _vst: TVirtualStringTree; _pb: TProgressBar; _lCompute_Aggregates: TLabel);
    destructor Destroy; override;
  //Attributes
  public
    has_check_boxes: Boolean;
    vst: TVirtualStringTree;
    pb: TProgressBar;
    lCompute_Aggregates: TLabel;
    slFiles: TStringList;
    slNodes: TStringList;
    slTreeData: TStringList;
  //Methods
  public
    procedure Load_from_File( _FileName: String);
    procedure Load_from_StringList( _sl: TStringList);
    function Get_Selected: String;
    function Get_Checked: String;
    function Get_Checked_or_Selected( _eLoadTime   : TEdit;
                                      _lRunTime    : TLabel;
                                      _lMachineTime: TLabel;
                                      _lCount      : TLabel): String;
    procedure vst_expand_first_level;
    procedure vst_expand_full;
    function TreeData_from_Node( _Node: PVirtualNode): TTreeData;
    function render_as_text: String;
  private
    function NewTreeData(_Text, _Key, _Value: String; _IsLeaf: Boolean): TTreeData;
    function NewNode_from_TreeData(_Parent: PVirtualNode; _td: TTreeData): PVirtualNode;
    procedure vst_addnode_from_key_value( _Key, _Value: String);
    function Add_Leaf(_Parent: PVirtualNode; _Text, _Key, _Value: String): PVirtualNode;
    function Add_Node(_Parent: PVirtualNode; _Text: String): PVirtualNode;
    procedure Compute_Aggregates;
    procedure internal_Load;
    procedure Empty_slTreeData;
  //vst Events
  private
    procedure vstChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstGetText( Sender: TBaseVirtualTree; Node: PVirtualNode;
                          Column: TColumnIndex;
                          TextType: TVSTTextType;
                          var CellText: String);
    procedure vstInitNode( Sender: TBaseVirtualTree;
                           ParentNode,Node: PVirtualNode;
                           var InitialStates: TVirtualNodeInitStates);
  end;

function Duration_from_DateTime( _DateTime: TDateTime): String;

implementation

function Duration_from_DateTime( _DateTime: TDateTime): String;
var
   Day, Hour, Minute, Second, Millisecond: Word;
begin
     Day:= Trunc(_DateTime);
     DecodeTime( _DateTime, Hour, Minute, Second, Millisecond);

     case Day
     of
       0:   Result:= '';
       1:   Result:= IntToStr(Day)+' Day ' ;
       else Result:= IntToStr(Day)+' Days ';
       end;

     if (Result<>'') or (Hour<>0) then Result:=Result+Format ('%.1d:',[Hour]);

          if (Result='') then Result:=       Format ('%.1d:',[Minute])
     else                     Result:=Result+Format ('%.2d:',[Minute]);

     Result:=Result+Format ('%.2d',[Second]);
end;

function DateTime_from_SpecialTime( _SpecialTime: String): TDateTime;
var
   s: String;
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
begin
     case Colon_count( _SpecialTime)
     of
       0: s:= '0:0:'+_SpecialTime;
       1: s:= '0:'  +_SpecialTime;
       2: s:=        _SpecialTime;
       end;
     if not TryStrToDateTime( s, Result)
     then
         Result:= 0;
end;

{ TTreeData }

procedure TTreeData.SetValue( _Value: String);
begin
     FValue := _Value;
     FdValue:= DateTime_from_SpecialTime( FValue);
end;

procedure TTreeData.SetdValue( _dValue: TDateTime);
begin
     FdValue:= _dValue;

     FValue:= Duration_from_DateTime( FdValue);
end;


{ ThVirtualStringTree }

constructor ThVirtualStringTree.Create( _has_check_boxes: Boolean;
                                        _vst: TVirtualStringTree;
                                        _pb: TProgressBar;
                                        _lCompute_Aggregates: TLabel);
begin
     has_check_boxes:= _has_check_boxes;
     vst:= _vst;
     pb:= _pb;
     lCompute_Aggregates:= _lCompute_Aggregates;

     slFiles   := TStringList.Create;
     slNodes   := TStringList.Create;
     slTreeData:= TStringList.Create;

     //assign vst events
     vst.OnChecked := @vstChecked;
     vst.OnGetText := @vstGetText;
     vst.OnInitNode:= @vstInitNode;
end;

destructor ThVirtualStringTree.Destroy;
begin
     FreeAndNil( slFiles   );
     FreeAndNil( slNodes   );
     FreeAndNil( slTreeData);//todo: TTreeData not freed( may be freed by vst ?)
     inherited Destroy;
end;

function ThVirtualStringTree.NewTreeData( _Text, _Key, _Value: String;
                                          _IsLeaf: Boolean): TTreeData;
begin
     Result:= TTreeData.Create;
     Result.Text := _Text;
     Result.Key  := _Key;
     Result.Value:= _Value;
     Result.IsLeaf:= _IsLeaf;
     slTreeData.AddObject( _Key, Result);
end;

function ThVirtualStringTree.NewNode_from_TreeData( _Parent: PVirtualNode; _td: TTreeData): PVirtualNode;
begin
     Result:= vst.AddChild( _Parent, Pointer(_td));
end;

procedure ThVirtualStringTree.internal_Load;
   procedure vst_from_slFiles;
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
     try
        vst.Clear;
        slNodes.Clear;
        Empty_slTreeData;

        vst.BeginUpdate;
        vst_from_slFiles;
        vst_expand_first_level;
     finally
            vst.EndUpdate;
            end;
end;

procedure ThVirtualStringTree.Empty_slTreeData;
var
   td: TTreeData;
begin
     while slTreeData.Count > 0
     do
       begin
       td:= slTreeData.Objects[0] as TTreeData;
       slTreeData.Delete(0);
       FreeAndNil( td);
       end;
end;

procedure ThVirtualStringTree.Load_from_File(_FileName: String);
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
begin
     slFiles_from_ini_file;
     internal_Load;
end;

procedure ThVirtualStringTree.Load_from_StringList(_sl: TStringList);
begin
     slFiles.Text:= _sl.Text;
     internal_Load;
end;

function ThVirtualStringTree.Add_Leaf( _Parent: PVirtualNode; _Text, _Key, _Value: String): PVirtualNode;
var
   td: TTreeData;
begin
     td:= NewTreeData( _Text, _Key, _Value, True);
     Result:= NewNode_from_TreeData( _Parent, td);
end;

function ThVirtualStringTree.Add_Node(_Parent: PVirtualNode; _Text: String): PVirtualNode;
var
   td: TTreeData;
begin
     td:= NewTreeData( _Text, _Text, '', False);
     Result:= NewNode_from_TreeData( _Parent, td);
end;

function ThVirtualStringTree.TreeData_from_Node(_Node: PVirtualNode): TTreeData;
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

procedure ThVirtualStringTree.vst_addnode_from_key_value(_Key, _Value: String);
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

procedure ThVirtualStringTree.Compute_Aggregates;
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

procedure ThVirtualStringTree.vst_expand_first_level;
var
   vn: PVirtualNode;
begin
     vn:= vst.GetFirstChild(vst.RootNode);
     while nil <> vn
     do
       begin
       vst.Expanded[ vn]:= True;
       vn:= vst.GetNextSibling(vn);
       end;
end;

procedure ThVirtualStringTree.vst_expand_full;
begin
     vst.FullExpand;
end;

function ThVirtualStringTree.Get_Selected: String;
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

function ThVirtualStringTree.Get_Checked: String;
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
           Formate_Liste( Result, #13#10, td.Key+'='+td.Value);
       vn:= vst.GetNextChecked( vn);
       end;
end;

function ThVirtualStringTree.Get_Checked_or_Selected( _eLoadTime   : TEdit;
                                                      _lRunTime    : TLabel;
                                                      _lMachineTime: TLabel;
                                                      _lCount      : TLabel): String;
var
   LoadTime, RunTime, MachineTime : TDateTime;
   ProgramCount: DWord;
   procedure CheckChilds( _Parent: PVirtualNode; _Parent_Checked, _Parent_Selected: Boolean);
   var
      vn: PVirtualNode;
      Checked, Selected: Boolean;
      procedure Process_TreeData;
      var
         td: TTreeData;
      begin
           td:= TreeData_from_Node( vn);
           if not td.IsLeaf then exit;
           Formate_Liste( Result, #13#10, td.Key+'='+td.Value);
           MachineTime:= MachineTime+td.dValue;
               RunTime:=     RunTime+td.dValue+LoadTime;
           inc(ProgramCount);
      end;
   begin
        vn:= vst.GetFirstChild(_Parent);
        while nil <> vn
        do
          begin
          Checked:= _Parent_Checked or (csCheckedNormal = vn^.CheckState);
          Selected:= _Parent_Selected or vst.Selected[vn];
          if Checked or Selected then Process_TreeData;
          CheckChilds( vn, Checked, Selected);
          vn:= vst.GetNextSibling(vn);
          end;
   end;
begin
        LoadTime:= DateTime_from_SpecialTime( _eLoadTime.Text);
         RunTime:= 0;
     MachineTime:= 0;
     ProgramCount:=0;
     Result:= '';
     CheckChilds( vst.RootNode, False, False);

     _lRunTime    .Caption:= '  '+Duration_From_DateTime(     RunTime)+'  ';
     _lMachineTime.Caption:= '  '+Duration_From_DateTime( MachineTime)+'  ';
     _lCount      .Caption:= '  '+inttostr(ProgramCount)+'  ';
end;

procedure ThVirtualStringTree.vstChecked( Sender: TBaseVirtualTree;
                                          Node: PVirtualNode);
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

procedure ThVirtualStringTree.vstGetText( Sender: TBaseVirtualTree;
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

procedure ThVirtualStringTree.vstInitNode( Sender: TBaseVirtualTree;
                                           ParentNode, Node: PVirtualNode;
                                           var InitialStates: TVirtualNodeInitStates);
begin
     if has_check_boxes
     then
         Node^.CheckType:=ctCheckBox
     else
         Node^.CheckType:=ctNone;
end;

function ThVirtualStringTree.render_as_text: String;
var
   sl:TStringList;
   procedure Iterate_childs( _Parent: PVirtualNode; _Parent_index: integer= -1);
   type String850= type String(850);
   const
        Indent= 4;
   var
      vn: PVirtualNode;
      td: TTreeData;
      vn_Level: Integer;
      vn_index: Integer;
      vn_Text: String;
      vn_indent: Integer;
      procedure Line_to_parent;
      const
           vertical_line_char=#179;//'|';
           horizontal_line_char=#196;//'-';
           angle_char=#192;//'*';
           crossing_char=#195;//'L';
      var
         i: Integer;
         Parent_indent: Integer;
         s: String850;
      begin
           if -1 = _Parent_index then exit;
           Parent_indent:= vn_indent-Indent;
           if Parent_indent < 0 then exit;
           //vertical line
           for i:= _Parent_index+1 to vn_index-1
           do
             begin
             s:= sl[i];
             case s[Parent_indent+1]
             of
               crossing_char: begin end;
               angle_char   : s[Parent_indent+1]:= crossing_char;
               else
                   s[Parent_indent+1]:= vertical_line_char;
               end;
             sl[i]:= s;
             end;
           //horizontal line
           s:= sl[vn_index];
           s[Parent_indent+1]:= angle_char;
           for i:= Parent_indent+2 to vn_indent
           do
             begin
             s[i]:= horizontal_line_char;
             end;
           sl[vn_index]:= s;
      end;
   begin
        vn:= vst.GetFirstChild(_Parent);
        while nil <> vn
        do
          begin
          vn_Level:= vst.GetNodeLevel(vn);
          vn_indent:= vn_Level*Indent;
          vn_Text:= StringOfChar( ' ', vn_indent);
          td:= TreeData_from_Node( vn);
          if nil <> td then vn_Text:= vn_Text + td.Text+' = '+td.Value;
          vn_index:= sl.Add( vn_Text);
          Line_to_parent;
          Iterate_childs( vn, vn_index);
          vn:= vst.GetNextSibling(vn);
          end;
   end;
begin
     sl:= TStringList.Create;
     sl.DefaultEncoding:= TEncoding.GetEncoding(850);

     Iterate_childs( vst.RootNode);
     Result:= sl.Text;
end;

end.

