unit uBinary_Tree;
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

//
//  Taken from Nicklaus Wirth :
//    Algorithmen und Datenstrukturen ( in Pascal )
//    Balanced Binary Trees p 250 ++
//
//
// Fixed By Giacomo Policicchio
// pgiacomo@tiscalinet.it
// 19/05/2000
//

interface

uses
    uClean,
    u_sys_,
    uBatpro_StringList,
  SysUtils,Classes;

type
 TypBalance= ( tb_Insertion, tb_Suppression);
 TBalance= -1..+1;
 TCote= ( c_Racine, c_Inferieur, c_Superieur);
 TBinary_TreeItem=class;
 TBrancheSetProc= procedure (const Value: TBinary_TreeItem) of object;
 TBinary_TreeItem
 =
  class(TObject)
  //Gestion du cycle de vie
  public
    constructor Create;
  //Général
  private
    Bal  : TBalance;
  //Parent
  public
    Parent: TBinary_TreeItem;
    Cote: TCote;
  //Inferieur
  private
    FInferieur: TBinary_TreeItem;
    procedure SetInferieur(const Value: TBinary_TreeItem);
  public
    property Inferieur : TBinary_TreeItem read FInferieur write SetInferieur;
  //Superieur
  private
    FSuperieur: TBinary_TreeItem;
    procedure SetSuperieur(const Value: TBinary_TreeItem);
  public
    property Superieur : TBinary_TreeItem read FSuperieur write SetSuperieur;
  //Gestion de l'affectation du parent
  private
    procedure SetBrancheParentCote( Branche: TBinary_TreeItem; _Cote: TCote; ValeurParent: TBinary_TreeItem);
  //Gestion de l'affectation d'une branche
  private
    procedure SetBranche( var Branche: TBinary_TreeItem; _Cote: TCote; Valeur: TBinary_TreeItem);
  //Général
  public
    function  Compare( a:TBinary_TreeItem):Shortint;  virtual; abstract; // data
    // a < self :-1  a=self :0  a > self :+1
    procedure List( var _sListe, _Indentation: String);
  //Déplacement
  public
    procedure MoveTo( ToA:TBinary_TreeItem);  virtual;
  //Attributs
  public
    Objet: TObject;
  //Nombre d'éléments
  public
    function Compter: Integer;
  //Libelle
  protected
    function Libelle_interne: String; virtual; abstract;
  public
    function Libelle: String;
 end;

 TBinary_TreeItem_class= class of TBinary_TreeItem;

 TBinary_Tree
 =
  class(TPersistent)
  //Gestion du cycle de vie
  public
    constructor Create( _Classe_Elements: TClass;
                        _Classe_Items   : TBinary_TreeItem_class);
    destructor Destroy; override;
  //Gestion de la racine
  private
    FRoot: TBinary_TreeItem;
    procedure SetRoot(const Value: TBinary_TreeItem);
  public
    property Root: TBinary_TreeItem read FRoot write SetRoot;
  //Général
  private
    procedure Del( var p: TBinary_TreeItem; Set_p: TBrancheSetProc;
                   var r: TBinary_TreeItem; Set_r: TBrancheSetProc);
    function  Delete         ( Item_a_supprimer: TBinary_TreeItem;var p:TBinary_TreeItem;Set_p: TBrancheSetProc): Boolean;
    procedure SearchAndInsert( Item: TBinary_TreeItem;var p:TBinary_TreeItem;Set_p: TBrancheSetProc;var Found:Boolean);

    function  SearchItem     ( Racine, Item: TBinary_TreeItem;var Trouve:TBinary_TreeItem):Boolean;
  public
    function Add   ( Item: TBinary_TreeItem):Boolean;
    function Remove( Item_a_supprimer: TBinary_TreeItem):Boolean;
    function Search( Item: TBinary_TreeItem): TBinary_TreeItem;
  //Gestion de l'équilibre
  private
    Desequilibre: Boolean;
    TB: TypBalance;
    procedure BalanceInferieur ( var p: TBinary_TreeItem; Set_p: TBrancheSetProc);
    procedure BalanceSuperieur( var p: TBinary_TreeItem; Set_p: TBrancheSetProc);
  //Gestion de l'affichage
  protected
    sListe, Indentation: String;
    procedure ListItems( p: TBinary_TreeItem); virtual;
  public
    function List: String;      // uses item.list through listitems recursively
  //Classe des éléments
  public
    Classe_Elements: TClass;
  //Classe des items
  public
    Classe_Items: TBinary_TreeItem_class;
  //Contrôle de type
  protected
    procedure CheckClass( var Resultat);
    procedure CheckItemClass( var Resultat);
  //Est Vide
  public
    function Est_Vide: Boolean;
  //Vidage
  public
    procedure Vide;
  //Recherche par Objet
  private
    function  Objet_Search_Interne( Racine: TBinary_TreeItem; Objet: TObject;var Trouve:TBinary_TreeItem):Boolean;
  public
    function Objet_Search( Objet: TObject): TBinary_TreeItem;
    function Objet_Remove( Objet: TObject):Boolean;
  //Iterateur
  private
    procedure Iterateur_go_Inferieur_End;
    procedure Iterateur_go_Parent;
  public
    btiIterateur_Suivant: TBinary_TreeItem;//mis en public pour tests
    procedure Iterateur_Start;
    procedure Iterateur_Suivant( var _Resultat); virtual;
    function  Iterateur_EOF: Boolean;
  //Nombre d'éléments
  private
    FCount: Integer;
    Recompter: Boolean;
  public
    function Count: Integer;
  //Première valeur
  public
    function First_Value: TObject;
  end;

