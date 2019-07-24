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

 { TContexteMembre }

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
    sTyp_TS: String;
    sLibelle: String;
    sParametre: String;
    Belongs_to_sCle: Boolean;
    CleEtrangere: Boolean;

    //Pascal
    sPascal_DeclarationChamp: String;
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
  //Méthodes internes
  private
    procedure Traite_NCHAR      ;
    procedure Traite_TEXT       ;
    procedure Traite_STRING     ;
    procedure Traite_SMALLINT   ;
    procedure Traite_INTEGER    ;
    procedure Traite_SERIAL     ;
    procedure Traite_DECIMAL    ;
    procedure Traite_FLOAT      ;
    procedure Traite_LONGBLOB   ;
    procedure Traite_NVARCHAR13 ;
    procedure Traite_DATE       ;
    procedure Traite_TDATETIME  ;
    procedure Traite_GRAPHIC    ;
    procedure Traite_MEMO       ;
  //Recherche/remplacement par les valeurs dans un modèle
  public
    function Produit( _Prefixe, _sModele: String): String;
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
     sTyp               := sTypChamp;
     sTyp_TS            := sTypChamp;

          if'NCHAR'      =sTypChamp_UPPERCASE then Traite_NCHAR
     else if'TEXT'       =sTypChamp_UPPERCASE then Traite_TEXT
     else if'STRING'     =sTypChamp_UPPERCASE then Traite_STRING
     else if'SMALLINT'   =sTypChamp_UPPERCASE then Traite_SMALLINT
     else if'INTEGER'    =sTypChamp_UPPERCASE then Traite_INTEGER
     else if'SERIAL'     =sTypChamp_UPPERCASE then Traite_SERIAL
     else if'DECIMAL'    =sTypChamp_UPPERCASE then Traite_DECIMAL
     else if'FLOAT'      =sTypChamp_UPPERCASE then Traite_FLOAT
     else if'LONGBLOB'   =sTypChamp_UPPERCASE then Traite_LONGBLOB
     else if'NVARCHAR13' =sTypChamp_UPPERCASE then Traite_NVARCHAR13
     else if'DATE'       =sTypChamp_UPPERCASE then Traite_DATE
     else if'TDATETIME'  =sTypChamp_UPPERCASE then Traite_TDATETIME
     else if'GRAPHIC'    =sTypChamp_UPPERCASE then Traite_GRAPHIC
     else if'MEMO'       =sTypChamp_UPPERCASE then Traite_MEMO      ;

     Belongs_to_sCle:= -1 <> cc.slCle.IndexOf( sNomChamp);

     sParametre:= ' _'+sNomChamp;
     sPascal_DeclarationChamp    := sNomChamp +': '+sTyp;
     sPascal_DeclarationParametre:= sParametre+': '+sTyp;
     s_bl  := 'bl' + TailleNom( sTyp);
     s_pool:= 'pool' + TailleNom( sTyp);
     s_fcb     := 'fcb'  + sTyp;
     s_NomAggregation:= 'bl'+ TailleNom( sNomChamp);

     sNomTableMembre:= sTyp;
     Member_Name:= sNomchamp;
end;

procedure TContexteMembre.Traite_NCHAR     ; begin sTyp:='String'   ;sTyp_TS:='string';end;
procedure TContexteMembre.Traite_TEXT      ; begin sTyp:='String'   ;sTyp_TS:='string';end;
procedure TContexteMembre.Traite_STRING    ; begin                   sTyp_TS:='string';end;
procedure TContexteMembre.Traite_SMALLINT  ; begin sTyp:='Integer'  ;sTyp_TS:='number';end;
procedure TContexteMembre.Traite_INTEGER   ; begin                   sTyp_TS:='number';end;
procedure TContexteMembre.Traite_SERIAL    ; begin sTyp:='Integer'  ;sTyp_TS:='number';end;
procedure TContexteMembre.Traite_DECIMAL   ; begin sTyp:='Double'   ;sTyp_TS:='number';end;
procedure TContexteMembre.Traite_FLOAT     ; begin sTyp:='Double'   ;sTyp_TS:='number';end;
procedure TContexteMembre.Traite_LONGBLOB  ; begin sTyp:='String'   ;sTyp_TS:='string';end;
procedure TContexteMembre.Traite_NVARCHAR13; begin sTyp:='String'   ;sTyp_TS:='string';end;
procedure TContexteMembre.Traite_DATE      ; begin sTyp:='TDateTime';sTyp_TS:='Date'  ;end;
procedure TContexteMembre.Traite_TDATETIME ; begin                   sTyp_TS:='Date'  ;end;//à surveiller, peut-être DateTime
procedure TContexteMembre.Traite_GRAPHIC   ; begin sTyp:='String'   ;sTyp_TS:='string';end;
procedure TContexteMembre.Traite_MEMO      ; begin sTyp:='String'   ;sTyp_TS:='string';end;

function TContexteMembre.Produit( _Prefixe, _sModele: String): String;
begin
     Result:= StringReplace( Result, _Prefixe+'Libelle'                    ,sLibelle                    ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'NomChamp_database'          ,sNomChamp_database          ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'NomChamp'                   ,sNomChamp                   ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'TypChamp_UPPERCASE'         ,sTypChamp_UPPERCASE         ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'TypChamp'                   ,sTypChamp                   ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'Typ_TS'                     ,sTyp_TS                     ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'Typ'                        ,sTyp                        ,[rfReplaceAll,rfIgnoreCase]);
end;

end.
