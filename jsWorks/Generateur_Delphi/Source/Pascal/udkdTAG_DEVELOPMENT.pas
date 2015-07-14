unit udkdTAG_DEVELOPMENT;
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
 TdkdTAG_DEVELOPMENT
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

function dkdTAG_DEVELOPMENT: TdkdTAG_DEVELOPMENT;

implementation

uses
    uClean,

{dkd_implementation_uses_key}
    uBatpro_Ligne_Printer,
    upoolTAG_DEVELOPMENT;

{$R *.dfm}

var
   FdkdTAG_DEVELOPMENT: TdkdTAG_DEVELOPMENT;

function dkdTAG_DEVELOPMENT: TdkdTAG_DEVELOPMENT;
begin
     Clean_Get( Result, FdkdTAG_DEVELOPMENT, TdkdTAG_DEVELOPMENT);
end;

{ TdkdTAG_DEVELOPMENT }

procedure TdkdTAG_DEVELOPMENT.FormCreate(Sender: TObject);
begin
     pool:= poolTAG_DEVELOPMENT;
     Nom:= 'TAG_DEVELOPMENT';
     inherited;
end;

procedure TdkdTAG_DEVELOPMENT.bImprimerClick(Sender: TObject);
var
   cLibelle: TChamp;
   sLibelle: String;
begin
     inherited;
     cLibelle:= bl.Champs.Champ[ 'Libelle'];
     if Assigned( cLibelle)
     then
         sLibelle:= 'TAG_DEVELOPMENT de '+cLibelle.Chaine
     else
         sLibelle:= 'TAG_DEVELOPMENT';

     Batpro_Ligne_Printer.Execute( 'dkdTAG_DEVELOPMENT.stw',
                                   sLibelle,[],[],[],[],
                                   ['TAG_DEVELOPMENT'],
                                   [sl],
                                   [ nil],
                                   [ nil]);
end;

procedure TdkdTAG_DEVELOPMENT.Accroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;

procedure TdkdTAG_DEVELOPMENT.Decroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;


initialization
              Clean_Create ( FdkdTAG_DEVELOPMENT, TdkdTAG_DEVELOPMENT);
finalization
              Clean_Destroy( FdkdTAG_DEVELOPMENT);
end.
