unit utc_btString;
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
    ubtString,
    TestFrameWork, SysUtils;


type
 Ttc_btString
 =
  class(TTestCase)
  private

  protected
    bt: TbtString;
    S: array[1..20] of String;
    O: array[1..20] of TObject;
    procedure SetUp; override;
    procedure TearDown; override;

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
  end;

implementation

{ Ttc_btString }

procedure Ttc_btString.SetUp;
var
   J: Integer;
     procedure T( _index: Integer);
     begin
          S[ _index]:= Chr(64+_index);
          O[ _index]:= TObject(Pointer(_index+1));
     end;
begin
     inherited;
     bt:= TbtString.Create( nil);

     for J:= Low(S) to High(S)
     do
       T( J);
end;

procedure Ttc_btString.TearDown;
begin
     inherited;
     Free_nil( bt);
end;

procedure Ttc_btString.TestAjoute;
begin
     bt.Ajoute( S[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( S[1]));
end;

procedure Ttc_btString.TestEnleve;
begin
     bt.Ajoute( S[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( S[1]));
     bt.Enleve( S[1]);
     Check( nil = bt.Value_from_Cle( S[1]));
end;

procedure Ttc_btString.TestEnleve_complique;
var
   J, J2: Integer;
begin
     for J:= Low(S) to High(S)
     do
       bt.Ajoute( S[J], O[J]);

     J2:= High(S) div 2;

     Check( O[J2] = bt.Value_from_Cle( S[J2]));
     bt.Enleve( S[J2]);
     Check( nil = bt.Value_from_Cle( S[J2]));
end;

procedure Ttc_btString.AfficheEnleve_complique;
var
   J, J2: Integer;
   Resultat: String;
begin
     for J:= Low(S) to High(S)
     do
       bt.Ajoute( S[J], O[J]);

     J2:= High(S) div 2;

     bt.Enleve( S[J2]);

     Resultat:= bt.List;
     Check( '' = Resultat, 'Enlevé: '+S[J2]+sys_N+Resultat);
end;

procedure Ttc_btString.TestValue_from_Cle;
begin
     bt.Ajoute( S[1], O[1]);
     Check( O[1] = bt.Value_from_Cle( S[1]));
end;

procedure Ttc_btString.AfficheTri;
var
   J: Integer;
   Resultat: String;
begin
     for J:= Low(S) to High(S)
     do
       bt.Ajoute( S[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btString.AfficheInverse;
var
   J: Integer;
   Resultat: String;
begin
     for J:= High(S) downto Low(S)
     do
       bt.Ajoute( S[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

procedure Ttc_btString.AfficheMilieu;
var
   J: Integer;
   Resultat: String;
begin
     for J:= High(S) downto High(S) div 2
     do
       bt.Ajoute( S[J], O[J]);

     for J:= Low(S) to High(S) div 2
     do
       bt.Ajoute( S[J], O[J]);

     Resultat:= bt.List;
     Check( '' = Resultat, Resultat);
end;

initialization
  TestFramework.RegisterTest('utc_btString Suite',
    Ttc_btString.Suite);

end.
