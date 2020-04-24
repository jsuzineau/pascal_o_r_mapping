unit uFrequences;

{$mode delphi}

interface

uses
    uFrequence,
 Classes, SysUtils, Math, Types;

const
  uFrequences_coherent: array of double= (256, 269.8, 288, 303.1, 324, 341.2, 364.7, 384, 404.5, 432, 455.1, 486);
  uFrequences_decoherent: array of double= (249.4, 262.8, 278.8, 295.5, 313.4, 332.5, 352.8, 374.3, 394.1, 418.0, 443.2, 470.3);
  uFrequences_band_half_width=0.85;{%}
  uFrequences_Bas_factor =(1-(uFrequences_band_half_width/100));
  uFrequences_Haut_factor=(1+(uFrequences_band_half_width/100));


type

 { TFrequences }

 TFrequences
 =
  class

  //Affichage de l'harmonique d'une fréquence
  public
    function sFrequence( _Octave: Integer; _Base: double): String;

    function aCoherent_boundaries( _Octave: Integer): TDoubleDynArray;
    function aDeCoherent_boundaries( _Octave: Integer): TDoubleDynArray;
    function aCoherent_centers( _Octave: Integer): TDoubleDynArray;
    function aDeCoherent_centers( _Octave: Integer): TDoubleDynArray;
    function Liste( _Octave: Integer): String;

    function Liste_from_Frequence( _Frequence: double): String;

    function Match_Base( _Octave: Integer; _Base: double; _Frequence: double; _Prefixe: String; var _Nb: Integer): String;
    function sMatch( _Octave: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
    function Octave_from_Frequence( _Frequence: double): Integer;
  private
    function Harmonique( _Frequence: double; _Octave: Integer): double;
    function Frequence_in_Octave( _Frequence: double; _Octave: Integer): Boolean;
  end;

function Frequences: TFrequences;

function uFrequences_Min: double;
function uFrequences_Max: double;

implementation

function uFrequences_Min: double;
begin
     Result:= uFrequences_decoherent[0];
end;

function uFrequences_Max: double;
begin
     Result:= uFrequences_coherent[High(uFrequences_coherent)];
end;

var
   FFrequences: TFrequences= nil;

function Frequences: TFrequences;
begin
     if nil = FFrequences
     then
         FFrequences:= TFrequences.Create;
     Result:= FFrequences;
end;

{ TFrequences }

function TFrequences.Harmonique( _Frequence: double; _Octave: Integer): double;
begin
     Result:= _Frequence*(2**_Octave)
end;

function TFrequences.sFrequence(_Octave: Integer; _Base: double): String;
var
   Frequence, Bas, Haut: double;
begin
     Frequence:= Harmonique( _Base, _Octave);
     Bas := Frequence*uFrequences_Bas_factor;
     Haut:= Frequence*uFrequences_Haut_factor;
     //Result:= uFrequence.sFrequence( Frequence);
     Result:= uFrequence.sFrequence( Bas)+' / '+uFrequence.sFrequence( Frequence)+' / '+uFrequence.sFrequence( Haut);
end;

function TFrequences.aCoherent_boundaries(_Octave: Integer): TDoubleDynArray;
var
   I: Integer;
   procedure Traite_Frequence;
   var
      Frequence, Bas, Haut: double;
   begin
        Frequence:= Harmonique( uFrequences_coherent[I], _Octave);
        Bas := Frequence*uFrequences_Bas_factor;
        Haut:= Frequence*uFrequences_Haut_factor;
        Result[2*I+0]:= Bas;
        Result[2*I+1]:= Haut;
   end;
begin
     SetLength( Result, 2*Length(uFrequences_coherent));
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Traite_Frequence;
end;

function TFrequences.aDeCoherent_boundaries(_Octave: Integer): TDoubleDynArray;
var
   I: Integer;
   procedure Traite_Frequence;
   var
      Frequence, Bas, Haut: double;
   begin
        Frequence:= Harmonique( uFrequences_decoherent[I], _Octave);
        Bas := Frequence*uFrequences_Bas_factor;
        Haut:= Frequence*uFrequences_Haut_factor;
        Result[2*I+0]:= Bas;
        Result[2*I+1]:= Haut;
   end;
begin
     SetLength( Result, 2*Length(uFrequences_decoherent));
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Traite_Frequence;
end;

function TFrequences.aCoherent_centers(_Octave: Integer): TDoubleDynArray;
var
   I: Integer;
begin
     SetLength( Result, Length(uFrequences_coherent));
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result[I]:= Harmonique( uFrequences_coherent[I], _Octave);
end;

function TFrequences.aDeCoherent_centers(_Octave: Integer): TDoubleDynArray;
var
   I: Integer;
begin
     SetLength( Result, Length(uFrequences_decoherent));
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result[I]:= Harmonique( uFrequences_decoherent[I], _Octave);
end;

function TFrequences.Liste( _Octave: Integer): String;
var
   I: Integer;
begin
     Result:= 'Octave: '+IntToStr(_Octave)+uFrequence_Separateur_Lignes+'Fréquences cohérentes';
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave, uFrequences_coherent[I]);
     (*
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave+1, uFrequences_coherent[I]);
     *)

     Result:= Result+uFrequence_Separateur_Lignes+ 'Fréquences décohérentes';
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave, uFrequences_decoherent[I]);
     (*
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave+1, uFrequences_decoherent[I]);
     *)
end;

function TFrequences.Match_Base(_Octave: Integer; _Base: double; _Frequence: double; _Prefixe: String; var _Nb: Integer): String;
var
   F, Bas, Haut: double;
begin
     F:= Harmonique( _Base, _Octave);
     Bas := F*uFrequences_Bas_factor;
     Haut:= F*uFrequences_Haut_factor;
     if (Bas <= _Frequence) and (_Frequence <= Haut)
     then
         begin
         Result:= _Prefixe+' '+ sFrequence( _Octave, _Base);
         Inc( _Nb);
         end
     else
         Result:= '';
end;

function TFrequences.sMatch(_Octave: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
var
   I: Integer;
begin
     Result:= '';
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _Octave, uFrequences_coherent[I], _Frequence, 'cohérent', _NbCoherent);
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _Octave+1, uFrequences_coherent[I], _Frequence, 'cohérent', _NbCoherent);

     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _Octave, uFrequences_decoherent[I], _Frequence, 'décohérent', _NbDeCoherent);
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _Octave+1, uFrequences_decoherent[I], _Frequence, 'décohérent', _NbDeCoherent);
end;

function TFrequences.Octave_from_Frequence(_Frequence: double): Integer;
begin
     if _Frequence > uFrequences_Min
     then
         Result:= Trunc( Log2(_Frequence/uFrequences_Min))
     else
         Result:= -Trunc( Log2(uFrequences_Max/_Frequence));
end;

function TFrequences.Frequence_in_Octave(_Frequence: double; _Octave: Integer): Boolean;
var
   Bas, Haut: double;
begin
     Bas := Harmonique( uFrequences_Min, _Octave);
     Haut:= Harmonique( uFrequences_Max, _Octave);
     Result:= (Bas <= _Frequence)and(_Frequence<= Haut);
end;

function TFrequences.Liste_from_Frequence(_Frequence: double): String;
var
   Octave: Integer;
begin
     Octave:= Octave_from_Frequence( _Frequence);
     Result
     :=
        'Fréquence: '+uFrequence.sFrequence( _Frequence)+uFrequence_Separateur_Lignes
       + Liste( Octave);
end;

{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FFrequences);
{$endif}
end.

