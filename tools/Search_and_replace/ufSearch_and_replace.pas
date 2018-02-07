unit ufSearch_and_replace;

{$mode delphi}

interface

uses
    uuStrings,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,LazUTF8;

type

 { TfSearch_and_replace }

 TfSearch_and_replace
 =
  class(TForm)
   m: TMemo;
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
  end;

var
 fSearch_and_replace: TfSearch_and_replace;

implementation

{$R *.lfm}

{ TfSearch_and_replace }

procedure TfSearch_and_replace.FormCreate(Sender: TObject);
begin
     Remplacements_Charge;
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
   I: Integer;
   FileName_New: String;
   procedure Traite_Remplacement( _I: Integer);
   var
      sSearch, sReplace: String;
   begin
        sSearch := m.Lines.Names         [ I];
        sReplace:= m.Lines.ValueFromIndex[ I];
        S:= UTF8StringReplace( S, sSearch, sReplace, [rfReplaceAll]);
   end;
begin
     S:= String_from_File( _FileName);

     for I:= 0 to m.Lines.Count-1
     do
       Traite_Remplacement( I);

     FileName_New
     :=
       ChangeFileExt( _FileName, '_new'+ExtractFileExt( _FileName));
     String_to_File( FileName_New, S);
end;

end.

