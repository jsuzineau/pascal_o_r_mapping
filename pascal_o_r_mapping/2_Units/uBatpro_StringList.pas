unit uBatpro_StringList;
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
    JCLDebug,
    uClean,
    SysUtils, Classes,fpjson;

type
 EBatpro_StringList_Iterateur_running
 =
  class( Exception)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  end;

 EBatpro_StringList_Classe_Elements_indefini
 =
  class( Exception)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  end;

 { TJSONProvider }

 TJSONProvider
 =
  class
    //Export JSON, JavaScript Object Notation
    protected
      function  GetJSON: String; virtual;
      {$IFDEF FPC}
      procedure SetJSON( _Value: String); virtual;
      {$ENDIF}
    public
      property JSON: String
               read GetJSON
               {$IFDEF FPC}
               write SetJSON
               {$ENDIF}
               ;
      function JSON_Persistants: String; virtual;
  end;

 T_Iterateur_Count= function :Integer of Object;
 T_Iterateur_By_Index= procedure ( _Index: Integer; out _S: String; out _Resultat) of Object;
 T_Iterateur_Delete_By_Index= procedure ( _Index: Integer) of Object;

 TIterateur
 =
  class( TInterfacedObject)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String;
                        _Count: T_Iterateur_Count;
                        _By_Index: T_Iterateur_By_Index;
                        _Delete_By_Index: T_Iterateur_Delete_By_Index;
                        _Decroissant: Boolean);
    destructor Destroy; override;
  //Nom
  public
    Nom: String;
  // Comptage de éléments
  private
    Count: T_Iterateur_Count;
  // Accés par index
  private
    By_Index: T_Iterateur_By_Index;
  // Suppression d'un élément
  private
    Delete_By_Index: T_Iterateur_Delete_By_Index;
  //Sens d'itération Decroissant
  private
    Decroissant: Boolean;
  //Iterateur
  private
    Frunning: Boolean;
  public
    nSuivant: Integer;//mis en public pour tests

    Current_S: String; //chaine associée

    procedure Start;
    procedure Stop;

    // 2012/03/19 tentative de sécuriser l'appel en déclarant des itérateurs
    // pour chaque classe utilisatrice
    procedure Suivant_interne( out _Resultat);
    function  not_Suivant_interne( out _Resultat): Boolean;
  private
    procedure Suivant( out _Resultat);
    function  not_Suivant( out _Resultat): Boolean;
  public
    procedure Supprime_courant;
    function  EOF: Boolean;
    function Continuer: Boolean;
  end;

 TIterateur_Class= class of TIterateur;

 { TBatpro_StringList }

 TBatpro_StringList
 =
  class( TStringList)
  //Gestion du cycle de vie
  private
    procedure Create_Interne;
  public
    constructor Create( _Nom: String= ''); virtual;
    constructor CreateE( _Nom: String= ''; _Classe_Elements: TClass = nil);
    destructor Destroy; override;
  //Personnalisation de la comparaison de chaines (plus rapide que l'original)
  {$IFNDEF FPC}
  protected
    function CompareStrings(const S1:String;const S2:String):Integer;override;
  {$ENDIF}
  //Nom
  public
    Nom: String;
  //Classe des éléments
  protected
    Classe_Elements: TClass;
  //Iterateur  (première mouture de l'itérateur)
  private
    FIterateur_running: Boolean;
  public
    nIterateur_Suivant: Integer;//mis en public pour tests

    procedure Iterateur_Start;
    procedure Iterateur_Stop;
    procedure Iterateur_Suivant( out _Resultat);
    procedure Iterateur_Supprime_courant;
    function  Iterateur_EOF: Boolean;
  //Création d'itérateur (nouvelle mouture de l'itérateur: 2011/11/09)
  private
    function Iterateur_Count: Integer;
    procedure By_Index( _Index: Integer; out _S: String; out _Resultat);
  protected
    class function Classe_Iterateur: TIterateur_Class; virtual;
  public
    // 2012/03/19 tentative de sécuriser l'appel en déclarant des itérateurs
    // pour chaque classe utilisatrice
    function Iterateur_interne: TIterateur;
    function Iterateur_interne_Decroissant: TIterateur;
  private
    function Iterateur: TIterateur;
    function Iterateur_Decroissant: TIterateur;
  //Effacement sécurisé (peut être appelé si non affecté) (aggrégation faible) voir Vide
  public
    procedure Efface;
  //Effacement de la ligne correspondant à un objet donné
  public
    procedure Remove( O: TObject);
  //Vide = Efface + détruit chaque objet contenu (aggrégation forte)
  public
      procedure Vide;
  //Export JSON, JavaScript Object Notation
  public
    JSON_Page : Integer;
    JSON_Debut: Integer;
    JSON_Fin  : Integer;
    procedure JSON_Premiere_Page;
    procedure JSON_Page_precedente;
    procedure JSON_Page_suivante;
    function JSON: String; virtual;
    function JSON_Persistants: String; virtual;
    function JSON_Persistants_Complet: String;
  //
  //public
  //  procedure S_Object_from_Index( _Index: Integer; out _S: String; out _O: TObject);
  end;

 TBatpro_StringList_class= class of TBatpro_StringList;

 TIterateur_Batpro_StringList
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TBatpro_StringList);
    function  not_Suivant( out _Resultat: TBatpro_StringList): Boolean;
  end;

 TslBatpro_StringList
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
    function Iterateur: TIterateur_Batpro_StringList;
    function Iterateur_Decroissant: TIterateur_Batpro_StringList;
  end;

 TIterateur_Object
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TObject);
    function  not_Suivant( out _Resultat: TObject): Boolean;
  end;

 TslObject
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
    function Iterateur: TIterateur_Object;
    function Iterateur_Decroissant: TIterateur_Object;
  end;


