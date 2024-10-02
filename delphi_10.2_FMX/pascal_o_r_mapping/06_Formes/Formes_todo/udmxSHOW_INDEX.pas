unit udmxSHOW_INDEX;

interface

uses
    uClean,
    u_sys_,
    udmDatabase,
    udmx,
    ufAccueil_Erreur,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr, ucBatproVerifieur,
  ucbvQuery_Datasource;

type
 TdmxSHOW_INDEX
 =
  class(Tdmx)
  public
    function Cherche( _Database, _Table, _Key_name: String; _GED: Boolean= False): Boolean; overload;
    function Cherche( _Table, _Key_name: String; _GED: Boolean= False): Boolean; overload;
  end;

function dmxSHOW_INDEX: TdmxSHOW_INDEX;

implementation

{$R *.dfm}

var
   FdmxSHOW_INDEX: TdmxSHOW_INDEX;

function dmxSHOW_INDEX: TdmxSHOW_INDEX;
begin
     Clean_Get( Result, FdmxSHOW_INDEX, TdmxSHOW_INDEX);
end;

{ TdmxSHOW_INDEX }

function TdmxSHOW_INDEX.Cherche( _Database, _Table, _Key_name: String; _GED: Boolean): Boolean;
begin
     if not (dmDatabase.IsMySQL or _GED)
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxSHOW_INDEX.Cherche sur une base non MySQL');
         exit;
         end;


     if dmDatabase.IsMySQL
     then
         sqlq.SQLConnection:= dmDatabase.sqlc
     else
         sqlq.SQLConnection:= dmDatabase.sqlcGED;

     sqlq.SQL.Text:= 'show index from '+_Table+' from '+_Database;
     Result:= inherited Ouvrir_LectureSeule;
     if Result
     then
         begin
         Result:= cd.Locate( 'Key_name', _Key_name, [loCaseInsensitive]);
         end;
end;

function TdmxSHOW_INDEX.Cherche( _Table, _Key_name: String; _GED: Boolean): Boolean;
begin
     Result:= Cherche( dmDatabase.Database, _Table, _Key_name, _GED);
end;

initialization
              Clean_CreateD( FdmxSHOW_INDEX, TdmxSHOW_INDEX);
finalization
              Clean_Destroy( FdmxSHOW_INDEX);
end.
