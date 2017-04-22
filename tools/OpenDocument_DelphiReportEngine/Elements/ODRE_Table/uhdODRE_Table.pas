unit uhdODRE_Table;

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uLog,
    uBatpro_StringList,
    uBatpro_Element,
    uBatpro_Ligne,
    ubeString,
    ublODRE_Table,
    ublOD_Dataset_Columns,
    ublOD_Dataset_Column,
    ublOD_Affectation,
    ublOD_Column,
    uhDessinnateur,
    uOD_TextTableContext,

    ucChamp_Edit,
    ucChamp_Lookup_ComboBox,
 Classes, SysUtils, Grids, Graphics,Dialogs,LCLType,Controls, StdCtrls, ExtCtrls;

type

 { ThdODRE_Table }

 ThdODRE_Table
 =
  class( ThDessinnateur)
  //Gestion du cycle de vie
  public
    constructor Create( _Contexte: Integer; _SG: TStringGrid;
                        _Titre: String);
    destructor Destroy; override;
  //blODRE_Table
  private
    FblODRE_Table: TblODRE_Table;
    procedure Set_blODRE_Table( _Value: TblODRE_Table);
  public
    property blODRE_Table: TblODRE_Table read FblODRE_Table write Set_blODRE_Table;
  //Composition
  private
    procedure Charge_OD_Column;
    procedure Charge_OD_Dataset_Columns_hdm;
    procedure Charge_OD_Dataset_Columns;
    procedure Champ_Change;
  public
    bsTitre: TBeString;
    clkcbNomChamp: TChamp_Lookup_ComboBox;
    ceTitre  : TChamp_Edit;
    ceLargeur: TChamp_Edit;
    pDrag: TPanel;
    mCellule_Info: TMemo;
    procedure _from_pool; override;
  //timer de réaffichage
  public
    t: TTimer;
    procedure t_Timer( Sender: TObject);
  //Gestion souris et Drag / Drop
  protected
    Drag_Column: TblOD_Column;
    Drag_Affectation: TblOD_Affectation;
    procedure Drag_nil;
    function  Drag_from_( ACol, ARow: Integer): Boolean; override;
  //Suppression de colonne
  public
    procedure Supprimer_Colonne( _C: TOD_TextTableContext);
  //Insertion de colonne
  public
    procedure InsererColonne( _C: TOD_TextTableContext; _Apres: Boolean);
  //Rafraichissement
  public
    procedure Vide; override;
  end;

implementation

{ ThdODRE_Table }

const
     ThdODRE_Table_Ligne_Titres_Colonnes=0;

constructor ThdODRE_Table.Create( _Contexte: Integer;
                                  _SG: TStringGrid;
                                  _Titre: String);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Gestionnaire de grille de ODRE_Table';
         CP.Font.Name:= sys_Courier_New;
         CP.Font.Size:= 8;
         with CP.Font do Style:= Style + [fsBold];
         end;
     inherited Create( _Contexte, _SG, _Titre, nil);

     bsTitre:= TbeString.Create( nil, 'Titre', clYellow, bea_Gauche);
     Debug_Hint:= True;
     t:= TTimer.Create( nil);
     t.Interval:= 1;
     t.OnTimer:= t_Timer;

     FblODRE_Table:= nil;
     //Batpro_Element_Marge:= 10;
end;

destructor ThdODRE_Table.Destroy;
begin
     FreeAndNil( t);
     inherited Destroy;
end;

procedure ThdODRE_Table.Set_blODRE_Table( _Value: TblODRE_Table);
begin
     if FblODRE_Table = _Value then Exit;
     if Assigned( FblODRE_Table) then FblODRE_Table.T.to_Doc_Called.Desabonne( Self, Champ_Change);
     FblODRE_Table:=_Value;
     if Assigned( FblODRE_Table) then FblODRE_Table.T.to_Doc_Called.Abonne( Self, Champ_Change);
end;

procedure ThdODRE_Table.Charge_OD_Column;
begin
     Charge_Cell( bsTitre, 0, ThdODRE_Table_Ligne_Titres_Colonnes);
     Charge_Ligne( blODRE_Table.haOD_Column.sl, 1, ThdODRE_Table_Ligne_Titres_Colonnes);
end;

procedure ThdODRE_Table.Charge_OD_Dataset_Columns_hdm;
var
   I: TIterateur_OD_Dataset_Columns;
   blDCs: TblOD_Dataset_Columns;
begin
     I:= blODRE_Table.haOD_Dataset_Columns.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( blDCs) then continue;

       blDCS.haAvant.Charge;
       blDCs.haApres.Charge;

       blDCs.Affectation_Charge_Avant( blODRE_Table.Nom);
       blDCs.Affectation_Charge_Apres( blODRE_Table.Nom);
       end;
end;

procedure ThdODRE_Table.Charge_OD_Dataset_Columns;
var
   I: TIterateur_OD_Dataset_Columns;
   blDCs: TblOD_Dataset_Columns;
   iRow: Integer;
begin
     iRow:= 1;
     I:= blODRE_Table.haOD_Dataset_Columns.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( blDCs) then continue;

       Charge_Cell( blDCs.bsAvant, 0, iRow);
       Charge_Ligne( blDCs.haAvant_Affectation, 1, iRow);
       Inc( iRow);
       end;

     I:= blODRE_Table.haOD_Dataset_Columns.Iterateur_Decroissant;
     while I.Continuer
     do
       begin
       if I.not_Suivant( blDCs) then continue;

       Charge_Cell( blDCs.bsApres, 0, iRow);
       Charge_Ligne( blDCs.haApres_Affectation, 1, iRow);
       Inc( iRow);
       end;
