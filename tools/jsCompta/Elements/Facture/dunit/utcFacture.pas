unit utcFacture;
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

{$mode delphi}
uses
    udmDatabase,

    ublClient,
    upoolClient,

    ublFacture,
    upoolFacture,
    uRequete,
  SysUtils, Classes, fpcunit, testutils, testregistry;

type

  { TtcFacture }

  TtcFacture = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published
    // Test methods
    procedure Test_Nouveau_Numero;
    procedure Test_Annee_Incoherente;
    procedure Test;
  end;

implementation

{ TtcFacture }

procedure TtcFacture.Test_Nouveau_Numero;
var
   Annee: Integer;
   Nouveau: Integer;
begin
     poolClient.ToutCharger;
     dmDatabase.jsDataConnexion.ExecQuery( 'delete from facture');
     Annee:= CurrentYear;
     poolFacture.Test(Annee,1,Date, 0,'',0,0);
     Nouveau:= poolFacture.Nouveau_Numero( Annee);
     Check( Nouveau = 2, 'Echec');
end;

procedure TtcFacture.Test_Annee_Incoherente;
var
   Annee: Integer;
   Annee0: Integer;
   Annee1: Integer;
   Nouveau: Integer;
   bl0_1: TblFacture;
   bl0_2: TblFacture;
   bl0_3: TblFacture;
   bl1_1: TblFacture;
   bl1_3: TblFacture;
begin
     poolFacture.Vide;
     dmDatabase.jsDataConnexion.ExecQuery( 'delete from facture');
     poolClient.ToutCharger;
     Annee:= CurrentYear;
     Annee0:= Annee-1;
     Annee1:= Annee;

     //Test sur un cas valide
     bl0_1:= poolFacture.Assure(Annee0,1);
     bl0_2:= poolFacture.Assure(Annee0,2);
     bl0_3:= poolFacture.Assure(Annee0,3);
     Check( False=poolFacture.Annee_Incoherente( Annee0), 'Faux positif');

     //Test avec un trou dans la numérotation
     bl1_1:= poolFacture.Assure(Annee1,1);
     bl1_3:= poolFacture.Assure(Annee1,3);
     Check( poolFacture.Annee_Incoherente( Annee1), 'absence non trouvée');
end;


procedure TtcFacture.Test;
begin
end;

initialization
              RegisterTest( 'utcFacture Suite', TtcFacture.Suite);
end.
