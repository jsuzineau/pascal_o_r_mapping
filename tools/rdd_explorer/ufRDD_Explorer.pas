unit ufRDD_Explorer;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uRDD,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
 StdCtrls;

type

 { TfRDD_Explorer }

 TfRDD_Explorer
 =
  class(TForm)
   mRaw: TMemo;
   pc: TPageControl;
   tsRaw: TTabSheet;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  //RDD
  private
    rdd: TRDD;
    procedure rdd_Changed;
  end;

var
 fRDD_Explorer: TfRDD_Explorer;

implementation

{$R *.lfm}

{ TfRDD_Explorer }

procedure TfRDD_Explorer.FormCreate(Sender: TObject);
begin
     rdd:= TRDD.Create;
     rdd.OnChange.Abonne( Self, @rdd_Changed);
end;

procedure TfRDD_Explorer.FormDestroy(Sender: TObject);
begin
     rdd.OnChange.DesAbonne( Self, @rdd_Changed);
     Free_nil( rdd);
end;

procedure TfRDD_Explorer.FormDropFiles( Sender: TObject; const FileNames: array of String);
begin
     if Length( FileNames) < 1 then exit;

     rdd.NomFichier:= FileNames[0];
end;

procedure TfRDD_Explorer.rdd_Changed;
begin
     mRaw.Lines.Text:= rdd.S;
end;

end.

