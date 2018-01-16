unit uftBatpro_Element;
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
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.ActnList, FMX.StdCtrls, FMX.ComCtrls, Buttons, FMX.ExtCtrls, Grids,
  ufpBas,
  uhDessinnateur,
  uBatpro_Element,
  ubeString,
  ubeClusterElement, FMX.Menus;

const
     ncClusterDebut= 0;
     ncClusterFin  = 2;
     ncVertical    = 3;
type
 TftBatpro_Element
 =
  class(TfpBas)
    sg: TStringGrid;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function ftBatpro_Element: TftBatpro_Element;

implementation

uses
    uClean;

{$R *.fmx}

var
   FftBatpro_Element: TftBatpro_Element;

function ftBatpro_Element: TftBatpro_Element;
begin
     Clean_Get( Result, FftBatpro_Element, TftBatpro_Element);
end;

{ TftBatpro_Element }

function TftBatpro_Element.Execute: Boolean;
var
   hd: ThDessinnateur;

   bs1, bs2: TbeString;
   bec: array[ncClusterDebut..ncClusterFin] of TbeClusterElement;

   I: Integer;
   beci: TbeClusterElement;
begin
     hd:= ThDessinnateur.Create( 0, sg, 'Test', nil);
     try
        sg.ColCount:= ncVertical+10;
        sg.RowCount:= 1;


        bs1:= TbeString.Create( nil, 'Regroupement', TColorRec.Blue, bea_Centre_Horiz);
        bs1.Cree_Cluster;
        bs1.Cluster.Initialise;

        for I:= ncClusterDebut to ncClusterFin
        do
          begin
          beci:= TbeClusterElement.Create( nil, bs1);
          bec[i]:= beci;
          hd.Charge_Cell( beci, I,0);
          bs1.Cluster.Ajoute( beci, I, 0);
          end;

        bs2:= TbeString.Create( nil, 'Vertical', clLime, bea_Gauche, 900);
        bs2.beAlignement.V:= bea_Bas;
        hd.Charge_Cell( bs2 , ncVertical    ,0);

        hd.Traite_Dimensions;

        Result:= inherited Execute;
     finally
            Free_nil( hd);
            end;
end;

initialization
              Clean_Create ( FftBatpro_Element, TftBatpro_Element);
finalization
              Clean_Destroy( FftBatpro_Element);
end.
