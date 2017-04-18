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
 Classes, SysUtils, Grids, Graphics,Dialogs,LCLType,Controls, ExtCtrls;

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
  //Composition
  public
    blODRE_Table: TblODRE_Table;
    bsTitre: TBeString;
    clkcbNomChamp: TChamp_Lookup_ComboBox;
    ceTitre: TChamp_Edit;
    pDrag: TPanel;
    procedure _from_pool; override;
  //Gestion souris et Drag / Drop
  protected
    Drag_Column: TblOD_Column;
    Drag_Affectation: TblOD_Affectation;
    procedure Drag_nil;
    procedure Drag_Abonne;
    procedure Drag_Desabonne;
    procedure Drag_Column_Change;
    procedure Drag_Affectation_Change;
    function  Drag_from_( ACol, ARow: Integer): Boolean; override;
  public
    procedure Supprimer_Colonne( _C: TOD_TextTableContext);
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
end;

destructor ThdODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure ThdODRE_Table._from_pool;
   procedure Charge_OD_Column;
   begin
        Charge_Cell( bsTitre, 0, ThdODRE_Table_Ligne_Titres_Colonnes);
        Charge_Ligne( blODRE_Table.haOD_Column.sl, 1, ThdODRE_Table_Ligne_Titres_Colonnes);
   end;
   procedure Charge_OD_Dataset_Columns;
   var
      I: TIterateur_OD_Dataset_Columns;
      blDCs: TblOD_Dataset_Columns;
      iRow: Integer;
      procedure Charge_Avant;
      begin
           blDCs.Affectation_Charge_Avant( blODRE_Table.Nom);
           Charge_Ligne( blDCs.haAvant_Affectation, 1, iRow);
      end;
      procedure Charge_Apres;
      begin
           blDCs.Affectation_Charge_Apres( blODRE_Table.Nom);
           Charge_Ligne( blDCs.haApres_Affectation, 1, iRow);
      end;
   begin
        iRow:= 1;
        I:= blODRE_Table.haOD_Dataset_Columns.Iterateur;
        while I.Continuer
        do
          begin
          if I.not_Suivant( blDCs) then continue;

          blDCS.haAvant.Charge;
          blDCs.haApres.Charge;

          Charge_Cell( blDCs, 0, iRow);
          Charge_Avant;
          Inc( iRow);
          end;

        I:= blODRE_Table.haOD_Dataset_Columns.Iterateur_Decroissant;
        while I.Continuer
        do
          begin
          if I.not_Suivant( blDCs) then continue;

          Charge_Cell( blDCs, 0, iRow);
          Charge_Apres;
          Inc( iRow);
          end;
   end;
begin
     inherited _from_pool;

     Drag_nil;

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
     Clusterise;
     sg.Show;
end;

procedure ThdODRE_Table.Drag_nil;
begin
     Drag_Desabonne;
     Drag_Column     := nil;
     Drag_Affectation:= nil;
     pDrag.Visible:= False;
     ceTitre      .Champs:= nil;
     clkcbNomChamp.Champs:= nil;
end;

procedure ThdODRE_Table.Drag_Abonne;
begin
     if Assigned( Drag_Column     ) then Drag_Column     .cLibelle .OnChange.Desabonne( Self, Drag_Column_Change     );
     if Assigned( Drag_Affectation) then Drag_Affectation.cNomChamp.OnChange.Desabonne( Self, Drag_Affectation_Change);
end;

procedure ThdODRE_Table.Drag_Desabonne;
begin
     if Assigned( Drag_Column     ) then Drag_Column     .cLibelle .OnChange.Desabonne( Self, Drag_Column_Change     );
     if Assigned( Drag_Affectation) then Drag_Affectation.cNomChamp.OnChange.Desabonne( Self, Drag_Affectation_Change);
end;

procedure ThdODRE_Table.Drag_Column_Change;
begin
     _from_pool;
end;

procedure ThdODRE_Table.Drag_Affectation_Change;
begin
     _from_pool;
end;

function ThdODRE_Table.Drag_from_(ACol, ARow: Integer): Boolean;
   procedure Traite_Titre;
   begin
        if nil = ceTitre then exit;

        ceTitre.Champs:= nil;
        ceTitre.Caption:= '';

        if Affecte_( Drag_Column, TblOD_Column,
                     sg_be( ACol, ThdODRE_Table_Ligne_Titres_Colonnes)) then exit;

        ceTitre.Champs:= Drag_Column.Champs;
        pDrag.Visible:= True;
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
   end;
begin
     Result:=inherited Drag_from_(ACol, ARow);

     Drag_nil;

     Traite_Titre;
     not_Traite_Affectation;
     Drag_Abonne;
end;

procedure ThdODRE_Table.Supprimer_Colonne( _C: TOD_TextTableContext);
var
   nColonne: Integer;
begin
     if nil = Drag_Column then exit;

     nColonne:= Drag_Colonne-1;

     if mrYes <> MessageDlg( 'Confirmation',
     'Souhaitez vous supprimer la colonne n°'+IntToStr(nColonne)+' '+Drag_Column.C.Titre+' ?',
     mtConfirmation, [mbYes, mbNo], 0, mbNo)
     then
         exit;
     Vide;

     blODRE_Table.SupprimerColonne( nColonne, _C);
     blODRE_Table.T.To_Doc( _C);
     _from_pool;
end;

procedure ThdODRE_Table.Vide;
begin
     Drag_nil;
     inherited Vide;
end;

end.

