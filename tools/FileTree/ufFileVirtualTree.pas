unit ufFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
    uFileVirtualTree,
    ufFileTree,
    uFileVirtualTree_odt, uText_to_PDF,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, IniPropStorage, IniFiles, VirtualTrees, LCLIntf, Menus;

type

 { TfFileVirtualTree }

 TfFileVirtualTree
 =
  class(TForm)
   bReport: TButton;
   eFileName: TEdit;
   eLoadTime: TEdit;
   ips: TIniPropStorage;
   Label1: TLabel;
   Label2: TLabel;
   lCount1: TLabel;
   lCount: TLabel;
   lMachineTime: TLabel;
   lMachineTime1: TLabel;
   lCompute_Aggregates: TLabel;
   lRunTime: TLabel;
   lRunTime1: TLabel;
   m: TMemo;
   miReport: TMenuItem;
   miCutListPDF: TMenuItem;
   miCutListTreePDF: TMenuItem;
   miDocument: TMenuItem;
   mifFileTree: TMenuItem;
   miWindow: TMenuItem;
   miGetCheckedItems: TMenuItem;
   miGetChecked_or_Selected: TMenuItem;
   miGetSelection: TMenuItem;
   miResult: TMenuItem;
   miLoadFrom_File: TMenuItem;
   miFile: TMenuItem;
   mm: TMainMenu;
   od: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pb: TProgressBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    tReady: TTimer;
    vstCutList: TVirtualStringTree;
    vst: TVirtualStringTree;
    procedure bGetChecked_or_SelectedClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure bReportClick(Sender: TObject);
    procedure bTest_Duration_from_DateTimeClick(Sender: TObject);
    procedure miCutListPDFClick(Sender: TObject);
    procedure miCutListTreePDFClick(Sender: TObject);
    procedure miDocumentClick(Sender: TObject);
    procedure eFileNameChange(Sender: TObject);
    procedure eFileNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ipsRestoreProperties(Sender: TObject);
    procedure ipsSaveProperties(Sender: TObject);
    procedure mifFileTreeClick(Sender: TObject);
    procedure miGetCheckedItemsClick(Sender: TObject);
    procedure miGetChecked_or_SelectedClick(Sender: TObject);
    procedure miGetSelectionClick(Sender: TObject);
    procedure miLoadFrom_FileClick(Sender: TObject);
    procedure tReadyTimer(Sender: TObject);
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
     var NewState: TCheckState; var Allowed: Boolean);
    procedure vstClick(Sender: TObject);
  //Ready (waiting for loading completed)
  private
    Ready: Boolean;
  //Load_from_File
  private
    procedure Load_from_File;
    procedure Select_File;
  //Extracting Result
  private
    slCutList: TStringList;
    hvst: ThVirtualStringTree;
    hvstCutList: ThVirtualStringTree;
    procedure Process_CutList;
    procedure Process_GetChecked_or_Selected;
  //Result Files
  private
    CutList, CutList_Tree, CutList_List_Tree: String;
    procedure OpenDocument_Log( _FileName: String);
    procedure Process_PDF( _Text, _PDF_filename: String);
    procedure Process_CutList_PDF;
    procedure Process_CutList_Tree_PDF;
    procedure Process_CutList_PDF_Tree;
    procedure Process_txt_to_odt;
  end;

var
 fFileVirtualTree: TfFileVirtualTree;

implementation

{$R *.lfm}

{ TfFileVirtualTree }

procedure TfFileVirtualTree.FormCreate(Sender: TObject);
begin
     slCutList  := TStringList.Create;

     hvst       := ThVirtualStringTree.Create( True , vst       , pb, lCompute_Aggregates);
     hvstCutList:= ThVirtualStringTree.Create( False, vstCutList, pb, lCompute_Aggregates);

     Ready:= False;
     tReady.Enabled:= True;

     lRunTime    .Caption:= '            ';
     lMachineTime.Caption:= '            ';
     lCount      .Caption:= '      ';
     m.text:='';
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slCutList  );
     FreeAndNil( hvst      );
     FreeAndNil( hvstCutList);
end;

procedure TfFileVirtualTree.ipsRestoreProperties(Sender: TObject);
begin
     vst.Header.Columns[0].Width:= ips.ReadInteger( 'vst.Header.Columns[0].Width', 200);
     vst.Header.Columns[1].Width:= ips.ReadInteger( 'vst.Header.Columns[1].Width',  50);
     vstCutList.Header.Columns[0].Width:= ips.ReadInteger( 'vstCutList.Header.Columns[0].Width', 200);
     vstCutList.Header.Columns[1].Width:= ips.ReadInteger( 'vstCutList.Header.Columns[1].Width',  50);
     Text_to_PDF.Report_Title:= ips.ReadString( 'Text_to_PDF.Report.Title','Cut List Report');
end;

procedure TfFileVirtualTree.ipsSaveProperties(Sender: TObject);
begin
     ips.WriteInteger( 'vst.Header.Columns[0].Width', vst.Header.Columns[0].Width);
     ips.WriteInteger( 'vst.Header.Columns[1].Width', vst.Header.Columns[1].Width);
     ips.WriteInteger( 'vstCutList.Header.Columns[0].Width', vstCutList.Header.Columns[0].Width);
     ips.WriteInteger( 'vstCutList.Header.Columns[1].Width', vstCutList.Header.Columns[1].Width);
     ips.WriteString ( 'Text_to_PDF.Report.Title',  Text_to_PDF.Report_Title);
end;


procedure TfFileVirtualTree.miLoadFrom_FileClick(Sender: TObject);
begin
     Load_from_File;
end;

procedure TfFileVirtualTree.tReadyTimer(Sender: TObject);
begin
     Ready:= True;
     tReady.Enabled:= False;
     Load_from_File;
