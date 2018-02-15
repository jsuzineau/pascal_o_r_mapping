unit ufSearch_and_replace;

{$mode delphi}

interface

uses
    uuStrings, ufXML_Editor, ufRemplacements, Classes, SysUtils, FileUtil,
    Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

 { TfSearch_and_replace }

 TfSearch_and_replace
 =
  class(TForm)
   bTest: TButton;
   bParametres: TButton;
   e: TEdit;
   l: TLabel;
   m: TMemo;
   p: TPanel;
   procedure bParametresClick(Sender: TObject);
   procedure bTestClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  private
    procedure Traite( _FileName: String);
    function HexString( _S: String): String;
  private
    BOM: String;
    fAvant, fApres: TfXML_Editor;
    fRemplacements: TfRemplacements;
  end;

var
 fSearch_and_replace: TfSearch_and_replace;

implementation

{$R *.lfm}

{ TfSearch_and_replace }

procedure TfSearch_and_replace.FormCreate(Sender: TObject);
begin
     Assure_fXML_Editor( fAvant, 'fAvant');
     Assure_fXML_Editor( fApres, 'fApres');
     Assure_fRemplacements( fRemplacements, 'fRemplacements');

     fRemplacements.Charge;

     BOM:= #$EF+#$BB+#$BF;
     m.Lines.Text:= '';
     e.Text:= '';
     l.Caption:= '';
end;

procedure TfSearch_and_replace.FormDestroy(Sender: TObject);
begin
     fRemplacements.Sauve;
end;

procedure TfSearch_and_replace.bTestClick(Sender: TObject);
var
   S: String;
begin
     S:= BOM+e.Text;
     fAvant.Affiche( BOM+S+' Hex:'+HexString( S));
     fRemplacements.Traite_Chaine( S);
     fApres.Affiche( BOM+S+' Hex:'+HexString( S));
     l.Caption:= S;
     fAvant.Show;
     fApres.Show;
end;

procedure TfSearch_and_replace.bParametresClick(Sender: TObject);
begin
     fRemplacements.Show;
end;

procedure TfSearch_and_replace.FormDropFiles( Sender: TObject; const FileNames: array of String);
var
   I: Integer;
begin
     for I:= Low( FileNames) to High( FileNames)
     do
       Traite( FileNames[I]);
end;

procedure TfSearch_and_replace.Traite(_FileName: String);
var
   S: String;
   FileName_New: String;
begin
     S:= String_from_File( _FileName);

     fRemplacements.Traite_Chaine( S);

     FileName_New
     :=
       ChangeFileExt( _FileName, '_new'+ExtractFileExt( _FileName));
     String_to_File( FileName_New, S);
     m.Lines.Add( '');
     m.Lines.Add( 'Traitement terminé de '+_FileName);
     m.Lines.Add( '');
end;

function TfSearch_and_replace.HexString( _S: String): String;
var
   I: Integer;
   C: Char;
begin
     Result:= '';
     for I:=1 to length(_S)
     do
       begin
       C:= _S[I];
       if C in ['a'..'z','A'..'Z','0'..'9',' ']
       then
           Result:= Result+ C
       else
           Result:=Result+Format( '(%.2x)', [Ord(C)]);
       end;
end;

end.

