unit uPool;
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
    uSGBD,
    uBatpro_StringList,
    uLog,
    u_sys_,
    uClean,
    uuStrings,
    uVide,
    uChrono,
    ubtInteger,
    ubtString,
    uLookupConnection_Ancetre,
    ujsDataContexte,
    uChampDefinition,
    uChamp,
    uChamps,
    uCD_from_Params,
    //uDataClasses,
    uDataUtilsF,
    udmDatabase,{AUTOOPENUNIT udmDatabase}
    (*udmxG3_UTI,*)
    upool_Ancetre_Ancetre,
    uMySQL,

    uRequete,

    uBatpro_Element,
    uBatpro_Ligne,
    uPublieur,
    uhFiltre,
    (*ufProgression,*)
    ufAccueil_Erreur,
    uTri,
    uSuppression,

    uHTTP_Interface,
  {$ifdef fpc}
  blcksock, sockets, Synautil, fphttpclient,
  {$endif}
  SysUtils, Variants, Classes,
  FMTBcd, DB, mysql51conn, SQLDB, DBXpress,  Math, BufDataSet;


var
   table_sans_id: array[1..414{415}] of String=
   (
'syscolumns',
'sysconstraints',
'sysindexes',
'sysprocedures',
'systables',
'tables',
'columns',
'a_aff',
'a_aff2',
'a_bud',
'a_calc',
'a_cap',
'a_cpt',
'a_dat',
'a_dep',
'a_fg4',
'a_his',
'a_lse',
'a_pha',
'a_pla_liaison',
'a_rep',
'a_rep6',
'a_sin',
'a_voe',
'ac4_adl',
'ac4_ap1',
'ac4_ap2',
'ac4_ap3',
'ac4_apblocs',
'ac4_bloc6',
'ac4_blocs',
'ac4_cpt',
'ac4_dmd',
'ac4_msg',
'ac4_par',
'ac4_rel',
'ac4_sce',
'ac4_sig',
'ac4_w006',
'ac4_w0_1',
'ac4_w111',
'ac4_w254',
'ac4_w_11',
'ac4_wpc1',
'ac4_wver',
'am_ahisto',
'am_amort',
'am_atype',
'am_famimmo',
'b_cod',
'b_dscml',
'b_pxb',
'b_seq',
'bc_mdp',
'bom_item_part',
'bom_optim_part',
'bom_option_part',
'bp_aco',
'bp_adr',
'bp_ass',
'bp_at1',
'bp_ava',
'bp_bjour',
'bp_ccp',
'bp_cgp',
'bp_chap',
'bp_co1',
'bp_co2',
'bp_cod',
'bp_cou',
'bp_ctr',
'bp_dad2',
'bp_dads',
'bp_det',
'bp_droicp',
'bp_eap',
'bp_enf',
'bp_etr',
'bp_for',
'bp_hi1',
'bp_hi2',
'bp_inf',
'bp_nom',
'bp_ofo',
'bp_ope',
'bp_paj',
'bp_pare',
'bp_pau',
'bp_pet',
'bp_pr1',
'bp_pr2',
'bp_prof',
'bp_psa2',
'bp_qet',
'bp_rb2',
'bp_rb3',
'bp_rb4',
'bp_rb5',
'bp_rbi',
'bp_rbs',
'bp_sai0',
'bp_sit',
'bp_sitc',
'bp_smi',
'bp_st1',
'bp_st2',
'bp_sta',
'bp_tb1',
'bp_tb2',
'bp_tex',
'bp_vac',
'calc1',
'calc6',
'cg_acticom',
'cg_anahisto',
'cg_banque',
'cg_bbc',
'cg_bilan',
'cg_bloc',
'cg_bor',
'cg_budget',
'cg_chrono',
'cg_chropre',
'cg_cptcrbi',
'cg_cptgen',
'cg_cptres',
'cg_ctpart',
'cg_devise',
'cg_dossier',
'cg_effcom',
'cg_effparam',
'cg_errint',
'cg_fouregl3',
'cg_fourmagnet',
'cg_gesbil',
'cg_hbilan',
'cg_hchrono',
'cg_hcptres',
'cg_journal',
'cg_lettre',
'cg_libelle',
'cg_lignebi',
'cg_lignecr',
'cg_mdpay',
'cg_modlett',
'cg_modpaie',
'cg_note',
'cg_nouvcli',
'cg_ori',
'cg_paramagee',
'cg_parambal',
'cg_paramexe',
'cg_paramgl',
'cg_paramsdos',
'cg_parbnp',
'cg_pchrono',
'cg_poste',
'cg_radcrbi',
'cg_radtiers',
'cg_relan',
'cg_relint',
'cg_relsuite',
'cg_remche',
'cg_remisebanq',
'cg_resulselect',
'cg_rfl',
'cg_rfp',
'cg_rfp0',
'cg_rfp2',
'cg_scenario',
'cg_tempojour',
'cg_tva0',
'cg_tva2',
'cg_tvahis',
'cg_uti',
'cg_vparunip',
'client',
'co_modele',
'co_publipostage',
'code_asc',
'consultations',
'd_chap',
'd_dos',
'd_not',
'delta_client',
'devis',
'dna',
'e_far',
'e_pha',
'e_wb',
'e_wb4',
'e_wb5',
'e_ws300',
'eblocs',
'ecobat',
'ecout_mo',
'edcal',
'edescriptif',
'edescriptifml',
'edi_s',
'efdivers',
'efiltre',
'efr_gestion',
'ememoire',
'entete',
'esynthese',
'etape1',
'etape2',
'etexte',
'f5_affaire',
'f5_arh',
'f5_cfmult',
'f5_cfmult1',
'f5_cfx',
'f5_cfx2',
'f5_classe',
'f5_constante',
'f5_cpt',
'f5_degr',
'f5_effet',
'f5_encli',
'f5_lft',
'f5_mdp',
'f5_msg',
'f5_param',
'f5_pkg',
'f5_pro',
'f5_ref',
'f5_rem2',
'f5_remise',
'f5_remise1',
'f5_serifact',
'f5_speciaux',
'f5_stata',
'f5_statc',
'f5_statci',
'f5_statp',
'f5_t1',
'f5_texte',
'f5_texteh',
'f5_tpx',
'f5_trp',
'f_app',
'f_fpd',
'f_ptc',
'f_ptg1',
'f_ptg2',
'f_rpx',
'f_sit',
'f_trs',
'f_txt',
'fab_corps',
'fab_fiche',
'formule',
'g3_uti',
'g_ban2',
'g_bdom',
'g_bic',
'g_blocs',
'g_car',
'g_ccg',
'g_cex',
'g_cir',
'g_cli2',
'g_clici',
'g_clii',
'g_clirib',
'g_cor',
'g_cpt5',
'g_cpv',
'g_ctr',
'g_ctrcir',
'g_dat',
'g_dev1',
'g_dev2',
'g_doc',
'g_e1',
'g_e2',
'g_e3',
'g_fab',
'g_for',
'g_frs0',
'g_frs1',
'g_frs2',
'g_frsi',
'g_grp',
'g_hfo',
'g_i1',
'g_i2',
'g_i3',
'g_ioom',
'g_lag',
'g_msg',
'g_msq',
'g_refa',
'g_refc',
'g_rem',
'g_rfo',
'g_rfr',
'g_sepa',
'g_sepa1',
'g_tf1',
'g_tmp',
'g_ttechnal',
'g_uni',
'g_zfo',
'i_ec',
'i_rc',
'import1',
'liaison',
'ligne',
'lignes',
'list',
'logo',
'mdp',
'medecins',
'modele',
'mult',
'p_cal',
'p_cod',
'p_ftrv',
'p_ftrv1',
'p_ftrv2',
'p_ftrv3',
'p_ftrv_ch',
'p_ftrv_mo',
'p_ftrv_mtl',
'p_ftrv_mtx',
'p_maa',
'p_not',
'p_par',
'p_prz',
//'p_qlf', en cours champ id ajouté  à la main pour CLAPOT
'p_slm',
'p_tmo',
'p_trf',
'p_txi',
'p_wprc',
'p_wprc1',
'patients',
'pl_rap',
'pm_car',
'pm_cgp',
'pm_chap',
'pm_eve',
'pm_inf',
'pm_kms',
'pm_mvt',
'pr_contact',
'pr_interv',
'pr_role',
'quote',
'quote_item',
'quoteoption',
'rp_crx',
'rp_rcg',
'sav_ot',
'sav_type',
'st4_blc',
'st4_enc',
'st4_visa',
'tableau',
'versions',
'vf_dem_appro_det_v31',
'vf_dem_appro_mai_v31',
'vf_heures',
'vf_menu',
'vf_minutes',
'vf_prix',
'vf_qte',
'vf_rapport_impu',
'vf_rapport_impu_det',
'vf_rapport_salar',
'vf_rapport_salar_det',
'viteDict',
'viteDict_champ',
'vite_etat',
'vite_etat_champ',
'vitefait',
'w_cht1',
'w_deb',
'w_debm',
'w_ecr',
'w_err',
'w_etcli',
'w_gl',
'w_lig',
'w_lig1',
'w_met',
'w_point',
'w_proges2',
'w_scal',
'w_sdcharp',
'wa_calc',
'wbud',
'wcg_balance',
'we_piq',
'wfamo',
'wl',
'wost',
'wp_not',
'wreg',
'wsitu3',
'x_ce',
'x_mate',
'x_mate_genr',
'x_ouvr_fami',
'x_ouvr_list_mat',
'x_ouvr_ouvr',
'x_text_ce',
'x_text_fami',
'xlpro',
'xlpro1',
'xprov_oo',
'z_maitre'
);
slTABLE_SANS_ID: TBatpro_StringList= nil;


