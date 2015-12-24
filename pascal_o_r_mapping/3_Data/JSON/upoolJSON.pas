unit upoolJSON;
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
    uBatpro_StringList,
    uhAggregation,
    uDataUtilsU,
    uChamp,
    uChamps,
    uVide,
    uOD_Forms,

    uBatpro_Element,
    uBatpro_Ligne,
    ublAutomatic,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uHTTP_Interface,

  fpjson, jsonparser,
  SysUtils, Classes,
  DB, sqldb;

type
 { TJSONFieldBuffer }

 TJSONFieldBuffer
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _Champs: TChamps;
                        _FieldName: String; _d: TJSONData);
    destructor Destroy; override;
  //Attributs
  public
    Champs: TChamps;
    C: TChamp;
    FieldName: String;
    d: TJSONData;
    sType: String;
  //Méthodes
  public
    procedure Traite; virtual;
  end;

 { TStringJSONFieldBuffer }

 TStringJSONFieldBuffer
 =
  class( TJSONFieldBuffer)
    Value: String;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TJSON_StringJSONFieldBuffer }

 TJSON_StringJSONFieldBuffer
 =
  class( TJSONFieldBuffer)
    Value: String;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TIntegerJSONFieldBuffer }

 TIntegerJSONFieldBuffer
 =
  class( TJSONFieldBuffer)
    Value: Integer;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TDoubleJSONFieldBuffer }

 TDoubleJSONFieldBuffer
 =
  class( TJSONFieldBuffer)
    Value: double;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TBooleanJSONFieldBuffer }

 TBooleanJSONFieldBuffer
 =
  class( TJSONFieldBuffer)
    Value: Boolean;
  //Méthodes
  public
    procedure Traite; override;
  end;

 TIterateur_JSONFieldBuffer
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TJSONFieldBuffer);
    function  not_Suivant( var _Resultat: TJSONFieldBuffer): Boolean;
  end;

 TslJSONFieldBuffer
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
    function Iterateur: TIterateur_JSONFieldBuffer;
    function Iterateur_Decroissant: TIterateur_JSONFieldBuffer;
  end;

 TLink= ^TBatpro_Element;
 TIterateur_Link
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TLink);
    function  not_Suivant( var _Resultat: TLink): Boolean;
  end;

 TslLink
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
    function Iterateur: TIterateur_Link;
    function Iterateur_Decroissant: TIterateur_Link;
  end;

 { ThaJSON__JSON }
 ThaJSON__JSON
 =
  class( ThAggregation)
  //JSON Data
  public
    d: TJSONData;
  //Chargement de tous les détails
  public
    procedure Charge; override;
  end;

 { TblJSON }
 TblJSON
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    q: TDataset;
    slFields: TslJSONFieldBuffer;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Import des champs depuis des données au format JSON
  public
    procedure _from_JSONData( _jsd: TJSONData);
  //Affectation de valeurs aux champs existants depuis des données au format JSON
  private
    procedure Champ_from_JSONData( _c: TChamp; _d: TJSONData);
  public
    procedure Champs_from_JSONData( _jsd: TJSONData);
  //Gestion de liens
  private
    FslLink: TslLink;
    function GetslLink: TslLink;
  public
    property slLink: TslLink read GetslLink;
  //Génération de code
  public
    procedure Genere_code( _Suffixe: String);
  end;

 TIterateur_JSON
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblJSON);
    function  not_Suivant( var _Resultat: TblJSON): Boolean;
  end;

 TslJSON
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
    function Iterateur: TIterateur_JSON;
    function Iterateur_Decroissant: TIterateur_JSON;
  end;

 { TpoolJSON }

 TpoolJSON
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Création à partir d'une chaine JSON
  private
    function Traite_jsd( _jsd: TJSONData): TblJSON;
    procedure Traite_liste( _jsd: TJSONData; _slLoaded: TBatpro_StringList);
  public
    function Get_from_JSON( _JSON: String): TblJSON;
    procedure Charge_from_JSON( _JSON: String; _slLoaded: TBatpro_StringList);
  end;

function poolJSON: TpoolJSON;

implementation

{$R *.lfm}

{ ThaJSON__JSON }

procedure ThaJSON__JSON.Charge;
begin
     inherited Charge;
     poolJSON.Traite_liste( d, slCharge);
     Ajoute_slCharge;
end;

{ TIterateur_JSONFieldBuffer }

function TIterateur_JSONFieldBuffer.not_Suivant( var _Resultat: TJSONFieldBuffer): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_JSONFieldBuffer.Suivant( var _Resultat: TJSONFieldBuffer);
begin
     Suivant_interne( _Resultat);
end;

{ TslJSONFieldBuffer }

constructor TslJSONFieldBuffer.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TJSONFieldBuffer);
end;

destructor TslJSONFieldBuffer.Destroy;
begin
     inherited;
end;

class function TslJSONFieldBuffer.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_JSONFieldBuffer;
end;

function TslJSONFieldBuffer.Iterateur: TIterateur_JSONFieldBuffer;
begin
     Result:= TIterateur_JSONFieldBuffer( Iterateur_interne);
