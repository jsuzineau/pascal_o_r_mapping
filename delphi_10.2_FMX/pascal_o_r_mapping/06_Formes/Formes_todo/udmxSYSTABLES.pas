unit udmxSYSTABLES;

interface

uses
    u_sys_,
    uClean,
    udmDatabase,
    udmBatpro_DataModule,
    udmx,
    ufAccueil_Erreur,
    ucBatproVerifieur,
    ucbvQuery_Datasource,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, FMTBcd, Provider, DBClient, SqlExpr;

type
 TdmxSYSTABLES
 =
  class(Tdmx)
    sqlqtabname: TStringField;
    sqlqowner: TStringField;
    sqlqpartnum: TIntegerField;
    sqlqtabid: TIntegerField;
    sqlqrowsize: TSmallintField;
    sqlqncols: TSmallintField;
    sqlqnindexes: TSmallintField;
    sqlqnrows: TIntegerField;
    sqlqcreated: TDateField;
    sqlqversion: TIntegerField;
    sqlqtabtype: TStringField;
    sqlqlocklevel: TStringField;
    sqlqnpused: TIntegerField;
    sqlqfextsize: TIntegerField;
    sqlqnextsize: TIntegerField;
    sqlqflags: TSmallintField;
    sqlqsite: TStringField;
    sqlqdbname: TStringField;
    cdtabname: TStringField;
    cdowner: TStringField;
    cdpartnum: TIntegerField;
    cdtabid: TIntegerField;
    cdrowsize: TSmallintField;
    cdncols: TSmallintField;
    cdnindexes: TSmallintField;
    cdnrows: TIntegerField;
    cdcreated: TDateField;
    cdversion: TIntegerField;
    cdtabtype: TStringField;
    cdlocklevel: TStringField;
    cdnpused: TIntegerField;
    cdfextsize: TIntegerField;
    cdnextsize: TIntegerField;
    cdflags: TSmallintField;
    cdsite: TStringField;
    cddbname: TStringField;
  private
    { Déclarations privées }
  protected
  public
    { Déclarations publiques }
    function Cherche( tabname: String): Boolean;
  end;

function dmxSYSTABLES: TdmxSYSTABLES;

implementation

{$R *.dfm}

var
   FdmxSYSTABLES: TdmxSYSTABLES;

function dmxSYSTABLES: TdmxSYSTABLES;
begin
     Clean_Get( Result, FdmxSYSTABLES, TdmxSYSTABLES);
end;

function TdmxSYSTABLES.Cherche( tabname: String): Boolean;
begin
     if dmDatabase.IsMySQL
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxSYSTABLES.Cherche sur une base MySQL');
         exit;
         end;

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
              Clean_Create ( FdmxSYSTABLES, TdmxSYSTABLES);
finalization
              Clean_Destroy( FdmxSYSTABLES);
end.
