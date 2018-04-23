unit utcOpenDocument_AddHTML;

{$mode objfpc}{$H+}

interface

uses
  uOD_Temporaire,
  uOpenDocument,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type
 TtcOpenDocument_AddHTML
 =
  class(TTestCase)
  private
    NomODT: String;
    od: TOpenDocument;
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  end;

implementation

procedure TtcOpenDocument_AddHTML.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcOpenDocument_AddHTML.odt', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcOpenDocument_AddHTML.TearDown;
begin
     FreeAndNil( od);
     //DeleteFile( NomODT);
end;

procedure TtcOpenDocument_AddHTML.TestHookUp;
begin
     od.AddHtml( '<p><strong>yujy</strong>ujf<em>yujC</em>LP<u>100</u>&#x2F;70-<span style="color:#e60000">D4-H</span>T<span style="background-color:#ff9900">4.80 </span>( s<strong style="color:#ff9900"><u>imple pare</u></strong>ment BA 15)<br/><br/>ftrh<br/>rtfj<br/><br/>rtjrtj test jean</p>');

     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Freeze_fields;
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( NomODT);
     //Fail('Écrivez votre propre test');
end;

initialization
              RegisterTest(TtcOpenDocument_AddHTML);
end.