end;

function TslJSONFieldBuffer.Iterateur_Decroissant: TIterateur_JSONFieldBuffer;
begin
     Result:= TIterateur_JSONFieldBuffer( Iterateur_interne_Decroissant);
end;

{ TJSONFieldBuffer }

constructor TJSONFieldBuffer.Create( _sl: TBatpro_StringList;
                                     _Champs: TChamps;
                                     _FieldName: String;
                                     _d: TJSONData);
begin
     inherited Create( _sl);
     Champs:= _Champs;
     FieldName:= _FieldName;
     d:= _d;
     C:= nil;
     sType:= '';
     Traite;
end;

destructor TJSONFieldBuffer.Destroy;
begin
     inherited Destroy;
end;

procedure TJSONFieldBuffer.Traite;
begin

end;

{ TStringJSONFieldBuffer }

procedure TStringJSONFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Ajoute_String( Value, FieldName);
     sType:= 'String';
     Value:= d.AsString;
end;

{ TJSON_StringJSONFieldBuffer }

procedure TJSON_StringJSONFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Ajoute_String( Value, FieldName);
     sType:= 'String';
     Value:= d.AsJSON;
end;

{ TIntegerJSONFieldBuffer }

procedure TIntegerJSONFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Ajoute_Integer( Value, FieldName);
     sType:= 'Integer';
     Value:= d.AsInteger;
end;

{ TDoubleJSONFieldBuffer }

procedure TDoubleJSONFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Ajoute_Float( Value, FieldName);
     sType:= 'FLOAT';
     Value:= d.AsFloat;
end;

{ TBooleanJSONFieldBuffer }

procedure TBooleanJSONFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Ajoute_Boolean( Value, FieldName);
     sType:= 'Boolean';
     Value:= d.AsBoolean;
end;

{ TIterateur_Link }

function TIterateur_Link.not_Suivant( var _Resultat: TLink): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Link.Suivant( var _Resultat: TLink);
begin
     Suivant_interne( _Resultat);
end;

{ TslLink }

constructor TslLink.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, nil{TLink});
end;

destructor TslLink.Destroy;
begin
     inherited;
end;

class function TslLink.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Link;
end;

function TslLink.Iterateur: TIterateur_Link;
begin
     Result:= TIterateur_Link( Iterateur_interne);
end;

function TslLink.Iterateur_Decroissant: TIterateur_Link;
begin
     Result:= TIterateur_Link( Iterateur_interne_Decroissant);
end;

{ TIterateur_JSON }

function TIterateur_JSON.not_Suivant( var _Resultat: TblJSON): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_JSON.Suivant( var _Resultat: TblJSON);
begin
     Suivant_interne( _Resultat);
end;

{ TslJSON }

constructor TslJSON.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblJSON);
end;

destructor TslJSON.Destroy;
begin
     inherited;
end;

class function TslJSON.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_JSON;
end;

function TslJSON.Iterateur: TIterateur_JSON;
begin
     Result:= TIterateur_JSON( Iterateur_interne);
end;

function TslJSON.Iterateur_Decroissant: TIterateur_JSON;
begin
     Result:= TIterateur_JSON( Iterateur_interne_Decroissant);
end;

{ TblJSON }