type
 TPool= class;

 { TLoad_sqlQuery_Context }

 TLoad_sqlQuery_Context
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _pool: TPool; _jsdc: TjsDataContexte_SQLQuery); virtual;
    destructor Destroy; override;
  //Attributs
  public
    pool: TPool;
    jsdc: TjsDataContexte_SQLQuery;
    id: Integer;
    bl: TBatpro_Ligne;
  //Traitement de la ligne courante de sqlq
  protected
    function not_loaded: Boolean; virtual;
  public
    procedure Traite_Ligne;
  end;
 TLoad_sqlQuery_Context_class= class of TLoad_sqlQuery_Context;

 { TPool }

 TPool
 =
  class( Tpool_Ancetre_Ancetre)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  //Gestion du cycle de vie
  public
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
  //Chargement par clé
  private
    jsdcSELECT: TjsDataContexte_SQLQuery;
    procedure Select( var bl);
  protected
    procedure Ajoute( var bl); //passé de private à protected pour TpoolJSON
  public
    Select_Enabled: Boolean;
  //Gestion de l'insertion
  private
    procedure Compose_INSERT;
    procedure Insert_then_Select( var bl);
  private
    jsdcCD_FROM_INSERT: TjsDataContexte_CD_from_Params;
    procedure Select_from_Insert(var bl);
  protected
    is_Base: Boolean;
    jsdcINSERT: TjsDataContexte_SQLQuery;
    function SQL_INSERT: String; virtual;
    procedure Params_INSERT; virtual;
  //Gestion de la création de l'id
  public
    dernier_id: Integer;
    dernier_id_actif: Boolean;
    function Last_Insert_id: Integer; virtual;
  //Attributs
  public
    slT: TBatpro_StringList;
    pChange, pLoad: TPublieur;
  protected
    Creer_si_non_trouve: Boolean;
    procedure To_Params( _Params: TParams); virtual;
    procedure Get_Interne( var bl; _Created: PBoolean= nil);
    procedure Get_Interne_from_Memory( var bl);
    procedure Nouveau_Interne( var bl; Source: TBatpro_Ligne= nil);
  public
    procedure Nouveau_Base( var bl); virtual;
  //Arbres binaires
  public
    btsCle: TbtString;
  //Gestion de la classe des éléments
  public
    Classe_Elements: TBatpro_Ligne_Class;       // un seule classe
    function Cree_Element( _jsdc: TjsDataContexte): TBatpro_Ligne; virtual; // permet de sélectionner des classes différentes
  //Récupération d'id
  private
    sqlqID_Recuperation: TSQLQuery;
  protected
    SQL_Recuperation: String;
  //Nom de la table
  protected
    procedure SetNomTable(const Value: String); override;
  //Chargement par id
  private
    jsdcSELECT_from_id: TjsDataContexte_SQLQuery;
    procedure _Select_from_id( _id: Integer; var bl);
  private
    IDFieldName: String;
    function sSELECT: String;
  protected
    Load_by_id_Trier        : Boolean;
    Load_by_id_TrierFiltre  : Boolean;
    Load_by_id_TrierslLoaded: Boolean;
  public
    procedure Get_Interne_from_id( _id: Integer; out bl);
    procedure Get_Interne_from_SQLid( _SQL: String; out bl; _fID: String= 'id');
    procedure Load_by_id( _jsdc: TjsDataContexte_SQLQuery;
                          slLoaded : TBatpro_StringList = nil;
                          btsLoaded: TbtString          = nil); overload;
  private
    jsdcLoad_by_id: TjsDataContexte_SQLQuery;
  public
    procedure Load_by_id( _SQL      : String                   ;
                          _slLoaded : TBatpro_StringList = nil ;
                          _btsLoaded: TbtString          = nil ;
                          _fID      : String             = 'id';
                          _Params   : TParams            = nil ); overload;
  // Load_N_rows_by_id
  public
    Load_N_rows_by_id_ORDER_BY: String;//pour contraintes éphémères sur A_PLA
    procedure Load_N_rows_by_id( _jsdc: TjsDataContexte_SQLQuery;
                                 slLoaded : TBatpro_StringList = nil;
                                 btsLoaded: TbtString          = nil;
                                 N: Integer= -1);
    //procedure Direct_Load_by_id( SQL: String;
    //                             fID: String;
    //                             slLoaded : TBatpro_StringList = nil;
    //                             btsLoaded: TbtString          = nil);
    //procedure Direct_Load_N_rows_by_id( MySQLResult: TMySQLResult;
    //                             fID: String;
    //                             slLoaded : TBatpro_StringList = nil;
    //                             btsLoaded: TbtString          = nil;
    //                             N: Integer= -1);
  //Chargement direct du contenu d'un SQLQuery
  private
    procedure Load_sqlQuery( _jsdc: TjsDataContexte_SQLQuery;
                             _slLoaded : TBatpro_StringList = nil ;
                             _btsLoaded: TbtString          = nil ;
                             _Vider    : Boolean            = True);
  protected
    Load_sqlQuery_Context_class: TLoad_sqlQuery_Context_class;
  //Chargement direct sans passer par le champ id
  private
    jsdcLoad: TjsDataContexte_SQLQuery;
  public
    procedure Load( _SQL      : String                   ;
                    _slLoaded : TBatpro_StringList = nil ;
                    _btsLoaded: TbtString          = nil ;
                    _Params   : TParams            = nil );
  //Gestion du chargement à partir de sqlq_SELECT_ALL
  public
    procedure Load_from_sqlq_SELECT_ALL(  slLoaded: TBatpro_StringList = nil;
                                         btsLoaded: TbtString          = nil;
                                         Vider: Boolean = True);
  //Chargement de toutes les lignes
  private
    sqlq_SELECT_ALL_count: TSQLQuery;
  public//en public juste pour uaA_PST
    jsdcSELECT_ALL: TjsDataContexte_SQLQuery;
    ToutCharger_SQL_suffixe: String;
    procedure Verifie_ToutCharger_SQL_suffixe;
    procedure ToutCharger_prepare_sqlq_SELECT_ALL;
    function ToutCharger_Count: Integer;
    procedure ToutCharger(  slLoaded: TBatpro_StringList = nil;
                           btsLoaded: TbtString          = nil;
                           Vider    : Boolean = True); virtual;
  //Chargement direct de toutes les lignes sans passer par le champ id
  public
    ToutCharger_direct_effectue: boolean;
    procedure ToutCharger_direct;
  //Gestion de la clé
  protected
    sCle: String;
    procedure Nouveau_from_Cle( blNouveau: TBatpro_Ligne); virtual;
  public
    procedure sCle_Change( _bl: TBatpro_Element); override;
  //Filtre
  private
    procedure hf_AfterExecute;
  public
    Classe_Filtre: ThFiltre_Class;
    hf: ThFiltre;
    slFiltre: TBatpro_StringList;
    pFiltreChange: TPublieur;
  //Tri
  private
    function  GetChampTri( NomChamp: String): Integer;
    procedure SetChampTri( NomChamp: String; const Value: Integer);
  public
    Tri: TTri;
    property ChampTri[ NomChamp: String]: Integer read GetChampTri write SetChampTri;
    procedure Reset_ChampsTri;

    procedure Set_ChampsTri( _ChampsTri: array of String);

    procedure TrierListe( StringList: TBatpro_StringList);
    procedure Trier; virtual;
    procedure TrierFiltre;

    function LibelleTri: String;
    function LibelleChampTri( NomChamp: String): String;

  //Suppression
  public
    Suppression: TSuppression;
    procedure Supprimer( var bl); override;
    procedure Decharge_Seulement( var bl);
  //Suppression par champ id
  public
    procedure Supprimer_par_id( _SQL: String;
                                _fID: String= 'id';
                                _P: TParams= nil);
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; virtual;
  //méthode d'ajout dans les listes
  protected
    procedure Ajout_Interne( bl: TBatpro_Ligne); virtual;
  //Gestion du modèle
  protected
    procedure Charge_Modele; virtual;
  public
    blModele: TBatpro_Ligne;
  //Gestion des objets pool à partir de fPool
  public
    function Titre: String;
  //Gestion du rechargement
  public
    procedure Recharger;
    procedure Recharger_Ligne( _id: Integer);
  //Vidage (principalement pour changement de société)
  public
    pVide_Avant: TPublieur;
    procedure Vide; virtual;
  //Gestion de la récupération de lignes non initialisées
  private
    Recuperer: Boolean;
  //Gestion des lookups
  public
    procedure GetLookupListItems( _Current_Key: String;
                                  _Keys, _Labels: TStrings;
                                  _Connection_Ancetre: TLookupConnection_Ancetre;
                                  _CodeId_: Boolean= False); virtual;
  // ligne nulle
  public
    procedure Cree_nul( var _bl; _Classe_Element_null: TBatpro_Ligne_Class= nil);
  //Gestion de la connection
  public
    function Connection: TDatabase; virtual;
  //Objet de requete
  public
    function r: TRequete; virtual;
  //Routines de table
  public
    procedure Vider_table;
    procedure Detruire_table;
  //Log SQL
  protected
    procedure Log( S: String);
  //Recupération de la première ligne d'une requête
  private
    slPremier: TBatpro_StringList;
  public
    procedure Get_Premier( var _bl; _SQLConstraint: String; _Order_By: String= '');
  //Statistiques sur le champ id
  public
    function idMin: Integer; virtual;
    function idMax: Integer; virtual;
  //Tableau par id
  private
    Tid_Premiere_fois: Boolean;
    Tid_offset: Integer;
    Tid: array of TBatpro_Ligne;
    procedure Tid_Initialise;
    procedure Tid_Dimensionne( _Taille: Integer);
    procedure Tid_Vide;

    function iTid_from_id( _id: Integer): Integer;
    function id_from_iTid( _iTid: Integer): Integer;
    function Tid_count: Integer;
    procedure Tid_Delete(  _id: Integer);
  protected
    Pas_de_champ_id: Boolean;
  public
    procedure S_bl_from_id( _id: Integer; out _S: String; out _bl);
    procedure bl_from_id( _id: Integer; out _bl);
    procedure Set_bl_from_id( _id: Integer; _bl: TBatpro_Ligne);
    function Iterateur_id: TIterateur;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP: Boolean; override;
  //spécial Gestion bases Microsoft Access en Freepascal
  private
    procedure SetUsePrimaryKeyAsKey( _Value: Boolean);
  public
    property UsePrimaryKeyAsKey: Boolean write SetUsePrimaryKeyAsKey;
  end;

  Tprocedure_sCle_Change= procedure ( _bl: TBatpro_Ligne) of object;

