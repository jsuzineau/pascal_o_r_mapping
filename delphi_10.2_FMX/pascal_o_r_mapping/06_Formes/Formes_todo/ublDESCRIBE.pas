unit ublDESCRIBE;

interface

uses
    SysUtils, Classes, DB, Grids,
    uBatpro_StringList,
    u_sys_,
    uChamp,
    uuStrings,
    uDataClasses,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne;

type
 TChampMySQL
 =
  (
  cms_CHAR      ,
  cms_VARCHAR   ,
  cms_DECIMAL   ,
  cms_INT       ,
  cms_SMALLINT  ,
  cms_DOUBLE    ,
  cms_DATE      ,
  cms_DATETIME  ,
  cms_BLOB      ,
  cms_LONGBLOB  ,
  cms_TEXT      ,
  cms_LONGTEXT  ,
  cms_NonDecode
  );


 TblDESCRIBE
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs
  public
    Field  : String;
    Typ    : String;
    Nul    : String;
    Key    : String;
    Default: String;
    Extra  : String;
  //Champs calculés
  public
    bObligatoire: Boolean;
    sObligatoire: String;
    sType       : String;
    // pour DECIMAL
    Precision, Scale: Integer;
    type_base: String;
    ChampMySQL: TChampMySQL;
  //Création des champs
  protected
    procedure Cree_Champs; override;
  //Gestion de la clé
  public
    class function sCle_from_( _Field: String): String;

    function sCle: String; override;

  end;

function blDESCRIBE_from_sl( sl: TBatpro_StringList; Index: Integer): TblDESCRIBE;
function blDESCRIBE_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDESCRIBE;
function sg_blDESCRIBE( sg: TStringGrid; Colonne, Ligne: Integer): TblDESCRIBE;

implementation

function blDESCRIBE_from_sl( sl: TBatpro_StringList; Index: Integer): TblDESCRIBE;
begin
     _Classe_from_sl( Result, TblDESCRIBE, sl, Index);
end;

function blDESCRIBE_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDESCRIBE;
begin
     _Classe_from_sl_sCle( Result, TblDESCRIBE, sl, sCle);
end;

function sg_blDESCRIBE( sg: TStringGrid; Colonne, Ligne: Integer): TblDESCRIBE;
var
   be: TBatpro_Element;
begin
     Result:= nil;

     be:= Batpro_Element_from_sg( sg, Colonne, Ligne);
     if be = nil then exit;
     if not (be is TblDESCRIBE) then exit;

     Result:=TblDESCRIBE( be);
end;


{ TblDESCRIBE }

constructor TblDESCRIBE.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'DESCRIBE';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;
     inherited;
     Champs.ChampDefinitions.NomTable:= 'DESCRIBE';
end;

destructor TblDESCRIBE.Destroy;
begin
     inherited;
end;

class function TblDESCRIBE.sCle_from_( _Field: String): String;
begin
     Result:=  _Field;
end;

function TblDESCRIBE.sCle: String;
begin
     Result:= sCle_from_( Field);
end;

procedure TblDESCRIBE.Cree_Champs;
var
   iParenthese: Integer;
   procedure Get_2_parametres( var I1, I2: Integer);
   var
      S, sI1, sI2: String;
   begin
        S:= Typ;
        StrToK( '(', S);
        sI1:= StrToK( ',', S);
        sI2:= StrToK( ')', S);
        if not TryStrToInt( sI1, I1) then I1:= 0;
        if not TryStrToInt( sI2, I2) then I2:= 0;
   end;
begin
     inherited;
     //champs persistants
     Champs.  String_from_String ( Field  , 'Field'  );
     Champs.  String_from_Memo   ( Typ    , 'Type'   );
     Champs.  String_from_String ( Nul    , 'Null'   );
     Champs.  String_from_String ( Key    , 'Key'    );
     Champs.  String_from_String ( Default, 'Default');
     Champs.  String_from_String ( Extra  , 'Extra'  );

     type_base:= Typ;
     iParenthese:= Pos( '(', type_base);
     if iParenthese > 0
     then
         Delete( type_base, iParenthese, Length(type_base));

          if 'char'     = type_base then ChampMySQL:= cms_CHAR
     else if 'varchar'  = type_base then ChampMySQL:= cms_VARCHAR
     else if 'decimal'  = type_base then ChampMySQL:= cms_DECIMAL
     else if 'int'      = type_base then ChampMySQL:= cms_INT
     else if 'smallint' = type_base then ChampMySQL:= cms_SMALLINT
     else if 'double'   = type_base then ChampMySQL:= cms_DOUBLE
     else if 'date'     = type_base then ChampMySQL:= cms_DATE
     else if 'datetime' = type_base then ChampMySQL:= cms_DATETIME
     else if 'blob'     = type_base then ChampMySQL:= cms_BLOB
     else if 'longblob' = type_base then ChampMySQL:= cms_LONGBLOB
     else if 'text'     = type_base then ChampMySQL:= cms_TEXT
     else if 'longtext' = type_base then ChampMySQL:= cms_LONGTEXT
     else                                ChampMySQL:= cms_NonDecode;

     bObligatoire:= Nul <> 'YES';

     if bObligatoire
     then
         sObligatoire:= 'O'
     else
         sObligatoire:= 'N';

     case ChampMySQL
     of
       cms_DECIMAL   : Get_2_parametres( Precision, Scale);
       end;
     Champs.Ajoute_String( sObligatoire, 'Obligatoire', False);
end;

end.


