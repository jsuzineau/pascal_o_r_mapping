unit uhDessinnateurWeb;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014-2016 Jean SUZINEAU - MARS42                                       |
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
    uClean,
    uPublieur,
    ubtString,
    uOD_Temporaire,
    uBatpro_StringList,
    u_sys_,
    u_ini_,
    uSVG,
    uVide,
    uChamp,
    uEXE_INI,

    uBatpro_Element,
    ubeClusterElement,
    ubeCurseur,
    ubeString,
    ubeSerie,
    uBatpro_Ligne,

    uDrawInfo,

  SysUtils,Classes, DOM, Types, FPCanvas;

type
 TypeCellule= (tc_Semaine, tc_Equipe, tc_ESequence, tc_A_PLA, tc_Date, tc_hDessinnateurWeb,
               tc_BP_SAL, tc_Case, tc_Cluster, tc_NULL);


 //non affecté considéré comme colonne de l'équipe nulle

 ThDessinnateurWeb = class;
 ThDessinnateurWeb_Colonnes = class;
 ThDessinnateurWeb_Colonne
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _hd: ThDessinnateurWeb;
                        _hdcs: ThDessinnateurWeb_Colonnes;
                        _inikey, _Titre, _Libelle: String;
                        _Classe_Elements: TClass); reintroduce;
    destructor Destroy; override;
  //Attributs
  protected
    inikey: String;
    bsTitre: TbeString;
  protected
    hd  : ThDessinnateurWeb;
    hdcs: ThDessinnateurWeb_Colonnes;
    Libelle: String;
  public
    Colonne: Integer;
    slLignes     : TBatpro_StringList;
  //Visibilité de la colonne
  private
    procedure Visible_Change;
  public
    Visible: Boolean;
  //Méthodes
  public
    procedure Vide; virtual;
    procedure hd_Charge;
  //Placement d'un objet à une ligne donnée
  private
    function Offset_Ligne_Titre: Integer;
    function Offset_Ligne: Integer;
  public
    procedure Place( _Ligne: Integer; _O: TObject);
  end;

 TIterateur_hDessinnateurWeb_Colonne
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: ThDessinnateurWeb_Colonne);
    function  not_Suivant( var _Resultat: ThDessinnateurWeb_Colonne): Boolean;
  end;

 Tsl_hDessinnateurWeb_Colonne
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_hDessinnateurWeb_Colonne;
    function Iterateur_Decroissant: TIterateur_hDessinnateurWeb_Colonne;
  end;

 TbeSeparation_verticale
 =
  class( TbeSerie)
  public
    function VerticalHorizontal_( Contexte: Integer): Boolean; override;
  end;

 ThDessinnateurWeb_Colonnes
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  protected
    OffsetColonne: Integer;
  public
    OffsetTitresColonnes: Integer;
    sl: Tsl_hDessinnateurWeb_Colonne;
  //Méthodes
  public
    NbColonnes_visibles: Integer;
    procedure Ajoute( _c: ThDessinnateurWeb_Colonne);
    procedure AssureLongueur( _Longueur: Integer; _sCle: String);
    procedure Vide;
    procedure hd_Charge;
    function Count: Integer;
    procedure Calcule_Indexes;
  //Lignes de séparation horizontale
  public
    beSeparation: TbeSerie;
    procedure Ajoute_Separation;
  //Lignes de séparation verticale
  public
    beSeparation_verticale: TbeSeparation_verticale;
  end;

 ThDessinnateurWeb
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _Contexte: Integer;
                        _Titre: String;
                        _PopupDefaut: TPopupMenu);
    destructor Destroy; override;
  //Divers
  protected
    FTitre: String;
    Legende: array of String;
    function GetTitre: String; virtual;
    function DoImprime( unhdTable:ThDessinnateurWeb; RowCountMin: Integer;
                        HMax: Boolean;
                        _sLegende_ligne_1: String;
                        _aLegende_ligne_2: array of String):Boolean;
    procedure EnregistrerSous_interne( NomFichier: String);
  public
    DI: TDrawInfo;
    sg: TStringGridWeb;
    PopupDefaut: TPopupMenu;

    //Variables MouseMove
    MMColonne, MMLigne: Integer;
    MMbe: TBatpro_Element;

    function Typ(Col, Row: Integer): TypeCellule; virtual;
    function GetCell( Contexte: Integer): String; override;
    function sg_be( Colonne, Ligne: Integer): TBatpro_Element;
    function Cell_Height( _Colonnne, _Ligne, _Cell_Width: Integer): Integer; reintroduce;
    function hdCell: String;
    procedure Refresh;
    property Titre: String read GetTitre write FTitre;
    function Imprime: Boolean; virtual;
    function EnregistrerSous: Boolean;
  //Affichage
  public
    procedure DrawCell_Table; virtual;
    procedure DrawCell_Table_Defaut; virtual;
  //Affichage
  public
    Font: TFont;
    Canvas: TCanvas;
    procedure svgDrawCell_Table; virtual;
    procedure svgDrawCell_Table_Defaut; virtual;
    function svgDraw: String; reintroduce;
    function html: String;
    procedure Test_html;
  //Dimensionnement
  public
    procedure Initialise_dimensions( _ColonneDebut: Integer= 0);
    procedure Traite_Hauteurs_Lignes;
    procedure Traite_Largeurs_Colonnes( _ColonneDebut: Integer= 0;
                                        _ColonneFin  : Integer= -1);
    procedure Egalise_Largeurs_Colonnes( ColonneDebut, ColonneFin: Integer);
    procedure Ajuste_Largeur_Client( _ColonneDebut: Integer= 0);
    procedure Traite_Dimensions; virtual;
  //Impression
  public
    procedure Traite_Ratio;
  //Chargement de cellule
  public
    procedure Charge_Cell( be:TBatpro_Element; Colonne,Ligne:Integer);
  //Chargement de listes
  public
    procedure Charge_Ligne  ( _sl: TBatpro_StringList; OffsetColonne,Ligne: Integer;
                              ClusterAddInit_: Boolean= False); overload;
    procedure Charge_Colonne( _sl: TBatpro_StringList; Colonne,OffsetLigne: Integer); overload;
    procedure Charge_Colonne( beEntete:TBatpro_Element; _sl: TBatpro_StringList;
                              Colonne,OffsetLigne: Integer); overload;
  //Chargement de d'arbres binaires
  public
    procedure Charge_Ligne  ( bts: TbtString; OffsetColonne,Ligne: Integer;
                              ClusterAddInit_: Boolean= False); overload;
    procedure Charge_Colonne( bts: TbtString; Colonne,OffsetLigne: Integer); overload;
    procedure Charge_Colonne( beEntete:TBatpro_Element; bts: TbtString;
                              Colonne,OffsetLigne: Integer); overload;
  //Rafraichissement
  protected
    slCE: TBatpro_StringList;
    procedure _from_pool_interne; virtual;
  public
    procedure Vide; virtual;
    procedure _from_pool; virtual;
    procedure Clusterise;
  //Gestion souris et Drag / Drop
  protected
    function  Drag_from_( ACol, ARow: Integer): Boolean; virtual;
    function  Drop_from_XY( _X, _Y: Integer): Boolean; virtual;
  public
    Drag_Colonne, Drag_Ligne,
    Drop_Colonne, Drop_Ligne: Integer;
    pDrag: TPublieur;
  //Gestion Curseur
  private
    FCurseur_Colonne: Integer;
    procedure SetCurseur_Colonne(const Value: Integer);
  protected
    beCurseur: TbeCurseur;
    procedure Cache_Curseur;
    procedure Montre_Curseur;
  public
    property Curseur_Colonne: Integer read FCurseur_Colonne write SetCurseur_Colonne;
    function GotoXY( _Colonne, _Ligne: Integer): Boolean;
  //Recherche d'un objet sur une ligne
  public
    function Colonne_of( _be: TBatpro_Element; _Ligne: Integer): Integer;
  //Gestion de l'exécution
  protected
    Execute_running: Boolean;//juste entre PreExecute et PostExecute
    procedure PreExecute; virtual;
    procedure PostExecute; virtual;
  //Affichage de déboguage
  public
    Debug_Hint: Boolean;
  end;

 ThDessinnateurWebArray= array of ThDessinnateurWeb;
 PhDessinnateurWebArray= ^ThDessinnateurWebArray;

 Tfunction_fBatproReport_Execute= function ( unhdTable:ThDessinnateurWeb; RowCountMin: Integer;
                                             HMax: Boolean;
                                             _sLegende_ligne_1: String;
                                             _aLegende_ligne_2: array of String;
                                             _nColumnHeaderDebut: Integer = 0;
                                             _nColumnHeaderFin  : Integer = 1;
                                             _Bande_Titre: Boolean = True;
                                             _Paysage: Boolean= True):Boolean;
