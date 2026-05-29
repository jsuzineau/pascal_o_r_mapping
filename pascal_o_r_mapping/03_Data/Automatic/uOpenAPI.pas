unit uOpenAPI;

interface

uses
    //uLog,
    uuStrings,
    uBatpro_StringList,
 Classes, SysUtils,fpjson,jsonparser,fgl, StrUtils;

type

  { TJSON_Field }

  TJSON_Field
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Attributs
   public
     name: String;
     jo: TJSONObject;
   end;

  TJSON_Field_List= TFPGObjectList<TJSON_Field>;

  { TOpenAPI_JSON_Field }

  TOpenAPI_JSON_Field
  =
   class( TJSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Parametres (rajouté pour chainage de variables entre niveau classe et niveau application)
   public
     slParametres: TBatpro_StringList;
     function RemplaceParametres( _Prefixe, S: String): String;
     procedure Log_slParametres;
   //déboguage
   private
     Log_Actif: Boolean;
     slLog: TBatpro_StringList;
   //Recherche/remplacement par les valeurs dans un modèle
   public
     function Produit( _Prefixe, _sModele: String): String;
   end;

  TOpenAPI_JSON_Field_List= TFPGObjectList<TOpenAPI_JSON_Field>;

  { TProperty }

  TProperty
  =
   class( TJSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Attributs
   public
     typ_is_class: boolean;
     typ_is_array: boolean;
     typ_is_enum: boolean;
     typ: string;
     nullable: boolean;
     description: String;
     function sArray: String;
   end;
  TProperties_List= TFPGObjectList<TProperty>;

  { TSchema }

  TSchema
  =
   class( TJSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Attributs
   public
     description: String;
   //Méthodes
   public
     function Get_Properties: TJSONObject;
     function Get_Properties_List: TProperties_List;
   end;

  TSchema_List= TFPGObjectList<TSchema>;

  { TProperty }

  { TEnumValue }

  TEnumValue
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _Libelle: String);
     destructor Destroy; override;
   //Attributs
   public
     name: String;
     libelle: String;
   end;
  TEnumValue_List= TFPGObjectList<TEnumValue>;

  { TEnum }

  TEnum
  =
   class( TJSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Attributs
   public
     slDescription: TStringList;
     procedure slDescription_from_Description;
   //Méthodes
   public
     function Get_Enum: TJSONArray;
     function Get_Description: String;
     function Get_EnumValue_List: TEnumValue_List;
   end;

  TEnum_List= TFPGObjectList<TEnum>;

  { TVerb_Parameter }

  TVerb_Parameter
  =
   class( TOpenAPI_JSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _jo: TJSONObject);
     destructor Destroy; override;
   //Recherche/remplacement par les valeurs dans un modèle
   public
     function Produit( _Prefixe, _sModele: String): String;
   end;

  TVerb_Parameter_List= TFPGObjectList<TVerb_Parameter>;

  { TVerb_Property }

  TVerb_Property
  =
   class( TOpenAPI_JSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Recherche/remplacement par les valeurs dans un modèle
   public
     function Produit( _Prefixe, _sModele: String): String;
   end;

  TVerb_Property_List= TFPGObjectList<TVerb_Property>;

  { TVerb }

  TVerb
  =
   class( TOpenAPI_JSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Méthodes
   public
     function Get_Parameters: TJSONArray;
     function Get_Properties: TJSONObject;

     function Get_Parameter_List: TVerb_Parameter_List;
     function Get_Property_List: TVerb_Property_List;
   //Recherche/remplacement par les valeurs dans un modèle
   public
     function Produit( _Prefixe, _sModele: String): String;
   end;

  TVerb_List= TFPGObjectList<TVerb>;

  { TOpenAPI_JSON_Field }

  { TPath }

  TPath
  =
   class( TOpenAPI_JSON_Field)
   //Gestion du cycle de vie
   public
     constructor Create( _name: String; _jo: TJSONObject);
     destructor Destroy; override;
   //Attributs
   public
     Nom_de_la_classe: String;
   //Méthodes
   public
     function Get_Verb_List: TVerb_List;
   //Recherche/remplacement par les valeurs dans un modèle
   public
     function Produit( _Prefixe, _sModele: String): String;
   end;

  TPath_List= TFPGObjectList<TPath>;

  { TOpenAPI }

  TOpenAPI
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _Filename: String);
     destructor Destroy; override;
   //Attributs
   public
     Filename: String;
     jd: TJSONData;
     jo: TJSONObject;
   //Méthodes
   public
     function Get_Components: TJSONObject;
     function Get_Schemas: TJSONObject;
     function Get_Paths: TJSONObject;
   //
   public
     function Get_Schemas_List: TSchema_List;
     function Get_Enums_List: TEnum_List;
     function Get_Paths_List: TPath_List;
   end;

implementation

function uOpenAPI_ClassName_from_SchemaName( _s: String): String;
begin
     Result:= StringReplace( _s, '-','_',[rfReplaceAll]);
end;

function uOpenAPI_ClassName_from_PathName( _s: String): String;
begin
     Result:= StringReplace( _s, '-','_',[rfReplaceAll]);
     Result:= StringReplace( _s, '/','_',[rfReplaceAll]);
     Result:= StringReplace( _s, '{','_',[rfReplaceAll]);
     Result:= StringReplace( _s, '}','_',[rfReplaceAll]);
     Result:= StringReplace( _s, '.','_',[rfReplaceAll]);
end;

{ TJSON_Field }

constructor TJSON_Field.Create( _name: String; _jo: TJSONObject);
begin
     name:= _name;
     jo  := _jo;
end;

destructor TJSON_Field.Destroy;
begin
     inherited Destroy;
end;

{ TOpenAPI_JSON_Field }

constructor TOpenAPI_JSON_Field.Create(_name: String; _jo: TJSONObject);
begin
     inherited Create(_name, _jo);
     slLog  := TBatpro_StringList.Create;
end;

destructor TOpenAPI_JSON_Field.Destroy;
begin
     FreeAndNil( slLog);
     inherited Destroy;
end;

procedure TOpenAPI_JSON_Field.Log_slParametres;
var
   I: Integer;
   OldKey, NewKey: String;
begin
     for I:= 0 to slParametres.Count -1
     do
       begin
       OldKey:= slParametres.Names [ I];
       NewKey:= slParametres.Values[OldKey];
       if '' = Trim(NewKey) then continue;

       //if Log_Actif then
       slLog.Add( ClassName+'.Log_slParametres: Remplacement de:');
       slLog.Add( OldKey);
       slLog.Add( 'par :');
       slLog.Add( NewKey);
       slLog.Add( '##########################');
       end;
end;

function TOpenAPI_JSON_Field.RemplaceParametres(_Prefixe, S: String): String;
var
   I: Integer;
   OldKey, NewKey: String;
begin
     Result:= S;
     for I:= 0 to slParametres.Count -1
     do
       begin
       OldKey:= slParametres.Names [ I];
       NewKey:= slParametres.Values[OldKey];
       //if '' = Trim(NewKey) then continue;

       Result:= StringReplace(Result,_Prefixe+OldKey,NewKey,[rfReplaceAll,rfIgnoreCase]);
       end;
end;

function TOpenAPI_JSON_Field.Produit(_Prefixe, _sModele: String): String;
begin

end;

{ TProperty }

constructor TProperty.Create(_name: String; _jo: TJSONObject);
    function Class_from_ref( _ref: String): String;
    begin
         typ_is_class:= True;
         Result:= _ref;
         if 1 = Pos('#/components/schemas/', Result)
         then
             StrToK( '#/components/schemas/', Result);
         Result:= uOpenAPI_ClassName_from_SchemaName( Result);
         typ_is_enum:=1 = Pos( 'enum_', Result);
    end;
    function not_Traite_type( _contexte: String; _jo: TJSONObject): Boolean;
    var
       jt: TJSONtype;
    begin
         Result:= -1 = _jo.IndexOfName('type' );
         if Result then exit;

         jt:= _jo.Types['type'];
         case jt
         of
           jtArray:
             typ:= _jo.Arrays ['type'].Strings[0];//provisoire
           else
             typ:= _jo.Strings['type'];
         end;
    end;
    function not_Traite_ref( _contexte: String; _jo: TJSONObject): Boolean;
    begin
         Result:= -1 = _jo.IndexOfName('$ref');
         if Result
         then
             typ:= _contexte+' ref non trouvé : '+_jo.AsJSON
         else
             typ:= Class_from_ref( _jo.Strings['$ref']);
    end;
    function not_Traite_allOf: Boolean;
    begin
         Result:= -1 = _jo.IndexOfName('allOf');
         if Result then exit;

         Result:= not_Traite_ref( 'allOf', jo.Arrays['allOf'].Objects[0]);
    end;
    function not_Traite_anyOf: Boolean;
    begin
         Result:= -1 = _jo.IndexOfName('anyOf');
         if Result then exit;

         Result:= not_Traite_ref( 'anyOf', jo.Arrays['anyOf'].Objects[0]);
    end;
    procedure Traite_array;
       procedure Traite_items;
       var
          items: TJSONObject;
       begin
            items:= jo.Objects['items'];
                 if not_Traite_type( 'array items', items)
            then if -1 <> items.IndexOfName('$ref') then typ:= Class_from_ref( items.Strings['$ref'])
            else                                         typ:= 'Aggregation ref non trouvé : '+items.AsJSON;
       end;
    begin
         typ_is_array:= True;

         if -1 = jo.IndexOfName('items')
         then
             typ:= 'Tableau sans items : '+jo.AsJSON
         else
             Traite_items;
    end;
    procedure Traite_string;
    begin
         if     (-1 <> jo.IndexOfName('format' ) )
            and ( 'date-time' = jo.Strings['format'])
         then
             typ:= 'date-time';
    end;
    procedure Traite_number;
    begin
         if     (-1 <> jo.IndexOfName('format' ) )
            and ( 'float' = jo.Strings['format'])
         then
             typ:= 'float';
    end;
    procedure Traite_nullable;
    begin
         nullable:= -1 <> jo.IndexOfName( 'nullable');
         if not nullable then exit;

         nullable:= jo.Booleans[ 'nullable'];
    end;
    procedure Traite_description;
    begin
         if -1 = jo.IndexOfName( 'description')
         then
             description:= ''
         else
             description:= jo.Strings[ 'description'];
    end;
begin
     inherited Create(_name, _jo);
     typ_is_class:= False;
     typ_is_enum:= False;
     typ_is_array:= False;
          if not_Traite_type( '', jo)
     then if not_Traite_ref ( '', jo)
     then if not_Traite_allOf
     then if not_Traite_anyOf
     then typ:= 'type non trouvé: '+jo.AsJSON;

          if 'array'  = typ then Traite_array
     else if 'string' = typ then Traite_string
     else if 'number' = typ then Traite_number;
     Traite_nullable;
     Traite_description;
end;

destructor TProperty.Destroy;
begin
     inherited Destroy;
end;

function TProperty.sArray: String;
begin
     if typ_is_array
     then
         if typ_is_class
         then
             Result:= 'Aggregation '
         else
             Result:= 'array of '
     else
         Result:= '';
end;

{ TSchema }

constructor TSchema.Create(_name: String; _jo: TJSONObject);
    procedure Traite_description;
    begin
         if -1 = jo.IndexOfName( 'description')
         then
             description:= ''
         else
             description:= jo.Strings[ 'description'];
    end;
begin
     inherited Create(_name, _jo);
     Traite_description;
end;

destructor TSchema.Destroy;
begin
     inherited Destroy;
end;

function TSchema.Get_Properties: TJSONObject;
begin
     if -1 <> jo.IndexOfName('properties' )
     then
         Result:= jo.Objects['properties']
     else
         Result:= nil;
end;

function TSchema.Get_Properties_List: TProperties_List;
var
   properties: TJSONObject;
   I: Integer;
   name: String;
   p: TProperty;
begin
      Result:= TProperties_List.Create(True);
      properties:= Get_Properties;
      if Assigned(properties)
      then
          for I:= 0 to properties.Count-1
          do
            begin
            name:= properties.Names[I];
            p:= TProperty.Create( name, properties.Objects[name]);
            Result.Add( p);
            end
      else
          begin
          //Log.PrintLn( 'Schema sans properties: '+name);
          end;
end;

{ TEnumValue }

constructor TEnumValue.Create(_name: String; _Libelle: String);
begin
     name   := _name;
     libelle:= _Libelle;
end;

destructor TEnumValue.Destroy;
begin
     inherited Destroy;
end;

{ TEnum }

constructor TEnum.Create(_name: String; _jo: TJSONObject);
begin
     inherited Create(_name, _jo);
     slDescription:= TStringList.Create;
     slDescription_from_Description;
end;

destructor TEnum.Destroy;
begin
     FreeAndNil( slDescription);
     inherited Destroy;
end;

procedure TEnum.slDescription_from_Description;
var
   sl: TStringList;
   I: Integer;
   Line: String;
   Cle, Libelle: String;
begin
     sl:= TStringList.Create;
     try
        sl.Text:= Get_Description;
        for I:= 0 to sl.Count-1
        do
          begin
          Line:= sl[I];
          StrTok(' - ', Line);
          Cle    := StrTok(' -> ', Line);
          Libelle:= Line;
          slDescription.Values[Cle]:=Libelle;
          end;
     finally
            FreeAndNil( sl);
            end;
end;

function TEnum.Get_Enum: TJSONArray;
begin
      if -1 <> jo.IndexOfName('enum' )
      then
          Result:= jo.Arrays['enum']
      else
          Result:= nil;
end;

function TEnum.Get_Description: String;
begin
      if -1 <> jo.IndexOfName('description' )
      then
          Result:= jo.Strings['description']
      else
          Result:= '';
end;

function TEnum.Get_EnumValue_List: TEnumValue_List;
var
   enum: TJSONArray;
   I: Integer;
   name: String;
   libelle: String;
   ev: TEnumValue;
begin
      Result:= TEnumValue_List.Create(True);
      enum:= Get_Enum;
      if Assigned(enum)
      then
          for I:= 0 to enum.Count-1
          do
            begin
            name:= enum.Strings[I];
            if -1 = slDescription.IndexOfName( name)
            then
                libelle:= name
            else
                libelle:= slDescription.Values[name];
            ev:= TEnumValue.Create( name, libelle);
            Result.Add( ev);
            end
      else
          begin
          //Log.PrintLn( 'Schema sans properties: '+name);
          end;
end;

{ TVerb_Parameter }

constructor TVerb_Parameter.Create( _jo: TJSONObject);
begin
     name:= _jo.Strings['name'];
     inherited Create( name, _jo);
end;

destructor TVerb_Parameter.Destroy;
begin
     inherited Destroy;
end;

function TVerb_Parameter.Produit(_Prefixe, _sModele: String): String;
begin
     Result:= _sModele;
     Result:= StringReplace( Result, _Prefixe+'Parameter', name,[rfReplaceAll,rfIgnoreCase]);
     //Result:= RemplaceParametres( _Prefixe, Result);
end;

{ TVerb_Property }

constructor TVerb_Property.Create(_name: String; _jo: TJSONObject);
begin
     inherited Create(_name, _jo);
end;

destructor TVerb_Property.Destroy;
begin
     inherited Destroy;
end;

function TVerb_Property.Produit(_Prefixe, _sModele: String): String;
begin
     Result:= _sModele;
     Result:= StringReplace( Result, _Prefixe+'Property', name,[rfReplaceAll,rfIgnoreCase]);
     //Result:= RemplaceParametres( _Prefixe, Result);
end;

{ TVerb }

constructor TVerb.Create(_name: String; _jo: TJSONObject);
begin
     inherited Create(_name, _jo);
end;

destructor TVerb.Destroy;
begin
     inherited Destroy;
end;

function TVerb.Get_Parameters: TJSONArray;
var
   d: TJSONData;
   //t: TJSONtype;
begin
     d:= jo.FindPath( 'parameters');
     //t:= d.JSONType;
     Result:= d as TJSONArray;
end;

function TVerb.Get_Properties: TJSONObject;
begin
     Result:= jo.FindPath( 'requestBody.content.application/x-www-form-urlencoded.schema.properties') as TJSONObject;
end;

function TVerb.Get_Parameter_List: TVerb_Parameter_List;
var
   parameters: TJSONArray;
   I: Integer;
   p: TVerb_Parameter;
begin
     Result:= TVerb_Parameter_List.Create(True);
     parameters:= Get_Parameters;
     if nil = parameters then exit;

     for I:= 0 to parameters.Count-1
     do
       begin
       p:= TVerb_Parameter.Create( parameters.Objects[I]);
       Result.Add( p);
       end;
end;

function TVerb.Get_Property_List: TVerb_Property_List;
var
   properties: TJSONObject;
   I: Integer;
   p_name: String;
   p: TVerb_Property;
begin
     Result:= TVerb_Property_List.Create(True);
     properties:= Get_Properties;
     if nil = properties then exit;

     for I:= 0 to properties.Count-1
     do
       begin
       p_name:= properties.Names[I];
       p:= TVerb_Property.Create( p_name, properties.Objects[p_name]);
       Result.Add( p);
       end;
end;

function TVerb.Produit(_Prefixe, _sModele: String): String;
begin
     Result:= _sModele;
     Result:= StringReplace( Result, _Prefixe+'Verb', name,[rfReplaceAll,rfIgnoreCase]);
     //Result:= RemplaceParametres( _Prefixe, Result);
end;

{ TPath }

constructor TPath.Create(_name: String; _jo: TJSONObject);
begin
     inherited Create(_name, _jo);
     Nom_de_la_classe:= uOpenAPI_ClassName_from_PathName( name);
end;

destructor TPath.Destroy;
begin
     //Log_slParametres;
     //if Pos( 'Customer', Nom_de_la_table) <> 0
     //then
     //    slLog.SaveToFile( g.sRepertoireResultat+'table_'+Nom_de_la_table+'.log');

     inherited Destroy;
end;

function TPath.Get_Verb_List: TVerb_List;
var
   I: Integer;
   v_name: String;
   v: TVerb;
begin
     Result:= TVerb_List.Create(True);
     for I:= 0 to jo.Count-1
     do
       begin
       v_name:= jo.Names[I];
       v:= TVerb.Create( v_name, jo.Objects[v_name]);
       Result.Add( v);
       end;
end;

function TPath.Produit(_Prefixe, _sModele: String): String;
begin
     Result:= _sModele;
     Result:= StringReplace( Result, _Prefixe+'Name'            , name            ,[rfReplaceAll,rfIgnoreCase]);
     Result:= StringReplace( Result, _Prefixe+'Nom_de_la_classe', Nom_de_la_classe,[rfReplaceAll,rfIgnoreCase]);
     //Result:= RemplaceParametres( _Prefixe, Result);
end;


{ TOpenAPI }

constructor TOpenAPI.Create( _Filename: String);
var
   F: TFileStream;
   json: TJSONData;
begin
     Filename:= _Filename;
     F:= TFileStream.Create( Filename, fmOpenRead);
     try
        jd:= GetJSON( F);
        jo:= jd as TJSONObject;
     finally
            FreeAndNil( F);
            end;
end;

destructor TOpenAPI.Destroy;
begin
     FreeAndNil( jd);
     inherited Destroy;
end;

function TOpenAPI.Get_Components: TJSONObject;
begin
     Result:= jo.Objects['components'];
end;

function TOpenAPI.Get_Schemas: TJSONObject;
begin
     Result:= Get_Components.Objects['schemas'];
end;

function TOpenAPI.Get_Paths: TJSONObject;
begin
     Result:= jo.Objects['paths'];
end;

function TOpenAPI.Get_Schemas_List: TSchema_List;
var
   schemas: TJSONObject;
   I: Integer;
   name: String;
   ClassName: String;
   s: TSchema;
begin
      Result:= TSchema_List.Create(True);
      schemas:= Get_Schemas;
      for I:= 0 to schemas.Count-1
      do
        begin
        name:= schemas.Names[I];
        if 1 = Pos( 'enum_', name) then continue;

        ClassName:= uOpenAPI_ClassName_from_SchemaName( name);
        s:= TSchema.Create( ClassName, schemas.Objects[name]);
        Result.Add( s);
        end;
end;

function TOpenAPI.Get_Enums_List: TEnum_List;
var
   schemas: TJSONObject;
   I: Integer;
   name: String;
   ClassName: String;
   e: TEnum;
begin
      Result:= TEnum_List.Create(True);
      schemas:= Get_Schemas;
      for I:= 0 to schemas.Count-1
      do
        begin
        name:= schemas.Names[I];
        if 1 <> Pos( 'enum_', name) then continue;

        ClassName:= uOpenAPI_ClassName_from_SchemaName( name);
        e:= TEnum.Create( ClassName, schemas.Objects[name]);
        Result.Add( e);
        end;
end;

function TOpenAPI.Get_Paths_List: TPath_List;
var
   paths: TJSONObject;
   I: Integer;
   name: String;
   p: TPath;
begin
     Result:= TPath_List.Create(True);
     paths:= Get_Paths;
     for I:= 0 to paths.Count-1
     do
       begin
       name:= paths.Names[I];
       p:= TPath.Create( name, paths.Objects[name]);
       Result.Add( p);
       end;
end;

end.
