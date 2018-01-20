unit uBatpro_StringList;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    SysUtils, Classes;

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
  end;

 T_Iterateur_Count= function :Integer of Object;
 T_Iterateur_By_Index= procedure ( _Index: Integer; var _Resultat) of Object;
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

    procedure Start;
    procedure Stop;

    // 2012/03/19 tentative de sécuriser l'appel en déclarant des itérateurs
    // pour chaque classe utilisatrice
    procedure Suivant_interne( var _Resultat);
    function  not_Suivant_interne( var _Resultat): Boolean;
  private
    procedure Suivant( var _Resultat);
    function  not_Suivant( var _Resultat): Boolean;
  public
    procedure Supprime_courant;
    function  EOF: Boolean;
    function Continuer: Boolean;
  end;

 TIterateur_Class= class of TIterateur;

 TBatpro_StringList
 =
  class( TStringList)
  //Gestion du cycle de vie
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
    procedure Iterateur_Suivant( var _Resultat);
    procedure Iterateur_Supprime_courant;
    function  Iterateur_EOF: Boolean;
  //Création d'itérateur (nouvelle mouture de l'itérateur: 2011/11/09)
  private
    function Iterateur_Count: Integer;
    procedure By_Index( _Index: Integer; var _Resultat);
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
  //Effacement sécurisé (peut être appelé si non affecté)
  public
    procedure Efface;
  //Effacement de la ligne correspondant à un objet donné
  public
    procedure Remove( O: TObject);
  //Export JSON, JavaScript Object Notation
  public
    function JSON: String; virtual;
  end;

 TBatpro_StringList_class= class of TBatpro_StringList;

 TIterateur_Batpro_StringList
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TBatpro_StringList);
    function  not_Suivant( var _Resultat: TBatpro_StringList): Boolean;
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
    procedure Suivant( var _Resultat: TObject);
    function  not_Suivant( var _Resultat: TObject): Boolean;
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

procedure _Classe_from_sl     ( var Resultat; Classe: TClass;
                                sl: TStringList; Index: Integer);
procedure _Classe_from_sl_sCle( var Resultat; Classe: TClass;
                                sl: TStringList; sCle: String);

function Affecte( var O          ;
                  Classe: TClass ;
                  Valeur: TObject): Boolean;

function Affecte_( var O          ;
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
          sl.Add( _E.StackTrace);

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

procedure _Classe_from_sl( var Resultat; Classe: TClass;
                           sl: TStringList; Index: Integer);
begin
     TObject( Resultat):= Object_from_sl( sl, Index);
     CheckClass( Resultat, Classe);
end;

procedure _Classe_from_sl_sCle( var Resultat; Classe: TClass;
                                sl: TStringList; sCle: String);
begin
     TObject( Resultat):= Object_from_sl_sCle( sl, sCle);
     CheckClass( Resultat, Classe);
end;

function Affecte_( var O          ;
                   Classe: TClass ;
                   Valeur: TObject): Boolean;
begin
     TObject(O):= Valeur;
     CheckClass( O, Classe);

     Result:= TObject(O) = nil;
end;

function Affecte( var O          ;
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

function TIterateur_Batpro_StringList.not_Suivant( var _Resultat: TBatpro_StringList): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Batpro_StringList.Suivant( var _Resultat: TBatpro_StringList);
begin
     Suivant_interne( _Resultat);
end;

{ TIterateur_Object }

function TIterateur_Object.not_Suivant( var _Resultat: TObject): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Object.Suivant( var _Resultat: TObject);
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

constructor TBatpro_StringList.Create( _Nom: String= '');
begin
     inherited Create;
     Nom:= _Nom;

     Classe_Elements:= nil;

     FIterateur_running:= False;
end;

constructor TBatpro_StringList.CreateE( _Nom: String= '';
                                        _Classe_Elements: TClass = nil);
begin
     inherited Create;
     Nom:= _Nom;

     Classe_Elements:= _Classe_Elements;

     FIterateur_running:= False;
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

procedure TBatpro_StringList.Iterateur_Suivant( var _Resultat);
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

procedure TBatpro_StringList.By_Index( _Index: Integer; var _Resultat);
begin
     _Classe_from_sl( _Resultat, Classe_Elements, Self, _Index);
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

function TBatpro_StringList.JSON: String;
var
   I: Integer;
   O: TObject;
   JSONProvider: TJSONProvider;
   iJSON: Integer;
begin
     Result:= '[';
     iJSON:= 0;
     for I:= 0 to Count - 1
     do
       begin
       O:= Objects[I];
       JSONProvider:= TJSONProvider_from_Object( O);
       if JSONProvider = nil then continue;
       if iJSON > 0
       then
           Result:= Result + ',';
       Result:= Result + JSONProvider.JSON;
       Inc( iJSON);
       end;
     Result:= Result+']';
end;

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

procedure TIterateur.Suivant_interne(var _Resultat);
begin
     if Assigned( By_Index)
     then
         By_Index( nSuivant, _Resultat)
     else
         TObject(_Resultat):= nil;
     if Decroissant
     then
         Dec( nSuivant)
     else
         Inc( nSuivant);
end;

procedure TIterateur.Suivant(var _Resultat);
begin
     Suivant_interne( _Resultat);
end;

function TIterateur.not_Suivant_interne(var _Resultat): Boolean;
begin
     Suivant_interne( _Resultat);
     Result:= TObject(_Resultat) = nil;
end;

function TIterateur.not_Suivant(var _Resultat): Boolean;
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
