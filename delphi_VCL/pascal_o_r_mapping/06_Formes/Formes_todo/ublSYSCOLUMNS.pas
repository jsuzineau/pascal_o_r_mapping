unit ublSYSCOLUMNS;

interface

uses
    uBatpro_StringList,
    u_sys_,
    uChamp,
    uuStrings,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,

  SysUtils, Classes, DB;

const
     ct_NCHAR0      =  0;
     ct_SMALLINT    =  1;
     ct_INTEGER     =  2;
     ct_FLOAT       =  3;
     ct_SMALLFLOAT  =  4;
     ct_DECIMAL     =  5;
     ct_SERIAL      =  6;
     ct_DATE        =  7;
     ct_MONEY       =  8;
     ct_DATETIME    = 10;
     ct_BYTE        = 11;
     ct_TEXT        = 12;
     ct_NVARCHAR13  = 13;
     ct_INTERVAL    = 14;
     ct_NCHAR15     = 15;
     ct_NVARCHAR16  = 16;

type
 TblSYSCOLUMNS
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    colname: String;
    tabid: Integer;
    colno: Integer;
    coltype: Integer;
    collength: Integer;
    colmin: Integer;
    colmax: Integer;

  //aggrégations faibles
  public
//pattern_aggregations_faibles_declaration
  //Gestion de la clé
  public
    class function sCle_from_( _colname: String; _tabid: Integer): String;

    function sCle: String; override;

  //Champs calculés
  public
    bObligatoire: Boolean;
    sObligatoire: String;
    sType       : String;
    Longueur    : String;
    //pour ct_MONEY, ct_DECIMAL
    Precision, Scale: Integer;
    //pour ct_NVARCHAR
    Min_space, Max_size: Integer;
    //pour ct_DATETIME, ct_INTERVAL
    Len, Largest_qualifier_value, Smallest_qualifier_value: Integer;
    sLargest_qualifier_value,
    sSmallest_qualifier_value: String;
    SQL, SQL_MySQL: String;
    function Is_NCHAR: Boolean;
  end;

function blSYSCOLUMNS_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSCOLUMNS;
function blSYSCOLUMNS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSCOLUMNS;

implementation

function blSYSCOLUMNS_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSCOLUMNS;
begin
     _Classe_from_sl( Result, TblSYSCOLUMNS, sl, Index);
end;

function blSYSCOLUMNS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSCOLUMNS;
begin
     _Classe_from_sl_sCle( Result, TblSYSCOLUMNS, sl, sCle);
end;

{extrait de la doc informix
 4365.pdf, Guide to SQL Reference, February 1998, p 1-16
coltype SMALLINT Code for column data type:
0 = NCHAR       8 = MONEY
1 = SMALLINT   10 = DATETIME
2 = INTEGER    11 = BYTE
3 = FLOAT      12 = TEXT
4 = SMALLFLOAT 13 = NVARCHAR
5 = DECIMAL    14 = INTERVAL
6 = SERIAL     15 = NCHAR
7 = DATE       16 = NVARCHAR
If the coltype column contains a value greater than 256, it does not allow null
values. To determine the data type for a coltype column that contains a value
greater than 256, subtract 256 from the value and evaluate the remainder,
based on the possible coltype values. For example, if a column has a coltype
value of 262, subtracting 256 from 262 leaves a remainder of 6, which
indicates that this column uses a SERIAL data type.
}
{
The value that the collength column holds depends on the data type of the
column. If the data type of the column is BYTE or TEXT, collength holds the
length of the descriptor. The following formula determines a collength value
for a MONEY or DECIMAL column:
(precision * 256) + scale
For columns of type NVARCHAR, the max_size and min_space values are
encoded in the collength column using one of the following formulas:
n If the collength value is positive:
collength = (min_space * 256) + max_size
n If the collength value is negative:
collength + 65536 = (min_space * 256) + max_size
For columns of type DATETIME or INTERVAL, the following formula deter-mines
collength:
(length * 256) + (largest_qualifier_value * 16) + smallest_qualifier_value
The length is the physical length of the DATETIME or INTERVAL field, and
largest_qualifier and smallest_qualifier have the values that the following table
shows.
For example, if a DATETIME YEAR TO MINUTE column has a length of 12
(such as YYYY:DD:MM:HH:MM), a largest_qualifier value of 0 (for YEAR), and a
smallest_qualifier value of 8 (for MINUTE), the collength value is 3080 or
(256 * 12) + (0 * 16) + 8.
Field Qualifier Value
YEAR 0
MONTH 2
DAY 4
HOUR 6
MINUTE 8
SECOND 10
FRACTION(1) 11
FRACTION(2) 12
FRACTION(3) 13
FRACTION(4) 14
FRACTION(5) 15
}


