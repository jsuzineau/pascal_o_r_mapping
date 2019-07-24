unit uChrono;
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
    SysUtils, Classes,
    uBatpro_StringList,
    u_sys_;

type
 TChrono
 =
  class
  private
    Debut, Fin, dtStop: TDateTime;
    sl: TBatpro_StringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop( Info: String= '');

    function Get_Temps: String;

    function Get_Liste: String;
  end;

var
   Chrono: TChrono;

implementation

uses
    uClean;

{ TChrono }

constructor TChrono.Create;
begin
     inherited;
     sl:= TBatpro_StringList.Create;
end;

destructor TChrono.Destroy;
begin
     Free_nil( sl);
     inherited;
end;

procedure TChrono.Start;
begin
     Debut:= Now;
     Fin  := Debut;
     dtStop:= Fin;
     sl.Clear;
end;

procedure TChrono.Stop( Info: String= '');
begin
     dtStop:= Fin;
     Fin:= Now;
     if Info <> sys_Vide
     then
         Info:= ' <- '+Info;
     sl.Add( Get_Temps+Info);
end;

function TChrono.Get_Temps: String;
var
   Delta_Debut : TDateTime;
   Delta_dtStop: TDateTime;
begin
     Delta_Debut := Fin - Debut ;
     Delta_dtStop:= Fin - dtStop;
     Result:=  FormatDateTime( 'hh:nn:ss"."zzz', Delta_Debut )
              +', delta: '
              +FormatDateTime( 'hh:nn:ss"."zzz', Delta_dtStop);
end;

function TChrono.Get_Liste: String;
begin
     Result:= sl.Text;
end;

initialization
              Chrono:= TChrono.Create;
finalization
            Free_nil( Chrono);
end.
