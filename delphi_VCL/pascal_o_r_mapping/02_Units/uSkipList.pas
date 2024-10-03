unit uSkipList;
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
    uuStrings,
    SysUtils, Classes, Math;

// codé d'aprés Skip Lists: A Probabilistic Alternative to Balanced Trees
//              par William Pugh
const
     MaxLevel = 14;
     p:double= 1/4;// 1/4 globalement plus rapide mais gros écarts selon les cas
                   // 1/2 globalement plus lent mais plus homogène quel que soit le cas
type
 TSkipList_Item
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Key: Pointer; _Value: TObject); virtual;
    destructor Destroy; override;
  //éléments suivants
  public
    Forward: array[1..MaxLevel] of TSkipList_Item;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  virtual; abstract;
    // a < self :-1  a=self :0  a > self :+1
  //nil
  public
    Is_nil: Boolean;
  //Valeur
  public
    Value: TObject;
  //Clé
  public
    function Key: Pointer; virtual; abstract;
  //Libelle
  protected
    function Libelle_interne: String; virtual; abstract;
  public
    function Libelle: String;
  //Niveau, pour gestion affichage
  public
    function Level: Integer; virtual;
  end;

 TSkipList_Item_Header
 =
  class( TSkipList_Item)
  //Gestion du cycle de vie
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  //Clé
  public
    function Key: Pointer; override;
  //Libelle
  protected
    function Libelle_interne: String; override;
  //Niveau, pour gestion affichage
  public
    function Level: Integer; override;
  end;

 TSkipList_Item_Terminator
 =
  class( TSkipList_Item)
  //Gestion du cycle de vie
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  //Clé
  public
    function Key: Pointer; override;
  //Libelle
  protected
    function Libelle_interne: String; override;
  //Niveau, pour gestion affichage
  public
    function Level: Integer; override;
  end;

 TSkipList_Item_class= class of TSkipList_Item;
 TSkipList_Update= array[1..MaxLevel] of TSkipList_Item;
 PSkipList_Update= ^TSkipList_Update;

 ESkipList_Iterateur_running
 =
  class( Exception)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  end;

 TSkipList
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TClass;
                        _Classe_Items: TSkipList_Item_class;
                        _Nom: String= '');
    destructor Destroy; override;
  //Nom
  public
    Nom: String;
  //Tête
  public
    Header: TSkipList_Item;
  //Niveau
  public
    Level: Integer;
  //Classe des éléments
  public
    Classe_Elements: TClass;
  //Classe des items
  public
    Classe_Items: TSkipList_Item_class;
  //Contrôle de type
  protected
    procedure CheckClass( var Resultat);
    procedure CheckItemClass( var Resultat);
  //Méthodes
  private
    function RandomLevel: Integer;
  protected
    function MakeNode( _Level: Integer; _Key: Pointer; _Value: Pointer): TSkipList_Item;
  public
    function  Search( _Key: Pointer; _update: PSkipList_Update= nil): TSkipList_Item;
    procedure Insert( _Key, _Value: Pointer);
    procedure Delete( _Key: Pointer);
  //Nombre d'éléments
  private
    FCount: Integer;
  public
    function Count: Integer;
  //Première valeur
  public
    function First_Value: TObject;
  //Gestion de l'affichage
  public
    function List: String;
  //Iterateur
  private
    FIterateur_running: Boolean;
  public
    skiIterateur_Suivant: TSkipList_Item;//mis en public pour tests
    procedure Iterateur_Start;
    procedure Iterateur_Stop;
    procedure Iterateur_Suivant( var _Resultat); virtual;
    function  Iterateur_EOF: Boolean;
  //Recherche par Objet
  public
    function Objet_Search( _Objet: TObject): TSkipList_Item;
    function Objet_Remove( _Objet: TObject):Boolean;
  //Pour compatibilité des tests sur les binary tree
  public
    function Root: TSkipList_Item;
    function Remove( Item_a_supprimer: TSkipList_Item):Boolean;
    function btiIterateur_Suivant: TSkipList_Item;
  //Est Vide
  public
    function Est_Vide: Boolean;
  //Vidage
  public
    procedure Vide;
  end;

var
   SkipList_Item_Terminator: TSkipList_Item_Terminator= nil;

implementation

{ TSkipList_Item }

constructor TSkipList_Item.Create( _Key: Pointer; _Value: TObject);
var
   I: Integer;
begin
     for I:= Low( Forward) to High( Forward)
     do
       Forward[I]:= SkipList_Item_Terminator;

     Value:= _Value;
     Is_nil:= False;
end;

destructor TSkipList_Item.Destroy;
begin

     inherited;
end;

function TSkipList_Item.Level: Integer;
var
   I: Integer;
begin
     for I:= Low( Forward) to High( Forward)
     do
       if Forward[I] = SkipList_Item_Terminator
       then
           break;
     Result:= I;