var
   slPool: TBatpro_StringList= nil;

function pool_from_sl( sl: TBatpro_StringList; Index: Integer): TPool;

procedure Reinitialise_pools;//pour passage d'informix à MySQL

var
   uPool_Vide_contexte: String = '';

procedure uPool_Vide;

implementation

{$R *.lfm}

procedure Traite_TABLE_SANS_ID;
var
   I: Integer;
begin
     slTABLE_SANS_ID:= TBatpro_StringList.Create( 'uPool.slTABLE_SANS_ID');
     for I:= Low( table_sans_id) to High( table_sans_id)
     do
       slTABLE_SANS_ID.Add( table_sans_id[I]);
end;

function pool_from_sl( sl: TBatpro_StringList; Index: Integer): TPool;
var
   O: TObject;
begin
     Result:= nil;

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     O:= sl.Objects[ Index];
     if O = nil                         then exit;
     if not (O is TPool)      then exit;

     Result:= TPool(O);
end;

procedure Reinitialise_pools;
var
   I: Integer;
   p: TPool;
begin
     for I:= 0 to slPool.Count - 1
     do
       begin
       p:= pool_from_sl( slPool, I);
       if Assigned( p)
       then
           begin
           p.NomTable:= p.NomTable;
           end;
       end;
end;

procedure uPool_Vide;
var
   I: Integer;
   p: TPool;
begin
     try
        uBatpro_Ligne_vidage_des_pools_en_cours:= True;
        //uClean_Log( 'Liste des pools');
        //for I:= 0 to slPool.Count - 1
        //do
        //  begin
        //  p:= pool_from_sl( slPool, I);
        //  if p = nil then continue;
        //  //uClean_Log( '  '+p.Name);
        //  end;
        //uClean_Log( 'Vidage des pools');
        for I:= 0 to slPool.Count - 1
        do
          begin
          p:= pool_from_sl( slPool, I);
          if p = nil then continue;
          uPool_Vide_contexte:= p.Name;
          p.Vide;
          end;
        //uClean_Log( 'Fin du vidage des pools');
     finally
            uBatpro_Ligne_vidage_des_pools_en_cours:= False;
            uPool_Vide_contexte:= '';
            end;
end;


{ TLoad_sqlQuery_Context }

constructor TLoad_sqlQuery_Context.Create( _pool: TPool;
                                           _jsdc: TjsDataContexte_SQLQuery);
begin
     inherited Create;
     pool:= _pool;
     jsdc:= _jsdc;
end;

destructor TLoad_sqlQuery_Context.Destroy;
begin

     inherited;
end;

function TLoad_sqlQuery_Context.not_loaded: Boolean;
begin
     Result:= True;

     id:= jsdc.id;
     if -1 = id then exit;

     pool.bl_from_id( id, bl);
     Result:= bl = nil;
end;

procedure TLoad_sqlQuery_Context.Traite_Ligne;
begin
     if not_loaded
     then
         begin
         bl:= pool.Cree_Element( jsdc);
         pool.Ajoute( bl);
         end;
end;

{ TdmxPool }

procedure TPool.SetUsePrimaryKeyAsKey( _Value: Boolean);
begin
     jsdcSELECT           .UsePrimaryKeyAsKey:= _Value;
     jsdcLoad             .UsePrimaryKeyAsKey:= _Value;
     jsdcSELECT_from_id   .UsePrimaryKeyAsKey:= _Value;
     sqlq_SELECT_ALL_count.UsePrimaryKeyAsKey:= _Value;
     jsdcSELECT_ALL       .UsePrimaryKeyAsKey:= _Value;
     sqlqID_Recuperation  .UsePrimaryKeyAsKey:= _Value;
     jsdcINSERT           .UsePrimaryKeyAsKey:= _Value;
     jsdcLoad_by_id       .UsePrimaryKeyAsKey:= _Value;
end;

constructor TPool.Create(AOwner: TComponent);
begin
     Load_sqlQuery_Context_class:= TLoad_sqlQuery_Context;

     jsdcSELECT        := TjsDataContexte_SQLQuery.Create(ClassName+'.jsdcSELECT'        );
     jsdcLoad          := TjsDataContexte_SQLQuery.Create(ClassName+'.jsdcLoad'          );
     jsdcSELECT_from_id:= TjsDataContexte_SQLQuery.Create(ClassName+'.jsdcSELECT_from_id');

     sqlq_SELECT_ALL_count:= TSQLQuery.Create( Self);
     sqlq_SELECT_ALL_count.Name:= 'sqlq_SELECT_ALL_count';

     jsdcSELECT_ALL    := TjsDataContexte_SQLQuery.Create(ClassName+'.jsdcSELECT_ALL');

     SQL_Recuperation:= '';
     sqlqID_Recuperation:= TSQLQuery.Create( Self);
     sqlqID_Recuperation.Name:= 'sqlqID_Recuperation';

     jsdcINSERT:= TjsDataContexte_SQLQuery.Create( ClassName+'.jsdcINSERT');

     jsdcLoad_by_id    := TjsDataContexte_SQLQuery.Create(ClassName+'.jsdcLoad_by_id');
     jsdcLoad_by_id.Create_id_field;

     Tid_Premiere_fois:= True;
     Pas_de_champ_id:= False;
     Select_Enabled:= True;
     dernier_id_actif:= False;

     jsdcCD_FROM_INSERT:= TjsDataContexte_CD_from_Params.Create(ClassName+'.jsdcCD_FROM_INSERT');

     Load_N_rows_by_id_ORDER_BY:= '';

     inherited;
end;

destructor TPool.Destroy;
begin
     Free_nil( jsdcSELECT);
     Free_nil( jsdcLoad  );
     Free_nil( jsdcSELECT_from_id);
     Free_nil( jsdcSELECT_ALL);
     Free_nil( jsdcINSERT);
     Free_nil( jsdcLoad_by_id);
     Free_nil( jsdcCD_FROM_INSERT);
     inherited;
end;
procedure TPool.DataModuleCreate(Sender: TObject);
begin
     inherited;

     slPool.AddObject( Name, Self);

     slT     := TBatpro_StringList.CreateE(ClassName+'.slT', Classe_Elements);

     btsCle:= TbtString .Create( Classe_Elements, Name+'.btsCle');

     Creer_si_non_trouve:= False;
     pChange    := TPublieur.Create( Name+'.pChange'    );
     pLoad      := TPublieur.Create( Name+'.pLoad'      );
     pVide_Avant:= TPublieur.Create( Name+'.pVide_Avant');

     slFiltre:= TBatpro_StringList.CreateE( ClassName+'.slFiltre', Classe_Elements);
     Tri:= TTri.Create;

     if Assigned( Classe_Filtre)
     then
         begin
         hf:= Classe_Filtre.Create( nil, btsCle, slFiltre, Tri);
         hf.AfterExecute:= hf_AfterExecute;
         end
     else
         hf:= nil;

     pFiltreChange:= TPublieur.Create( Name+'.pFiltreChange');

     Suppression:= TSuppression.Create( Classe_Elements);
     blModele:= nil;

    Load_by_id_Trier        := True;
    Load_by_id_TrierFiltre  := True;
    Load_by_id_TrierslLoaded:= True;
    ToutCharger_SQL_suffixe:= sys_Vide;

    Recuperer:= Trim( SQL_Recuperation) <> sys_Vide;
    if Recuperer
    then
        sqlqID_Recuperation.SQL.Text:= SQL_Recuperation;

    ToutCharger_direct_effectue:= False;

    slPremier:= TBatpro_StringList.CreateE( ClassName+'.slPremier',
                                           Classe_Elements);

    Pas_de_champ_id:= -1 <> slTABLE_SANS_ID.IndexOf( NomTable);
