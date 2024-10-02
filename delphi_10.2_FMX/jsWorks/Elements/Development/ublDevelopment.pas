unit ublDevelopment;
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
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,
    ublTag,

    udmDatabase,
    upool_Ancetre_Ancetre,

    ublCategorie,
    upoolCategorie,

    ublState,
    upoolState,

    upoolTag_Development,
    upoolTag,

    SysUtils, Classes, SQLExpr, DB;

type
 { ThaDevelopment__Tag }
 ThaDevelopment__Tag
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
  end;


 { TblDevelopment }

 TblDevelopment
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Solution: String;
    Origin: String;
    nSheetref: Integer;
    nDemander: Integer;
    isBug: Integer;
    Steps: String;
    nProject: Integer;
    Description: String;
    nSolutionWork: Integer;
    nCreationWork: Integer;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Categorie
  private
    FnCategorie: Integer;
    FblCategorie : TblCategorie;
    Categorie: String;
    procedure SetblCategorie(const Value: TblCategorie);
    procedure SetnCategorie(const Value: Integer);
    procedure nCategorie_Change;
    procedure Categorie_Connecte;
    procedure Categorie_Aggrege;
    procedure Categorie_Desaggrege;
    procedure Categorie_Change;
  public
    cnCategorie: TChamp;
    property nCategorie: Integer read FnCategorie write SetnCategorie;
    property blCategorie: TblCategorie read FblCategorie write SetblCategorie;
  //State
  private
    FnState: Integer;
    FblState : TblState;
    State: String;
    procedure SetblState(const Value: TblState);
    procedure SetnState(const Value: Integer);
    procedure nState_Change;
    procedure State_Connecte;
    procedure State_Aggrege;
    procedure State_Desaggrege;
    procedure State_Change;
  public
    cnState: TChamp;
    property nState: Integer read FnState write SetnState;
    property blState: TblState read FblState write SetblState;
  //Description courte pour liste
  private
    FDescription_Short: String;
    function GetDescription_Short: String;
    procedure Description_Short_Get_Chaine( var _Chaine: String);
  public
    property Description_Short: String read GetDescription_Short;
  //Tag
  public
    procedure Tag( _blTag: TblTag);
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Tag correspondants
  private
    FhaTag: ThaDevelopment__Tag;
    function GethaTag: ThaDevelopment__Tag;
  public
    property haTag: ThaDevelopment__Tag read GethaTag;
  end;

 TIterateur_Development
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblDevelopment);
    function  not_Suivant( var _Resultat: TblDevelopment): Boolean;
  end;

 TslDevelopment
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
    function Iterateur: TIterateur_Development;
    function Iterateur_Decroissant: TIterateur_Development;
  end;

function blDevelopment_from_sl( sl: TBatpro_StringList; Index: Integer): TblDevelopment;
function blDevelopment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDevelopment;

implementation

function blDevelopment_from_sl( sl: TBatpro_StringList; Index: Integer): TblDevelopment;
begin
     _Classe_from_sl( Result, TblDevelopment, sl, Index);
end;

function blDevelopment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDevelopment;
begin
     _Classe_from_sl_sCle( Result, TblDevelopment, sl, sCle);
end;

{ TIterateur_Development }

function TIterateur_Development.not_Suivant( var _Resultat: TblDevelopment): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Development.Suivant( var _Resultat: TblDevelopment);
begin
     Suivant_interne( _Resultat);
end;

{ TslDevelopment }

constructor TslDevelopment.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblDevelopment);
end;

destructor TslDevelopment.Destroy;
begin
     inherited;
end;

class function TslDevelopment.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Development;
end;

function TslDevelopment.Iterateur: TIterateur_Development;
begin
     Result:= TIterateur_Development( Iterateur_interne);
end;

function TslDevelopment.Iterateur_Decroissant: TIterateur_Development;
begin
     Result:= TIterateur_Development( Iterateur_interne_Decroissant);
end;

{ ThaDevelopment__Tag }

constructor ThaDevelopment__Tag.Create( _Parent: TBatpro_Element;
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

destructor ThaDevelopment__Tag.Destroy;
begin
     inherited;
end;

procedure ThaDevelopment__Tag.Charge;
begin
     inherited Charge;
     poolTag.Charge_Development( TblDevelopment(Parent).id, slCharge);
     Ajoute_slCharge;
end;

class function ThaDevelopment__Tag.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag;
end;

function ThaDevelopment__Tag.Iterateur: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne);
end;

function ThaDevelopment__Tag.Iterateur_Decroissant: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);
end;

{ TblDevelopment }

