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
    uhDessinnateur,

 Classes, SysUtils, Grids, Graphics;

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
    procedure _from_pool; override;
  end;

implementation

{ ThdODRE_Table }

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
end;

destructor ThdODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure ThdODRE_Table._from_pool;
   procedure Charge_OD_Column;
   begin
        Charge_Cell( bsTitre, 0, 0);
        Charge_Ligne( blODRE_Table.haOD_Column.sl, 1, 0);
   end;
   procedure Charge_OD_Dataset_Columns;
   var
      I: TIterateur_OD_Dataset_Columns;
      blDCs: TblOD_Dataset_Columns;
      iRow: Integer;
      procedure Charge_Avant;
      var
         iDC: TIterateur_OD_Dataset_Column;
         blDC: TblOD_Dataset_Column;
         iCol: Integer;
      begin
           iDC:= blDCs.haAvant.Iterateur;
           while iDC.Continuer
           do
             begin
             if iDC.not_Suivant( blDC) then continue;

             for iCol:= blDC.DC.Debut to blDC.DC.Fin
             do
               begin
               Log.PrintLn( blDCs.Nom+' '+blDC.FieldName+' '+IntToStr( iCol)+' '+IntToStr( iRow));
               Charge_Cell( blDC, 1+iCol, iRow);
               end;
             end;
      end;
      procedure Charge_Apres;
      var
         iDC: TIterateur_OD_Dataset_Column;
         blDC: TblOD_Dataset_Column;
         iCol: Integer;
      begin
           iDC:= blDCs.haApres.Iterateur;
           while iDC.Continuer
           do
             begin
             if iDC.not_Suivant( blDC) then continue;

             for iCol:= blDC.DC.Debut to blDC.DC.Fin
             do
               begin
               Log.PrintLn( blDCs.Nom+' '+blDC.FieldName+' '+IntToStr( iCol)+' '+IntToStr( iRow));
               Charge_Cell( blDC, 1+iCol, iRow);
               end;
             end;
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

     //blODRE_Table.haOD_Column.Charge;
     //blODRE_Table.haOD_Dataset_Columns.Charge;

     sg.FixedCols:= 0;
     sg.FixedRows:= 0;
     sg.ColCount:= 1+blODRE_Table.haOD_Column.Count;
     sg.RowCount
     :=
         1  //Titres de colonnes
       + 2*blODRE_Table.haOD_Dataset_Columns.Count;

     Charge_OD_Column;
     Charge_OD_Dataset_Columns;
     Clusterise;
end;

end.

