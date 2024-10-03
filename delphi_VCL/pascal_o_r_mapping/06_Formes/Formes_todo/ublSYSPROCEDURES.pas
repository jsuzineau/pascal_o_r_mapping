unit ublSYSPROCEDURES;

interface

uses
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
  SysUtils, Classes, DB;

type
 TblSYSPROCEDURES
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    procname: String;
    owner: String;
    procid: Integer;
    mode: String;
    retsize: Integer;
    symsize: Integer;
    datasize: Integer;
    codesize: Integer;
    numargs: Integer;
  //Gestion de la clé
  public
    class function sCle_from_( _procname: String): String;

    function sCle: String; override;
  end;

function blSYSPROCEDURES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSPROCEDURES;
function blSYSPROCEDURES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSPROCEDURES;

implementation

function blSYSPROCEDURES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSPROCEDURES;
begin
     _Classe_from_sl( Result, TblSYSPROCEDURES, sl, Index);
end;

function blSYSPROCEDURES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSPROCEDURES;
begin
     _Classe_from_sl_sCle( Result, TblSYSPROCEDURES, sl, sCle);
end;

{ TblSYSPROCEDURES }

constructor TblSYSPROCEDURES.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSPROCEDURES';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'sysprocedures';

     //champs persistants
     Champs.  String_from_String ( procname       , 'procname'       );
     Champs.  String_from_String ( owner          , 'owner'          );
     Champs. Integer_from_Integer( procid         , 'procid'         );
     Champs.  String_from_String ( mode           , 'mode'           );
     Champs. Integer_from_Integer( retsize        , 'retsize'        );
     Champs. Integer_from_Integer( symsize        , 'symsize'        );
     Champs. Integer_from_Integer( datasize       , 'datasize'       );
     Champs. Integer_from_Integer( codesize       , 'codesize'       );
     Champs. Integer_from_Integer( numargs        , 'numargs'        );

     procname:= Trim( procname);
end;

destructor TblSYSPROCEDURES.Destroy;
begin

     inherited;
end;

class function TblSYSPROCEDURES.sCle_from_( _procname: String): String;
begin                               
     Result:=  Fixe_Min( _procname, 18);    
end;

function TblSYSPROCEDURES.sCle: String;
begin
     Result:= sCle_from_( procname);
end;

end.


