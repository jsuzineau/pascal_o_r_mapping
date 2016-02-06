unit utc_hDessinnateur_web;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uSVG,
    uDrawInfo,
    uBatpro_Element,
    ubeClusterElement,
    ubeString,
    uhDessinnateurWeb,
    upoolG_BECP,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type
 TTest_hDessinnateur_web
 =
  class(TTestCase)
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  //attributs
  private
    hdW: ThDessinnateurWeb;
    bs: TbeString;
    ce1: TbeClusterElement;
    ce2: TbeClusterElement;
  end;

implementation

procedure TTest_hDessinnateur_web.TestHookUp;
begin
     //Fail('Écrivez votre propre test');
     hdW.Test_html;
end;

procedure TTest_hDessinnateur_web.SetUp;
begin
     bs:= TbeString.Create( nil, 'Test', clYellow, bea_Gauche);
     bs.Cree_Cluster;
     bs.Cluster.Initialise;
     bs.Cluster.Colonne_LargeurMaxi:= 10;
     ce1:= TbeClusterElement.Create( nil, bs);
     ce2:= TbeClusterElement.Create( nil, bs);
     bs.Cluster.Ajoute( ce1, 1,1);
     bs.Cluster.Ajoute( ce2, 2,1);


     hdW:= ThDessinnateurWeb.Create( 1, 'Test', nil);
     hdW.sg.Width := 100;
     hdW.sg.Height:= 100;
     hdW.sg.DefaultColWidth := 25;
     hdW.sg.DefaultRowHeight:= 25;
     hdW.sg.Resize( 4, 4);

     hdW.Charge_Cell( ce1, 1, 1);
     hdW.Charge_Cell( ce2, 2, 1);
end;

procedure TTest_hDessinnateur_web.TearDown;
begin
     Free_nil( bs);
     Free_nil( hdW);
end;

initialization
              RegisterTest(TTest_hDessinnateur_web);
end.

