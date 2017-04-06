unit utcOpenDocument_Embed_Image;

{$mode objfpc}{$H+}

interface

uses
    ublTest,
    uOD_Batpro_Table,
    uOD_Niveau,
    uBatpro_OD_Printer,
 Classes, SysUtils, fpcunit, testutils, testregistry,LCLIntf;

type

 TtcOpenDocument_Embed_Image
 =
  class(TTestCase)
  protected
    NomFichierModele: String;
    sl: TslTest;
    bl: TblTest;
    t: TOD_Batpro_Table;
    n: TOD_Niveau;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure test_Embed_Image;
  end;

implementation

procedure TtcOpenDocument_Embed_Image.SetUp;
begin
     NomFichierModele:= ExtractFilePath(ParamStr(0))+'tcOpenDocument_Embed_Image.ott';;
     sl:= TslTest.Create( ClassName+'.sl');
     bl:= TblTest.Create( sl, nil, nil);
     sl.AddObject( bl.sCle, bl);

     t:= TOD_Batpro_Table.Create( 'Corps');
     t.Pas_de_persistance:=True;
     t.AddColumn( 10, 'Image PNG');
     t.AddColumn( 10, 'Image JPG');
     n:= t.AddNiveau( '');
     n.Charge_sl( sl);
     n.Ajoute_Column_Avant('graphic_png',0,0);
     n.Ajoute_Column_Avant('graphic_jpg',1,1);
end;

procedure TtcOpenDocument_Embed_Image.TearDown;
begin
     FreeAndNil( t);
     sl.Clear;
     FreeAndNil( bl);
     FreeAndNil( sl);
end;

procedure TtcOpenDocument_Embed_Image.test_Embed_Image;
var
   Resultat: String;
begin
     Batpro_OD_Printer.AssureModele( NomFichierModele, [], [], [], [t]);
     Resultat:= Batpro_OD_Printer.Execute( NomFichierModele, ClassName,
                                [], [],
                                [], [],[t]);
     OpenDocument( Resultat);
end;

initialization
              RegisterTest(TtcOpenDocument_Embed_Image);
end.

