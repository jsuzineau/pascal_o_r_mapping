unit uFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
 Classes, SysUtils, IniFiles, VirtualTrees, ComCtrls, StdCtrls, Forms,
    fpreport,fpreportpdfexport, fpTTF;

type
 { TStringList_ReportData }

 TStringList_ReportData
 =
  class( TFPReportData)
  public
    sl: TStringList;
    i: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure DoGetValue(const AFieldName: string; var AValue: variant); override;
    procedure DoInitDataFields; override;
    procedure DoOpen; override;
    procedure DoFirst; override;
    procedure DoNext; override;
    procedure DoClose; override;
    function  DoEOF: boolean; override;
  end;

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
    function Get_Checked_or_Selected: String;
    procedure vst_expand_first_level;
    procedure vst_expand_full;
    function TreeData_from_Node( _Node: PVirtualNode): TTreeData;
    function render_as_text: String;
    function to_fpreport_pdf( _pdf_filename: String): String;
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
  //txt2pdf
  private
    slTXT2PDF: TStringList;
    FLineIndex : Integer;
    txt2pdf_First_Run: Boolean;
    procedure DoFirst(Sender: TObject);
    procedure DoGetEOF(Sender: TObject; var IsEOF: boolean);
    procedure DoGetNames(Sender: TObject; List: TStrings);
    procedure DoGetNext(Sender: TObject);
    procedure DoGetValue(Sender: TObject; const AValueName: string; var AValue: variant);
  public
    function fpreport_txt2pdf( _pdf_filename: String): String;
  end;


implementation

{ TStringList_ReportData }

constructor TStringList_ReportData.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     sl:= TStringList.Create;
end;

destructor TStringList_ReportData.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TStringList_ReportData.DoGetValue(const AFieldName: string; var AValue: variant);
begin
     AValue:= sl[i];
end;

procedure TStringList_ReportData.DoInitDataFields;
begin
     inherited DoInitDataFields;
     DataFields.AddField('Text',rfkString);
end;

procedure TStringList_ReportData.DoOpen;
begin
     inherited DoOpen;
end;

procedure TStringList_ReportData.DoFirst;
begin
     inherited DoFirst;
     i:= 0;
end;

procedure TStringList_ReportData.DoNext;
begin
     inherited DoNext;
     Inc(I);
end;

procedure TStringList_ReportData.DoClose;
begin
     inherited DoClose;
end;

function TStringList_ReportData.DoEOF: boolean;
begin
     Result:= i>= sl.Count-1;
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

     FValue:= FormatDateTime( 'd:hh:nn:ss', FdValue);
     Strip_leading_zeroes;
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
     slTXT2PDF := TStringList.Create;
     txt2pdf_First_Run:= True;

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
     FreeAndNil( slTXT2PDF );
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
        slFiles.Clear;
        ini:= TINIFile.Create( _FileName);
        try
           ini.ReadSectionRaw( 'Files', slFiles);
        finally
               FreeAndNil( ini);
               end;
   end;
begin
     slFiles_from_ini_file;
     vst.Clear;
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