end;

function TSkipList_Item.Libelle: String;
begin
     Result
     :=
        ChaineDe( MaxLevel-Level, '|')
       +ChaineDe( Level         , {'•'}'.') + Libelle_interne;
end;

{ TSkipList_Item_Header }

constructor TSkipList_Item_Header.Create;
begin
     inherited Create( nil, nil);
end;

destructor TSkipList_Item_Header.Destroy;
begin
     inherited;
end;

function TSkipList_Item_Header.Compare(_Key: Pointer): Shortint;
begin
     Result:= +1;
end;

function TSkipList_Item_Header.Key: Pointer;
begin
     Result:= nil;
end;

function TSkipList_Item_Header.Libelle_interne: String;
begin
     Result:= 'Entête';
end;

function TSkipList_Item_Header.Level: Integer;
begin
     Result:= MaxLevel;
end;

{ TSkipList_Item_Terminator }

constructor TSkipList_Item_Terminator.Create;
begin
     SkipList_Item_Terminator:= Self;
     inherited Create( nil, nil);
     Is_nil:= True;
end;

destructor TSkipList_Item_Terminator.Destroy;
begin

     inherited;
end;

function TSkipList_Item_Terminator.Compare(_Key: Pointer): Shortint;
begin
     Result:= -1;
end;

function TSkipList_Item_Terminator.Key: Pointer;
begin
     Result:= nil;
end;

function TSkipList_Item_Terminator.Libelle_interne: String;
begin
     Result:= 'Terminateur';
end;

function TSkipList_Item_Terminator.Level: Integer;
begin
     Result:= MaxLevel;
end;

{ ESkipList_Iterateur_running }

constructor ESkipList_Iterateur_running.Create( _Nom: String);
begin
     inherited Create(  'Erreur à signaler au développeur:'#13#10
                       +'  L''itérateur de ('+_Nom+': TSkipList) est déjà en cours d''utilisation');
end;

destructor ESkipList_Iterateur_running.Destroy;
begin

     inherited;
end;

{ TSkipList }

constructor TSkipList.Create( _Classe_Elements: TClass;
                              _Classe_Items: TSkipList_Item_class;
                              _Nom: String= '');
begin
     Level:= 1;
     Classe_Items:= _Classe_Items;
     FCount:= 0;
     Header:= TSkipList_Item_Header.Create;
     FIterateur_running:= False;
     Nom:= _Nom;
end;

destructor TSkipList.Destroy;
begin
     Free_nil( Header);
     inherited;
end;

function TSkipList.Search( _Key: Pointer;
                           _update: PSkipList_Update= nil): TSkipList_Item;
var
   I: Integer;
   Resultat, fwd: TSkipList_Item;
   function Take_fwd: Boolean;
   begin
        try
           fwd:= Resultat.Forward[ I];
           Result:= Assigned( fwd);
        except
              on Exception   //pas trop propre
              do
                begin
                fwd:= nil;
                Result:= False;
                end;
              end;
   end;
begin
     Result:= Header;

     Resultat:= Result;

     for I:= Level downto 1
     do
       begin
       while     Take_fwd
             and (0 < fwd.Compare( _Key))
       do
         Resultat:= fwd;
       if Assigned( _update)
       then
           {$IFDEF FPC_OBJFPC }
           _update^[I]:= Resultat;
           {$ELSE}
           _update[I]:= Resultat;
           {$ENDIF}
       end;

     Resultat:= Resultat.Forward[1];
     if 0 <> Resultat.Compare( _Key)
     then
         Resultat:= nil;

     Result:= Resultat;
end;

function TSkipList.Objet_Search( _Objet: TObject): TSkipList_Item;
var
   ski: TSkipList_Item;
   next_ski: TSkipList_Item;
   function not_OK: Boolean;
   begin
        Result:= Assigned( ski);
        if not Result then exit;

        Result:= _Objet <> ski.Value;
   end;
begin
     ski:= Header;
     while not_OK
     do
       begin
       if ski = nil then break;

       next_ski:= ski.Forward[ 1];
       if ski = next_ski then break; //rajouté rapidement pour bug GED, à revoir en profondeur
                                     //il doit il y avoir un bug
       ski:= next_ski;
       end;

     Result:= ski;
end;

function TSkipList.Objet_Remove( _Objet: TObject): Boolean;
var
   ski: TSkipList_Item;
begin
     Result:= True;

     ski:= Objet_Search( _Objet);
     if ski = nil then exit;

     Delete( ski.Key);
end;

procedure TSkipList.Insert( _Key, _Value: Pointer);
var
   update: array[1..MaxLevel] of TSkipList_Item;
   x: TSkipList_Item;
   I: Integer;
   lvl: Integer;
