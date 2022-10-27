unit udkdNom_de_la_classe;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
 TdkdNom_de_la_classe
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

function dkdNom_de_la_classe: TdkdNom_de_la_classe;

implementation

uses
    uClean,
//JoinPoint_uses_ubl
{dkd_implementation_uses_key}
    uBatpro_Ligne_Printer,
    upoolNom_de_la_classe;

{$R *.dfm}

var
   FdkdNom_de_la_classe: TdkdNom_de_la_classe;

function dkdNom_de_la_classe: TdkdNom_de_la_classe;
begin
     Clean_Get( Result, FdkdNom_de_la_classe, TdkdNom_de_la_classe);
end;

{ TdkdNom_de_la_classe }

procedure TdkdNom_de_la_classe.FormCreate(Sender: TObject);
begin
     pool:= poolNom_de_la_classe;
     Nom:= 'Nom_de_la_classe';
     inherited;
end;

procedure TdkdNom_de_la_classe.bImprimerClick(Sender: TObject);
var
   cLibelle: TChamp;
   sLibelle: String;
begin
     inherited;
     cLibelle:= bl.Champs.Champ[ 'Libelle'];
     if Assigned( cLibelle)
     then
         sLibelle:= 'Nom_de_la_classe de '+cLibelle.Chaine
     else
         sLibelle:= 'Nom_de_la_classe';

     Batpro_Ligne_Printer.Execute( 'dkdNom_de_la_classe.stw',
                                   sLibelle,[],[],[],[],
                                   ['Nom_de_la_classe'],
                                   [sl],
                                   [ nil],
                                   [ nil]);
end;

procedure TdkdNom_de_la_classe.Accroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;

procedure TdkdNom_de_la_classe.Decroche( _bl: TBatpro_Ligne; _sl: TStringList; _pc: TPageControl);
begin
     inherited;
end;


initialization
              Clean_Create ( FdkdNom_de_la_classe, TdkdNom_de_la_classe);
finalization
              Clean_Destroy( FdkdNom_de_la_classe);
end.
