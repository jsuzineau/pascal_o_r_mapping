unit udkdTAG;
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
    uBatpro_StringList,
    uDataUtilsU,
    uChamp,

    uBatpro_Ligne,

    udkdBase,

    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
    ExtCtrls, DB,
    ucChampsGrid, ucBatpro_Shape;

type
 TdkdTAG
 =
  class(TdkdBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Accroche( _bl: TBatpro_Ligne; _sl: TBatpro_StringList; _pc: TPageControl); override;
    procedure Decroche( _bl: TBatpro_Ligne; _sl: TBatpro_StringList; _pc: TPageControl); override;
  end;

function dkdTAG: TdkdTAG;

implementation

uses
    uClean,

{dkd_implementation_uses_key}
    uBatpro_Ligne_Printer,
    upoolTAG;

{$R *.dfm}

var
   FdkdTAG: TdkdTAG;

function dkdTAG: TdkdTAG;
begin
     Clean_Get( Result, FdkdTAG, TdkdTAG);
end;

{ TdkdTAG }

procedure TdkdTAG.FormCreate(Sender: TObject);
begin
     pool:= poolTAG;
     Nom:= 'TAG';
     inherited;
end;

procedure TdkdTAG.bImprimerClick(Sender: TObject);
var
   cLibelle: TChamp;
   sLibelle: String;
begin
     inherited;
     cLibelle:= bl.Champs.Champ[ 'Libelle'];
     if Assigned( cLibelle)
     then
         sLibelle:= 'TAG de '+cLibelle.Chaine
     else
         sLibelle:= 'TAG';

     Batpro_Ligne_Printer.Execute( 'dkdTAG.stw',
                                   sLibelle,[],[],[],[],
                                   ['TAG'],
                                   [sl],
                                   [ nil],
                                   [ nil]);
end;

procedure TdkdTAG.Accroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;

procedure TdkdTAG.Decroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;


initialization
              Clean_Create ( FdkdTAG, TdkdTAG);
finalization
              Clean_Destroy( FdkdTAG);
end.
