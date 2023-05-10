unit ublSYSCONSTRAINTS;

interface

uses
    uBatpro_StringList,
    u_sys_,
    uChamp,
    uuStrings,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
  SysUtils, Classes, DB;

type
 TblSYSCONSTRAINTS
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    constrid: Integer;
    constrname: String;
    owner: String;
    tabid: Integer;
    constrtype: String;
    idxname: String;
  //Gestion de la clé
  public
    class function sCle_from_( _constrid: Integer): String;

    function sCle: String; override;
  //Primary Key
  public
    function is_PRIMARY_KEY: Boolean;
  end;

function blSYSCONSTRAINTS_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSCONSTRAINTS;
function blSYSCONSTRAINTS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSCONSTRAINTS;

implementation

function blSYSCONSTRAINTS_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSCONSTRAINTS;
begin
     _Classe_from_sl( Result, TblSYSCONSTRAINTS, sl, Index);
end;

function blSYSCONSTRAINTS_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSCONSTRAINTS;
begin
     _Classe_from_sl_sCle( Result, TblSYSCONSTRAINTS, sl, sCle);
end;

{ TblSYSCONSTRAINTS }

constructor TblSYSCONSTRAINTS.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSCONSTRAINTS';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'sysconstraints';

     //champs persistants
     Champs. Integer_from_Integer( constrid  , 'constrid'  );
     Champs.  String_from_String ( constrname, 'constrname');
     Champs.  String_from_String ( owner     , 'owner'     );
     Champs. Integer_from_Integer( tabid     , 'tabid'     );
     Champs.  String_from_String ( constrtype, 'constrname');
     Champs.  String_from_String ( idxname   , 'idxname'   );

     constrname:= Trim( constrname);
     idxname:= Trim( idxname);
end;

destructor TblSYSCONSTRAINTS.Destroy;
begin

     inherited;
end;

class function TblSYSCONSTRAINTS.sCle_from_( _constrid: Integer): String;
begin
     Result:= IntToHex( _constrid, 8);
end;

function TblSYSCONSTRAINTS.sCle: String;
begin
     Result:= sCle_from_( constrid);
end;

function TblSYSCONSTRAINTS.is_PRIMARY_KEY: Boolean;
begin
     Result:= constrtype = 'P';
end;

end.


