unit uTraits;
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
    uClean,
    uBatpro_StringList,
    uVide,
    uContextes,
    uDrawInfo,
    uSVG,
  {$IFNDEF FPC}
  Graphics,
  {$ENDIF}
  SysUtils, Classes;

type
 TArete
 =
  (
  a_Milieu,
  a_Gauche,
  a_Haut  ,
  a_Droite,
  a_Bas
  );
 TProgression_Trait
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Debut, Arrivee: TArete;
    Step: Integer;
  end;
 TLigne
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    bl_1,
    bl_2: TObject;
    x1,y1,
    x2,y2: Integer;
    IndiceColonne: Integer;
  //Clé
  public
    function sCle: String;
  //Progressions
  private
    FHorizontal: TProgression_Trait;
    FAngle     : TProgression_Trait;
    FVertical  : TProgression_Trait;
    procedure Assure_Progression( var pt: TProgression_Trait);
  public
    function Horizontal: TProgression_Trait;
    function Angle     : TProgression_Trait;
    function Vertical  : TProgression_Trait;
  end;
 TTrait
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Ligne: TLigne;
    Depart, Arrivee: TArete;
    a: double;
    IsDebutLigne, IsFinLigne: Boolean;
  //Méthodes
  public
    procedure {svg}Dessinne(  DrawInfo: TDrawInfo);
  end;
 TTraits
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    sl: TBatpro_StringList;
  //Méthodes
  public
    function Ajoute( _Ligne: TLigne;
                      _Depart, _Arrivee: TArete): TTrait;
    procedure {svg}Dessinne( DrawInfo: TDrawInfo);
    procedure Vide;
  end;

function Ligne_from_sl( sl: TStringList; Index: Integer): TLigne;
function Ligne_from_sl_sCle( sl: TStringList; sCle: String): TLigne;

implementation

uses Types;

function Ligne_from_sl( sl: TStringList; Index: Integer): TLigne;
begin
     _Classe_from_sl( Result, TLigne, sl, Index);
end;

function Ligne_from_sl_sCle( sl: TStringList; sCle: String): TLigne;
begin
     _Classe_from_sl_sCle( Result, TLigne, sl, sCle);
end;

{ TProgression_Trait }

constructor TProgression_Trait.Create;
begin

end;

destructor TProgression_Trait.Destroy;
begin

  inherited;
end;

{ TLigne }

constructor TLigne.Create;
begin
     bl_1:= nil;
     bl_2:= nil;
     x1:= 0;
     y1:= 0;
     x2:= 0;
     y2:= 0;
     FHorizontal:= nil;
     FAngle     := nil;
     FVertical  := nil;
end;

destructor TLigne.Destroy;
begin

     inherited;
end;

function TLigne.sCle: String;
begin
     Result
     :=
        IntToHex( Integer(Pointer( bl_2)), 8)
       +IntToHex( Integer(Pointer( bl_1)), 8);
end;

procedure TLigne.Assure_Progression(var pt: TProgression_Trait);
begin
     if pt = nil
     then
         pt:= TProgression_Trait.Create;
end;

function TLigne.Horizontal: TProgression_Trait;
begin
     Assure_Progression( FHorizontal);
     Result:= FHorizontal;
     if x1 <= x2
     then
         begin
         Result.Step:= +1;
         Result.Debut  := a_Gauche;
         Result.Arrivee:= a_Droite;
         end
     else
         begin
         Result.Step:= -1;
         Result.Debut  := a_Droite;
         Result.Arrivee:= a_Gauche;
         end
end;

function TLigne.Angle: TProgression_Trait;
begin
     Assure_Progression( FAngle);
     Result:= FAngle;
     Result.Step:= 0;
     if x1 <= x2
     then
         Result.Debut:= a_Gauche
     else
         Result.Debut:= a_Droite;
     if y1 <= y2
     then
         Result.Arrivee:= a_Bas
     else
         Result.Arrivee:= a_Haut;
end;

function TLigne.Vertical: TProgression_Trait;
begin
     Assure_Progression( FVertical);
     Result:= FVertical;
     if y1 <= y2
     then
         begin
         Result.Step:= +1;
         Result.Debut  := a_Haut;
         Result.Arrivee:= a_Bas ;
         end
     else
         begin
         Result.Step:= -1;
         Result.Debut  := a_Bas ;
         Result.Arrivee:= a_Haut;
         end
end;

{ TTrait }

constructor TTrait.Create;
begin
     Ligne       := nil;
     IsDebutLigne:= False;
     IsFinLigne  := False;
end;

destructor TTrait.Destroy;
begin

     inherited;
end;

