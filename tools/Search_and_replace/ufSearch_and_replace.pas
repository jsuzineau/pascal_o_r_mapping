unit ufSearch_and_replace;

{$mode delphi}

interface

uses
    uuStrings, ufXML_Editor, Classes, SysUtils, FileUtil, Forms, Controls,
    Graphics, Dialogs, StdCtrls, ExtCtrls, LazUTF8;

type

 { TfSearch_and_replace }

 TfSearch_and_replace
 =
  class(TForm)
   bTest: TButton;
   e: TEdit;
   l: TLabel;
   m: TMemo;
   p: TPanel;
   procedure bTestClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
   procedure mDragOver(Sender, Source: TObject; X, Y: Integer;
    State: TDragState; var Accept: Boolean);
  private
    function Remplacements_NomFichier: String;
    procedure Remplacements_Charge;
    procedure Remplacements_Sauve;
    procedure Traite( _FileName: String);
    procedure Traite_Chaine( var _S: String);
    function HexString( _S: String): String;
  private
    BOM: String;
    fAvant, fApres: TfXML_Editor;
  end;

var
 fSearch_and_replace: TfSearch_and_replace;

implementation

{$R *.lfm}

{ TfSearch_and_replace }

procedure TfSearch_and_replace.FormCreate(Sender: TObject);
begin
     Remplacements_Charge;
     Assure_fXML_Editor( fAvant, 'fAvant');
     Assure_fXML_Editor( fApres, 'fApres');
     BOM:= #$EF+#$BB+#$BF;
end;

procedure TfSearch_and_replace.bTestClick(Sender: TObject);
var
   S: String;
begin
     S:= BOM+e.Text;
     fAvant.Affiche( BOM+S+' Hex:'+HexString( S));
     Traite_Chaine( S);
     fApres.Affiche( BOM+S+' Hex:'+HexString( S));
     l.Caption:= S;
     fAvant.Show;
     fApres.Show;
end;

procedure TfSearch_and_replace.FormDestroy(Sender: TObject);
begin
     Remplacements_Sauve;
end;

procedure TfSearch_and_replace.FormDropFiles( Sender: TObject; const FileNames: array of String);
var
   I: Integer;
begin
     for I:= Low( FileNames) to High( FileNames)
     do
       Traite( FileNames[I]);
end;

procedure TfSearch_and_replace.mDragOver( Sender, Source: TObject;
                                          X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
     Accept:= False;
end;

function TfSearch_and_replace.Remplacements_NomFichier: String;
begin
     Result
     :=
        IncludeTrailingPathDelimiter(ExtractFilePath( Application.ExeName))
       +'etc'+PathDelim
       +'Remplacements.ini';
end;

procedure TfSearch_and_replace.Remplacements_Charge;
var
   nf: String;
begin
     nf:= Remplacements_NomFichier;
     if not FileExists( nf) then exit;

     m.Lines.LoadFromFile( nf);
end;

procedure TfSearch_and_replace.Remplacements_Sauve;
var
   nf: String;
begin
     nf:= Remplacements_NomFichier;
     ForceDirectories( ExtractFilePath(nf));

     m.Lines.SaveToFile( nf);
end;

procedure TfSearch_and_replace.Traite(_FileName: String);
var
   S: String;
   FileName_New: String;
begin
     S:= String_from_File( _FileName);

     Traite_Chaine( S);

     FileName_New
     :=
       ChangeFileExt( _FileName, '_new'+ExtractFileExt( _FileName));
     String_to_File( FileName_New, S);
end;

procedure TfSearch_and_replace.Traite_Chaine( var _S: String);
var
   I: Integer;

   procedure Traite_Remplacement( _I: Integer);
   var
      sSearch, sReplace: String;
   begin
        sSearch := m.Lines.Names         [ I];
        sReplace:= m.Lines.ValueFromIndex[ I];
        //S:= UTF8StringReplace( S, sSearch, sReplace, [rfReplaceAll]);
        _S:= StringReplace( _S, sSearch, sReplace, [rfReplaceAll]);
   end;
begin
     //SynEdit gère mal en UTF8 les caractères accentués par un deuxième caractère.
     //il accentue le caractère d'aprés au lieu d'accentuer le caractère d'avant
     //"VREME E DA V̌ARVIM" devient "VREME E DA VǍRVIM" dans l'éditeur de source de lazarus et synedit
     //_S:= StringReplace( _S, 'õ', #$CC#$8C'A', [rfReplaceAll]);
     for I:= 0 to m.Lines.Count-1
     do
       Traite_Remplacement( I);
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

