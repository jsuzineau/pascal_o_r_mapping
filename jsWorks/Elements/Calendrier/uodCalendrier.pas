unit uodCalendrier;
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

{$mode delphi}

interface

uses
    uBatpro_StringList,

    uhdmCalendrier,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodCalendrier }

 TodCalendrier
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create( _Afficher_Depassement: Boolean);
    destructor Destroy; override;
  //Gestion état
  private
    Afficher_Depassement: Boolean;
    sl: TBatpro_StringList;
    t: TOD_Batpro_Table;
    n: TOD_Niveau;
  public
    procedure Init( _hdmCalendrier: ThdmCalendrier); reintroduce;
  end;

implementation

{ TodCalendrier }

constructor TodCalendrier.Create(_Afficher_Depassement: Boolean);
begin
     Afficher_Depassement:= _Afficher_Depassement;
     sl:= TBatpro_StringList.Create;
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Calendrier.ott';
end;

destructor TodCalendrier.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TodCalendrier.Init( _hdmCalendrier: ThdmCalendrier);
begin
     inherited Init;

     Ajoute_Parametre( 'Debut', DateTimeToStr( Trunc(_hdmCalendrier.Debut)));
     Ajoute_Parametre( 'Fin'  , DateTimeToStr( Trunc(_hdmCalendrier.Fin  )));
     t:= Ajoute_Table( 't');
     t.Pas_de_persistance:= True;
     if Afficher_Depassement
     then
         begin
         t.AddColumn( 15, '  '      );
         t.AddColumn( 20, 'Jour');
         t.AddColumn( 20, 'Dépassement');
         t.AddColumn( 20, 'Semaine');
         t.AddColumn( 20, 'Dépassement');
         t.AddColumn( 20, 'Global');
         t.AddColumn( 20, 'Dépassement');
         t.AddSurtitre(1,2,'Cumul Jour'   );
         t.AddSurtitre(3,4,'Cumul Semaine');
         t.AddSurtitre(5,6,'Cumul Global' );
         end
     else
         begin
         t.AddColumn( 15, '  '      );
         t.AddColumn( 20, 'Jour');
         t.AddColumn( 20, 'Cumul '#13#10'sur semaine');
         t.AddColumn( 20, 'Cumul '#13#10'global');
         end;
     n:= t.AddNiveau( 'Root');
     n.Charge_sl( _hdmCalendrier.sl);
     if Afficher_Depassement
     then
         begin
         n.Ajoute_Column_Avant( 'D'          , 0, 0);
         n.Ajoute_Column_Avant( 'Cumul_Jour_Total'         , 1, 1);
         n.Ajoute_Column_Avant( 'Cumul_Jour_Depassement'   , 2, 2);
         n.Ajoute_Column_Avant( 'Cumul_Semaine_Total'      , 3, 3);
         n.Ajoute_Column_Avant( 'Cumul_Semaine_Depassement', 4, 4);
         n.Ajoute_Column_Avant( 'Cumul_Global_Total'       , 5, 5);
         n.Ajoute_Column_Avant( 'Cumul_Global_Depassement' , 6, 6);
         end
     else
         begin
         n.Ajoute_Column_Avant( 'D'                  , 0, 0);
         n.Ajoute_Column_Avant( 'Cumul_Jour_Total'   , 1, 1);
         n.Ajoute_Column_Avant( 'Cumul_Semaine_Total', 2, 2);
         n.Ajoute_Column_Avant( 'Cumul_Global_Total' , 3, 3);
         end;
end;

end.

