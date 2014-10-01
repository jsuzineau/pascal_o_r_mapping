program Elements_Pattern;

uses
  Forms,
  ufNomTable in 'ufNomTable.pas',
  ufPatternMainMenu in 'ufPatternMainMenu.pas',
  utcNomTable in 'utcNomTable.pas',
  udmcreNomTable in 'udmcreNomTable.pas' {dmcreNomTable},
  udmxtNomTable in 'udmxtNomTable.pas' {dmxtNomTable},
  ufcbNomTable in 'ufcbNomTable.pas' {fcbNomTable},
  udmaNomTable in 'udmaNomTable.pas' {dmaNomTable: TDataModule},
  udmdNomTable in 'udmdNomTable.pas' {dmdNomTable: TDataModule},
  udkdNomTable in 'udkdNomTable.pas' {dkdNomTable},
  udmlkNomTable in 'udmlkNomTable.pas' {dmlkNomTable: TDataModule},
  uhrNomTable in 'uhrNomTable.pas',
  ufdNomTable in 'ufdNomTable.pas' {fdNomTable};

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.
