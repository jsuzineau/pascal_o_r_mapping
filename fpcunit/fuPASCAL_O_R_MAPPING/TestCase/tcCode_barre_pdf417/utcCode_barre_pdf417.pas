unit utcCode_barre_pdf417;

{$mode objfpc}{$H+}

interface

uses
    uOD_Temporaire,
    uOpenDocument,
    uCode_barre_pdf417, // Warning this unit is under GPL license
 Classes, SysUtils, fpcunit, testutils, testregistry, FileUtil,LCLIntf;

type

 TtcCode_barre_pdf417
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

procedure TtcCode_barre_pdf417.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcCode_barre_pdf417.odt', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcCode_barre_pdf417.TearDown;
begin
     FreeAndNil( od);
end;

procedure TtcCode_barre_pdf417.TestHookUp;
var
   code: String;
   pdf417_code: String;
var
   secu   : Integer;
   nbcol  : Integer;
   CodeErr: Integer;
begin
            code:= 'truc';
            secu:= -1;
           nbcol:= -1;
     pdf417_code:= pdf417( code, secu, nbcol, CodeErr);
     od.Set_Field(       'code',       code);
     od.Set_Field(       'secu', IntToStr(secu      ));
     od.Set_Field(      'nbcol', IntToStr(nbcol     ));
     od.Set_Field(    'CodeErr', IntToStr(CodeErr   ));
     od.Set_Field('pdf417_code',pdf417_code);

     od.Save;
     OpenDocument( NomODT);
end;

initialization

 RegisterTest(TtcCode_barre_pdf417);
end.