{ TblSYSCOLUMNS }

constructor TblSYSCOLUMNS.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
   cCOLNAME,
   cTABID  : TChamp;

    nLongueur: Integer;
    function sDateTimeQualifier( Qualifier: Integer): String;
    begin
         case Qualifier
         of
            0:  Result:= 'YEAR       ';
            2:  Result:= 'MONTH      ';
            4:  Result:= 'DAY        ';
            6:  Result:= 'HOUR       ';
            8:  Result:= 'MINUTE     ';
           10:  Result:= 'SECOND     ';
           11:  Result:= 'FRACTION(1)';
           12:  Result:= 'FRACTION(2)';
           13:  Result:= 'FRACTION(3)';
           14:  Result:= 'FRACTION(4)';
           15:  Result:= 'FRACTION(5)';
           else Result:= 'INCONNU    ';
           end;
    end;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSCOLUMNS';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'syscolumns';

     //champs persistants
     cCOLNAME:= Champs.  String_from_String ( colname        , 'colname'        , True);
     cTABID  := Champs. Integer_from_Integer( tabid          , 'tabid'          , True);
                Champs. Integer_from_Integer( colno          , 'colno'          );
                Champs. Integer_from_Integer( coltype        , 'coltype'        );
                Champs. Integer_from_Integer( collength      , 'collength'      );
                Champs. Integer_from_Integer( colmin         , 'colmin'         );
                Champs. Integer_from_Integer( colmax         , 'colmax'         );

     colname:= Trim( colname);

     //Aggrégations faibles
