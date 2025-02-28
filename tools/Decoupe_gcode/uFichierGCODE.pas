unit uFichierGCODE;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
 Classes, SysUtils,math,strutils;
type

 { TG1_Z }

 TG1_Z
 =
  class
  public
    constructor Create;
    destructor Destroy; override;
  //Index
  public
    Index: Integer;
  //Z
  public
    sZ: String;
    Z: double;
    Erreur: Integer;
    procedure DecodeZ;
  end;


 { TFichierGCODE }

 TFichierGCODE
 =
  class
  public
    constructor Create;
    destructor Destroy; override;
  public
    NomFichier: String;
  public
    S: String;
  public
    procedure Charge( _NomFichier: String);
  //Montées
  public
    Montees: array of TG1_Z;
    procedure Parse;
  public
    function Cherche( _Commande: String): Integer;
    function Cherche_Reverse( _Commande: String): Integer;
  //Fin de ligne
  public
    Fin_Ligne: String;
    function sFin_Ligne: String;
  //START_GCODE
  public
    Fin_START_GCODE: Integer;
    function sSTART_GCODE: String;
  //Début première couche
  public
    Montee_Premiere_Couche: Integer;
    Premiere_Couche: Integer;
  //END_GCODE
  public
    Debut_END_GCODE: Integer;
    function sEND_GCODE: String;
  //Header
  public
    function Header( _Premier_Fichier: Boolean):String;
  //Footer
  public
    function Footer:String;
  //fin de la Ligne à partir d'un index
  public
    function Ligne( _Index: Integer): String;
  //Découpage en plusieurs fichiers
  public
    procedure Decoupe( _Nb: Integer);
  private
    procedure Tranche( _NumeroFichier: Integer; _Debut, _NbCouches: Integer);
  //Variables
  public
    slVariables: TStringList;
  end;


implementation

{ TG1_Z }

constructor TG1_Z.Create;
begin

end;

destructor TG1_Z.Destroy;
begin
     inherited Destroy;
end;

procedure TG1_Z.DecodeZ;
begin
     Val( sZ, Z, Erreur);
end;

{ TFichierGCODE }

constructor TFichierGCODE.Create;
begin
     slVariables:= TStringList.Create;

     NomFichier:= '';
     S:= '';
     SetLength( Montees, 0);
end;

destructor TFichierGCODE.Destroy;
begin
     FreeAndNil( slVariables);
     inherited Destroy;
end;

procedure TFichierGCODE.Charge(_NomFichier: String);
begin
     NomFichier:= _NomFichier;
     S:= String_from_File( NomFichier);
     Parse;
end;

