unit ufGenerateur;

{$mode objfpc}{$H+}

interface

uses
    ufAutomatic_VST,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

 { TfGenerateur }

 TfGenerateur = class(TForm)
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  { private declarations }
 public
  { public declarations }
 end;

var
 fGenerateur: TfGenerateur;

implementation

{$R *.lfm}

{ TfGenerateur }

procedure TfGenerateur.FormCreate(Sender: TObject);
begin

end;

procedure TfGenerateur.FormShow(Sender: TObject);
begin
     fAutomatic_VST.Show;
end;

end.

