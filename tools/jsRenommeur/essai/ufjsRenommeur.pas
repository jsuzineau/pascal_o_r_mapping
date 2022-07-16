unit ufjsRenommeur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,ShellAPI,
  StdCtrls;

type
  TfjsRenommeur = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    ePrefixe: TEdit;
    eNouveau: TEdit;
    cbInserer: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure WndProc(var Message: TMessage); override;
  public
    procedure TraiteFichiers(S: TStrings);
    { Déclarations publiques }
  end;

var
  fjsRenommeur: TfjsRenommeur;

implementation

{$R *.DFM}

procedure TfjsRenommeur.TraiteFichiers(S: TStrings);
var
   I: Integer;
   Prefixe: String;
   LongueurPrefixe: Integer;
   Index: Integer;
   Nouveau: String;
   LongueurNouveau: Integer;
   Inserer: Boolean;
   Repertoire,AncienNom, NouveauNom: String;
begin
     Prefixe:= ePrefixe.Text;
     LongueurPrefixe:= Length( Prefixe);
     Nouveau:= eNouveau.Text;
     LongueurNouveau:= Length( Nouveau);
     Inserer:= cbInserer.Checked;
     for I:= 0 to S.Count-1
     do
       begin
       AncienNom:= S.Strings[I];
       Repertoire:= ExtractFilePath( AncienNom);
       AncienNom:= ExtractFileName( AncienNom);

       if Pos( Prefixe, ExtractFileName( AncienNom)) > 0
       then
           begin
           NouveauNom:= AncienNom;
           Index:= Pos( Prefixe, AncienNom)+LongueurPrefixe;
           if not Inserer
           then
               Delete( NouveauNom, Index, LongueurNouveau);
           Insert( Nouveau, NouveauNom, Index);
           if MessageBox( Handle,
                       PChar(Format( 'Renommer %s en %s ?', [AncienNom, NouveauNom])),
                       'jsRenommeur',
                       MB_YESNO
                       ) = idYes
           then
               if not RenameFile( Repertoire+AncienNom, Repertoire+NouveauNom)
               then
                   ShowMessage(Format( 'Impossible de renommer %s en %s ?', [AncienNom, NouveauNom]));
           end;
       end;
end;

procedure TfjsRenommeur.Button1Click(Sender: TObject);
begin
     if OpenDialog1.Execute
     then
         TraiteFichiers( OpenDialog1.Files);
end;

procedure TfjsRenommeur.FormCreate(Sender: TObject);
begin
     DragAcceptFiles( Handle, True);
end;

procedure TfjsRenommeur.WndProc(var Message: TMessage);
var
   hDrop: THandle;
   Iterateur: Cardinal;
   NomFichier: PChar;
   TailleNomFichier: Cardinal;
   NombreFichiers: Cardinal;
   S: TStringList;
begin
     case Message.Msg
     of
       WM_DROPFILES:
{
UINT DragQueryFile(


    HDROP hDrop,	// handle to structure for dropped files
    UINT iFile,	// index of file to query
    LPTSTR lpszFile,	// buffer for returned filename
    UINT cch 	// size of buffer for filename
   );
Parameters
hDrop
Identifies the structure containing the filenames of the dropped files.
iFile
Specifies the index of the file to query. If the value of the iFile parameter is 0xFFFFFFFF, DragQueryFile returns a count of the files dropped. If the value of the iFile parameter is between zero and the total number of files dropped, DragQueryFile copies the filename with the corresponding value to the buffer pointed to by the lpszFile parameter.
lpszFile
Points to a buffer to receive the filename of a dropped file when the function returns. This filename is a null-terminated string. If this parameter is NULL, DragQueryFile returns the required size, in characters, of the buffer.
cch
Specifies the size, in characters, of the lpszFile buffer.
Return Value
When the function copies a filename to the buffer, the return value is a count of the characters copied, not including the terminating null character.
If the index value is 0xFFFFFFFF, the return value is a count of the dropped files.
If the index value is between zero and the total number of dropped files and the lpszFile buffer address is NULL, the return value is the required size, in characters, of the buffer, not including the terminating null character.
}
         begin
         hDrop:= Message.wParam;
         NombreFichiers:= DragQueryFile(hDrop,$FFFFFFFF,NIL, 0);
         S:= TStringList.Create;
         for Iterateur:= 0 to NombreFichiers-1
         do
           begin
           TailleNomFichier:= DragQueryFile(hDrop,Iterateur,NIL, 0)+1;
           NomFichier:= StrAlloc(TailleNomFichier);
           DragQueryFile(hDrop,Iterateur,NomFichier, TailleNomFichier);
           S.Add( NomFichier);
           StrDispose(NomFichier);
           end;
         DragFinish( hDrop);

         TraiteFichiers( S);
         S.Free;
         Message.Result:= 0;
         end;
       end;
     inherited WndProc(Message);
end;

end.