end;

procedure ThdODRE_Table._from_pool;
begin
     inherited _from_pool;

     Drag_nil;

     Charge_OD_Dataset_Columns_hdm;

     //blODRE_Table.haOD_Column.Charge;
     //blODRE_Table.haOD_Dataset_Columns.Charge;
     sg.Hide;
     Vide_StringGrid( sg);
     sg.FixedCols:= 1;
     sg.FixedRows:= 1;
     sg.ColCount:= 1+blODRE_Table.haOD_Column.Count;
     sg.RowCount
     :=
         1  //Titres de colonnes
       + 2*blODRE_Table.haOD_Dataset_Columns.Count;

     Charge_OD_Column;
     Charge_OD_Dataset_Columns;

     //Clusterise;

     Traite_Dimensions;

     sg.Show;
end;

procedure ThdODRE_Table.Champ_Change;
begin
     t.Enabled:= True;
end;

procedure ThdODRE_Table.t_Timer( Sender: TObject);
begin
     t.Enabled:= False;
     //_from_pool;
     Charge_OD_Column;
     Charge_OD_Dataset_Columns;
end;

procedure ThdODRE_Table.Drag_nil;
begin
     Drag_Column     := nil;
     Drag_Affectation:= nil;
     pDrag.Visible:= False;
     ceTitre      .Champs:= nil;
     ceLargeur    .Champs:= nil;
     clkcbNomChamp.Champs:= nil;
     mCellule_Info.Clear;
end;

function ThdODRE_Table.Drag_from_(ACol, ARow: Integer): Boolean;
   procedure Traite_Titre;
   begin
        if nil = ceTitre   then exit;
        if nil = ceLargeur then exit;

        ceTitre  .Champs:= nil; ceTitre  .Caption:= '';
        ceLargeur.Champs:= nil; ceLargeur.Caption:= '';

        if Affecte_( Drag_Column, TblOD_Column,
                     sg_be( ACol, ThdODRE_Table_Ligne_Titres_Colonnes)) then exit;

        ceTitre  .Champs:= Drag_Column.Champs;
        ceLargeur.Champs:= Drag_Column.Champs;
        pDrag.Visible:= True;
   end;
   procedure Affiche_Cellule_Info( _bl: TblOD_Affectation);
   var
      W: Integer;
   begin
        W:= _bl.Cell_Width(DI);
        mCellule_Info.Lines.Add( 'Largeur:'+IntToStr( W));
        mCellule_Info.Lines.Add( 'Hauteur:'+IntToStr( _bl.Cell_Height(DI,W)));
   end;
   function not_Traite_Affectation: Boolean;
   var
      bl: TblOD_Affectation;
   begin
        Result:= True;

        if nil = clkcbNomChamp then exit;

        clkcbNomChamp.Champs:= nil;
        clkcbNomChamp.Text:= '';

        if Affecte_( bl, TblOD_Affectation, sg_be( ACol, ARow)) then exit;

        Result:= False;
        clkcbNomChamp.Champs:= bl.Champs;
        pDrag.Visible:= True;

        //Affiche_Cellule_Info( bl);
   end;
begin
     Result:=inherited Drag_from_(ACol, ARow);

     Drag_nil;

     Traite_Titre;
     not_Traite_Affectation;
end;

procedure ThdODRE_Table.Supprimer_Colonne( _C: TOD_TextTableContext);
var
   nColonne: Integer;
   Abandon: Boolean;
begin
     if nil = Drag_Column then exit;

     nColonne:= Drag_Colonne-1;

     Abandon
     :=
          mrYes
       <> MessageDlg( 'Confirmation',
                       'Souhaitez vous supprimer la colonne n°'
                      +IntToStr(nColonne)+': '
                      +Drag_Column.C.Titre+' ?',
                      mtConfirmation,
                      [mbYes, mbNo],
                      0,
                      mbNo
                      );
     if Abandon then exit;

     Vide;
     blODRE_Table.SupprimerColonne( nColonne, _C);
     _from_pool;
end;

procedure ThdODRE_Table.InsererColonne(_C: TOD_TextTableContext; _Apres: Boolean);
var
   nColonne: Integer;
   Abandon: Boolean;
   sAvant_Apres: String;
begin
     if nil = Drag_Column then exit;

     nColonne:= Drag_Colonne-1;

     if _Apres
     then
         sAvant_Apres:= 'aprés'
     else
         sAvant_Apres:= 'avant';
     Abandon
     :=
          mrYes
       <> MessageDlg( 'Confirmation',
                       'Souhaitez vous insérer une colonne '+sAvant_Apres+' la colonne n°'
                      +IntToStr(nColonne)+': '
                      +Drag_Column.C.Titre+' ?',
                      mtConfirmation,
                      [mbYes, mbNo],
                      0,
                      mbNo);
     if Abandon then exit;

     Vide;
     blODRE_Table.InsererColonne( nColonne, _C, _Apres);
     _from_pool;
end;


procedure ThdODRE_Table.Vide;
begin
     Drag_nil;
     inherited Vide;
end;

end.

