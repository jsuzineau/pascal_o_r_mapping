unit ublWork;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    uReels,
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,
    ublTag,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upoolTag,
    upoolTag_Work,

    SysUtils, Classes, sqldb, DB,DateUtils, Math;

type
  { ThaWork__Tag }
  ThaWork__Tag
  =
   class( ThAggregation)
   //Gestion du cycle de vie
   public
     constructor Create( _Parent: TBatpro_Element;
                         _Classe_Elements: TBatpro_Element_Class;
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
     destructor  Destroy; override;
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_Tag;
     function Iterateur_Decroissant: TIterateur_Tag;
   //déconnection d'un tag
   public
     procedure Supprime( _blTag: TblTag);
   end;

  { ThaWork__Tag_from_Description }
  ThaWork__Tag_from_Description
  =
   class( ThAggregation)
   //Gestion du cycle de vie
   public
     constructor Create( _Parent: TBatpro_Element;
                         _Classe_Elements: TBatpro_Element_Class;
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
     destructor  Destroy; override;
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_Tag;
     function Iterateur_Decroissant: TIterateur_Tag;
   //Valide
   public
     procedure Valide;
   end;

  { TblWork }

 TblWork
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    nUser: Integer;
    nProject: Integer;
    Beginning: TDateTime; cBeginning: TChamp;
    End_     : TDateTime; cEnd      : TChamp;
    Description: String;

  //Duree
  private
    FDuree: TDateTime;
    procedure Duree_GetChaine( var _Chaine: String);
    function GetDuree: TDateTime;
    function sDuree: String;
  public
    cDuree: TChamp;
    property Duree: TDateTime read GetDuree;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Tag correspondants
  private
    FhaTag: ThaWork__Tag;
    function GethaTag: ThaWork__Tag;
  public
    property haTag: ThaWork__Tag read GethaTag;
  //Aggrégation vers les Tag_from_Description correspondants
  private
    FhaTag_from_Description: ThaWork__Tag_from_Description;
    function GethaTag_from_Description: ThaWork__Tag_from_Description;
  public
    property haTag_from_Description: ThaWork__Tag_from_Description read GethaTag_from_Description;
  //Méthodes
  public
    procedure Stop;
  //Gestion des sessions
  private
    FsSession: String;
    procedure sSession_GetChaine( var _Chaine: String);
    function GetsSession: String;
  public
    csSession: TChamp;
    property sSession: String read GetsSession;
  //Session differente
  public
    function Session_Differente( _bl: TblWork): Boolean;
  //Semaine differente
  public
    function Semaine_Differente( _bl: TblWork): Boolean;
  //Jour different
  public
    function Jour_Different( _bl: TblWork): Boolean;
  //Tag
  public
    procedure Tag( _blTag: TblTag);
  end;

 TIterateur_Work
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblWork);
    function  not_Suivant( var _Resultat: TblWork): Boolean;
  end;

 TslWork
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
    function Iterateur: TIterateur_Work;
    function Iterateur_Decroissant: TIterateur_Work;
  end;

function sNb_Heures_from_DateTime( _dt: TDateTime): String;
function sNb_Heures_Arrondi_from_DateTime( _dt: TDateTime): String;

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;

implementation

function sNb_Heures_Arrondi_from_DateTime( _dt: TDateTime): String;
var
   NbHeures: double;
begin
     Result:= '';
     if Reel_Zero( _dt) then exit;

     NbHeures:= ceil(_dt*24*2)/2;
     Result
     :=
       FloatToStrF( NbHeures, ffFixed, 0, 2)+'h';
end;

function sNb_Heures_from_DateTime( _dt: TDateTime): String;
var
   NbHeures: double;
begin
     Result:= '';
     if Reel_Zero( _dt) then exit;

     NbHeures:= _dt*24;
     Result
     :=
       Format( '%d:%.2d,  %sh',
               [
                Trunc(NbHeures),
                Trunc(Frac(Abs(NbHeures))*60),
                FloatToStrF( NbHeures, ffFixed, 0, 2)
               ]);
end;

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
begin
     _Classe_from_sl( Result, TblWork, sl, Index);
end;

function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;
begin
     _Classe_from_sl_sCle( Result, TblWork, sl, sCle);
end;

{ ThaWork__Tag }

constructor ThaWork__Tag.Create( _Parent: TBatpro_Element;
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

destructor ThaWork__Tag.Destroy;
begin
     inherited;
end;

procedure ThaWork__Tag.Charge;
begin
     inherited Charge;
     poolTag.Charge_Work( TblWork(Parent).id, slCharge);
     Ajoute_slCharge;
end;

class function ThaWork__Tag.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag;
end;

function ThaWork__Tag.Iterateur: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne);
end;

function ThaWork__Tag.Iterateur_Decroissant: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);
end;

procedure ThaWork__Tag.Supprime( _blTag: TblTag);
begin
     if nil = _blTag then exit;
     poolTag_Work.Supprime( _blTag.id, TblWork(Parent).id);
     Enleve( _blTag);
end;

{ ThaWork__Tag_from_Description }

constructor ThaWork__Tag_from_Description.Create( _Parent: TBatpro_Element;
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

destructor ThaWork__Tag_from_Description.Destroy;
begin
     inherited;
end;

procedure ThaWork__Tag_from_Description.Charge;
begin
     sl.Clear;
     inherited Charge;
     TblWork(Parent).haTag.Charge;
     poolTag.Charge_Work_from_Description( TblWork(Parent).Description, slCharge, TblWork(Parent).haTag.sl);
     Ajoute_slCharge;
end;

class function ThaWork__Tag_from_Description.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag;
end;

function ThaWork__Tag_from_Description.Iterateur: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne);
end;

