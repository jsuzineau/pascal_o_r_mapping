unit ufjsSousTitres;

{$mode objfpc}{$H+}

interface

uses
    uOpenDocument,
    uEXE_INI,
    uuStrings,
    uOD_JCL,
    uDataUtilsU,
    Classes, SysUtils,
    Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, IniPropStorage,
    Spin, uFichierASS, uFichierODT, ufTableaux, DOM, IniFiles, Math, StrUtils;

type

 { TfjsSousTitres }

 TfjsSousTitres
 =
  class(TForm)
   bASS: TButton;
   bMakeASS: TButton;
   bODT: TButton;
   bTableaux: TButton;
   bFont: TButton;
   eASS: TEdit;
   eFontName: TEdit;
   eODT: TEdit;
   fd: TFontDialog;
   ips: TIniPropStorage;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   mResultat: TMemo;
   odASS: TOpenDialog;
   odODT: TOpenDialog;
   Panel1: TPanel;
   seColonne: TSpinEdit;
   seFontSize: TSpinEdit;
   tReady: TTimer;
   procedure bASSClick(Sender: TObject);
   procedure bFontClick(Sender: TObject);
   procedure bMakeASSClick(Sender: TObject);
   procedure bODTClick(Sender: TObject);
   procedure bTableauxClick(Sender: TObject);
   procedure eASSChange(Sender: TObject);
   procedure eFontNameChange(Sender: TObject);
   procedure eODTChange(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure seColonneChange(Sender: TObject);
   procedure seFontSizeChange(Sender: TObject);
   procedure tReadyTimer(Sender: TObject);
  //Document
  private
    ODT_OK: Boolean;
    fo: TFichierODT;
    procedure ODT_Ouvrir;
  //Table
  private
    iColonne: Integer;
  //fichier ASS
  private
    ASS_OK: Boolean;
    faSource: TFichierASS;
    faCible : TFichierASS;
    procedure ASS_Ouvrir;
    procedure Compare_ASS;
    procedure MakeASS;
  //Affichage
  private
    procedure _from_mResultat_Font;
  end;

var
 fjsSousTitres: TfjsSousTitres;

implementation

{$R *.lfm}

{ TfjsSousTitres }

procedure TfjsSousTitres.FormCreate(Sender: TObject);
begin
     ODT_OK:= False;
     ASS_OK:= False;
     fo      := TFichierODT.Create;
     faSource:= TFichierASS.Create;
     faCible := TFichierASS.Create;
     ips.IniFileName:= ExtractFilePath( EXE_INI_Nom)+'IniPropStorage.ini' ;
     ips.IniSection := Name;
end;

procedure TfjsSousTitres.FormDestroy(Sender: TObject);
begin
     FreeAndNil( fo      );
     FreeAndNil( faSource);
     FreeAndNil( faCible );
end;

procedure TfjsSousTitres.bODTClick(Sender: TObject);
begin
     odODT.FileName:= eODT.Text;
     if odODT.Execute
     then
         eODT.Text:= odODT.FileName;
end;

procedure TfjsSousTitres.bASSClick(Sender: TObject);
begin
     odASS.FileName:= eASS.Text;
     if odASS.Execute
     then
         eASS.Text:= odASS.FileName;
end;

procedure TfjsSousTitres.eODTChange(Sender: TObject);
begin
     ODT_Ouvrir;
end;

procedure TfjsSousTitres.eASSChange(Sender: TObject);
begin
     ASS_Ouvrir;
end;

procedure TfjsSousTitres.bMakeASSClick(Sender: TObject);
begin
     MakeASS;
end;

procedure TfjsSousTitres.seColonneChange(Sender: TObject);
begin
     iColonne:= seColonne.Value;
     Compare_ASS;
end;

procedure TfjsSousTitres._from_mResultat_Font;
begin
     seFontSize.Value:= mResultat.Font.Size;
     eFontName .Text := mResultat.Font.Name;
end;

procedure TfjsSousTitres.eFontNameChange(Sender: TObject);
begin
     mResultat.Font.Name:= eFontName.Text;
end;

procedure TfjsSousTitres.seFontSizeChange(Sender: TObject);
begin
     mResultat.Font.Size:= seFontSize.Value;
end;

procedure TfjsSousTitres.tReadyTimer(Sender: TObject);
begin
     tReady.Enabled:= False;

     _from_mResultat_Font;
end;

procedure TfjsSousTitres.bFontClick(Sender: TObject);
begin
     fd.Font:= mResultat.Font;
     if fd.Execute
     then
         begin
         mResultat.Font:= fd.Font;
         _from_mResultat_Font;
         end;
end;

procedure TfjsSousTitres.bTableauxClick(Sender: TObject);
begin
     fTableaux.Liste_Tableaux( fo);
     fTableaux.Show;
end;

procedure TfjsSousTitres.ODT_Ouvrir;
begin
     ODT_OK:= FileExists( eODT.Text);
     if not ODT_OK then exit;

     fo.Charger( eODT.Text);

     if Assigned( fTableaux)
     then
         fTableaux.Liste_Tableaux( fo);

     Compare_ASS;
end;

procedure TfjsSousTitres.ASS_Ouvrir;
begin
     ASS_OK:= FileExists( eASS.Text);
     if not ASS_OK then exit;

     faSource.Charger( eASS.Text);
     Compare_ASS;
end;

procedure TfjsSousTitres.Compare_ASS;
begin
     if ODT_OK and ASS_OK
     then
         mResultat.Lines.Text:= faSource.GetResultat( fo, iColonne);
end;

procedure TfjsSousTitres.MakeASS;
var
   NomFichierSource, NomFichierCible: String;
begin
     faCible.Init_from_( faSource);
     faCible.Produire( fo, iColonne);

     NomFichierSource:= eASS.Text;
     NomFichierCible:= ChangeFileExt( NomFichierSource, FormatDateTime( '_dd_mm_yy_hh"h"nn"m"ss"s"', Now)+'.ass');
     faCible.sl.SaveToFile( NomFichierCible);
end;

end.

