unit uffpCalc;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, IniPropStorage, SynEdit,
 ActnList, ExtCtrls, StdCtrls, process;

type

 { TffpCalc }

 TffpCalc = class(TForm)
  aCalcul: TAction;
  aSave: TAction;
  al: TActionList;
  bEditorFile: TButton;
  bSCalc_Path: TButton;
  eEditorFile: TEdit;
  eSCalc_Path: TEdit;
  ips: TIniPropStorage;
  Label1: TLabel;
  Label2: TLabel;
  Memo1: TMemo;
  Memo2: TMemo;
  odEditorFile: TOpenDialog;
  odSCalc_Path: TOpenDialog;
  Panel1: TPanel;
  se: TSynEdit;
  procedure aCalculExecute(Sender: TObject);
  procedure aSaveExecute(Sender: TObject);
  procedure bEditorFileClick(Sender: TObject);
  procedure bSCalc_PathClick(Sender: TObject);
  procedure eEditorFileChange(Sender: TObject);
  procedure eSCalc_PathChange(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
   const key_scalc_path= 'scalc_path';
 private
   scalc_path: String;
 public

 end;

var
 ffpCalc: TffpCalc;

implementation

{$R *.lfm}

{ TffpCalc }

procedure TffpCalc.FormCreate(Sender: TObject);
var
   Default_eSCalc_Path_Text: String;
   Default_eEditorFile_Text: String;
begin
     Default_eSCalc_Path_Text:= eSCalc_Path.Text;
     Default_eEditorFile_Text:= eEditorFile.Text;
     SessionProperties:= 'eSCalc_Path.Text;eEditorFile.Text';
     ips.Restore;
     if Default_eSCalc_Path_Text = eSCalc_Path.Text then eSCalc_Path.Text:= '/home/jean/install/scalc';
     if Default_eEditorFile_Text = eEditorFile.Text then eEditorFile.Text:= '/home/jean/Documents/mentor_pincemin/ht/doc/calc.txt';
end;

procedure TffpCalc.FormDestroy(Sender: TObject);
begin
     ips.Save;
end;

procedure TffpCalc.bSCalc_PathClick(Sender: TObject);
begin
     odSCalc_Path.FileName:= eSCalc_Path.Text;
     if odSCalc_Path.Execute
     then
         eSCalc_Path.Text:= odSCalc_Path.FileName;
end;

procedure TffpCalc.eEditorFileChange(Sender: TObject);
var
   sNew: String;
begin
     sNew:= eEditorFile.Text;
     if '' = sNew then exit;

     se.Lines.LoadFromFile( sNew);
end;

procedure TffpCalc.eSCalc_PathChange(Sender: TObject);
var
   sNew: String;
begin
     sNew:= eSCalc_Path.Text;
     if '' = sNew then exit;

     scalc_path:= sNew;
end;

procedure TffpCalc.bEditorFileClick(Sender: TObject);
begin
     odEditorFile.FileName:= eEditorFile.Text;
     if odEditorFile.Execute
     then
         eEditorFile.Text:= odEditorFile.FileName;
end;

procedure TffpCalc.aSaveExecute(Sender: TObject);
begin
     se.Lines.SaveToFile( eEditorFile.Text);
end;

procedure TffpCalc.aCalculExecute(Sender: TObject);
const
  BUF_SIZE = 2048; // Buffer size for reading the output in chunks
var
   Buffer: array[1..BUF_SIZE] of Byte;
var
   Entree_Filename: String;
   sEntree: String;
   slEntree: TStringList;
   p: TProcess;
   msSortie: TMemoryStream;
   BytesRead: LongInt;
   slSortie: TStringList;
   sSortie: String;
   function Delete_trailing_Line_ending( _s: String): String;
   var
      lFin: Integer;
      iFin: Integer;
      Fin: String;
   begin
        Result:= _s;
        lFin:= Length(LineEnding);
        iFin:= 1+Length(Result)-lFin;
        Fin:= Copy(Result, iFin, lFin);
        if LineEnding = Fin
        then
            Delete( Result, iFin, lFin);
   end;
begin
     sEntree:= se.SelText;
     if '' = sEntree
     then
         begin
         se.SelectLine;
         sEntree:= se.SelText;
         end;

     Entree_Filename:= ChangeFileExt(Application.ExeName, '_Entree.txt');
     slEntree:= TStringList.Create;
     try
        slEntree.Add( sEntree);
        slEntree.SaveToFile( Entree_Filename);
     finally
            FreeAndNil( slEntree);
            end;

     p:= TProcess.Create(nil);
     try
        p.Executable:= scalc_path;
        //p.Parameters.Add('-i');
        p.Parameters.Add(Entree_Filename);
        p.Options := [poUsePipes];
        p.Execute;
        //p.Input.WriteAnsiString( slEntree);
        msSortie:= TMemoryStream.Create;
        repeat
              BytesRead:= p.Output.Read( Buffer, BUF_SIZE);
              msSortie.Write( Buffer, BytesRead);
        until 0 = BytesRead;
     finally
            FreeAndNil( p);
            end;

     slSortie:= TStringList.Create;
     try
        msSortie.Position:= 0;
        slSortie.LoadFromStream( msSortie);
        sSortie:= Delete_trailing_Line_ending( slSortie.Text);
     finally
            FreeAndNil( slSortie);
            end;
     se.SelText:= sSortie;
end;

end.


