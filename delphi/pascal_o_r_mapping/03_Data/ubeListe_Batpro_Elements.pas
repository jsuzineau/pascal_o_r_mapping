unit ubeListe_Batpro_Elements;
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
    uBatpro_StringList,
    u_sys_,
    uClean,
    uDrawInfo,
    uBatpro_Element,
  SysUtils, Classes, FMX.Graphics, System.UITypes;

type
 TbeListe_Batpro_Elements
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( un_sl: TBatpro_StringList);
    destructor Destroy; override;
  //Attributs
  public
    slListe: TBatpro_StringList;
  //Méthodes
  public
    procedure Ajoute( be: TBatpro_Element    ); overload;
    procedure Ajoute( StringList: TBatpro_StringList); overload;
  //Gestion du texte de cellule
  protected
    function GetCell( Contexte: Integer): String; override;
  //Gestion du Hint
  public
    function Contenu( Contexte: Integer; Col, Row: Integer): String; override;
  //Comparaison
  public
    function Egale( be: TBatpro_Element): Boolean; override;
  //Affichage
  public
    function Couleur_Fond(DrawInfo: TDrawInfo): TColor; override;
    procedure {svg}Draw(DrawInfo: TDrawInfo); override;
  //Dessin d'une bordure
  protected
    function GetBordure: Boolean; override;
  end;


implementation

{ TbeListe_Batpro_Elements }

constructor TbeListe_Batpro_Elements.Create(un_sl: TBatpro_StringList);
begin
     inherited Create( un_sl);
     slListe:= TBatpro_StringList.Create;
end;

destructor TbeListe_Batpro_Elements.Destroy;
begin
     Free_nil( slListe);
     inherited;
end;

procedure TbeListe_Batpro_Elements.Ajoute( be: TBatpro_Element);
begin
     if be= nil then exit;
     slListe.AddObject( be.sCle, be);
     slListe.Sort;
end;

procedure TbeListe_Batpro_Elements.Ajoute( StringList: TBatpro_StringList);
begin
     slListe.AddStrings( StringList);
end;

function TbeListe_Batpro_Elements.GetCell( Contexte: Integer): String;
var
   I: Integer;
   be: TBatpro_Element;
begin
     //if Assigned( Cluster)
     //then
     //    begin
     //    Result:= Format( '(%d,%d,%d,%d)',
     //                     [
     //                     Cluster.Bounds.Left,
     //                     Cluster.Bounds.Top,
     //                     Cluster.Bounds.Right,
     //                     Cluster.Bounds.Bottom
     //                     ]);
     //    exit;
     //    end;
     Result:= sys_Vide;
     for I:= 0 to slListe.Count-1
     do
       begin
       be:= Batpro_Element_from_sl( slListe, I);
       if Assigned( be)
       then
           begin
           if Result <> sys_Vide
           then
               Result
               :=
                  Result + sys_N
                 +'—— § ——'+ sys_N;
           Result:= Result + be.Cell[ Contexte];
           end;
       end;
end;

function TbeListe_Batpro_Elements.Contenu( Contexte, Col, Row: Integer): String;
var
   I: Integer;
   be: TBatpro_Element;
begin
     Result:= sys_Vide;
     for I:= 0 to slListe.Count-1
     do
       begin
       be:= Batpro_Element_from_sl( slListe, I);
       if Assigned( be)
       then
           begin
           if Result <> sys_Vide
           then
               Result:= Result + sys_N;
           Result:= Result + be.Contenu( Contexte, Col, Row);
           end;
       end;
end;

function TbeListe_Batpro_Elements.Egale( be: TBatpro_Element): Boolean;
var
   bel: TbeListe_Batpro_Elements;
   slListe_Count: Integer;
   I: Integer;
   be1, be2: TBatpro_Element;
begin
     Result:= inherited Egale( be);
     if Result then exit;

     if Affecte_( bel, TbeListe_Batpro_Elements, be) then exit;

     slListe_Count:= slListe.Count;
     if slListe_Count = 0                  then exit;
     if bel.slListe.Count <> slListe_Count then exit;

     Result:= True;
     for I:= 0 to slListe_Count-1
     do
       begin
       be1:= Batpro_Element_from_sl(     slListe, I);
       be2:= Batpro_Element_from_sl( bel.slListe, I);
       Result
       :=
             Assigned( be1)
         and be1.Egale( be2);
       if not Result then break;
       end;
end;

function TbeListe_Batpro_Elements.Couleur_Fond(DrawInfo: TDrawInfo): TColor;
begin
     Result:= inherited Couleur_Fond( DrawInfo);
     if    (slListe.Count = 0)
        and not DrawInfo.Gris
     then
         Result:= TColorRec.White;
end;

procedure TbeListe_Batpro_Elements.{svg}Draw(DrawInfo: TDrawInfo);
begin
     inherited;
     //Dessinne_Bordure( DrawInfo);
     //DrawJalon( DrawInfo, tj_Losange, TColorRec.Red);
end;

function TbeListe_Batpro_Elements.GetBordure: Boolean;
begin
     Result
     :=
           (slListe.Count > 0   )
       and (inherited GetBordure);
end;

end.
