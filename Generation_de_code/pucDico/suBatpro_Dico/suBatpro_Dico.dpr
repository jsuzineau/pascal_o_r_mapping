library suBatpro_Dico;

uses
  ComServ,
  upoolG_BECP,
  ufDICO in '..\ufDICO.pas' {fDico},
  urepTables in '..\urepTables.pas' {repTables: TQuickRep},
  udmcreSYSDICO_ENT in '..\udmcreSYSDICO_ENT.pas' {dmcreSYSDICO_ENT: TDataModule},
  u_db_DICO in '..\u_db_DICO.pas',
  u_loc_DICO in '..\u_loc_DICO.pas',
  udmxcreSYSDICO_REL in '..\udmxcreSYSDICO_REL.pas' {dmxcreSYSDICO_REL: TDataModule},
  upatchSYSDICO_ENT in '..\upatchSYSDICO_ENT.pas' {dmcreSYSDICO_ENT_ENTETE_PIED: TDataModule},
  udmTables in '..\udmTables.pas' {dmTables: TDataModule},
  udmcreSYSDICO_LIG in '..\udmcreSYSDICO_LIG.pas' {dmcreSYSDICO_LIG: TDataModule},
  ublSYSDICO_TXT in '..\ublSYSDICO_TXT.PAS',
  ublSYSDICO_LIG in '..\ublSYSDICO_LIG.PAS',
  ublSYSDICO_REL in '..\ublSYSDICO_REL.PAS',
  ublSYSDICO_ENT in '..\ublSYSDICO_ENT.PAS',
  uhfSYSDICO_TXT in '..\uhfSYSDICO_TXT.PAS',
  uhfSYSDICO_LIG in '..\uhfSYSDICO_LIG.PAS',
  uhfSYSDICO_REL in '..\uhfSYSDICO_REL.PAS',
  uhfSYSDICO_ENT in '..\uhfSYSDICO_ENT.PAS',
  upoolSYSDICO_TXT in '..\upoolSYSDICO_TXT.PAS' {poolSYSDICO_TXT: TDataModule},
  upoolSYSDICO_ENT in '..\upoolSYSDICO_ENT.PAS' {poolSYSDICO_ENT: TDataModule},
  upoolSYSDICO_LIG in '..\upoolSYSDICO_LIG.PAS' {poolSYSDICO_LIG: TDataModule},
  upoolSYSDICO_REL in '..\upoolSYSDICO_REL.PAS' {poolSYSDICO_REL: TDataModule},
  udmxEXPORT in '..\udmxEXPORT.pas' {dmxEXPORT},
  uOOo_SYSDICO_ENT in '..\uOOo_SYSDICO_ENT.pas',
  uOOo_SYSDICO_ENT_liste in '..\uOOo_SYSDICO_ENT_liste.pas',

  suBatpro_Dico_TLB in 'suBatpro_Dico_TLB.pas',
  StarUML_TLB in 'StarUML_TLB.pas',
  uBatpro_Dico in 'uBatpro_Dico.pas' {Batpro_Dico: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