var
   function_fBatproReport_Execute: Tfunction_fBatproReport_Execute= nil;

procedure uhDessinnateurWeb_Demarre_Animation;

procedure uhDessinnateurWeb_Termine_Animation;

implementation

uses Math;

procedure uhDessinnateurWeb_Demarre_Animation;
begin
     //ufBatpro_Form_Demarre_Animation;
end;

procedure uhDessinnateurWeb_Termine_Animation;
begin
     //ufBatpro_Form_Termine_Animation;
end;

{ ThDessinnateurWeb_Colonne }

constructor ThDessinnateurWeb_Colonne.Create( _hd: ThDessinnateurWeb;
                                           _hdcs: ThDessinnateurWeb_Colonnes;
                                           _inikey, _Titre, _Libelle: String;
                                           _Classe_Elements: TClass);
var
   cVisible: TChamp;
begin
     hd     := _hd;
     hdcs   := _hdcs;
     inikey     := _inikey;
     Libelle:= _Libelle;

     inherited Create( hdcs.sl, nil, nil);

                Ajoute_String ( Libelle, 'Libelle', False);
     cVisible:= Ajoute_Boolean( Visible, 'Visible', False);
     cVisible.OnChange.Abonne( Self, Visible_Change);

     bsTitre:= TbeString.Create( nil, _Titre, clWhite, bea_Gauche);
     slLignes:=TBatpro_StringList.CreateE(ClassName+'('+_Titre+').slLignes',_Classe_Elements);
     Colonne:= -1;
     Visible:= EXE_INI.ReadBool( ini_Options, ClassName+'_'+inikey, True);
