unit uContexteMembre;
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
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
  SysUtils, Classes;

type
 TContexteMembre
 =
  class
  //Attributs
  public
    g: TGenerateur_de_code_Ancetre;
    cc: TContexteClasse;
    sNomChamp: String;
    sNomChamp_database: String;
    sNomChamp_database_quote: String;
    sTypChamp: String;
    sTypChamp_UPPERCASE: String;
    sTyp: String;
    sLibelle: String;
    sParametre: String;
    Belongs_to_sCle: Boolean;
    CleEtrangere: Boolean;

    //Pascal
    sPascal_DeclarationParametre: String;
    s_bl: String;
    s_pool: String;
    s_fcb: String;
    s_NomAggregation: String;

    //CSharp
    sNomTableMembre: String;
    Member_Name: String;
    sDetail: String;

  //Gestion du cycle de vie
  public
    constructor Create( _g: TGenerateur_de_code_Ancetre; _cc: TContexteClasse; _sNomChamp, _sTypChamp, _sLibelle: String; _CleEtrangere: Boolean= False);
  end;


implementation

{ TContexteMembre }

constructor TContexteMembre.Create( _g: TGenerateur_de_code_Ancetre; _cc: TContexteClasse; _sNomChamp, _sTypChamp, _sLibelle: String; _CleEtrangere: Boolean= False);
begin
     g:= _g;
     cc:= _cc;
     sNomChamp:= _sNomChamp;
     sNomChamp_database:= sNomChamp;
     sNomChamp_database_quote:= '`'+sNomChamp_database+'`';
     sNomChamp:= StringReplace( sNomChamp, ' ', '_', [rfReplaceAll]);
     sNomChamp:= StringReplace( sNomChamp, '-', '_', [rfReplaceAll]);
     sNomChamp:= StringReplace( sNomChamp, '(', '_', [rfReplaceAll]);
     sNomChamp:= StringReplace( sNomChamp, ')', '_', [rfReplaceAll]);
     sNomChamp:= StringReplace( sNomChamp, '''', '_', [rfReplaceAll]);

     sTypChamp:= _sTypChamp;
     sLibelle := _sLibelle;
     if sLibelle= '' then sLibelle:= sNomChamp;
     CleEtrangere:= _CleEtrangere;

     sTypChamp_UPPERCASE:= UpperCase( sTypChamp);
     sTyp:= sTypChamp;
          if'NCHAR'      =sTypChamp_UPPERCASE then sTyp:='String'
     else if'TEXT'       =sTypChamp_UPPERCASE then sTyp:='String'
     else if'SMALLINT'   =sTypChamp_UPPERCASE then sTyp:='Integer'
     else if'SERIAL'     =sTypChamp_UPPERCASE then sTyp:='Integer'
     else if'DECIMAL'    =sTypChamp_UPPERCASE then sTyp:='Double'
     else if'FLOAT'      =sTypChamp_UPPERCASE then sTyp:='Double'
     else if'LONGBLOB'   =sTypChamp_UPPERCASE then sTyp:='String'
     else if'NVARCHAR13' =sTypChamp_UPPERCASE then sTyp:='String'
     else if'DATE'       =sTypChamp_UPPERCASE then sTyp:='TDateTime'
     else if'GRAPHIC'    =sTypChamp_UPPERCASE then sTyp:='String'
     else if'MEMO'       =sTypChamp_UPPERCASE then sTyp:='String';

     Belongs_to_sCle:= -1 <> cc.slCle.IndexOf( sNomChamp);

     sParametre:= ' _'+sNomChamp;
     sPascal_DeclarationParametre:= sParametre+': '+sTyp;
     s_bl  := 'bl' + TailleNom( sTyp);
     s_pool:= 'pool' + TailleNom( sTyp);
     s_fcb     := 'fcb'  + sTyp;
     s_NomAggregation:= 'bl'+ TailleNom( sNomChamp);

     sNomTableMembre:= sTyp;
     Member_Name:= sNomchamp;
end;

end.
