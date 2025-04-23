unit uOpenAPI;

interface

uses
    //uLog,
    uuStrings,
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
     function sArray: String;
   end;
  TProperties_List= TFPGObjectList<TProperty>;

  { TSchema }

  TSchema
  =
   class( TJSON_Field)
   //Méthodes
   public
     function Get_Properties: TJSONObject;
     function Get_Properties_List: TProperties_List;
   end;

  TSchema_List= TFPGObjectList<TSchema>;

  { TEnum }

  TEnum
  =
   class( TJSON_Field)
   //Méthodes
   public
     function Get_Properties: TJSONObject;
     function Get_Properties_List: TProperties_List;
   end;

  TEnum_List= TFPGObjectList<TEnum>;

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
     jd: TJSONData;
     jo: TJSONObject;
   //Méthodes
   public
     function Get_Components: TJSONObject;
     function Get_Schemas: TJSONObject;
     function Get_Schemas_List: TSchema_List;
     function Get_Enums_List: TEnum_List;
   end;

implementation

function uOpenAPI_ClassName_from_SchemaName( _s: String): String;
begin
     Result:= StringReplace( _s, '-','_',[rfReplaceAll]);
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
    var
       items: TJSONObject;
    begin
         typ_is_array:= True;
         items:= jo.Objects['items'];
              if -1 <> items.IndexOfName('type') then typ:= items.Strings['type']
         else if -1 <> items.IndexOfName('$ref') then typ:= Class_from_ref( items.Strings['$ref'])
         else                                         typ:= 'Aggregation ref non trouvé : '+items.AsJSON;
    end;
    procedure Traite_string;
    begin
         if     (-1 <> jo.IndexOfName('format' ) )
            and ( 'date-time' = jo.Strings['format'])
         then
             typ:= 'date-time';
    end;
begin
     inherited Create(_name, _jo);
     typ_is_class:= False;
     typ_is_enum:= False;
     typ_is_array:= False;
          if -1 <> jo.IndexOfName('type' ) then typ:= jo.Strings['type']
     else if not_Traite_ref( '', jo)
     then if not_Traite_allOf
     then if not_Traite_anyOf
     then typ:= 'type non trouvé: '+jo.AsJSON;

          if 'array'  = typ then Traite_array
     else if 'string' = typ then Traite_string;
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

{ TEnum }

function TEnum.Get_Properties: TJSONObject;
begin

end;

function TEnum.Get_Properties_List: TProperties_List;
begin

end;


{ TOpenAPI }

constructor TOpenAPI.Create( _Filename: String);
var
   F: TFileStream;
   json: TJSONData;
begin
     F:= TFileStream.Create( _Filename, fmOpenRead);
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

end.
