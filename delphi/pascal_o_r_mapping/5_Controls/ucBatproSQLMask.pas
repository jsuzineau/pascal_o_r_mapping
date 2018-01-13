unit ucBatproSQLMask;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    u_sys_,
    uSGBD,
    uuStrings,
    uDataUtilsU,
    uParametre,
    ufAccueil_Erreur,
  SysUtils, Classes, FMX.Controls, StdCtrls;

type
 TBatproSQLMask
 =
  class(TEdit, IParametre)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
  //Méthodes
  protected
    procedure Loaded; override;
  //Contrainte SQL
  private
    function Traite_Inf_Sup(S: String): String;
    function Traite_BETWEEN(S: String; Pos_2points: Integer): String;
  public
    function SQLConstraint: String;
  //Paramètre
  public
    function Parametre: String;
  //Fieldname
  private
    FFieldName: String;
  published
    property b0_FieldName: String read FFieldName write FFieldName;
  //Doc
  private
    FDoc: TMemo;
  published
    property b2_Doc: TMemo read FDoc write FDoc;
  //Label
  private
    FLabel: TLabel;
  published
    property b3_Label: TLabel read FLabel write FLabel;
  //Libellé
  private
    FLibelle: String;
  published
    property b4_Libelle: String read FLibelle write FLibelle;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents( 'Batpro', [TBatproSQLMask]);
end;

constructor TBatproSQLMask.Create( AOwner: TComponent);
begin
     inherited;
     Font.Family:= 'Courier New';
     Font.Size:= 8;
     Width:= 183;
     FDoc:= nil;
end;

procedure TBatproSQLMask.Loaded;
var
   sDeb, sFin, sSGBD: String;
begin
     inherited;
     if Assigned( FDoc)
     then
         begin
         sDeb:= 'Syntaxe pour les masques:'+#13#10+
                '- si commence par  < ou >: test inférieur/supérieur'+#13#10+
                '  Exemple: ">= 2"'+#13#10+
                '- si contient le caractère ":" : BETWEEN'+#13#10+
                '  Exemple: "01.01.03:01.02.03"'+#13#10;
         case SGBD
         of
           sgbd_Informix:
             sSGBD
             :=
               '- si contient le caractère "*" : MATCHES de INFORMIX'+#13#10+
               '  Exemple: "31*"'+#13#10;
           sgbd_MySQL:
             sSGBD
             :=
               '- si contient le caractère "*" : REGEXP de MySQL'+#13#10+
               '  Exemple: "^TOUL.*" pour ce qui commence par TOUL'+#13#10;
           sgbd_Postgres:
             sSGBD
             :=
               '- si contient le caractère "%" : SIMILAR TO de Postgres'+#13#10+
               '  Exemple: "TOUL%" pour ce qui commence par TOUL'+#13#10;
           else
               SGBD_non_gere('TBatproSQLMask.Loaded');
           end;

         sFin:= '- sinon: test d''égalité'+#13#10+
                '  Exemple: "T"';
         FDoc.Text:= sDeb+ sSGBD + sFin;
         end;
end;

function TBatproSQLMask.Traite_Inf_Sup( S: String): String;
var
   LS: Integer;
   Operateur, Valeur: String;
begin
     Result:= sys_Vide;
     LS:= Length( S);
     if LS < 2 then exit;

     if S[2] = '='
     then
         begin
         Operateur:= Copy( S, 1, 2 );
         Valeur   := Copy( S, 3, LS);
         end
     else
         begin
         Operateur:= Copy( S, 1, 1 );
         Valeur   := Copy( S, 2, LS);
         end;

     Result:= SQL_OP( FFieldName, Operateur, Valeur);
end;

function TBatproSQLMask.Traite_BETWEEN( S: String; Pos_2points: Integer):String;
var
   Valeur1, Valeur2: String;
begin
     Valeur1:= Copy( S, 1, Pos_2points-1);
     Valeur2:= Copy( S, Pos_2points+1, Length(S));
     Result:= SQL_BETWEEN( FFieldName, Valeur1, Valeur2);
end;

function TBatproSQLMask.SQLConstraint: String;
var
   S: String;
   Pos_2points: Integer;
begin
     Result:= sys_Vide;

     S:= Text;
     if S = sys_Vide then exit;

     case S[1]
     of
       '<','>': Result:= Traite_Inf_Sup( S);
       else
         begin
         Pos_2points:= Pos(':', S);
              if Pos_2points > 0
         then
             Result:= Traite_BETWEEN( S, Pos_2points)
         else if (Pos('*', S) > 0) and (SGBD in [sgbd_Informix, sgbd_MySQL])
         then
             begin
             case SGBD
             of
               sgbd_Informix: Result:= SQL_MATCHES   ( FFieldName, S);
               sgbd_MySQL   : Result:= SQL_REGEXP    ( FFieldName, S);
               end;
             end
         else if (Pos('%', S) > 0) and sgbdPOSTGRES
         then
             Result:= SQL_SIMILAR_TO( FFieldName, S) //Postgres
         else
             Result:= SQL_EGAL      ( FFieldName, S);
         end;
       end;
end;

function TBatproSQLMask.Parametre: String;
var
   L: String;
begin
     Result:= Text;
     if '' = Result then exit;
     if nil = b3_Label
     then
         L:= b4_Libelle
     else
         L:= b3_Label.Caption;

     Result:= L+' '+Result;
end;

end.
