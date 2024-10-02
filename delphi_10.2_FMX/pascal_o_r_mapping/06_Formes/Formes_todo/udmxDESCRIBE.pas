unit udmxDESCRIBE;

interface

uses
    u_sys_,
    uSGBD,
    uClean,
    uDataUtilsF,

    ublInformix_Column,

    udmDatabase,
    udmBatpro_DataModule,
    udmx,

    ufAccueil_Erreur,

  SysUtils, Classes, 
  Db, DBTables, FMTBcd, Provider, DBClient, SqlExpr,
  ucBatproVerifieur,
  ucbvQuery_Datasource;

type
 TdmxDESCRIBE
 =
  class(Tdmx)
  private
    { Déclarations privées }
  protected
    function Register_Dataset(D: TDataSet): TypeDataset; override;
  public
    { Déclarations publiques }
    function Cherche( tabname, colname: String; _GED: Boolean = False): Boolean; overload;
    function Cherche( tabname, colname, TypeColonne, Defaut: String; _GED: Boolean = False): Boolean; overload;
  end;

function dmxDESCRIBE: TdmxDESCRIBE;

implementation

{$R *.dfm}

var
   FdmxDESCRIBE: TdmxDESCRIBE;

function dmxDESCRIBE: TdmxDESCRIBE;
begin
     Clean_Get( Result, FdmxDESCRIBE, TdmxDESCRIBE);
end;

function TdmxDESCRIBE.Cherche( tabname, colname: String; _GED: Boolean = False): Boolean;
begin
     if not (sgbdMYSQL or _GED)
     then
         begin
         Result:= False;
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+sys_N+
                          'Appel de dmxDESCRIBE.Cherche sur une base non MySQL');
         exit;
         end;

     sqlq.Close;
     if _GED
     then
         sqlq.SQLConnection:= dmDatabase.sqlcGED
     else
         sqlq.SQLConnection:= dmDatabase.sqlc;

     sqlq.SQL.Text:= 'describe '+tabname+' '+ colname;
     Result:= RefreshQuery( cd);
     if Result
     then
         begin
         cd.First;
         Result:= not cd.EOF;
         end;
end;

function TdmxDESCRIBE.Cherche( tabname,colname,TypeColonne,Defaut:String;
                               _GED: Boolean = False):Boolean;
var
   LengthDefaut: Integer;
   cdType: TField;
   cdDefault: TField;
begin
     Result:= Cherche( tabname, colname, _GED);
     if Result
     then
         begin
         TypeColonne:= LowerCase( TypeColonne);

         //enlève les quotes de Defaut.
         //ne marche pas s'il y a des quotes à l'intérieur (improbable)
         LengthDefaut:= Length( Defaut);
         if LengthDefaut > 0
         then
             begin
             if    ((Defaut[1]='''') and (Defaut[LengthDefaut]=''''))
                or ((Defaut[1]='''' ) and (Defaut[LengthDefaut]='''' ))
             then
                 Defaut:= Copy(Defaut, 2, LengthDefaut-2)
             end;

         Defaut     := LowerCase( Defaut     );

         cdType   := cd.FieldByName('Type'   );
         cdDefault:= cd.FieldByName('Default');

         Result:=     (cdType   .AsString = TypeColonne)
                  and (cdDefault.AsString = Defaut     );
         end;
end;

function TdmxDESCRIBE.Register_Dataset(D: TDataSet): TypeDataset;
begin
     Result:= td_Special;
end;

initialization
              Clean_Create ( FdmxDESCRIBE, TdmxDESCRIBE);
finalization
              Clean_Destroy( FdmxDESCRIBE);
end.
