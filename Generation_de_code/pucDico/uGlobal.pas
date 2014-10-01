unit uGlobal;
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
    SysUtils, Classes;

const
     s_Nom_de_la_table = 'Nom_de_la_table';
     s_Nom_de_la_classe= 'Nom_de_la_classe';
     s_SQL_saut= ''''#13#10'      ''';

function CalculeSaisi_from_ClassName( ClassName: String): Boolean;

function NomTable_from_ClassName( ClassName: String): String;

function TailleNom( S: String): String;

function SQL_from_Type( Typ: String): String;

var
   slLog: TStringList;
   Premiere_Classe: Boolean;
   S: String;

function CS_from_Type( NomChamp, Typ: String): String;

function PHP_from_Type( NomChamp, Typ: String): String;

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

function SQL_from_Type( Typ: String): String;
begin
     Typ:= UpperCase( Typ);
          if'STRING'    =Typ then Result:='CHAR( 42) '
     else if'INTEGER'   =Typ then Result:='INTEGER   '
     else if'DATE'      =Typ then Result:='DATE      '
     else if'TDATETIME' =Typ then Result:='DATETIME  '
     else if'CURRENCY'  =Typ then Result:='DOUBLE    '
     else if'FLOAT'     =Typ then Result:='DOUBLE    '
     else if'GRAPHIC'   =Typ then Result:='MEDIUMBLOB'
     else if'MEMO'      =Typ then Result:='TEXT      '
     else
         begin
         Result:= Typ;
         slLog.Add( 'Type non traduit en SQL: '+Typ);
         end;
end;

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
initialization
              slLog:= TStringList.Create; 
finalization
               FreeAndNil( slLog       );
end.
