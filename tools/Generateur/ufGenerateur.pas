unit ufGenerateur;

{$mode objfpc}{$H+}

interface

uses
    udmDatabase,
    ufAutomatic_VST, odbcconn, sqldb,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

 { TfGenerateur }

 TfGenerateur
 =
  class(TForm)
   procedure FormCreate(Sender: TObject);
   procedure FormShow(Sender: TObject);
  private
   { private declarations }
   fAutomatic_VST: TfAutomatic_VST;
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
     fAutomatic_VST:= TfAutomatic_VST.Create( Self);
     ClientWidth := fAutomatic_VST.Width;
     ClientHeight:= fAutomatic_VST.Height;
     fAutomatic_VST.Parent:= Self;
     fAutomatic_VST.Align:= alClient;
     //fAutomatic_VST.Menu:= nil;
     //Menu:= fAutomatic_VST.mm;
     //OnDropFiles:= @fAutomatic_VST.DropFiles;
     //fjpFiles.Show;
end;

procedure TfGenerateur.FormShow(Sender: TObject);
begin
     dmDatabase.Ouvre_db;
     //fAutomatic_VST.Show;
end;

end.

