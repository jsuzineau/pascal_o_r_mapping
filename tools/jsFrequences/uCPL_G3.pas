unit uCPL_G3;

{$mode delphi}

interface

uses
 Classes, SysUtils,uFrequence,uFrequences;

const
  CPL_G3_NbPorteuses= 36;
  CPL_G3_Min=35938;{Hz}
  CPL_G3_Max=90625;{Hz}
  CPL_G3_Espacement=1562.5;{Hz}
type
 { TCPL_G3 }

 TCPL_G3
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //F
  public
    F: array of double;
    procedure Calcule_F;
    function Liste: String;
  end;

function CPL_G3: TCPL_G3;

implementation

var
   FCPL_G3: TCPL_G3= nil;

function CPL_G3: TCPL_G3;
begin
     if nil = FCPL_G3
     then
         FCPL_G3:= TCPL_G3.Create;
     Result:= FCPL_G3;
end;

{ TCPL_G3 }

constructor TCPL_G3.Create;
begin
     Calcule_F;
end;

destructor TCPL_G3.Destroy;
begin
     inherited Destroy;
end;

procedure TCPL_G3.Calcule_F;
var
   I: Integer;
begin
     SetLength( F, CPL_G3_NbPorteuses);
     for I:= Low(F) to High(F)
     do
       F[I]:=CPL_G3_Min+ I*CPL_G3_Espacement;
end;

function TCPL_G3.Liste: String;
var
   I: Integer;
   NbCoherent, NbDeCoherent, NbNeutre: Integer;
   function sNb( _Nb: Integer; _S: String): String;
   var
      dPourcent: double;
   begin
        dPourcent:= (_Nb/CPL_G3_NbPorteuses)*100;
        Result:= IntToStr(_Nb)+_S+' soit '+FloatToStr( dPourcent)+'% '#13#10
   end;
begin
     NbCoherent  := 0;
     NbDeCoherent:= 0;
     Result:= 'Fréquences porteuses CPL G3';
     for I:= Low(F) to High(F)
     do
       Result:= Result+#13#10+ IntToStr(I+1)+': '+uFrequence.sFrequence( F[I])+' '+Frequences.sMatch( 7, F[I], NbCoherent, NbDeCoherent);
     NbNeutre:= CPL_G3_NbPorteuses-NbCoherent-NbDeCoherent;

     Result
     :=
        Result+#13#10
       +sNb( NbCoherent  , ' fréquences cohérentes'  )
       +sNb( NbDeCoherent, ' fréquences décohérentes')
       +sNb( NbNeutre    , ' fréquences neutres'     );
end;

{ TCPL_G3 }


{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FCPL_G3);
{$endif}
end.

