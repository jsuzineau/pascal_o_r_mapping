unit ublSYSDICO_ENT;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uPatternHandler,
    uMenuHandler,
    uGlobal,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
    ujpNom_de_la_table ,
    ujpNom_de_la_classe,
    ujpSQL_CREATE_TABLE,
    ujpChamps_persistants,
    ujpContenus,
    ujpDocksDetails_Affiche,
    ujpLabelsDFM,
    ujpLabelsPAS,
    ujpChamp_EditDFM,
    ujpChamp_EditPAS,
    ujpAffecte,

    uClean,
    uSGBD,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uChamp,
    uDataClasses,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
    ublSYSDICO_LIG,
    ublSYSDICO_REL,
    ublSYSTABLES,
    ublSYSINDEXES,
    udmDatabase,
    upoolSYSTABLES,
    upoolSYSDICO_LIG,
    upoolSYSDICO_REL,
    upoolSYSINDEXES,
  SysUtils, Classes, DB, Grids, IniFiles, uOD_Forms, Dialogs;

type
 TblSYSDICO_ENT
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    tabname: String;
    libelle: String;
    entete: String;
    pied: String;

  //aggrégations faibles
  public
    blSYSTABLES: TblSYSTABLES;
    slSYSDICO_LIG: TBatpro_StringList;
    slSYSDICO_REL: TBatpro_StringList;
    slSYSINDEXES: TBatpro_StringList;
    procedure ChargeDetails;
  //Gestion de la clé
  public
    class function sCle_from_( _tabname: String): String;

    function sCle: String; override;
  //Génération de code
  public
    procedure Genere_Delphi;
  end;

function blSYSDICO_ENT_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSDICO_ENT;
function blSYSDICO_ENT_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSDICO_ENT;
function sg_blSYSDICO_ENT( sg: TStringGrid; Colonne, Ligne: Integer): TblSYSDICO_ENT;

type
 TGenerateur_de_code
 =
  class
  private
    a: array of TJoinPoint;
    procedure Initialise( _a: array of TJoinPoint);
  public
    blSYSDICO_ENT: TblSYSDICO_ENT;
    procedure Execute( _blSYSDICO_ENT: TblSYSDICO_ENT);
  end;

var
   Generateur_de_code: TGenerateur_de_code= nil;

implementation

uses uChamps;

function blSYSDICO_ENT_from_sl( sl: TBatpro_StringList; Index: Integer): TblSYSDICO_ENT;
begin
     _Classe_from_sl( Result, TblSYSDICO_ENT, sl, Index);
end;

function blSYSDICO_ENT_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSYSDICO_ENT;
begin
     _Classe_from_sl_sCle( Result, TblSYSDICO_ENT, sl, sCle);
end;

function sg_blSYSDICO_ENT( sg: TStringGrid; Colonne, Ligne: Integer): TblSYSDICO_ENT;
var
   be: TBatpro_Element;
begin
     Result:= nil;

     be:= Batpro_Element_from_sg( sg, Colonne, Ligne);
     if be = nil then exit;
     if not (be is TblSYSDICO_ENT) then exit;

     Result:=TblSYSDICO_ENT( be);
end;

{ TblSYSDICO_ENT }

constructor TblSYSDICO_ENT.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
   cTABNAME     ,
   cLIBELLE     ,
   cENTETE      ,
   cPIED        : TChamp;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SYSDICO_ENT';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'sysdico_ent';

     //champs persistants
     cTABNAME     := Champs.  String_from_String ( tabname        , 'tabname'        , True);
     cLIBELLE     := Champs.  String_from_String ( libelle        , 'libelle'        );
     cENTETE      := Champs.  String_from_       ( entete         , 'entete'         );
     cPIED        := Champs.  String_from_       ( pied           , 'pied'           );


     //Aggrégations faibles
     if sgbdINFORMIX
     then
         blSYSTABLES:= poolSYSTABLES.Get_by_Cle( tabname)
     else
         blSYSTABLES:= nil;

     //Gestion de la visibilité
     cTABNAME     .Definition.Visible:= True ;
     cLIBELLE     .Definition.Visible:= True ;
     cENTETE      .Definition.Visible:= False;
     cPIED        .Definition.Visible:= False;


     //Détails
     slSYSDICO_LIG:= nil;
     slSYSDICO_REL:= nil;
     slSYSINDEXES := nil;
