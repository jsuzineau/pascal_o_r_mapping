unit ufAutomatic_Genere_tout_sl;

{$mode delphi}

interface

uses
    uClean, ufpBas, uEXE_INI, Classes, SysUtils, FileUtil, Forms, Controls,
    Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, ActnList, Menus;

type

 { TfAutomatic_Genere_tout_sl }

 TfAutomatic_Genere_tout_sl
 =
  class(TfpBas)
   bFromINI: TButton;
   bToINI: TButton;
    m: TMemo;
    procedure bFromINIClick(Sender: TObject);
    procedure bToINIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  //pré- et post- exécution
  protected
    function PreExecute: Boolean; override;
    procedure PostExecute; override;
  // Exécution
  public
    function Execute( _s: TStrings): Boolean; reintroduce;
  //attributs
  public
    s: TStrings;
  //persistance
  private
    NomFichier: String;
    procedure FromINI;
    procedure ToINI;
  end;

function fAutomatic_Genere_tout_sl: TfAutomatic_Genere_tout_sl;

implementation

{$R *.lfm}

{ TfAutomatic_Genere_tout_sl }

var
   FfAutomatic_Genere_tout_sl: TfAutomatic_Genere_tout_sl= nil;

function fAutomatic_Genere_tout_sl: TfAutomatic_Genere_tout_sl;
begin
     Clean_Get( Result, FfAutomatic_Genere_tout_sl, TfAutomatic_Genere_tout_sl);
end;

procedure TfAutomatic_Genere_tout_sl.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     NomFichier:= ChangeFileExt( EXE_INI.FileName, ClassName+'.txt');
end;

procedure TfAutomatic_Genere_tout_sl.FromINI;
begin
     m.Lines.LoadFromFile( NomFichier);
end;

procedure TfAutomatic_Genere_tout_sl.ToINI;
begin
     m.Lines.SaveToFile( NomFichier);
end;

procedure TfAutomatic_Genere_tout_sl.bFromINIClick(Sender: TObject);
begin
     FromINI;
end;

procedure TfAutomatic_Genere_tout_sl.bToINIClick(Sender: TObject);
begin
     ToINI;
end;

function TfAutomatic_Genere_tout_sl.PreExecute: Boolean;
begin
     FromINI;
     if '' = m.Lines.Text
     then
         m.Lines.Text:= s.Text;
     Result:=inherited PreExecute;
end;

procedure TfAutomatic_Genere_tout_sl.PostExecute;
begin
     inherited PostExecute;

     if not Valide then exit;

     s.Text:= m.Lines.Text;
end;

function TfAutomatic_Genere_tout_sl.Execute( _s: TStrings): Boolean;
begin
     s:= _s;
     Result:=inherited Execute;
end;

initialization

finalization
            Clean_Destroy( FfAutomatic_Genere_tout_sl);
end.

