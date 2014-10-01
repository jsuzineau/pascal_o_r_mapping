library suPatterns_from_MCD;

uses
  ComServ,
  Dialogs,
  suPatterns_from_MCD_TLB in 'suPatterns_from_MCD_TLB.pas',
  StarUML_TLB in 'StarUML_TLB.pas',
  uPatterns_from_MCD in 'uPatterns_from_MCD.pas' {Patterns_from_MCD: CoClass},
  uPatternHandler in 'uPatternHandler.pas',
  uf_f_dbgKeyPress_Key_Pattern in 'uf_f_dbgKeyPress_Key_Pattern.pas' {f_f_dbgKeyPress_Key_Pattern},
  uMenuHandler in 'uMenuHandler.pas',
  uGenerateur_CSharp in 'uGenerateur_CSharp.pas',
  uJoinPoint in 'uJoinPoint.pas',
  uContexteMembre in 'uContexteMembre.pas',
  uContexteClasse in 'uContexteClasse.pas',
  uGlobal in 'uGlobal.pas',
  ujpSQL_CREATE_TABLE in 'ujpSQL_CREATE_TABLE.pas',
  ujpNomTable in 'ujpNomTable.pas',
  ujpChamps_persistants in 'ujpChamps_persistants.pas',
  ujpConteneurs in 'ujpConteneurs.pas',
  ujpChargement_Conteneurs in 'ujpChargement_Conteneurs.pas',
  ujpContenus in 'ujpContenus.pas',
  ucsMenuHandler in 'ucsMenuHandler.pas',
  ujpDocksDetails in 'ujpDocksDetails.pas',
  ujpDocksDetails_Affiche in 'ujpDocksDetails_Affiche.pas',
  uGenerateur_PHP_Doctrine in 'uGenerateur_PHP_Doctrine.pas',
  ujpNomTableMinuscule in 'ujpNomTableMinuscule.pas',
  ujpPHP_Doctrine_Has_Column in 'ujpPHP_Doctrine_Has_Column.pas',
  ujpPHP_Doctrine_HasMany in 'ujpPHP_Doctrine_HasMany.pas',
  ujpPHP_Doctrine_HasOne in 'ujpPHP_Doctrine_HasOne.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
     //ShowMessage( 'suPatterns_from_MCD dll');
end.