end;

destructor ThDessinnateurWeb_Colonne.Destroy;
begin
     EXE_INI.WriteBool( ini_Options, ClassName+'_'+inikey, Visible);

     Free_nil( bsTitre);
     Free_nil( slLignes);
     inherited;
end;

function ThDessinnateurWeb_Colonne.Offset_Ligne_Titre: Integer;
begin
     Result:= hdcs.OffsetTitresColonnes;
end;

function ThDessinnateurWeb_Colonne.Offset_Ligne: Integer;
begin
     Result:= Offset_Ligne_Titre+1;
end;

procedure ThDessinnateurWeb_Colonne.hd_Charge;
begin
     if not Visible then exit;

     hd.Charge_Cell   ( bsTitre , Colonne, Offset_Ligne_Titre);
     hd.Charge_Colonne( slLignes, Colonne, Offset_Ligne      );
end;

procedure ThDessinnateurWeb_Colonne.Vide;
begin
     slLignes.Efface;
end;

procedure ThDessinnateurWeb_Colonne.Visible_Change;
begin
     hd._from_pool;
end;

procedure ThDessinnateurWeb_Colonne.Place( _Ligne: Integer; _O: TObject);
begin
     uBatpro_Element.Place( slLignes,
                         _Ligne-Offset_Ligne,
                         '',
                         _O,
                         ClassName+'.Place( '+IntToStr(_Ligne)+')',
                         False);
end;

{ TIterateur_hDessinnateurWeb_Colonne }

function TIterateur_hDessinnateurWeb_Colonne.not_Suivant( var _Resultat: ThDessinnateurWeb_Colonne): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_hDessinnateurWeb_Colonne.Suivant( var _Resultat: ThDessinnateurWeb_Colonne);
begin
     Suivant_interne( _Resultat);
end;

{ Tsl_hDessinnateurWeb_Colonne }

constructor Tsl_hDessinnateurWeb_Colonne.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, ThDessinnateurWeb_Colonne);
end;

destructor Tsl_hDessinnateurWeb_Colonne.Destroy;
begin
     inherited;
end;

class function Tsl_hDessinnateurWeb_Colonne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_hDessinnateurWeb_Colonne;
end;

function Tsl_hDessinnateurWeb_Colonne.Iterateur: TIterateur_hDessinnateurWeb_Colonne;
begin
     Result:= TIterateur_hDessinnateurWeb_Colonne( Iterateur_interne);
end;

function Tsl_hDessinnateurWeb_Colonne.Iterateur_Decroissant: TIterateur_hDessinnateurWeb_Colonne;
begin
     Result:= TIterateur_hDessinnateurWeb_Colonne( Iterateur_interne_Decroissant);
end;

{ TbeSeparation_verticale }

function TbeSeparation_verticale.VerticalHorizontal_( Contexte: Integer): Boolean;
begin
     Result:= True;
end;

{ ThDessinnateurWeb_Colonnes }

constructor ThDessinnateurWeb_Colonnes.Create;
begin
     inherited;
     OffsetColonne:= 0;
     OffsetTitresColonnes:= 0;

     sl:= Tsl_hDessinnateurWeb_Colonne.Create( ClassName+'.sl');

     beSeparation:= TbeSerie.Create( nil, ss_TraitEpais);
     beSeparation.Serie.CellDebut:= True;

     beSeparation_verticale:= TbeSeparation_verticale.Create( nil, ss_TraitEpais);
     beSeparation_verticale.Serie.CellDebut:= True;

     NbColonnes_visibles:= 0;
end;

destructor ThDessinnateurWeb_Colonnes.Destroy;
begin
     Free_nil( beSeparation_verticale);
     Free_nil( beSeparation);
     Free_nil( sl);
     inherited;
end;

procedure ThDessinnateurWeb_Colonnes.Ajoute( _c: ThDessinnateurWeb_Colonne);
var
   Index: Integer;
   L: Integer;
begin
     Index:= sl.AddObject( '', _c);
     _c.Colonne:= OffsetColonne+Index;
     L:= Count+1;
     beSeparation.Serie.Ajoute    ( -1, L);
     beSeparation.Serie.SetVisible( -1, L);
end;

procedure ThDessinnateurWeb_Colonnes.Ajoute_Separation;
var
   it: TIterateur_hDessinnateurWeb_Colonne;
   c: ThDessinnateurWeb_Colonne;
