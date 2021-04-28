unit ufFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
    uFileVirtualTree,
    ufFileTree,
    uFileVirtualTree_odt, uText_to_PDF,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, IniPropStorage, IniFiles, VirtualTrees, LCLIntf;

type

 { TfFileVirtualTree }

 TfFileVirtualTree
 =
  class(TForm)
   bGetChecked: TButton;
   bGetChecked_or_Selected: TButton;
   bGetSelection: TButton;
   bfFileTree: TButton;
   bLoad_from_File: TButton;
   bOD: TButton;
   bTest_Duration_from_DateTime: TButton;
   eFileName: TEdit;
   eLoadTime: TEdit;
   eRunTime: TEdit;
   eMachineTime: TEdit;
   ips: TIniPropStorage;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   lCompute_Aggregates: TLabel;
   m: TMemo;
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
    procedure bfFileTreeClick(Sender: TObject);
    procedure bGetCheckedClick(Sender: TObject);
    procedure bGetChecked_or_SelectedClick(Sender: TObject);
    procedure bGetSelectionClick(Sender: TObject);
    procedure bLoad_from_FileClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure bTest_Duration_from_DateTimeClick(Sender: TObject);
    procedure eLoadTimeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ipsRestoreProperties(Sender: TObject);
    procedure mChange(Sender: TObject);
    procedure tFirstTimer(Sender: TObject);
  //Load_from_File
  private
    procedure Load_from_File;
  //Extracting Result
  private
    slResult: TStringList;
    hvst: ThVirtualStringTree;
    hvstResult: ThVirtualStringTree;
    procedure Process_Result;
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
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slResult  );
     FreeAndNil( hvst      );
     FreeAndNil( hvstResult);
end;

procedure TfFileVirtualTree.ipsRestoreProperties(Sender: TObject);
begin
   uFileVirtualTree.e_Load_Time:=  eLoadTime.Text;
end;

procedure TfFileVirtualTree.mChange(Sender: TObject);
begin
     eMachineTime.Text:= uFileVirtualTree.e_Machine_Time;
     eRunTime.Text:= uFileVirtualTree.e_Run_Time;
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

procedure TfFileVirtualTree.bLoad_from_FileClick(Sender: TObject);
begin
     Load_from_File;
end;

procedure TfFileVirtualTree.bODClick(Sender: TObject);
begin
     od.FileName:= eFileName.Text;
     if od.Execute
     then
         Begin
            eFileName.Text:= od.FileName;
            Load_from_File;
         end;
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

procedure TfFileVirtualTree.eLoadTimeChange(Sender: TObject);
begin
   If eLoadTime.Text <> '12345' Then
  uFileVirtualTree.e_Load_Time:=  eLoadTime.Text;
end;

procedure TfFileVirtualTree.Process_Result;
var
   Result_List, Result_Tree, Result_List_Tree: String;
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
     slResult.Sort;

     hvstResult.Load_from_StringList( slResult);
     hvstResult.vst_expand_full;

     Result_List:= slResult.Text;
     Result_Tree:= hvstResult.render_as_text;
     Result_List_Tree:= Result_List+#13#10+Result_Tree;

     m.Lines .Text:= Result_List_Tree;
     m.Lines .SaveToFile('Result.txt');
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

procedure TfFileVirtualTree.bGetSelectionClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Selected;
     Process_Result;
end;

procedure TfFileVirtualTree.bGetCheckedClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Checked;
     Process_Result;
end;

procedure TfFileVirtualTree.bGetChecked_or_SelectedClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Checked_or_Selected;
     Process_Result;
end;

procedure TfFileVirtualTree.bfFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