end;

procedure TPool.DataModuleDestroy(Sender: TObject);
var
   I: Integer;
begin

     Free_nil( slPremier);
     Free_nil( Suppression);
     Free_nil( pFiltreChange);

     Free_nil( hf);
     Free_nil( Tri);
     Free_nil( slFiltre   );

     Free_nil( pLoad      );
     Free_nil( pChange    );
     Free_nil( pVide_Avant);
     Free_nil( slT);

     Free_nil( btsCle);

     Free_nil( slT);

     I:= slPool.IndexOf( Name);
     if I <> -1
     then
         slPool.Delete( I);

     inherited;
end;

function TPool.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
        '#################################'#13#10
       +'Erreur à signaler au développeur:'#13#10
       +'  fonction '+Name+'.SQLWHERE_ContraintesChamps non codée'#13#10
       +'#################################';
end;

procedure TPool.To_Params( _Params: TParams);
begin

end;

procedure TPool.Ajoute( var bl);
begin
     Ajout_Interne( TBatpro_Ligne( bl));

     if Assigned( hf)
     then
         begin
         hf.Execute_bl( TBatpro_Ligne( bl));
         if TBatpro_Ligne( bl).Passe_le_filtre
         then
             slFiltre.AddObject( TBatpro_Ligne( bl).sCle, TBatpro_Ligne( bl));
         end;
end;

procedure TPool.Select( var bl);
begin
     TBatpro_Ligne( bl):= nil;

     if not Select_Enabled then exit;

     jsdcSELECT.Connection:= Connection;
     To_Params( jsdcSELECT.Params);
     try
        //uLog.Log.Print( Classname+' SELECT');
        //uClean_Log( Classname+' SELECT');
        if not jsdcSELECT.RefreshQuery then exit;

        if jsdcSELECT.IsEmpty then exit;

        TBatpro_Ligne( bl):= Cree_Element( jsdcSELECT);
        Ajoute( bl);
     finally
            jsdcSELECT.Close;
            end;

     pChange.Publie;
end;

procedure TPool.ToutCharger_direct;
var
   bl: TBatpro_Ligne;
begin
     if ToutCharger_direct_effectue then exit;

     Load( 'select * from '+NomTable);

     pChange.Publie;
     ToutCharger_direct_effectue:= True;
end;

procedure TPool.Load_sqlQuery( _jsdc     : TjsDataContexte_SQLQuery;
                               _slLoaded : TBatpro_StringList= nil ;
                               _btsLoaded: TbtString         = nil ;
                               _Vider    : Boolean           = True);
var
   Load_sqlQuery_Context: TLoad_sqlQuery_Context;
   bl: TBatpro_Ligne;
begin
     if _Vider
     then
         begin
         if Assigned(  _slLoaded) then  _slLoaded.Clear;
         if Assigned( _btsLoaded) then _btsLoaded.Vide;
         end;

     try
        Chrono.Stop( Name+'.Load_sqlQuery( '+_jsdc.Name+') avant exécution');
        if not _jsdc.RefreshQuery then exit;
        Chrono.Stop( Name+'.Load_sqlQuery( '+_jsdc.Name+') aprés exécution');

        if _jsdc.IsEmpty then exit;

        Load_sqlQuery_Context:= Load_sqlQuery_Context_class.Create( Self, _jsdc);
        _jsdc.First;
        while not _jsdc.Eof
        do
          begin
          Load_sqlQuery_Context.Traite_Ligne;
          bl:= Load_sqlQuery_Context.bl;
          if Assigned(  _slLoaded) then  _slLoaded.AddObject( bl.sCle, bl);
          if Assigned( _btsLoaded) then _btsLoaded.Ajoute   ( bl.sCle, bl);

          _jsdc.Next;
          end;
     finally
            _jsdc.Close;
            end;
end;

procedure TPool.Load( _SQL: String;
                      _slLoaded: TBatpro_StringList;
                      _btsLoaded: TbtString; _Params: TParams);
begin
     jsdcLoad.Connection:= Connection;
     jsdcLoad.SQL:= _SQL;
     if Assigned( _Params)
     then
         jsdcLoad.Params.Assign( _Params);

     Load_sqlQuery( jsdcLoad, _slLoaded, _btsLoaded);
end;

procedure TPool._Select_from_id( _id: Integer; var bl);
begin
     TBatpro_Ligne( bl):= nil;
     try
        if _id = 0 then exit;

        jsdcSELECT_from_id.Connection:= Connection;
        with jsdcSELECT_from_id.Params
        do
          ParamByName( 'id').AsInteger:= _id;
        if not jsdcSELECT_from_id.RefreshQuery then exit;

        if jsdcSELECT_from_id.IsEmpty then exit;

        TBatpro_Ligne( bl):= Cree_Element( jsdcSELECT_from_id);
        Ajoute( bl);
     finally
            jsdcSELECT_from_id.Close;
            end;
     // pLoad.Publie est appelé au niveau de Load_by_id
end;

procedure TPool.Select_from_Insert(var bl);
begin
     jsdcCD_FROM_INSERT._from_Params( jsdcINSERT.Params);
     TBatpro_Ligne( bl):= Cree_Element( jsdcCD_FROM_INSERT);
     Ajoute( bl);
end;

procedure TPool.Insert_then_Select(var bl);
var
   //T: TTransactionDesc;
   //Param: TParam;
	id: Integer;