begin
     it:= sl.Iterateur;
     while it.Continuer
     do
       begin
       it.Suivant( c);
       if  c= nil then continue;

       c.slLignes.AddObject( sys_Vide, beSeparation);
       end;
end;

procedure ThDessinnateurWeb_Colonnes.AssureLongueur( _Longueur: Integer; _sCle: String);
var
   it: TIterateur_hDessinnateurWeb_Colonne;
   c: ThDessinnateurWeb_Colonne;
begin
     it:= sl.Iterateur;
     while it.Continuer
     do
       begin
       it.Suivant( c);
       if  c= nil then continue;

       uBatpro_Element.AssureLongueur( c.slLignes, _Longueur, _sCle);
       end;
end;

procedure ThDessinnateurWeb_Colonnes.Vide;
var
   it: TIterateur_hDessinnateurWeb_Colonne;
   c: ThDessinnateurWeb_Colonne;
begin
     it:= sl.Iterateur;
     while it.Continuer
     do
       begin
       it.Suivant( c);
       if  c= nil then continue;

       c.Vide;
       end;
end;

procedure ThDessinnateurWeb_Colonnes.hd_Charge;
var
   it: TIterateur_hDessinnateurWeb_Colonne;
   c: ThDessinnateurWeb_Colonne;
begin
     it:= sl.Iterateur;
     while it.Continuer
     do
       begin
       it.Suivant( c);
       if  c= nil then continue;

       c.hd_Charge;
       end;
end;

function ThDessinnateurWeb_Colonnes.Count: Integer;
begin
     Result:= sl.Count;
end;

procedure ThDessinnateurWeb_Colonnes.Calcule_Indexes;
var
   it: TIterateur_hDessinnateurWeb_Colonne;
   c: ThDessinnateurWeb_Colonne;
   Index: Integer;
begin
     NbColonnes_visibles:= 0;
     it:= sl.Iterateur;
     Index:= 0;
     while it.Continuer
     do
       begin
       it.Suivant( c);
       if  c= nil then continue;
       if not c.Visible then continue;

       c.Colonne:= OffsetColonne+Index;
       Inc( Index);
       Inc( NbColonnes_visibles);
       end;
end;

{ ThDessinnateurWeb }

constructor ThDessinnateurWeb.Create( _Contexte: Integer;
                                      _Titre: String;
                                      _PopupDefaut: TPopupMenu);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         CP.Titre:= 'Gestionnaire de grille de '+_Titre;

     inherited Create( nil);

     Debug_Hint:= False;

     FTitre:= _Titre;
     SetLength( Legende, 0);
     sg:= TStringGridWeb.Create;

     Fond:= clBtnFace;
     PopupDefaut:= _PopupDefaut;
     MMColonne:= -1;
     MMLigne  := -1;
     Drag_Colonne:= -1;
     Drag_Ligne:= -1;

     DI:= TDrawInfo.Create( _Contexte, sg);
     slCE:= TBatpro_StringList.CreateE( ClassName+'.slCE', TbeClusterElement);

     beCurseur:= TbeCurseur.Create( nil);
     Curseur_Colonne:= -1;

     pDrag:= TPublieur.Create( 'ThDessinnateurWeb.pDrag');
     Canvas:= nil;
     Font:= TFont.Create;
end;

destructor ThDessinnateurWeb.Destroy;
begin
     Free_nil( Font);
     Free_nil( Canvas);
     Free_nil( pDrag);

     Detruit_StringList( slCE);

     Free_nil( DI);
     Free_nil( sg);
     inherited;
end;

procedure ThDessinnateurWeb.DrawCell_Table_Defaut;
begin
     DI.Dessine_Fond;
end;

procedure ThDessinnateurWeb.DrawCell_Table;
var
   be: TBatpro_Element;
begin
     be:= sg_be( DI.Col, DI.Row);
     if DI.SVG_Drawing
     then
         begin
         if Assigned(be)
         then
             be.svgDraw( DI)
         else
             svgDrawCell_Table_Defaut;
         end
     else
         begin
         DI.Traite_Grille_impression( uBatpro_Element_Afficher_Grille);
         if Assigned(be)
         then
             be.Draw( DI)
         else
             DrawCell_Table_Defaut;
         end;

end;

procedure ThDessinnateurWeb.svgDrawCell_Table;
begin
     {svg}DrawCell_Table;
end;

procedure ThDessinnateurWeb.svgDrawCell_Table_Defaut;
var
   Couleur: TColor;
begin
     if DI.Gris
     then
         Couleur:= DI.Couleur_Jour_Non_Ouvrable
     else
         Couleur:= DI.Fond;
     DI.rect_uni( DI.Rect, Couleur);
end;

function ThDessinnateurWeb.Typ( Col, Row: Integer): TypeCellule;
begin
     if (Col < 0) or (Row < 0)
     then
         Result:= tc_NULL
     else
         if (Row = 0) and (sg.FixedRows > 0)
         then
             Result:= tc_hDessinnateurWeb
         else
             Result:= tc_Case;
