unit uodSession;
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

    uhdmSession,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
 Classes, SysUtils;

type

 { TodSession }

 TodSession
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TBatpro_StringList;
    t: TOD_Batpro_Table;
    nSession, nWork, nWork_Self: TOD_Niveau;
  public
    procedure Init( _hdmSession: ThdmSession); reintroduce;
  end;

implementation

constructor TodSession.Create;
begin
     sl:= TBatpro_StringList.Create;
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Session.ott';
end;

destructor TodSession.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TodSession.Init( _hdmSession: ThdmSession);
begin
     inherited Init;

     t:= Ajoute_Table( 't');
     t.Pas_de_persistance:= True;
     t.Bordures_Verticales_Colonnes:= False;

     t.AddColumn(  1, '  ');
     t.AddColumn(  1, '  ');
     t.AddColumn( 17, '  ');
     nSession  := t.AddNiveau( 'Root');
     nWork     := t.AddNiveau( 'Work');
     nWork_Self:= t.AddNiveau( 'Self');
     nSession.Charge_sl( _hdmSession.sl);
     nSession  .Ajoute_Column_Avant( 'Titre'        , 0, 2);
     nWork     .Ajoute_Column_Avant( 'Session_Titre', 1, 2);
     nWork_Self.Ajoute_Column_Avant( 'Description'  , 2, 2);
     nSession  .Ajoute_Column_Apres( 'Pied'         , 1, 2);
end;

end.

