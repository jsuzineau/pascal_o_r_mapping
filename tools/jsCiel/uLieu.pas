unit uLieu;

{$mode Delphi}

interface

uses
    uPublieur,
    uuStrings,
    uCoordonnee,
 Classes, SysUtils, Math;

type
  { TLieu}
  TLieu
  =
   class
   {Penser à modifier Copy_From si rajout de champs (utilisation de Move)}
   private {Ceci empêche de modifier directement les champs sans mise à jour}
           {globale, ce qui peut être source de bogues difficiles à déceler.}
           {ce qui suit dans cette déclaration n"est accessible que dans les}
           { routines de cette unité.(=déclaration en partie IMPLEMENTATION.}
     Lieu_Courant   : String;
     FDecalage_Heure_Ete: Real;
     FDecalage_Heure_Locale: Real;
     Latitude, Longitude: T_Coordonnee;
     Edition: Boolean;
     procedure Coordonnee_Change;
   public
     ModifyCoordonnees: TPublieur;
     ModifyLieu: TPublieur;
     constructor Create;
     destructor  Destroy; override;

     procedure Debut_Edition;
     procedure Fin_Edition;

     procedure Copy_From( _Lieu: TLieu);

     property Lieu   : String  read Lieu_Courant        ;
     property Decalage_Heure_Locale: Real    read FDecalage_Heure_Locale write FDecalage_Heure_Locale;
     property Decalage_Heure_Ete   : Real    read FDecalage_Heure_Ete    write FDecalage_Heure_Ete;
     property La: T_Coordonnee read Latitude;
     property Lg: T_Coordonnee read Longitude;
     property Edition_en_cours: Boolean read Edition;

     procedure Nouveau( NomLieu: String);
     procedure SetToLieuNul;
     procedure Log(_Prefix: String);
   end;



implementation

{ TLieu }

constructor TLieu.Create;
begin
     Edition:= False;
     Latitude := T_Coordonnee.Create( True );
     Longitude:= T_Coordonnee.Create( False);
     Latitude. Longitude_from_LatitudeOverflow:= Longitude.Retournement_Longitude;

     Latitude .Modify.Abonne( Self, Coordonnee_Change);
     Longitude.Modify.Abonne( Self, Coordonnee_Change);

     ModifyCoordonnees:= TPublieur.Create(ClassName+'.ModifyCoordonnees');
     ModifyLieu       := TPublieur.Create(ClassName+'.ModifyLieu'       );
end;

destructor  TLieu.Destroy;
begin
     Latitude .Modify.Desabonne( Self, Coordonnee_Change);
     Longitude.Modify.Desabonne( Self, Coordonnee_Change);

     FreeAndNil( Latitude         );
     FreeAndNil( Longitude        );

     FreeAndNil( ModifyCoordonnees);
     FreeAndNil( ModifyLieu       );

     inherited Destroy;
end;

procedure TLieu.SetToLieuNul;
var Result: Integer;
begin
     Lieu_Courant:= 'Lieu non répertorié';
     Edition:= True;
     try
        // Le 1 est rajouté pour éviter une confusion avec l'état initial
        // mémoire à 0.
        Result:= 10*Latitude .Set_To( 1, 0, 0, 0);

        Result:= Result + Longitude.Set_To( 1, 0, 0, 0);
        FDecalage_Heure_Locale:= 0;
        FDecalage_Heure_Ete:= 0;
        if Result = 0
        then
            begin
            ModifyCoordonnees.Publie;
            ModifyLieu       .Publie;
            end;
     finally
            Edition:= False;
            end;
end;

procedure TLieu.Copy_From( _Lieu: TLieu);
begin
     if _Lieu <> NIL
     then
         begin
         Lieu_courant          := _Lieu.Lieu_courant          ;
         FDecalage_Heure_Ete   := _Lieu.FDecalage_Heure_Ete   ;
         FDecalage_Heure_Locale:= _Lieu.FDecalage_Heure_Locale;
         Latitude .Copy_From( _Lieu.Latitude );
         Longitude.Copy_From( _Lieu.Longitude);
         end;
end;

procedure TLieu.Coordonnee_Change;
begin
     if Edition
     then
     else
         begin
         Lieu_Courant:= 'Lieu non répertorié';
         ModifyCoordonnees.Publie;
         ModifyLieu.Publie;
         end;
end;

procedure TLieu.Debut_Edition;
begin
     Edition:= True;
end;

procedure TLieu.Fin_Edition;
begin
     Edition:= False;
end;

procedure TLieu.Nouveau( NomLieu: String);
begin
     Lieu_Courant:= NomLieu;
     Latitude.Nouveau;
     Longitude.Nouveau;
end;

procedure TLieu.Log( _Prefix: String);
begin
     WriteLn( _Prefix+'latitude:', latitude.Str, ' longitude:',longitude.Str);
end;

end.