implementation

{ TBinary_TreeItem }

constructor TBinary_TreeItem.Create;
begin
     inherited Create;
     Parent:= nil;
     Cote:= c_Inferieur;//juste pour avoir une valeur
end;

procedure TBinary_TreeItem.SetBrancheParentCote( Branche: TBinary_TreeItem;
                                                 _Cote: TCote;
                                                 ValeurParent: TBinary_TreeItem);
begin
     if Branche = nil then exit;
     Branche.Parent:= ValeurParent;
     Branche.Cote  := _Cote;
end;

procedure TBinary_TreeItem.SetBranche( var Branche: TBinary_TreeItem;
                                       _Cote: TCote;
                                       Valeur: TBinary_TreeItem);
begin
     Branche:= Valeur;
     SetBrancheParentCote( Branche, _Cote, Self);
end;

procedure TBinary_TreeItem.SetInferieur(const Value: TBinary_TreeItem);
begin
     SetBranche( FInferieur , c_Inferieur, Value);
end;

procedure TBinary_TreeItem.SetSuperieur(const Value: TBinary_TreeItem);
begin
     SetBranche( FSuperieur, c_Superieur, Value);
end;

function TBinary_TreeItem.Compter: Integer;
begin
     Result:= 1;
     if Assigned( FSuperieur) then Inc( Result, FSuperieur.Compter);
     if Assigned( FInferieur ) then Inc( Result, FInferieur .Compter);
end;

function TBinary_TreeItem.Libelle: String;
var
   sCote: String;
begin
     case Cote
     of
       c_Inferieur: sCote:= '-';
       c_Superieur: sCote:= '+';
       c_Racine: sCote:= 'R';
       else      sCote:= 'coté inconnu';
       end;
     sCote:= '('+sCote+')';
     Result:= Libelle_interne + sCote +'(bti $'+IntToHex( Integer( Self), 8)+')';
end;

procedure TBinary_TreeItem.List(var _sListe, _Indentation: String);
begin
     if _sListe <> sys_Vide
     then
         _sListe:= _sListe + #13#10;
     _sListe:= _sListe + _Indentation + Libelle;
end;

procedure TBinary_TreeItem.MoveTo(ToA: TBinary_TreeItem);
begin
     if ToA = nil then exit;

     ToA.Objet:= Objet;
end;

{ TBinary_Tree }

constructor TBinary_Tree.Create( _Classe_Elements: TClass;
                                 _Classe_Items   : TBinary_TreeItem_class);
begin
     inherited Create;
     Root:= nil;
     Classe_Elements:= _Classe_Elements;
     Classe_Items   := _Classe_Items;
     FCount:= 0;
     Recompter:= True;
end;

destructor TBinary_Tree.Destroy;
begin
     while Root <> nil do Remove( Root);
     inherited Destroy;
end;

procedure TBinary_Tree.SetRoot(const Value: TBinary_TreeItem);
begin
     FRoot:= Value;
     if Assigned( FRoot)
     then
         begin
         FRoot.Parent:= nil;
         FRoot.Cote  := c_Racine;
         end;
     Recompter:= True;
end;

procedure TBinary_Tree.balanceSuperieur( var p:TBinary_TreeItem;
                                     Set_p: TBrancheSetProc);
var
   p1, p2: TBinary_TreeItem;
