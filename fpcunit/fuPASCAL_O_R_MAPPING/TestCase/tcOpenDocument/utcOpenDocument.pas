unit utcOpenDocument;

{$mode objfpc}{$H+}

interface

uses
    uOD_Temporaire,
    uOpenDocument,
 Classes, SysUtils, fpcunit, testutils, testregistry, FileUtil,LCLIntf;

type

 { TtcOpenDocument }

 TtcOpenDocument
 =
  class(TTestCase)
  private
    NomODT: String;
    od: TOpenDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure test_TOpenDocument_Freeze_fields;
  end;

implementation

procedure TtcOpenDocument.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcOpenDocument.odt', NomODT);
     //CopyFile( '/home/jean/temp/BCR05XXXXXXVIR.ott', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcOpenDocument.TearDown;
begin
     FreeAndNil( od);
     //DeleteFile( NomODT);
end;

procedure TtcOpenDocument.test_TOpenDocument_Freeze_fields;
begin
     od.Set_Field('variable_utilisee_deux_fois','13,30');
     //od.Set_Field('Somme_CG_RF1_dmontant','13,30');

     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Freeze_fields;
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( NomODT);
//     Fail('Écrivez votre propre test');
end;

initialization
              RegisterTest(TtcOpenDocument);
end.

