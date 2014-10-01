unit uOD_Table_Batpro;
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
    uOD,
    uOD_Maitre,
    uOD_Batpro_Table,
    uBatpro_OD_Printer,
    SysUtils, Classes;

type
 TOD_Table_Batpro
 =
  class( TOD_Maitre)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  protected
    Tables: array of TOD_Batpro_Table;
    procedure Init; override;
    function  Editer_Modele_Impression_interne: String; override;
    function  Composer              : String; override;
  public
    function Ajoute_Table( _Nom: String; _Bordure_Ligne: Boolean= True): TOD_Batpro_Table;
  end;

implementation

{ TOD_Table_Batpro }

constructor TOD_Table_Batpro.Create;
begin
     inherited;
end;

destructor TOD_Table_Batpro.Destroy;
begin
     inherited;
end;

procedure TOD_Table_Batpro.Init;
begin
     inherited;
     SetLength( Tables, 0);
end;

function TOD_Table_Batpro.Ajoute_Table( _Nom: String; _Bordure_Ligne: Boolean= True): TOD_Batpro_Table;
begin
     Result:= TOD_Batpro_Table.Create( _Nom, _Bordure_Ligne);

     SetLength( Tables, Length( Tables)+1);

     Tables[ High( Tables)]:= Result;
end;

function  TOD_Table_Batpro.Editer_Modele_Impression_interne: String;
begin
     Result:= NomFichier_Modele( True);
     Batpro_OD_Printer.AssureModele( Result,
                                        ParametresNoms,
                                        Maitres_Titre, Maitres_bl,
                                        Tables
                                        );
end;

function TOD_Table_Batpro.Composer: String;
begin
     Result:= Batpro_OD_Printer.Execute( NomFichier_Modele,
                                    TitreEtat,
                                    ParametresNoms, ParametresValeurs,
                                    Maitres_Titre, Maitres_bl,
                                    Tables);
     Traite_Logos( Result);
end;

end.

