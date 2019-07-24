unit utc_btInteger;
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
    u_sys_,
    uClean,
    uBinary_Tree,
    ubtInteger,
    TestFrameWork, SysUtils;


type
 Ttc_btInteger
 =
  class(TTestCase)
  private

  protected
    bt: TbtInteger;
    I: array[0..20] of Integer;
    O: array[0..20] of TObject;
    procedure SetUp; override;
    procedure TearDown; override;
    procedure Obtenu_Attendu( Obtenu, Attendu: Integer);
  published
    // Test methods
    procedure TestAjoute;
    procedure TestEnleve;
    procedure TestEnleve_complique;
    procedure AfficheEnleve_complique;
    procedure TestValue_from_Cle;

    procedure AfficheTri;
    procedure AfficheInverse;
    procedure AfficheMilieu;

    procedure TestIterateur;
    procedure TestCount;

    procedure TestSuppressionRacine;

    procedure TestCotes;

    procedure AfficheEnleveAvantDernier;
    procedure AfficheParIterateur;

  //test enlèvement avec vérification par Value_from_Cle
  private
    procedure TestEnleve_par_Value_from_Cle_interne( _J: Integer);
  published
    procedure TestEnleve_par_Value_from_Cle;
  //recherche par itération sur l'arbre
  private
    function Value_from_Cle_par_iteration( _Valeur: Integer): TObject;
  //test enlèvement avec vérification par itération
  private
    TestEnleve_par_Iteration_interne_resultat: String;
    procedure TestEnleve_par_Iteration_interne( _J: Integer);
  published
    procedure TestEnleve_par_Iteration;
  end;

implementation

{ Ttc_btInteger }

procedure Ttc_btInteger.Obtenu_Attendu( Obtenu, Attendu: Integer);
begin
     Check( Obtenu = Attendu,
            Format(  'Obtenu : %d éléments'+sys_N
                    +'Attendu: %d éléments'+sys_N, [Obtenu, Attendu]));
end;

procedure Ttc_btInteger.SetUp;
var
   J: Integer;
     procedure A( _index: Integer; _I: Integer);
     begin
          I[ _index]:= _I;
          O[ _index]:= TObject(Pointer(_I));
     end;
begin
     inherited;
     bt:= TbtInteger.Create( nil, 'Ttc_btInteger.bt');

     for J:= Low(I) to High(I)
     do
       A( J, J);
end;

procedure Ttc_btInteger.TearDown;
begin
     inherited;
     Free_nil( bt);
end;

