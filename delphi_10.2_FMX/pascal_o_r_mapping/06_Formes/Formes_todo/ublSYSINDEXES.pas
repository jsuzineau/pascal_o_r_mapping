unit ublSYSINDEXES;

interface

uses
    uBatpro_StringList,
    u_sys_,
    uChamp,
    uuStrings,

    uBatpro_Element,
    uBatpro_Ligne,
    ublSYSCONSTRAINTS,

    upool_Ancetre_Ancetre,
    upoolSYSCONSTRAINTS,

  SysUtils, Classes, DB;

type
 TblSYSINDEXES
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    idxname: String;
    owner: String;
    tabid: Integer;
    idxtype: String;
    clustered: String;
    part1: Integer;
    part2: Integer;
    part3: Integer;
    part4: Integer;
    part5: Integer;
    part6: Integer;
    part7: Integer;
    part8: Integer;
    part9: Integer;
    part10: Integer;
    part11: Integer;
    part12: Integer;
    part13: Integer;
    part14: Integer;
    part15: Integer;
    part16: Integer;
    levels: Integer;
    leaves: Integer;
    nunique: Integer;
    clust: Integer;
  //Gestion de la clé
  public
    class function sCle_from_( _idxname: String): String;

    function sCle: String; override;
  //Contrainte
  public
    blSYSCONSTRAINTS: TblSYSCONSTRAINTS;
  //Primary Key
  public
    function is_PRIMARY_KEY: Boolean;
  //Colonnes de l'index
  private
    procedure Calcule_Colonnes;
  public
    Colonnes: String;
  //Unique
  public
    Unique: String;
  end;

function blSYSINDEXES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSINDEXES;
function blSYSINDEXES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSINDEXES;

implementation

function blSYSINDEXES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSINDEXES;
begin
     _Classe_from_sl( Result, TblSYSINDEXES, sl, Index);
end;

function blSYSINDEXES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSINDEXES;
begin
     _Classe_from_sl_sCle( Result, TblSYSINDEXES, sl, sCle);
end;

{ TblSYSINDEXES }

constructor TblSYSINDEXES.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
   cTABID  : TChamp;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSINDEXES';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'sysindexes';

     //champs persistants
                Champs.  String_from_String ( idxname  , 'idxname'  );
                Champs.  String_from_String ( owner    , 'owner'    );
     cTABID  := Champs. Integer_from_Integer( tabid    , 'tabid'    );
                Champs.  String_from_String ( idxtype  , 'idxtype'  );
                Champs.  String_from_String ( clustered, 'clustered');
                Champs. Integer_from_Integer( part1    , 'part1'    );
                Champs. Integer_from_Integer( part2    , 'part2'    );
                Champs. Integer_from_Integer( part3    , 'part3'    );
                Champs. Integer_from_Integer( part4    , 'part4'    );
                Champs. Integer_from_Integer( part5    , 'part5'    );
                Champs. Integer_from_Integer( part6    , 'part6'    );
                Champs. Integer_from_Integer( part7    , 'part7'    );
                Champs. Integer_from_Integer( part8    , 'part8'    );
                Champs. Integer_from_Integer( part9    , 'part9'    );
                Champs. Integer_from_Integer( part10   , 'part10'   );
                Champs. Integer_from_Integer( part11   , 'part11'   );
                Champs. Integer_from_Integer( part12   , 'part12'   );
                Champs. Integer_from_Integer( part13   , 'part13'   );
                Champs. Integer_from_Integer( part14   , 'part14'   );
                Champs. Integer_from_Integer( part15   , 'part15'   );
                Champs. Integer_from_Integer( part16   , 'part16'   );
                Champs. Integer_from_Integer( levels   , 'levels'   );
                Champs. Integer_from_Integer( leaves   , 'leaves'   );
                Champs. Integer_from_Integer( nunique  , 'nunique'  );
                Champs. Integer_from_Integer( clust    , 'clust'    );

     Ajoute_String( Colonnes, 'Colonnes', False);
     Ajoute_String( Unique  , 'Unique', False);

     idxname:= Trim( idxname);

     // Code manuel
     cTABID  .Definition.Visible:= False;

     blSYSCONSTRAINTS:= poolSYSCONSTRAINTS.Get_first_from_idxname( idxname);

     Calcule_Colonnes;
     if nunique = 1
     then
         Unique:= 'non'
     else
         Unique:= 'oui';
end;

destructor TblSYSINDEXES.Destroy;
begin

     inherited;
end;

class function TblSYSINDEXES.sCle_from_( _idxname: String): String;
begin
     Result:=  Fixe_Min( _idxname, 18);
end;

function TblSYSINDEXES.sCle: String;
begin
     Result:= sCle_from_( idxname);
end;

function TblSYSINDEXES.is_PRIMARY_KEY: Boolean;
begin
     if blSYSCONSTRAINTS = nil
     then
         Result:= False
     else
         Result:= blSYSCONSTRAINTS.is_PRIMARY_KEY;
end;

procedure TblSYSINDEXES.Calcule_Colonnes;
var
   I: Integer;
   procedure T( var _part: Integer);
   begin
        if _part = 0 then exit;

        Formate_Liste( Colonnes, ' ', IntToStr( _part));
   end;
begin
     Colonnes:= '';
     T( part1 );
     T( part2 );
     T( part3 );
     T( part4 );
     T( part5 );
     T( part6 );
     T( part7 );
     T( part8 );
     T( part9 );
     T( part10);
     T( part11);
     T( part12);
     T( part13);
     T( part14);
     T( part15);
     T( part16);
end;

end.