constructor TblDevelopment.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Development';
         CP.Font.Family:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Development';

     //champs persistants
     Integer_from_Integer( nProject       , 'nProject'       );
     Integer_from_Integer( nCreationWork  , 'nCreationWork'  );
     Integer_from_Integer( nSolutionWork  , 'nSolutionWork'  );
     cLibelle:= String_from_        ( Description    , 'Description'    );
     Integer_from_Integer( nDemander      , 'nDemander'      );
     Integer_from_Integer( nSheetref      , 'nSheetref'      );
     String_from_        ( Solution       , 'Solution'       );
     String_from_        ( Origin         , 'Origin'         );
     Integer_from_       ( isBug          , 'isBug'          );
     String_from_        ( Steps          , 'Steps'          );

     Ajoute_String( FDescription_Short, 'Description_Short', False)
     .OnGetChaine:= Description_Short_Get_Chaine;

     cnCategorie:= Integer_from_Integer( FnCategorie, 'nCategorie');
     Champs.String_Lookup( Categorie, 'Categorie', cnCategorie, poolCategorie.GetLookupListItems, '');
     nCategorie_Change;
     cnCategorie.OnChange.Abonne( Self, nCategorie_Change);

     cnState:= Integer_from_Integer( FnState, 'nState');
     Champs.String_Lookup( State, 'State', cnState, poolState.GetLookupListItems, '');
     nState_Change;
     cnState.OnChange.Abonne( Self, nState_Change);

end;

destructor TblDevelopment.Destroy;
begin
     State_Desaggrege;
     Categorie_Desaggrege;
     inherited;
end;

function TblDevelopment.sCle: String;
begin
     Result:= sCle_id;
end;

function TblDevelopment.GetDescription_Short: String;
begin
     Result:= '';
     if Assigned( blState   ) then Result:= Result + blState    .Symbol;
     if Assigned(blCategorie) then Result:= Result + blCategorie.Symbol;
     Result:= Result+Description;
end;

procedure TblDevelopment.Description_Short_Get_Chaine(var _Chaine: String);
begin
     _Chaine:= Description_Short;
end;

procedure TblDevelopment.Tag(_blTag: TblTag);
begin
     poolTag_Development.Assure( _blTag.id, id);
     haTag.Ajoute( _blTag);
end;

procedure TblDevelopment.SetnCategorie(const Value: Integer);
begin
     if FnCategorie = Value then exit;
     FnCategorie:= Value;
     nCategorie_Change;
     Save_to_database;
end;

procedure TblDevelopment.nCategorie_Change;
begin
     Categorie_Aggrege;
end;

procedure TblDevelopment.SetblCategorie(const Value: TblCategorie);
begin
     if FblCategorie = Value then exit;

     Categorie_Desaggrege;

     FblCategorie:= Value;

     if nCategorie <> FblCategorie.id
     then
         begin
         nCategorie:= FblCategorie.id;
         Save_to_database;
         end;

     Categorie_Connecte;
end;

procedure TblDevelopment.Categorie_Connecte;
begin
     if nil = blCategorie then exit;

     Connect_To( FblCategorie);
end;

procedure TblDevelopment.Categorie_Aggrege;
var
   blCategorie_New: TblCategorie;
begin
     blCategorie_New:= poolCategorie.Get( nCategorie);
     if blCategorie = blCategorie_New then exit;

     Categorie_Desaggrege;
     FblCategorie:= blCategorie_New;

     Categorie_Connecte;
end;

procedure TblDevelopment.Categorie_Desaggrege;
begin
     if blCategorie = nil then exit;

     Unconnect_To( FblCategorie);
end;

procedure TblDevelopment.Categorie_Change;
begin
     if Assigned( FblCategorie)
     then
         Categorie:= FblCategorie.Description
     else
         Categorie:= '';
end;

procedure TblDevelopment.Unlink( be: TBatpro_Element);
begin
     inherited;
          if blCategorie  = be then  Categorie_Desaggrege
     else if blState      = be then      State_Desaggrege;
end;

procedure TblDevelopment.SetnState(const Value: Integer);
begin
     if FnState = Value then exit;
     FnState:= Value;
     nState_Change;
     Save_to_database;
end;

procedure TblDevelopment.nState_Change;
begin
     State_Aggrege;
end;

procedure TblDevelopment.SetblState(const Value: TblState);
begin
     if FblState = Value then exit;

     State_Desaggrege;

     FblState:= Value;

     if nState <> FblState.id
     then
         begin
         nState:= FblState.id;
         Save_to_database;
         end;

     State_Connecte;
end;

procedure TblDevelopment.State_Connecte;
begin
     if nil = blState then exit;

     Connect_To( FblState);
end;

procedure TblDevelopment.State_Aggrege;
var
   blState_New: TblState;
begin
     blState_New:= poolState.Get( nState);
     if blState = blState_New then exit;

     State_Desaggrege;
     FblState:= blState_New;

     State_Connecte;
end;

procedure TblDevelopment.State_Desaggrege;
begin
     if blState = nil then exit;

     Unconnect_To( FblState);
end;

procedure TblDevelopment.State_Change;
begin
     if Assigned( FblState)
     then
         State:= FblState.Description
     else
         State:= '';
end;

procedure TblDevelopment.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Tag' = Name then P.Faible( ThaDevelopment__Tag, TblTag, poolTag)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblDevelopment.GethaTag: ThaDevelopment__Tag;
begin
     if FhaTag = nil
     then
         FhaTag:= Aggregations['Tag'] as ThaDevelopment__Tag;

     Result:= FhaTag;
end;


end.


