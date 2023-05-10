unit uInformix_Column;

interface

uses
    SysUtils,
    u_sys_;
    
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
 TInformix_Column
 =
  class
  public
    ColType  : Integer;
    ColLength: Integer;
    bObligatoire: Boolean;
    sObligatoire: String;
    sType       : String;
    Longueur: String;
    //pour ct_MONEY, ct_DECIMAL
    Precision, Scale: Integer;
    //pour ct_NVARCHAR
    Min_space, Max_size: Integer;
    //pour ct_DATETIME, ct_INTERVAL
    Len, Largest_qualifier_value, Smallest_qualifier_value: Integer;
    sLargest_qualifier_value,
    sSmallest_qualifier_value: String;
    SQL: String;
    procedure Set_To( aColType, aColLength: Integer);
    function Is_NCHAR: Boolean;
  end;

implementation
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

procedure TInformix_Column.Set_To( aColType, aColLength: Integer);
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
     ColType  := aColType  ;
     ColLength:= aColLength;

     bObligatoire:= ColType >= 256;

     if bObligatoire
     then
         sObligatoire:= 'O'
     else
         sObligatoire:= 'N';

     ColType:= ColType mod 256;

     SQL:= sys_Vide;
     case ColType
     of
       ct_NCHAR0    : begin sType:= 'NCHAR     '; SQL:= 'CHAR'      ; end;
       ct_SMALLINT  : begin sType:= 'SMALLINT  '; SQL:= 'SMALLINT'  ; end;
       ct_INTEGER   : begin sType:= 'INTEGER   '; SQL:= 'INTEGER'   ; end;
       ct_FLOAT     : begin sType:= 'FLOAT     '; SQL:= 'FLOAT'     ; end;
       ct_SMALLFLOAT: begin sType:= 'SMALLFLOAT'; SQL:= 'SMALLFLOAT'; end;
       ct_DECIMAL   : begin sType:= 'DECIMAL   '; SQL:= 'DECIMAL'   ; end;
       ct_SERIAL    : begin sType:= 'SERIAL    '; SQL:= 'SERIAL'    ; end;
       ct_DATE      : begin sType:= 'DATE      '; SQL:= 'DATE'      ; end;
       ct_MONEY     : begin sType:= 'MONEY     '; SQL:= 'MONEY'     ; end;
       ct_DATETIME  : begin sType:= 'DATETIME  '; SQL:= 'DATETIME'  ; end;
       ct_BYTE      : begin sType:= 'BYTE      '; SQL:= 'BYTE'      ; end;
       ct_TEXT      : begin sType:= 'TEXT      '; SQL:= 'TEXT'      ; end;
       ct_NVARCHAR13: begin sType:= 'NVARCHAR13'; SQL:= 'VARCHAR'   ; end;
       ct_INTERVAL  : begin sType:= 'INTERVAL  '; SQL:= 'INTERVAL'  ; end;
       ct_NCHAR15   : begin sType:= 'NCHAR   15'; SQL:= 'CHAR'      ; end;
       ct_NVARCHAR16: begin sType:= 'NVARCHAR16'; SQL:= 'VARCHAR'   ; end;
       else           begin sType:= 'INCONNU   '; SQL:= ''          ; end;
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
         SQL:= SQL+Format('(%d,%d)',[Precision, Scale]);
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
             ColLength:= ColLength + 65536;
             Min_space:= ColLength div 256;
             Max_size := ColLength mod 256;
             end;
         Longueur:= Format( 'Min_space:%d,Max_size:%d', [Min_space, Max_size]);
         SQL:= SQL+Format('(%d,%d)',[Max_size, Min_space]);
         end;
       ct_DATETIME  ,
       ct_INTERVAL  :
         begin
         //collength = (length * 256) +
         //            (largest_qualifier_value * 16) + smallest_qualifier_value
         Len:= ColLength div 256;
         ColLength:= ColLength mod 256;
          Largest_Qualifier_Value:= ColLength div 16;
         Smallest_Qualifier_Value:= ColLength mod 16;
          sLargest_Qualifier_Value:=sDateTimeQualifier( Largest_Qualifier_Value);
         sSmallest_Qualifier_Value:=sDateTimeQualifier(Smallest_Qualifier_Value);
         Longueur:= Format( '%d,%s to %s',
                            [ Len,
                               sLargest_Qualifier_Value,
                              sSmallest_Qualifier_Value]);
         SQL:= SQL+Format( ' %s TO %s',
                           [sLargest_Qualifier_Value, sSmallest_Qualifier_Value]);
         end;
       ct_NCHAR0 ,
       ct_NCHAR15:
         begin
         Longueur:= IntToStr( ColLength);
         SQL:= SQL+'('+Longueur+')';
         end;
       else
         Longueur:= IntToStr( ColLength);
       end;

     ColLength:= aColLength;
end;

function TInformix_Column.Is_NCHAR: Boolean;
begin
     Result:=    (ColType = ct_NCHAR0 )
              or (ColType = ct_NCHAR15);
end;

end.
