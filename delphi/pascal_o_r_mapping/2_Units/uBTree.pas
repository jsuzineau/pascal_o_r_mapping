UNIT uBTree;
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

{ DOS & WINDOWS }

INTERFACE

USES
    SysUtils, Classes, Types;

TYPE
 TypeNoeud= (tn_Inferieur, tn_Souche, tn_Superieur);
 { Définit le noeud par rapport à son éventuelle racine.  }
 { btr_ pour BinaryTree_}

 TypeComparaison= (tc_Inferieur, tc_Egal, tc_Superieur);
 WordArray= array of Word;
 TNoeud
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Valeur: Word);
  //Valeur
  public
    Valeur: Word;{ En pratique: Valeur indice de tableau }
  //Racine
  public
    Racine: TNoeud;
    Typ: TypeNoeud;
  //Noeud
  private
    FInferieur,
    FSuperieur: TNoeud;
    procedure SetInferieur( _Inferieur: TNoeud);
    procedure SetSuperieur( _Superieur: TNoeud);
  public
    property Inferieur: TNoeud read FInferieur write SetInferieur;
    property Superieur: TNoeud read FSuperieur write SetSuperieur;
  //Méthodes
  public
    procedure EnracineDans( _Racine: TNoeud; _Type: TypeNoeud);

    procedure Ordonne;
    procedure EchangeAvecInferieur;
    procedure EchangeAvecSuperieur;
  end;

 TArbre
 =
  class
    //Afficheur: PTextObject;
    Busy: Boolean;
    NbElements: LongInt;
    Arbre: TNoeud;
    Courant: TNoeud;
    NoeudTrouve: TNoeud;
    XMax: Byte; {usage interne pour l'affichage}
    Fish   : TNoeud;   { idem }

    { routines à surcharger }
    function CompareAaB( A, B: Word): TypeComparaison; Virtual;
    procedure AfficheValeur( X, Y: Byte; _Valeur: Word); Virtual;

    constructor Create{( _Afficheur: TextObject)};
    procedure DestroyTree;

    procedure Insere( _Valeur: Word);
    procedure LireDans( _Tableau: WordArray);
    procedure LireDichotomiquementDans( _Tableau: WordArray);

    procedure Equilibrer;

    function Trouvee( _Valeur: Word): Boolean;
    { si la valeur est trouvee, r‚sultat True et NoeudTrouve    }
    { pointe sur le noeud cherch‚ sinon le noeud le plus proche.}

    { à utiliser }
    procedure Afficher;

    function OrdreOK: Boolean;

    procedure RangerDans( var _Tableau: WordArray);

    { Usage interne}
    function Affichage( A: TNoeud; XInferieur, Y: Word): Word;
  end;

IMPLEMENTATION

type
    TMoment= ( m_NoeudInferieur, m_ValeurNoeud, m_NoeudSuperieur, m_RacineNoeud);

CONSTRUCTOR TNoeud.Create( _Valeur: Word);
begin
     Valeur:= _Valeur;
     Racine:= nil;
     Inferieur:= nil;
     Superieur:= nil;
     Typ:= tn_Souche;
end;

procedure TNoeud.EnracineDans( _Racine: TNoeud; _Type: TypeNoeud);
begin
     Racine:= _Racine;
     Typ:= _Type;
end;

procedure TNoeud.SetInferieur( _Inferieur: TNoeud);
begin
     Inferieur:= _Inferieur;
     if Inferieur <> nil
     then
         Inferieur.EnracineDans( Self, tn_Inferieur);
end;

procedure TNoeud.SetSuperieur( _Superieur: TNoeud);
begin
     Superieur:= _Superieur;
     if Superieur <> nil
     then
         Superieur.EnracineDans( Self, tn_Superieur);
end;

procedure TNoeud.Ordonne;
begin
{     if Inferieur <> nil
     then
         begin
         Inferieur.Ordonne;
         case CompareAaB( Inferieur.Valeur, Valeur) of
              btr_Inferieur: ;
              btr_Egal     : ;
              btr_Superieur: EchangeAvecInferieur;
              end;
         Inferieur.Ordonne;
         end;
     if Superieur <> nil
     then
         begin
         Superieur.Ordonne;
         case CompareAaB( Valeur, Superieur.Valeur) of
              btr_Inferieur: EchangeAvecSuperieur;
              btr_Egal     : ;
              btr_Superieur: ;
              end;
         Superieur.Ordonne;
         end;}
end;

procedure TNoeud.EchangeAvecInferieur;
var
   Fish: TNoeud;
begin
     Fish:= Inferieur;            { On fait glisser le noeud vers la Inferieur }
     Inferieur.Valeur:= Valeur;  { On ‚change donc avec le Inferieur:            }
     Inferieur.Superieur:= Superieur;        {    - la valeur.                         }
     Valeur:= Fish.Valeur; {    - le Superieur.                            }
     Superieur:= Fish.Superieur;
end;

procedure TNoeud.EchangeAvecSuperieur;
var
   Fish: TNoeud;
begin
     Fish:= Superieur;            { On fait glisser le noeud vers la Superieur }
     Superieur.Valeur:= Valeur;  { On ‚change donc avec le Superieur:            }
     Superieur.Inferieur:= Inferieur;        {    - la valeur.                         }
     Valeur:= Fish.Valeur; {    - le Inferieur.                            }
     Inferieur:= Fish.Inferieur;
end;

function TArbre.CompareAaB( A, B: Word): TypeComparaison;
begin
     CompareAaB:= tc_Egal;{ Le type TNoeud est un type Abstrait     }
                          { Seuls ses descendants sont utilisables. }
end;

PROCEDURE TArbre.AfficheValeur;
begin
end;

constructor TArbre.Create{( UnAfficheur: PTextObject)};
begin
     //Afficheur:= UnAfficheur;
     Busy:= False;
     Arbre:= nil;
     Courant:= nil;
     XMax:= 1;
     NbElements:= 0;
end;

procedure TArbre.DestroyTree;
var
   Moment: TMoment;
   N: TNoeud;
begin
     N:= Arbre;
     Moment:= m_NoeudInferieur;
     if N <> nil
     then
         repeat
               case Moment
               of
                 m_NoeudInferieur:
                   if N.Inferieur <> nil
                   then
                       N:= N.Inferieur
                   else
                       Moment:= m_ValeurNoeud;
                 m_ValeurNoeud:
                   Moment:= m_NoeudSuperieur;
                 m_NoeudSuperieur:
                   if N.Superieur <> nil
                   then
                       begin
                       N:= N.Superieur;
                       Moment:= m_NoeudInferieur;
                       end
                   else
                       Moment:= m_RacineNoeud;
                 m_RacineNoeud:
                   begin
                   if N.Typ = tn_Inferieur
                   then
                       Moment:= m_ValeurNoeud;
                   Courant:= N.Racine;
                   N.Free;
                   N:= Courant;
                   end;
                 end;
         until (N.Typ = tn_Souche) and (Moment = m_RacineNoeud);


     Busy:= False;
     Arbre:= nil;
     Courant:= nil;
     XMax:= 1;
     NbElements:= 0;
end;

procedure TArbre.Insere( _Valeur: Word);
begin
     Busy:= True;
     Courant:= Arbre;
     if Courant = nil
     then
         begin
         Arbre:= TNoeud.Create( _Valeur);
         Busy:= False;
         end
     else
         repeat
               case CompareAaB( _Valeur, Courant.Valeur)
               of
                 tc_Inferieur,
                 tc_Egal:
                   if Courant.Inferieur = nil
                   then
                       begin
                       Fish:= TNoeud.Create( _Valeur);
                       Courant.Inferieur:= Fish;
                       Busy:= False;
                       end
                   else
                       Courant:= Courant.Inferieur;
                 tc_Superieur:
                   if Courant.Superieur = nil
                   then
                       begin
                       Fish:= TNoeud.Create( _Valeur);
                       Courant.Superieur:= Fish;
                       Busy:= False;
                       end
                   else
                       Courant:= Courant.Superieur;
                 end;
         until not Busy;
     Inc( NbElements);
end;

procedure TArbre.LireDans( _Tableau: WordArray);
var
   Pas: LongInt;
   Indice: LongInt;
begin
     DestroyTree;
     Pas:= Length( _Tableau) div 2;
     repeat
           for Indice:= 1 to ( High(_Tableau) div Pas)
           do
             Insere(_Tableau[ Indice*Pas]);
           Pas:= Pas div 2;
     until Pas = 0;
     Insere( _Tableau[ High(_Tableau)]);
end;

procedure TArbre.LireDichotomiquementDans( _Tableau: WordArray);
{sous-}procedure LireMilieuDe( a, b: LongInt);
var
   Milieu: LongInt;
begin
     Milieu:= (a+b) div 2;
     Insere( _Tableau[ Milieu]);
     if a <> b
     then
         begin
         if a <> Milieu
         then
             LireMilieuDe( a, Milieu);
         if b <> (Milieu + 1)
         then
             LireMilieuDe( Milieu+1, b);
         end;
end;
begin
     if Length( _Tableau) <> 0
     then
         begin
         DestroyTree;
         LireMilieuDe( 1, Length(_Tableau));
         Insere( _Tableau[High(_Tableau)]);
         end;
end;

function TArbre.Trouvee( _Valeur: Word): Boolean;
begin
     Result:= False;
     Busy:= True;
     Courant:= Arbre;
     if Courant = nil
     then
         begin
         Trouvee:= False;
         NoeudTrouve:= nil;
         Busy:= False;
         end
     else
         repeat
               case CompareAaB( _Valeur, Courant.Valeur)
               of
                 tc_Inferieur:
                    if Courant.Inferieur = nil
                    then
                        begin
                        Trouvee:= False;
                        Busy:= False;
                        end
                    else
                        Courant:= Courant.Inferieur;
                 tc_Egal:
                    begin
                    Trouvee:= True;
                    Busy:= False;
                    end;
                 tc_Superieur:
                    if Courant.Superieur = nil
                    then
                        begin
                        Trouvee:= False;
                        Busy:= False;
                        end
                    else
                        Courant:= Courant.Superieur;
                 end;
         until not Busy;
     NoeudTrouve:= Courant;
end;

function TArbre.OrdreOK: Boolean;
type
    TypeOrdre= (bto_Inferieur, bto_Valeur, bto_Superieur, bto_Souche);
var
   C: TNoeud;
   Prochain: TypeOrdre;
   Dernier: TNoeud;
   OK, Fin: Boolean;
begin
     C:= Arbre;
     Dernier:= C;
     Prochain:= bto_Inferieur;
     Result:= True;
     Fin:= False;
     repeat
           repeat
                 OK:= True;
                 case Prochain
                 of
                   bto_Inferieur:
                     begin
                     if C.Inferieur = nil
                     then
                         begin
                         OK:= False;
                         Prochain:= bto_Superieur;
                         end
                     else
                         begin
                         C:= C.Inferieur;
                         Prochain:= bto_Inferieur;
                         end;
                     end;
                   bto_Valeur: Prochain:= bto_Superieur;
                   bto_Superieur:
                     begin
                     if C.Superieur = nil
                     then
                         begin
                         OK:= False;
                         Prochain:= bto_Souche;
                         Dernier:= C;
                         end
                     else
                         begin
                         Dernier:= C;
                         C:= C.Superieur;
                         Prochain:= bto_Inferieur;
                         end;
                     end;
                   bto_Souche:
                     begin
                     if C.Racine <> nil
                     then
                         begin
                         case C.Typ
                         of
                           tn_Inferieur: Prochain:= bto_Valeur;
                           tn_Superieur: Prochain:= bto_Souche;
                           tn_Souche: Fin:= True;
                           end;
                         C:= C.Racine;
                         OK:= False;
                         end
                     else
                         Fin:= True;
                     end;
                   end;
           until OK or Fin;
           if     (Prochain <> bto_Souche)
              and ((Dernier.Typ <> tn_Souche) or (C.Typ <> tn_Inferieur))
           then
               Result:=
                 (CompareAaB( Dernier.Valeur, C.Valeur)
                  in [tc_Inferieur, tc_Egal]);
     until Fin or not Result;
end;

PROCEDURE TArbre.Afficher;
begin
{     ClrScr;
     XMax:= 1;}
     Affichage( Arbre, XMax, 1);
end;

FUNCTION TArbre.Affichage( A: TNoeud; XInferieur, Y: Word): Word;
{
var
   XSuperieur: Word;
   XCentreInferieur, XCentre, XCentreSuperieur: Word;
   X: Word;
   i: Byte;
}
begin
     Result:= 0;
{
     XCentre:= XInferieur;
     if A <> nil
        then
            begin
            if A.Inferieur <> nil
            then
               begin
               XCentreInferieur:= Affichage( A.Inferieur, XInferieur, Y+1);
               Xcentre:= XMax;
               Afficheur^.WriteXY( XCentreInferieur, Y,'+');
               for i:= XCentreInferieur+1 to XCentre-1
               do
                 Afficheur^.WriteXY( I, Y,'=');
               end;

            AfficheValeur( XCentre, Y, A.Valeur);
            X:= Afficheur^.WhereX;
            if X > XMax then
               XMax:= X;
            end;
            XCentreSuperieur:= XMax;
            XInferieur:= XMax;

            if A.Superieur <> nil
            then
               begin
               XCentreSuperieur:= Affichage( A.Superieur, XCentreSuperieur+1, Y+1);
               XSuperieur:= XMax;
               Afficheur^.WriteXY( XCentreSuperieur, Y,'+');
               for i:= XInferieur to XCentreSuperieur-1
               do
                 Afficheur^.WriteXY( I, Y, '=');
               end;
     Affichage:= XCentre;
}
end;

procedure TArbre.RangerDans( var _Tableau: WordArray);
var
   Moment: TMoment;
   N: TNoeud;
   Compteur: LongInt;
begin
     SetLength( _Tableau, NbElements);
     Moment:= m_NoeudInferieur;
     N:= Arbre;
     Compteur:= 0;
     repeat
           case Moment
           of
             m_NoeudInferieur:
               if N.Inferieur <> nil
               then
                   N:= N.Inferieur
               else
                   Moment:= m_ValeurNoeud;
             m_ValeurNoeud:
               begin
               _Tableau[ Compteur]:= N.Valeur;
               Inc( Compteur);
               Moment:= m_NoeudSuperieur;
               end;
             m_NoeudSuperieur:
               if N.Superieur <> nil
               then
                   begin
                   N:= N.Superieur;
                   Moment:= m_NoeudInferieur;
                   end
               else
                   Moment:= m_RacineNoeud;
             m_RacineNoeud:
               begin
               if N.Typ = tn_Inferieur
               then
                   Moment:= m_ValeurNoeud;
               N:= N.Racine;
               end;
             end;
     until Compteur>High( _Tableau);
end;

procedure TArbre.Equilibrer;
var
   WA: WordArray;
begin
     SetLength( WA, NbElements);
     RangerDans( WA);
     LireDichotomiquementDans( WA);
end;

END.