end;

procedure TfFileVirtualTree.Load_from_File;
begin
     if not Ready then exit;

     hvst.Load_from_File( eFileName.Text);
end;

procedure TfFileVirtualTree.Select_File;
begin
     od.FileName:= eFileName.Text;
     if od.Execute
     then
         eFileName.Text:= od.FileName;
end;

procedure TfFileVirtualTree.bODClick(Sender: TObject);
begin
     Select_File;
end;

procedure TfFileVirtualTree.eFileNameClick(Sender: TObject);
begin
     Select_File;
end;

procedure TfFileVirtualTree.eFileNameChange(Sender: TObject);
begin
     If Not(tReady.Enabled) Then
        Load_from_File;
end;

procedure TfFileVirtualTree.bTest_Duration_from_DateTimeClick(Sender: TObject);

     procedure Test( _Day, _Hour, _Minute, _Second: Word);
     var
        dt: TDateTime;
        duration: String;
     begin
          dt:= _Day+EncodeTime( _Hour, _Minute, _Second, 0);
          duration:= Duration_from_DateTime( dt);
          m.Lines.Add( Format( '%.2d %.2d:%.2d:%.2d => %s',
                               [_Day, _Hour, _Minute, _Second, duration]));
     end;
begin
     m.Clear;
     Test( 0, 0, 0, 0);
     Test( 0, 0, 0, 1);
     Test( 0, 0, 0,10);
     Test( 0, 0, 1,10);
     Test( 0, 0,10,10);
     Test( 0, 1,10,10);
     Test( 0,10,10,10);
     Test( 1,10,10,10);
     Test(10,10,10,10);
end;

procedure TfFileVirtualTree.miCutListPDFClick(Sender: TObject);
begin
     Process_CutList_PDF;
end;

procedure TfFileVirtualTree.miCutListTreePDFClick(Sender: TObject);
begin
     Process_CutList_Tree_PDF;
end;

procedure TfFileVirtualTree.miDocumentClick(Sender: TObject);
begin
     Process_txt_to_odt;
end;

procedure TfFileVirtualTree.Process_CutList;
begin
     slCutList.Sort;

     hvstCutList.Load_from_StringList( slCutList);
     hvstCutList.vst_expand_full;

     CutList:= 'Programs To Run:'+lCount.Caption+#13#10+'Total Machine Run Time:'+lMachineTime.Caption+#13#10+'Total Run Time Including Loading: '+lRunTime.Caption+#13#10#13#10+slCutList.Text;
     CutList_Tree:= 'Programs To Run:'+lCount.Caption+#13#10+'Total Machine Run Time:'+lMachineTime.Caption+#13#10+'Total Run Time Including Loading: '+lRunTime.Caption+#13#10#13#10+hvstCutList.render_as_text;
     CutList_List_Tree:= CutList+#13#10+#13#10+#13#10+CutList_Tree;

     m.Lines .Text:= CutList_List_Tree;
     m.Lines .SaveToFile('Result.txt');
end;

procedure TfFileVirtualTree.OpenDocument_Log(_FileName: String);
begin
     m.Lines.Insert(0,'File generated: '+_FileName);
     OpenDocument( _FileName);
end;

procedure TfFileVirtualTree.Process_PDF(_Text, _PDF_filename: String);
begin
     OpenDocument_Log( Text_to_PDF.Execute( _Text, _PDF_filename));
end;

procedure TfFileVirtualTree.Process_CutList_PDF;
begin
     Process_PDF( CutList, 'Result_List.pdf');
end;

procedure TfFileVirtualTree.Process_CutList_Tree_PDF;
begin
     Process_PDF( CutList_Tree, 'Result_Tree.pdf');
end;

procedure TfFileVirtualTree.Process_CutList_PDF_Tree;
begin
     Process_PDF( CutList_List_Tree, 'Result_List_Tree.pdf');
end;

procedure TfFileVirtualTree.Process_txt_to_odt;
begin
     //OpenDocument_Log( FileVirtualTree_odt( 'FileTree.odt', hvstCutList));
     OpenDocument_Log( FileVirtualTree_txt_to_odt( 'FileVirtualTree_txt_to_odt.odt', hvstCutList));
end;

procedure TfFileVirtualTree.miGetSelectionClick(Sender: TObject);
begin
     slCutList.Text:= hvst.Get_Selected;
     Process_CutList;
end;

procedure TfFileVirtualTree.miGetCheckedItemsClick(Sender: TObject);
begin
     slCutList.Text:= hvst.Get_Checked;
     Process_CutList;
end;

procedure TfFileVirtualTree.Process_GetChecked_or_Selected;
begin
     slCutList.Text:= hvst.Get_Checked_or_Selected( eLoadTime, lRunTime, lMachineTime, lCount);
     Process_CutList;
end;

procedure TfFileVirtualTree.miGetChecked_or_SelectedClick(Sender: TObject);
begin
     Process_GetChecked_or_Selected;
end;

procedure TfFileVirtualTree.bGetChecked_or_SelectedClick(Sender: TObject);
begin
     Process_GetChecked_or_Selected;
end;

procedure TfFileVirtualTree.vstChecking( Sender: TBaseVirtualTree;
                                         Node: PVirtualNode;
                                         var NewState: TCheckState;
                                         var Allowed: Boolean);
begin
     Process_GetChecked_or_Selected;
end;

procedure TfFileVirtualTree.vstClick(Sender: TObject);
begin
     Process_GetChecked_or_Selected;
end;

procedure TfFileVirtualTree.bReportClick(Sender: TObject);
begin
     Process_CutList_Tree_PDF;
end;

procedure TfFileVirtualTree.mifFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