function Object_from_sl( sl: TStringList; Index: Integer): TObject;
function Object_from_sl_sCle( sl: TStringList; sCle: String): TObject;
// les procedures suivantes évitent de réécrire des routines comme
// Object_from_sl avec des types dérivées
// mais peuvent se révéler dangereuses si l'on change le type de la variable
// passée comme Resultat sans aller mettre à jour le paramètre Classe

procedure CheckClass( var Resultat; Classe: TClass);

procedure _Classe_from_sl     ( out Resultat; Classe: TClass;
                                sl: TStringList; Index: Integer);
procedure _Classe_from_sl_sCle( out Resultat; Classe: TClass;
                                sl: TStringList; sCle: String);

function Affecte( out O          ;
                  Classe: TClass ;
                  Valeur: TObject): Boolean;

function Affecte_( out O          ;
                   Classe: TClass ;
                   Valeur: TObject): Boolean;


function TJSONProvider_from_Object( O: TObject): TJSONProvider;

implementation

function Object_from_sl( sl: TStringList; Index: Integer): TObject;
begin
     Result:= nil;

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     Result:= sl.Objects[ Index];
end;

//version plus lente avec 2 accés à la liste, mais basée sur TStringList
function Object_S_from_sl( sl: TStringList; Index: Integer; out _S: String): TObject;
begin
     Result:= nil;
     _S:= '';

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     _S    := sl.Strings[ Index];
     Result:= sl.Objects[ Index];
end;

(*
//version utilisant S_Object_from_Index défini sur TBatpro_StringList
function Object_S_from_sl( sl: TBatpro_StringList; Index: Integer; out _S: String): TObject;
begin
     Result:= nil;
     _S:= '';

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     sl.S_Object_from_Index( Index, _S, Result);
end;
*)

function Object_from_sl_sCle( sl: TStringList; sCle: String): TObject;
begin
     Result:= nil;
     if sl = nil then exit;
     Result:= Object_from_sl( sl, sl.IndexOf( sCle))
end;

procedure CheckClass( var Resultat; Classe: TClass);
     procedure Set_to_nil;
     begin
          TObject( Resultat):= nil;
     end;
     procedure Gere_Exception( _E: Exception);
     var
        sl: TStringList;
     begin
          sl:= TStringList.Create;
          sl.Add( 'Exception '+_E.Classname+' dans uBatpro_StringList.CheckClass'
                  +'( $'+IntToHex(Integer(Pointer(Resultat)),8)+', '+Classe.ClassName+'):'#13#10
                  +_E.Message);
          sl.Add( 'Pile d''appels:');
          JclLastExceptStackListToStrings( sl, True, True, True, True);

          uClean_Log( sl.Text);
          Free_nil( sl);

          Set_to_nil;
     end;