constructor TblJSON.Create( _sl: TBatpro_StringList;
                                 _q: TDataset;
                                 _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'JSON';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited Create(_sl, _q, _pool);

     q:= _q;
     slFields:= TslJSONFieldBuffer.Create( ClassName+'.slFields');
     FslLink:= nil;
end;

destructor TblJSON.Destroy;
begin
     Free_nil( FslLink);
     Vide_StringList( slFields);
     Free_nil( slFields);
     inherited Destroy;
end;

procedure TblJSON.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
     P.Forte( ThaJSON__JSON, TblJSON, poolJSON);
end;

procedure TblJSON._from_JSONData( _jsd: TJSONData);
var
   jso: TJSONObject;
   I: Integer;
   FieldName: String;
   d: TJSONData;
   fb: TJSONFieldBuffer;
   procedure Traite_Number;
   begin
        fb:= TDoubleJSONFieldBuffer  .Create( sl, Champs, FieldName, d);
   end;
   procedure Traite_String;
   begin
        fb:= TStringJSONFieldBuffer.Create( sl, Champs, FieldName, d);
   end;
   procedure Traite_JSON;
   begin
        fb:= TJSON_StringJSONFieldBuffer.Create( sl, Champs, FieldName, d);
   end;
   procedure Traite_array;
   var
      ha: ThAggregation;
      haJSON: ThaJSON__JSON;
   begin
        ha:= Aggregations.by_Name[ FieldName];
        if Affecte_( haJSON, ThaJSON__JSON, ha) then exit;

        haJSON.d:= d;
        haJSON.Charge;
   end;
   procedure Traite_object;
   var
      bl: TblJSON;
   begin
        bl:= poolJSON.Get_from_JSON(d.AsJSON);
        if nil = bl then exit;

        AggregeLigne( FieldName, bl);
   end;
   procedure Traite_Boolean;
   begin
        fb:= TBooleanJSONFieldBuffer .Create( sl, Champs, FieldName, d);
   end;
   procedure Default;
   begin
        Traite_JSON;
   end;
   function Champ_Existe: Boolean;
   var
      c: TChamp;
   begin
        c:= Champs.Champ_from_Field( FieldName);
        Result:= Assigned( c);
        if not Result then exit;

        Champ_from_JSONData( c, d);
   end;
begin
     if Affecte_( jso, TJSONObject, _jsd) then exit;

     for I:= 0 to jso.Count-1
     do
       begin
       FieldName:= jso.Names[ I];
       d:= jso.Elements[ FieldName];
       if nil = d then continue;

       if Champ_Existe then continue;

       fb:= nil;

       case d.JSONType
       of
         jtUnknown: Default;
         jtNumber : Traite_String;
         jtString : Traite_String;
         jtBoolean: Traite_Boolean;
         jtNull   : Default;
         jtArray  : Traite_array;
         jtObject : Traite_object;
         else       Default;
         end;
       if fb = nil then continue;

       slFields.AddObject( fb.sCle, fb);
       end;
end;

procedure TblJSON.Champ_from_JSONData( _c: TChamp; _d: TJSONData);
   procedure Traite_String ;begin _c.asString := _d.AsString ; end;
   procedure Traite_Boolean;begin _c.asBoolean:= _d.AsBoolean; end;
   procedure Default       ;begin Traite_String;               end;
begin
     case _d.JSONType
     of
       jtUnknown: Default;
       jtNumber : Default;
       jtString : Traite_String;
       jtBoolean: Traite_Boolean;
       jtNull   : Default;
       jtArray  : Default;
       jtObject : Default;
       else       Default;
       end;
end;

procedure TblJSON.Champs_from_JSONData(_jsd: TJSONData);
var
   jso: TJSONObject;
   I: Integer;
   FieldName: String;
   c: TChamp;
   d: TJSONData;
begin
     if Affecte_( jso, TJSONObject, _jsd) then exit;

     for I:= 0 to jso.Count-1
     do
       begin
       FieldName:= jso.Names[ I];

       c:= Champs.Champ_from_Field( FieldName);
       if nil = c then continue;

       d:= jso.Elements[ FieldName];
       if nil = d then continue;

       Champ_from_JSONData( c, d);
       end;
end;

function TblJSON.GetslLink: TslLink;
begin
     if FslLink= nil
     then
         FslLink:= TslLink.Create( Classname+'.sl');
     Result:= FslLink;
end;

procedure TblJSON.Genere_code( _Suffixe: String);
begin
     Generateur_de_code.Execute( Self, _Suffixe);
end;

{ TpoolJSON }

var
   FpoolJSON: TpoolJSON= nil;

function poolJSON: TpoolJSON;
begin
     Clean_Get( Result, FpoolJSON, TpoolJSON);
end;


procedure TpoolJSON.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'JSON';
     Classe_Elements:= TblJSON;
     Classe_Filtre:= nil;

     inherited;

     Pas_de_champ_id:= True;
end;

function TpoolJSON.Traite_jsd(_jsd: TJSONData): TblJSON;
begin
     if Affecte_( Result, TblJSON, Cree_Element( nil)) then exit;
     Result._from_JSONData( _jsd);
     Ajoute( Result);
end;

procedure TpoolJSON.Traite_liste( _jsd: TJSONData;
                                  _slLoaded: TBatpro_StringList);
var
   I: Integer;
   item: TJSONData;
   bl: TblJSON;
begin
     _slLoaded.Clear;
     for I:= 0 to _jsd.Count-1
     do
       begin
       item:= _jsd.Items[ I];
       if nil = item then continue;

       bl:= Traite_jsd( item);
       if nil = bl then continue;

       _slLoaded.AddObject( bl.sCle, bl);
       end;
end;

function TpoolJSON.Get_from_JSON(_JSON: String): TblJSON;
var
   jsp: TJSONParser;
   jsd: TJSONData;
begin
     jsp:= TJSONParser.Create( _JSON);
     jsd:= jsp.Parse as TJSONData;
     try
          Result:= Traite_jsd( jsd);
     finally
            Free_nil( jsp);
            end;
end;


procedure TpoolJSON.Charge_from_JSON( _JSON: String;
                                      _slLoaded: TBatpro_StringList);
var
   jsp: TJSONParser;
   jsd: TJSONData;
   procedure Traite_Object;
   var
      bl: TblJSON;
   begin
        bl:= Traite_jsd( jsd);
        _slLoaded.Clear;
        _slLoaded.AddObject( bl.sCle, bl);
   end;
begin
     jsp:= TJSONParser.Create( _JSON);
     jsd:= jsp.Parse;
     try
        case jsd.JSONType
        of
          jtArray : Traite_liste( jsd, _slLoaded);
          jtObject: Traite_Object;
          end;
     finally
            Free_nil( jsp);
            end;
end;

initialization
finalization
              Clean_destroy( FpoolJSON);
end.
