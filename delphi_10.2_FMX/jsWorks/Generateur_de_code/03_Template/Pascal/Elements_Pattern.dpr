program Elements_Pattern;

uses
  Forms,
  udmxcreNom_de_la_classe in 'udmxcreNom_de_la_classe.pas' {dmxcreNom_de_la_classe: TDataModule},
  ublNom_de_la_classe in 'ublNom_de_la_classe.pas',
  upoolNom_de_la_classe in 'upoolNom_de_la_classe.pas' {poolNom_de_la_classe: TDataModule},
  ufNom_de_la_classe in 'ufNom_de_la_classe.pas' {fNom_de_la_classe},
  udkdNom_de_la_classe in 'udkdNom_de_la_classe.pas' {dkdNom_de_la_classe},
  ufcbNom_de_la_classe in 'ufcbNom_de_la_classe.pas' {fcbNom_de_la_classe},
  utcNom_de_la_classe in 'utcNom_de_la_classe.pas',
  ufPatternMainMenu in 'ufPatternMainMenu.pas' {fPatternMainMenu},
  uhfNom_de_la_classe in 'uhfNom_de_la_classe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.
