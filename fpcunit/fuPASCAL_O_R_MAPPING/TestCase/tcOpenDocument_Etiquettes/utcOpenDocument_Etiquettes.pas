unit utcOpenDocument_Etiquettes;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uOD_Temporaire,
    uOpenDocument,

    uOD_JCL,
 Classes, SysUtils, fpcunit, testutils, testregistry, FileUtil,LCLIntf, DOM,dialogs;

type

 { TtcOpenDocument_Etiquettes }

 TtcOpenDocument_Etiquettes
 =
  class(TTestCase)
  private
    NomODT: String;
    od: TOpenDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure test_Etiquettes;
  end;

implementation

procedure TtcOpenDocument_Etiquettes.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcOpenDocument_Etiquettes.odt', NomODT);
     //CopyFile( '/home/jean/temp/BCR05XXXXXXVIR.ott', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcOpenDocument_Etiquettes.TearDown;
begin
     FreeAndNil( od);
     //DeleteFile( NomODT);
end;

procedure TtcOpenDocument_Etiquettes.test_Etiquettes;
var
   cir: TCherche_Items_Recursif;
   frame1: TDOMNode;
   frames: array of TDOMNode;
   procedure frames_from_cir;
   var
      frame: TDOMNode;
      name: String;
      sNumber: String;
      Number: Integer;
      Index: Integer;
   begin
        SetLength( frames, cir.l.Count);
        for frame in cir.l
        do
          begin
          if not_Get_Property( frame, 'draw:name', name) then continue;//draw:name="Cadre21"

          StrTok('Cadre', name);
          sNumber:= name;
          if not TryStrToInt( sNumber, Number) then continue;

          if 1 = Number then frame1:= frame;

          Index:= Number-1;
          frames[Index]:= frame;
          end;
   end;
   procedure Copy_frame1;
   var
      frame: TDOMNode;
      tb1, tb: TDOMNode;
      function textbox_from_frame( _f: TDOMNode): TDOMNode;
      begin
           Result:= Elem_from_path(_f, 'draw:text-box');
      end;
   begin
        tb1:= textbox_from_frame( frame1);
        for frame in cir.l
        do
          begin
          if frame1 = frame then continue;
          tb:= textbox_from_frame( frame);
          RemoveChilds( tb);
          Copie_Item( tb1, tb);
          end;
   end;
begin
     cir:= TCherche_Items_Recursif.Create( od.Get_xmlContent_TEXT, 'draw:frame', [], []);
     try
        frames_from_cir;
        Copy_frame1;
     finally
            FreeAndNil( cir);
            end;

     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( NomODT);
//     Fail('Écrivez votre propre test');
end;


initialization
              RegisterTest(TtcOpenDocument_Etiquettes);
end.

