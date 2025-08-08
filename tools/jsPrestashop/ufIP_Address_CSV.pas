unit ufIP_Address_CSV;

{$mode Delphi}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, csvdocument;

type

 { TfIP_Address_CSV }

 TfIP_Address_CSV
 =
  class(TForm)
    bOuvrir: TButton;
    od: TOpenDialog;
    procedure bOuvrirClick(Sender: TObject);
   private
    procedure Traite( _NomFichier: String);
   public

   end;

var
   fIP_Address_CSV: TfIP_Address_CSV;

implementation

{$R *.lfm}

{ TfIP_Address_CSV }

procedure TfIP_Address_CSV.bOuvrirClick(Sender: TObject);
begin
     od.InitialDir:= ExtractFilePath(Application.ExeName);
     if od.Execute
     then
         Traite( od.FileName);
end;

procedure TfIP_Address_CSV.Traite( _NomFichier: String);
var
   d: TCSVDocument;
   Col, Row: Integer;
   nIP_Address: Integer;
   B1, B2, B3, B4: Byte;
   ip, reseau: string;
begin
     d:= TCSVDocument.Create;
     try
        d.Delimiter:= ';';
        d.LoadFromFile( _NomFichier);
        if d.ColCount[0] > 1 then exit;
        d.Cells[ 1, 0]:= 'ip';
        d.Cells[ 2, 0]:= 'reseau';
        for Row:= 1 to d.RowCount
        do
          begin
          if not TryStrToInt( d.Cells[0,Row], nIP_Address) then continue;

          B1:= Hi(Hi(Longint(nIP_Address)));
          B2:= Lo(Hi(Longint(nIP_Address)));
          B3:= Hi(Lo(Longint(nIP_Address)));
          B4:= Lo(Lo(Longint(nIP_Address)));

          ip    := Format( '%d.%d.%d.%d',[B1,B2,B3,B4]);
          reseau:= Format( '%d.%d.%d'   ,[B1,B2,B3   ]);

          d.Cells[ 1, Row]:= ip;
          d.Cells[ 2, Row]:= reseau;
          end;
        d.SaveToFile( _NomFichier);
     finally
            FreeAndNil( d);
            end;
     ShowMessage( 'Traitement terminé');
end;
end.

