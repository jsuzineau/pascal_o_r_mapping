unit uGenerateur_de_code_Ancetre;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uuStrings,
  SysUtils, Classes;

const
     s_Nom_de_la_table = 'Nom_de_la_table';
     s_Nom_de_la_classe= 'Nom_de_la_classe';
     s_NomTableMinuscule= 'NomTableMinuscule';
     s_SQL_saut= ''''#13#10'      ''';
const
   TailleMaximumIdentificateur = 15;

function TailleNom( S: String): String;

var
   slLog: TStringList;
   Premiere_Classe: Boolean;
   S: String;

//General
function CalculeSaisi_from_ClassName( ClassName: String): Boolean;

function NomTable_from_ClassName( ClassName: String): String;

//SQL
function SQL_from_Type( Typ: String): String;
function Default_from_Type( Typ: String): String;

//Pascal
function Declaration_from_Type( prefixe, NomChamp, Typ: String): String;
function PAS_from_Type( prefixe, NomChamp, Typ: String): String;
function DFM_from_Type( prefixe, NomChamp, Typ: String; notVisible: Boolean): String;
function DFM_Lookup( prefixe, Member_Name, ClasseLookup: String): String;

//CSharp
function CS_from_Type( NomChamp, Typ: String): String;

//PHP
function PHP_from_Type( NomChamp, Typ: String): String;


type

 { TGenerateur_de_code_Ancetre }

 TGenerateur_de_code_Ancetre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    sRepSource, sRepCible, sRepParametres: String;
  //Méthodes
  public
    function dbx_from_Type( Typ: String): String;
    function TailleNom_Quote( S: String): String;
  end;

implementation

function CalculeSaisi_from_ClassName( ClassName: String): Boolean;
begin
     Result:= False;
     if ClassName = '' then exit;

     Result:= ClassName[1] = 'c';
end;

function NomTable_from_ClassName( ClassName: String): String;
begin
     Result:= ClassName;
     if CalculeSaisi_from_ClassName( ClassName)
     then
         Delete( Result, 1, 1);
end;

function TailleNom( S: String): String;
begin
     Result:= S;
     while Length( Result) < 15 do Result:= Result + ' ';
end;

function DFM_from_Type( prefixe, NomChamp, Typ: String; notVisible: Boolean): String;
begin
     Result
     :=
       '    object '+Declaration_from_Type( prefixe, NomChamp, Typ)+#13#10+
       '      FieldName = '''+NomChamp+''''#13#10;
     if notVisible
     then
         Result
         :=
             Result
           + '      Visible = False'#13#10;

     Typ:= UpperCase( Typ);
          if 'STRING'  =Typ then Result:= Result+'      Size = 42'#13#10
     else if 'CURRENCY'=Typ then Result:= Result+'      currency= true'#13#10;

     Result
     :=
       Result +
       '    end'#13#10;
end;

function DFM_Lookup( prefixe, Member_Name, ClasseLookup: String): String;
begin
     Result
     :=
       '    object '+Declaration_from_Type(prefixe,Member_Name,'STRING')+#13#10+
       '      FieldName = '''+Member_Name+'''                           '#13#10+
       '      FieldKind = fkLookup                                      '#13#10+
       '      LookupDataSet = dmlk'+ClasseLookup+'.q                    '#13#10+
       '      LookupKeyFields = ''rowid''                              '#13#10+
       '      LookupResultField = ''Libelle''                           '#13#10+
       '      KeyFields = ''n'+Member_Name+'''                          '#13#10+
       '      Lookup = True                                             '#13#10+
       '      Size = 42                                                 '#13#10+
       '    end                                                         '#13#10;
end;

function SQL_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:='CHAR( 42) '
     else if'INTEGER'   =Typ then Result:='INTEGER   '
     else if'DATE'      =Typ then Result:='DATE      '
     else if'TDATETIME' =Typ then Result:='DATETIME  '
     else if'CURRENCY'  =Typ then Result:='DOUBLE    '
     else if'FLOAT'     =Typ then Result:='DOUBLE    '
     else if'BOOLEAN'   =Typ then Result:='BOOLEAN   '
     else if'GRAPHIC'   =Typ then Result:='MEDIUMBLOB'
     else if'MEMO'      =Typ then Result:='TEXT      '
     else
         begin
         Result:= Typ;
         slLog.Add( 'Type non traduit en SQL: '+Typ);
         end;
end;

function Default_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:=''''''
     else if'SMALLINT'  =Typ then Result:='0'
     else if'INTEGER'   =Typ then Result:='0'
     else if'DATE'      =Typ then Result:='Date'
     else if'TDATETIME' =Typ then Result:='Date'
     else if'CURRENCY'  =Typ then Result:='0.0'
     else if'FLOAT'     =Typ then Result:='0.0'
     else if'BOOLEAN'   =Typ then Result:='False'
     else
         begin
         Result:= '''''';
         slLog.Add( 'Default_from_Type(): Type non géré '+Typ);
         end;
end;

