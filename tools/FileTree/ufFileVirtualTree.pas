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
   lMachineTime: TLabel;
   lMachineTime1: TLabel;
   lCompute_Aggregates: TLabel;
   lRunTime: TLabel;
   lRunTime1: TLabel;
   m: TMemo;
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
    tFirst: TTimer;
    vstResult: TVirtualStringTree;
    vst: TVirtualStringTree;
    procedure bGetChecked_or_SelectedClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure bReportClick(Sender: TObject);
    procedure bTest_Duration_from_DateTimeClick(Sender: TObject);
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
    procedure tFirstTimer(Sender: TObject);
    procedure vstChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
     var NewState: TCheckState; var Allowed: Boolean);
    procedure vstClick(Sender: TObject);
  //Load_from_File
  private
    procedure Load_from_File;
    procedure Select_File;
  //Extracting Result
  private
    slResult: TStringList;
    hvst: ThVirtualStringTree;
    hvstResult: ThVirtualStringTree;
    procedure Process_Result;
    procedure Process_GetChecked_or_Selected;
  //Result Files
  private
    Result_List, Result_Tree, Result_List_Tree: String;
    procedure Process_Result_Files;
  end;

var
 fFileVirtualTree: TfFileVirtualTree;

implementation

{$R *.lfm}

{ TfFileVirtualTree }

procedure TfFileVirtualTree.FormCreate(Sender: TObject);
begin
     slResult  := TStringList.Create;

     hvst      := ThVirtualStringTree.Create( True , vst      , pb, lCompute_Aggregates);
     hvstResult:= ThVirtualStringTree.Create( False, vstResult, pb, lCompute_Aggregates);
     tFirst.Enabled:= True;
     lRunTime    .Caption:= '';
     lMachineTime.Caption:= '';
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slResult  );
     FreeAndNil( hvst      );
     FreeAndNil( hvstResult);
end;

procedure TfFileVirtualTree.ipsRestoreProperties(Sender: TObject);
begin
     vst.Header.Columns[0].Width:= ips.ReadInteger( 'vst.Header.Columns[0].Width', 200);
     vst.Header.Columns[1].Width:= ips.ReadInteger( 'vst.Header.Columns[1].Width',  50);
     vstResult.Header.Columns[0].Width:= ips.ReadInteger( 'vstResult.Header.Columns[0].Width', 200);
     vstResult.Header.Columns[1].Width:= ips.ReadInteger( 'vstResult.Header.Columns[1].Width',  50);
end;

procedure TfFileVirtualTree.ipsSaveProperties(Sender: TObject);
begin
     ips.WriteInteger( 'vst.Header.Columns[0].Width', vst.Header.Columns[0].Width);
     ips.WriteInteger( 'vst.Header.Columns[1].Width', vst.Header.Columns[1].Width);
     ips.WriteInteger( 'vstResult.Header.Columns[0].Width', vstResult.Header.Columns[0].Width);
     ips.WriteInteger( 'vstResult.Header.Columns[1].Width', vstResult.Header.Columns[1].Width);
end;

procedure TfFileVirtualTree.miLoadFrom_FileClick(Sender: TObject);
begin
     Load_from_File;
end;

procedure TfFileVirtualTree.tFirstTimer(Sender: TObject);
begin
     tFirst.Enabled:= False;
     Load_from_File;
end;

procedure TfFileVirtualTree.Load_from_File;
begin
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
     If Not(tFirst.Enabled) Then
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

procedure TfFileVirtualTree.Process_Result;
begin
     slResult.Sort;

     hvstResult.Load_from_StringList( slResult);
     hvstResult.vst_expand_full;

     Result_List:= slResult.Text;
     Result_Tree:= hvstResult.render_as_text;
     Result_List_Tree:= Result_List+#13#10+Result_Tree;

     m.Lines .Text:= Result_List_Tree;
     m.Lines .SaveToFile('Result.txt');
end;

procedure TfFileVirtualTree.Process_Result_Files;
     procedure OpenDocument_Log( _FileName: String);
     begin
          m.Lines.Insert(0,'File generated: '+_FileName);
          OpenDocument( _FileName);
     end;
     procedure Process_PDF( _Text, _PDF_filename: String);
     begin
          OpenDocument_Log( Text_to_PDF.Execute( _Text, _PDF_filename));
     end;
begin
     //OpenDocument_Log( FileVirtualTree_odt( 'FileTree.odt', hvstResult));

     {
     ExecuteProcess( 'txt2pdf.exe',['Result.txt']);
     OpenDocument_Log( 'Result.pdf');
     }
     Process_PDF( Result_List     , 'Result_List.pdf'     );
     Process_PDF( Result_Tree     , 'Result_Tree.pdf'     );
     Process_PDF( Result_List_Tree, 'Result_List_Tree.pdf');
     OpenDocument_Log( FileVirtualTree_txt_to_odt( 'FileVirtualTree_txt_to_odt.odt', hvstResult));
end;

procedure TfFileVirtualTree.miGetSelectionClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Selected;
     Process_Result;
end;

procedure TfFileVirtualTree.miGetCheckedItemsClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Checked;
     Process_Result;
end;

procedure TfFileVirtualTree.Process_GetChecked_or_Selected;
begin
     slResult.Text:= hvst.Get_Checked_or_Selected( eLoadTime, lRunTime, lMachineTime);
     Process_Result;
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
     Process_Result_Files;
end;

procedure TfFileVirtualTree.mifFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

