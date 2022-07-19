unit ufjsRenommeur;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TypeFonction= (f_Remplacer, f_Inserer_Apres, f_Ecraser_Apres);

  { TfjsRenommeur }

  TfjsRenommeur = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    ePrefixe: TEdit;
    eNouveau: TEdit;
    rbFonction: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure rbFonctionClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Fonction: TypeFonction;
    procedure TraiteFichiers(S: TStrings);
    procedure Fonction_from_rbFonction;
  end;

var
  fjsRenommeur: TfjsRenommeur;

implementation

{$R *.lfm}

procedure TfjsRenommeur.TraiteFichiers(S: TStrings);
var
   I: Integer;
   Prefixe: String;
   LongueurPrefixe: Integer;
   IndexDebutPrefixe, IndexFinPrefixe: Integer;
   Index: Integer;
   Nouveau: String;
   LongueurNouveau: Integer;
   Repertoire,AncienNom, NouveauNom: String;
begin
     Prefixe:= ePrefixe.Text;
     LongueurPrefixe:= Length( Prefixe);
     Nouveau:= eNouveau.Text;
     LongueurNouveau:= Length( Nouveau);
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
           IndexDebutPrefixe:= Pos( Prefixe, AncienNom);
           IndexFinPrefixe:= IndexDebutPrefixe + LongueurPrefixe;
           case Fonction
           of
             f_Remplacer:
               begin
               Index:= IndexDebutPrefixe;
               Delete( NouveauNom, Index, LongueurPrefixe);
               end;
             f_Inserer_Apres:
               Index:= IndexFinPrefixe;
             f_Ecraser_Apres:
               begin
               Index:= IndexFinPrefixe;
               Delete( NouveauNom, Index, LongueurNouveau);
               end;
             else
                 ShowMessage('TfjsRenommeur.TraiteFichiers: valeur de fonction non gérée '+IntToStr(Ord(Fonction)));
             end;
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
     rbFonction.ItemIndex:= 0;
     Fonction_from_rbFonction;
end;

procedure TfjsRenommeur.FormDropFiles( Sender: TObject; const FileNames: array of string);
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

procedure TfjsRenommeur.Fonction_from_rbFonction;
begin
     Fonction:= TypeFonction( rbFonction.ItemIndex);
end;

procedure TfjsRenommeur.rbFonctionClick(Sender: TObject);
begin
     Fonction_from_rbFonction;
end;

end.
