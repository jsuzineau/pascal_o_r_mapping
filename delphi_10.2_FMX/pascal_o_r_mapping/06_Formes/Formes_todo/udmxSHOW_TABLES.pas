unit udmxSHOW_TABLES;

interface

uses
    u_sys_,
    uClean,
    uSGBD,

    udmDatabase,
    udmBatpro_DataModule,
    udmx,

    ufAccueil_Erreur,

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, FMTBcd, Provider, DBClient, SqlExpr,
  ucBatproVerifieur,
  ucbvQuery_Datasource;

type
 TdmxSHOW_TABLES
 =
  class(Tdmx)
    procedure DataModuleCreate(Sender: TObject);
  public
    { Déclarations publiques }
    cdNomTable: TStringField;
    function Cherche( tabname: String): Boolean;
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmxSHOW_TABLES: TdmxSHOW_TABLES;

implementation

{$R *.dfm}

var
   FdmxSHOW_TABLES: TdmxSHOW_TABLES;

function dmxSHOW_TABLES: TdmxSHOW_TABLES;
begin
     Clean_Get( Result, FdmxSHOW_TABLES, TdmxSHOW_TABLES);
end;

procedure TdmxSHOW_TABLES.DataModuleCreate(Sender: TObject);
begin
     inherited;
     Ouvrir_apres_login:= True;
     cdNomTable:= nil;
end;

function TdmxSHOW_TABLES.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= sgbdMYSQL;
     if Result
     then
         Result:= inherited Ouverture( Edition);
     if Result
     then
         cdNomTable:= cd.Fields[0] as TStringField
     else
         cdNomTable:= nil;
end;

function TdmxSHOW_TABLES.Cherche( tabname: String): Boolean;
var
   NomChamp: String;
begin
     tabname:= LowerCase( tabname);
     if not dmDatabase.IsMySQL
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxSHOW_TABLES.Cherche sur une base non MySQL');
         exit;
         end;

     Result:= Ouvert;
     if Result
     then
         begin
         NomChamp:= cdNomTable.FieldName;
         Result:= cd.Locate( NomChamp, tabname, []);
         end;
end;

initialization
              Clean_Create ( FdmxSHOW_TABLES, TdmxSHOW_TABLES);
finalization
              Clean_Destroy( FdmxSHOW_TABLES);
end.
