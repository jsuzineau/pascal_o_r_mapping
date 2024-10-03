unit uIntervalle;
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
    ufAccueil_Erreur,
    SysUtils, Classes, Math;

type
 TIntervalle
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _PDebut: PDateTime= nil; _PFin: PDateTime= nil);
    destructor  Destroy; override;
  //Attributs
  private
    attributs_locaux: Boolean;
    LocalDebut: TDateTime;
    LocalFin  : TDateTime;
    PDebut, PFin: PDateTime;
    function GetDebut: Integer;
    function GetFin: Integer;
    procedure SetDebut(const Value: Integer);
    procedure SetFin(const Value: Integer);
    procedure Calcule_Vide;
  public
    Vide: Boolean;
    property Debut: Integer read GetDebut write SetDebut;
    property Fin  : Integer read GetFin   write SetFin  ;
  //Méthodes
  public
    procedure Init_from_( _Intervalle: TIntervalle);
    procedure Intersection_avec_( _Intervalle: TIntervalle);
    function Contient( D: Integer): Boolean;
  end;


implementation

{ TIntervalle }

constructor TIntervalle.Create( _PDebut: PDateTime= nil; _PFin: PDateTime= nil);
var
   d: TDateTime;
   i: Integer;
begin
     attributs_locaux:= _PDebut = nil;

     if attributs_locaux
     then
         begin
         PDebut:= @LocalDebut;
         PFin  := @LocalFin;
         try
            Debut:= Trunc( Now);
         except
               on E:Exception
               do
                 begin
                 fAccueil_Erreur('TIntervalle.Create: Echec de Debut:= Now; PDebut= $'+IntToHex(Integer(Pointer(PDebut)), 8));
                 end;
               end;
         Fin  := Debut;
         end
     else
         begin
         PDebut:= _PDebut;
         PFin  := _PFin  ;
         Calcule_Vide;
         end;
end;

destructor TIntervalle.Destroy;
begin
     inherited;
end;

function TIntervalle.GetDebut: Integer;
begin
     Result:= Trunc( PDebut^);
end;

function TIntervalle.GetFin: Integer;
begin
     Result:= Trunc( PFin^);
end;

procedure TIntervalle.SetDebut(const Value: Integer);
begin
     PDebut^:= Value;
     Calcule_Vide;
end;

procedure TIntervalle.SetFin(const Value: Integer);
begin
     PFin^:= Value;
     Calcule_Vide;
end;

procedure TIntervalle.Init_from_( _Intervalle: TIntervalle);
begin
     Debut:= _Intervalle.Debut;
     Fin  := _Intervalle.Fin  ;
end;

procedure TIntervalle.Calcule_Vide;
begin
     Vide:= Fin < Debut;
end;

procedure TIntervalle.Intersection_avec_( _Intervalle: TIntervalle);
begin
     if _Intervalle = nil then exit;
     
     Debut:= Max( Debut, _Intervalle.Debut);
     Fin  := Min( Fin  , _Intervalle.Fin  );
end;

function TIntervalle.Contient( D: Integer): Boolean;
begin
     Result:= (Debut <=D)and(D<= Fin);
end;

end.
