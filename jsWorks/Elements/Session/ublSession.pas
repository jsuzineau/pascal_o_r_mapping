unit ublSession;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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
    uuStrings,
    uBatpro_StringList,
    uChamp,
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,
    ublWork,
    ublCalendrier,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upoolWork,

  SysUtils, Classes, sqldb, DB;

type

 { ThaSession_Work }

 ThaSession_Work
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Work;
    function Iterateur_Decroissant: TIterateur_Work;
  //Libelle
  public
    function Libelle: String;
    function Duree: TDateTime;
    function Beginning: TDateTime;
    function End_: TDateTime;
  end;

 { TblSession }

 TblSession
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Work
  private
    FhaWork: ThaSession_Work;
    function  GethaWork: ThaSession_Work;
  public
    property haWork: ThaSession_Work read GethaWork;
  //Titre
  private
    FTitre: String;
    procedure Titre_GetChaine( var _Chaine: String);
    function GetTitre: String;
  public
    cTitre: TChamp;
    property Titre: String read GetTitre;
  //Pied
  private
    FPied: String;
    procedure Pied_GetChaine( var _Chaine: String);
    function GetPied: String;
  public
    cPied: TChamp;
    property Pied: String read GetPied;
  //Libelle
  private
    FLibelle: String;
    procedure Libelle_GetChaine( var _Chaine: String);
    function GetLibelle: String;
  public
    cLibelle: TChamp;
    property Libelle: String read GetLibelle;
  //Beginning
  private
    FBeginning: TDateTime;
    procedure Beginning_GetChaine( var _Chaine: String);
    function GetBeginning: TDateTime;
  public
    cBeginning: TChamp;
    property Beginning: TDateTime read GetBeginning;
  //End_
  private
    FEnd_: TDateTime;
    procedure End__GetChaine( var _Chaine: String);
    function GetEnd_: TDateTime;
  public
    cEnd_: TChamp;
    property End_: TDateTime read GetEnd_;
  //Libelle_date
  public
    Libelle_date: String;
    cLibelle_date: TChamp;
    procedure Libelle_date_GetChaine( var _Chaine: String);
  //Duree
  public
    function Duree: TDateTime;
    function sDuree: String;
  //Cumul Jour
  public
    Cumul_Jour: TWork_Cumul;
    FinJour: Boolean;
  //Cumul Semaine
  public
    Cumul_Semaine: TWork_Cumul;
    FinSemaine: Boolean;
  //Cumul Global
  public
    Cumul_Global: TWork_Cumul;
    FinGlobal: Boolean;
  end;

 TIterateur_Session
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblSession);
    function  not_Suivant( var _Resultat: TblSession): Boolean;
  end;

 TslSession
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
    function Iterateur: TIterateur_Session;
    function Iterateur_Decroissant: TIterateur_Session;
  end;


function blSession_from_sl( sl: TBatpro_StringList; Index: Integer): TblSession;
function blSession_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSession;

var
   ublSession_Ecrire_arrondi: Boolean= False;

implementation

function blSession_from_sl( sl: TBatpro_StringList; Index: Integer): TblSession;
begin
     _Classe_from_sl( Result, TblSession, sl, Index);
end;

function blSession_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSession;
begin
     _Classe_from_sl_sCle( Result, TblSession, sl, sCle);
end;

{ TIterateur_Session }

function TIterateur_Session.not_Suivant( var _Resultat: TblSession): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Session.Suivant( var _Resultat: TblSession);
begin
     Suivant_interne( _Resultat);
end;

{ TslSession }

constructor TslSession.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblSession);
end;

destructor TslSession.Destroy;
begin
     inherited;
end;

class function TslSession.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Session;
end;

function TslSession.Iterateur: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne);
end;

function TslSession.Iterateur_Decroissant: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne_Decroissant);
end;

{ TblSession }

constructor TblSession.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Session';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= '';

     cTitre:= Ajoute_String( FTitre,'Titre', False);
     cTitre.OnGetChaine:= Titre_GetChaine;

     cPied:= Ajoute_String( FPied,'Pied', False);
     cPied.OnGetChaine:= Pied_GetChaine;

     cLibelle:= Ajoute_String( FLibelle,'Libelle', False);
     cLibelle.OnGetChaine:= Libelle_GetChaine;

     cBeginning:= Ajoute_DateTime( FBeginning, 'Beginning', False);
     cBeginning.OnGetChaine:= Beginning_GetChaine;
     cEnd_:= Ajoute_DateTime( FEnd_, 'End_', False);
     cEnd_.OnGetChaine:= End__GetChaine;

     cLibelle_date:= Ajoute_String( Libelle_date,'Libelle_date', False);
     cLibelle_date.OnGetChaine:= Libelle_date_GetChaine;

     Cumul_Global.Zero;
     FinGlobal:= False;

     Cumul_Semaine.Zero;
     FinSemaine:= False;

     Cumul_Jour.Zero;
     FinJour:= False;
end;

destructor TblSession.Destroy;
begin

     inherited;
end;

function TblSession.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblSession.Create_Aggregation( Name: String;
                                         P: ThAggregation_Create_Params);
begin
     if 'Work' = Name then P.Faible( ThaSession_Work, TblWork, poolWork)
     else                  inherited Create_Aggregation( Name, P);
end;

function TblSession.GethaWork: ThaSession_Work;
begin
     if FhaWork = nil
     then
         FhaWork:= Aggregations['Work'] as ThaSession_Work;

     Result:= FhaWork;
end;

function TblSession.GetTitre: String;
begin
     Result
     :=
        FormatDateTime( 'dddd ddddd', Beginning)
       +' Session de '+FormatDateTime( 'hh:nn', Beginning)
       +' à ' +FormatDateTime( 'hh:nn', End_     )
       ;