//Pascal
function Declaration_from_Type( prefixe, NomChamp, Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'   =Typ then Result:=': TStringField'
     else if'SMALLINT' =Typ then Result:=': TIntegerField'
     else if'INTEGER'  =Typ then Result:=': TIntegerField'
     else if'DATE'     =Typ then Result:=': TDateField'
     else if'TDATETIME'=Typ then Result:=': TDateTimeField'
     else if'CURRENCY' =Typ then Result:=': TCurrencyField'
     else if'FLOAT'    =Typ then Result:=': TFloatField'
     else if'BOOLEAN'  =Typ then Result:=': TBooleanField'
     else if'LONGBLOB' =Typ then Result:=': TStringField'
     else
         begin
         Result:= ': T'+Typ+'Field';
         slLog.Add( 'Declaration_from_Type(): Type non traduit en champ: '+Typ);
         end;
     Result:= prefixe + NomChamp + Result;
end;

function PAS_from_Type( prefixe, NomChamp, Typ: String): String;
begin
     Result:='    ' + Declaration_from_Type(prefixe,NomChamp,Typ) + ';'#13#10;
end;

//CSharp
function CSType_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:='string'
     else if'INTEGER'   =Typ then Result:='Int32'
     else if'CLE'       =Typ then Result:='UInt32'
     else if'DATE'      =Typ then Result:='DateTime'
     else if'TDATETIME' =Typ then Result:='DateTime'
     else if'CURRENCY'  =Typ then Result:='double'
     else if'FLOAT'     =Typ then Result:='double'
     else if'BOOLEAN'   =Typ then Result:='Int32'
     else
         begin
         Result:= 'T'+Typ+'Field';
         slLog.Add( 'Type non traduit en champ: '+Typ);
         end;
end;

function PHPType_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:='string'
     else if'INTEGER'   =Typ then Result:='integer'
     else if'CLE'       =Typ then Result:='integer'
     else if'DATE'      =Typ then Result:='date'
     else if'TDATETIME' =Typ then Result:='float'
     else if'CURRENCY'  =Typ then Result:='float'
     else if'FLOAT'     =Typ then Result:='float'
     else if'BOOLEAN'   =Typ then Result:='integer'
     else
         begin
         Result:= 'T'+Typ+'Field';
         slLog.Add( 'PHPType_from_Type: Type non traduit en champ: '+Typ);
         end;
end;

function PHPTaille_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:='42'
     else if'INTEGER'   =Typ then Result:=''
     else if'CLE'       =Typ then Result:=''
     else if'DATE'      =Typ then Result:=''
     else if'TDATETIME' =Typ then Result:=''
     else if'CURRENCY'  =Typ then Result:=''
     else if'FLOAT'     =Typ then Result:=''
     else if'BOOLEAN'   =Typ then Result:=''
     else
         begin
         Result:= 'T'+Typ+'Field';
         slLog.Add( 'PHPType_from_Type: Type non traduit en champ: '+Typ);
         end;
end;

function CS_from_Type( NomChamp, Typ: String): String;
var
   CSType: String;
begin
     CSType:= CSType_from_Type( Typ);

     Result
     :=
       Format( '		public %0:s  %1:s;'#13#10
              +'		public %0:s _%1:s {get{return %1:s;} set{%1:s= value;}}'#13#10,
              [CSType, NomChamp]);

end;

function PHP_from_Type( NomChamp, Typ: String): String;
var
   PHPType, PHPTaille: String;
begin
     PHPType  :=   PHPType_from_Type( Typ);
     PHPTaille:= PHPTaille_from_Type( Typ);

     if PHPTaille = ''
     then
         Result
         :=
           Format( '        $this->hasColumn(''%0:s'', ''%1:s'');'#13#10,
                  [NomChamp, PHPType])
     else
         Result
         :=
           Format( '        $this->hasColumn(''%0:s'', ''%1:s'', %2:s);'#13#10,
                  [NomChamp, PHPType, PHPTaille]);

end;

{ TGenerateur_de_code_Ancetre }

constructor TGenerateur_de_code_Ancetre.Create;
begin

end;

destructor TGenerateur_de_code_Ancetre.Destroy;
begin
     inherited Destroy;
end;

function TGenerateur_de_code_Ancetre.dbx_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'   =Typ then Result:='  String_from_String '
     else if'SMALLINT' =Typ then Result:=' Integer_from_Integer'
     else if'INTEGER'  =Typ then Result:=' Integer_from_Integer'
     else if'DATE'     =Typ then Result:='DateTime_from_Date   '
     else if'TDATETIME'=Typ then Result:='DateTime_from_       '
     else if'CURRENCY' =Typ then Result:='Currency_from_       '
     else if'DOUBLE'   =Typ then Result:='  Double_from_       '
     else if'FLOAT'    =Typ then Result:='  Double_from_       '
     else if'BOOLEAN'  =Typ then Result:=' Boolean_from_       '
     else if'LONGBLOB' =Typ then Result:='  String_from_Blob   '
     else
         begin
         Result:= '''''';
         slLog.Add( 'Default_from_Type(): Type non géré '+Typ);
         end;
end;

function TGenerateur_de_code_Ancetre.TailleNom_Quote( S: String): String;
begin
     Result:= Fixe_Min( ''''+S+'''', TailleMaximumIdentificateur+2);
end;

initialization
              slLog:= TStringList.Create; 
finalization
               FreeAndNil( slLog       );
end.
