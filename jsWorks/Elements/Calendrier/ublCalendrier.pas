unit ublCalendrier;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    u_sys_,
    uReels,
    uuStrings,
    uBatpro_StringList,
    uChamp,
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,
    ublWork,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upoolWork,

  SysUtils, Classes, sqldb, DB;

type

 { TWork_Cumul }

 TWork_Cumul
 =
  object
  //Attributs
  public
    Total: TDateTime;
    Depassement: TDateTime;
  //Methodes
  public
    procedure Zero;
    procedure Add_Total( _Total: TDateTime);
    procedure Add_Depassement( _Depassement: TDateTime);
    function To_String: String;
    function To_String_arrondi: String;
  end;

 { TCalendrier_Cumul }

 TCalendrier_Cumul
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Cumul
  public
    Cumul: TWork_Cumul;
  //Champs
  public
    cTotal: TChamp;
    cDepassement: TChamp;
    procedure Total_GetChaine( var _Chaine: String);
    procedure Depassement_GetChaine( var _Chaine: String);
  //Log
  public
    function sLog: String;
  end;

 { TblCalendrier }

 TblCalendrier
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Gestion de la clé
  public
    function sCle: String; override;
    class function sCle_from_( _D: TDateTime): String;
  //Date
  private
    cD: TChamp;
    procedure D_GetChaine( var _Chaine: String);
  public
    D: Integer;
  //Cumuls
  private
    procedure Ajout_Cumul( out _Cumul: TCalendrier_Cumul; _Prefixe: String);
  public
    Cumul_Jour, Cumul_Semaine, Cumul_Global: TCalendrier_Cumul;
  //BoldLine
  public
    BoldLine: Boolean;
    procedure BoldLine_from_D;
  end;

 TIterateur_Calendrier
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblCalendrier);
    function  not_Suivant( var _Resultat: TblCalendrier): Boolean;
  end;

 TslCalendrier
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
    function Iterateur: TIterateur_Calendrier;
    function Iterateur_Decroissant: TIterateur_Calendrier;
  end;


function blCalendrier_from_sl( sl: TBatpro_StringList; Index: Integer): TblCalendrier;
function blCalendrier_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCalendrier;

var
   ublCalendrier_Heures_Supplementaires: Boolean= False;

implementation

function blCalendrier_from_sl( sl: TBatpro_StringList; Index: Integer): TblCalendrier;
begin
     _Classe_from_sl( Result, TblCalendrier, sl, Index);
end;

function blCalendrier_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCalendrier;
begin
     _Classe_from_sl_sCle( Result, TblCalendrier, sl, sCle);
end;

{ TWork_Cumul }

procedure TWork_Cumul.Zero;
begin
     Total:= 0;
     Depassement:= 0;
end;

procedure TWork_Cumul.Add_Total(_Total: TDateTime);
begin
     Total:= Total+ _Total;
end;

procedure TWork_Cumul.Add_Depassement(_Depassement: TDateTime);
begin
     Depassement:= Depassement + _Depassement;
end;

function TWork_Cumul.To_String: String;
begin
     Result:= sNb_Heures_from_DateTime( Total);
     if (Depassement <> 0) and ublCalendrier_Heures_Supplementaires
     then
         Result:= Result +'(HS:'+sNb_Heures_from_DateTime( Depassement)+')';
end;

function TWork_Cumul.To_String_arrondi: String;
begin
     Result:= sNb_Heures_Arrondi_from_DateTime( Total);
end;

{ TCalendrier_Cumul }

constructor TCalendrier_Cumul.Create;
begin
     inherited;
     cTotal      := nil;
     cDepassement:= nil;
end;

destructor TCalendrier_Cumul.Destroy;
begin
     inherited Destroy;
end;

procedure TCalendrier_Cumul.Total_GetChaine(var _Chaine: String);
begin
     _Chaine:= '';
     if Reel_Zero( Cumul.Total) then exit;
      //_Chaine:= sNb_Heures_from_DateTime( Cumul.Total);
      _Chaine:= FloatToStrF( Cumul.Total*24, ffFixed, 0, 2);
end;

procedure TCalendrier_Cumul.Depassement_GetChaine(var _Chaine: String);
begin
     _Chaine:= '';
     if Reel_Zero( Cumul.Depassement) then exit;
     //_Chaine:= sNb_Heures_from_DateTime( Cumul.Depassement);
     _Chaine:= FloatToStrF( Cumul.Depassement*24, ffFixed, 0, 2);
end;

function TCalendrier_Cumul.sLog: String;
begin
     Result
     :=
           'Durée:'       +cTotal      .asString
       + ', Dépassement: '+cDepassement.asString;
end;

{ TIterateur_Calendrier }

function TIterateur_Calendrier.not_Suivant( var _Resultat: TblCalendrier): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Calendrier.Suivant( var _Resultat: TblCalendrier);
begin
     Suivant_interne( _Resultat);
end;

{ TslCalendrier }

constructor TslCalendrier.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblCalendrier);
end;

destructor TslCalendrier.Destroy;
begin
     inherited;
end;

class function TslCalendrier.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Calendrier;
end;

function TslCalendrier.Iterateur: TIterateur_Calendrier;
begin
     Result:= TIterateur_Calendrier( Iterateur_interne);
end;

function TslCalendrier.Iterateur_Decroissant: TIterateur_Calendrier;
begin
     Result:= TIterateur_Calendrier( Iterateur_interne_Decroissant);
end;

{ TblCalendrier }

constructor TblCalendrier.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Calendrier';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= '';

     cD:= Ajoute_Integer( D, 'D', False);
     cD.OnGetChaine:= D_GetChaine;

     Ajout_Cumul( Cumul_Jour   , 'Cumul_Jour'   );
     Ajout_Cumul( Cumul_Semaine, 'Cumul_Semaine');
     Ajout_Cumul( Cumul_Global , 'Cumul_Global' );

     Ajoute_Boolean( BoldLine, 'BoldLine', False);
     cD.OnChange.Abonne( Self, BoldLine_from_D);
end;

destructor TblCalendrier.Destroy;
begin
     Free_nil( Cumul_Jour);
     Free_nil( Cumul_Semaine);
     Free_nil( Cumul_Global);
     inherited;
end;

function TblCalendrier.sCle: String;
begin
     Result:= sCle_from_( D);
end;

class function TblCalendrier.sCle_from_(_D: TDateTime): String;
begin
     Result:= IntToHex( Trunc( _D), 8);
end;

procedure TblCalendrier.D_GetChaine(var _Chaine: String);
begin
     _Chaine:= FormatDateTime( 'ddd dd/mm', D);
end;

procedure TblCalendrier.Ajout_Cumul( out _Cumul: TCalendrier_Cumul; _Prefixe: String);
var
   Prefixe: String;
begin
     Prefixe:= _Prefixe + '_';

     _Cumul:= TCalendrier_Cumul.Create;

     _Cumul.cTotal:= Ajoute_Float( _Cumul.Cumul.Total, Prefixe+'Total', False);
     _Cumul.cTotal.OnGetChaine:= _Cumul.Total_GetChaine;

     _Cumul.cDepassement:= Ajoute_Float( _Cumul.Cumul.Depassement, Prefixe+'Depassement', False);
     _Cumul.cDepassement.OnGetChaine:= _Cumul.Depassement_GetChaine;
end;

procedure TblCalendrier.BoldLine_from_D;
begin
     BoldLine:= 2 = DayOfWeek( D);
end;

end.