end;

procedure TblSession.Titre_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetTitre;
end;

function TblSession.GetPied: String;
   procedure Ecrit_Cumul_Jour;
   var
      S: String;
   begin
        S:= '(Jour: '+Cumul_Jour.To_String;
        if ublSession_Ecrire_arrondi
        then
            S:= S+', a '+Cumul_Jour.To_String_arrondi;
        S:= S+')';
        Formate_Liste( Result, #13#10, S);
   end;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, '(Session: '+sDuree+')');
     if FinJour
     then
         Ecrit_Cumul_Jour;
     if FinSemaine
     then
         Formate_Liste( Result, #13#10, '(Semaine: '+Cumul_Semaine.To_String+')');

     if FinGlobal
     then
         Formate_Liste( Result, #13#10, '(Global: '+Cumul_Global.To_String+')');
end;

procedure TblSession.Pied_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetPied;
end;

procedure TblSession.Libelle_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetLibelle;
end;

function TblSession.GetLibelle: String;
begin
     FLibelle:= Titre;
     Formate_Liste_Indentation( FLibelle, #13#10, '  ', haWork.Libelle);
     Formate_Liste( FLibelle, #13#10, Pied);
     Result:= FLibelle;
end;

procedure TblSession.Beginning_GetChaine(var _Chaine: String);
begin
     GetBeginning;
     _Chaine:= FormatDateTime( 'dd"/"mm"/"yyyy hh:nn', Beginning);
end;

function TblSession.GetBeginning: TDateTime;
begin
     FBeginning:= haWork.Beginning;
     Result:= FBeginning;
end;

procedure TblSession.End__GetChaine(var _Chaine: String);
begin
     GetEnd_;
     _Chaine:= FormatDateTime( 'dd"/"mm"/"yyyy hh:nn', End_);
end;

function TblSession.GetEnd_: TDateTime;
begin
     FEnd_:= haWork.End_;
     Result:= FEnd_;
end;

procedure TblSession.Libelle_date_GetChaine(var _Chaine: String);
var
   Debut_Y, Debut_M, Debut_D: Word;
     Fin_Y,   Fin_M,   Fin_D: Word;
   procedure Cas_Meme_Jour;
   begin
        _Chaine
        :=
           FormatDateTime( 'ddd dd"/"mm"/"yyyy '#13#10'"de" hh:nn', FBeginning)
          + ' à '
          +FormatDateTime( 'hh:nn'                   , FEnd_     )
          ;
   end;
   procedure Cas_Meme_Mois;
   begin
        _Chaine
        :=
           FormatDateTime( 'ddd dd"/"mm"/"yyyy hh:nn', FBeginning)
          + #13#10' à '
          +FormatDateTime( 'ddd dd  hh:nn'       , FEnd_     )
          ;
   end;
   procedure Cas_Meme_Annee;
   begin
        _Chaine
        :=
           FormatDateTime( 'ddd dd"/"mm"/"yyyy hh:nn', FBeginning)
          + #13#10' à '
          +FormatDateTime( 'ddd dd"/"mm hh:nn'       , FEnd_     )
          ;
   end;
   procedure Cas_Different;//au cas où on y passe le réveillon ...
   begin
        _Chaine
        :=
           FormatDateTime( 'ddd dd"/"mm"/"yyyy hh:nn', FBeginning)
          + #13#10' à '
          +FormatDateTime( 'ddd dd"/"mm"/"yyyy hh:nn', FEnd_     )
          ;
   end;
begin
     //avant d'utiliser FBeginning et FEnd_ on s'assure de les mettre à jour
     FBeginning:= Beginning;
     FEnd_     := End_;

     DecodeDate( FBeginning, Debut_Y, Debut_M, Debut_D);
     DecodeDate( FEnd_     ,   Fin_Y,   Fin_M,   Fin_D);

          if Trunc( FBeginning) = Trunc( FEnd_) then Cas_Meme_Jour
     else if        Debut_M     =        Fin_M  then Cas_Meme_Mois
     else if        Debut_Y     =        Fin_Y  then Cas_Meme_Annee
     else                                            Cas_Different
        ;
end;

function TblSession.Duree: TDateTime;
begin
     Result:= haWork.Duree;
end;

function TblSession.sDuree: String;
begin
     Result:= FormatDateTime( 'hh:nn', Duree);
end;


{ ThaSession_Work }

constructor ThaSession_Work.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaSession_Work.Destroy;
begin
     inherited;
end;

class function ThaSession_Work.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

function ThaSession_Work.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function ThaSession_Work.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;

function ThaSession_Work.Libelle: String;
var
   I: TIterateur_Work;
   bl: TblWork;
begin
     Result:= '';

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       Formate_Liste( Result, #13#10, bl.sSession);
       end;
end;

function ThaSession_Work.Duree: TDateTime;
var
   I: TIterateur_Work;
   bl: TblWork;
begin
     Result:= 0;

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       Result:= Result + bl.Duree;
       end;
end;

function ThaSession_Work.Beginning: TDateTime;
var
   I: TIterateur_Work;
   bl: TblWork;
begin
     Result:= 0;

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       if    (Result = 0)
          or (bl.Beginning < Result)
       then
           Result:= bl.Beginning;
       end;
end;

function ThaSession_Work.End_: TDateTime;
var
   I: TIterateur_Work;
   bl: TblWork;
begin
     Result:= 0;

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       if    (Result = 0)
          or (bl.End_ > Result)
       then
           Result:= bl.End_;
       end;
end;

end.


