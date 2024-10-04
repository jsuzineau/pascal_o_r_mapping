unit ufjpFiles;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean,
    uWinUtils,
    uuStrings,
    uVide,
    ujpFile,
    ufjpFile,
 Classes, SysUtils, VCL.Forms, VCL.Controls, VCL.Graphics, VCL.Dialogs, VCL.Menus;

type

 { TfjpFiles }

 TfjpFiles
 =
  class(TForm)
   miFenetres: TMenuItem;
   miOuvrir: TMenuItem;
   miNouveau: TMenuItem;
   miFichier: TMenuItem;
   mm: TMainMenu;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
   procedure miNouveauClick(Sender: TObject);
   procedure miOuvrirClick(Sender: TObject);
  private
   Racine_Listes: String;
   sl: TslfjpFile;
   procedure miFenetreClick(Sender: TObject);
   procedure TraiteFichiers(_S: TStrings);
   procedure Ouvre;overload;
   procedure Cree_fjpFile( _Directory: String);overload;
 public
   procedure DropFiles(Sender: TObject; const FileNames: array of string);
  //Recherche de 01_key
  private
    procedure Ouvre_FileFound( _NomFichier: String);
    procedure Ouvre( _Directory: String);overload;
  end;

function fjpFiles: TfjpFiles;

implementation

{$R *.dfm}

{ TfjpFiles }

var
   FfjpFiles: TfjpFiles= nil;

function fjpFiles: TfjpFiles;
begin
     Clean_Get( Result, FfjpFiles, TfjpFiles);
end;

procedure TfjpFiles.FormCreate(Sender: TObject);
begin
     Racine_Listes:= ExtractFilePath( Application.ExeName)+'Generateur_de_code'+PathDelim+'01_Listes';
     sl:= TslfjpFile.Create( ClassName+'.sl');
end;

procedure TfjpFiles.FormDestroy(Sender: TObject);
var
   I: TIterateur_fjpFile;
   fjpFile: TfjpFile;
begin
     I:= sl.Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( fjpFile) then continue;
          FreeAndNil( fjpFile);
          end;
     finally
            FreeAndNil( I);
            end;
     FreeAndNil( sl);
end;

procedure TfjpFiles.Cree_fjpFile( _Directory: String);
var
   sCle: String;
   f: TfjpFile;
   procedure Cree;
   var
      mi: TMenuItem;
   begin
        f:= TfjpFile.Create( sCle, _Directory);

        sl.AddObject( sCle, f);

        mi:= TMenuItem.Create( mm);
        miFenetres.Add( mi);
        mi.Caption:= sCle;
        mi.OnClick:= miFenetreClick;
   end;
begin
     sCle:= _Directory;
     if 1 = Pos( Racine_Listes, sCle)
     then
         Delete( sCle, 1, Length(Racine_Listes));

     f:= fjpFile_from_sl_sCle( sl, sCle);
     if nil = f then Cree;

     if nil = f then exit;
     f.Show;
end;

procedure TfjpFiles.Ouvre_FileFound( _NomFichier: String);
begin
     Cree_fjpFile( ExcludeTrailingPathDelimiter(ExtractFilePath( _NomFichier)));
end;

procedure TfjpFiles.Ouvre( _Directory: String);
begin
     ujpFile_EnumFiles( _Directory, Ouvre_FileFound, s_key_mask);
end;

procedure TfjpFiles.miFenetreClick(Sender: TObject);
var
   mi: TMenuItem;
   sCle: String;
   f: TfjpFile;

begin
     if not (Sender is TMenuItem) then exit;

     mi:= Sender as TMenuItem;
     sCle:= mi.Caption;
     f:= fjpFile_from_sl_sCle( sl, sCle);
     if nil = f then exit;

     f.Show;
end;

procedure TfjpFiles.TraiteFichiers(_S: TStrings);
var
   Directory: String;
begin
     for Directory in _S
     do
       Ouvre( Directory);
end;

procedure TfjpFiles.Ouvre;
var
   NomRepertoire: String;
begin
     NomRepertoire:= Racine_Listes;
     if not SelectionnneRepertoire( Handle, Caption, NomRepertoire) then exit;

     Ouvre( NomRepertoire);
end;

procedure TfjpFiles.FormDropFiles( Sender: TObject; const FileNames: array of string);
begin
     DropFiles( Sender, FileNames);
end;

procedure TfjpFiles.DropFiles(Sender: TObject; const FileNames: array of string);
var
   NomFichier: String;
   sl: TStringList;
begin
     sl:= TStringList.Create;
     try
        for NomFichier in FileNames
        do
          sl.Add( NomFichier);

        TraiteFichiers( sl);
     finally
            FreeAndNil( sl);
            end;
end;

procedure TfjpFiles.miNouveauClick(Sender: TObject);
var
   Directory: String;
   Name: String;
   Extension: String;
   nfKey       : String;
   nfBegin     : String;
   nfElement   : String;
   nfSeparateur: String;
   nfEnd       : String;
begin
     Directory:= Racine_Listes;
     if not SelectionnneRepertoire( Handle, Caption, Directory) then exit;

     Extension:= InputBox( 'Extension des fichiers template', 'Saisissez l''extension', 'pas');
     Name:= ExtractFileName( Directory);
     nfKey       := IncludeTrailingPathDelimiter( Directory)+Name+s_key_       +Extension;
     nfBegin     := IncludeTrailingPathDelimiter( Directory)+Name+s_begin_     +Extension;
     nfElement   := IncludeTrailingPathDelimiter( Directory)+Name+s_element_   +Extension;
     nfSeparateur:= IncludeTrailingPathDelimiter( Directory)+Name+s_separateur_+Extension;
     nfEnd       := IncludeTrailingPathDelimiter( Directory)+Name+s_end_       +Extension;
     String_to_File( nfKey       , Name);
     String_to_File( nfBegin     , ' ');
     String_to_File( nfElement   , ' ');
     String_to_File( nfSeparateur, ' ');
     String_to_File( nfEnd       , ' ');

     Ouvre( Directory);
end;

procedure TfjpFiles.miOuvrirClick(Sender: TObject);
begin
     Ouvre;
end;

end.

