unit ufHTML;

{$mode ObjFPC}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
 ActnList, SynEdit, SynHighlighterHTML, SynEditTypes,LCLIntf;

type

 { TfHTML }

 TfHTML = class(TForm)
  al: TActionList;
  aSauver: TAction;
  bSauver: TButton;
  bOpenDocument: TButton;
  bOpenDocument_clean_html: TButton;
  mError: TMemo;
  Panel1: TPanel;
  se: TSynEdit;
  shlHTML: TSynHTMLSyn;
  procedure aSauverExecute(Sender: TObject);
  procedure bOpenDocumentClick(Sender: TObject);
  procedure bOpenDocument_clean_htmlClick(Sender: TObject);
  procedure seStatusChange(Sender: TObject; Changes: TSynStatusChanges);
 private

 public
   NomFichier: String;
   procedure Ouvre( _NomFichier: String; _e: Exception);
   procedure Sauver;
 end;

var
 fHTML: TfHTML;

implementation

{$R *.lfm}

{ TfHTML }

procedure TfHTML.aSauverExecute(Sender: TObject);
begin
     Sauver;
end;

procedure TfHTML.bOpenDocumentClick(Sender: TObject);
begin
     OpenDocument( NomFichier);
end;

procedure TfHTML.bOpenDocument_clean_htmlClick(Sender: TObject);
begin
     OpenDocument( ChangeFileExt(NomFichier, '_html_clean.html'));
end;

procedure TfHTML.seStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
     if scModified in Changes
     then
         bSauver.Show;
end;

procedure TfHTML.Ouvre(_NomFichier: String; _e: Exception);
begin
     NomFichier:= _NomFichier;
     mError.Text:= _e.Message;
     se.Lines.LoadFromFile( NomFichier);
     bSauver.Hide;
     Show;
end;

procedure TfHTML.Sauver;
begin
     se.Lines.SaveToFile( NomFichier);
     bSauver.Hide;
end;

end.