end;

{
procedure ThDessinnateurWeb.sgDrawCell( Sender: TObject; ACol, ARow: Integer;
                                   Rect: TRect; State: TGridDrawState);
var
   TC: TypeCellule;
begin
     with sg
     do
       begin
       TC:= Typ( ACol, ARow);
       Canvas.Font.Assign( Font);

       DI.Init_Draw( Canvas, ACol, ARow, Rect, False);
       DI.Init_Cell( TC <> tc_Case, False);

       DrawCell_Table;

       (*if gdFocused in State    Plante l'affichage
       then
           Canvas.DrawFocusRect(Rect);*)
       end;
end;
}
function ThDessinnateurWeb.GetCell( Contexte: Integer): String;
begin
     Result:= Titre;
end;

function ThDessinnateurWeb.sg_be(Colonne, Ligne: Integer): TBatpro_Element;
begin
     Result:= sg.Batpro_Element[ Colonne, Ligne];
end;

function ThDessinnateurWeb.Cell_Height( _Colonnne, _Ligne, _Cell_Width:Integer):Integer;
var
   be: TBatpro_Element;
begin
     be:= sg_be( _Colonnne, _Ligne);
     if Assigned( be)
     then
         Result:= be.Cell_Height( DI, _Cell_Width)
     else
         Result:= sg.RowHeights[ _Ligne];
end;

