unit udmxSYSCOLUMNS;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, DBTables, FMTBcd, Provider, DBClient, SqlExpr,
    udmBatpro_DataModule,
    udmx,
    ublInformix_Column,
    ucBatproVerifieur,
    ucbvQuery_Datasource;

type
 TdmxSYSCOLUMNS
 =
  class(Tdmx)
    sqlqcolname: TStringField;
    sqlqtabid: TIntegerField;
    sqlqcolno: TSmallintField;
    sqlqcoltype: TSmallintField;
    sqlqcollength: TSmallintField;
    sqlqcolmin: TIntegerField;
    sqlqcolmax: TIntegerField;
    cdcolname: TStringField;
    cdtabid: TIntegerField;
    cdcolno: TSmallintField;
    cdcoltype: TSmallintField;
    cdcollength: TSmallintField;
    cdcolmin: TIntegerField;
    cdcolmax: TIntegerField;
    sqlqrowid: TIntegerField;
    cdrowid: TIntegerField;
  private
    { Déclarations privées }
  protected
  public
    { Déclarations publiques }
    function Cherche( tabname, colname: String): Boolean; overload;
    function Cherche( tabname, colname, TypeColonne: String): Boolean; overload;
  end;

function dmxSYSCOLUMNS: TdmxSYSCOLUMNS;

implementation

uses
    u_sys_,
    uClean,
    udmDatabase,
    ufAccueil_Erreur, uBatpro_Ligne;

{$R *.dfm}

var
   FdmxSYSCOLUMNS: TdmxSYSCOLUMNS;

function dmxSYSCOLUMNS: TdmxSYSCOLUMNS;
begin
     Clean_Get( Result, FdmxSYSCOLUMNS, TdmxSYSCOLUMNS);
end;

function TdmxSYSCOLUMNS.Cherche( tabname, colname: String): Boolean;
begin
     if dmDatabase.IsMySQL
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxSYSCOLUMNS.Cherche sur une base MySQL');
         exit;
         end;

     sqlq.ParamByName( 'tabname').AsString:= tabname;
     sqlq.ParamByName( 'colname').AsString:= colname;
     Result:= inherited Ouvrir_LectureSeule;
     if Result
     then
         begin
         cd.First;
         Result:= not cd.EOF;
         end;
end;

function TdmxSYSCOLUMNS.Cherche( tabname, colname, TypeColonne: String):Boolean;
var
   bl: TblInformix_Column;
begin
     Result:= Cherche( tabname, colname);
     if Result
     then
         begin
         TypeColonne:= UpperCase( TypeColonne);
         bl:= TblInformix_Column.Create( nil, cd, nil);
         try
            bl.Set_To( cdcoltype.Value, cdcollength.Value);
            Result:= bl.SQL = TypeColonne;
         finally
                Free_nil( bl);
                end;
         end;
end;

initialization
              Clean_Create ( FdmxSYSCOLUMNS, TdmxSYSCOLUMNS);
finalization
              Clean_Destroy( FdmxSYSCOLUMNS);
end.