begin
     if TObject( Resultat) = nil then exit;
     if Classe             = nil then exit;

     try
         if not ( TObject( Resultat) is Classe)
         then
             Set_to_nil;
     except
           on E:Exception do Gere_Exception( E);
           end;
end;

procedure _Classe_from_sl( out Resultat; Classe: TClass;
                           sl: TStringList; Index: Integer);
begin
     TObject( Resultat):= Object_from_sl( sl, Index);
     CheckClass( Resultat, Classe);
end;

procedure _S_Classe_from_sl( out _S: String; out _Resultat; _Classe: TClass;
                             _sl: TBatpro_StringList; _Index: Integer);
begin
     TObject( _Resultat):= Object_S_from_sl( _sl, _Index, _S);
     CheckClass( _Resultat, _Classe);
end;

procedure _Classe_from_sl_sCle( out Resultat; Classe: TClass;
                                sl: TStringList; sCle: String);
begin
     TObject( Resultat):= Object_from_sl_sCle( sl, sCle);
     CheckClass( Resultat, Classe);
end;

function Affecte_( out O          ;
                   Classe: TClass ;
                   Valeur: TObject): Boolean;
begin
     TObject(O):= Valeur;
     CheckClass( O, Classe);

     Result:= TObject(O) = nil;
end;

function Affecte( out O          ;
                  Classe: TClass ;
                  Valeur: TObject): Boolean;
begin
     Result:= not Affecte_( O, Classe, Valeur);
end;

function TJSONProvider_from_Object( O: TObject): TJSONProvider;
begin
     Result:= TJSONProvider(O);
     CheckClass( Result, TJSONProvider);
end;

{ EBatpro_StringList_Iterateur_running }

constructor EBatpro_StringList_Iterateur_running.Create( _Nom: String);
begin
     inherited Create(  'Erreur à signaler au développeur:'#13#10
                       +'  L''itérateur de ('+_Nom+': TBatpro_StringList) est déjà en cours d''utilisation');
end;

destructor EBatpro_StringList_Iterateur_running.Destroy;
begin

     inherited;
end;

{ EBatpro_StringList_Classe_Elements_indefini }

constructor EBatpro_StringList_Classe_Elements_indefini.Create( _Nom: String);
begin
     inherited Create(  'Erreur à signaler au développeur:'#13#10
                       +'  La classe d''éléments n''est pas définie sur l''itérateur');
end;

destructor EBatpro_StringList_Classe_Elements_indefini.Destroy;
begin
     inherited;
end;

{ TIterateur_Batpro_StringList }

function TIterateur_Batpro_StringList.not_Suivant( out _Resultat: TBatpro_StringList): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Batpro_StringList.Suivant( out _Resultat: TBatpro_StringList);
begin
     Suivant_interne( _Resultat);
end;

{ TIterateur_Object }

function TIterateur_Object.not_Suivant( out _Resultat: TObject): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Object.Suivant( out _Resultat: TObject);
begin
     Suivant_interne( _Resultat);
end;

{ TslObject }

constructor TslObject.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TObject);
end;

destructor TslObject.Destroy;
begin
     inherited;
end;

class function TslObject.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Object;
end;

function TslObject.Iterateur: TIterateur_Object;
begin
     Result:= TIterateur_Object( Iterateur_interne);
end;

function TslObject.Iterateur_Decroissant: TIterateur_Object;
begin
     Result:= TIterateur_Object( Iterateur_interne_Decroissant);
end;

{ TslBatpro_StringList }

constructor TslBatpro_StringList.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TBatpro_StringList);
end;

destructor TslBatpro_StringList.Destroy;
begin
     inherited;
end;

class function TslBatpro_StringList.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Batpro_StringList;
end;

function TslBatpro_StringList.Iterateur: TIterateur_Batpro_StringList;
begin
     Result:= TIterateur_Batpro_StringList( Iterateur_interne);
end;

function TslBatpro_StringList.Iterateur_Decroissant: TIterateur_Batpro_StringList;
begin
     Result:= TIterateur_Batpro_StringList( Iterateur_interne_Decroissant);
end;

{ TBatpro_StringList }

