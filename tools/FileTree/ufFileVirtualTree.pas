unit ufFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
    uFileVirtualTree,
    ufFileTree,
    uFileVirtualTree_odt,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, IniPropStorage, IniFiles, VirtualTrees, LCLIntf;

type

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
   ips: TIniPropStorage;
   Label1: TLabel;
   lCompute_Aggregates: TLabel;
   m: TMemo;
   od: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pb: TProgressBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    vstResult: TVirtualStringTree;
    vst: TVirtualStringTree;
    procedure bfFileTreeClick(Sender: TObject);
    procedure bGetCheckedClick(Sender: TObject);
    procedure bGetSelectionClick(Sender: TObject);
    procedure bLoad_from_FileClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    slResult: TStringList;
    hvst: ThVirtualStringTree;
    hvstResult: ThVirtualStringTree;
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
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slResult  );
     FreeAndNil( hvst      );
     FreeAndNil( hvstResult);
end;


procedure TfFileVirtualTree.bLoad_from_FileClick(Sender: TObject);
begin
     hvst.Load_from_File( eFileName.Text);
end;

procedure TfFileVirtualTree.bODClick(Sender: TObject);
begin
     od.FileName:= eFileName.Text;
     if od.Execute
     then
         eFileName.Text:= od.FileName;
end;

procedure TfFileVirtualTree.bGetSelectionClick(Sender: TObject);
begin
     m.Lines.Text:= hvst.Get_Selected;
end;

procedure TfFileVirtualTree.bGetCheckedClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Checked;
     slResult.Sort;

     hvstResult.Load_from_StringList( slResult);
     hvstResult.vst_expand_full;
     m.Lines .Text:= slResult.Text+#13#10+hvstResult.render_as_text;
     m.Lines .SaveToFile('Result.txt');
     //OpenDocument( FileVirtualTree_odt( 'FileTree.odt', hvstResult));
     //OpenDocument( hvstResult.to_fpreport_pdf( 'Result.pdf'));

     {
     ExecuteProcess( 'txt2pdf.exe',['Result.txt']);
     OpenDocument( 'Result.pdf');
     }
     OpenDocument( hvstResult.fpreport_txt2pdf( 'Result.pdf'));
     OpenDocument( FileVirtualTree_txt_to_odt( 'FileVirtualTree_txt_to_odt.odt', hvstResult));

end;

procedure TfFileVirtualTree.bfFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