end;

destructor TblSYSDICO_ENT.Destroy;
begin
     Free_nil( slSYSDICO_LIG);
     Free_nil( slSYSDICO_REL);
     Free_nil( slSYSINDEXES );
     inherited;
end;

class function TblSYSDICO_ENT.sCle_from_( _tabname: String): String;
begin
     Result:=  Fixe_Min( _tabname, 18);
end;

function TblSYSDICO_ENT.sCle: String;
begin
     Result:= sCle_from_( tabname);
end;

procedure TblSYSDICO_ENT.ChargeDetails;
    procedure Assure_StringList_Vide( var StringList: TBatpro_StringList;
                                      _Nom: String; _ClasseElements: TClass);
    begin
         if StringList = nil
         then
             StringList:= TBatpro_StringList.CreateE( _Nom, _ClasseElements)
         else
             StringList.Clear;
    end;
begin
     Assure_StringList_Vide( slSYSDICO_LIG, ClassName+'.slSYSDICO_LIG', TblSYSDICO_LIG);
     Assure_StringList_Vide( slSYSDICO_REL, ClassName+'.slSYSDICO_REL', TblSYSDICO_REL);
     Assure_StringList_Vide( slSYSINDEXES , ClassName+'.slSYSINDEXES' , TblSYSINDEXES );

     poolSYSDICO_LIG.Charge_tabname( tabname          , slSYSDICO_LIG);
     poolSYSDICO_REL.Charge_tabname( tabname          , slSYSDICO_REL);

     if blSYSTABLES = nil then exit;
     poolSYSINDEXES .Charge_tabid  ( blSYSTABLES.tabid, slSYSINDEXES );
end;

procedure TblSYSDICO_ENT.Genere_Delphi;
begin
     Generateur_de_code.Execute( Self);
end;

{ TGenerateur_de_code }

procedure TGenerateur_de_code.Execute( _blSYSDICO_ENT: TblSYSDICO_ENT);
const
     sys_Vide                 = '';

     s_Order_By_Key           = '      Order_By_Key';

     s_Traite_Index_key       ='{Traite_Index_key}';
