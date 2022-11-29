unit utcOD_Label_Printer;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    ujsDataContexte,
    u_sys_,
    uBatpro_Element,
    uBatpro_StringList,
    uBatpro_Ligne,
    uOD_Label_Printer,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TblOD_Label_Printer_Test }

 TblOD_Label_Printer_Test
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    Client : String;
    Ligne_1: String;
    Ligne_2: String;
    Ligne_3: String;
    Ligne_4: String;
  end;

 TIterateur_OD_Label_Printer_Test
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOD_Label_Printer_Test);
    function  not_Suivant( var _Resultat: TblOD_Label_Printer_Test): Boolean;
  end;

 TslOD_Label_Printer_Test
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Label_Printer_Test;
    function Iterateur_Decroissant: TIterateur_OD_Label_Printer_Test;
  end;



type

 { TtcOD_Label_Printer }

 TtcOD_Label_Printer
 =
  class(TTestCase)
  private
    sl: TslOD_Label_Printer_Test;
    procedure Cree_Donnees;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
   procedure TestHookUp;
  end;

implementation

function blOD_Label_Printer_Test_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Label_Printer_Test;
begin
     _Classe_from_sl( Result, TblOD_Label_Printer_Test, sl, Index);
end;

function blOD_Label_Printer_Test_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Label_Printer_Test;
begin
     _Classe_from_sl_sCle( Result, TblOD_Label_Printer_Test, sl, sCle);
end;

{ TIterateur_OD_Label_Printer_Test }

function TIterateur_OD_Label_Printer_Test.not_Suivant( var _Resultat: TblOD_Label_Printer_Test): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Label_Printer_Test.Suivant( var _Resultat: TblOD_Label_Printer_Test);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Label_Printer_Test }

constructor TslOD_Label_Printer_Test.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Label_Printer_Test);
end;

destructor TslOD_Label_Printer_Test.Destroy;
begin
     inherited;
end;

class function TslOD_Label_Printer_Test.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Label_Printer_Test;
end;

function TslOD_Label_Printer_Test.Iterateur: TIterateur_OD_Label_Printer_Test;
begin
     Result:= TIterateur_OD_Label_Printer_Test( Iterateur_interne);
end;

function TslOD_Label_Printer_Test.Iterateur_Decroissant: TIterateur_OD_Label_Printer_Test;
begin
     Result:= TIterateur_OD_Label_Printer_Test( Iterateur_interne_Decroissant);
end;

{ TblOD_Label_Printer_Test }

constructor TblOD_Label_Printer_Test.Create( _sl: TBatpro_StringList;
                                             _jsdc: TjsDataContexte;
                                             _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Test';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'OD_Label_Printer_Test';

     Ajoute_String( Client , 'Client', False);
     Ajoute_String( Ligne_1, 'Ligne_1', False);
     Ajoute_String( Ligne_2, 'Ligne_2', False);
     Ajoute_String( Ligne_3, 'Ligne_3', False);
     Ajoute_String( Ligne_4, 'Ligne_4', False);
end;

destructor TblOD_Label_Printer_Test.Destroy;
begin
     inherited Destroy;
end;

{ TtcOD_Label_Printer }

procedure TtcOD_Label_Printer.Cree_Donnees;
var
   i: Integer;
   sI: String;
   bl: TblOD_Label_Printer_Test;
begin
     sl:= TslOD_Label_Printer_Test.Create( ClassName+'.sl');

     for i:= 1 to 60
     do
       begin
       sI:= IntToStr( i);
       bl:= TblOD_Label_Printer_Test.Create( sl, nil, nil);
       bl.Client := 'Client ' +sI+' '+sI;
       bl.Ligne_1:= 'Ligne_1 '+sI+' '+sI;
       bl.Ligne_2:= 'Ligne_2 '+sI+' '+sI;
       bl.Ligne_3:= 'Ligne_3 '+sI+' '+sI;
       bl.Ligne_4:= 'Ligne_4 '+sI+' '+sI;
       sl.AddObject( bl.sCle, bl);
       end;

end;

procedure TtcOD_Label_Printer.SetUp;
begin
     inherited SetUp;
     Cree_Donnees;
end;

procedure TtcOD_Label_Printer.TearDown;
begin
     FreeAndNil( sl);
     inherited TearDown;
end;


procedure TtcOD_Label_Printer.TestHookUp;
var
   olp: TOD_Label_Printer;
begin
     olp:= TOD_Label_Printer.Create( '','tcOpenDocument_Etiquettes.odt', sl);
     try
        olp.Open_ODT;
        //olp.Open_Content;
        //olp.Open_Styles;
        olp.Explorer_on_folder;
     finally
            FreeAndNil( olp);
            end;
end;



initialization
              RegisterTest(TtcOD_Label_Printer);
end.