procedure TFichierGCODE.Parse;
var
   Longueur_S: Integer;
   I, J: Integer;
   C: Char;
   FinLigne, DebutLigne: Boolean;
   function Suivant: Char;
   begin
        Result:= #0;

        Inc(J);
        if J > Longueur_S then exit;

        Result:= S[J];
   end;
   procedure Traite_Fin_Ligne;
   var
      D: Char;
   begin
        FinLigne:= True;
        if '' <> Fin_Ligne then exit;
        Fin_Ligne:= C;
        repeat
              D:= Suivant;
              if not (D in [#13, #10]) then break;
              Fin_Ligne:= Fin_Ligne+D;
        until J>=Longueur_S;

   end;
   procedure Cree_Montee;
   var
      D: Char;
      G1_Z: TG1_Z;
   begin
        G1_Z:= TG1_Z.Create;
        G1_Z.Index:= I;
        SetLength( Montees, Length(Montees)+1);
        Montees[High(Montees)]:= G1_Z;
        I:= J;
        repeat
              D:= Suivant;
              G1_Z.sZ:= G1_Z.sZ+D;
        until (D=' ') or (J>=Longueur_S);
        I:= J;
        G1_Z.DecodeZ;
   end;
   procedure Traite_G;
   begin
        //G1 Z
        if    (Suivant = '1')
           and(Suivant = ' ')
           and(Suivant = 'Z')
        then
            Cree_Montee;
   end;
   procedure Traite_Variable;
   var
      D: Char;
      sLigne: String;
      Key, Value: String;
   begin
        sLigne:= '';
        repeat
              D:= Suivant;
              if D in [#13, #10, #0] then break;
              sLigne:= sLigne+D;
        until J>=Longueur_S;
        I:= J-1;
        Key  := Trim(StrToK('=', sLigne));
        if '' = Key then exit;

        Delete(sLigne, 1, 1);
        Value:= sLigne;
        slVariables.Values[Key]:= Value;
   end;
   procedure Trouve_Fin_START_GCODE;
   var
      Commande: String;
      Debut_START_GCODE: Integer;
   begin
        Commande:= sSTART_GCODE;
        Debut_START_GCODE:= Cherche( Commande);
        if 0 = Debut_START_GCODE
        then
            Fin_START_GCODE:= 0
        else
            Fin_START_GCODE:= Debut_START_GCODE+Length(Commande);
   end;
   procedure Trouve_Premiere_Couche;
   var
      K: Integer;
      G1_Z: TG1_Z;
   begin
        Montee_Premiere_Couche:= 0;
        Premiere_Couche:= 1;
        for K:= Low( Montees) to High(Montees)
        do
          begin
          G1_Z:= Montees[K];
          if G1_Z.Index > Fin_START_GCODE
          then
              begin
              Montee_Premiere_Couche:= K;
              Premiere_Couche:= G1_Z.Index;
              break;
              end;
          end;
   end;
   procedure Trouve_Debut_END_GCODE;
   var
      Commande: String;
   begin
        Commande:= sEND_GCODE;
        Debut_END_GCODE:= Cherche( Commande);
   end;
begin
     Fin_Ligne:= '';

     for I:= Low(Montees) to High(Montees) do FreeAndNil( Montees[I]);
     SetLength( Montees, 0);

     I:= 0;
     DebutLigne:= False;
     FinLigne:= True;
     Longueur_S:= Length(S);
     while I< Longueur_S
     do
       begin
       Inc(I);
       C:= S[I];
       if C in [#13, #10]
       then
           Traite_Fin_Ligne
       else
           begin
           DebutLigne:= FinLigne;
           FinLigne:= False;
           end;
       if FinLigne then continue;
       if not DebutLigne then continue;

       DebutLigne:= False;
       J:= I;

            if 'G' = C then Traite_G
       else if ';' = C then Traite_Variable;
       end;

     Trouve_Fin_START_GCODE;
     Trouve_Debut_END_GCODE;
     Trouve_Premiere_Couche;
end;

function TFichierGCODE.Cherche( _Commande: String): Integer;
begin
     Result:= Pos( _Commande, S);
end;

function TFichierGCODE.Cherche_Reverse(_Commande: String): Integer;
var
   Longueur_S: Integer;
   I, J: Integer;
   C: Char;
   function Suivant: Char;
   begin
        Result:= #0;

        Inc(J);
        if J > Longueur_S then exit;

        Result:= S[J];
   end;
   function Match_Commande: Boolean;
   var
      K: Integer;
   begin
        Result:= False;
        for K:= 1 to Length( _Commande)
        do
          if Suivant <> _Commande[K] then exit;
        Result:= True;
   end;
begin
     Result:= 0;
     Longueur_S:= Length(S);
     I:= Longueur_S+1;
     while I > 0
     do
       begin
       Dec(I);
       C:= S[I];
       if not (C in [#13, #10]) then continue;
       J:= I;
       if Match_Commande
       then
           begin
           Result:= I+1;
           break;
           end;
       end;
end;

function TFichierGCODE.sFin_Ligne: String;
var
   I: Integer;
begin
     Result:= '';
     for I:= 1 to Length( Fin_Ligne)
     do
       Result:= Result+'#'+IntToStr(Ord(Fin_Ligne[I]));
end;

function TFichierGCODE.sSTART_GCODE: String;
begin
     Result:= StringsReplace( slVariables.Values['start_gcode'], ['\n'], [Fin_Ligne], [rfReplaceAll]);
end;

function TFichierGCODE.sEND_GCODE: String;
begin
     Result:= StringsReplace( slVariables.Values['end_gcode'], ['\n'], [Fin_Ligne], [rfReplaceAll]);
end;

function TFichierGCODE.Header( _Premier_Fichier: Boolean):String;
begin

     Result:= '';
     if Premiere_Couche <= 1 then exit;

     Result:= Copy(S, 1, Premiere_Couche-1);
     if not _Premier_Fichier
     then
         //lit chauffant que sur la première impression
         Result:= StringReplace( Result, 'M190 S', ';M190 S', [rfReplaceAll]);
end;

function TFichierGCODE.Footer: String;
begin
     Result:= '';
     if Debut_END_GCODE = 0 then exit;

     Result:= Copy(S, Debut_END_GCODE, Length(S));
end;

function TFichierGCODE.Ligne(_Index: Integer): String;
var
   Longueur_S: Integer;
   I: Integer;
   Longueur: Integer;
begin
     Longueur_S:= Length( S);
     I:= _Index;
     while I < Longueur_S
     do
       begin
       if S[I] in [#13, #10] then break;
       Inc(I);
       end;
     Longueur:= I-_Index;
     Result:= Copy( S, _Index, Longueur)+Fin_Ligne;
end;

procedure TFichierGCODE.Decoupe( _Nb: Integer);
var
   NbCouches_par_fichier: Integer;
   I: Integer;
   iMontees: Integer;
begin
     NbCouches_par_fichier:= Trunc( ceil((Length( Montees)-Montee_Premiere_Couche) / _Nb));
     iMontees:= Montee_Premiere_Couche;
     for I:= 1 to _Nb
     do
       begin
       Tranche( I, iMontees, NbCouches_par_fichier);
       Inc(iMontees, NbCouches_par_fichier);
       end;
end;

procedure TFichierGCODE.Tranche( _NumeroFichier: Integer; _Debut, _NbCouches: Integer);
var
   Fin: Integer;
   IndexDebut, IndexFin: Integer;
   sTranche: String;
   NomTranche: String;
begin
     Fin:= _Debut+_NbCouches;
     if Fin>High( Montees) then Fin:= -1;

     IndexDebut:= Montees[_Debut].Index;
     if Fin = -1
     then
         IndexFin:= Debut_END_GCODE-1
     else
         IndexFin:= Montees[Fin].Index-1;

     sTranche
     :=
        Header( 1 = _NumeroFichier)
       +Copy( S, IndexDebut, IndexFin-IndexDebut+1)
       +'; '+Ligne(IndexFin+1)
       +Footer;

     NomTranche
     :=
        ChangeFileExt(NomFichier,'')
       +'_'+IntToStr( _NumeroFichier)
       +ExtractFileExt(NomFichier);
     String_to_File( NomTranche, sTranche);
end;

end.