var
   NomFichierProjet: String;
   cc: TContexteClasse;
   sTaggedValues: String;

   sRepSource, sRepCible, sRepParametres: String;

   Order_By_Key: String;

   Traite_Index_key
                             :String;

   phPAS_DMCRE,
   phPAS_POOL ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DKD  ,

   phDFM_DMCRE,
   phDFM_POOL ,
   phDFM_F    ,
   phDFM_FCB  ,
   phDFM_DKD  ,

   phDFM_FD   ,
   phPAS_FD   ,

   phPAS_BL   ,
   phPAS_HF   ,
   phPAS_TC   ,
   phDPK      : TPatternHandler;
   slParametres: TBatpro_StringList;

   MenuHandler: TMenuHandler;

   INI: TIniFile;


   nfLibelle : String;
   nfOrder_By: String;
   nfIndex   : String;
   slLibelle :TStringList;
   slOrder_By:TStringList;
   slIndex   :TStringList;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   slChamps_non_order_by: TStringList;

   procedure CreePatternHandler( var phPAS, phDFM: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.dfm',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_BL( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'ubl'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_HF( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'uhf'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_TC( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'utc'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible+'dunit\',slParametres);
   end;

   procedure CreePatternHandler_DPK( var phDPK: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'p'+s_Nom_de_la_classe;
        phDPK:= TPatternHandler.Create( sRepRacine+'.dpk',sRepCible,slParametres);
   end;

   procedure Traite_LIG( _bl: TblSYSDICO_LIG);
   var
      cm: TContexteMembre;
      sParametre: String;
      sDeclarationParametre: String;
   begin
        cm:= TContexteMembre.Create( cc, _bl.colname, _bl.blSYSCOLUMNS.sType, _bl.libelle);
        try
           uJoinPoint_VisiteMembre( cm, a);

           sParametre:= ' _'+cm.sNomChamp;
           sDeclarationParametre:= sParametre+': '+cm.sTyp;
           finally
                  FreeAndNil( cm);
                  end;
   end;
   procedure Produit;
   var
      RepertoirePaquet: String;
   begin
        RepertoirePaquet:= 'p'+cc.Nom_de_la_classe+'\';

        phPAS_DMCRE.Produit( '');
        phPAS_POOL .Produit( RepertoirePaquet);
        phPAS_F    .Produit( '');
        phPAS_FCB  .Produit( '');
        phPAS_DKD  .Produit( '');

        phDFM_DMCRE.Produit( '');
        phDFM_POOL .Produit( RepertoirePaquet);
        phDFM_F    .Produit( '');
        phDFM_FCB  .Produit( '');
        phDFM_DKD  .Produit( '');

        phDFM_FD   .Produit( RepertoirePaquet);
        phPAS_FD   .Produit( RepertoirePaquet);

        phPAS_BL   .Produit( RepertoirePaquet);
        phPAS_HF   .Produit( RepertoirePaquet);
        phPAS_TC   .Produit( '');
        phDPK      .Produit( RepertoirePaquet);
   end;
   function Allowed_in_order_by( NomChamp: String): Boolean;
   begin
        Result:= -1 = slChamps_non_order_by.IndexOf( NomChamp);
   end;
   procedure Visite;
   var
      I: TIterateur;
      J: Integer;
      blSYSDICO_LIG: TblSYSDICO_LIG;
   begin
        blSYSDICO_ENT.ChargeDetails;
        cc:= TContexteClasse.Create( blSYSDICO_ENT.tabname,
                                     blSYSDICO_ENT.slSYSDICO_LIG.Count);
        try
           slChamps_non_order_by.Clear;
           slParametres.Clear;

           uJoinPoint_Initialise( cc, a);

           Traite_Index_key         := '';

           I:= blSYSDICO_ENT.slSYSDICO_LIG.Iterateur_interne;
           while I.Continuer
           do
             begin
             if I.not_Suivant_interne( blSYSDICO_LIG) then continue;
             Traite_LIG( blSYSDICO_LIG);
             end;

           //Gestion du libellé
           slLibelle:= TStringList.Create;
           try
              nfLibelle:= sRepParametres+cc.Nom_de_la_classe+'.libelle.txt';
              if FileExists( nfLibelle)
              then
                  slLibelle.LoadFromFile( nfLibelle);
           finally
                  slLibelle.SaveToFile( nfLibelle);
                  FreeAndNil( slLibelle);
                  end;

           //Gestion de l'order by
           slOrder_by:= TStringList.Create;
           try
              nfOrder_By:= sRepParametres+cc.Nom_de_la_classe+'.order_by.txt';
                   if FileExists( nfOrder_By)
              then
                  slOrder_by.LoadFromFile( nfOrder_By)
              else if FileExists( nfLibelle)
              then
                  slOrder_by.LoadFromFile( nfLibelle);

              Order_By_Key:= '';
              for J:= 0 to slOrder_by.Count-1
              do
                begin
                if Allowed_in_order_by( slOrder_by.Strings[J])
                then
                    begin
                    if Order_By_Key = sys_Vide
                    then Order_By_Key:= Order_By_Key+ '      '
                    else Order_By_Key:= Order_By_Key+ ','+s_SQL_saut+'      ';
                    Order_By_Key:= Order_By_Key + slOrder_by.Strings[J];
                    end;
                end;
              if Order_By_Key = sys_Vide
              then
                  Order_By_Key:= '      Numero';
           finally
                  slOrder_by.SaveToFile( nfOrder_By);
                  FreeAndNil( slOrder_by);
                  end;

           //Gestion des détails
           slDetails:= TStringList.Create;
           try
              nfDetails:= sRepParametres+cc.Nom_de_la_classe+'.Details.txt';
              if FileExists( nfDetails)
              then
                  slDetails.LoadFromFile( nfDetails);
              NbDetails:= slDetails.Count;
              for J:= 0 to NbDetails-1
              do
                uJoinPoint_VisiteDetail( slDetails.Names[J],
                                         slDetails.ValueFromIndex[J],
                                         a);
           finally
                  slDetails.SaveToFile( nfDetails);
                  FreeAndNil( slDetails);
                  end;

           //Fermeture des chaines
           uJoinPoint_Finalise( a);

           slParametres.Values[s_Order_By_Key  ]:= Order_By_Key  ;
           slParametres.Values[s_Traite_Index_key       ]:= Traite_Index_key;
           uJoinPoint_To_Parametres( slParametres, a);

           Produit;
           //slLog.Add( 'aprés Produit');
           //csMenuHandler.Add( cc.NomTable, NbDetails = 0, cc.CalculeSaisi_);
           //slLog.Add( 'MenuHandler.Add');
        finally
               FreeAndNil( cc)
               end;
   end;
begin
     blSYSDICO_ENT:= _blSYSDICO_ENT;
     NomFichierProjet:= uOD_Forms_EXE_Name;
     INI
     :=
       TIniFile.Create( ChangeFileExt(EXE_INI.FileName,'_Generateur_de_code.ini'));
     try
        sRepSource    := INI.ReadString( 'Options', 'sRepSource', ExtractFilePath(NomFichierProjet)+'Generateur_de_code\patterns\');
        sRepParametres:= INI.ReadString( 'Options', 'sRepParametres', ExtractFilePath(NomFichierProjet)+'Generateur_de_code\Parametres\');
        sRepCible     := INI.ReadString( 'Options', 'sRepCible' , ExtractFilePath(NomFichierProjet)+'Generateur_de_code\Source\');
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );

        slParametres:= TBatpro_StringList.Create;
        slLog.Clear;
        try
           CreePatternHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmxcre');
           CreePatternHandler( phPAS_POOL , phDFM_POOL , 'pool'  );
           CreePatternHandler( phPAS_F    , phDFM_F    , 'f'     );
           CreePatternHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'   );
           CreePatternHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'   );
           CreePatternHandler( phPAS_FD  , phDFM_FD  , 'fd'   );
           CreePatternHandler_BL( phPAS_BL);
           CreePatternHandler_HF( phPAS_HF);
           CreePatternHandler_TC( phPAS_TC);
           CreePatternHandler_DPK( phDPK);
           MenuHandler:= TMenuHandler.Create( sRepSource, sRepCible);

           slChamps_non_order_by:= TStringList.Create;
           try
              S:= '';
              Premiere_Classe:= True;

              Visite;

              //csMenuHandler.Produit;
              slLog.Add( S);
           finally
                  FreeAndNil( slChamps_non_order_by);
                  FreeAndNil( MenuHandler);
                  FreeAndNil( phPAS_DMCRE);
                  FreeAndNil( phPAS_POOL );
                  FreeAndNil( phPAS_F    );
                  FreeAndNil( phPAS_FCB  );
                  FreeAndNil( phPAS_DKD  );

                  FreeAndNil( phDFM_DMCRE);
                  FreeAndNil( phDFM_POOL );
                  FreeAndNil( phDFM_F    );
                  FreeAndNil( phDFM_FCB  );
                  FreeAndNil( phDFM_DKD  );

                  FreeAndNil( phDFM_FD  );
                  FreeAndNil( phPAS_FD  );

                  FreeAndNil( phPAS_BL   );
                  FreeAndNil( phPAS_HF   );
                  FreeAndNil( phPAS_TC   );
                  end;
        finally
               slLog.SaveToFile( sRepCible+'suPatterns_from_MCD.log');
               FreeAndNil( slParametres);
               end;
     finally
            FreeAndNil( INI);
            end;
end;

procedure TGenerateur_de_code.Initialise(_a: array of TJoinPoint);
var
   I: Integer;
begin
     SetLength( a, Length(_a));
     for I:= Low( _a) to High( _a)
     do
       a[I]:= _a[I];
end;

initialization
              Generateur_de_code:= TGenerateur_de_code.Create;
              Generateur_de_code.Initialise(
                                           [
                                           jpChamps_persistants   ,
                                           jpContenus             ,
                                           jpDocksDetails_Affiche ,
                                           jpSQL_CREATE_TABLE     ,
                                           jpNom_de_la_classe    ,
                                           jpNom_de_la_table,
                                           jpLabelsDFM,
                                           jpLabelsPAS,
                                           jpChamp_EditDFM,
                                           jpChamp_EditPAS,
                                           jpAffecte
                                           ]
                                           );
finalization
              FreeAndNil( Generateur_de_code);
end.


