unit uSysteme_Solaire;

{$mode Delphi}

interface

uses
    uObservation,
    uObjets,
    uObjets_du_Systeme_Solaire,
 Classes, SysUtils;

type

    { T_Systeme_Solaire }

    T_Systeme_Solaire
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _Observation: TObservation);
       destructor Destroy; override;
     //Attributs
     private
     public
       Observation: TObservation;
       Soleil : T_Soleil;
       //Lune   : T_Lune  ;
       //Mercure: T_Planete;{T_Mercure;}
       //Venus  : T_Planete;{T_Venus;}
       //Terre  : T_Objet_du_Systeme_Solaire;{T_Terre;}
       //Mars   : T_Planete;{T_Mars;}
       //Jupiter: T_Planete;{T_Jupiter;}
       //Saturne: T_Planete;{T_Saturne;}
       //Uranus : T_Planete;{T_Uranus;}
       //Neptune: T_Planete;{T_Neptune;}
       //Pluton : T_Planete;{T_Pluton;}

       procedure Calcul;

       function GetObjet( i: Integer): T_Objet_du_Systeme_Solaire;
     end;

implementation

constructor T_Systeme_Solaire.Create( _Observation: TObservation);
begin
     inherited Create;
     Observation:= _Observation;
     Soleil := T_Soleil .Create(Observation,  0);
     //Terre  := T_Terre  .Create( Soleil,   nil, 10, tp_Persistant);
     //Lune   := T_Lune   .Create( Soleil, Terre,  1, tp_Persistant);
     //Mercure:= T_Mercure.Create( Soleil, Terre,  2, tp_Persistant);
     //Venus  := T_Venus  .Create( Soleil, Terre,  3, tp_Persistant);
     //Mars   := T_Mars   .Create( Soleil, Terre,  4, tp_Persistant);
     //Jupiter:= T_Jupiter.Create( Soleil, Terre,  5, tp_Persistant);
     //Saturne:= T_Saturne.Create( Soleil, Terre,  6, tp_Persistant);
     //Uranus := T_Uranus .Create( Soleil, Terre,  7, tp_Persistant);
     //Neptune:= T_Neptune.Create( Soleil, Terre,  8, tp_Persistant);
     //Pluton := T_Pluton .Create( Soleil, Terre,  9, tp_Persistant);
end;

procedure T_Systeme_Solaire.Calcul;
var
   I: Integer;
begin
     //Resolve_Planetary_Theory_to_use;
     Soleil.Calcul;
     //Terre .Calcul;
     //for I:= 1 to 9 do GetObjet( I).Calcul;
end;

destructor T_Systeme_Solaire.Destroy;
begin
     FreeAndNil( Soleil );
     //FreeAndNil( Lune   );
     //FreeAndNil( Mercure);
     //FreeAndNil( Venus  );
     //FreeAndNil( Mars   );
     //FreeAndNil( Terre  );
     //FreeAndNil( Jupiter);
     //FreeAndNil( Saturne);
     //FreeAndNil( Uranus );
     //FreeAndNil( Neptune);
     //FreeAndNil( Pluton );

     inherited Destroy;
end;

function T_Systeme_Solaire.GetObjet(i: Integer): T_Objet_du_Systeme_Solaire;
begin
     case i
     of
       0:   GetObjet:= Soleil ;
       //1:   GetObjet:= Lune   ;
       //2:   GetObjet:= Mercure;
       //3:   GetObjet:= Venus  ;
       //4:   GetObjet:= Mars   ;
       //5:   GetObjet:= Jupiter;
       //6:   GetObjet:= Saturne;
       //7:   GetObjet:= Uranus ;
       //8:   GetObjet:= Neptune;
       //9:   GetObjet:= Pluton ;
       //10:  GetObjet:= Terre  ;
       else GetObjet:= Soleil ; {pour le cas où...}
       end;
end;

end.

