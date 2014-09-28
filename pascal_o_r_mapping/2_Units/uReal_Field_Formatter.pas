unit uReal_Field_Formatter;
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
    uForms,
    u_sys_,
    uDataUtilsU,
  SysUtils, Classes, DB;

type
 Trff_Format= ( rff_ee, rff_eee, rff_00, rff_000, rff_00ee);
 TReal_Field_Formatter
 =
  class
  private
    F: TField;
    FF_DisplayFormat: String;
    FF_Value: Double;
    FF_Currency: Boolean;
    Frff_Format: Trff_Format;
    Precision: Integer;
    Texte: String;
    procedure Setrff_Format( Value: Trff_Format);
    procedure Espaces_from_Zeros;
    procedure FGetText( Sender:TField; var Text:String; DisplayText:Boolean);
  protected
    constructor Create( _F: TField; _rff_Format: Trff_Format);
    procedure FF_Values_from_Field; virtual; abstract;
  public
    destructor Destroy; override;
    property rff_Format: Trff_Format read Frff_Format write Setrff_Format;
  end;

 TrffFloat
 =
  class( TReal_Field_Formatter)
  private
    FF: TFloatField;
  protected
    procedure FF_Values_from_Field; override;
  public
    constructor Create( _FF: TFloatField; _rff_Format: Trff_Format);
  end;

 TrffAggregate
 =
  class( TReal_Field_Formatter)
  private
    (*AF: TAggregateField;*)
  protected
    procedure FF_Values_from_Field; override;
  public
    (*constructor Create( _AF: TAggregateField; _rff_Format: Trff_Format);*)
  end;

 TrffBCD
 =
  class( TReal_Field_Formatter)
  private
    BCDF: TBCDField;
  protected
    procedure FF_Values_from_Field; override;
  public
    constructor Create( _BCDF: TBCDField; _rff_Format: Trff_Format);
  end;

 TrffFMTBCD
 =
  class( TReal_Field_Formatter)
  private
    FMTBCDF: TFMTBCDField;
  protected
    procedure FF_Values_from_Field; override;
  public
    constructor Create( _FMTBCDF: TFMTBCDField; _rff_Format: Trff_Format);
  end;

function Create_rff_from_Field( F: TField; rff_Format: Trff_Format): TReal_Field_Formatter;

//pour mémoire pendant la modification
//procedure Format_FloatField_0_000( Sender: TField; var Text: String);
//procedure Format_FloatField_0_00 ( Sender: TField; var Text: String);
//procedure Format_FloatField_0    ( Sender: TField; var Text: String);
//procedure Format_FloatField( Sender: TField; var Text: String; Tronque: Boolean;
//                             Precision_par_defaut: Integer);
//begin
//end;
//
//procedure Format_FloatField_0_000( Sender: TField; var Text: String);
//begin
//     Format_FloatField( Sender, Text, False, 3);
//end;
//
//procedure Format_FloatField_0_00( Sender: TField; var Text: String);
//begin
//     Format_FloatField( Sender, Text, False, 2);
//end;
//
//procedure Format_FloatField_0   ( Sender: TField; var Text: String);
//begin
//     Format_FloatField( Sender, Text, True, 2);
//end;


implementation

function Create_rff_from_Field( F: TField; rff_Format: Trff_Format): TReal_Field_Formatter;
begin
     (*if F is TAggregateField then Result:= TrffAggregate.Create( TAggregateField(F), rff_Format)
else *)if F is TFloatField     then Result:= TrffFloat    .Create( TFloatField    (F), rff_Format)
else if F is TBCDField       then Result:= TrffBCD      .Create( TBCDField      (F), rff_Format)
else if F is TFMTBCDField    then Result:= TrffFMTBCD   .Create( TFMTBCDField   (F), rff_Format)
else                              Result:= nil;
end;

{ TReal_Field_Formatter }

constructor TReal_Field_Formatter.Create( _F: TField; _rff_Format: Trff_Format);
begin
     F         := _F        ;
     rff_Format:= _rff_Format;

     if Assigned( F.OnGetText)
     then
         uForms_ShowMessage( 'Erreur à signaler au développeur:'+sys_N+
                      '  TReal_Field_Formatter.Create'+sys_N+
                      '  '+F.Name+'.OnGetText <> nil');
     F.OnGetText:= FGetText;
end;

destructor TReal_Field_Formatter.Destroy;
begin
     F.OnGetText:= nil;
     inherited;
end;

procedure TReal_Field_Formatter.Setrff_Format( Value: Trff_Format);
begin
     Frff_Format:= Value;
     case Frff_Format
     of
       rff_ee  : Precision:= 2;
       rff_eee : Precision:= 3;
       rff_00  : Precision:= 2;
       rff_000 : Precision:= 3;
       rff_00ee: Precision:= 4;
       else      Precision:= 2;
       end;
