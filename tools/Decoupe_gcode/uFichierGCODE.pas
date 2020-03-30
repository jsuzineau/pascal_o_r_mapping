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
    function Extrait_Ligne( _Debut_Ligne: Integer): String;
    function nExtrait_Ligne( _Debut_Ligne: Integer): String;
  //Montées
  public
    Montees: array of TG1_Z;
    procedure Parse;
    function sMontees: String;
  public
    function Cherche( _Commande: String): Integer;
    function Cherche_Reverse( _Commande: String): Integer;
  //Couches
  public
    Couches: array of TG1_Z;
    function sCouches: String;
    function G1_Z_Libelle( _G1_Z: TG1_Z): String;
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
  //Reprise à partir d'une couche donnée
  public
    function Reprendre( _iCouche: Integer): String;
  //Conversion outil T -> pause à Y symbolisant une couleur
  public
    function Outil_T_PauseY( _nb_outils: Integer; _dy: Integer): String;
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

function TFichierGCODE.Extrait_Ligne( _Debut_Ligne: Integer): String;
var
   I: Integer;
   C: Char;
   function GetC: Char;
   begin
        C:= S[I];
        Result:= C;
   end;
begin
     Result:= '';
     I:= _Debut_Ligne;
     while     (I< Length(S))
           and not (GetC in [#13,#10])
     do
       begin
       Result:= Result + C;
       Inc( I);
       end;
end;

function TFichierGCODE.nExtrait_Ligne(_Debut_Ligne: Integer): String;
begin
     Result:= IntToStr( _Debut_Ligne)+'>'+Extrait_Ligne( _Debut_Ligne);
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
        Delete( Fin_Ligne, 3, Length( Fin_Ligne));
        if Length(Fin_Ligne) >1
        then
            begin
            if Fin_Ligne[2] = #13
            then
                Delete( Fin_Ligne, 2, Length( Fin_Ligne))
            else
                if Fin_Ligne[1] = #10 then Fin_Ligne:= #10;
            end;
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
   procedure Trouve_Couches;
   var
      NbCouches: Integer;
      iMontee, iCouche: Integer;
   begin
        NbCouches:= High(Montees) - Montee_Premiere_Couche +1;
        SetLength( Couches, NbCouches);
        for iCouche:= Low(Couches) to High(Couches)
        do
          begin
          iMontee:= Montee_Premiere_Couche+iCouche;
          Couches[iCouche]:= Montees[iMontee];
          end;
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
     Trouve_Couches;
end;

function TFichierGCODE.G1_Z_Libelle(_G1_Z: TG1_Z): String;
begin
     Result:= _G1_Z.sZ+':'+Extrait_Ligne( _G1_Z.Index);
end;

function TFichierGCODE.sMontees: String;
var
   I: Integer;
begin
     Result:= '';
     for I:= Low(Montees) to High(Montees)
     do
       Formate_Liste( Result, #13#10, 'Montée '+Format( '%.2d',[I])+': '+G1_Z_Libelle( Montees[I]));
end;

function TFichierGCODE.sCouches: String;
var
   I: Integer;
begin
     Result:= '';
     for I:= Low(Couches) to High(Couches)
     do
       Formate_Liste( Result, #13#10, 'Couche '+Format( '%.2d',[I])+': '+G1_Z_Libelle(Couches[I]));
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
   sFileName: String;
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

     {
     NomTranche
     :=
        ChangeFileExt(NomFichier,'')
       +'_'+IntToStr( _NumeroFichier)
       +ExtractFileExt(NomFichier);
     }
     sFileName:= ExtractFileName( NomFichier);
     Insert( IntToStr( _NumeroFichier)+'_', sFileName,4);
     NomTranche
     :=
         ExtractFilePath( NomFichier)
        +sFileName;
     String_to_File( NomTranche, sTranche);
end;

function TFichierGCODE.Reprendre( _iCouche: Integer): String;
var
   Debut, Fin: Integer;
   IndexDebut, IndexFin: Integer;
   sTranche: String;
   NomTranche: String;
   sFileName: String;
begin
     Debut:= Montee_Premiere_Couche+_iCouche;
     Fin:= High( Montees);

     IndexDebut:= Montees[Debut].Index;
     if Fin = -1
     then
         IndexFin:= Debut_END_GCODE-1
     else
         IndexFin:= Montees[Fin].Index-1;

     sTranche
     :=
        Header( False)
       +Copy( S, IndexDebut, IndexFin-IndexDebut+1)
       +'; '+Ligne(IndexFin+1)
       +Footer;

     sFileName:= ExtractFileName( NomFichier);
     Insert( 'reprise_couche_'+IntToStr( Debut)+'_', sFileName,4);
     NomTranche
     :=
         ExtractFilePath( NomFichier)
        +sFileName;
     String_to_File( NomTranche, sTranche);
     Result:= NomTranche;
end;

function TFichierGCODE.Outil_T_PauseY( _nb_outils: Integer; _dy: Integer): String;
var
   I: Integer;
   sCommentaire: String;
   NomCible: String;
   procedure T( _I: Integer);
   var
      sOutil: String;
      sY: String;
      sPause: String;
   begin
        sOutil:= 'T'+IntToStr( _I);
        sY:= IntToStr( _I*_dy);
        sPause:= 'G1 X0 Y'+sY+' E0'#13#10'G92 E0';
        Formate_Liste( sCommentaire, #13#10, ';'+sOutil+' converti en '+StringReplace( sPause, #13#10, '\n', [rfReplaceAll]));
        S:= StringReplace( S, sOutil, sPause, [rfReplaceAll]);
   end;
begin
     sCommentaire:= ';Outil_T_PauseY, '+IntToStr( _nb_outils)+' outils, _dy='+IntToStr( _dy);
     NomCible:= ChangeFileExt( NomFichier, '_Outil_T_PauseY.'+ExtractFileExt( NomFichier));
     for I:= 0 to _nb_outils-1
     do
       T(I);
     Insert( sCommentaire+#13#10, S, 1);
     String_to_File( NomCible, S);
     Result:= NomCible;
end;


end.

