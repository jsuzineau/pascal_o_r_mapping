unit utcOpenDocument_Embed_Image;

interface
uses
    uVide,
    uEXE_INI,
    ublTest,
    uOD_Batpro_Table,
    uOD_Niveau,
    uBatpro_OD_Printer,
  DUnitX.TestFramework, System.SysUtils, Winapi.Windows, Winapi.ShellAPI;

type

 { TtcOpenDocument_Embed_Image_type_image }

 TtcOpenDocument_Embed_Image_type_image
 =
  class
  //Cycle de vie
  public
    constructor Create( _Extension: String);
    destructor Destroy; override;
  //Extension
  public
    Extension: String;
  //attributs
  public
    RepertoireImages: String;
    sl: TslTest;
    t: TOD_Batpro_Table;
  //méthodes
  private
    procedure Cree_Donnees;
    procedure Cree_Etat;
  end;

  [TestFixture]
  TtcOpenDocument_Embed_Image = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  //test_Embed_Image
  private
    jpg, png, bmp: TtcOpenDocument_Embed_Image_type_image;
  public
    [TestCase('test_Embed_Image','')]
    procedure test_Embed_Image;
  end;

implementation

{ TtcOpenDocument_Embed_Image_type_image }

constructor TtcOpenDocument_Embed_Image_type_image.Create( _Extension: String);
begin
     Extension:= _Extension;
     Cree_Donnees;
     Cree_Etat;
end;

destructor TtcOpenDocument_Embed_Image_type_image.Destroy;
begin
     FreeAndNil( t);
     Vide_StringList( sl);
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TtcOpenDocument_Embed_Image_type_image.Cree_Donnees;
var
   Masque: String;
   sr: TSearchRec;
   bl: TblTest;
begin
     sl:= TslTest.Create( ClassName+'.sl');

     RepertoireImages
     :=
       EXE_INI.Assure_String( ClassName+'.Répertoire images', ExtractFilePath(ParamStr(0)));

     RepertoireImages:= IncludeTrailingPathDelimiter( RepertoireImages);
     Masque:= RepertoireImages+'*.'+Extension;
     try
        if 0 <> FindFirst( Masque, faAnyFile, sr) then exit;
        repeat
          bl:= TblTest.Create( sl, nil, nil);
          bl.Nom:= sr.Name;
          bl.graphic_Nom:= RepertoireImages+sr.Name;
          sl.AddObject( bl.sCle, bl);
        until 0 <> FindNext( sr);
     finally
            System.SysUtils.FindClose( sr);
            end;

end;

procedure TtcOpenDocument_Embed_Image_type_image.Cree_Etat;
var
   n: TOD_Niveau;
begin
     t:= TOD_Batpro_Table.Create( Extension);
     t.Pas_de_persistance:=True;
     t.AddColumn( 10, 'Nom');
     t.AddColumn( 10, 'Image');
     n:= t.AddNiveau( '');
     n.Charge_sl( sl);
     n.Ajoute_Column_Avant('Nom'        ,0,0);
     n.Ajoute_Column_Avant('graphic_Nom',1,1);
end;

{ TtcOpenDocument_Embed_Image }

procedure TtcOpenDocument_Embed_Image.Setup;
begin
     jpg:= TtcOpenDocument_Embed_Image_type_image.Create('jpg');
     png:= TtcOpenDocument_Embed_Image_type_image.Create('png');
     bmp:= TtcOpenDocument_Embed_Image_type_image.Create('bmp');
end;

procedure TtcOpenDocument_Embed_Image.TearDown;
begin
     FreeAndNil( jpg);
     FreeAndNil( png);
     FreeAndNil( bmp);
end;

procedure TtcOpenDocument_Embed_Image.test_Embed_Image;
var
   NomFichierModele: String;
   Resultat: String;
begin
     NomFichierModele:= ExtractFilePath(ParamStr(0))+'tcOpenDocument_Embed_Image.ott';;

     Batpro_OD_Printer.AssureModele( NomFichierModele,
                                     ['RepertoireImages'],
                                     [], [],
                                     [jpg.t,png.t,bmp.t]);
     Resultat:= Batpro_OD_Printer.Execute( NomFichierModele, ClassName,
                                     ['RepertoireImages'],
                                     [jpg.RepertoireImages],
                                     [], [],
                                     [jpg.t,png.t,bmp.t]);
     //OpenDocument( Resultat);
     ShellExecute(0, 'OPEN', PChar(Resultat), '', '', SW_SHOWNORMAL);
end;

initialization
              TDUnitX.RegisterTestFixture(TtcOpenDocument_Embed_Image);
end.
