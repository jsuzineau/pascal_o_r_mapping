unit udmxSYSINDEXES;

interface

uses
    uClean,
    u_sys_,
    udmDatabase,
    udmBatpro_DataModule,
    udmx,
    ufAccueil_Erreur,
  ucBatproVerifieur,
  ucbvQuery_Datasource,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr;

type
 TdmxSYSINDEXES
 =
  class( Tdmx)
    sqlqidxname: TStringField;
    sqlqowner: TStringField;
    sqlqtabid: TIntegerField;
    sqlqidxtype: TStringField;
    sqlqclustered: TStringField;
    sqlqpart1: TSmallintField;
    sqlqpart2: TSmallintField;
    sqlqpart3: TSmallintField;
    sqlqpart4: TSmallintField;
    sqlqpart5: TSmallintField;
    sqlqpart6: TSmallintField;
    sqlqpart7: TSmallintField;
    sqlqpart8: TSmallintField;
    sqlqpart9: TSmallintField;
    sqlqpart10: TSmallintField;
    sqlqpart11: TSmallintField;
    sqlqpart12: TSmallintField;
    sqlqpart13: TSmallintField;
    sqlqpart14: TSmallintField;
    sqlqpart15: TSmallintField;
    sqlqpart16: TSmallintField;
    sqlqlevels: TSmallintField;
    sqlqleaves: TIntegerField;
    sqlqnunique: TIntegerField;
    sqlqclust: TIntegerField;
    cdidxname: TStringField;
    cdowner: TStringField;
    cdtabid: TIntegerField;
    cdidxtype: TStringField;
    cdclustered: TStringField;
    cdpart1: TSmallintField;
    cdpart2: TSmallintField;
    cdpart3: TSmallintField;
    cdpart4: TSmallintField;
    cdpart5: TSmallintField;
    cdpart6: TSmallintField;
    cdpart7: TSmallintField;
    cdpart8: TSmallintField;
    cdpart9: TSmallintField;
    cdpart10: TSmallintField;
    cdpart11: TSmallintField;
    cdpart12: TSmallintField;
    cdpart13: TSmallintField;
    cdpart14: TSmallintField;
    cdpart15: TSmallintField;
    cdpart16: TSmallintField;
    cdlevels: TSmallintField;
    cdleaves: TIntegerField;
    cdnunique: TIntegerField;
    cdclust: TIntegerField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Cherche( idxname, tabname: String): Boolean;
  end;

function dmxSYSINDEXES: TdmxSYSINDEXES;

implementation

{$R *.dfm}

var
   FdmxSYSINDEXES: TdmxSYSINDEXES;

function dmxSYSINDEXES: TdmxSYSINDEXES;
begin
     Clean_Get( Result, FdmxSYSINDEXES, TdmxSYSINDEXES);
end;

function TdmxSYSINDEXES.Cherche(idxname, tabname: String): Boolean;
begin
     if dmDatabase.IsMySQL
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxSYSINDEXES.Cherche sur une base MySQL');
         exit;
         end;

     sqlq.ParamByName( 'idxname').AsString:= idxname;
     sqlq.ParamByName( 'tabname').AsString:= tabname;
     Result:= inherited Ouvrir_LectureSeule;
     if Result
     then
         begin
         cd.First;
         Result:= not cd.EOF;
         end;
end;

initialization
              Clean_CreateD( FdmxSYSINDEXES, TdmxSYSINDEXES);
finalization
              Clean_Destroy( FdmxSYSINDEXES);
end.