procedure ThDessinnateurWeb.Charge_Cell(be:TBatpro_Element; Colonne,Ligne:Integer);
begin
     sg.Charge_Cell( Colonne, Ligne, be, DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Ligne( _sl:TBatpro_StringList;OffsetColonne,Ligne:Integer;
                                       ClusterAddInit_: Boolean= False);
begin
     sg.Charge_Ligne( OffsetColonne, Ligne, _sl, ClusterAddInit_, DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Colonne(_sl:TBatpro_StringList;Colonne,OffsetLigne:Integer);
begin
     sg.Charge_Colonne( Colonne, OffsetLigne, _sl, DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Colonne( beEntete: TBatpro_Element;
                                         _sl: TBatpro_StringList;
                                         Colonne, OffsetLigne: Integer);
begin
     sg.Charge_Colonne( Colonne, OffsetLigne, beEntete,_sl, DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Ligne( bts: TbtString;OffsetColonne,Ligne:Integer;
                                       ClusterAddInit_: Boolean= False);
begin
     sg.Charge_Ligne  ( OffsetColonne,Ligne, bts,ClusterAddInit_,DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Colonne( bts: TbtString;Colonne,OffsetLigne:Integer);
begin
     sg.Charge_Colonne( Colonne,OffsetLigne, bts, DI.Contexte);
end;

procedure ThDessinnateurWeb.Charge_Colonne( beEntete: TBatpro_Element;
                                            bts: TbtString;
                                            Colonne, OffsetLigne: Integer);
begin
     sg.Charge_Colonne( Colonne,OffsetLigne, beEntete,bts, DI.Contexte);
end;

function ThDessinnateurWeb.hdCell: String;
begin
     Result:= Cell[DI.Contexte];
end;

procedure ThDessinnateurWeb.Traite_Hauteurs_Lignes;
begin
     sg.Traite_Hauteurs_Lignes( DI);
end;

procedure ThDessinnateurWeb.Traite_Largeurs_Colonnes( _ColonneDebut: Integer= 0;
                                                   _ColonneFin  : Integer= -1);
begin
     sg.Traite_Largeurs_Colonnes( DI, _ColonneDebut, _ColonneFin);
end;

procedure ThDessinnateurWeb.Traite_Ratio;
begin
     //sg.Traite_Ratio( DI);
end;

procedure ThDessinnateurWeb.Initialise_dimensions( _ColonneDebut: Integer= 0);
begin
     sg.Initialise_dimensions( _ColonneDebut);
end;

procedure ThDessinnateurWeb.Ajuste_Largeur_Client(_ColonneDebut: Integer);
begin
     sg.Ajuste_Largeur_Client( _ColonneDebut);
end;

procedure ThDessinnateurWeb.Egalise_Largeurs_Colonnes( ColonneDebut, ColonneFin: Integer);
begin
     sg.Egalise_Largeurs_Colonnes( ColonneDebut, ColonneFin);
end;

{
procedure ThDessinnateurWeb.sgMouseMove( Sender: TObject; Shift: TShiftState;
                                      X, Y: Integer);
var
   OldHint, NewHint: String;
begin
     OldHint:= sg.Hint;

     sg.ShowHint:= False;
     sg.Hint:= '';
     MMbe:= nil;
     sg.PopupMenu:= nil;

     sg.MouseToCell( X, Y, MMColonne, MMLigne);
     if (MMColonne < 0)or(MMLigne < 0) then exit;

     sg.PopupMenu:= PopupDefaut;

     MMbe:= sg_be( MMColonne, MMLigne);
     if MMbe = nil then exit;

     NewHint:= MMbe.Contenu( DI.Contexte, MMColonne, MMLigne);

     if Debug_Hint
     then
         NewHint:=   MMbe.ClassName+#13#10
                    +NewHint;
     if OldHint <> NewHint
     then
         Application.CancelHint;

     sg.ShowHint:= True;
     sg.Hint:= NewHint;

     sg.PopupMenu:= MMbe.Popup( DI.Contexte);
end;
}
procedure ThDessinnateurWeb.Refresh;
begin
     //sg.Refresh;
end;

function ThDessinnateurWeb.GetTitre: String;
begin
     Result:= FTitre;
end;

function ThDessinnateurWeb.DoImprime( unhdTable: ThDessinnateurWeb;
                                   RowCountMin: Integer; HMax: Boolean;
                                   //'Les couleurs représentent les équipes.'
                                   _sLegende_ligne_1: String;
                                   _aLegende_ligne_2: array of String): Boolean;
begin
     Result:= Assigned(function_fBatproReport_Execute);
     if not Result then exit;

     Result
     :=
       function_fBatproReport_Execute( unhdTable, RowCountMin, HMax,
                                       _sLegende_ligne_1,
                                       _aLegende_ligne_2);
end;

function ThDessinnateurWeb.Imprime: Boolean;
begin
     Result:= DoImprime( Self, 8, False, sys_Vide, []);
end;

procedure ThDessinnateurWeb.EnregistrerSous_interne( NomFichier: String);
const
     Separateur= #9;//#9 = tabulation
var
   slLignes: TBatpro_StringList;
   I, J: Integer;
   be: TBatpro_Element;
   sTableurCell, Ligne: String;
   procedure sTableurCell_EnleveSautsLigne;
   var
      k: Integer;
   begin
        for k:= 1 to Length( sTableurCell)
        do
          if sTableurCell[k] in [#13,#10]
          then
              sTableurCell[k]:= ' ';
   end;
begin
     slLignes:= TBatpro_StringList.Create;
     try
        for J:= 0 to sg.RowCount -1
        do
          begin
          Ligne:= sys_Vide;

          for I:= 0 to sg.ColCount-1
          do
            begin
            be:= sg_be( I, J);

            if nil = be
            then
                sTableurCell:= sys_Vide
            else
                sTableurCell:= be.TableurCell[DI.Contexte];

            sTableurCell_EnleveSautsLigne;

            if I > 0
            then
                Ligne:= Ligne+Separateur;

            Ligne:= Ligne+sTableurCell;

            end;
          slLignes.Add( Ligne);
          end;

        slLignes.SaveToFile( NomFichier);
     finally
            Free_nil( slLignes);
            end;
end;

function ThDessinnateurWeb.EnregistrerSous: Boolean;
//var
//   sd: TSaveDialog;
begin
{
     sd:= TSaveDialog.Create( nil);
     try
        sd.DefaultExt:= 'TXT';
        sd.FileName:= ClassName+'.txt';
        Result:= sd.Execute;
        if Result
        then
            EnregistrerSous_interne( sd.FileName);
     finally
            Free_nil( sd);
            end;
}
end;

procedure ThDessinnateurWeb._from_pool_interne;
begin

end;

procedure ThDessinnateurWeb._from_pool;
begin
     Vide;
     if Execute_running
     then
         _from_pool_interne;
end;

procedure ThDessinnateurWeb.Vide;
begin
     if Self = nil then exit;

     Vide_StringList( slCE);
     Vide_StringGrid( sg);
end;

procedure ThDessinnateurWeb.Clusterise;
var
   iCol, iRow: Integer;
   beTopLeft: TBatpro_Element;
   procedure Clusterise_( x, y: Integer);
   var
      bece: TbeClusterElement;
   begin
        bece:= TbeClusterElement.Create( slCE, beTopLeft);
        beTopLeft.Cluster.Ajoute( bece, x, y);
        slCE.AddObject( sys_Vide, bece);
        sg.Objects[ x, y]:= bece;
   end;
   function Clusterise_horizontal: Boolean;
   var
      i, j, iColFin: Integer;
      function beTopLeft_Egale( x, y: Integer): Boolean;
      begin
           Result:= beTopLeft.Egale( sg_be( x, y));
      end;
      function Teste_Ligne_horizontale: Boolean;
      var
         x: Integer;
      begin
           Result:= True;
           for x:= iCol to iColFin
           do
             begin
             Result:= beTopLeft_Egale( x, j);
             if not Result then break;
             end;
      end;
      procedure Ajoute_Ligne_horizontale;
      var
         x: Integer;
      begin
           for x:= iCol to iColFin
           do
             Clusterise_( x, j);
      end;
   begin
        //on ne fait ce traitement
        //que si on est au début d'une série horizontale
        i:= iCol+1;
        j:= iRow;
        Result:= beTopLeft_Egale( i, j);
        if Result
        then
            begin
            beTopLeft.Cree_Cluster;
            Clusterise_( iCol, iRow);
            Clusterise_( i   , j   );
            //On balaye à droite
            Inc(I);
            while beTopLeft_Egale( i, j)
            do
              begin
              Clusterise_( i, j);
              Inc( I);
              end;
            //On balaye vers le bas
            iColFin:= I-1;
            Inc( j);
            while Teste_Ligne_horizontale
            do
              begin
              Ajoute_Ligne_horizontale;
              Inc( j);
              end;
            end;
   end;
   procedure Clusterise_vertical;
   var
      i, j: Integer;
      function Egaux: Boolean;
      begin
           Result:= beTopLeft.Egale( sg_be( i, j));
      end;
   begin
        //on ne fait ce traitement
        //que si on est au début d'une série horizontale
        i:= iCol;
        j:= iRow+1;
        if Egaux
        then
            begin
            beTopLeft.Cree_Cluster;
            Clusterise_( iCol, iRow);
            Clusterise_( i   , j   );
            //On balaye vers le bas
            Inc(j);
            while Egaux
            do
              begin
              Clusterise_( i, j);
              Inc( j);
              end;
            end;
   end;
begin
     for iRow:= 0 to sg.RowCount - 1
     do
       for iCol:= 0 to sg.ColCount - 1
       do
         begin
         beTopLeft:= sg_be( iCol, iRow);
         if     Assigned( beTopLeft)
            and not(beTopLeft is TbeClusterElement)
         then
             begin
             if not Clusterise_horizontal
             then
                 Clusterise_vertical;
             end;
         end;
end;

procedure ThDessinnateurWeb.SetCurseur_Colonne(const Value: Integer);
begin
     FCurseur_Colonne:= Value;
     if Curseur_Colonne = -1      then exit;
     sg.ColWidths[ Curseur_Colonne]:= beCurseur.Cell_Width( DI);
end;

procedure ThDessinnateurWeb.Cache_Curseur;
begin
     if Curseur_Colonne = -1      then exit;
     if Drag_Ligne  <  0          then exit;
     if sg.RowCount <= Drag_Ligne then exit;

     sg.Objects[ Curseur_Colonne, Drag_Ligne]:= nil;
     sg.Refresh;
end;

procedure ThDessinnateurWeb.Montre_Curseur;
begin
     if Curseur_Colonne = -1      then exit;
     if Drag_Ligne  <  0          then exit;
     if sg.RowCount <= Drag_Ligne then exit;

     sg.Objects[ Curseur_Colonne, Drag_Ligne]:= beCurseur;
end;

function ThDessinnateurWeb.Drag_from_(ACol, ARow: Integer): Boolean;
var
   gr: TRect;//TGridRect;
   gr_Change: Boolean;
begin
     gr_Change:= False;
     if ACol < sg.FixedCols
     then
         begin
         ACol:= sg.Col;
         if ACol < sg.FixedCols
         then
             //ACol:= sg.FixedCols;
             ACol:= -1;
         gr_Change:= True;
         gr.Left := ACol;
         gr.Right:= ACol;
         end;
     if ARow < sg.FixedRows
     then
         begin
         ARow:= sg.Row;
         if ARow < sg.FixedRows
         then
             //ARow:= sg.FixedRows;
             ARow:= -1;
         gr_Change:= True;
         gr.Top   := ARow;
         gr.Bottom:= ARow;
         end;

     if gr_Change
     then
         begin
         sg.Selection:= gr;
         sg.Row:= ARow;
         sg.Col:= ACol;
         end;

     Drag_Colonne:= ACol;
     Drag_Ligne  := ARow;
     Montre_Curseur;
     sg.Refresh;

     pDrag.Publie;

     Result:= True;
end;

function ThDessinnateurWeb.Drop_from_XY( _X, _Y: Integer): Boolean;
begin
     sg.MouseToCell( _X, _Y, Drop_Colonne, Drop_Ligne);
     Result:= True;
end;

function ThDessinnateurWeb.GotoXY( _Colonne, _Ligne: Integer): Boolean;
begin
     Cache_Curseur;
     Result:= Drag_from_( _Colonne, _Ligne);
end;

{
procedure ThDessinnateurWeb.sgMouseDown( Sender:TObject; Button:TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
     inherited;
     Cache_Curseur;
     sg.MouseToCell( X, Y, Drag_Colonne, Drag_Ligne);
     if Drag_from_( Drag_Colonne, Drag_Ligne)
     then
         TraiteMouseDown( Button, Shift, X, Y);
     if Assigned( Old_sgMouseDown)
     then
         Old_sgMouseDown( Sender, Button, Shift, X, Y)
end;

procedure ThDessinnateurWeb.sgSelectCell( Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
     inherited;
     Cache_Curseur;
     Drag_from_( ACol, ARow);
     if Assigned( Old_sgSelectCell)
     then
         Old_sgSelectCell( Sender, ACol, ARow, CanSelect);
end;

procedure ThDessinnateurWeb.Bloque( _Proc: TAbonnement_Objet_Proc);
begin
     ufBloqueur.Bloque( Form, _Proc);
end;
}
function ThDessinnateurWeb.svgDraw: String;
var
   iCol, iRow: Integer;
   TC: TypeCellule;
   svg: TSVGDocument;
   eSVG: TDOMNode;
   eDEFS: TDOMNode;
begin
     svg:= TSVGDocument.Create( '');
     eSVG:= svg.xml.AppendChild(svg.xml.CreateElement('svg'));
     //eSVG:= Cree_path( svg.xml.DocumentElement, 'svg');
     svg.Set_Property( eSVG, 'xmlns'  , 'http://www.w3.org/2000/svg');
     svg.Set_Property( eSVG, 'version', '1.1');
     svg.Set_Property( eSVG, 'width' , IntToStr(sg.Width ));
     svg.Set_Property( eSVG, 'height', IntToStr(sg.Height));
     svg.Set_Property( eSVG, 'viewBox', '0 0 '+IntToStr(sg.Width)+' '+IntToStr(sg.Height));

     try
        eDEFS:= Cree_path( eSVG, 'defs');

        eDEFS.NodeValue
        :=
            ''
          +SVG_Bitmaps.DOCSINGL
          +SVG_Bitmaps.LOSANGE

+'<pattern                                                                  '#13#10
+'   id="Hachures_Slash"                                                    '#13#10
+'   patternUnits="userSpaceOnUse"                                          '#13#10
+'   width="2"                                                              '#13#10
+'   height="1"                                                             '#13#10
+'   patternTransform="matrix(8.1529948,5.7903945,-5.7903945,8.1529948,0,0)"'#13#10
+'  <rect                                                                   '#13#10
+'     style="fill:black;stroke:none"                                       '#13#10
+'     x="0"                                                                '#13#10
+'     y="-0.5"                                                             '#13#10
+'     width="1"                                                            '#13#10
+'     height="2"    />                                                     '#13#10
+'</pattern>                                                                '#13#10
+'<pattern                                                                  '#13#10
+'   id="Hachures_BackSlash"                                                '#13#10
+'   patternUnits="userSpaceOnUse"                                          '#13#10
+'   width="2"                                                              '#13#10
+'   height="1"                                                             '#13#10
+'   patternTransform="matrix(8.2170442,-5.6991383,5.6991383,8.2170442,0,0)"'#13#10
+'  <rect                                                                   '#13#10
+'     height="2"                                                           '#13#10
+'     width="1"                                                            '#13#10
+'     y="-0.5"                                                             '#13#10
+'     x="0"                                                                '#13#10
+'     style="fill:black;stroke:none" />                                    '#13#10
+'</pattern>                                                                '#13#10
          ;
        with sg
        do
          for iRow:= 0 to sg.RowCount - 1
          do
            begin
            for iCol:= 0 to sg.ColCount - 1
            do
              begin
              TC:= Typ( iCol, iRow);
//              Canvas.Font.Assign( Font);

              DI.Init_Draw( Canvas, iCol, iRow, CellRect( iCol, iRow), False);
              DI.Init_Cell( TC <> tc_Case, False);
              DI.Init_SVG( svg, eSVG);
              InflateRect( DI.Rect, 1, 1);

              svgDrawCell_Table;

              //if gdFocused in State
              //then
              //    Canvas.DrawFocusRect(Rect);
              end;
            end;
          Result:= svg.Save_to_string;
     finally
            DI.Init_SVG( nil, nil);
            Free_nil( svg);
            end;
end;

function ThDessinnateurWeb.html: String;
begin
     Result
     :=
        '<html>'#13#10
       +'<header>'
       +'</header>'
       +'<body>'
       +svgDraw
       +'</body>';
end;

procedure ThDessinnateurWeb.Test_html;
var
   NomFichier: String;
   slLignes: TBatpro_StringList;
begin
     NomFichier:= OD_Temporaire.Nouveau_Extension( ClassName, '.html');
     slLignes:= TBatpro_StringList.Create;
     try
        slLignes.Text:= html;
        slLignes.SaveToFile( NomFichier);
     finally
            Free_nil( slLignes);
            end;
     ShowURL( NomFichier);
end;

procedure ThDessinnateurWeb.Traite_Dimensions;
begin
     Traite_Largeurs_Colonnes;
     Traite_Hauteurs_Lignes;
end;

function ThDessinnateurWeb.Colonne_of( _be: TBatpro_Element;
                                    _Ligne: Integer): Integer;
var
   I: Integer;
   be: TBatpro_Element;
begin
     Result:= -1;
     if _be = nil then exit;

     for I:= 0 to sg.ColCount-1
     do
       begin
       be:= sg_be( I, _Ligne);
       if be = _be
       then
           begin
           Result:= I;
           break;
           end;
       end;
end;

procedure ThDessinnateurWeb.PreExecute;
begin
     Execute_running:= True;
end;

procedure ThDessinnateurWeb.PostExecute;
begin
     Execute_running:= False;
     Vide;
end;

end.