procedure TBatpro_StringList.Create_Interne;
begin
     FIterateur_running:= False;

     JSON_Page:= 20;
     JSON_Debut:=-1;
     JSON_Fin  :=-1;
end;

constructor TBatpro_StringList.Create( _Nom: String= '');
begin
     inherited Create;
     Nom:= _Nom;
     Classe_Elements:= nil;

     Create_Interne;
end;

constructor TBatpro_StringList.CreateE( _Nom: String= '';
                                        _Classe_Elements: TClass = nil);
begin
     inherited Create;
     Nom:= _Nom;

     Classe_Elements:= _Classe_Elements;

     Create_Interne;
end;

destructor TBatpro_StringList.Destroy;
begin
     inherited;
end;

{$IFNDEF FPC}
function TBatpro_StringList.CompareStrings( const S1, S2: String): Integer;
begin
     Result:= CompareStr( S1, S2);
end;
{$ENDIF}

procedure TBatpro_StringList.Iterateur_Start;
begin
     if FIterateur_running
     then
         raise EBatpro_StringList_Iterateur_running.Create( Nom);

     if Classe_Elements = nil
     then
         raise EBatpro_StringList_Classe_Elements_indefini.Create( Nom);

     FIterateur_running:= True;
     nIterateur_Suivant:= 0;
end;

procedure TBatpro_StringList.Iterateur_Stop;
begin
     FIterateur_running:= False;
end;

procedure TBatpro_StringList.Iterateur_Suivant( out _Resultat);
begin
     _Classe_from_sl( _Resultat, Classe_Elements, Self, nIterateur_Suivant);
     Inc( nIterateur_Suivant);
end;

procedure TBatpro_StringList.Iterateur_Supprime_courant;
begin
     Dec( nIterateur_Suivant);
     if nIterateur_Suivant = -1 then exit;
     if Iterateur_EOF           then exit;
     Delete( nIterateur_Suivant);
end;

function TBatpro_StringList.Iterateur_EOF: Boolean;
begin
     Result:= nIterateur_Suivant >= Count;
end;

procedure TBatpro_StringList.By_Index( _Index: Integer; out _S: String; out _Resultat);
begin
     _S_Classe_from_sl( _S, _Resultat, Classe_Elements, Self, _Index);
end;

function TBatpro_StringList.Iterateur_Count: Integer;
begin
     Result:= Count;
end;

function TBatpro_StringList.Iterateur_interne: TIterateur;
begin
     Result:= nil;
     if Self = nil then exit;
     
     if Classe_Elements = nil
     then
         raise EBatpro_StringList_Classe_Elements_indefini.Create( Nom);

     {$IFDEF FPC_OBJFPC }
     Result:= Classe_Iterateur.Create( Nom, @Iterateur_Count, @By_Index, @Delete, False);
     {$ELSE}
     Result:= Classe_Iterateur.Create( Nom, Iterateur_Count, By_Index, Delete, False);
     {$ENDIF}
end;

function TBatpro_StringList.Iterateur_interne_Decroissant: TIterateur;
begin
     if Classe_Elements = nil
     then
         raise EBatpro_StringList_Classe_Elements_indefini.Create( Nom);

     {$IFDEF FPC_OBJFPC }
     Result:= Classe_Iterateur.Create( Nom, @Iterateur_Count, @By_Index, @Delete, True);
     {$ELSE}
     Result:= Classe_Iterateur.Create( Nom, Iterateur_Count, By_Index, Delete, True);
     {$ENDIF}
end;

function TBatpro_StringList.Iterateur: TIterateur;
begin
     Result:= Iterateur_interne;
end;

function TBatpro_StringList.Iterateur_Decroissant: TIterateur;
begin
     Result:= Iterateur_interne_Decroissant;
end;


procedure TBatpro_StringList.Efface;
begin
     if Self = nil then exit;
     Clear;
end;

procedure TBatpro_StringList.Remove( O: TObject);
var
   I: Integer;
begin
     I:= IndexOfObject( O);
     if I = -1 then exit;
     Delete( I);
end;

procedure TBatpro_StringList.Vide;
var
   I: TIterateur;
   o: TObject;
begin
     if nil = Self            then exit;
     if nil = Classe_Elements then exit;

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( o) then continue;

       I.Supprime_courant;
       FreeAndNil( o);
       end;