function ThaWork__Tag_from_Description.Iterateur_Decroissant: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);
end;

procedure ThaWork__Tag_from_Description.Valide;
var
   I: TIterateur_Tag;
   bl: TblTag;
begin
     Charge;
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       poolTag_Work.Assure( bl.id, TblWork(Parent).id);
       TblWork(Parent).haTag.Ajoute( bl);
       end;
     sl.Clear;
end;

{ TIterateur_Work }

function TIterateur_Work.not_Suivant( var _Resultat: TblWork): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Work.Suivant( var _Resultat: TblWork);
begin
     Suivant_interne( _Resultat);
end;

{ TslWork }

constructor TslWork.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblWork);
end;

destructor TslWork.Destroy;
begin
     inherited;
end;

class function TslWork.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

function TslWork.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function TslWork.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;

{ TblWork }

constructor TblWork.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Work';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Work';

     //champs persistants
     Integer_from_ ( nUser          , 'nUser'          );
     Integer_from_ ( nProject       , 'nProject'       );

     cBeginning:= DateTime_from_( Beginning      , 'Beginning'      );
     cBeginning.Definition.Format_DateTime:= 'yyyy/mm/dd" "hh:nn';

     cEnd:= DateTime_from_( End_           , 'End'            );
     cEnd.Definition.Format_DateTime:= 'yyyy/mm/dd" "hh:nn';

     String_from_Memo( Description    , 'Description'    );

     cDuree:= Ajoute_Float( FDuree, 'Duree', False);
     cDuree.OnGetChaine:= Duree_GetChaine;

     csSession:= Ajoute_String( FsSession,'sSession', False);
     csSession.OnGetChaine:= sSession_GetChaine;
end;

destructor TblWork.Destroy;
begin

     inherited;
end;

procedure TblWORK.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Tag' = Name then P.Faible( ThaWork__Tag, TblTag, poolTag)
     else if 'Tag_from_Description' = Name then P.Faible( ThaWork__Tag_from_Description, TblTag, poolTag)
     else                  inherited Create_Aggregation( Name, P);
end;

function  TblWORK.GethaTag: ThaWork__Tag;
begin
     if FhaTag = nil
     then
         FhaTag:= Aggregations['Tag'] as ThaWork__Tag;

     Result:= FhaTag;
end;

function  TblWork.GethaTag_from_Description: ThaWork__Tag_from_Description;
begin
     if FhaTag_from_Description = nil
     then
         FhaTag_from_Description:= Aggregations['Tag_from_Description'] as ThaWork__Tag_from_Description;

     Result:= FhaTag_from_Description;
end;

procedure TblWork.Duree_GetChaine(var _Chaine: String);
begin
     _Chaine:= sDuree;
end;

function TblWork.sDuree: String;
begin
     Result:= FormatDateTime( 'hh:nn', Duree);
end;

function TblWork.GetDuree: TDateTime;
begin
     if End_ < Beginning
     then
         FDuree:= 0
     else
         FDuree:= End_ - Beginning;

     Result:= FDuree;
end;

function TblWork.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblWork.Stop;
begin
     End_:= Now;
     Save_to_database;
end;

procedure TblWork.sSession_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetsSession;
end;

function TblWork.GetsSession: String;
begin
     Result
     :=
       // FormatDateTime( 'hh:nn', Beginning)
       //+'-'
       //+FormatDateTime( 'hh:nn', End_     )
       //+'('+sDuree+'):'
       sDuree+':'
       ;
     Formate_Liste_Indentation( Result, #13#10, '  ', Description);
end;

function TblWork.Session_Differente( _bl: TblWork): Boolean;
     function Test( _1, _2: TblWork): Boolean;
     const
          dt_2_minute= (2{minute}/60{heure})/24{jour};
     var
        Delta: TDateTime;
     begin
          Delta:= _2.Beginning - _1.End_;
          Result:= Delta > dt_2_minute;
     end;
begin
     Result:= True;
     if _bl = nil then exit;

     if Self.Beginning < _bl.Beginning
     then
         Result:= Test( Self, _bl)
     else
         Result:= Test( _bl, Self);
end;

function TblWork.Semaine_Differente(_bl: TblWork): Boolean;
begin
     Result:= True;
     if _bl = nil then exit;

     Result:= WeekOfTheYear( Beginning) <> WeekOfTheYear( _bl.Beginning);
end;

function TblWork.Jour_Different(_bl: TblWork): Boolean;
begin
     Result:= True;
     if _bl = nil then exit;

     Result:= DayOfTheMonth( Beginning) <> DayOfTheMonth( _bl.Beginning);
end;

procedure TblWork.Tag( _blTag: TblTag);
begin
     if _blTag = nil then exit;
     poolTag_Work.Assure( _blTag.id, id);
     haTag.Ajoute( _blTag);
end;

initialization
              ublTag.TIterateur_Work:= TIterateur_Work;
              ublTag.TblWork:= TblWork;
              ublTag.poolWork:= poolWork;
finalization
            ublTag.TIterateur_Work:= nil;
            ublTag.TblWork:= nil;
            ublTag.poolWork:= nil;
end.