function ThVirtualStringTree.Get_Checked_or_Selected: String;
   procedure CheckChilds( _Parent: PVirtualNode; _Parent_Checked, _Parent_Selected: Boolean);
   var
      vn: PVirtualNode;
      Checked, Selected: Boolean;
      td: TTreeData;
      procedure Process_TreeData;
      var
         td: TTreeData;
      begin
           td:= TreeData_from_Node( vn);
           if not td.IsLeaf then exit;
           Formate_Liste( Result, #13#10, td.Key+'='+td.Value);
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
     Result:= '';
     CheckChilds( vst.RootNode, False, False);
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

function ThVirtualStringTree.to_fpreport_pdf( _pdf_filename: String): String;
var
   r: TFPReport;
   srd: TStringList_ReportData;
   p: TFPReportPage;
   //tb: TFPReportTitleBand;
   //m: TFPReportMemo;
   db:TFPReportDataBand;
   Memo: TFPReportMemo;
   re: TFPReportExportPDF;
begin
     Result:= _pdf_filename;

     PaperManager.RegisterStandardSizes;
     r:= TFPReport.Create( nil);
     try
        r.Author:= 'FileTree';
        r.Title:=  'FileTree';
        srd:= TStringList_ReportData.Create( nil);
        srd.sl.DefaultEncoding:= TEncoding.GetEncoding(850);
        try
           srd.sl.Text:= slFiles.Text+#13#10+render_as_text;
           //srd.sl.Text:= 'A';
           //srd.sl.Add('A');
           p:= TFPReportPage.Create( r);
           p.Orientation:= poPortrait;
           p.PageSize.PaperName:= 'A4';
           //p.Font.Name:='Courier New';
           p.Font.Name:='Ubuntu Mono';
           { page margins }
           p.Margins.Left := 30;
           p.Margins.Top := 20;
           p.Margins.Right := 30;
           p.Margins.Bottom := 20;

           {
           tb:= TFPReportTitleBand.Create( p);
           tb.Layout.Height := 40;

           m := TFPReportMemo.Create(tb);
           m.Layout.Left := 5;
           m.Layout.Top := 0;
           m.Layout.Width := 140;
           m.Layout.Height := 15;

           m.Text:= '';
           }
           db := TFPReportDataBand.Create(p);
           db.Layout.Height := 30;
           db.Data:= srd;
           Memo := TFPReportMemo.Create(db);
           Memo.Layout.Left := 30;
           Memo.Layout.Top := 0;
           Memo.Layout.Width := 50;
           Memo.Layout.Height := 5;
           Memo.Text := '[text]';

           { specify what directories should be used to find TrueType fonts }
           //gTTFontCache.SearchPath.Add(cFCLReportDemosLocation + '/fonts/');
           //gTTFontCache.ReadStandardFonts;
           //gTTFontCache.SearchPath.Add('c:\WINDOWS\Fonts\');
           //gTTFontCache.SearchPath.Add('c:\WINDOWS\Fonts\COUR.TTF');
           //gTTFontCache.SearchPath.Add(ExtractFilePath(Application.ExeName));
           //gTTFontCache.Add(TFPFontCacheItem.Create('c:\WINDOWS\Fonts\COUR.TTF'));
           gTTFontCache.SearchPath.Add('fonts/');

           gTTFontCache.BuildFontCache;

           r.RunReport;
           re:= TFPReportExportPDF.Create(nil); // as before, use Self or Nil based on Application class
           try
              re.FileName:= Result;
              r.RenderReport( re);
           finally
                  FreeAndNil( re);
                  end;

        finally
               FreeAndNil( srd);
               end;
     finally
            FreeAndNil( r);
            end;
end;

procedure ThVirtualStringTree.DoGetNames(Sender: TObject; List: TStrings);
begin
     List.Add('Line');
end;

procedure ThVirtualStringTree.DoGetEOF(Sender: TObject; var IsEOF: boolean);
begin
     isEOF:=FLineIndex>=slTXT2PDF.Count;
end;

procedure ThVirtualStringTree.DoFirst(Sender: TObject);
begin
     FLineIndex:=0;
end;

procedure ThVirtualStringTree.DoGetNext(Sender: TObject);
begin
     Inc(FLineIndex);
end;

procedure ThVirtualStringTree.DoGetValue( Sender: TObject;
                                          const AValueName: string;
                                          var AValue: variant);
begin
     Avalue:=slTXT2PDF[FLineIndex];
end;

function ThVirtualStringTree.fpreport_txt2pdf(_pdf_filename: String): String;
var
   r  : TFPReport;
   rud: TFPReportUserData;
   PG : TFPReportPage;
   PH : TFPReportPageHeaderBand;
   PF : TFPReportPageFooterBand;
   DB : TFPReportDataBand;
   M : TFPReportMemo;
   PDF : TFPReportExportPDF;
   Fnt : String;

begin
     r:=TFPReport.Create(nil);
     rud:=TFPReportUserData.Create(nil);
     try
        //Fnt:='DejaVuSans';
        Fnt:='Consolas';
        //Fnt:='CourierNewPSMT';
        //Fnt:='UbuntuMono-Regular';
        //Terminate;
        //slTXT2PDF.LoadFromFile(ParamStr(1));
        slTXT2PDF.Text:= slFiles.Text+#13#10+render_as_text;
        gTTFontCache.ReadStandardFonts;
        //gTTFontCache.SearchPath.Add('E:\01_Projets\01_pascal_o_r_mapping\tools\FileTree\fonts\');
        gTTFontCache.BuildFontCache;
        if txt2pdf_First_Run
        then
            begin
            PaperManager.RegisterStandardSizes;
            txt2pdf_First_Run:= False;
            end;
        // Page
        PG:=TFPReportPage.Create(r);
        PG.Data:=rud;
        PG.Orientation := poPortrait;
        PG.PageSize.PaperName := 'A4';
        PG.Margins.Left := 15;
        PG.Margins.Top := 15;
        PG.Margins.Right := 15;
        PG.Margins.Bottom := 15;
        // Page header
        PH:=TFPReportPageHeaderBand.Create(PG);
        PH.Layout.Height:=10; // 1 cm.
        M:=TFPReportMemo.Create(PH);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=120;
        M.Layout.Height:=7;
        M.Text:=ParamStr(1);
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        M:=TFPReportMemo.Create(PH);
        M.Layout.Top:=1;
        M.Layout.Left:=PG.Layout.Width-41;
        M.Layout.Width:=40;
        M.Layout.Height:=7;
        M.Text:='[Date]';
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Page footer
        PF:=TFPReportPageFooterBand.Create(PG);
        PF.Layout.Height:=10; // 1 cm.
        M:=TFPReportMemo.Create(PF);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=40;
        M.Layout.Height:=7;
        M.Text:='Page [PageNo]';
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Actual line
        DB:=TFPReportDataBand.Create(PG);
        DB.Data:=rud;
        DB.Layout.Height:=5; // 0.5 cm.
        DB.StretchMode:=smActualHeight;
        M:=TFPReportMemo.Create(DB);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=PG.Layout.Width-41;
        M.Layout.Height:=4;
        M.Text:='[Line]';
        M.StretchMode:=smActualHeight;
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Set up data
        rud.OnGetNames:=@DoGetNames;
        rud.OnNext:=@DoGetNext;
        rud.OnGetValue:=@DoGetValue;
        rud.OnGetEOF:=@DoGetEOF;
        rud.OnFirst:=@DoFirst;
        // Go !
        r.RunReport;
        PDF:=TFPReportExportPDF.Create(nil);
        try
          PDF.FileName:=_pdf_filename;
          r.RenderReport(PDF);
        finally
          PDF.Free;
        end;

     finally
            FreeAndNil(rud);
            FreeAndNil(r);
            end;
     Result:= _pdf_filename;

end;

end.

