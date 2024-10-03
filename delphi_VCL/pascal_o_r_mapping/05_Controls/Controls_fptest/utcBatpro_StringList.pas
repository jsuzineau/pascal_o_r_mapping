unit utcBatpro_StringList;
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
    uBatpro_StringList,
  TestFrameWork;

type
 TtcIterateurTestElement
 =
  class
  public
    constructor Create( _Valeur: Integer);
  public
    Valeur: Integer;
    function s: String;
  end;

 TtcIterateur
 =
  class(TTestCase)
  private
    sl: TBatpro_StringList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  //Variables de test
  private
   I: TIterateur;
   e: TtcIterateurTestElement;
   Msg: String;
   procedure Check_Valeur( _Valeur: Integer);
  // Test methods
  published
    procedure Test_Croissant;
    procedure Test_Decroissant;
    procedure Test_Supprime_courant_Croissant;
    procedure Test_Supprime_courant_Decroissant;
  end;

implementation

uses SysUtils;

{ TtcIterateurTestElement }

constructor TtcIterateurTestElement.Create( _Valeur: Integer);
begin
     Valeur:= _Valeur;
end;

function TtcIterateurTestElement.s: String;
begin
     Result:= IntToStr( Valeur);
end;

{ TtcIterateur }

procedure TtcIterateur.SetUp;
var
   Valeur: Integer;
begin
     inherited;
     sl:= TBatpro_StringList.CreateE( ClassName+'.sl', TtcIterateurTestElement);
     for Valeur:= 0 to 10
     do
       sl.AddObject( IntToStr( Valeur), TtcIterateurTestElement.Create( Valeur));
     Msg:= '';
end;

procedure TtcIterateur.TearDown;
begin
     FreeAndNil( sl);
     inherited;
end;

procedure TtcIterateur.Check_Valeur( _Valeur: Integer);
begin
     Check( not I.not_Suivant_interne( e), Msg+'élément non affecté');
     Check( e.Valeur = _Valeur, Msg+'On a l''élement '+e.s+' au lieu de l''élément '+IntToStr(_Valeur));
end;

procedure TtcIterateur.Test_Croissant;
var
   Valeur: Integer;
begin
     I:= sl.Iterateur_interne;
     Check( I.Continuer, 'Liste vide');
     for Valeur:= 0 to 10
     do
       Check_Valeur( Valeur);
end;

procedure TtcIterateur.Test_Decroissant;
var
   Valeur: Integer;
begin
     I:= sl.Iterateur_interne_Decroissant;
     Check( I.Continuer, 'Liste vide');
     for Valeur:= 10 downto 0
     do
       Check_Valeur( Valeur);
end;

procedure TtcIterateur.Test_Supprime_courant_Croissant;
begin
     Msg:= 'Première passe: ';
     I:= sl.Iterateur_interne;
     Check( I.Continuer, 'Liste vide');
     Check_Valeur( 0);
     Check_Valeur( 1);
     I.Supprime_courant;
     Check_Valeur( 2);

     Msg:= 'Deuxième passe: ';
     I:= sl.Iterateur_interne;
     Check( I.Continuer, 'Liste vide');
     Check_Valeur( 0);
     Check_Valeur( 2);
end;

procedure TtcIterateur.Test_Supprime_courant_Decroissant;
begin
     Msg:= 'Première passe: ';
     I:= sl.Iterateur_interne_Decroissant;
     Check( I.Continuer, 'Liste vide');
     Check_Valeur( 10);
     Check_Valeur(  9);
     I.Supprime_courant;
     Check_Valeur(  8);

     Msg:= 'Deuxième passe: ';
     I:= sl.Iterateur_interne_Decroissant;
     Check( I.Continuer, 'Liste vide');
     Check_Valeur( 10);
     Check_Valeur(  8);
end;

initialization
  TestFramework.RegisterTest('utcBatpro_StringList Suite', TtcIterateur.Suite);
end.