procedure TTrait.{svg}Dessinne( DrawInfo: TDrawInfo);
var
   XGauche, XDroite, XMilieu, XLigne: Integer;
   YHaut  , YBas   , YMilieu: Integer;
   W: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   W8: Integer;//Width  div 8
   x1, y1, x2, y2: Integer;
   XBezier: Integer;
   Points: array[1..4] of TPoint;
   procedure D( x, y: Integer);
   begin
        x1:= x;
        y1:= y;
   end;
   procedure Ar( x, y: Integer);
   begin
        x2:= x;
        y2:= y;
   end;
   procedure P( Indice, _x, _y: Integer);
   begin
        with Points[ Indice]
        do
          begin
          X:= _x;
          Y:= _y;
          end;
   end;
begin
     XGauche:= DrawInfo.Rect.Left  ;
     XDroite:= DrawInfo.Rect.Right ;
     XMilieu:= (XGauche + XDroite) div 2;


     YHaut  := DrawInfo.Rect.Top   ;
     YBas   := DrawInfo.Rect.Bottom;
     YMilieu:= (YHaut + YBas) div 2;

     W := XDroite - XGauche;
     W4:= W div 4;
     W8:= W div 8;
     H4:= (YBas    - YHaut  ) div 4;

     XLigne:= XGauche+W8+Trunc( Self.a * (W-W4));//marge de W8
                                                 //a: position relative de la ligne verticale
     case Depart
     of
       a_Milieu: D(XMilieu,YMilieu);
       a_Gauche: D(XGauche,YMilieu);
       a_Haut  : D(XLigne ,YHaut  );
       a_Droite: D(XDroite,YMilieu);
       a_Bas   : D(XLigne ,YBas   );
       end;

     case Arrivee
     of
       a_Milieu: Ar( XLigne,YMilieu);
       a_Gauche: Ar(XGauche,YMilieu);
       a_Haut  : Ar(XLigne ,YHaut  );
       a_Droite: Ar(XDroite,YMilieu);
       a_Bas   : Ar(XLigne ,YBas   );
       end;

     P( 1, x1, y1);
     P( 4, x2, y2);

     //P( 2, (XMilieu+x1)div 2, (YMilieu+y1)div 2);
     //P( 3, (XMilieu+x2)div 2, (YMilieu+y2)div 2);
     if      IsDebutLigne
        and (Arrivee = a_Droite)
     then
         XBezier:= XMilieu
     else
         XBezier:= XLigne;
     P( 2, XBezier, YMilieu);
     P( 3, XBezier, YMilieu);

     DrawInfo.PolyBezier( Points);

     if IsFinLigne
     then
         begin
         //DrawInfo.MoveTo( XMilieu   , YHaut  );
         //DrawInfo.LineTo( XMilieu   , YBas-H4);
         //DrawInfo.MoveTo( XGauche+W4, YBas-H4);
         //DrawInfo.LineTo( XDroite-W4, YBas-H4);
         //DrawInfo.MoveTo( XMilieu   , YHaut+H4);
         //DrawInfo.LineTo( XMilieu   , YBas    );
         if Depart = a_Haut
         then
             begin
             DrawInfo.MoveTo( XLigne-W8, YHaut+H4);
             DrawInfo.LineTo( XLigne   , YMilieu );
             DrawInfo.LineTo( XLigne+W8, YHaut+H4);
             end
         else
             begin
             DrawInfo.MoveTo( XLigne-W8, YBas-H4);
             DrawInfo.LineTo( XLigne   , YMilieu);
             DrawInfo.LineTo( XLigne+W8, YBas-H4);
             end;
         end;
     //DrawInfo.MoveTo( x1, y1);
     //DrawInfo.LineTo( x2, y2);
end;

{ TTraits }

constructor TTraits.Create;
begin
     sl:= TBatpro_StringList.CreateE( ClassName+'.sl', TTrait);
end;

destructor TTraits.Destroy;
begin
     Free_nil( sl);
     inherited;
end;

function TTraits.Ajoute( _Ligne: TLigne; _Depart, _Arrivee: TArete): TTrait;
begin
     Result:= TTrait.Create;
     Result.Ligne  := _Ligne  ;
     Result.Depart := _Depart ;
     Result.Arrivee:= _Arrivee;
     sl.AddObject( '', Result);
end;

procedure TTraits.Dessinne( DrawInfo: TDrawInfo);
var
   T: TTrait;
   OldPenColor: TColor;
begin
     if DrawInfo.Contexte = ct_PL_SAL then exit;
     
     OldPenColor:= DrawInfo.CouleurLigne;
     DrawInfo.CouleurLigne:= clBlue;

     sl.Iterateur_Start;
     try
        while not sl.Iterateur_EOF
        do
          begin
          sl.Iterateur_Suivant( T);
          if T = nil then continue;

          T.Dessinne( DrawInfo);
          end;
     finally
            sl.Iterateur_Stop;
            end;
     DrawInfo.CouleurLigne:= OldPenColor;
end;

procedure TTraits.Vide;
begin
     Vide_StringList( sl);
end;

end.
