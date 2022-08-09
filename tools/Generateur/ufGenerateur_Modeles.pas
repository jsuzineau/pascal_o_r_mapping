unit ufGenerateur_Modeles;

{$mode objfpc}{$H+}

interface

uses
    ufjpFiles,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

 { TfGenerateur_Modeles }

 TfGenerateur_Modeles
 =
  class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fjpFiles: TfjpFiles;
  public

  end;

var
 fGenerateur_Modeles: TfGenerateur_Modeles;

implementation

{$R *.lfm}

{ TfGenerateur_Modeles }

procedure TfGenerateur_Modeles.FormCreate(Sender: TObject);
begin
     fjpFiles:= TfjpFiles.Create( Self);
     fjpFiles.Parent:= Self;
     fjpFiles.Align:= alClient;
     fjpFiles.Menu:= nil;
     Menu:= fjpFiles.mm;
     OnDropFiles:= @fjpFiles.DropFiles;
     //fjpFiles.Show;
end;

procedure TfGenerateur_Modeles.FormDestroy(Sender: TObject);
begin
     FreeAndNil( fjpFiles);
end;

end.

