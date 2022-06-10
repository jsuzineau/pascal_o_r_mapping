unit uTri_Ancetre;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014-2016 Jean SUZINEAU - MARS42                                       |
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
    uClean,
    uBatpro_StringList,
    u_sys_,
    uLog,
    uPublieur,
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
  SysUtils, Classes, math;

type

 { TTri_Ancetre }

 TTri_Ancetre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  protected
    slChampsTri: TBatpro_StringList;
    function  GetChampTri( NomChamp: String): Integer;
    procedure SetChampTri( NomChamp: String; const Value: Integer);
  public
    property ChampTri[ NomChamp: String]: Integer read GetChampTri write SetChampTri;
    procedure Reset_ChampsTri;

    procedure Execute( StringList: TBatpro_StringList); virtual; abstract;

    function LibelleTri( Court: Boolean = True): String;
    function LibelleChampTri( NomChamp: String; Court: Boolean = True): String;
    function OrderBy: String;
    function NbChampsTri: Integer;
  //Sous détails
  public
    slSousDetails: TslObject;
    procedure Execute_et_Cree_SousDetails( StringList: TBatpro_StringList); virtual; abstract;
    procedure Vide_SousDetails; virtual; abstract;
  //Observation des changements
  public
    pChange: TPublieur;
  //Longueur maximale de la chaine d'arbre pour affichage HTML
  public
    function Longueur_Arbre( _Champs: TChamps): Integer;
  end;


implementation

uses DateUtils;

{ TTri_Ancetre}

constructor TTri_Ancetre.Create;
begin
     slChampsTri:= TBatpro_StringList.Create;
     pChange:= TPublieur.Create( 'TTri_Ancetre.pChange');
     slSousDetails:= TslObject.Create( ClassName+'.slSousDetails');
end;

destructor TTri_Ancetre.Destroy;
begin
     Free_nil( slSousDetails);
     Free_nil( pChange);
     Free_nil( slChampsTri);
     inherited;
end;

function TTri_Ancetre.GetChampTri(NomChamp: String): Integer;
var
   I: Integer;
begin
     Result:= 0;

     I:= slChampsTri.IndexOf( NomChamp);
     if I = -1 then exit;

     Result:= Integer(Pointer(slChampsTri.Objects[ I]));
end;

procedure TTri_Ancetre.SetChampTri(NomChamp: String; const Value: Integer);
var
   I: Integer;
begin
     I:= slChampsTri.IndexOf( NomChamp);
     if I = -1
     then
         I:= slChampsTri.Add( NomChamp);

     slChampsTri.Objects[ I]:= TObject( Pointer( Integer( Value)));
     pChange.Publie;
end;

procedure TTri_Ancetre.Reset_ChampsTri;
begin
     slChampsTri.Clear;
     pChange.Publie;
end;

function TTri_Ancetre.LibelleChampTri( NomChamp: String; Court: Boolean = True): String;
     function Croissant: String;
     begin
          if Court
          then
              Result:= '/'
          else
              Result:= ' croissant'
     end;
     function Decroissant: String;
     begin
          if Court
          then
              Result:= '\'
          else
              Result:= ' décroissant'
     end;
begin
     case ChampTri[ NomChamp]
     of
       -1 : Result:= NomChamp + Decroissant;
        0 : Result:= sys_Vide;
       +1 : Result:= NomChamp + Croissant;
       else Result:= sys_Vide;
       end;
end;

function TTri_Ancetre.LibelleTri( Court: Boolean = True): String;
var
   I: Integer;
   sI: String;
begin
     Result:= sys_Vide;
     for I:= 0 to slChampsTri.Count - 1
     do
       begin
       sI:= LibelleChampTri( slChampsTri[I]);
       if sI <> sys_Vide
       then
           begin
           if Result <> sys_Vide
           then
               Result:= Result + ', ';
           Result:= Result + sI;
           end;
       end;
end;

function TTri_Ancetre.OrderBy: String;
var
   I: Integer;
   NomChamp: String;
begin
     Result:= sys_Vide;
     for I:= 0 to slChampsTri.Count - 1
     do
       begin
       NomChamp:= slChampsTri[I];
       if NomChamp <> sys_Vide
       then
           begin
           if Result <> sys_Vide
           then
               Result:= Result + ', ';
           Result:= Result + NomChamp;
           case ChampTri[ NomChamp]
           of
             -1 : Result:= Result + ' desc';
              0 : begin end;
             +1 : begin end;
             else begin end;
             end;
           end;
       end;
end;

function TTri_Ancetre.NbChampsTri: Integer;
begin
     Result:= slChampsTri.Count;
end;

function TTri_Ancetre.Longueur_Arbre( _Champs: TChamps): Integer;
const
     Indentation= 4;
var
   I: Integer;
   NomChamp: String;
   c: TChamp;
   d: TChampDefinition;
   Result_I: Integer;
   function Longueur_Indentation: Integer;
   begin
        Result:= I*Indentation;
        Log.PrintLn( ClassName+'.Longueur_Arbre, Longueur_Indentation= '+IntToStr( Result));
   end;
   function Longueur_Libelle: Integer;
   var
      S: String;
      L: Integer;
   begin
        S:= d.Libelle+': ';
        L:= d.Longueur;
        Result:= Length( S) + L;
        Log.PrintLn( ClassName+'.Longueur_Arbre, Longueur_Libelle= Length( '+S+')+'+IntToStr( L)+'= '+IntToStr( Result));
   end;
begin
     Result:= Length('Reset Tri');
     Log.PrintLn( ClassName+'.Longueur_Arbre, Initial, Result= '+IntToStr( Result));

     if slSousDetails.Count = 0 then exit;

     for I:= 0 to slChampsTri.Count - 1
     do
       begin
       NomChamp:= slChampsTri[I];
       if NomChamp = sys_Vide then continue;

       c:= _Champs.Champ_from_Field( NomChamp);
       if nil = c then continue;

       d:= c.Definition;
       if nil = d then continue;

       Log.PrintLn( ClassName+'.Longueur_Arbre, niveau '+IntToStr( I));

       Result_I:= Longueur_Indentation+Longueur_Libelle;
       Log.PrintLn( ClassName+'.Longueur_Arbre, Result_I= '+IntToStr( Result_I));

       Result:= Max( Result, Result_I);
       end;
end;

end.
