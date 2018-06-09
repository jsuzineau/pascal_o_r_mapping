unit utcOpenDocument_AddHTML;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uVide,
    uOD_JCL,
    uOD_Temporaire,
    ublTest_HTML,
    uOpenDocument,
    uOD_Batpro_Table,
    uOD_Niveau,
    uBatpro_OD_Printer,
 Classes, SysUtils, fpcunit, testutils, testregistry,FileUtil,LCLIntf,DOM;

type
  { TtcOpenDocument_AddHTML_type_HTML }

  TtcOpenDocument_AddHTML_type_HTML
  =
   class
   //Cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //attributs
   public
     sl: TslTest_HTML;
     t: TOD_Batpro_Table;
   //méthodes
   private
     procedure Cree_Donnees;
     procedure Cree_Etat;
   end;

 TtcOpenDocument_AddHTML
 =
  class(TTestCase)
  private
    test: TtcOpenDocument_AddHTML_type_HTML;
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  end;

implementation

{ TtcOpenDocument_AddHTML_type_HTML }

constructor TtcOpenDocument_AddHTML_type_HTML.Create;
begin
     Cree_Donnees;
     Cree_Etat;
end;

destructor TtcOpenDocument_AddHTML_type_HTML.Destroy;
begin
     FreeAndNil( t);
     Vide_StringList( sl);
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TtcOpenDocument_AddHTML_type_HTML.Cree_Donnees;
var
   i: Integer;
   bl: TblTest_HTML;
begin
     sl:= TslTest_HTML.Create( ClassName+'.sl');

     for i:= 1 to 5
     do
       begin
       bl:= TblTest_HTML.Create( sl, nil, nil);
       bl.Nom:= 'Ligne '+IntToStr( i);
       sl.AddObject( bl.sCle, bl);
       case i mod 4
       of
         1: bl.Load_html( nom_html  );
         2: bl.Load_html( nom_html_2);
         3: bl.Load_html( nom_html_3);
         0: bl.Load_html( nom_html_4);
         end;
       end;
end;

procedure TtcOpenDocument_AddHTML_type_HTML.Cree_Etat;
var
   n: TOD_Niveau;
begin
     t:= TOD_Batpro_Table.Create( 'Corps');
     t.Pas_de_persistance:=True;
     t.AddColumn( 10, 'Nom');
     t.AddColumn( 10, 'HTML');
     n:= t.AddNiveau( '');
     n.Charge_sl( sl);
     n.Ajoute_Column_Avant('Nom',0,0);
     n.Ajoute_Column_Avant('html',1,1);
end;


{ TtcOpenDocument_AddHTML }
procedure TtcOpenDocument_AddHTML.SetUp;
begin
     test:= TtcOpenDocument_AddHTML_type_HTML.Create;
end;

procedure TtcOpenDocument_AddHTML.TearDown;
begin
     FreeAndNil( test);
end;

procedure TtcOpenDocument_AddHTML.TestHookUp;
var
   NomFichierModele: String;
   Resultat: String;
   od: TOpenDocument;

   html: String;
   function New_p: TDOMNode;
   begin
        Result:= Cree_path( od.Get_xmlContent_TEXT, 'text:p');
   end;
begin
     html:= String_from_File( nom_html);

     NomFichierModele:= ExtractFilePath(ParamStr(0))+'tcOpenDocument_AddHTML.odt';

     {
     Batpro_OD_Printer.AssureModele( NomFichierModele,
                                     ['RepertoireImages'],
                                     [], [],
                                     [test.t]);
     }
     Resultat:= Batpro_OD_Printer.Execute( NomFichierModele, ClassName,
                                     ['variable_html'],
                                     [html],
                                     [], [],
                                     [test.t]);
     od:= TOpenDocument.Create( Resultat);
     //e:= Cree_path( od.Get_xmlContent_TEXT, 'text:p');
     //od.AddHtml( e, '<p><strong>yujy</strong>ujf<em>yujC</em>LP<u>100</u>&#x2F;70-<span style="color:#e60000">D4-H</span>T<span style="background-color:#ff9900">4.80 </span>( s<strong style="color:#ff9900"><u>imple pare</u></strong>ment BA 15)<br/><br/>ftrh<br/>rtfj<br/><br/>rtjrtj test jean</p>');


     od.AddHtml( New_p, html);
     od.AddHtml( New_p, 'test & a > b et c< d');
     od.AddHtml( New_p, '< test ');

     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Freeze_fields;
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( Resultat);
     OpenDocument( nom_html);
     //Fail('Écrivez votre propre test');
end;

initialization
              RegisterTest(TtcOpenDocument_AddHTML);
end.

