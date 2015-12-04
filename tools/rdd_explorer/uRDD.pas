unit uRDD;

{$mode objfpc}{$H+}

interface

uses
    uCLean,
    uuStrings,
    uPublieur,
 Classes, SysUtils;

type

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
  //Contenu
  public
    S: String;
  //OnChange
  public
    OnChange: TPublieur;
  end;


implementation

{ TRDD }

constructor TRDD.Create;
begin
     FNomFichier:= '';
     OnChange:= TPublieur.Create( ClassName+'.OnChange');
end;

destructor TRDD.Destroy;
begin
     Free_nil( OnChange);
     inherited Destroy;
end;

procedure TRDD.SetNomFichier( const _Value: String);
begin
     FNomFichier:= _Value;
     S:= uuStrings.String_from_File( FNomFichier);
     OnChange.Publie;
end;

end.