begin
     x:= Search( _Key, @update);
     if Assigned( x)
     then
         x.Value:= TObject(_Value)
     else
         begin
         lvl:= RandomLevel;
         if lvl > Level
         then
             begin
             for I:= Level + 1 to lvl
             do
               update[I]:= Header;
             Level:= lvl;
             end;
         x:= MakeNode( lvl, _Key, _Value);
         for I:= 1 to Level
         do
           begin
           x.Forward[I]:= update[i].Forward[i];
           update[i].Forward[i]:= x;
           end;
         end;
end;

procedure TSkipList.Delete( _Key: Pointer);
var
   update: TSkipList_Update;
   x: TSkipList_Item;
   I: Integer;
begin
     x:= Search( _Key, @update);
     if Assigned( x)
     then
         begin
         for I:= 1 to level
         do
           if update[I].Forward[I] = x
           then
               update[I].Forward[I]:= x.Forward[I]
           else
               break;
         if not x.Is_nil
         then
             Free_nil( x);
         Dec( FCount);
         while     (Level > 1)
               and (Header.Forward[Level] = nil)
         do
           Dec( Level);

         end;
end;

function TSkipList.RandomLevel: Integer;
begin
     Result:= 1;
     while     (Random < p)
           and (Result < MaxLevel)
     do
       Inc( Result);
end;

function TSkipList.MakeNode( _Level: Integer; _Key, _Value: Pointer): TSkipList_Item;
begin
     Result:= nil;
     if Classe_Items = nil then exit;

     Result:= Classe_Items.Create( _Key, TObject(_Value));
     Inc( FCount);
end;

procedure TSkipList.CheckClass(var Resultat);
begin
     if Classe_Elements = nil then exit;

     if Assigned( TObject( Resultat))
     then
         if not ( TObject( Resultat) is Classe_Elements)
         then
             TObject( Resultat):= nil;
end;

procedure TSkipList.CheckItemClass(var Resultat);
begin
     if Classe_Items = nil then exit;

     if Assigned( TObject( Resultat))
     then
         if not ( TObject( Resultat) is Classe_Items)
         then
             TObject( Resultat):= nil;
end;

function TSkipList.Count: Integer;
begin
     Result:= FCount;
end;

function TSkipList.First_Value: TObject;
begin
     Result:= nil;
     if Header = nil then exit;

     Result:= Header.Value;
end;

function TSkipList.List: String;
var
   ski: TSkipList_Item;
   procedure List_ski;
   begin
       if Result <> ''
       then
           Result:= Result + #13#10;
       Result:= Result + ski.Libelle;
   end;
begin
     Result:= '';

     ski:= Header;
     while ski <> SkipList_Item_Terminator
     do
       begin
       if ski = nil then break;

       List_ski;

       ski:= ski.Forward[ 1];
       end;
     if Assigned( ski)
     then
         List_ski;
end;

procedure TSkipList.Iterateur_Start;
begin
     if FIterateur_running
     then
         raise ESkipList_Iterateur_running.Create( Nom);

     FIterateur_running:= True;
     skiIterateur_Suivant:= Header;
end;

procedure TSkipList.Iterateur_Stop;
begin
     FIterateur_running:= False;
end;

function TSkipList.Iterateur_EOF: Boolean;
begin
     Result:= skiIterateur_Suivant.is_nil;
end;

procedure TSkipList.Iterateur_Suivant(var _Resultat);
begin
     TObject(_Resultat):= nil;
     if skiIterateur_Suivant = nil then exit;

     TObject(_Resultat):= skiIterateur_Suivant.Value;
     CheckClass( _Resultat);

     skiIterateur_Suivant:= skiIterateur_Suivant.Forward[1];
end;

function TSkipList.Root: TSkipList_Item;
begin
     Result:= Header;
end;

function TSkipList.Remove( Item_a_supprimer: TSkipList_Item): Boolean;
begin
     Result:= Assigned( Item_a_supprimer);
     if not Result then exit;

     Delete( Item_a_supprimer.Key);
end;

function TSkipList.btiIterateur_Suivant: TSkipList_Item;
begin
     Result:= skiIterateur_Suivant;
end;

function TSkipList.Est_Vide: Boolean;
begin
     Result:= Header = nil;
end;

procedure TSkipList.Vide;
var
   ski, trash: TSkipList_Item;
   I: Integer;
begin
     if Header = nil then exit;
     
     ski:= Header.Forward[1];
     while ski <> SkipList_Item_Terminator
     do
       begin
       trash:= ski;
       ski:= ski.Forward[1];
       Free_nil( trash);
       end;
     for I:= Low( Header.Forward) to High( Header.Forward)
     do
       Header.Forward[I]:= SkipList_Item_Terminator;
     FCount:=0;
     Level:= 1;
end;

initialization
              Randomize;
              SkipList_Item_Terminator:= TSkipList_Item_Terminator.Create;
finalization
              Free_nil( SkipList_Item_Terminator);
end.