begin
     case p.bal
     of
       -1:
         begin
         p.bal:=0;

         if tb_Insertion = TB then Desequilibre:=false;
         end;
       0:
         begin
         p.bal:=+1;
         if tb_Suppression = TB then Desequilibre:=false;
         end;
       +1:
         begin    // new balancing
         p1:=p.Superieur;
         if     (p1.bal=+1)
            or ((p1.bal=0 ) and (tb_Suppression = TB))
         then
             begin  // single rr rotation
             p.Superieur:=p1.Inferieur; p1.Inferieur:=p;
             if tb_Insertion = TB
             then
                 p.bal:=0
             else
                 begin
                 if p1.bal=0
                 then
                     begin
                     p.bal:=+1; p1.bal:=-1; Desequilibre:=false;
                     end
                 else
                     begin
                     p.bal:=0;  p1.bal:=0;
                     end;
                 end;
             Set_p( p1);
             end
         else
             begin  // double rl rotation
             p2:=p1.Inferieur;
             p1.Inferieur:=p2.Superieur;
             p2.Superieur:=p1;
             p.Superieur:=p2.Inferieur;
             p2.Inferieur:=p;
             if p2.bal=+1 then p .bal:=-1 else p .bal:=0;
             if p2.bal=-1 then p1.bal:=+1 else p1.bal:=0;
             //p:=p2;
             Set_p( p2);
             if tb_Suppression = TB then p2.bal:=0;
            end;
         if tb_Insertion = TB
         then
             begin
             p.bal:=0;
             Desequilibre:=false;
             end;
         end;
       end;
end;

procedure TBinary_Tree.BalanceInferieur( var p: TBinary_TreeItem;
                                    Set_p: TBrancheSetProc);
var
   p1, p2:TBinary_TreeItem;
Begin
    case p.bal
    of
      +1:
        begin
        p.bal:=0;
        if tb_Insertion = TB then Desequilibre:=false;
        end;
      0:
        begin
        p.bal:=-1;
        if tb_Suppression = TB then  Desequilibre:=false;
        end;
      -1:
        begin   // new balancing
        p1:=p.Inferieur;
        if     (p1.bal=-1)
           or ((p1.bal=0) and (tb_Suppression = TB))
        then
            begin   // single ll rotation
            p.Inferieur:=p1.Superieur;p1.Superieur:=p;
            if tb_Insertion = TB
            then
                p.bal:=0
            else
                begin
                if p1.bal=0
                then
                    begin
                    p.bal:=-1;
                    p1.bal:=+1;
                    Desequilibre:=false;
                    end
                else
                    begin
                    p.bal:=0;
                    p1.bal:=0;
                    end;
                end;
            Set_p( p1);
            end
        else
            begin //double lr rotation
            p2:=p1.Superieur;
            P1.Superieur:=p2.Inferieur;
            p2.Inferieur:=p1;
            p.Inferieur:=p2.Superieur;
            p2.Superieur:=p;
            if p2.bal=-1
            then
                p.bal:=+1
            else
                p.bal:=0;
            if p2.bal=+1
            then
                p1.bal:=-1
            else
                p1.bal:=0;
            Set_p( p2);
            if tb_Suppression = TB then p2.bal:=0;
            end;
        if tb_Insertion = TB
        then
            begin
            p.bal:=0;
            Desequilibre:=false;
            end;
        end; { -1 }
      end; { case }
end;

procedure TBinary_Tree.Del( var p: TBinary_TreeItem; Set_p: TBrancheSetProc;
                            var r: TBinary_TreeItem; Set_r: TBrancheSetProc);
    procedure Algo_original;
    var
       Poubelle: TBinary_TreeItem;
    begin
         r.MoveTo( p);

         Poubelle:= r;
         Set_r( r.Inferieur);
         Free_nil( Poubelle);

         Desequilibre:= True;
    end;
    procedure Algo_sans_MoveTo;
    var
       Poubelle: TBinary_TreeItem;
    begin
         Set_r( r.Inferieur);
         if r = nil
         then
             Set_r( p.Superieur)
         else
             begin
             r.Inferieur := nil;
             r.Superieur:= p.Superieur;
             end;

         Poubelle:= p;
         Set_p( r);
         Free_nil( Poubelle);

         Desequilibre:= True;
    end;
begin
     if Assigned( r.FSuperieur)
     then
         begin
         Del( p, Set_p, r.FSuperieur, r.SetSuperieur);
         if Desequilibre then BalanceInferieur( r, Set_r);
         end
     else
         Algo_original;
         //Algo_sans_MoveTo;
