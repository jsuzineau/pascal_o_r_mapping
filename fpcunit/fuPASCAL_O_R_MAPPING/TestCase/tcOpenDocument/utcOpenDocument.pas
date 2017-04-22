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

procedure TtcOpenDocument.test_TOpenDocument_Freeze_fields;
begin
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Freeze_fields;
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( NomODT);
//     Fail('Écrivez votre propre test');
end;

procedure TtcOpenDocument.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcOpenDocument.odt', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcOpenDocument.TearDown;
begin
     FreeAndNil( od);
     //DeleteFile( NomODT);
end;

initialization
              RegisterTest(TtcOpenDocument);
end.

