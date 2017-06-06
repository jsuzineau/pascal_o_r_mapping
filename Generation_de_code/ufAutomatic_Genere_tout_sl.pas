unit ufAutomatic_Genere_tout_sl;

{$mode delphi}

interface

uses
    uClean,
    ufpBas,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfAutomatic_Genere_tout_sl }

 TfAutomatic_Genere_tout_sl
 =
  class(TfpBas)
    m: TMemo;
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
end;

function TfAutomatic_Genere_tout_sl.PreExecute: Boolean;
begin
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

