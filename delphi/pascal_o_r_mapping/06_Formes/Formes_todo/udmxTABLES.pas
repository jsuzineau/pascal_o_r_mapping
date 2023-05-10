unit udmxTABLES;

interface

uses
    u_sys_,
    uClean,
    uMySQL,
    uDataUtilsF,

    udmDatabase,
    udmBatpro_DataModule,
    udmx,

    ufAccueil_Erreur,

    ucBatproVerifieur,
    ucbvQuery_Datasource,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, DBTables, FMTBcd, Provider, DBClient, SqlExpr;

type
 TdmxTABLES
 =
  class(Tdmx)
    procedure DataModuleCreate(Sender: TObject);
  public
    { Déclarations publiques }
    function Cherche( tabname: String; _GED: Boolean = False): Boolean;
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmxTABLES: TdmxTABLES;

implementation

{$R *.dfm}

var
   FdmxTABLES: TdmxTABLES;

function dmxTABLES: TdmxTABLES;
begin
     Clean_Get( Result, FdmxTABLES, TdmxTABLES);
end;

procedure TdmxTABLES.DataModuleCreate(Sender: TObject);
begin
     inherited;
     Ouvrir_apres_login:= False;
end;

function TdmxTABLES.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= dmDatabase.IsMySQL;
     if Result
     then
         Result:= inherited Ouverture( Edition);
end;

function TdmxTABLES.Cherche( tabname: String; _GED: Boolean = False): Boolean;
var
   DatabaseName: String;
begin
     if not (dmDatabase.IsMySQL or _GED)
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxTABLES.Cherche sur une base non MySQL');
         exit;
         end;

     sqlq.Close;
     if dmDatabase.IsMySQL
     then
         begin
         DatabaseName:= MySQL.DataBase;
         sqlq.SQLConnection:= dmDatabase.sqlc;
         end
     else
         begin
         DatabaseName:= 'batpro_ged';
         sqlq.SQLConnection:= dmDatabase.sqlcGED;
         end;
     with sqlq.Params
     do
       begin
       ParamByName( 'table_schema').AsString:= DatabaseName;
       ParamByName( 'table_name'  ).AsString:= tabname       ;
       end;
     RefreshQuery( sqlq);
     Result:= not sqlq.IsEmpty;
end;

initialization
              Clean_Create ( FdmxTABLES, TdmxTABLES);
finalization
              Clean_Destroy( FdmxTABLES);
end.