//pattern_aggregations_faibles_pool_get
     // Code manuel

     cCOLNAME.Definition.Visible:= False;
     cTABID  .Definition.Visible:= False;

     bObligatoire:= ColType >= 256;

     if bObligatoire
     then
         sObligatoire:= 'O'
     else
         sObligatoire:= 'N';

     ColType:= ColType mod 256;

     SQL      := sys_Vide;
     SQL_MySQL:= sys_Vide;
     case ColType
     of
       ct_NCHAR0    : begin sType:= 'NCHAR     '; SQL:= 'CHAR'      ; SQL_MySQL:= 'char'      ; end;
       ct_SMALLINT  : begin sType:= 'SMALLINT  '; SQL:= 'SMALLINT'  ; SQL_MySQL:= 'smallint(6)'; end;
       ct_INTEGER   : begin sType:= 'INTEGER   '; SQL:= 'INTEGER'   ; SQL_MySQL:= 'int(11)'   ; end;
       ct_FLOAT     : begin sType:= 'FLOAT     '; SQL:= 'FLOAT'     ; SQL_MySQL:= 'double'    ; end;
       ct_SMALLFLOAT: begin sType:= 'SMALLFLOAT'; SQL:= 'SMALLFLOAT'; SQL_MySQL:= 'float'     ; end;
       ct_DECIMAL   : begin sType:= 'DECIMAL   '; SQL:= 'DECIMAL'   ; SQL_MySQL:= 'decimal'   ; end;
       ct_SERIAL    : begin sType:= 'SERIAL    '; SQL:= 'SERIAL'    ; SQL_MySQL:= 'int(11)'   ; end;
       ct_DATE      : begin sType:= 'DATE      '; SQL:= 'DATE'      ; SQL_MySQL:= 'date'      ; end;
       ct_MONEY     : begin sType:= 'MONEY     '; SQL:= 'MONEY'     ; SQL_MySQL:= 'decimal'   ; end;
       ct_DATETIME  : begin sType:= 'DATETIME  '; SQL:= 'DATETIME'  ; SQL_MySQL:= 'datetime'  ; end;
       ct_BYTE      : begin sType:= 'BYTE      '; SQL:= 'BYTE'      ; SQL_MySQL:= 'longblob'  ; end;
       ct_TEXT      : begin sType:= 'TEXT      '; SQL:= 'TEXT'      ; SQL_MySQL:= 'longtext'  ; end;
       ct_NVARCHAR13: begin sType:= 'NVARCHAR13'; SQL:= 'VARCHAR'   ; SQL_MySQL:= 'varchar'   ; end;
       ct_INTERVAL  : begin sType:= 'INTERVAL  '; SQL:= 'INTERVAL'  ; SQL_MySQL:= 'INTERVAL(non traductible)'; end;
       ct_NCHAR15   : begin sType:= 'NCHAR   15'; SQL:= 'CHAR'      ; SQL_MySQL:= 'char'      ; end;
       ct_NVARCHAR16: begin sType:= 'NVARCHAR16'; SQL:= 'VARCHAR'   ; SQL_MySQL:= 'varchar'   ; end;
       else           begin sType:= 'INCONNU   '; SQL:= ''          ; SQL_MySQL:= ''          ; end;
       end;

     // Composition de Longueur
     case ColType
     of
       ct_MONEY     ,
       ct_DECIMAL   :
         begin
         //ColLength= (precision * 256) + scale
         Precision:= ColLength div 256;
         Scale    := ColLength mod 256;
         Longueur:= Format( '%d dont %d décimales', [Precision, Scale]);
         SQL      := SQL      +Format('(%d,%d)',[Precision, Scale]);
         SQL_MySQL:= SQL_MySQL+Format('(%d,%d)',[Precision, Scale]);
         end;
       ct_NVARCHAR13, ct_NVARCHAR16:
         begin
         if ColLength > 0
         then
             begin
             //collength = (min_space * 256) + max_size
             Min_space:= ColLength div 256;
             Max_size := ColLength mod 256;
             end
         else
             begin
             //collength + 65536 = (min_space * 256) + max_size
             nLongueur:= ColLength + 65536;
             Min_space:= nLongueur div 256;
             Max_size := nLongueur mod 256;
             end;
         Longueur:= Format( 'Min_space:%d,Max_size:%d', [Min_space, Max_size]);
         SQL      := SQL      +Format('(%d,%d)',[Max_size, Min_space]);
         if Max_size > 255
         then
             SQL_MySQL:= 'text'
         else
             SQL_MySQL:= SQL_MySQL+Format('(%d)',[Max_size]);
         end;
       ct_DATETIME  ,
       ct_INTERVAL  :
         begin
         //collength = (length * 256) +
         //            (largest_qualifier_value * 16) + smallest_qualifier_value
         Len:= ColLength div 256;
         nLongueur:= ColLength mod 256;
          Largest_Qualifier_Value:= nLongueur div 16;
         Smallest_Qualifier_Value:= nLongueur mod 16;
          sLargest_Qualifier_Value:=sDateTimeQualifier( Largest_Qualifier_Value);
         sSmallest_Qualifier_Value:=sDateTimeQualifier(Smallest_Qualifier_Value);
         Longueur:= Format( '%d,%s to %s',
                            [ Len,
                               sLargest_Qualifier_Value,
                              sSmallest_Qualifier_Value]);
         SQL      := SQL      +Format( ' %s TO %s',
                           [sLargest_Qualifier_Value, sSmallest_Qualifier_Value]);
         SQL_MySQL:= SQL_MySQL;
         end;
       ct_NCHAR0 ,
       ct_NCHAR15:
         begin
         Longueur:= IntToStr( ColLength);
         SQL      := SQL      +'('+Longueur+')';
         if ColLength > 255
         then
             SQL_MySQL:= 'text'
         else
             SQL_MySQL:= SQL_MySQL+'('+Longueur+')';
         end;
       else
         Longueur:= IntToStr( ColLength);
       end;
     Champs.Ajoute_String( sObligatoire, 'Obligatoire', False);
     Champs.Ajoute_String( Longueur    , 'Longueur'   , False);
     Champs.Ajoute_String( SQL         , 'SQL'        , False);
     Champs.Ajoute_String( SQL_MySQL   , 'SQL_MySQL'  , False);
end;

destructor TblSYSCOLUMNS.Destroy;
begin

     inherited;
end;

class function TblSYSCOLUMNS.sCle_from_( _colname: String; _tabid: Integer): String;
begin                               
     Result:=  Fixe_Min( _colname, 18) +  IntToStr(_tabid);
end;

function TblSYSCOLUMNS.sCle: String;
begin
     Result:= sCle_from_( colname, tabid);
end;

function TblSYSCOLUMNS.Is_NCHAR: Boolean;
begin
     Result:=    (ColType = ct_NCHAR0 )
              or (ColType = ct_NCHAR15);
end;

end.