end;

function TBinary_Tree.Delete( Item_a_supprimer: TBinary_TreeItem;
                              var p:TBinary_TreeItem;
                              Set_p: TBrancheSetProc): Boolean;
   procedure Affecte_p( _bti: TBinary_TreeItem);
   var
      Poubelle: TBinary_TreeItem;
   begin
        Poubelle:= p;
        Set_p( _bti);
        Free_nil( Poubelle);
        Desequilibre:=true;
   end;
begin
     TB:= tb_Suppression;

     Result:= Assigned( p);
     if not Result then Desequilibre:= False;
     if not Result then exit;

          if 0 < Item_a_supprimer.compare(p)
     then
         begin
         Result:= Delete( Item_a_supprimer, p.FInferieur, p.SetInferieur);
         if Desequilibre then BalanceSuperieur( p, Set_p);
         end
     else if 0 > Item_a_supprimer.compare(p)
     then
         begin
         Result:= Delete( Item_a_supprimer, p.FSuperieur, p.SetSuperieur);
         if Desequilibre then BalanceInferieur(p,Set_p);
         end
     else
         begin
              if p.Superieur = nil then Affecte_p( p.Inferieur )
         else if p.Inferieur  = nil then Affecte_p( p.Superieur)
         else
             begin
             Del( p, Set_p, p.FInferieur, p.SetInferieur);
             if Desequilibre then BalanceSuperieur( p, Set_p);
             end;
         end;
end;

procedure TBinary_Tree.SearchAndInsert( Item:TBinary_TreeItem;
                                        var p:TBinary_TreeItem;
                                        Set_p: TBrancheSetProc;
                                        var Found: Boolean);
var
   item_compare_p: Shortint;
begin
     TB:= tb_Insertion;
     Found:= False;
     if p=nil
     then
         begin        // word not in tree, insert it
         //p:=item;
         Set_p( item);
         Desequilibre:=true;
         with p
         do
           begin
           if root=nil
           then
               root:=p;
           Inferieur :=nil;
           Superieur:=nil;
           bal  :=0;
           end;
         end
     else
         begin
         item_compare_p:= item.compare(p);
              if item_compare_p > 0 // new < current
         then
             begin
             searchAndInsert(item,p.FInferieur,p.SetInferieur,found);
             if Desequilibre and not found
             then
                 BalanceInferieur(p,Set_p);
             end
         else if item_compare_p < 0 // new > current
         then
             begin
             searchAndInsert(item,p.FSuperieur,p.SetSuperieur,found);
             if Desequilibre and not found
             then
                 BalanceSuperieur(p,Set_p);
             end
          else                      // new = current
              begin
              Desequilibre:=false;
              found:=true;
              end;
         end;
end;

function TBinary_Tree.Add( Item:TBinary_TreeItem):boolean;
begin
     SearchAndInsert( item,FRoot,SetRoot,Result);
     Recompter:= True;
end;

// returns true and a pointer to the equal item if found, false otherwise
function TBinary_Tree.SearchItem( Racine, Item: TBinary_TreeItem;
                                  var Trouve:TBinary_TreeItem):Boolean;
begin
     Result:= Assigned( Racine);
     if not Result then exit;

     case Item.compare( Racine)
     of
       -1:  Result:= SearchItem( Racine.Superieur, Item, Trouve);
        0:
          begin
          Result:= True;
          Trouve:= Racine;
          end;
       +1:  Result:= SearchItem( Racine.Inferieur , Item, Trouve);
       else Result:= False;
       end;
end;

function TBinary_Tree.Search(Item:TBinary_TreeItem):TBinary_TreeItem;
begin
     Result:= nil;
     SearchItem( Root, Item, Result);
end;

function TBinary_Tree.Remove( Item_a_supprimer: TBinary_TreeItem):Boolean;
begin
     Result:= Delete( Item_a_supprimer, FRoot, SetRoot);
     Recompter:= True;
end;

function  TBinary_Tree.Objet_Search_Interne( Racine: TBinary_TreeItem;
                                             Objet: TObject;
                                             var Trouve:TBinary_TreeItem):Boolean;
begin
     Result:= Assigned( Racine);
     if not Result then exit;

     Result:= Racine.Objet = Objet;
     if Result
     then
         begin
         Trouve:= Racine;
         exit;
         end;

     Result:= Objet_Search_Interne( Racine.Superieur, Objet, Trouve);
     if Result then exit;

     Result:= Objet_Search_Interne( Racine .Inferieur, Objet, Trouve);
