unit ublTag;
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
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    ufAccueil_Erreur,
    uSVG,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    ublType_Tag,
    upoolType_Tag,

    udmDatabase,

    SysUtils, Classes, SqlDB;

type
  { ThaTag__Work }
  ThaTag__Work
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
   //public
   //  function Iterateur: TIterateur_Work;
   //  function Iterateur_Decroissant: TIterateur_Work;
   end;

 { TblTag }

 TblTag
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Name: String;
  //Type_Tag
  public
    idType: Integer;
    blType_Tag: TblType_Tag;
  //Libelle
  private
    FLibelle: String;
    procedure Libelle_GetChaine( var _Chaine: String);
  public
    function GetLibelle: String; override;
  public
    cLibelle: TChamp;
    property Libelle: String read GetLibelle;
  //Gestion de la clé
  public
    class function sCle_from_( _idType: Integer;  _Name: String): String;

    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Session correspondants
  private
    FhaSession: ThAggregation;
    function GethaSession: ThAggregation;
  public
    property haSession: ThAggregation read GethaSession;
  //Aggrégation vers les Work correspondants
  private
    FhaWork: ThaTag__Work;
    function GethaWork: ThaTag__Work;
  public
    property haWork: ThaTag__Work read GethaWork;
  //Aggrégation vers les Work_from_Session correspondants
  private
    FhaWork_from_Session: ThAggregation;
    function GethaWork_from_Session: ThAggregation;
  public
    property haWork_from_Session: ThAggregation read GethaWork_from_Session;
 //Couleur
 public
   function Couleur: TColor;
 //NewPage rajouté pour sauts de page dans TodSession
 public
   NewPage: Boolean;
 end;

 TIterateur_Tag
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblTag);
    function  not_Suivant( out _Resultat: TblTag): Boolean;
  end;

 TslTag
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
    function Iterateur: TIterateur_Tag;
    function Iterateur_Decroissant: TIterateur_Tag;
  end;

function blTag_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag;
function blTag_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag;

var
   TIterateur_Work: TIterateur_Class= nil;
   TblWork: TBatpro_Ligne_Class= nil;
   poolWork: Tfunction_pool_Ancetre_Ancetre= nil;

   ThaTag__Session: ThAggregation_class= nil;
   TblSession: TBatpro_Ligne_Class= nil;

   ThaTag__Work_from_Session: ThAggregation_class= nil;

type
    TCharge_Tag= procedure ( _idTag: Integer; _slLoaded: TBatpro_StringList) of object;

var
   poolWork_Charge_Tag: TCharge_Tag= nil;

implementation

function blTag_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag;
begin
     _Classe_from_sl( Result, TblTag, sl, Index);
end;

function blTag_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag;
begin
     _Classe_from_sl_sCle( Result, TblTag, sl, sCle);
end;

{ TIterateur_Tag }

function TIterateur_Tag.not_Suivant( out _Resultat: TblTag): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Tag.Suivant( out _Resultat: TblTag);
begin
     Suivant_interne( _Resultat);
end;

{ TslTag }

constructor TslTag.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTag);
end;

destructor TslTag.Destroy;
begin
     inherited;
end;

class function TslTag.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag;
end;

function TslTag.Iterateur: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne);
end;

function TslTag.Iterateur_Decroissant: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);
end;

{ ThaTag__Work }

constructor ThaTag__Work.Create( _Parent: TBatpro_Element;
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

destructor ThaTag__Work.Destroy;
begin
     inherited;
end;

procedure ThaTag__Work.Charge;
begin
     inherited Charge;
     if not Assigned( poolWork_Charge_Tag) then exit;

     poolWork_Charge_Tag( TblTag(Parent).id, slCharge);
     Ajoute_slCharge;
end;

class function ThaTag__Work.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

{
function ThaTag__Work.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function ThaTag__Work.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;
}

{ TblTag }

constructor TblTag.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Tag';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Tag';

     //champs persistants
     Champs. Integer_from_Integer( idType         , 'idType'         );
     Champs.  String_from_String ( Name           , 'Name'           );
     Champs. Ajoute_Boolean      ( NewPage        , 'NewPage', False );
     NewPage:= True;

     blType_Tag:= poolType_Tag.Get( idType);
     AggregeLigne( 'Type_Tag', blType_Tag);

     cLibelle:= Ajoute_String( FLibelle,'Libelle', False);
     cLibelle.OnGetChaine:= Libelle_GetChaine;

end;

destructor TblTag.Destroy;
begin
     DesAggregeLigne( 'Type_Tag', blType_Tag);

     inherited;
end;

function TblTag.GetLibelle: String;
begin
     Result:= '';
     if Assigned( blType_Tag)
     then
         Formate_Liste( Result, ' ', blType_Tag.Name);
     Formate_Liste( Result, ' ', Name);
end;

procedure TblTag.Libelle_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetLibelle;
end;

class function TblTag.sCle_from_( _idType: Integer;  _Name: String): String;
begin
     Result:=  IntToHex( _idType, 8)+ _Name;
end;

function TblTag.sCle: String;
begin
     Result:= sCle_from_(  idType,  Name);
end;

procedure TblTag.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Session'           = Name then P.Faible( ThaTag__Session          , TblSession, nil)
     else if 'Work'              = Name then P.Faible( ThaTag__Work             , TblWork, poolWork)
     else if 'Work_from_Session' = Name then P.Faible( ThaTag__Work_from_Session, TblWork, poolWork)
     else                                    inherited Create_Aggregation( Name, P);
end;

function TblTag.GethaSession: ThAggregation;
begin
          if FhaSession = nil
          then
              FhaSession:= Aggregations['Session'];

          Result:= FhaSession;
end;


function  TblTag.GethaWork: ThaTag__Work;
begin
     if FhaWork = nil
     then
         FhaWork:= Aggregations['Work'] as ThaTag__Work;

     Result:= FhaWork;
end;

function  TblTag.GethaWork_from_Session: ThAggregation;
begin
     if FhaWork_from_Session = nil
     then
         FhaWork_from_Session:= Aggregations['Work_from_Session'];

     Result:= FhaWork_from_Session;
end;

function TblTag.Couleur: TColor;
begin
     case idType
     of
       1: Result:= clAqua;
       2: Result:= clLime;
       3: Result:= clYellow;
       else Result:= clWhite;
       end;
end;

end.


