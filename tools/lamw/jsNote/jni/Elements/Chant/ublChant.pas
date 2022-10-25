unit ublChant;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uClean,
    uChamp,
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type


 { TblChant }

 TblChant
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Titre: String;
    n1: String;
    n2: String;
    n3: String;
    n4: String;
  //Champs calculés
  private
    function t_from_n( _n: String): String;
  public
    Ft1: String; ct1: TChamp;
    Ft2: String; ct2: TChamp;
    Ft3: String; ct3: TChamp;
    Ft4: String; ct4: TChamp;
    function t1: String;
    function t2: String;
    function t3: String;
    function t4: String;
    procedure t1GetChaine( var _Chaine: String);
    procedure t2GetChaine( var _Chaine: String);
    procedure t3GetChaine( var _Chaine: String);
    procedure t4GetChaine( var _Chaine: String);
    procedure n1_Change;
    procedure n2_Change;
    procedure n3_Change;
    procedure n4_Change;
  //Gestion de la clé
  public
    function sCle: String; override;
  end;

 TIterateur_Chant
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblChant);
    function  not_Suivant( out _Resultat: TblChant): Boolean;
  end;

 TslChant
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
    function Iterateur: TIterateur_Chant;
    function Iterateur_Decroissant: TIterateur_Chant;
  end;

function blChant_from_sl( sl: TBatpro_StringList; Index: Integer): TblChant;
function blChant_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblChant;

implementation

function blChant_from_sl( sl: TBatpro_StringList; Index: Integer): TblChant;
begin
     _Classe_from_sl( Result, TblChant, sl, Index);
end;

function blChant_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblChant;
begin
     _Classe_from_sl_sCle( Result, TblChant, sl, sCle);
end;

{ TIterateur_Chant }

function TIterateur_Chant.not_Suivant( out _Resultat: TblChant): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Chant.Suivant( out _Resultat: TblChant);
begin
     Suivant_interne( _Resultat);
end;

{ TslChant }

constructor TslChant.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblChant);
end;

destructor TslChant.Destroy;
begin
     inherited;
end;

class function TslChant.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Chant;
end;

function TslChant.Iterateur: TIterateur_Chant;
begin
     Result:= TIterateur_Chant( Iterateur_interne);
end;

function TslChant.Iterateur_Decroissant: TIterateur_Chant;
begin
     Result:= TIterateur_Chant( Iterateur_interne_Decroissant);
end;



{ TblChant }

constructor TblChant.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Chant';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Chant';

     //champs persistants
     Champs.  String_from_String ( Titre, 'Titre');
     Champs.  String_from_String ( n1   , 'n1'   ).OnChange.Abonne( Self, n1_Change);
     Champs.  String_from_String ( n2   , 'n2'   ).OnChange.Abonne( Self, n2_Change);
     Champs.  String_from_String ( n3   , 'n3'   ).OnChange.Abonne( Self, n3_Change);
     Champs.  String_from_String ( n4   , 'n4'   ).OnChange.Abonne( Self, n4_Change);

     //champs calculés
     ct1:= Champs.Ajoute_String( Ft1, 't1', False);
     ct2:= Champs.Ajoute_String( Ft2, 't2', False);
     ct3:= Champs.Ajoute_String( Ft3, 't3', False);
     ct4:= Champs.Ajoute_String( Ft4, 't4', False);
     ct1.OnGetChaine:= t1GetChaine;
     ct2.OnGetChaine:= t2GetChaine;
     ct3.OnGetChaine:= t3GetChaine;
     ct4.OnGetChaine:= t4GetChaine;

end;

destructor TblChant.Destroy;
begin

     inherited;
end;

function TblChant.t_from_n( _n: String): String;
var
   voix: string;
   c: Char;
begin
     voix:= StrToK( ':', _n);
     for c in voix
     do
       case c
       of
         'p': Formate_Liste( Result, LineEnding, 'Principale');
         's': Formate_Liste( Result, LineEnding, 'Soprano'   );
         'a': Formate_Liste( Result, LineEnding, 'Alto'      );
         't': Formate_Liste( Result, LineEnding, 'Tenor'     );
         'b': Formate_Liste( Result, LineEnding, 'Basse'     );
         end;
end;

function TblChant.t1: String; begin Ft1:= t_from_n( n1);Result:= Ft1; end;
function TblChant.t2: String; begin Ft2:= t_from_n( n2);Result:= Ft2; end;
function TblChant.t3: String; begin Ft3:= t_from_n( n3);Result:= Ft3; end;
function TblChant.t4: String; begin Ft4:= t_from_n( n4);Result:= Ft4; end;

procedure TblChant.t1GetChaine(var _Chaine: String); begin _Chaine:= t1;end;
procedure TblChant.t2GetChaine(var _Chaine: String); begin _Chaine:= t2;end;
procedure TblChant.t3GetChaine(var _Chaine: String); begin _Chaine:= t3;end;
procedure TblChant.t4GetChaine(var _Chaine: String); begin _Chaine:= t4;end;

procedure TblChant.n1_Change;begin ct1.onChange.Publie;end;
procedure TblChant.n2_Change;begin ct2.onChange.Publie;end;
procedure TblChant.n3_Change;begin ct3.onChange.Publie;end;
procedure TblChant.n4_Change;begin ct4.onChange.Publie;end;

function TblChant.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