end;

function TBinary_Tree.Objet_Search( Objet: TObject   ): TBinary_TreeItem;
begin
     Result:= nil;
     Objet_Search_Interne( Root, Objet, Result);
end;

function TBinary_Tree.Objet_Remove( Objet: TObject):Boolean;
var
   Item_a_supprimer: TBinary_TreeItem;
begin
     Item_a_supprimer:= Objet_Search( Objet);

     Result:= Assigned( Item_a_supprimer);
     if not Result then exit;

     Result:= Delete( Item_a_supprimer, FRoot, SetRoot);
     Recompter:= True;
end;


procedure TBinary_Tree.ListItems( p:TBinary_TreeItem);
var
   Old_Indentation: String;
begin
     if p = nil then exit;
     Old_Indentation:= Indentation;
     try
        Indentation:= #9#9+Indentation;
        ListItems( p.Inferieur);
        p.list( sListe, Indentation);
        ListItems( p.Superieur);
     finally
            Indentation:= Old_Indentation;
            end;
end;

function TBinary_Tree.List: String;      // uses item.list recursively
begin
     sListe:= sys_Vide;
     Indentation:= sys_Vide;
     ListItems( root);
     Result:= sListe;
end;

procedure TBinary_Tree.CheckClass( var Resultat);
begin
     uBatpro_StringList.CheckClass( Resultat, Classe_Elements);
end;

procedure TBinary_Tree.CheckItemClass(var Resultat);
begin
     uBatpro_StringList.CheckClass( Resultat, Classe_Items);
end;

function TBinary_Tree.Est_Vide: Boolean;
begin
     Result:= Root = nil;
end;

procedure TBinary_Tree.Vide;
begin
     if Self = nil then exit;
     
     while Assigned( Root)
     do
       Remove( Root);
     Recompter:= True;
end;

procedure TBinary_Tree.Iterateur_go_Inferieur_End;
begin
     if btiIterateur_Suivant = nil then exit;

     while Assigned( btiIterateur_Suivant.FInferieur)
     do
       btiIterateur_Suivant:= btiIterateur_Suivant.FInferieur;
end;

procedure TBinary_Tree.Iterateur_go_Parent;
begin
     if btiIterateur_Suivant = nil then exit;
     btiIterateur_Suivant:= btiIterateur_Suivant.Parent;
end;

procedure TBinary_Tree.Iterateur_Start;
begin
     btiIterateur_Suivant:= Root;
     Iterateur_go_Inferieur_End;
end;

function TBinary_Tree.Iterateur_EOF: Boolean;
begin
     Result:= btiIterateur_Suivant = nil;
end;

procedure TBinary_Tree.Iterateur_Suivant(var _Resultat);
begin
     TObject(_Resultat):= nil;
     if btiIterateur_Suivant = nil then exit;

     TObject(_Resultat):= btiIterateur_Suivant.Objet;
     CheckClass( _Resultat);

     if btiIterateur_Suivant.Superieur = nil
     then
         begin
         case btiIterateur_Suivant.Cote
         of
           c_Racine: btiIterateur_Suivant:= nil;
           c_Superieur:
             begin
             Iterateur_go_Parent;
             case btiIterateur_Suivant.Cote
             of
               c_Racine:
                 btiIterateur_Suivant:= nil;
               c_Superieur :
                 while btiIterateur_Suivant.Cote = c_Superieur
                 do
                   Iterateur_go_Parent;
               end;
             Iterateur_go_Parent;
             end;

           c_Inferieur:
             Iterateur_go_Parent;
           end;
         end
     else
         begin
         btiIterateur_Suivant:= btiIterateur_Suivant.FSuperieur;
         Iterateur_go_Inferieur_End;
         end;
end;

function TBinary_Tree.Count: Integer;
begin
     Result:= 0;
     if Root = nil then  exit;

     if Recompter
     then
         FCount:= Root.Compter;

     Result:= FCount;
end;

function TBinary_Tree.First_Value: TObject;
begin
     Result:= nil;
     if Root = nil then exit;

     Result:= Root.Objet;
end;

end.
//Test OK
//AfficheEnleve_complique: ETestFailure
//at  $00404FCE
//Enlevé: 10//								1
//						2
//								3
//				4
//								5
//						6
//								7
//		8
//								9
//										11
//						12
//										13
//								14
//										15
//				16
//								17
//						18
//								19
//										20