end;

procedure TBatpro_StringList.JSON_Premiere_Page;
begin
     JSON_Debut:= 0;
     JSON_Fin:= JSON_Debut+JSON_Page;
end;

procedure TBatpro_StringList.JSON_Page_precedente;
begin
     Dec( JSON_Debut, JSON_Page);
     if JSON_Debut < 0 then JSON_Debut:= 0;
     JSON_Fin:= JSON_Debut+JSON_Page;
end;

procedure TBatpro_StringList.JSON_Page_suivante;
var
   Fin: Integer;
begin
     Fin:= Count-1;
     Inc( JSON_Fin, JSON_Page);
     if JSON_Fin > Fin then JSON_Fin:= Fin;
     JSON_Debut:= JSON_Fin-JSON_Page;
end;

function TBatpro_StringList.JSON: String;
var
   Debut, Fin: Integer;
   I: Integer;
   O: TObject;
   sJSON: String;
   iJSON: Integer;
   function notTraite_JSONProvider: Boolean;
   var
      JSONProvider: TJSONProvider;
   begin
        JSONProvider:= TJSONProvider_from_Object( O);
        Result:= JSONProvider = nil;
        if Result then exit;

        sJSON:= JSONProvider.JSON;
   end;
   function notTraite_Batpro_StringList: Boolean;
   var
      Batpro_StringList: TBatpro_StringList;
   begin

        Result:= Affecte_( Batpro_StringList, TBatpro_StringList, O);
        if Result then exit;

        sJSON:= Batpro_StringList.JSON;
   end;
begin
     Debut:= JSON_Debut; if Debut < 0                     then Debut:= 0;
     Fin  := JSON_Fin  ; if (-1 = Fin) or (Fin > Count-1) then Fin  := Count-1;
     Result:= '[';
     iJSON:= 0;
     for I:= Debut to Fin
     do
       begin
       O:= Objects[I];
            if notTraite_JSONProvider
       then if notTraite_Batpro_StringList
       then    sJSON:= '"'+StringToJSONString(Strings[ I])+'"';

       if iJSON > 0
       then
           Result:= Result + ',';
       Result:= Result + sJSON;
       Inc( iJSON);
       end;
     Result:= Result+']';
     Result
     :=
        '{'
       +'"Nom":"'+StringToJSONString(Nom)+'",'
       +'"JSON_Debut":'+IntToStr( JSON_Debut)+','
       +'"JSON_Fin":'  +IntToStr( JSON_Fin  )+','
       +'"Count":'     +IntToStr( Count  )+','
       +'"Elements":'+Result
       +'}';
end;

function TBatpro_StringList.JSON_Persistants: String;
var
   Debut, Fin: Integer;
   I: Integer;
   O: TObject;
   sJSON: String;
   iJSON: Integer;
   function notTraite_JSONProvider: Boolean;
   var
      JSONProvider: TJSONProvider;
   begin
        JSONProvider:= TJSONProvider_from_Object( O);
        Result:= JSONProvider = nil;
        if Result then exit;

        sJSON:= JSONProvider.JSON_Persistants;
   end;
   function notTraite_Batpro_StringList: Boolean;
   var
      Batpro_StringList: TBatpro_StringList;
   begin

        Result:= Affecte_( Batpro_StringList, TBatpro_StringList, O);
        if Result then exit;

        sJSON:= Batpro_StringList.JSON_Persistants;
   end;
begin
     Debut:= JSON_Debut; if Debut < 0                     then Debut:= 0;
     Fin  := JSON_Fin  ; if (-1 = Fin) or (Fin > Count-1) then Fin  := Count-1;
     Result:= '[';
     iJSON:= 0;
     for I:= Debut to Fin
     do
       begin
       O:= Objects[I];
            if notTraite_JSONProvider
       then if notTraite_Batpro_StringList
       then    sJSON:= '"'+StringToJSONString(Strings[ I])+'"';

       if iJSON > 0
       then
           Result:= Result + ',';
       Result:= Result + sJSON;
       Inc( iJSON);
       end;
     Result:= Result+']';
     Result
     :=
        '{'
       +'"Nom":"'+StringToJSONString(Nom)+'",'
       +'"JSON_Debut":'+IntToStr( JSON_Debut)+','
       +'"JSON_Fin":'  +IntToStr( JSON_Fin  )+','
       +'"Count":'     +IntToStr( Count  )+','
       +'"Elements":'+Result
       +'}';
