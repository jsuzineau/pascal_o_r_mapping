unit ublCOLUMNS;

interface

uses
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

  SysUtils, Classes, SqlExpr, DB;

type
 TblCOLUMNS
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    TABLE_CATALOG: String;
    TABLE_SCHEMA: String;
    TABLE_NAME: String;
    COLUMN_NAME: String;
    ORDINAL_POSITION: Integer;
    COLUMN_DEFAULT: String;
    IS_NULLABLE: String;
    DATA_TYPE: String;
    CHARACTER_MAXIMUM_LENGTH: Integer;
    CHARACTER_OCTET_LENGTH: Integer;
    NUMERIC_PRECISION: Integer;
    NUMERIC_SCALE: Integer;
    CHARACTER_SET_NAME: String;
    COLLATION_NAME: String;
    COLUMN_TYPE: String;
    COLUMN_KEY: String;
    EXTRA: String;
    PRIVILEGES: String;
    COLUMN_COMMENT: String;

  //Gestion de la clé
  public
    class function sCle_from_( _TABLE_SCHEMA: String; _TABLE_NAME: String; _COLUMN_NAME: String): String;
  
    function sCle: String; override;
  end;

 TIterateur_COLUMNS
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblCOLUMNS);
    function  not_Suivant( var _Resultat: TblCOLUMNS): Boolean;
  end;

 TslCOLUMNS
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
    function Iterateur: TIterateur_COLUMNS;
    function Iterateur_Decroissant: TIterateur_COLUMNS;
  end;

function blCOLUMNS_from_sl( sl: TBatpro_StringList; Index: Integer): TblCOLUMNS;
function blCOLUMNS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCOLUMNS;

implementation

function blCOLUMNS_from_sl( sl: TBatpro_StringList; Index: Integer): TblCOLUMNS;
begin
     _Classe_from_sl( Result, TblCOLUMNS, sl, Index);
end;

function blCOLUMNS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCOLUMNS;
begin
     _Classe_from_sl_sCle( Result, TblCOLUMNS, sl, sCle);
end;

{ TIterateur_COLUMNS }

function TIterateur_COLUMNS.not_Suivant( var _Resultat: TblCOLUMNS): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_COLUMNS.Suivant( var _Resultat: TblCOLUMNS);
begin
     Suivant_interne( _Resultat);
end;

{ TslCOLUMNS }

constructor TslCOLUMNS.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblCOLUMNS);
end;

destructor TslCOLUMNS.Destroy;
begin
     inherited;
end;

class function TslCOLUMNS.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_COLUMNS;
end;

function TslCOLUMNS.Iterateur: TIterateur_COLUMNS;
begin
     Result:= TIterateur_COLUMNS( Iterateur_interne);
end;

function TslCOLUMNS.Iterateur_Decroissant: TIterateur_COLUMNS;
begin
     Result:= TIterateur_COLUMNS( Iterateur_interne_Decroissant);
end;

{ TblCOLUMNS }

constructor TblCOLUMNS.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'COLUMNS';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'information_schema.columns';

     //champs persistants
     Champs.  String_from_String ( TABLE_CATALOG  , 'TABLE_CATALOG'  );
     Champs.  String_from_String ( TABLE_SCHEMA   , 'TABLE_SCHEMA'   );
     Champs.  String_from_String ( TABLE_NAME     , 'TABLE_NAME'     );
     Champs.  String_from_String ( COLUMN_NAME    , 'COLUMN_NAME'    );
     Champs. Integer_from_       ( ORDINAL_POSITION, 'ORDINAL_POSITION');
     Champs.  String_from_String ( COLUMN_DEFAULT , 'COLUMN_DEFAULT' );
     Champs.  String_from_String ( IS_NULLABLE    , 'IS_NULLABLE'    );
     Champs.  String_from_String ( DATA_TYPE      , 'DATA_TYPE'      );
     Champs. Integer_from_Integer( CHARACTER_MAXIMUM_LENGTH, 'CHARACTER_MAXIMUM_LENGTH');
     Champs. Integer_from_Integer( CHARACTER_OCTET_LENGTH, 'CHARACTER_OCTET_LENGTH');
     Champs. Integer_from_Integer( NUMERIC_PRECISION, 'NUMERIC_PRECISION');
     Champs. Integer_from_Integer( NUMERIC_SCALE  , 'NUMERIC_SCALE'  );
     Champs.  String_from_String ( CHARACTER_SET_NAME, 'CHARACTER_SET_NAME');
     Champs.  String_from_String ( COLLATION_NAME , 'COLLATION_NAME' );
     Champs.  String_from_String ( COLUMN_TYPE    , 'COLUMN_TYPE'    );
     Champs.  String_from_String ( COLUMN_KEY     , 'COLUMN_KEY'     );
     Champs.  String_from_String ( EXTRA          , 'EXTRA'          );
     Champs.  String_from_String ( PRIVILEGES     , 'PRIVILEGES'     );
     Champs.  String_from_String ( COLUMN_COMMENT , 'COLUMN_COMMENT' );

end;

destructor TblCOLUMNS.Destroy;
begin

     inherited;
end;

class function TblCOLUMNS.sCle_from_( _TABLE_SCHEMA: String; _TABLE_NAME: String; _COLUMN_NAME: String): String;
begin                               
     Result:=  _TABLE_SCHEMA +  _TABLE_NAME +  _COLUMN_NAME;    
end;                                

function TblCOLUMNS.sCle: String;
begin
     Result:= sCle_from_( TABLE_SCHEMA,
TABLE_NAME,
COLUMN_NAME);
end;

end.


