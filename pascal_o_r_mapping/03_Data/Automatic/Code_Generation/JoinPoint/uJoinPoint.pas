unit uJoinPoint;
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
    uContexteClasse,
    uContexteMembre;

type

 { TJoinPoint }

 TJoinPoint
 =
  class
  //Attributs
  public
    Cle: String;
    Valeur: String;
    cc: TContexteClasse;
    cm: TContexteMembre;
  //Gestion du cycle de vie
  public
  //Gestion de la visite d'une classe
  public
    procedure Initialise( _cc: TContexteClasse); virtual;
    procedure VisiteMembre( _cm: TContexteMembre); virtual;
    procedure VisiteEnumString( s_EnumString, sNomTableMembre: String); virtual;
    procedure VisiteDetail( s_Detail, sNomTableMembre: String); virtual;
    procedure VisiteSymetric( s_Symetric, sNomTableMembre: String); virtual;
    procedure VisiteAggregation( s_Aggregation, sNomTableMembre: String); virtual;
    procedure VisiteLibelle( s_Libelle: String); virtual;
    procedure Finalise; virtual;
    procedure To_Parametres( _sl: TStringList);
  //Méthodes
  public
    procedure pv( var S: String; Debut: String);
    procedure v( var S: String; Debut: String);
    procedure plus( var S: String; Debut: String);
  end;

procedure uJoinPoint_Initialise       ( _cc: TContexteClasse; a: array of TJoinPoint);
procedure uJoinPoint_VisiteMembre     ( _cm: TContexteMembre; a: array of TJoinPoint);
procedure uJoinPoint_VisiteEnumString ( s_EnumString     , sNomTableMembre: String; a: array of TJoinPoint);
procedure uJoinPoint_VisiteDetail     ( s_Detail     , sNomTableMembre: String; a: array of TJoinPoint);
procedure uJoinPoint_VisiteSymetric   ( s_Symetric   , sNomTableMembre: String; a: array of TJoinPoint);
procedure uJoinPoint_VisiteAggregation( s_Aggregation, sNomTableMembre: String; a: array of TJoinPoint);
procedure uJoinPoint_VisiteLibelle    ( s_Libelle: String; a: array of TJoinPoint);
procedure uJoinPoint_Finalise     (                       a: array of TJoinPoint);
procedure uJoinPoint_To_Parametres( _sl: TStringList    ; a: array of TJoinPoint);

implementation

procedure uJoinPoint_Initialise   ( _cc: TContexteClasse; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].Initialise( _cc);
end;
procedure uJoinPoint_VisiteMembre ( _cm: TContexteMembre; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteMembre( _cm);
end;
procedure uJoinPoint_VisiteEnumString ( s_EnumString,sNomTableMembre: String; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteEnumString ( s_EnumString, sNomTableMembre);
end;
procedure uJoinPoint_VisiteDetail ( s_Detail,sNomTableMembre: String; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteDetail ( s_Detail, sNomTableMembre);
end;
procedure uJoinPoint_VisiteSymetric( s_Symetric,sNomTableMembre: String; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteSymetric ( s_Symetric, sNomTableMembre);
end;
procedure uJoinPoint_VisiteAggregation ( s_Aggregation,sNomTableMembre: String; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteAggregation ( s_Aggregation, sNomTableMembre);
end;
procedure uJoinPoint_VisiteLibelle ( s_Libelle: String; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].VisiteLibelle ( s_Libelle);
end;
procedure uJoinPoint_Finalise     (                       a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].Finalise;
end;
procedure uJoinPoint_To_Parametres( _sl: TStringList    ; a: array of TJoinPoint);
var
   I: Integer;
begin
     for I:= Low( a) to High( a) do a[i].To_Parametres( _sl);
end;

{ TJoinPoint }

procedure TJoinPoint.Initialise(_cc: TContexteClasse);
begin
     cc:= _cc;
     cm:= nil;
     Valeur:= '';
end;

procedure TJoinPoint.VisiteMembre(_cm: TContexteMembre);
begin
     cm:= _cm;
end;

procedure TJoinPoint.Finalise;
begin
end;

procedure TJoinPoint.To_Parametres(_sl: TStringList);
begin
     _sl.Values[ Cle]:= Valeur;
end;

procedure TJoinPoint.VisiteEnumString(s_EnumString,sNomTableMembre: String);
begin

end;

procedure TJoinPoint.VisiteDetail(s_Detail,sNomTableMembre: String);
begin

end;

procedure TJoinPoint.VisiteSymetric(s_Symetric,sNomTableMembre: String);
begin

end;

procedure TJoinPoint.VisiteAggregation(s_Aggregation,sNomTableMembre: String);
begin

end;

procedure TJoinPoint.VisiteLibelle(s_Libelle: String);
begin

end;

procedure TJoinPoint.pv( var S: String; Debut: String);
begin
     if S = ''
     then
         S:= S + Debut
     else
         S:= S + ';';
end;
procedure TJoinPoint.v( var S: String; Debut: String);
begin
     if S = ''
     then
         S:= S + Debut
     else
         S:= S + ','#13#10;
end;
procedure TJoinPoint.plus( var S: String; Debut: String);
begin
     if S = ''
     then
         S:= S + Debut
     else
         S:= S + ' + ';
end;

end.
