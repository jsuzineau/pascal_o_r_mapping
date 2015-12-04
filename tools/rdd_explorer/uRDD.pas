unit uRDD;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uVide,
    uBatpro_StringList,
    uuStrings,
    uPublieur,
 Classes, SysUtils, math;

type

 { TRDD_Ligne }

 TRDD_Ligne
 =
  class
   //Gestion du cycle de vie
   public
     constructor Create( _S: String);
     destructor Destroy; override;
   //Contenu
   public
     S: String;
     A: array of String;
     function NbColonnes: Integer;
  end;

 TIterateur_RDD_Ligne
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TRDD_Ligne);
    function  not_Suivant( var _Resultat: TRDD_Ligne): Boolean;
  end;


 TslRDD_Ligne
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_RDD_Ligne;
    function Iterateur_Decroissant: TIterateur_RDD_Ligne;
  end;

 { TRDD }

 TRDD
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Nom de fichier
  private
    FNomFichier: String;
    procedure SetNomFichier( const _Value: String);
  public
    property NomFichier: String read FNomFichier write SetNomFichier;
  //Contenu sous forme de chaine
  public
    S: String;
  //Contenu sous forme de liste de lignes
  public
    sl: TslRDD_Ligne;
    NbColonnes: Integer;
    procedure sl_from_S;
    function NbLignes: Integer;
  //OnChange
  public
    OnChange: TPublieur;
  end;


implementation

{ TRDD_Ligne }

constructor TRDD_Ligne.Create(_S: String);
var
   sA: String;
begin
     S:= _S;

     SetLength( A, 0);
     sA:= S;
     while '' <> sA
     do
       begin
       SetLength( A, Length(A)+1);
       A[High(A)]:= StrToK( '^', sA);
       end;
end;

destructor TRDD_Ligne.Destroy;
begin
 inherited Destroy;
end;

function TRDD_Ligne.NbColonnes: Integer;
begin
     Result:= Length( A);
end;

{ TIterateur_RDD_Ligne }

function TIterateur_RDD_Ligne.not_Suivant( var _Resultat: TRDD_Ligne): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_RDD_Ligne.Suivant( var _Resultat: TRDD_Ligne);
begin
     Suivant_interne( _Resultat);
end;

{ TslRDD_Ligne }

constructor TslRDD_Ligne.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TRDD_Ligne);
end;

destructor TslRDD_Ligne.Destroy;
begin
     inherited;
end;

class function TslRDD_Ligne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_RDD_Ligne;
end;

function TslRDD_Ligne.Iterateur: TIterateur_RDD_Ligne;
begin
     Result:= TIterateur_RDD_Ligne( Iterateur_interne);
end;

function TslRDD_Ligne.Iterateur_Decroissant: TIterateur_RDD_Ligne;
begin
     Result:= TIterateur_RDD_Ligne( Iterateur_interne_Decroissant);
end;

{ TRDD }

constructor TRDD.Create;
begin
     FNomFichier:= '';
     OnChange:= TPublieur.Create( ClassName+'.OnChange');
     sl:= TslRDD_Ligne.Create( ClassName+'.sl');
end;

destructor TRDD.Destroy;
begin
     Free_nil(sl);
     Free_nil( OnChange);
     inherited Destroy;
end;

procedure TRDD.SetNomFichier( const _Value: String);
begin
     FNomFichier:= _Value;
     S:= uuStrings.String_from_File( FNomFichier);

     sl_from_S;

     OnChange.Publie;
end;

procedure TRDD.sl_from_S;
var
   sA: String;
   bl: TRDD_Ligne;
begin
     Vide_StringList( sl);
     NbColonnes:= 0;
     sA:= S;
     while sA <> ''
     do
       begin
       bl:= TRDD_Ligne.Create( StrToK( #13#10, sA));
       sl.AddObject( '', bl);
       NbColonnes:= Max( NbColonnes, bl.NbColonnes);
       end;
end;

function TRDD.NbLignes: Integer;
begin
     Result:= sl.Count;
end;

end.

