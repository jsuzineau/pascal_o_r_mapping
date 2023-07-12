unit uBatpro_Ligne;
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
    uBatpro_StringList,
    uClean,
    u_sys_,
    uContrainte,
    uMotsCles,
    uuStrings,
    uPublieur,

    udmDatabase,

    uVide,
    uBatpro_Element,

    ujsDataContexte,
    uChampDefinition,
    uChamp,
    uChamps,
    uChampDefinitions,

    upool_Ancetre_Ancetre,

    uXML,

    uChamps_persistance,
    uhFiltre_Ancetre,
    ufAccueil_Erreur,
  {$IFDEF FPC}
  fpjson,
  {$ELSE}
  Graphics, Windows, DBTables, ComCtrls,
  {$ENDIF}
  Classes, SysUtils,
  DB,
  Types;

type
    TjsDataContexte         = ujsDataContexte.TjsDataContexte;
    TjsDataContexte_SQLQuery=ujsDataContexte.TjsDataContexte_SQLQuery;
 TGroupe     = class;
 TGroupeTitle= class;

 { TBatpro_Ligne }

 TBatpro_Ligne
 =
  class( TBatpro_Element)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); virtual;
    destructor Destroy; override;
  // Persistance à partir du dataset principal
  protected
    Fjsdc: TjsDataContexte;
  public
    Modified: Boolean;
  //Persistance XML
  public
    procedure WriteXMLString( M: TMemoryStream; isMetaData: Boolean;
                              NomChamp: String; Valeur: String;
                              Longueur: Integer);
    procedure WriteXMLDate( M: TMemoryStream; isMetaData: Boolean;
                            NomChamp: String; Valeur: TDateTime);
    procedure WriteXMLDateTime( M: TMemoryStream; isMetaData: Boolean;
                                NomChamp: String; Valeur: TDateTime);
    procedure WriteXMLFloat( M: TMemoryStream; isMetaData: Boolean;
                            NomChamp: String; Valeur: Extended);
    procedure WriteXMLROW(M: TMemoryStream; IsMetaData: Boolean); virtual;
  //Persistance SQL
  //table, clé, valeurs, connection champs/variables
  public
    Champs: TChamps;
    procedure Save_to_database; virtual;
    procedure Insert_into_database; virtual;
    function  Delete_from_database: Boolean; virtual;
  //Suppression
  private
    FSuppression: TPublieur;
    function GetSuppression: TPublieur;
  public
    property Suppression: TPublieur read GetSuppression;
    function Suppression_created: Boolean;
  //interface TChampsProvider
  public
    function Champ_a_editer(Contexte: Integer): TChamp; override;
    function GetChamps: TChamps; override;
  // Filtrage
  public
    Passe_le_filtre: Boolean; //True si répond au conditions de filtrage
    function Calcule_Passe_le_filtre( hf: ThFiltre_Ancetre): Boolean; virtual;
    function Passe_la_Contrainte( _Contrainte: TContrainte): Boolean; 
    function Passe_les_Contraintes( _Contraintes: array of TContrainte): Boolean;
  //Champs persistants
  private
    function Traite_Appartient_a_sCle( _C: TChamp; _Appartient_a_sCle: Boolean): TChamp;
  public
    id: Integer;
    function   ShortString_from_   (var Memory:ShortString;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function   String_from_String  (var Memory:   String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function   String_from_Memo    (var Memory:   String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function   String_from_Blob    (var Memory:   String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function   String_from_        (var Memory:   String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function  Integer_from_Integer (var Memory:  Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function  Integer_from_SmallInt(var Memory:  Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function  Integer_from_String  (var Memory:  Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function  Integer_from_FMTBCD  (var Memory:  Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function  Integer_from_        (var Memory:  Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Currency_from_BCD     (var Memory: Currency;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function   Double_from_        (var Memory:   Double;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function DateTime_from_Date    (var Memory:TDateTime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function DateTime_from_        (var Memory:TDateTime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_ShortString    (var Memory:ShortString;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_String         (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_Integer        (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_SmallInt       (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_DateTime       (var Memory:  TDatetime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_Date           (var Memory:  TDatetime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_BCD            (var Memory:  Currency ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_Float          (var Memory:  Double   ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
    function Ajoute_Boolean        (var Memory:  Boolean  ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp;
  //Aggrégation (terme peut-être incorrect) de champ
  //on fait apparaître comme champ de cet objet le champ d'un autre objet
  //==> permet dans P_PLP un filtre sur BP_SAL
  //==> permet d'aficher le libellé correspondant à une clé étrangère
  //==> La notion de propriétaire de champ permet de sécuriser la modification
  public
    procedure    AggregeChamp( NomChamp: String; _bl: TBatpro_Ligne; _bl_NomChamp: String= '');
    procedure DesaggregeChamp( NomChamp: String);
  //Aggégation de tous les champs d'un Batpro_Ligne dans un autre
  public
    procedure    AggregeLigne( Prefixe: String; _bl: TBatpro_Ligne);
    procedure DesaggregeLigne( Prefixe: String; _bl: TBatpro_Ligne);
  //Recopie à partir d'un autre Batpro_Ligne
  public
    procedure Copy_from_( _Source: TBatpro_Ligne; _Desactiver_Publications: Boolean= True);
  //Rechargement
  public
    procedure Recharge( _jsdc: TjsDataContexte); virtual;
  // id sous forme de chaine en hexadécimal pour les clés
  public
    class function sCle_ID_from_( _id: Integer): String;
    function sCle_ID: String;
  //Lien vers le pool éventuel
  public
    pool: Tpool_Ancetre_Ancetre;
  //Gestion de la clé
  public
    procedure sCle_Change; virtual;
  //Champs calculés
  public
    procedure Rafraichit_Champs_Calcules; virtual;
  //Gestion de la connection
  public
    class function jsDataConnexion: TjsDataConnexion; virtual;
  //Gestion des champ de code et de libelle
  public
    cCode   : TChamp;
    cLibelle: TChamp;
    function GetCode   : String; virtual;
    function GetLibelle: String; virtual;
  //Déconnection avant destruction de l'instance
  public
    procedure Deconnecte; virtual;
    procedure Connecte; virtual;
  //Déconnection avant suppression de la base
  public
    procedure Supprime_Connections; virtual;
  //Sérialisation
  public
    procedure Serialise  ( S: TStream);
    procedure DeSerialise( S: TStream);
  //Création des champs
  protected
    procedure Cree_Champs; virtual;
  //Définition des mots clés pour la GED
  public
    class procedure GED_Get_MotsCles_Nom( MotsCles: TMotsCles); virtual;
    procedure GED_Get_MotsCles( MotsCles: TMotsCles); virtual;
  //Valeur d'un champ
  public
    function ValeurChamp( NomChamp: String): String;
  //Envoi d'un message de modification de champ
  public
    procedure ChampChanged( var _Valeur);
  //Gestion du texte de cellule
  protected
    function GetCell( Contexte: Integer): String; override;
  //Gestion des ruptures sur états OpenOffice
  private
    FGroupe: TGroupe;
    function GetGroupe: TGroupe;
    procedure Aggrege_Groupe;
  public
    property Groupe: TGroupe read GetGroupe;
    procedure Groupe_Supprime;
  //Gestion des titres de ruptures sur états OpenOffice
  private
    FGroupeTitle: TGroupeTitle;
    function GetGroupeTitle: TGroupeTitle;
    procedure Aggrege_GroupeTitle;
  public
    property GroupeTitle: TGroupeTitle read GetGroupeTitle;
    procedure GroupeTitle_Supprime;
  //Gestion de la sélection
  public
    procedure Selectionner;
    procedure DeSelectionner;
  //Export JSON, JavaScript Object Notation
  protected
    function  GetJSON: String; override;
    {$IFDEF FPC}
    procedure SetJSON( _Value: String); override;
    {$ENDIF}
  public
    property JSON: String
             read GetJSON
             {$IFDEF FPC}
             write SetJSON
             {$ENDIF}
             ;
     function JSON_Persistants: String; override;
     function JSON_id_Libelle: String; override;
 //Listing des champs pour déboguage
  public
    function Listing_Champs( Separateur: String): String; override;
    function Listing( Indentation: String): String; override;
  end;

 TBatpro_Ligne_Class= class of TBatpro_Ligne;

 { TGroupe }

 TGroupe
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    NewGroup         : Boolean;
    EndGroup         : Boolean;
    GroupSize        : Integer;
  end;

 { TGroupeTitle }

 TGroupeTitle
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    GroupTitle       :  String;
    GroupTitle_Style :  String;
    GroupTitle_Column: Integer;
  end;

function Batpro_Ligne_from_sl( sl: TStringList; Index: Integer): TBatpro_Ligne;

function Batpro_Ligne_from_sl_sCle( sl: TStringList; sCle: String): TBatpro_Ligne;

{$IFNDEF FPC}
function Batpro_Ligne_from_TreeNode( tn: TTreeNode): TBatpro_Ligne;

function Batpro_Ligne_from_TreeView( tv: TTreeView; Index: Integer): TBatpro_Ligne; overload;
function Batpro_Ligne_from_TreeView( tv: TTreeView): TBatpro_Ligne; overload;
{$ENDIF}

procedure bl_nil( var bl);

function Non_trouve( _Table: String; _id: Integer): String;

procedure Batpro_Ligne_Tout_selectionner( _sl: TBatpro_StringList);
procedure Batpro_Ligne_Tout_deselectionner( _sl: TBatpro_StringList);

procedure BooleanFieldValue( _bl: TBatpro_Ligne; _FielName: String; var _C:TChamp; var _B: Boolean);
procedure IntegerFieldValue( _bl: TBatpro_Ligne; _FielName: String; var _C:TChamp; var _I: Integer);
procedure  StringFieldValue( _bl: TBatpro_Ligne; _FielName: String; var _C:TChamp; var _S: String );

procedure id_from_bl( var _id: Integer; _bl: TBatpro_Ligne);

var
   uBatpro_Ligne_vidage_des_pools_en_cours: Boolean= False;
   
implementation

function Batpro_Ligne_from_sl( sl: TStringList; Index: Integer): TBatpro_Ligne;
begin
     _Classe_from_sl( Result, TBatpro_Ligne, sl, Index);
end;

function Batpro_Ligne_from_sl_sCle( sl: TStringList; sCle: String): TBatpro_Ligne;
begin
     _Classe_from_sl_sCle( Result, TBatpro_Ligne, sl, sCle);
end;

{$IFNDEF FPC}
function Batpro_Ligne_from_TreeNode( tn: TTreeNode): TBatpro_Ligne;
begin
     Result:= nil;
     if tn = nil then exit;

     Result:= TBatpro_Ligne( tn.Data);
     CheckClass( Result, TBatpro_Ligne);
end;

function Batpro_Ligne_from_TreeView( tv: TTreeView; Index: Integer): TBatpro_Ligne; overload;
begin
     Result:= nil;
     if Index          <  0      then exit;
     if tv.Items.Count <= Index  then exit;
     Result:= Batpro_Ligne_from_TreeNode( tv.Items[Index]);
end;

function Batpro_Ligne_from_TreeView( tv: TTreeView): TBatpro_Ligne; overload;
begin
     Result:= Batpro_Ligne_from_TreeNode( tv.Selected);
end;
{$ENDIF}

procedure bl_nil( var bl);
//var
//   BatproLigne: TBatpro_Ligne;
begin
     if TObject( bl) = nil then exit;

     //if Affecte( BatproLigne, TBatpro_Ligne, TObject( bl))
     //then
     //    BatproLigne.Deconnecte;

     Free_nil( bl);
end;

function Non_trouve( _Table: String; _id: Integer): String;
begin
     Result:= _Table+' id '+IntToStr(_id)+' non trouvé';
end;

procedure Batpro_Ligne_Tout_selectionner( _sl: TBatpro_StringList);
var
   bl: TBatpro_Ligne;
begin
     _sl.Iterateur_Start;
     try
        while not _sl.Iterateur_EOF
        do
          begin
          _sl.Iterateur_Suivant( bl);
          if bl = nil then exit;

          bl.Selectionner;
          end;
     finally
            _sl.Iterateur_Stop;
            end;
end;

procedure Batpro_Ligne_Tout_deselectionner( _sl: TBatpro_StringList);
var
   bl: TBatpro_Ligne;
begin
     _sl.Iterateur_Start;
     try
        while not _sl.Iterateur_EOF
        do
          begin
          _sl.Iterateur_Suivant( bl);
          if bl = nil then exit;

          bl.DeSelectionner;
          end;
     finally
            _sl.Iterateur_Stop;
            end;
end;

procedure BooleanFieldValue( _bl: TBatpro_Ligne; _FielName: String;
                             var _C: TChamp; var _B: Boolean);
begin
     _C:= _bl.Champs.Champ_from_Field( _FielName);
     if      Assigned( _C)
        and ( _C.Definition.Info.jsDataType = jsdt_Boolean)
     then
         _B:= PtrBoolean( _C.Valeur)^
     else
         _B:= False;
end;

procedure IntegerFieldValue( _bl: TBatpro_Ligne; _FielName: String;
                             var _C: TChamp; var _I: Integer);
begin
     _C:= _bl.Champs.Champ_from_Field( _FielName);
     if      Assigned( _C)
        and ( _C.Definition.Info.jsDataType = jsdt_Integer)
     then
         _I:= PInteger( _C.Valeur)^
     else
         _I:= 0;
end;

procedure StringFieldValue( _bl: TBatpro_Ligne; _FielName: String;
                            var _C: TChamp; var _S: String);
begin
     _C:= _bl.Champs.Champ_from_Field( _FielName);
     if      Assigned( _C)
        and ( _C.Definition.Info.jsDataType = jsdt_String)
     then
         _S:= _C.Chaine
     else
         _S:= '';
end;

procedure id_from_bl( var _id: Integer; _bl: TBatpro_Ligne);
begin
     if _bl = nil
     then
         _id:= 0
     else
         _id:= _bl.id;
end;

{ TBatpro_Ligne }

constructor TBatpro_Ligne.Create( _sl: TBatpro_StringList;
                                  _jsdc: TjsDataContexte;
                                  _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create( _sl);
     Fjsdc  := _jsdc;
     pool:= _pool;
     Modified:= False;

     if Fjsdc= nil
     then
         Fjsdc:= jsDataContexte_Dataset_Null;

     Champs:= TChamps.Create( ClassName, Fjsdc, Save_to_database);

     Passe_le_filtre:= True;

     cCode   := nil;
     cLibelle:= nil;

     FGroupe     := nil;
     FGroupeTitle:= nil;

     FSuppression:= nil;

     Cree_Champs;
end;

destructor TBatpro_Ligne.Destroy;
begin
     Deconnecte;

     Free_nil( FSuppression);
     Free_nil( FGroupe     );
     Free_nil( FGroupeTitle);
     Free_nil( Champs);
     inherited;
end;

procedure TBatpro_Ligne.Cree_Champs;
begin
     Champs.Cree_Champ_ID( id);
     Champs.Ajoute_Boolean( FSelected, 'Selected', False);
end;

procedure TBatpro_Ligne.WriteXMLString( M: TMemoryStream; isMetaData: Boolean;
                                        NomChamp: String; Valeur: String;
                                        Longueur: Integer);
begin
     if isMetaData
     then
         WriteXMLDef  ( M, NomChamp, 'string', 'FixedChar', IntToStr(Longueur))
     else
         WriteXMLValue( M, NomChamp, XMLString( Valeur));
end;

procedure TBatpro_Ligne.WriteXMLDate( M: TMemoryStream; isMetaData: Boolean;
                                      NomChamp: String; Valeur: TDateTime);
begin
     if isMetaData
     then
         WriteXMLDef  ( M, NomChamp, 'date')
     else
         WriteXMLValue( M, NomChamp, XMLDate( Valeur));
end;

procedure TBatpro_Ligne.WriteXMLDateTime( M: TMemoryStream; isMetaData: Boolean;
                                          NomChamp: String; Valeur: TDateTime);
begin
     if isMetaData
     then
         WriteXMLDef  ( M, NomChamp, 'dateTime')
     else
         WriteXMLValue( M, NomChamp, XMLDateTime( Valeur));
end;

procedure TBatpro_Ligne.WriteXMLFloat( M: TMemoryStream; isMetaData: Boolean;
                                       NomChamp: String; Valeur: Extended);
begin
     if isMetaData
     then
         WriteXMLDef  ( M, NomChamp, 'r8')
     else
         WriteXMLValue( M, NomChamp, XMLFloat( Valeur));
end;

procedure TBatpro_Ligne.WriteXMLROW(M: TMemoryStream; IsMetaData: Boolean);
begin
end;

procedure TBatpro_Ligne.Save_to_database;
begin
     Modified:= not Champs_persistance.Save_to_database( Champs, jsDataConnexion);
     Rafraichit_Champs_Calcules;
end;

procedure TBatpro_Ligne.Insert_into_database;
begin
     Modified:= not Champs_persistance.Insert_into_database( Champs, jsDataConnexion);
end;

function TBatpro_Ligne.Delete_from_database: Boolean;
begin
     Aggregations.Delete_from_database;
     Supprime_Connections;
     Result:= Champs_persistance.Delete_from_database( Champs, jsDataConnexion);
end;

function TBatpro_Ligne.GetSuppression: TPublieur;
begin
     if nil = FSuppression
     then
         FSuppression:= TPublieur.Create(ClassName+'.Suppression');
     Result:= FSuppression;
end;

function TBatpro_Ligne.Suppression_created: Boolean;
begin
     Result:= Assigned( FSuppression);
end;

function TBatpro_Ligne.GetChamps: TChamps;
begin
     Result:= Champs;
end;

function TBatpro_Ligne.Traite_Appartient_a_sCle( _C: TChamp; _Appartient_a_sCle: Boolean): TChamp;
begin
     Result:= _C;
     if Result = nil then exit;
     if not _Appartient_a_sCle then exit;

     Result.OnChange.Abonne( Self, sCle_Change);
end;

function TBatpro_Ligne.  ShortString_from_   (var Memory:ShortString;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  ShortString_from_   (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.  String_from_String  (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  String_from_String  (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.  String_from_Memo    (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  String_from_Memo    (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.  String_from_Blob    (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  String_from_Blob    (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.  String_from_        (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  String_from_        (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne. Integer_from_Integer (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs. Integer_from_Integer (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne. Integer_from_SmallInt(var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs. Integer_from_SmallInt(Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne. Integer_from_String  (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs. Integer_from_String  (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne. Integer_from_FMTBCD  (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs. Integer_from_FMTBCD  (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne. Integer_from_        (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs. Integer_from_        (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Currency_from_BCD     (var Memory:   Currency;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Currency_from_BCD     (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.  Double_from_        (var Memory:     Double;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.  Double_from_        (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.DateTime_from_Date    (var Memory:  TDateTime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.DateTime_from_Date    (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.DateTime_from_        (var Memory:  TDateTime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.DateTime_from_        (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_ShortString    (var Memory:ShortString;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_ShortString    (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_String         (var Memory:     String;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_String         (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_Integer        (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_Integer        (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_SmallInt       (var Memory:    Integer;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_SmallInt       (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_DateTime       (var Memory:  TDatetime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_DateTime       (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_Date           (var Memory:  TDatetime;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_Date           (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_BCD            (var Memory:  Currency ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_BCD            (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_Float          (var Memory:  Double   ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_Float          (Memory,Field,Persistant),_Appartient_a_sCle);end;
function TBatpro_Ligne.Ajoute_Boolean        (var Memory:  Boolean  ;Field:String;Persistant:Boolean=True; _Appartient_a_sCle: Boolean= False): TChamp; begin Result:= Traite_Appartient_a_sCle( Champs.Ajoute_Boolean        (Memory,Field,Persistant),_Appartient_a_sCle);end;

procedure TBatpro_Ligne.AggregeChamp( NomChamp: String; _bl: TBatpro_Ligne; _bl_NomChamp: String= '');
var
   _bl_Champs: TChamps;
begin
     if _bl = nil
     then
         _bl_Champs:= nil
     else
         _bl_Champs:= _bl.Champs;

     Champs.Aggrege( NomChamp, _bl_Champs, _bl_NomChamp);
end;

procedure TBatpro_Ligne.DesaggregeChamp( NomChamp: String);
begin
     Champs.DesAggrege( NomChamp);
end;

procedure TBatpro_Ligne.AggregeLigne( Prefixe: String; _bl: TBatpro_Ligne);
begin
     if _bl = nil then exit;

     Champs.AggregeChamps( Prefixe, _bl.Champs);
end;

procedure TBatpro_Ligne.DesaggregeLigne( Prefixe: String; _bl: TBatpro_Ligne);
begin
     if _bl = nil then exit;

     Champs.DesAggregeChamps( Prefixe, _bl.Champs);
end;

function TBatpro_Ligne.Calcule_Passe_le_filtre( hf: ThFiltre_Ancetre): Boolean;
var
   slLIKE     : TBatpro_StringList;
   slOR_LIKE  : TBatpro_StringList;
   slLIKE_ou_VIDE: TBatpro_StringList;
   slDIFFERENT: TBatpro_StringList;
   slEGAL     : TBatpro_StringList;
   slCONTIENT : TBatpro_StringList;
var
   //Batpro_Element / StringList
   J, iChamp: Integer;
   NomChamp, ValeurCritere, ValeurChamp: String;
   Champ: TChamp;
   Contrainte: TContrainte;
   ORLIKE_OK: Boolean;
   procedure CC( _sl: TBatpro_StringList; _Index: Integer);
   var
      Ligne: String;
   begin
       Ligne:= _sl.Strings[ _Index];
       NomChamp:= StrTok( '=', Ligne);
       ValeurCritere:= Ligne;
   end;
begin
     Result:= False;
     try
        Passe_le_filtre:= Assigned( hf);
        if not Passe_le_filtre then exit;

        slLIKE        := hf.slLIKE        ;
        slOR_LIKE     := hf.slOR_LIKE     ;
        slLIKE_ou_VIDE:= hf.slLIKE_ou_VIDE;
        slDIFFERENT   := hf.slDIFFERENT   ;
        slEGAL        := hf.slEGAL        ;
        slCONTIENT    := hf.slCONTIENT    ;

        for J:= 0 to slLIKE.Count -1
        do
          begin
          cc( slLIKE, J);
          iChamp  := Champs.sl.IndexOf( NomChamp);
          if -1<> iChamp
          then
              begin
              Champ      := Champs.Champ_from_Index( iChamp);
              try
                 ValeurChamp:= Champ.Chaine;
              except
                    on E: Exception
                    do
                      begin
                      fAccueil_Erreur( Format(  'TBatpro_Ligne.Calcule_Passe_le_filtre: '
                                               +'erreur sur Champ.Chaine (Champ.GetChaine):'+sys_N
                                               +'  iChamp: %d'+sys_N
                                               +'  id:  %d'+sys_N
                                               +'  ClassName: %s',
                                               [iChamp, id, ClassName]));
                      end;
                    end;

              Passe_le_filtre:= 1 = Pos( ValeurCritere, ValeurChamp);
              if not Passe_le_filtre then break;
              end;
          end;

        if Passe_le_filtre
        then
            begin
            ORLIKE_OK:= slOR_LIKE.Count = 0;
            for J:= 0 to slOR_LIKE.Count -1
            do
              begin
              cc( slOR_LIKE, J);
              iChamp  := Champs.sl.IndexOf( NomChamp);
              if -1<> iChamp
              then
                  begin
                  Champ      := Champs.Champ_from_Index( iChamp);
                  try
                     ValeurChamp:= Champ.Chaine;
                  except
                        on E: Exception
                        do
                          begin
                          fAccueil_Erreur( Format(  'TBatpro_Ligne.Calcule_Passe_le_filtre: '
                                                   +'erreur sur Champ.Chaine (Champ.GetChaine):'+sys_N
                                                   +'  iChamp: %d'+sys_N
                                                   +'  id:  %d'+sys_N
                                                   +'  ClassName: %s',
                                                   [iChamp, id, ClassName]));
                          end;
                        end;

                  ORLIKE_OK:= 1 = Pos( ValeurCritere, ValeurChamp);
                  if ORLIKE_OK then break;
                  end;
              end;
            Passe_le_filtre:= ORLIKE_OK;
            end;

        if Passe_le_filtre
        then
            for J:= 0 to slLIKE_ou_VIDE.Count -1
            do
              begin
              cc( slLIKE_ou_VIDE, J);
              iChamp  := Champs.sl.IndexOf( NomChamp);
              if -1<> iChamp
              then
                  begin
                  Champ      := Champs.Champ_from_Index( iChamp);
                  try
                     ValeurChamp:= Champ.Chaine;
                  except
                        on E: Exception
                        do
                          begin
                          fAccueil_Erreur( Format(  'TBatpro_Ligne.Calcule_Passe_le_filtre: '
                                                   +'erreur sur Champ.Chaine (Champ.GetChaine):'+sys_N
                                                   +'  iChamp: %d'+sys_N
                                                   +'  id:  %d'+sys_N
                                                   +'  ClassName: %s',
                                                   [iChamp, id, ClassName]));
                          end;
                        end;
                  if ValeurChamp = '' then continue;

                  Passe_le_filtre:= 1 = Pos( ValeurCritere, ValeurChamp);
                  if not Passe_le_filtre then break;
                  end;
              end;

        if Passe_le_filtre
        then
            for J:= 0 to slDIFFERENT.Count -1
            do
              begin
              cc( slDIFFERENT, J);
              iChamp  := Champs.sl.IndexOf( NomChamp);
              if -1<> iChamp
              then
                  begin
                  Champ      := Champs.Champ_from_Index( iChamp);
                  ValeurChamp:= Champ.Chaine;
                  if ValeurCritere = uhFiltre_Ancetre_Code_pour_Vide
                  then
                      ValeurCritere:= sys_Vide;

                  Passe_le_filtre:= ValeurCritere <> ValeurChamp;
                  if not Passe_le_filtre then break;
                  end;
              end;

        if Passe_le_filtre
        then
            for J:= 0 to slEGAL.Count -1
            do
              begin
              cc( slEGAL, J);
              iChamp  := Champs.sl.IndexOf( NomChamp);
              if -1<> iChamp
              then
                  begin
                  Champ      := Champs.Champ_from_Index( iChamp);
                  ValeurChamp:= Champ.Chaine;
                  if ValeurCritere = uhFiltre_Ancetre_Code_pour_Vide
                  then
                      ValeurCritere:= sys_Vide;

                  Passe_le_filtre:= ValeurCritere = ValeurChamp;
                  if not Passe_le_filtre then break;
                  end;
              end;
        if Passe_le_filtre
        then
            for J:= 0 to slCONTIENT.Count -1
            do
              begin
              cc( slCONTIENT, J);
              iChamp  := Champs.sl.IndexOf( NomChamp);
              if -1<> iChamp
              then
                  begin
                  Champ      := Champs.Champ_from_Index( iChamp);
                  ValeurChamp:= Champ.Chaine;

                  Passe_le_filtre:= 0<> Pos( ValeurCritere, ValeurChamp);
                  if not Passe_le_filtre then break;
                  end;
              end;
        if Passe_le_filtre
        then
            for J:= Low(hf.Contraintes) to High(hf.Contraintes)
            do
              begin
              Contrainte:= hf.Contraintes[ J];
              Passe_le_filtre:= Passe_la_Contrainte( Contrainte);
              if not Passe_le_filtre then break;
              end;
     finally
            Result:= Passe_le_filtre;
            end;
end;

function TBatpro_Ligne.Passe_la_Contrainte( _Contrainte: TContrainte): Boolean;
var
   iChamp: Integer;
   NomChamp: String;
   Champ: TChamp;
begin
     Result:= True;
     if _Contrainte = nil      then exit;
     if not _Contrainte.Active then exit;

     NomChamp:= _Contrainte.NomChamp;
     iChamp:= Champs.sl.IndexOf( NomChamp);
     if -1 =  iChamp then exit;

     Champ:= Champs.Champ_from_Index( iChamp);
     case _Contrainte.TypeOperande
     of
       cto_Chaine  : _Contrainte.Valeur_Chaine  := Champ.Chaine    ;
       cto_Entier  : _Contrainte.Valeur_Entier  := Champ.asInteger ;
       cto_Flottant: _Contrainte.Valeur_Flottant:= Champ.asDouble  ;
       cto_Date    : _Contrainte.Valeur_Date    := Champ.asDatetime;
       end;
     Result:= _Contrainte.Passe_le_test;
end;

function TBatpro_Ligne.Passe_les_Contraintes( _Contraintes: array of TContrainte): Boolean;
var
   i: Integer;
begin
     Result:= True;
     for I:= Low( _Contraintes) to High( _Contraintes)
     do
       begin
       Result:= Passe_la_Contrainte( _Contraintes[I]);
       if not Result then break;
       end;
end;

procedure TBatpro_Ligne.Copy_from_( _Source: TBatpro_Ligne; _Desactiver_Publications: Boolean= True);
var
   csSource: TChamps;
   I: Integer;
   cCible, cSource: TChamp;
   dSource: TChampDefinition;
   NomChamp: String;
   Old_uChamp_Publier_Modifications: Boolean;
begin
     if _Source = nil then exit;
     if ClassName <> _Source.ClassName
     then
         begin
         fAccueil_Erreur(  'Erreur à signaler au développeur: '+sys_N
                          +'  TBatpro_Ligne.Copy_from_: ClassName <> _Source.ClassName'+sys_N
                          +'    La classe de la source ne correspond pas à la classe de la destination.'+sys_N
                          +'    Cible : '+        ClassName+sys_N
                          +'    Source: '+_Source.ClassName+sys_N);
         exit;
         end;

     csSource:= _Source.Champs;
     if csSource = nil then exit;

     Old_uChamp_Publier_Modifications:= uChamp_Publier_Modifications;
     try
        if _Desactiver_Publications
        then
            uChamp_Publier_Modifications:= False;

        for I:= 0 to csSource.Count - 1
        do
          begin
          cSource:= csSource.Champ_from_Index( I);
          if Assigned( cSource)
          then
              begin
              dSource:= cSource.Definition;
              if      not (csSource.cID = cSource) // on écarte le champ id
                 and (dSource.Persistant)          // on écarte les lookups
              then
                  begin
                  NomChamp:= dSource.Nom;
                  cCible:= Champs.Champ_from_Field( NomChamp);
                  if Assigned( cCible)
                  then
                      cCible.Chaine:= cSource.Chaine;
                  end;
              end;
          end;
     finally
            uChamp_Publier_Modifications:= Old_uChamp_Publier_Modifications;
            end;
end;

procedure TBatpro_Ligne.Recharge( _jsdc: TjsDataContexte);
begin
     Fjsdc:= _jsdc;
     Champs.Recharge( Fjsdc);
end;

class function TBatpro_Ligne.sCle_ID_from_( _id: Integer): String;
begin
     Result:= IntToHex( _id, 8);
end;

function TBatpro_Ligne.sCle_ID: String;
begin
     Result:= sCle_ID_from_( id);
end;

procedure TBatpro_Ligne.Rafraichit_Champs_Calcules;
begin

end;

class function TBatpro_Ligne.jsDataConnexion: TjsDataConnexion;
begin
     Result:= dmDatabase.jsDataConnexion;
end;

function TBatpro_Ligne.Champ_a_editer( Contexte: Integer): TChamp;
begin
     Result:= nil;
end;

function TBatpro_Ligne.GetCode: String;
begin
     if cCode = nil
     then
         Result:= sys_Vide
     else
         Result:= cCode.Chaine;
end;

function TBatpro_Ligne.GetLibelle: String;
begin
     if cLibelle = nil
     then
         Result:= sys_Vide
     else
         Result:= cLibelle.Chaine;
end;

procedure TBatpro_Ligne.Connecte;
begin

end;

procedure TBatpro_Ligne.Deconnecte;
     procedure Traite_Aggregeurs;
     var
        ha: ThAggregation;
     begin
          while Aggregeurs.Count > 0
          do
            begin
            ha:= hAggregation_from_sl( Aggregeurs, 0);
            if ha = nil then continue;

            ha.Enleve( Self);
            end;
     end;
     procedure Traite_Connecteurs;
     var
        I: TIterateur_Batpro_Element;
        be: TBatpro_Element;
     begin
          I:= Connecteurs.Iterateur;
          while I.continuer
          do
            begin
            if I.not_Suivant( be) then continue;

            be.Unlink( Self);
            end;
          FreeAndNil(I);
     end;
begin
     Aggregations.Deconnecte;
     Traite_Aggregeurs;
     Traite_Connecteurs;
end;

procedure TBatpro_Ligne.Supprime_Connections;
     procedure Traite_Aggregeurs;
     var
        ha: ThAggregation;
        Old_Count: Integer;
     begin
          while Aggregeurs.Count > 0
          do
            begin
            ha:= hAggregation_from_sl( Aggregeurs, 0);
            if ha = nil then continue;

            Old_Count:= Aggregeurs.Count;
            ha.Supprime_Connection( Self);

            //pas trop propre
            //rajouté pour éviter un blocage sur le planning
            if Old_Count = Aggregeurs.Count then Aggregeurs.Delete( 0);
            end;
     end;
begin
     Aggregations.Supprime_Connections;
     Traite_Aggregeurs;
end;

procedure TBatpro_Ligne.Serialise( S: TStream);
begin
     Champs.Serialise( S);
end;

procedure TBatpro_Ligne.DeSerialise( S: TStream);
begin
     Champs.DeSerialise( S);
end;

procedure TBatpro_Ligne.sCle_Change;
begin
     if Assigned( pool)
     then
         pool.sCle_Change( Self);

     Aggregations.sCle_Change( Self);
end;

class procedure TBatpro_Ligne.GED_Get_MotsCles_Nom( MotsCles: TMotsCles);
begin
end;

procedure TBatpro_Ligne.GED_Get_MotsCles( MotsCles: TMotsCles);
begin

end;

function TBatpro_Ligne.ValeurChamp( NomChamp: String): String;
var
   C: TChamp;
begin
     Result:= sys_Vide;

     C:= Champs.Champ[ NomChamp];
     if C = nil then exit;

     Result:= C.Chaine;
end;

function TBatpro_Ligne.GetCell( Contexte: Integer): String;
begin
     Result:= GetLibelle;
end;

procedure TBatpro_Ligne.ChampChanged(var _Valeur);
var
   C: TChamp;
begin
     C:= Champs.Champ_from_Valeur( _Valeur);
     if C = nil then exit;

     C.Publie_Modifications;
end;

procedure TBatpro_Ligne.Aggrege_Groupe;
begin
     AggregeChamp( 'NewGroup' , FGroupe);
     AggregeChamp( 'EndGroup' , FGroupe);
     AggregeChamp( 'GroupSize', FGroupe);
end;

procedure TBatpro_Ligne.Aggrege_GroupeTitle;
begin
     AggregeChamp( 'GroupTitle'       , FGroupeTitle);
     AggregeChamp( 'GroupTitle_Style' , FGroupeTitle);
     AggregeChamp( 'GroupTitle_Column', FGroupeTitle);
end;

function TBatpro_Ligne.GetGroupe: TGroupe;
begin
     if nil = FGroupe
     then
         begin
         FGroupe:= TGroupe.Create( nil, nil, nil);
         Aggrege_Groupe;
         end;

     Result:= FGroupe;
end;

function TBatpro_Ligne.GetGroupeTitle: TGroupeTitle;
begin
     if nil = FGroupeTitle
     then
         begin
         FGroupeTitle:= TGroupeTitle.Create( nil, nil, nil);
         Aggrege_GroupeTitle;
         end;

     Result:= FGroupeTitle;
end;

procedure TBatpro_Ligne.Groupe_Supprime;
begin
     Free_nil( FGroupe);
     Aggrege_Groupe;
end;

procedure TBatpro_Ligne.GroupeTitle_Supprime;
begin
     Free_nil( FGroupeTitle);
     Aggrege_GroupeTitle;
end;

procedure TBatpro_Ligne.Selectionner;
var
   C: TChamp;
begin
     C:= Champs.Champ['Selected'];
     if Assigned( C)
     then
         C.asBoolean:= True;
end;

procedure TBatpro_Ligne.DeSelectionner;
var
   C: TChamp;
begin
     C:= Champs.Champ['Selected'];
     if Assigned( C)
     then
         C.asBoolean:= False;
end;

function TBatpro_Ligne.GetJSON: String;
begin
     Result
     :=
        '{'
       +Champs.JSON;
     Formate_Liste( Result, ',',Aggregations.JSON);
     Result:= Result + '}';
end;

function TBatpro_Ligne.JSON_Persistants: String;
begin
     Result:= '{'+Champs.JSON_Persistants+Aggregations.JSON_Persistants+'}';
end;

function TBatpro_Ligne.JSON_id_Libelle: String;
begin
     (*
     Result
     :=
        '{'
       +Format( '"%s":"%s",',['id'     , StringToJSONString(IntToStr(id))])
       +Format( '"%s":"%s" ',['Libelle', StringToJSONString(GetLibelle)])
       +'}';
     *)
     Result
     :=
        '{'
       +Champs.JSON
       +Format( ',"%s":"%s"',['Libelle', StringToJSONString(GetLibelle)]);
     Formate_Liste( Result, ',',Aggregations.JSON);
     Result:= Result + '}';
end;

{$IFDEF FPC}
procedure TBatpro_Ligne.SetJSON(_Value: String);
begin
     Champs.JSON:= _Value;
end;

{$ENDIF}

function TBatpro_Ligne.Listing_Champs( Separateur: String): String;
var
   I: Integer;
   C: TChamp;
   D: TChampDefinition;

   S: String;
begin
     Result:= inherited Listing_Champs( Separateur);

     for I:= 0 to Champs.Count - 1
     do
       begin
       C:= Champs.Champ_from_Index( I);
       if C = nil then continue;

       D:= C.Definition;
       if D = nil
       then
           S:= '(Definition = nil)'
       else
           S:= D.Nom;
       S:= S + ' = ' + c.Chaine;

       Formate_Liste( Result, Separateur, S);
       end;
end;

function TBatpro_Ligne.Listing(Indentation: String): String;
begin
     Result
     :=
        Indentation+'>'+GetCode+'<, '+GetLibelle+#13#10
       +inherited Listing(Indentation);
end;

{ TGroupe }

constructor TGroupe.Create( _sl: TBatpro_StringList;
                            _jsdc: TjsDataContexte;
                            _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Groupe';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.Ajoute_Boolean( NewGroup , 'NewGroup' , False);
     Champs.Ajoute_Boolean( EndGroup , 'EndGroup' , False);
     Champs.Ajoute_Integer( GroupSize, 'GroupSize', False);
end;

destructor TGroupe.Destroy;
begin

  inherited;
end;

{ TGroupeTitle }

constructor TGroupeTitle.Create( _sl: TBatpro_StringList;
                                 _jsdc: TjsDataContexte;
                                 _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'GroupeTitle';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.Ajoute_String ( GroupTitle       , 'GroupTitle'       , False);
     Champs.Ajoute_String ( GroupTitle_Style , 'GroupTitle_Style' , False);
     Champs.Ajoute_Integer( GroupTitle_Column, 'GroupTitle_Column', False);
end;

destructor TGroupeTitle.Destroy;
begin

     inherited;
end;

initialization
              uVide_bl_nil:= bl_nil;
finalization
              uVide_bl_nil:= nil;
end.
