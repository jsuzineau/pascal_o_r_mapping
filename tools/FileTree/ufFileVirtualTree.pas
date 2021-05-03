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
   bOD: TButton;
   bReport: TButton;
   eFileName: TEdit;
   eLoadTime: TEdit;
   ips: TIniPropStorage;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   lCount: TLabel;
   lMachineTime: TLabel;
   lMachineTime1: TLabel;
   lRunTime: TLabel;
   lRunTime1: TLabel;
   mCutList: TMemo;
   miUnitTesting: TMenuItem;
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
    procedure bODClick(Sender: TObject);
    procedure bReportClick(Sender: TObject);
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
    procedure miUnitTestingClick(Sender: TObject);
    procedure tReadyTimer(Sender: TObject);
    procedure vstChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstClick(Sender: TObject);
  //Ready (waiting for loading completed)
  private
    Ready: Boolean;
  //Load_from_File
  private
    procedure Load_from_File;
    procedure Select_File;
  //Unit Testing
  private
    procedure UnitTesting;
  //Extracting CutList
  private
    slCutList: TStringList;
    hvst: ThVirtualStringTree;
    hvstCutList: ThVirtualStringTree;
    procedure Process_CutList;
    procedure Process_GetChecked_or_Selected;
  //CutList Files
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

     hvst       := ThVirtualStringTree.Create( True , vst       , pb);
     hvstCutList:= ThVirtualStringTree.Create( False, vstCutList, pb);

     Ready:= False;
     tReady.Enabled:= True;

     lRunTime    .Caption:= '';//lRunTime.Transparent = True so Caption:= '    ' does nothing more
     lMachineTime.Caption:= '';
     lCount      .Caption:= '';
     mCutList.text:='';
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

procedure TfFileVirtualTree.vstChecked( Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
     Process_GetChecked_or_Selected;
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
     Load_from_File;
end;

procedure TfFileVirtualTree.miUnitTestingClick(Sender: TObject);
begin
     UnitTesting;
end;

procedure TfFileVirtualTree.UnitTesting;
     procedure Test( _Day, _Hour, _Minute, _Second: Word);
     var
        dt: TDateTime;
        duration: String;
     begin
          dt:= _Day+EncodeTime( _Hour, _Minute, _Second, 0);
          duration:= Duration_from_DateTime( dt);
          mCutList.Lines.Add( Format( '%.2d %.2d:%.2d:%.2d => %s',
                               [_Day, _Hour, _Minute, _Second, duration]));
     end;
     procedure MakeTestFile_TIniFile; //Slow
     var
        ini: TIniFile;
        procedure Recursive( _Level: Integer; _Root: String);
        var
           I: Integer;
        begin
             if _Level < 3
             then
                 for I:= 0 to 9
                 do
                   Recursive( _Level+1, _Root+'Directory_'+IntToStr(I)+'\')
             else
               for I:= 0 to 9
               do
                 ini.WriteString( 'Files', _Root+'File_'+IntToStr(I), '10');
        end;
     begin
          ini:= TIniFile.Create('TestFile.ini');
          try
             Recursive( 0, 'C:\');
          finally
                 FreeAndNil( ini);
                 end;
     end;
     procedure MakeTestFile_TFileStream;
     var
        fs: TFileStream;
        procedure fsWriteLn( _S: String);
        begin
             _S:= _S+#13#10;
             fs.Write( _S[1], Length( _S));
        end;
        procedure Recursive( _Level: Integer; _Root: String);
        var
           I: Integer;
        begin
             if _Level < 3
             then
                 for I:= 0 to 9
                 do
                   Recursive( _Level+1, _Root+'Directory_'+IntToStr(I)+'\')
             else
               for I:= 0 to 9
               do
                 fsWriteLn( _Root+'File_'+IntToStr(I)+'=10');
        end;
     begin
          fs:= TFileStream.Create('TestFile.ini', fmCreate);
          try
             fsWriteLn( '[Files]');
             Recursive( 0, 'C:\');
          finally
                 FreeAndNil( fs);
                 end;
     end;
     procedure MakeTestFile_TStringList;
     var
        sl: TStringList;
        procedure Recursive( _Level: Integer; _Root: String);
        var
           I: Integer;
        begin
             if _Level < 3
             then
                 for I:= 0 to 9
                 do
                   Recursive( _Level+1, _Root+'Directory_'+IntToStr(I)+'\')
             else
               for I:= 0 to 9
               do
                 sl.Add( _Root+'File_'+IntToStr(I)+'=10');
        end;
     begin
          sl:= TStringList.Create;
          try
             sl.Add( '[Files]');
             Recursive( 0, 'C:\');
          finally
                 sl.SaveToFile( 'TestFile.ini');
                 FreeAndNil( sl);
                 end;
     end;
begin
     mCutList.Clear;
     Test( 0, 0, 0, 0);
     Test( 0, 0, 0, 1);
     Test( 0, 0, 0,10);
     Test( 0, 0, 1,10);
     Test( 0, 0,10,10);
     Test( 0, 1,10,10);
     Test( 0,10,10,10);
     Test( 1,10,10,10);
     Test(10,10,10,10);
     MakeTestFile_TStringList;
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

     mCutList.Lines .Text:= CutList_List_Tree;
     mCutList.Lines .SaveToFile('Result.txt');
end;

procedure TfFileVirtualTree.OpenDocument_Log(_FileName: String);
begin
     mCutList.Lines.Insert(0,'File generated: '+_FileName);
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