begin
     (*T.TransactionID:= 1;
     T.IsolationLevel:= xilREADCOMMITTED;*)

     if not is_Base //mis au cas où, normalement is_Base = False quand on vient ici
     then
         Params_INSERT;
     (*Connection.StartTransaction( T); //pour pilote Postgres Devart*)
     try
        //uLog.Log.Print( Classname+' INSERT_THEN_SELECT');
        //uClean_Log( Classname+' INSERT_THEN_SELECT');
        jsdcINSERT.Connection:= Connection;
        if not jsdcINSERT.ExecSQLQuery then exit;
     finally
            (*Connection.Commit( T);*)
            end;

     if not Select_Enabled
     then
         begin
         id:= 0;
         if      dernier_id_actif
            and (dernier_id <> 0)
         then
             id:= dernier_id + 1
         else
             id:= Last_Insert_id;

         with jsdcINSERT.Params
         do
           ParamByName( 'id').AsInteger:= id;

         //Param:= sqlq_INSERT.Params.CreateParam( ftInteger, 'id', ptInput);
         //Param.AsInteger:= Last_Insert_id;

         Select_from_Insert( bl);

         //sqlq_INSERT.Params.RemoveParam( Param);
         dernier_id:= id;
         end
     else
         Select( bl);
end;

procedure TPool.Get_Interne_from_Memory(var bl);
begin
     _Classe_from_sl_sCle( bl, Classe_Elements, slT, sCle);
end;

procedure TPool.Get_Interne( var bl; _Created: PBoolean= nil);
begin
     if Assigned( _Created) then _Created^:= False;

     Get_Interne_from_Memory( bl);
     if Assigned( Pointer( bl)) then exit;

     Select( bl);
     if Assigned( Pointer( bl)) then exit;

     if not Creer_si_non_trouve then exit;
     Insert_then_Select( bl);
     if Assigned( _Created) then _Created^:= False;
end;

procedure TPool.Nouveau_from_Cle(blNouveau: TBatpro_Ligne);
begin

end;

procedure TPool.Nouveau_Interne(var bl; Source: TBatpro_Ligne= nil);
var
   Cible: TBatpro_Ligne;
begin
     Insert_then_Select( bl);
     if Source = nil
     then
         begin
         if blModele = nil
         then
             Charge_Modele;
         Source:= blModele;
         end;
     if     Assigned( TBatpro_Ligne( bl))
        and Assigned( Source)
     then
         begin
         Cible:= TBatpro_Ligne( bl);
         if Cible.ClassName <> Source.ClassName
         then
             fAccueil_Erreur(  'Erreur à signaler au développeur: '+sys_N
                              +'  TdmxPool.Nouveau_Interne: Cible.ClassName <> Source.ClassName'+sys_N
                              +'    La classe de la source ne correspond pas à la classe de la destination.'+sys_N
                              +'    Cible: '+Cible.ClassName+sys_N
                              +'    Source: '+Source.ClassName+sys_N)
         else
             begin
             Cible.Copy_from_( Source);

             Nouveau_from_Cle( Cible);

             Cible.Save_to_database;
             end;
         end;
end;

function TPool.Last_Insert_id: Integer;
begin
     Result:= 0;
     case SGBD
     of
       sgbd_Informix: Result:= r.LAST_INSERT_ID_INFORMIX;
       sgbd_MySQL   : Result:= r.LAST_INSERT_ID_MySQL   ;
       sgbd_Postgres: Result:= r.LAST_INSERT_ID_Postgres( NomTable);
       sgbd_SQLite3 : Result:= r.LAST_INSERT_ID_SQLite3;
       else           SGBD_non_gere( 'TPool.Last_Insert_id');
       end;
end;

procedure TPool.Nouveau_Base( var bl);
var
   _id: Integer;
begin
     _id:= 0;

     //Recherche un id d'un éventuel plantage précédent (ligne non initialisée)
     if Recuperer
     then
         begin
         sqlqID_Recuperation.Database:= Connection;
         if RefreshQuery( sqlqID_Recuperation)
         then
             begin
             sqlqID_Recuperation.First;

             _id:= sqlqID_Recuperation.FieldByName('id').AsInteger;
             end;
         end;

     //Sinon on crée une nouvelle ligne
     if _id= 0
     then
         begin
         jsdcINSERT.Connection:= Connection;
         if not is_Base //mis au cas où, normalement is_Base = True quand on vient ici
         then
             Params_INSERT;
         if jsdcINSERT.ExecSQLQuery
         then
             _id:= Last_Insert_id;
         end;
     Get_Interne_from_id( _id, bl);
end;

procedure TPool.Get_Interne_from_id( _id: Integer; out bl);
begin
     Pointer( bl):= nil;
     if _id = 0 then exit;

     bl_from_id( _id, bl);
     if Assigned( Pointer( bl)) then exit;

     _Select_from_id( _id, bl);
end;

procedure TPool.Load_from_sqlq_SELECT_ALL(  slLoaded: TBatpro_StringList = nil;
                                                      btsLoaded: TbtString          = nil;
                                                      Vider: Boolean = True);
begin
     jsdcSELECT_ALL.Connection:= Connection;
     Load_sqlQuery( jsdcSELECT_ALL, slLoaded, btsLoaded, Vider);
end;

procedure TPool.Verifie_ToutCharger_SQL_suffixe;
begin
     if     (ToutCharger_SQL_suffixe    <> sys_Vide)
        and (ToutCharger_SQL_suffixe[1] <> ' ')
     then
         ToutCharger_SQL_suffixe:= ' '+ToutCharger_SQL_suffixe;
end;

function TPool.sSELECT: String;
begin
     if     (Length( NomTable) > 3)
        //and (NomTable[1] = 's')
        //and (NomTable[2] = 'y')
        //and (NomTable[3] = 's')
        and (
               (NomTable = 'systables' )
            or (NomTable = 'syscolumns')
            or (NomTable = 'sysindexes')
            or (NomTable = 'sysconstraints')
            or (NomTable = 'source4gl' )
            or (NomTable = 'bc_mdp'    )
            or (NomTable = 'g3_uti'    )
            )
     then
         Result:= 'rowid as id,*'
     else
         Result:= '*';
end;

procedure TPool.ToutCharger_prepare_sqlq_SELECT_ALL;
begin
     Verifie_ToutCharger_SQL_suffixe;

     jsdcSELECT_ALL.SQL
     :=
       'select '+sSELECT+' from '+NomTable+ToutCharger_SQL_suffixe;

     (*dmxG3_UTI.To_SQLQuery_Params( sqlq_SELECT_ALL);*)
end;

function TPool.ToutCharger_Count: Integer;
begin
     Verifie_ToutCharger_SQL_suffixe;

     sqlq_SELECT_ALL_count.Database:= Connection;
     sqlq_SELECT_ALL_count.SQL.Text
     :=
       'select count(*) as Resultat from '+NomTable+ToutCharger_SQL_suffixe;
     (*dmxG3_UTI.To_SQLQuery_Params( sqlq_SELECT_ALL_count);*)
     if not RefreshQuery( sqlq_SELECT_ALL_count)
     then
         Result:= 0
     else
         Result:= sqlq_SELECT_ALL_count.FieldByName('Resultat').AsInteger;
end;

procedure TPool.ToutCharger(  slLoaded: TBatpro_StringList = nil;
                              btsLoaded: TbtString          = nil;
                              Vider: Boolean = True);
begin
     try
        ToutCharger_prepare_sqlq_SELECT_ALL;
        Load_from_sqlq_SELECT_ALL( slLoaded, btsLoaded, Vider);
     except
           on E: Exception
           do
             begin
             fAccueil_Erreur(  'Dans TPool.ToutCharger, exception '+E.ClassName+#13#10
                              +E.Message);
             raise;
             end;
           end;
end;

procedure TPool.Load_N_rows_by_id( _jsdc: TjsDataContexte_SQLQuery;
                                   slLoaded: TBatpro_StringList;
                                   btsLoaded: TbtString;
                                   N: Integer);
var
   I: Integer;
   ID_a_charger: Boolean;
   bl: TBatpro_Ligne;
   sID, sIDs: String;
   iID, NbIDs: Integer;
   //NBDataset, NBCharges: Integer;
   procedure Traite_sqlqLoad_N_rows_by_id;
   var
      jsdcLoad_N_rows_by_id: TjsDataContexte_SQLQuery;
   begin
        if sIDs = sys_Vide then exit;

        jsdcLoad_N_rows_by_id:= TjsDataContexte_SQLQuery.Create( ClassName+'.Load_N_rows_by_id::Traite_sqlqLoad_N_rows_by_id::jsdcLoad_N_rows_by_id');
        try
           jsdcLoad_N_rows_by_id.Connection:= Connection;

           jsdcLoad_N_rows_by_id.SQL
           :=
              'select '+sSELECT
             +' from '+NomTable
             +' where '+IDFieldName+' in ('+sIDs+')'
             +Load_N_rows_by_id_ORDER_BY;

           try
              Load_sqlQuery( jsdcLoad_N_rows_by_id, slLoaded, btsLoaded, False);
           except
                 on E: Exception
                 do
                   begin
                   fAccueil_Erreur(  'Dans TPool.Load_N_rows_by_id'
                                    +'.Traite_sqlqLoad_N_rows_by_id, exception '
                                    +E.ClassName+#13#10
                                    +E.Message);
                   raise;
                   end;
                 end;

           sIDs:= sys_Vide;
           NbIDs:= 0;
        finally
               Free_nil( jsdcLoad_N_rows_by_id);
               end;
   end;
   function Pas_de_limite: Boolean;
   begin
        Result:= N = -1;
   end;
   function Continuer: Boolean;
   begin
        Result:= not _jsdc.Eof;
        if not Result then exit;

        Result:= Pas_de_limite;
        if Result then exit;

        Result:= I < N;
   end;
begin
     try
        if Pas_de_limite
        then
            begin
            if Assigned(  slLoaded) then  slLoaded.Clear;
            if Assigned( btsLoaded) then btsLoaded.Vide;
            end;

        //NBDataset:= 0;
        //NBCharges:= 0;
        sIDs:= sys_Vide;
        NbIDs:= 0;
        I:= 0;
        while Continuer
        do
          begin
          iID:= _jsdc.id;
          sID:= IntToStr( iID);
          ID_a_charger:= Tid_Premiere_fois;
          if not ID_a_charger
          then
              begin
              bl_from_id( iID, bl);
              ID_a_charger:= bl = nil;
              end;
          if ID_a_charger
          then
              begin
              if sIDs <> sys_Vide then sIDs:= sIDs + ',';
              sIDs:= sIDs+ ''''+sID+'''';
              Inc( NbIDs);
              //Inc( NBCharges);
              end
          else
              begin
              if Assigned(  slLoaded) then  slLoaded.AddObject( bl.sCle, bl);
              if Assigned( btsLoaded) then btsLoaded.Ajoute   ( bl.sCle, bl);
              end;

          if NbIDs > 1000
          then
              Traite_sqlqLoad_N_rows_by_id;

          //Inc( NBDataset);
          _jsdc.Next;
          Inc( I);
          end;

        Traite_sqlqLoad_N_rows_by_id;

        if Load_by_id_Trier
        then
            begin
            Trier;
            Load_by_id_Trier:= False;
            end;
        if Load_by_id_TrierFiltre
        then
            begin
            TrierFiltre;
            Load_by_id_TrierFiltre:= False;
            end;

        if     Load_by_id_TrierslLoaded
           and Assigned(slLoaded)
        then
            begin
            TrierListe( slLoaded);
            Load_by_id_TrierslLoaded:= False;
            end;

        //if Name = 'poolG_FAM'
        //then
        //    fAccueil_Erreur(  'Fin poolG_FAM.Load_N_rows_by_id');
        //AfficheRequete( sqlq_SELECT_ALL);
        Chrono.Stop( Name+'.Load_N_rows_by_id( '+_jsdc.Name+') fin (avant publication)');
     finally
            pLoad.Publie;
            end;
end;

procedure TPool.Load_by_id( _jsdc: TjsDataContexte_SQLQuery;
                            slLoaded: TBatpro_StringList = nil;
                            btsLoaded: TbtString          = nil);
begin
     //Direct_Load_by_id( TSQLQuery(Dataset).SQL.Text, 'id', slLoaded, btsLoaded);
     //exit;

     Chrono.Stop( Name+'.Load_by_id( '+_jsdc.Name+') début');
     if not _jsdc.RefreshQuery then exit;
     Chrono.Stop( Name+'.Load_by_id( '+_jsdc.Name+') aprés exécution de '+_jsdc.Name);

     _jsdc.First;
     Load_N_rows_by_id( _jsdc, slLoaded, btsLoaded);
     _jsdc.Close;
     Chrono.Stop( Name+'.Load_by_id( '+_jsdc.Name+') aprés Load_N_rows_by_id');
end;

procedure TPool.Load_by_id( _SQL      : String                   ;
                            _slLoaded : TBatpro_StringList = nil ;
                            _btsLoaded: TbtString          = nil ;
                            _fID      : String             = 'id';
                            _Params   : TParams            = nil);
begin
     jsdcLoad_by_id.Connection:= Connection;
     jsdcLoad_by_id.SQL:= _SQL;
     if Assigned( _Params)
     then
         jsdcLoad_by_id.Params.Assign( _Params);
     (*sqlqLoad_by_id.ParamCheck:= Assigned( _Params);*)
     jsdcLoad_by_id.id_FielName:= _fID;
     //if Assigned( _Params)
     //then
     //    AfficheRequete( sqlqLoad_by_id);
     Load_by_id( jsdcLoad_by_id, _slLoaded, _btsLoaded);
end;

//procedure TPool.Direct_Load_N_rows_by_id( MySQLResult: TMySQLResult;
//                                                     fID: String;
//                                                     slLoaded: TBatpro_StringList;
//                                                     btsLoaded: TbtString;
//                                                     N: Integer);
//var
//   I: Integer;
//   ID_a_charger: Boolean;
//   bl: TBatpro_Ligne;
//   sID, sIDs: String;
//   iID, NbIDs: Integer;
//   //NBDataset, NBCharges: Integer;
//   procedure Traite_sqlq_SELECT_ALL;
//   begin
//        if sIDs = sys_Vide then exit;
//
//        //if Name = 'poolG_FAM'
//        //then
//        //    fAccueil_Log(  'poolG_FAM.Load_N_rows_by_id'#13#10
//        //                  +sIDS);
//
//        ToutCharger_SQL_suffixe:= ' where '+IDFieldName+' in ('+sIDs+')';
//
//        Chrono.Stop( Name+'.Direct_Load_N_rows_by_id.Traite_sqlq_SELECT_ALL, avant ToutCharger');
//        ToutCharger( slLoaded, btsLoaded, False);
//        Chrono.Stop( Name+'.Direct_Load_N_rows_by_id.Traite_sqlq_SELECT_ALL, aprés ToutCharger');
//        sIDs:= sys_Vide;
//        NbIDs:= 0;
//   end;
//   function Pas_de_limite: Boolean;
//   begin
//        Result:= N = -1;
//   end;
//   function Continuer: Boolean;
//   begin
//        Result:= not MySQLResult.Eof;
//        if not Result then exit;
//
//        Result:= Pas_de_limite;
//        if Result then exit;
//
//        Result:= I < N;
//   end;
//begin
//     Chrono.Stop( Name+'.Direct_Load_N_rows_by_id, début');
//     try
//        if Pas_de_limite
//        then
//            begin
//            if Assigned(  slLoaded) then  slLoaded.Clear;
//            if Assigned( btsLoaded) then btsLoaded.Vide;
//            end;
//
//        //NBDataset:= 0;
//        //NBCharges:= 0;
//        sIDs:= sys_Vide;
//        NbIDs:= 0;
//        I:= 0;
//        while Continuer
//        do
//          begin
//          sID:= MySQLResult.FieldValueByName( fID);
//          iID:= StrToInt( sID);
//          ID_a_charger:= Tid_Premiere_fois;
//          if not ID_a_charger
//          then
//              begin
//              bl_from_id( iID, bl);
//              ID_a_charger:= bl = nil;
//              end;
//          if ID_a_charger
//          then
//              begin
//              if sIDs <> sys_Vide then sIDs:= sIDs + ',';
//              sIDs:= sIDs+ ''''+sID+'''';
//              Inc( NbIDs);
//              //Inc( NBCharges);
//              end
//          else
//              begin
//              if Assigned(  slLoaded) then  slLoaded.AddObject( bl.sCle, bl);
//              if Assigned( btsLoaded) then btsLoaded.Ajoute   ( bl.sCle, bl);
//              end;
//
//          if NbIDs > 1000
//          then
//              Traite_sqlq_SELECT_ALL;
//
//          //Inc( NBDataset);
//          MySQLResult.Next;
//          Inc( I);
//          end;
//
//        Traite_sqlq_SELECT_ALL;
//
//        if Load_by_id_Trier
//        then
//            begin
//            Trier;
//            Load_by_id_Trier:= False;
//            end;
//        if Load_by_id_TrierFiltre
//        then
//            begin
//            TrierFiltre;
//            Load_by_id_TrierFiltre:= False;
//            end;
//
//        if     Load_by_id_TrierslLoaded
//           and Assigned(slLoaded)
//        then
//            begin
//            TrierListe( slLoaded);
//            Load_by_id_TrierslLoaded:= False;
//            end;
//
//        //if Name = 'poolG_FAM'
//        //then
//        //    fAccueil_Erreur(  'Fin poolG_FAM.Load_N_rows_by_id');
//        //AfficheRequete( sqlq_SELECT_ALL);
//        Chrono.Stop( Name+'.Direct_Load_N_rows_by_id( MySQLResult) fin (avant publication)');
//     finally
//            pLoad.Publie;
//            end;
//end;

//procedure TPool.Direct_Load_by_id( SQL: String;
//                                              fID: String;
//                                              slLoaded: TBatpro_StringList;
//                                              btsLoaded: TbtString);
//var
//   MysqlClient: TMysqlClient;
//   MysqlResult: TMysqlResult;
//   MysqlResult_OK: Boolean;
//   Hostname_Port, Hostname, sPort: string;
//   Port: Integer;
//begin
//     Chrono.Stop( Name+'.Direct_Load_by_id, début');
//     MysqlClient:= TMysqlClient.Create;
//     Chrono.Stop( Name+'.Direct_Load_by_id, aprés TMysqlClient.Create');
//     try
//        Hostname_Port:= MySQL.HostName;
//        Hostname:= StrTok( ':', Hostname_Port);
//        sPort   := Hostname_Port;
//
//        if     ('' = sPort)
//            or not TryStrToInt( sPort, Port)
//        then
//            Port:= 3306;
//
//        MysqlClient.connect( Hostname,
//                             MySQL.User_Name,
//                             MySQL.Password ,
//                             MySQL.DataBase,
//                             Port
//                             );
//        Chrono.Stop( Name+'.Direct_Load_by_id, aprés MysqlClient.connect');
//        try
//           MysqlResult:= MysqlClient.query( SQL, True, MysqlResult_OK);
//           Chrono.Stop( Name+'.Direct_Load_by_id, aprés MysqlClient.query');
//           if MysqlResult = nil then exit;
//
//           MysqlResult.First;
//
//           Direct_Load_N_rows_by_id( MysqlResult, fID, slLoaded, btsLoaded);
//           Chrono.Stop( Name+'.Direct_Load_by_id, aprés Direct_Load_N_rows_by_id');
//
//        finally
//               MysqlClient.close;
//               Chrono.Stop( Name+'.Direct_Load_by_id, aprés MysqlClient.close;');
//               end;
//     finally
//            Free_nil( MysqlClient);
//            end;
//end;

procedure TPool.hf_AfterExecute;
begin
     pFiltreChange.Publie;
end;

procedure TPool.TrierListe( StringList: TBatpro_StringList);
begin
     Tri.Execute( StringList);
end;

procedure TPool.Trier;
begin
     TrierListe( slT);
end;

procedure TPool.TrierFiltre;
begin
     TrierListe( slFiltre);
end;

procedure TPool.Reset_ChampsTri;
begin
     Tri.Reset_ChampsTri;
end;

function TPool.GetChampTri( NomChamp: String): Integer;
begin
     Result:= Tri.ChampTri[ NomChamp];
end;

procedure TPool.SetChampTri( NomChamp: String; const Value: Integer);
begin
     Tri.ChampTri[ NomChamp]:= Value;
end;

procedure TPool.Set_ChampsTri( _ChampsTri: array of String);
var
   I: Integer;
begin
     Reset_ChampsTri;
     for I:= Low( _ChampsTri) to High( _ChampsTri)
     do
       ChampTri[ _ChampsTri[I]]:= +1;
end;

function TPool.LibelleChampTri( NomChamp: String): String;
begin
     Result:= Tri.LibelleChampTri( NomChamp);
end;

function TPool.LibelleTri: String;
begin
     Result:= Tri.LibelleTri;
end;

procedure TPool.Supprimer( var bl);
begin
     Set_bl_from_id( TBatpro_Ligne( bl).id, nil);
     Suppression.Execute( btsCle,[ slT, slFiltre], bl);
end;

procedure TPool.Decharge_Seulement( var bl);
begin
     Set_bl_from_id( TBatpro_Ligne( bl).id, nil);
     Suppression.Decharge_Seulement( btsCle,[ slT, slFiltre], bl);
end;

function TPool.Cree_Element( _jsdc: TjsDataContexte): TBatpro_Ligne;
begin
     Result:= Classe_Elements.Create( slT, _jsdc, Self);
end;

procedure TPool.sCle_Change( _bl: TBatpro_Element);
var
   bl: TBatpro_Ligne;
   procedure Traite( _sl: TBatpro_StringList);
   var
      I: Integer;
   begin
        I:= _sl.IndexOfObject( bl);
        if I <> -1
        then
            _sl.Strings[I]:= bl.sCle;
   end;
begin
     if _bl = nil                  then exit;
     if not (_bl is TBatpro_Ligne) then exit;

     bl:= TBatpro_Ligne( _bl);

     btsCle.Objet_Remove( bl);

     btsCle.Ajoute( bl.sCle, bl);

     Traite( slT);
     Traite( slFiltre);
end;

procedure TPool.Ajout_Interne( bl: TBatpro_Ligne);
begin
     slT.AddObject( TBatpro_Ligne( bl).sCle, TBatpro_Ligne( bl));

     Set_bl_from_id( TBatpro_Ligne( bl).id  , bl);
     btsCle.Ajoute( TBatpro_Ligne( bl).sCle, TBatpro_Ligne( bl));
end;

procedure TPool.SetNomTable(const Value: String);
var
   SQL: String;
begin
     FNomTable := Value;

     if (*    (Length( NomTable) > 3) à réactiver quand il n'y aura plus le pb avec a_not
        and (NomTable[1] = 's')
        and (NomTable[2] = 'y')
        and (NomTable[3] = 's')
        and *)(
               (NomTable = 'systables' )
            or (NomTable = 'syscolumns')
            or (NomTable = 'sysindexes')
            or (NomTable = 'sysconstraints')
            )
     then
         IDFieldName:= 'rowid'
     else
         IDFieldName:= 'id';

     SQL:=  'select        '#13#10
           +'      *       '#13#10
           +'from          '#13#10
           +'    '+NomTable+#13#10
           +SQLWHERE_ContraintesChamps;
     jsdcSELECT.SQL:= SQL;

     jsdcSELECT_from_id.SQL
     :=
         'select        '#13#10
        +'      *       '#13#10
        +'from          '#13#10
        +'    '+NomTable+#13#10
        +'where         '#13#10
        +'     '+IDFieldName+' = :id ';

     Compose_INSERT;
end;

function TPool.SQL_INSERT: String;
begin
     is_Base:= True;//True pour appeler insertion par id seul (pas d'appel à To_SQLQuery_Params)
     case SGBD
     of
       sgbd_SQLite3: Result:= 'insert into '+NomTable+' default values';
       else          Result:= 'insert into '+NomTable+'(id) values (0)';
     end;
end;

procedure TPool.Compose_INSERT;
var
   SQL: String;
begin
     SQL:= SQL_INSERT;

     jsdcINSERT.SQL:= SQL;
end;

procedure TPool.Params_INSERT;
begin
     To_Params ( jsdcINSERT.Params);
end;

procedure TPool.Charge_Modele;
begin

end;

function TPool.Titre: String;
var
   NbLignes: Integer;
   Libelle: String;
   sNbLignes: String;
begin
     NbLignes:= btsCle.Count;
     Libelle  := Fixe_Min( NomTable, 20);
     sNbLignes:= Fixe_Min( IntToStr( NbLignes), 10);
     Result:=Format( '%s %s lignes chargées, id de %d à %d', [Libelle, sNbLignes, idMin, idMax]);
end;

procedure TPool.Recharger;
var
   I: TIterateur;
   blID,
   bl: TBatpro_Ligne;

   SQL, sIDs: String;
   NbIDs: Integer;
   procedure Traite_sqlq_SELECT_ALL;
   begin
        if sIDs = sys_Vide then exit;

        SQL:=  'select * from '+NomTable+' where id in ('+sIDs+')';

        jsdcSELECT_ALL.Connection:= Connection;
        jsdcSELECT_ALL.SQL:= SQL;
        if not jsdcSELECT_ALL.RefreshQuery then exit;
        jsdcSELECT_ALL.First;
        while not jsdcSELECT_ALL.EOF
        do
          begin
          bl_from_id( jsdcSELECT_ALL.id, bl);
          if Assigned( bl)
          then
              bl.Recharge( jsdcSELECT_ALL);

          jsdcSELECT_ALL.Next;
          end;
        sIDs:= sys_Vide;
        NbIDs:= 0;
   end;
begin
     sIDs:= sys_Vide;

     try
        I:= slT.Iterateur_interne;
        while I.Continuer
        do
          begin
          if I.not_Suivant_interne( blID) then continue;

          if sIDs <> sys_Vide then sIDs:= sIDs + ',';
          sIDs:= sIDs+ ''''+blID.sCle_ID+'''';
          Inc( NbIDs);
          if NbIDs > 1000
          then
              Traite_sqlq_SELECT_ALL;
          end;

        Traite_sqlq_SELECT_ALL;
     finally
            pChange.Publie;
            end;
end;

procedure TPool.Recharger_Ligne( _id: Integer);
var
   bl: TBatpro_Ligne;
begin
     bl_from_id( _id, bl);
     if bl = nil then exit;

     try
        jsdcSELECT_from_id.Connection:= Connection;
        with jsdcSELECT_from_id.Params
        do
          ParamByName( 'id').AsInteger:= _id;
        if not jsdcSELECT_from_id.RefreshQuery then exit;

        if jsdcSELECT_from_id.IsEmpty then exit;

        bl.Recharge( jsdcSELECT_from_id);

     finally
            jsdcSELECT_from_id.Close;
            pChange.Publie;
            end;
end;

procedure TPool.Vide;
var
   bl: TBatpro_Ligne;
   I: TIterateur;
   sClean_Log_Start: String;
begin
     //uClean_Log( '  '+Name+':TPool.Vide début');
     pVide_Avant.Publie;
     //uClean_Log( '   aprés pVide_Avant.Publie');

     //while slT.Count > 0
     //do
     //  begin
     //  bl:= Batpro_Ligne_from_sl( slT, 0);
     //  if bl = nil
     //  then
     //      slT.Delete( 0)
     //  else
     //      Decharge_Seulement( bl);
     //  end;

     //sClean_Log_Start:= ClassName+':TPool.Vide;'+IntToStr(slT.Count)+' lignes Start';
     //uClean_Log_Start( sClean_Log_Start);
     I:= slT.Iterateur_interne;

     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;
       I.Supprime_courant;
       bl_nil( bl);
       end;

     //uClean_Log_Succes( sClean_Log_Start);

     //uClean_Log( '   avant slT.Clear');
     slT     .Clear;
     //uClean_Log( '   avant slFiltre.Clear');
     slFiltre.Clear;
     //uClean_Log( '   avant btsCle.Clear');
     btsCle.Vide;
     //uClean_Log( '  '+Name+':TPool.Vide fin');
     Tid_Vide;
end;

procedure TPool.GetLookupListItems( _Current_Key: String;
                                    _Keys, _Labels: TStrings;
                                    _Connection_Ancetre: TLookupConnection_Ancetre;
                                    _CodeId_: Boolean= False);
var
   bl: TBatpro_Ligne;
   TraiterContraintes: Boolean;
   Connection: TLookupConnection;
   LigneConvient: Boolean;
   sKey: String;
begin
     _Keys  .Clear;
     _Labels.Clear;

     TraiterContraintes:= Assigned( _Connection_Ancetre);
     if TraiterContraintes
     then
         Connection:= _Connection_Ancetre as TLookupConnection
     else
         Connection:= nil;

     try
        btsCle.Iterateur_Start;
        while not btsCle.Iterateur_EOF
        do
          begin
          btsCle.Iterateur_Suivant( bl);
          if Assigned( bl)
          then
              begin
              LigneConvient:= True;
              if TraiterContraintes
              then
                  LigneConvient:= LigneConvient and Connection.Convient( bl);

              if LigneConvient
              then
                  begin
                  if _CodeId_
                  then
                      sKey:= bl.GetCode
                  else
                      sKey:= IntToStr(bl.id);

                  _Keys  .Add( sKey);
                  _Labels.Add( bl.GetLibelle);
                  end;
              end;
          end;
     finally
            btsCle.Iterateur_Stop;
            end;
end;

procedure TPool.Cree_nul( var _bl; _Classe_Element_null: TBatpro_Ligne_Class);
begin
     TBatpro_Ligne( _bl):= _Classe_Element_null.Create( slT, nil, Self);
end;

function TPool.Connection: TDatabase;
begin
     Result:= dmDatabase.sqlc;
end;

procedure TPool.Vider_table;
begin
     dmDatabase.DoCommande( 'truncate '+NomTable);
end;

procedure TPool.Detruire_table;
begin
     dmDatabase.DoCommande( 'drop table '+NomTable);
end;

procedure TPool.Supprimer_par_id( _SQL: String;
                                          _fID: String= 'id';
                                          _P: TParams= nil);
var
   bl: TBatpro_Ligne;
   Log_erreurs: String;
begin
     jsdcLoad_by_id.Connection:= Connection;
     jsdcLoad_by_id.SQL:= _SQL;
     if Assigned( _P)
     then
         jsdcLoad_by_id.Params.Assign( _P);
     (*sqlqLoad_by_id.ParamCheck:= Assigned( _P);*)
     jsdcLoad_by_id.id_FielName:= _fID;

     if not jsdcLoad_by_id.RefreshQuery then exit;
     try
        Log_erreurs:= '';
        jsdcLoad_by_id.First;
        while not jsdcLoad_by_id.Eof
        do
          begin
          try
             Get_Interne_from_id( jsdcLoad_by_id.id, bl);
             if Assigned(bl)
             then
                 Supprimer( bl);
          except
                on E: Exception
                do
                  Formate_Liste( Log_erreurs, #13#10, E.Message);
                end;
          jsdcLoad_by_id.Next;
          end;
     finally
            jsdcLoad_by_id.Close;
            end;
     if Log_erreurs <> ''
     then
         fAccueil_Erreur( Log_erreurs,
                          'Des erreurs se sont produites pendant la suppression');
end;

procedure TPool.Log( S: String);
begin
     S:= FormatDateTime( 'ddddd tt', Now)+' '+Name+#13#10+S;
     Log_SQL.Log( S);
end;

procedure TPool.Get_Premier( var _bl; _SQLConstraint: String; _Order_By: String= '');
var
   SQL: String;
   Order_by: String;

   select: String;
   procedure compose_select;
   const
        sAsc = ' asc' ;
        sDesc= ' desc';
   var
      iAsc, iDesc: Integer;
      function Get_iAsc: Integer;
      begin
           iAsc:= Pos( sAsc, select);
           Result:= iAsc;
      end;
      function Get_iDesc: Integer;
      begin
           iDesc:= Pos( sDesc, select);
           Result:= iDesc;
      end;
   begin
        select:= LowerCase( _Order_By);
        while Get_iAsc  <> 0 do Delete( select, iAsc , Length( sAsc ));
        while Get_iDesc <> 0 do Delete( select, iDesc, Length( sDesc));
        if select <> ''
        then
            select:= ', '+select;
   end;
begin
     if _Order_By = ''
     then
         Order_by:= ''
     else
         Order_by:= ' order by '+_Order_By;

     compose_select;

     if dmDatabase_IsMySQL
     then
         SQL
         :=
            'select id'+select+' from '+NomTable
           +' where '+_SQLConstraint
           +Order_by
           +' limit 1'
     else
         SQL
         :=
            'select first 1 id'+select+' from '+NomTable
           +' where '+_SQLConstraint
           +Order_by;

     Load_by_id( SQL, slPremier);
     TBatpro_Ligne( _bl):= nil;
     slPremier.Iterateur_Start;
     try
        slPremier.Iterateur_Suivant( _bl);
     finally
            slPremier.Iterateur_Stop;
            end;
end;

procedure TPool.Get_Interne_from_SQLid( _SQL: String; out bl; _fID: String= 'id');
var
   id: Integer;
begin
     TBatpro_Ligne( bl):= nil;
     if Requete.Integer_from( _SQL, _fID, id)
     then
         Get_Interne_from_id( id, bl);
end;

function TPool.idMin: Integer;
begin
     Result:= 0;
     if Pas_de_champ_id then exit;

     try
        Requete.Integer_from('select Min(id) as id from '+NomTable,'id',Result);
     except
           on Exception do Result:= 0;
           end;
end;

function TPool.idMax: Integer;
begin
     Result:= 0;
     if Pas_de_champ_id then exit;

     try
        Requete.Integer_from('select Max(id) as id from '+NomTable,'id',Result);
     except
           on Exception do Result:= 0;
           end;
end;

function TPool.Tid_count: Integer;
begin
     Result:= Length( Tid);
end;

procedure TPool.Tid_Vide;
begin
     SetLength( Tid, 0);
end;

procedure TPool.Tid_Dimensionne(_Taille: Integer);
var
   OldTaille: Integer;
   I: Integer;
begin
     OldTaille:= Length( Tid);
     SetLength( Tid, _Taille);

     for I:= OldTaille to High(Tid)
     do
       Tid[I]:= nil;
end;

procedure TPool.Tid_Initialise;
var
   Taille: Integer;
begin
     Tid_offset:= idMin;
     Taille:= idMax + 1000;
     Tid_Dimensionne( Taille);
     Tid_Premiere_fois:= False;
end;

function TPool.id_from_iTid( _iTid: Integer): Integer;
begin
     Result:= Tid_offset + _iTid;
end;

function TPool.iTid_from_id( _id: Integer): Integer;
var
   iTid: Integer;
begin
     Result:= -1;

     iTid:= _id - Tid_offset;

     if iTid < Low( Tid) then exit;
     if iTid > High( Tid)
     then
         begin
         Tid_Dimensionne( Max( iTid+1, Length(Tid)+1000 ));
         if iTid > High( Tid) then exit;
         end;

     Result:= iTid;
end;

procedure TPool.S_bl_from_id( _id: Integer; out _S: String; out _bl);
var
   iTid: Integer;
begin
     TBatpro_Ligne( _bl):= nil;
     _S:= '';
     if Pas_de_champ_id then exit;

     if Tid_Premiere_fois then Tid_Initialise;

     iTid:= iTid_from_id( _id);
     if iTid = -1 then exit;

     _S:= IntToStr( _id);
     TBatpro_Ligne( _bl):= Tid[ iTid];
end;

procedure TPool.bl_from_id( _id: Integer; out _bl);
var
   iTid: Integer;
begin
     TBatpro_Ligne( _bl):= nil;
     if Pas_de_champ_id then exit;

     if Tid_Premiere_fois then Tid_Initialise;

     iTid:= iTid_from_id( _id);
     if iTid = -1 then exit;

     TBatpro_Ligne( _bl):= Tid[ iTid];
end;

procedure TPool.Set_bl_from_id( _id: Integer; _bl: TBatpro_Ligne);
var
   iTid: Integer;
begin
     if Pas_de_champ_id then exit;

     if Tid_Premiere_fois then Tid_Initialise;

     iTid:= iTid_from_id( _id);
     if iTid = -1 then exit;

     if    Assigned( _bl)
        and( not (_bl is Classe_Elements))
     then
         exit;

     Tid[ iTid]:= _bl;
end;

procedure TPool.Tid_Delete( _id: Integer);
begin
     Set_bl_from_id( _id, nil);
end;

function TPool.Iterateur_id: TIterateur;
begin
     Result:= TIterateur.Create( ClassName+'.Iterateur_id',
                                 Tid_count,
                                 S_bl_from_id, Tid_Delete, False);
end;

function TPool.Traite_HTTP: Boolean;
   function http_ToutCharger: Boolean;
   begin
        ToutCharger();
        HTTP_Interface.Send_JSON( slT.JSON);
        Result:= True;
   end;
   function http_Get: Boolean;
   var
      sID: String;
      id: Integer;
      bl: TBatpro_Ligne;
   begin
        sID:= HTTP_Interface.uri;
        Result:= TryStrToInt( sID, id);
        if not Result then exit;

        Get_Interne_from_id( id, bl);
        Result:= Assigned( bl);
        if not Result then exit;

        HTTP_Interface.Send_JSON( bl.JSON);
   end;
   function http_Set: Boolean;
   var
      sID: String;
      id: Integer;
      JSON: String;
      bl: TBatpro_Ligne;
   begin
        sID:= StrToK( '&',HTTP_Interface.uri);
        JSON:= DecodeURLElement( HTTP_Interface.uri);

        Result:= TryStrToInt( sID, id);
        if not Result then exit;

        Get_Interne_from_id( id, bl);
        Result:= Assigned( bl);
        if not Result then exit;

        bl.JSON:= JSON;
        HTTP_Interface.Send_JSON( bl.JSON);
   end;
begin
          if '' = HTTP_Interface.uri         then Result:= http_ToutCharger
     else if HTTP_Interface.Prefixe( '_Get') then Result:= http_Get
     else if HTTP_Interface.Prefixe( '_Set') then Result:= http_Set
     else                                         Result:= False;
end;

function TPool.r: TRequete;
begin
     Result:= uRequete.Requete;
end;

initialization
              slPool:= TBatpro_StringList.Create;
              Traite_TABLE_SANS_ID;
finalization
              Free_nil( slTABLE_SANS_ID);
              Free_nil( slPool);
end.

select
      information_schema.TABLES.TABLE_SCHEMA, information_schema.TABLES.TABLE_NAME
from
    information_schema.TABLES
    left join information_schema.COLUMNS
    on
          information_schema.TABLES.TABLE_SCHEMA=information_schema.COLUMNS.TABLE_SCHEMA
      and information_schema.TABLES.TABLE_NAME  =information_schema.COLUMNS.TABLE_NAME
      and information_schema.COLUMNS.COLUMN_NAME= "id"
where
     information_schema.COLUMNS.COLUMN_NAME is null
and information_schema.TABLES.TABLE_SCHEMA = "a"