end;

function TBatpro_StringList.JSON_Persistants_Complet: String;
var
   Old_JSON_Debut: Integer;
   Old_JSON_Fin  : Integer;
begin
     Old_JSON_Debut:= JSON_Debut;
     Old_JSON_Fin  := JSON_Fin  ;
     try
         JSON_Debut:= -1;
         JSON_Fin  := -1;

         Result:= JSON_Persistants;
     finally
            JSON_Debut:= Old_JSON_Debut;
            JSON_Fin  := Old_JSON_Fin  ;
            end;

end;

(*
procedure TBatpro_StringList.S_Object_from_Index( _Index: Integer;
                                                  out _S: String;
                                                  out _O: TObject);
var
   si: TStringItem;
begin
     //recopié du code source de TStringList, stringl.inc
     if (_Index<0) or (_Index>=Fcount)
     then
         Error(SListIndexError,Index);
     si:= Flist^[Index];
     _S:= si.FString;
     _O:= si.FObject;
end;
*)

class function TBatpro_StringList.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur;
end;

{ TJSONProvider }

function TJSONProvider.GetJSON: String;
begin

end;

{$IFDEF FPC}
procedure TJSONProvider.SetJSON(_Value: String);
begin

end;

function TJSONProvider.JSON_Persistants: String;
begin

end;

{$ENDIF}

{ TIterateur }

constructor TIterateur.Create( _Nom: String;
                               _Count: T_Iterateur_Count;
                               _By_Index: T_Iterateur_By_Index;
                               _Delete_By_Index: T_Iterateur_Delete_By_Index;
                               _Decroissant: Boolean);
begin
     Nom:= _Nom;
     Count:= _Count;
     By_Index:= _By_Index;
     Delete_By_Index:= _Delete_By_Index;
     Decroissant:= _Decroissant;
     Frunning:= False;
     Start;
end;

destructor TIterateur.Destroy;
begin

     inherited;
end;

function TIterateur.EOF: Boolean;
begin
     Result:= True;
     if not Assigned( Count) then exit;

     if Decroissant
     then
         Result:= nSuivant < 0
     else
         Result:= nSuivant >= Count()
end;

function TIterateur.Continuer: Boolean;
begin
     Result:= not EOF;
end;

procedure TIterateur.Start;
begin
     if Frunning
     then
         raise EBatpro_StringList_Iterateur_running.Create( Nom);

     Frunning:= True;


     if Decroissant
     then
         if not Assigned( Count)
         then
             nSuivant:= -1
         else
             nSuivant:= Count()-1
     else
         nSuivant:= 0;
end;

procedure TIterateur.Stop;
begin
     Frunning:= False;
end;

procedure TIterateur.Suivant_interne(out _Resultat);
begin
     if Assigned( By_Index)
     then
         By_Index( nSuivant, Current_S, _Resultat)
     else
         begin
         Current_S:= '';
         TObject(_Resultat):= nil;
         end;
     if Decroissant
     then
         Dec( nSuivant)
     else
         Inc( nSuivant);
end;

procedure TIterateur.Suivant(out _Resultat);
begin
     Suivant_interne( _Resultat);
end;

function TIterateur.not_Suivant_interne(out _Resultat): Boolean;
begin
     Suivant_interne( _Resultat);
     Result:= TObject(_Resultat) = nil;
end;

function TIterateur.not_Suivant(out _Resultat): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur.Supprime_courant;
     procedure Cas_Croissant;
     begin
          Dec( nSuivant);
          if nSuivant = -1 then exit;
          if EOF           then exit;
          Delete_By_Index( nSuivant); //la suppression fait avancer de 1
     end;
     procedure Cas_Decroissant;
     begin
          Inc( nSuivant);
          if nSuivant = -1 then exit;
          if EOF           then exit;
          Delete_By_Index( nSuivant); //la suppression fait avancer de 1
          Dec( nSuivant);             //ici on doit compenser en reculant de 1
     end;
begin
     if Decroissant
     then
         Cas_Decroissant
     else
         Cas_Croissant;
end;

end.