end;

procedure TReal_Field_Formatter.FGetText( Sender: TField; var Text: String;
                                          DisplayText: Boolean);
begin
     FF_Values_from_Field;
     Espaces_from_Zeros;
     Text:= Texte;
end;

procedure TReal_Field_Formatter.Espaces_from_Zeros;
var
   I, IVirgule: Integer;
   sPrecision: String;
   DisplayFormat: String;

   function Zero: Boolean;
   begin
        //chaine vide
        Result:= I > 0;
        if not Result then exit;

        Result:= Texte[I] = '0';
   end;
   function Valeur_Zero: Boolean; //'  0   '
   begin
        Result:= Zero;
        if not Result then exit;

        // on ne prend que les cas '0', '+0', '-0', ' 0'
        Result:= (I=1) or (Texte[I-1] in ['+','-',' ']);
   end;
   function Virgule: Boolean;
   begin
        //chaine vide
        Result:= I > 0;
        if not Result then exit;

        //Virgule
        Result:= Texte[I] = DecimalSeparator;
   end;
   procedure Espace_Precedent;
   begin
        Texte[I]:= ' ';
        Dec( I);
   end;
   function Arrondi_a_zero: Boolean;
   var
      J, L: Integer;
      TJ: Char;
   begin
        L:= Length( Texte);
        Result:= True;
        J:= 1;
        while (J <= L) and Result
        do
          begin
          TJ:= Texte[J];
          Result:= (TJ in ['+','-',' ','0']) or (TJ = DecimalSeparator);
          Inc(J);
          end;
   end;
begin
     if FF_Value = 0
     then
         begin
         Texte:= ' ';
         exit;
         end;

     sPrecision:= StringOfChar('0',Precision);

     DisplayFormat:= FF_DisplayFormat;
     if DisplayFormat = sys_Vide
     then
         DisplayFormat:= '###,###,###,##0.'+sPrecision;

     Texte:= FormatFloat( DisplayFormat, FF_Value);
     I            := Length(Texte);
     IVirgule     := Pos( DecimalSeparator           , Texte);

     if IVirgule > 0 //pas de tronquage
     then            //si pas de virgule
         case rff_Format
         of
           rff_ee, rff_eee:
             begin
             while Zero do   Espace_Precedent; //Suppression des 0
             if Virgule then Espace_Precedent; //Suppression virgule orpheline
             if Valeur_Zero then Texte:= ' ';  // cas valeur arrondie à 0
             end;
           rff_00,
           rff_000:
             if Arrondi_a_zero then Texte:= ' '; // cas valeur arrondie à 0
           rff_00ee:
             begin
             while Zero and(I>IVirgule+2)do Espace_Precedent;//Suppression des 0
             if Virgule then Espace_Precedent; //Suppression virgule orpheline
             if Arrondi_a_zero then Texte:= ' '; // cas valeur arrondie à 0
             end;
           end;

end;

{ TrffFloat }
constructor TrffFloat.Create( _FF: TFloatField; _rff_Format: Trff_Format);
begin
     FF:= _FF;
     inherited Create( FF, _rff_Format);
end;

procedure TrffFloat.FF_Values_from_Field;
begin
     FF_DisplayFormat:= FF.DisplayFormat;
     FF_Value        := FF.Value        ;
     FF_Currency     := FF.Currency     ;
end;

{ TrffAggregate }

(*constructor TrffAggregate.Create( _AF: TAggregateField; _rff_Format: Trff_Format);
begin
     AF:= _AF;
     inherited Create( AF, _rff_Format);
end;*)

procedure TrffAggregate.FF_Values_from_Field;
begin
     (*FF_DisplayFormat:= AF.DisplayFormat;
     FF_Value        := AF.Value        ;
     FF_Currency     := AF.Currency     ;*)
end;

{ TrffBCD }

constructor TrffBCD.Create( _BCDF: TBCDField; _rff_Format: Trff_Format);
begin
     BCDF:= _BCDF;
     inherited Create( BCDF, _rff_Format);
end;

procedure TrffBCD.FF_Values_from_Field;
begin
     FF_DisplayFormat:= BCDF.DisplayFormat;
     FF_Value        := BCDF.Value        ;
     FF_Currency     := BCDF.Currency     ;
end;

{ TrffFMTBCD }

constructor TrffFMTBCD.Create( _FMTBCDF: TFMTBCDField; _rff_Format:Trff_Format);
begin
     FMTBCDF:= _FMTBCDF;
     inherited Create( FMTBCDF, _rff_Format);
end;

procedure TrffFMTBCD.FF_Values_from_Field;
begin
     FF_DisplayFormat:= FMTBCDF.DisplayFormat;
     FF_Value        := FMTBCDF.AsFloat      ;
     FF_Currency     := FMTBCDF.Currency     ;
end;

end.