procedure Ttc_btInteger.TestAjoute;
begin
     bt.Ajoute( I[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( I[1]));
end;

procedure Ttc_btInteger.TestEnleve;
begin
     bt.Ajoute( I[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( I[1]));
     bt.Enleve( I[1]);
     Check( nil = bt.Value_from_Cle( I[1]));
end;

procedure Ttc_btInteger.TestEnleve_complique;
var
   J, J2: Integer;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     J2:= High(I) div 2;

     Check( O[J2] = bt.Value_from_Cle( I[J2]));
     bt.Enleve( I[J2]);
     Check( nil = bt.Value_from_Cle( I[J2]));
end;

procedure Ttc_btInteger.AfficheEnleve_complique;
var
   J, J2: Integer;
   Resultat: String;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     J2:= High(I) div 2;

     bt.Enleve( I[J2]);

     Resultat:= bt.List;
     Check( '' = Resultat, 'Enlevé: '+IntToStr(I[J2])+sys_N+Resultat);
end;

procedure Ttc_btInteger.TestEnleve_par_Value_from_Cle_interne( _J: Integer);
var
   J: Integer;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     Check( O[_J] = bt.Value_from_Cle( I[_J]));
     bt.Enleve( I[_J]);
     Check( nil = bt.Value_from_Cle( I[_J]));
end;

procedure Ttc_btInteger.TestEnleve_par_Value_from_Cle;
var
   J: Integer;
begin
     for J:= Low(I) to High(I)
     do
       TestEnleve_par_Value_from_Cle_interne( J);
end;

function Ttc_btInteger.Value_from_Cle_par_iteration( _Valeur: Integer): TObject;
var
   Valeur: Integer;
begin
     bt.Iterateur_Start;
     try
        while not bt.Iterateur_EOF
        do
          begin
          bt.Iterateur_Suivant( Result);
          Valeur:= Integer( Pointer( Result));
          if _Valeur = Valeur then exit;
          end;
     finally
            bt.Iterateur_Stop;
            end;
     Result:= nil;
end;

procedure Ttc_btInteger.TestEnleve_par_Iteration_interne(_J: Integer);
var
   J: Integer;
begin
     TearDown;
     SetUp;
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     if O[_J] <> Value_from_Cle_par_iteration( I[_J])
     then
         TestEnleve_par_Iteration_interne_resultat
         :=
            TestEnleve_par_Iteration_interne_resultat+#13#10
           + 'check 1, _J='+IntToStr(_J);
     bt.Enleve( I[_J]);
     if nil <> Value_from_Cle_par_iteration( I[_J])
     then
         TestEnleve_par_Iteration_interne_resultat
         :=
             TestEnleve_par_Iteration_interne_resultat+#13#10
           + 'check 2, _J='+IntToStr(_J);
end;

procedure Ttc_btInteger.TestEnleve_par_Iteration;
var
   J: Integer;
begin
     TestEnleve_par_Iteration_interne_resultat:= '';
     for J:= 1 to High(I)   //1 car 0 = nil
     do
       TestEnleve_par_Iteration_interne( J);
     Check( TestEnleve_par_Iteration_interne_resultat = '', TestEnleve_par_Iteration_interne_resultat);
end;

procedure Ttc_btInteger.TestValue_from_Cle;
begin
     bt.Ajoute( I[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( I[1]));
end;

procedure Ttc_btInteger.AfficheTri;
var
   J: Integer;
   Resultat: String;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btInteger.AfficheInverse;
var
   J: Integer;
   Resultat: String;
begin
     for J:= High(I) downto Low(I)
     do
       bt.Ajoute( I[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btInteger.AfficheMilieu;
var
   J: Integer;
   Resultat: String;
begin
     for J:= High(I) downto High(I) div 2
     do
       bt.Ajoute( I[J], O[J]);

     for J:= Low(I) to High(I) div 2
     do
       bt.Ajoute( I[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btInteger.TestIterateur;
var
   J: Integer;
   Objet: TObject;
   Valeur: Integer;
   Resultat: String;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     Resultat:= sys_Vide;
     J:= Low(I);
     bt.Iterateur_Start;
     while not bt.Iterateur_EOF
     do
       begin
       bt.Iterateur_Suivant( Objet);
       Valeur:= Integer( Pointer( Objet));
       Obtenu_Attendu( Valeur, I[J]);
       Resultat:= Resultat + sys_N+IntToStr(Valeur);
       Inc( J);
       end;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btInteger.TestCount;
var
   J, J2: Integer;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);
     Obtenu_Attendu( bt.Count, Length( I));

     J2:= High(I) div 2;
     bt.Enleve( I[J2]);
     Obtenu_Attendu( bt.Count, Length( I)-1);

     bt.Enleve( I[Low(I)]);
     Obtenu_Attendu( bt.Count, Length( I)-2);

     bt.Objet_Remove( O[High(I)]);
     Obtenu_Attendu( bt.Count, Length( I)-3);
end;

procedure Ttc_btInteger.TestSuppressionRacine;
var
   J: Integer;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     bt.Remove( bt.Root);

     Obtenu_Attendu( bt.Count, Length( I)-1);
end;

procedure Ttc_btInteger.TestCotes;
//var
//   J: Integer;
//   Objet: TObject;
//   Inferieur, Superieur: TBinary_TreeItem;
//   procedure T( Branche: TBinary_TreeItem; Cote: TCote);
//   begin
//        if Branche = nil then exit;
//        Check( Branche.Cote = Cote, 'Mauvais coté pour '+Branche.Libelle);
//   end;
begin
//     for J:= Low(I) to High(I)
//     do
//       bt.Ajoute( I[J], O[J]);
//
//     bt.Iterateur_Start;
//     while not bt.Iterateur_EOF
//     do
//       begin
//       T( bt.btiIterateur_Suivant.Inferieur, c_Inferieur);
//       T( bt.btiIterateur_Suivant.Superieur, c_Superieur);
//       bt.Iterateur_Suivant( Objet);
//       end;
end;

procedure Ttc_btInteger.AfficheEnleveAvantDernier;
var
   J, J2: Integer;
   S: String;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);

     J2:= 18;

     S:= 'Avant'#13#10+bt.List;
     bt.Enleve( I[J2]);

     S:= S+#13#10'Enlevé: '+IntToStr(I[J2])+sys_N+bt.List;
     Check( false, S);
end;

procedure Ttc_btInteger.AfficheParIterateur;
var
   J: Integer;
   S: String;
   P: TObject;
begin
     for J:= Low(I) to High(I)
     do
       bt.Ajoute( I[J], O[J]);


     S:= 'par iterateur'#13#10;
     bt.Iterateur_Start;
     while not bt.Iterateur_EOF
     do
       begin
       bt.Iterateur_Suivant( P);
       S:= S+IntToStr(Integer(Pointer(P)))+#13#10;
       end;
     Check( false, S);
end;

initialization
              TestFramework.RegisterTest('utc_btInteger Suite', Ttc_btInteger.Suite);
end.


