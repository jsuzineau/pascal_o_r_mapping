unit uFrequences;

{$mode delphi}

interface

uses
 Classes, SysUtils,uFrequence;

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
    function sFrequence( _OctaveFactor: Integer; _Base: double): String;
    function Liste( _OctaveFactor: Integer): String;
    function Match_Base( _OctaveFactor: Integer; _Base: double; _Frequence: double; _Prefixe: String; var _Nb: Integer): String;
    function sMatch( _OctaveFactor: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
  end;

function Frequences: TFrequences;

implementation

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

function TFrequences.sFrequence(_OctaveFactor: Integer; _Base: double): String;
var
   Frequence, Bas, Haut: double;
begin
     Frequence:= _Base*(2**_OctaveFactor);
     Bas := Frequence*uFrequences_Bas_factor;
     Haut:= Frequence*uFrequences_Haut_factor;
     //Result:= uFrequence.sFrequence( Frequence);
     Result:= uFrequence.sFrequence( Bas)+' - '+uFrequence.sFrequence( Haut);
end;

function TFrequences.Liste( _OctaveFactor: Integer): String;
var
   I: Integer;
begin
     Result:= 'Fréquences cohérentes';
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+'<br>'+ sFrequence( _OctaveFactor, uFrequences_coherent[I]);
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+'<br>'+ sFrequence( _OctaveFactor+1, uFrequences_coherent[I]);

     Result:= Result+'<br>'+ 'Fréquences décohérentes';
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+'<br>'+ sFrequence( _OctaveFactor, uFrequences_decoherent[I]);
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+'<br>'+ sFrequence( _OctaveFactor+1, uFrequences_decoherent[I]);
end;

function TFrequences.Match_Base(_OctaveFactor: Integer; _Base: double; _Frequence: double; _Prefixe: String; var _Nb: Integer): String;
var
   F, Bas, Haut: double;
begin
     F:= _Base*(2**_OctaveFactor);
     Bas := F*uFrequences_Bas_factor;
     Haut:= F*uFrequences_Haut_factor;
     if (Bas <= _Frequence) and (_Frequence <= Haut)
     then
         begin
         Result:= _Prefixe+' '+ sFrequence( _OctaveFactor, _Base);
         Inc( _Nb);
         end
     else
         Result:= '';
end;

function TFrequences.sMatch(_OctaveFactor: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
var
   I: Integer;
begin
     Result:= '';
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _OctaveFactor, uFrequences_coherent[I], _Frequence, 'cohérent', _NbCoherent);
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _OctaveFactor+1, uFrequences_coherent[I], _Frequence, 'cohérent', _NbCoherent);

     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _OctaveFactor, uFrequences_decoherent[I], _Frequence, 'décohérent', _NbDeCoherent);
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _OctaveFactor+1, uFrequences_decoherent[I], _Frequence, 'décohérent', _NbDeCoherent);
end;

{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FFrequences);
{$endif}
end.

