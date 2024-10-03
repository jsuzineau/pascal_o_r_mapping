unit ublSYSTABLES;

interface

uses
    uBatpro_StringList,
    uhAggregation,

    u_sys_,
    uChamp,
    uuStrings,
    uDataClasses,

    uBatpro_Element,
    uBatpro_Ligne,
    ublSYSINDEXES,

    upool_Ancetre_Ancetre,
    upoolSYSINDEXES,

    SysUtils, Classes, DB;

type
 ThaSYSTABLES__SYSINDEXES
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Chargement de tous les détails
  private
    Premier: Boolean;
    procedure Assure_Charge;
  public
    procedure Charge; override;
  //Calcul d'une valeur COLUMN_KEY pour comparaison avec MySQL
  public
    function MySQL_COLUMN_KEY( colno: Integer): String;
  end;

 TblSYSTABLES
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    tabname: String;
    owner: String;
    partnum: Integer;
    tabid: Integer;
    rowsize: Integer;
    ncols: Integer;
    nindexes: Integer;
    nrows: Integer;
    created: TDateTime;
    version: Integer;
    tabtype: String;
    locklevel: String;
    npused: Integer;
    fextsize: Integer;
    nextsize: Integer;
    flags: Integer;
    site: String;
    dbname: String;

  //Gestion de la clé
  public
    class function sCle_from_( _tabname: String): String;

    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les lignes correspondantes de SYSINDEXES
  private
    FhaSYSINDEXES: ThaSYSTABLES__SYSINDEXES;
    function GethaSYSINDEXES: ThaSYSTABLES__SYSINDEXES;
  public
    property haSYSINDEXES: ThaSYSTABLES__SYSINDEXES read GethaSYSINDEXES;
  end;

function blSYSTABLES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSTABLES;
function blSYSTABLES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSTABLES;

implementation

function blSYSTABLES_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSTABLES;
begin
     _Classe_from_sl( Result, TblSYSTABLES, sl, Index);
end;

function blSYSTABLES_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSTABLES;
begin
     _Classe_from_sl_sCle( Result, TblSYSTABLES, sl, sCle);
end;

{ TblSYSTABLES }

constructor TblSYSTABLES.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
   cTABNAME: TChamp;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSTABLES';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'systables';

     //champs persistants
     cTABNAME:= Champs.  String_from_String ( tabname  , 'tabname'  );
                Champs.  String_from_String ( owner    , 'owner'    );
                Champs. Integer_from_Integer( partnum  , 'partnum'  );
                Champs. Integer_from_Integer( tabid    , 'tabid'    );
                Champs. Integer_from_Integer( rowsize  , 'rowsize'  );
                Champs. Integer_from_Integer( ncols    , 'ncols'    );
                Champs. Integer_from_Integer( nindexes , 'nindexes' );
                Champs. Integer_from_Integer( nrows    , 'nrows'    );
                Champs.DateTime_from_Date   ( created  , 'created'  );
                Champs. Integer_from_Integer( version  , 'version'  );
                Champs.  String_from_String ( tabtype  , 'tabtype'  );
                Champs.  String_from_String ( locklevel, 'locklevel');
                Champs. Integer_from_Integer( npused   , 'npused'   );
                Champs. Integer_from_Integer( fextsize , 'fextsize' );
                Champs. Integer_from_Integer( nextsize , 'nextsize' );
                Champs. Integer_from_Integer( flags    , 'flags'    );
                Champs.  String_from_String ( site     , 'site'     );
                Champs.  String_from_String ( dbname   , 'dbname'   );

     tabname:= Trim( tabname);

     // Code manuel
     cTABNAME.Definition.Visible:= False;
end;

destructor TblSYSTABLES.Destroy;
begin

     inherited;
end;

class function TblSYSTABLES.sCle_from_( _tabname: String): String;
begin
     Result:=  Fixe_Min( _tabname, 18);
end;

function TblSYSTABLES.sCle: String;
begin
     Result:= sCle_from_( tabname);
end;

procedure TblSYSTABLES.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'SYSINDEXES' = Name then P.Faible( ThaSYSTABLES__SYSINDEXES, TblSYSINDEXES, poolSYSINDEXES)
     else                             inherited Create_Aggregation( Name, P);
end;

function TblSYSTABLES.GethaSYSINDEXES: ThaSYSTABLES__SYSINDEXES;
begin
     Get_Aggregation( Result, FhaSYSINDEXES, 'SYSINDEXES', ThaSYSTABLES__SYSINDEXES);
end;

{ ThaSYSTABLES__SYSINDEXES }

constructor ThaSYSTABLES__SYSINDEXES.Create( _Parent: TBatpro_Element;
                                             _Classe_Elements: TBatpro_Element_Class;
                                             _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     Premier:= True;
end;

destructor ThaSYSTABLES__SYSINDEXES.Destroy;
begin
     inherited;
end;

procedure ThaSYSTABLES__SYSINDEXES.Charge;
begin
     Premier:= False;
     poolSYSINDEXES.Charge_tabid( TblSYSTABLES(Parent).tabid, slCharge);
     Ajoute_slCharge;
end;

procedure ThaSYSTABLES__SYSINDEXES.Assure_Charge;
begin
     if Premier
     then
         Charge;
end;

function ThaSYSTABLES__SYSINDEXES.MySQL_COLUMN_KEY( colno: Integer): String;
var
   blSYSINDEXES: TblSYSINDEXES;
   sIDXTYPE: String;
   idxtype: char;
begin
     Assure_Charge;
     
     //Il faudrait utiliser SYSCONSTRAINT pour savoir si c'est un primary key
     Result:= '';
     sl.Iterateur_Start;
     try
        while not sl.Iterateur_EOF
        do
          begin
          sl.Iterateur_Suivant( blSYSINDEXES);
          if blSYSINDEXES = nil          then continue;

          if     blSYSINDEXES.is_PRIMARY_KEY
             and ('U' = blSYSINDEXES.idxtype)
          then
              begin
              if    (colno = blSYSINDEXES.part1)
                 or (colno = blSYSINDEXES.part2)
                 or (colno = blSYSINDEXES.part3)
                 or (colno = blSYSINDEXES.part4)
                 or (colno = blSYSINDEXES.part5)
                 or (colno = blSYSINDEXES.part6)
                 or (colno = blSYSINDEXES.part7)
                 or (colno = blSYSINDEXES.part8)
                 or (colno = blSYSINDEXES.part9)
                 or (colno = blSYSINDEXES.part10)
                 or (colno = blSYSINDEXES.part11)
                 or (colno = blSYSINDEXES.part12)
                 or (colno = blSYSINDEXES.part13)
                 or (colno = blSYSINDEXES.part14)
                 or (colno = blSYSINDEXES.part15)
                 or (colno = blSYSINDEXES.part16)
              then
                  begin
                  Result:= 'PRI';
                  break;
                  end;
              end
          else if colno = blSYSINDEXES.part1
          then
              begin
              sIDXTYPE:= blSYSINDEXES.idxtype;
              if sIDXTYPE = ''
              then
                  idxtype:= ' '
              else
                  idxtype:= sIDXTYPE[1];

              if 'U' = idxtype
              then
                  begin
                  Result:= 'UNI';
                  break;
                  end;
              if 'D' = idxtype
              then
                  Result:= 'MUL';
              end;
          end;
     finally
            sl.Iterateur_Stop;
            end;
end;

end.


