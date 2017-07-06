unit uOD_TextTableManager;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    DOM,
    uOOoStrings,
    uOpenDocument,
    uOD_SurTitre,
    uOD_Merge,
    uOD_Styles,
    uODRE_Table,
    uOD_Column,
    uOD_Dataset_Column,
    uOD_Dataset_Columns,
    uOD_TextFieldsCreator,
    uOD_TextTableContext,
  SysUtils, Classes,
  DB;

type

 { TOD_TextTableManager }

 TOD_TextTableManager
 =
  class
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //Attributs
  public
    C: TOD_TextTableContext;
    Nom: String;
  //Général
  private
    procedure Init( _ODRE_Table: TODRE_Table);
    procedure BooleanFieldValue( _D: TDataset; _FielName: String; var _F:TField; var _B: Boolean);
    procedure IntegerFieldValue( _D: TDataset; _FielName: String; var _F:TField; var _I: Integer);
  // Création d'une table maitre-détail à partir d'un tableau de
  // dataset
  public
    function Execute_Modele( ODRE_Table: TODRE_Table;
                             Nouveau_Modele: Boolean): Boolean; overload;
    function Remplit( ODRE_Table: TODRE_Table): Boolean; overload;
    function Remplit_sans_tableau( ODRE_Table: TODRE_Table): Boolean; overload;

    // en cours de mise au point
    function Remplit_HTML( ODRE_Table: TODRE_Table; var T: Text): Boolean;
  end;

implementation

{ TOD_TextTableManager }

constructor TOD_TextTableManager.Create( _D: TOpenDocument);
begin
     C:= TOD_TextTableContext.Create( _D);
end;

destructor TOD_TextTableManager.Destroy;
begin
     FreeAndNil( C);
     inherited;
end;

procedure TOD_TextTableManager.Init( _ODRE_Table: TODRE_Table);
begin
     C.Init( _ODRE_Table.Nom, _ODRE_Table.Bordures_Verticales_Colonnes, _ODRE_Table.MasquerTitreColonnes);
end;

procedure TOD_TextTableManager.BooleanFieldValue( _D: TDataset;
                                                  _FielName: String;
                                                  var _F: TField;
                                                  var _B: Boolean);
begin
     _F:= _D.FindField( _FielName);
     if      Assigned( _F)
     then
         case _F.DataType
         of
           ftBoolean: _B:= _F.AsBoolean;
           ftSmallint,
           ftWord,
           ftLargeint,
           ftInteger: _B:= _F.AsInteger <> 0;
           else       _B:= False;
           end
     else
         _B:= False;
end;

procedure TOD_TextTableManager.IntegerFieldValue( _D: TDataset;
                                                  _FielName: String;
                                                  var _F: TField;
                                                  var _I: Integer);
begin
     _F:= _D.FindField( _FielName);
     if Assigned( _F)
     then
         case _F.DataType
         of
           ftSmallint,
           ftWord,
           ftLargeint,
           ftInteger: _I:= _F.AsInteger;
           else       _I:= 0;
           end
     else
         _I:= 0;
end;

function TOD_TextTableManager.Execute_Modele( ODRE_Table: TODRE_Table;
                                              Nouveau_Modele: Boolean): Boolean;
var
   OD_Datasets: TOD_Dataset_Columns_array;
   procedure TraiteDataset( iDataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      Prefixe: String;
      procedure TraiteLigne( L: array of TOD_Dataset_Column);
      var
         I:Integer;
         OD_Dataset_Column: TOD_Dataset_Column;
         NomStyle: String;
      begin
           for I:= Low( L) to High( L)
           do
             begin
             OD_Dataset_Column:= L[ I];
             NomStyle:= Prefixe+'_'+OD_Dataset_Column.FieldName;
             C.Modelise_style_champ( NomStyle);
             end;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        Prefixe:= '_'+ODRE_Table.Nom+'_'+OD_Dataset_Columns.Nom;
        TraiteLigne( OD_Dataset_Columns.Avant.DCA);
        TraiteDataset( iDataset+1);
        TraiteLigne( OD_Dataset_Columns.Apres.DCA);
   end;
begin
     Result:= False;
     Init( ODRE_Table);
     if C.D.is_Calc then exit;
     C.Cree_Styles_de_base;
     ODRE_Table.Assure_Modele( C);

     OD_Datasets:= ODRE_Table.OD_Datasets;

     TraiteDataset( 0);

     C.Insere_table( Nouveau_Modele);

     Result:= True;
end;

function TOD_TextTableManager.Remplit( ODRE_Table: TODRE_Table): Boolean;
type
    TMergeInfo
    =
     record
       Line, Start, Stop: Integer;
     end;
var
   OD_Datasets: TOD_Dataset_Columns_array;
   OD_SurTitre: TOD_SurTitre;
   OD_Merge: TOD_Merge;

   iColonne: Integer;
   NomStyle: String;

   //Merge
   IMerge: Integer;
   NotEmpty_Count: Integer;
   NomStyleMerge: String;
   StyleMerge_exists: Boolean;

   //Surtitre
   iSurTitre,
   Debut, Fin: Integer;
   CellName: String;

   //curseurs de fusion de colonnes
   MergeInfo: array of TMergeInfo;

   procedure Add_Merge_Bookmark( Ligne, Debut, Fin: Integer);
   begin
        if Fin <= Debut then exit;

        SetLength( MergeInfo, Length(MergeInfo)+1);

        with MergeInfo[High(MergeInfo)]
        do
          begin
          Line := Ligne;
          Start:= Debut;
          Stop := Fin;
          end;
   end;
   procedure Traite_MergeBookmarks;
   //var
   //   iMerge:Integer;
   //   Ligne, Debut, Fin: Integer;
   //   cnDebut, cnFin: String;
   begin
        //for iMerge:= High(MergeInfo) downto Low(MergeInfo)
        //do
        //  begin
        //  with MergeInfo[iMerge]
        //  do
        //    begin
        //    Ligne:= Line ;
        //    Debut:= Start;
        //    Fin  := Stop ;
        //    end;
        //  cnDebut:= CellName_from_XY(Debut, Ligne);
        //  cnFin  := CellName_from_XY(Fin  , Ligne);
        //
        //  Cursor:= Table.createCursorByCellName( cnDebut);
        //  Cursor.gotoCellByName( cnFin, true);
        //  Cursor.mergeRange;
        //  end;
        //SetLength( MergeInfo, 0);
   end;

   function Dataset0_Empty: Boolean;
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      ds: TDataset;
   begin
        Result:= True;
        if Length(OD_Datasets) = 0 then exit;
        OD_Dataset_Columns:= OD_Datasets[0];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;
        Result:= ds.IsEmpty;
   end;
   procedure TraiteDataset( iDataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      OD_Styles: TOD_Styles;
      ds: TDataset;
      Prefixe: String;
      iChamp: Integer;
      fBoldLine    : TField; BoldLine : Boolean;
      fNewGroup    : TField; NewGroup : Boolean;
      fEndGroup    : TField; EndGroup : Boolean;
      fGroupSize   : TField; GroupSize: Integer;
      fSizePourcent: TField; SizePourcent: Integer;
      fLineSize    : TField; LineSize : Integer;
      fNewPage  : TField; NewPage  : Boolean;
      GroupDefined: Boolean;
      procedure TraiteLigne( L: array of TOD_Dataset_Column);
      var
         Row : TOD_TABLE_ROW;
         Cell: TOD_TABLE_CELL;
         Paragraph: TOD_PARAGRAPH;
         Frame: TOD_FRAME;
         Image: TOD_IMAGE;
         I:Integer;
         OD_Dataset_Column: TOD_Dataset_Column;
         FieldName: String;
         F: TField;

         CellStyle_FieldName: String;
         CellStyle_Field: TField;
         CellStyle: String;
         sCellValue: String;
         Gras: Boolean;
      begin
           if Length( L) =0 then exit;
           //if J mod 10 = 0        servait pour éviter sautillement
           //then                   à l'ouverture par OpenOffice
           //    C.New_Soft_page_break;
           if NewPage
           then
               ODRE_Table.NewPage( C);


           ROW:= C.NewRow;
           Row.Formate( Length( ODRE_Table.Columns));
           for I:= Low( L) to High( L)
           do
             begin
             OD_Dataset_Column:= L[ I];
             FieldName:= OD_Dataset_Column.FieldName;
             CellStyle_FieldName:= FieldName+'_CellStyle';

             CellStyle_Field:= ds.FindField( CellStyle_FieldName);
             if CellStyle_Field = nil
             then
                 CellStyle:= ''
             else
                 CellStyle:= CellStyle_Field.AsString;

             F:= ds.FindField( FieldName);
             if Assigned( F)
             then
                 begin
                 iColonne:= OD_Dataset_Column.Debut;

                 sCellValue:= F.DisplayText;
                 if CellStyle = ''
                 then
                     NomStyle:= Prefixe+'_'+OD_Dataset_Column.FieldName
                 else
                     NomStyle:= CellStyle;

                 if iColonne <= High( ODRE_Table.Columns)
                 then
                     begin
                     Gras:= NewGroup or EndGroup or BoldLine;

                     Cell     := Row.Cells     [iColonne];
                     Paragraph:= Row.Paragraphs[iColonne];
                     Paragraph.Set_Style( NomStyle, Gras, GroupSize, LineSize, SizePourcent);

                     if     (1 = Pos('graphic',FieldName))
                        and (sCellValue <> '')
                     then
                         begin
                         Frame:= Paragraph.NewFrame;
                         Image:= Frame.NewImage_as_Character( sCellValue);
                         end
                     else
                         Paragraph.AddText( sCellValue);

                     C.Formate_Cellule( iColonne, Row.Row,
                                        NewGroup and ODRE_Table.Bordure_Ligne,
                                        EndGroup and ODRE_Table.Bordure_Ligne);
                     Row.Fusionne( OD_Dataset_Column.Debut, OD_Dataset_Column.Fin);
                     end;
                 end;
             end;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;

        Prefixe:= '_'+ODRE_Table.Nom+'_'+OD_Dataset_Columns.Nom;
        //Styles de colonnes
        OD_Styles:= OD_Dataset_Columns.OD_Styles;
        if Assigned( OD_Styles)
        then
            begin
            for iChamp:= 0 to ds.FieldCount - 1
            do
              if iChamp <= High( OD_Styles.Styles)
              then
                  begin
                  NomStyle:= Prefixe+'_'+ds.Fields[iChamp].FieldName;
                  C.Change_style_parent( NomStyle, OD_Styles.Styles[ iChamp]);
                  end;
            end;

        ds.First;
        while not ds.Eof
        do
          begin
           BooleanFieldValue( ds, 'BoldLine'    , fBoldLine    , BoldLine );
           BooleanFieldValue( ds, 'NewGroup'    , fNewGroup    , NewGroup );
           BooleanFieldValue( ds, 'EndGroup'    , fEndGroup    , EndGroup );
           IntegerFieldValue( ds, 'GroupSize'   , fGroupSize   , GroupSize);
           IntegerFieldValue( ds, 'SizePourcent', fSizePourcent, SizePourcent);
           IntegerFieldValue( ds, 'LineSize'    , fLineSize    , LineSize );
           BooleanFieldValue( ds, 'NewPage'     , fNewPage     , NewPage  );

          GroupDefined
          :=
               Assigned( fNewGroup )
            or Assigned( fEndGroup )
            or Assigned( fGroupSize)
            or Assigned( fSizePourcent);

          if OD_Dataset_Columns.Avant.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Avant.DCA);
          TraiteDataset( iDataset+1);
          if OD_Dataset_Columns.Apres.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Apres.DCA);

          ds.Next;
          end;
   end;
begin
     Result:= False;

     Init( ODRE_Table);
     if C.D.is_Calc then exit;
     ODRE_Table.from_Doc( C);

     OD_Datasets:= ODRE_Table.OD_Datasets;
     OD_SurTitre:= ODRE_Table.OD_SurTitre;
     OD_Merge   := ODRE_Table.OD_Merge;

     SetLength( MergeInfo, 0);

     if not C.Table_Existe
     then
         begin
         if not C.Bookmark_Existe then exit;
         if Dataset0_Empty        then exit;

         C.Insere_table_au_bookmark;
         end;

     ODRE_Table.Dimensionne_Colonnes( C);
     //Titres
     ODRE_Table.Ajoute_Titres( C);

     //Lignes
     TraiteDataset( 0);


     //Merge
     //NomStyleMerge:= C.NomStyleMerge;
     //StyleMerge_exists:= C.ParagraphStyles.hasByName( NomStyleMerge);
     //if Assigned( OD_Merge)
     //then
     //    while J > JTitre   //JTitre n° ligne des titres
     //    do
     //      begin
     //      for iMerge:= High(OD_Merge.Debut) downto Low(OD_Merge.Debut)
     //      do
     //        begin
     //        Debut     := OD_Merge.Debut  [iMerge];
     //        Fin       := OD_Merge.Fin    [iMerge];
     //
     //        NotEmpty_Count:= 0;
     //        for iColonne:= Debut to Fin
     //        do
     //          begin
     //          CellName:= CellName_from_XY(iColonne, J);
     //          CellCursor:= Table.getCellByName( CellName);
     //          sCellValue:= CellCursor.getString;
     //          if sCellValue <> ''
     //          then
     //              Inc( NotEmpty_Count);
     //          if NotEmpty_Count > 1 then break;
     //          end;
     //
     //        if NotEmpty_Count <= 1
     //        then
     //            begin
     //            //CellName:= CellName_from_XY(Debut, J);
     //            //CellCursor:= Table.getCellByName( CellName);
     //            //sCellValue:= CellCursor.getFormula;
     //
     //            CellName:= CellName_from_XY(Debut, J);
     //
     //            CellCursor:= Table.createCursorByCellName( CellName);
     //            CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //            //xray( CellCursor);
     //            CellCursor.mergeRange;
     //
     //            CellCursor:= Table.getCellByName( CellName);
     //            if StyleMerge_exists
     //            then
     //                begin
     //                TextCursor:= CellCursor.CreateTextCursor;
     //                TextCursor.ParaStyleName:= NomStyleMerge;
     //                end;
     //
     //            //CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //            //TextCursor:= CellCursor.CreateTextCursor;
     //            //CellCursor.insertString( TextCursor, sCellValue, false);
     //            end;
     //        end;
     //      Dec( J);
     //      end;
     //      
     //Traite_MergeBookmarks;

     ODRE_Table.Traite_Bordure( C);


     //SurTitres
     //if     ODRE_Table.SurTitre_Actif
     //   and not C.MasquerTitreColonnes
     //then
     //    begin
     //    J:= 0;
     //    for iSurTitre:= High(OD_SurTitre.Libelle) downto Low(OD_SurTitre.Libelle)
     //    do
     //      begin
     //      sCellValue:= OD_SurTitre.Libelle[iSurTitre];
     //      Debut     := OD_SurTitre.Debut  [iSurTitre];
     //      Fin       := OD_SurTitre.Fin    [iSurTitre];
     //
     //      CellName:= CellName_from_XY(Debut, J);
     //      CellCursor:= Table.createCursorByCellName( CellName);
     //      CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //      //xray( CellCursor);
     //      CellCursor.mergeRange;
     //
     //      CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //      TextCursor:= CellCursor.CreateTextCursor;
     //      CellCursor.insertString( TextCursor, sCellValue, false);
     //      end;
     //    end;

     Result:= True;
end;

function TOD_TextTableManager.Remplit_sans_tableau( ODRE_Table: TODRE_Table): Boolean;
type
    TMergeInfo
    =
     record
       Line, Start, Stop: Integer;
     end;
var
   OD_Datasets: TOD_Dataset_Columns_array;
   OD_SurTitre: TOD_SurTitre;
   OD_Merge: TOD_Merge;

   iColonne: Integer;
   NomStyle: String;

   //Merge
   IMerge: Integer;
   NotEmpty_Count: Integer;
   NomStyleMerge: String;
   StyleMerge_exists: Boolean;

   //Surtitre
   iSurTitre,
   Debut, Fin: Integer;
   CellName: String;

   Paragraph: TOD_PARAGRAPH;

   function Dataset0_Empty: Boolean;
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      ds: TDataset;
   begin
        Result:= True;
        if Length(OD_Datasets) = 0 then exit;
        OD_Dataset_Columns:= OD_Datasets[0];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;
        Result:= ds.IsEmpty;
   end;
   procedure TraiteDataset( iDataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      OD_Styles: TOD_Styles;
      ds: TDataset;
      Prefixe: String;
      iChamp: Integer;
      fBoldLine    : TField; BoldLine : Boolean;
      fNewGroup    : TField; NewGroup : Boolean;
      fEndGroup    : TField; EndGroup : Boolean;
      fGroupSize   : TField; GroupSize: Integer;
      fSizePourcent: TField; SizePourcent: Integer;
      fLineSize    : TField; LineSize : Integer;
      fNewPage  : TField; NewPage  : Boolean;
      GroupDefined: Boolean;
      procedure TraiteLigne( L: array of TOD_Dataset_Column);
      var
         Frame: TOD_FRAME;
         Image: TOD_IMAGE;
         I:Integer;
         OD_Dataset_Column: TOD_Dataset_Column;
         FieldName: String;
         F: TField;

         CellStyle_FieldName: String;
         CellStyle_Field: TField;
         CellStyle: String;
         sCellValue: String;
         Gras: Boolean;
      begin
           if Length( L) =0 then exit;

           if NewPage
           then
               begin
               FreeAndNil( Paragraph);
               Paragraph:= ODRE_Table.Cree_Paragraphe_Tabule( C, OD_Styles, True);
               end;

           for I:= Low( L) to High( L)
           do
             begin
             OD_Dataset_Column:= L[ I];
             FieldName:= OD_Dataset_Column.FieldName;
             CellStyle_FieldName:= FieldName+'_CellStyle';

             CellStyle_Field:= ds.FindField( CellStyle_FieldName);
             if CellStyle_Field = nil
             then
                 CellStyle:= ''
             else
                 CellStyle:= CellStyle_Field.AsString;

             F:= ds.FindField( FieldName);
             if Assigned( F)
             then
                 begin
                 iColonne:= OD_Dataset_Column.Debut;

                 sCellValue:= F.DisplayText;
                 if CellStyle = ''
                 then
                     NomStyle:= Prefixe+'_'+OD_Dataset_Column.FieldName
                 else
                     NomStyle:= CellStyle;

                 if iColonne <= High( ODRE_Table.Columns)
                 then
                     begin
                     Gras:= NewGroup or EndGroup or BoldLine;

                     if iColonne > Low(L)
                     then
                         Paragraph.AddTab;

                     if     (1 = Pos('graphic',FieldName))
                        and (sCellValue <> '')
                     then
                         begin
                         Frame:= Paragraph.NewFrame;
                         Image:= Frame.NewImage_as_Character( sCellValue);
                         end
                     else
                         Paragraph.AddText( sCellValue, NomStyle, Gras, GroupSize, LineSize, SizePourcent);
                     end;
                 end;
             end;
           Paragraph.Add_CR_NL;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;

        Prefixe:= '_'+ODRE_Table.Nom+'_'+OD_Dataset_Columns.Nom;
        //Styles de colonnes
        OD_Styles:= OD_Dataset_Columns.OD_Styles;
        if Assigned( OD_Styles)
        then
            begin
            for iChamp:= 0 to ds.FieldCount - 1
            do
              if iChamp <= High( OD_Styles.Styles)
              then
                  begin
                  NomStyle:= Prefixe+'_'+ds.Fields[iChamp].FieldName;
                  C.Change_style_parent( NomStyle, OD_Styles.Styles[ iChamp]);
                  end;
            end;
        if Paragraph = nil
        then
            Paragraph:= ODRE_Table.Cree_Paragraphe_Tabule( C, OD_Styles);

        ds.First;
        while not ds.Eof
        do
          begin
           BooleanFieldValue( ds, 'BoldLine'    , fBoldLine    , BoldLine );
           BooleanFieldValue( ds, 'NewGroup'    , fNewGroup    , NewGroup );
           BooleanFieldValue( ds, 'EndGroup'    , fEndGroup    , EndGroup );
           IntegerFieldValue( ds, 'GroupSize'   , fGroupSize   , GroupSize);
           IntegerFieldValue( ds, 'SizePourcent', fSizePourcent, SizePourcent);
           IntegerFieldValue( ds, 'LineSize'    , fLineSize    , LineSize );
           BooleanFieldValue( ds, 'NewPage'     , fNewPage     , NewPage  );

          GroupDefined
          :=
               Assigned( fNewGroup )
            or Assigned( fEndGroup )
            or Assigned( fGroupSize)
            or Assigned( fSizePourcent);

          if OD_Dataset_Columns.Avant.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Avant.DCA);
          TraiteDataset( iDataset+1);
          if OD_Dataset_Columns.Apres.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Apres.DCA);

          ds.Next;
          end;
   end;
begin
     Result:= False;

     Init( ODRE_Table);
     if C.D.is_Calc then exit;
     ODRE_Table.from_Doc( C);

     OD_Datasets:= ODRE_Table.OD_Datasets;
     OD_SurTitre:= ODRE_Table.OD_SurTitre;
     OD_Merge   := ODRE_Table.OD_Merge;

     C.D.Ensure_style_text_bold;
     ODRE_Table.Dimensionne_Colonnes( C);
     Paragraph:= nil;

     //Titres
     ODRE_Table.Ajoute_Titres_sans_tableau(C);

     //Lignes
     TraiteDataset( 0);


     //Merge
     //NomStyleMerge:= C.NomStyleMerge;
     //StyleMerge_exists:= C.ParagraphStyles.hasByName( NomStyleMerge);
     //if Assigned( OD_Merge)
     //then
     //    while J > JTitre   //JTitre n° ligne des titres
     //    do
     //      begin
     //      for iMerge:= High(OD_Merge.Debut) downto Low(OD_Merge.Debut)
     //      do
     //        begin
     //        Debut     := OD_Merge.Debut  [iMerge];
     //        Fin       := OD_Merge.Fin    [iMerge];
     //
     //        NotEmpty_Count:= 0;
     //        for iColonne:= Debut to Fin
     //        do
     //          begin
     //          CellName:= CellName_from_XY(iColonne, J);
     //          CellCursor:= Table.getCellByName( CellName);
     //          sCellValue:= CellCursor.getString;
     //          if sCellValue <> ''
     //          then
     //              Inc( NotEmpty_Count);
     //          if NotEmpty_Count > 1 then break;
     //          end;
     //
     //        if NotEmpty_Count <= 1
     //        then
     //            begin
     //            //CellName:= CellName_from_XY(Debut, J);
     //            //CellCursor:= Table.getCellByName( CellName);
     //            //sCellValue:= CellCursor.getFormula;
     //
     //            CellName:= CellName_from_XY(Debut, J);
     //
     //            CellCursor:= Table.createCursorByCellName( CellName);
     //            CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //            //xray( CellCursor);
     //            CellCursor.mergeRange;
     //
     //            CellCursor:= Table.getCellByName( CellName);
     //            if StyleMerge_exists
     //            then
     //                begin
     //                TextCursor:= CellCursor.CreateTextCursor;
     //                TextCursor.ParaStyleName:= NomStyleMerge;
     //                end;
     //
     //            //CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //            //TextCursor:= CellCursor.CreateTextCursor;
     //            //CellCursor.insertString( TextCursor, sCellValue, false);
     //            end;
     //        end;
     //      Dec( J);
     //      end;
     //      
     //Traite_MergeBookmarks;

     ODRE_Table.Traite_Bordure( C);


     //SurTitres
     //if     ODRE_Table.SurTitre_Actif
     //   and not C.MasquerTitreColonnes
     //then
     //    begin
     //    J:= 0;
     //    for iSurTitre:= High(OD_SurTitre.Libelle) downto Low(OD_SurTitre.Libelle)
     //    do
     //      begin
     //      sCellValue:= OD_SurTitre.Libelle[iSurTitre];
     //      Debut     := OD_SurTitre.Debut  [iSurTitre];
     //      Fin       := OD_SurTitre.Fin    [iSurTitre];
     //
     //      CellName:= CellName_from_XY(Debut, J);
     //      CellCursor:= Table.createCursorByCellName( CellName);
     //      CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //      //xray( CellCursor);
     //      CellCursor.mergeRange;
     //
     //      CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //      TextCursor:= CellCursor.CreateTextCursor;
     //      CellCursor.insertString( TextCursor, sCellValue, false);
     //      end;
     //    end;

     Result:= True;
end;

function TOD_TextTableManager.Remplit_HTML( ODRE_Table: TODRE_Table; var T :Text): Boolean;
type                                 // en cours de mise au point
    TMergeInfo
    =
     record
       Line, Start, Stop: Integer;
     end;
var
   OD_Datasets: TOD_Dataset_Columns_array;
   OD_SurTitre: TOD_SurTitre;
   OD_Merge: TOD_Merge;

   iColonne: Integer;
   NomStyle: String;

   //Merge
   IMerge: Integer;
   NotEmpty_Count: Integer;
   NomStyleMerge: String;
   StyleMerge_exists: Boolean;

   //Surtitre
   iSurTitre,
   Debut, Fin: Integer;
   CellName: String;

   //curseurs de fusion de colonnes
   MergeInfo: array of TMergeInfo;

   procedure Add_Merge_Bookmark( Ligne, Debut, Fin: Integer);
   begin
        if Fin <= Debut then exit;

        SetLength( MergeInfo, Length(MergeInfo)+1);

        with MergeInfo[High(MergeInfo)]
        do
          begin
          Line := Ligne;
          Start:= Debut;
          Stop := Fin;
          end;
   end;
   procedure Traite_MergeBookmarks;
   //var
   //   iMerge:Integer;
   //   Ligne, Debut, Fin: Integer;
   //   cnDebut, cnFin: String;
   begin
        //for iMerge:= High(MergeInfo) downto Low(MergeInfo)
        //do
        //  begin
        //  with MergeInfo[iMerge]
        //  do
        //    begin
        //    Ligne:= Line ;
        //    Debut:= Start;
        //    Fin  := Stop ;
        //    end;
        //  cnDebut:= CellName_from_XY(Debut, Ligne);
        //  cnFin  := CellName_from_XY(Fin  , Ligne);
        //
        //  Cursor:= Table.createCursorByCellName( cnDebut);
        //  Cursor.gotoCellByName( cnFin, true);
        //  Cursor.mergeRange;
        //  end;
        //SetLength( MergeInfo, 0);
   end;

   function Dataset0_Empty: Boolean;
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      ds: TDataset;
   begin
        Result:= True;
        if Length(OD_Datasets) = 0 then exit;
        OD_Dataset_Columns:= OD_Datasets[0];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;
        Result:= ds.IsEmpty;
   end;
   procedure TraiteDataset( iDataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      OD_Styles: TOD_Styles;
      ds: TDataset;
      Prefixe: String;
      iChamp: Integer;
      fBoldLine : TField; BoldLine : Boolean;
      fNewGroup : TField; NewGroup : Boolean;
      fEndGroup : TField; EndGroup : Boolean;
      fGroupSize: TField; GroupSize: Integer;
      fSizePourcent: TField; SizePourcent: Integer;
      fLineSize : TField; LineSize : Integer;
      GroupDefined: Boolean;
      fNewPage  : TField; NewPage  : Boolean;
      procedure TraiteLigne( L: array of TOD_Dataset_Column);
      var
         Row : TOD_TABLE_ROW;
         Cell: TOD_TABLE_CELL;
         Paragraph: TOD_PARAGRAPH;
         Frame: TOD_FRAME;
         Image: TOD_IMAGE;
         I:Integer;
         OD_Dataset_Column: TOD_Dataset_Column;
         FieldName: String;
         F: TField;

         CellStyle_FieldName: String;
         CellStyle_Field: TField;
         CellStyle: String;
         sCellValue: String;
         Gras: Boolean;
      begin
           if Length( L) =0 then exit;
           //if J mod 10 = 0        servait pour éviter sautillement
           //then                   à l'ouverture par OpenOffice
           //    C.New_Soft_page_break;
           if NewPage
           then
               ODRE_Table.NewPage( C);
           ROW:= C.NewRow;
           Row.Formate( Length( ODRE_Table.Columns));
           for I:= Low( L) to High( L)
           do
             begin
             OD_Dataset_Column:= L[ I];
             FieldName:= OD_Dataset_Column.FieldName;
             CellStyle_FieldName:= FieldName+'_CellStyle';

             CellStyle_Field:= ds.FindField( CellStyle_FieldName);
             if CellStyle_Field = nil
             then
                 CellStyle:= ''
             else
                 CellStyle:= CellStyle_Field.AsString;

             F:= ds.FindField( FieldName);
             if Assigned( F)
             then
                 begin
                 iColonne:= OD_Dataset_Column.Debut;

                 sCellValue:= F.DisplayText;
                 if CellStyle = ''
                 then
                     NomStyle:= Prefixe+'_'+OD_Dataset_Column.FieldName
                 else
                     NomStyle:= CellStyle;

                 if iColonne <= High( ODRE_Table.Columns)
                 then
                     begin
                     Gras:= NewGroup or EndGroup or BoldLine;

                     Cell     := Row.Cells     [iColonne];
                     Paragraph:= Row.Paragraphs[iColonne];
                     Paragraph.Set_Style( NomStyle, Gras, GroupSize, LineSize, SizePourcent);

                     if     (1 = Pos('graphic',FieldName))
                        and (sCellValue <> '')
                     then
                         begin
                         Frame:= Paragraph.NewFrame;
                         Image:= Frame.NewImage_as_Character( sCellValue);
                         end
                     else
                         Paragraph.AddText( sCellValue);

                     if ODRE_Table.Bordure_Ligne
                     then
                         begin
                         //Cell.TopBorder   := BorderLine_NewGroup;
                         //Cell.BottomBorder:= BorderLine_EndGroup;
                         end;
                     Row.Fusionne( OD_Dataset_Column.Debut, OD_Dataset_Column.Fin);
                     end;
                 end;
             end;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;

        Prefixe:= '_'+ODRE_Table.Nom+'_'+OD_Dataset_Columns.Nom;
        //Styles de colonnes
        OD_Styles:= OD_Dataset_Columns.OD_Styles;
        if Assigned( OD_Styles)
        then
            begin
            for iChamp:= 0 to ds.FieldCount - 1
            do
              if iChamp <= High( OD_Styles.Styles)
              then
                  begin
                  NomStyle:= Prefixe+'_'+ds.Fields[iChamp].FieldName;
                  C.Change_style_parent( NomStyle, OD_Styles.Styles[ iChamp]);
                  end;
            end;

        ds.First;
        while not ds.Eof
        do
          begin
          BooleanFieldValue( ds, 'BoldLine'    , fBoldLine    , BoldLine );
          BooleanFieldValue( ds, 'NewGroup'    , fNewGroup    , NewGroup );
          BooleanFieldValue( ds, 'EndGroup'    , fEndGroup    , EndGroup );
          IntegerFieldValue( ds, 'GroupSize'   , fGroupSize   , GroupSize);
          IntegerFieldValue( ds, 'SizePourcent', fSizePourcent, SizePourcent);
          IntegerFieldValue( ds, 'LineSize'    , fLineSize    , LineSize );
          BooleanFieldValue( ds, 'NewPage'     , fNewPage     , NewPage  );

          GroupDefined
          :=
               Assigned( fNewGroup )
            or Assigned( fEndGroup )
            or Assigned( fGroupSize)
            or Assigned( fSizePourcent);

          if OD_Dataset_Columns.Avant.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Avant.DCA);
          TraiteDataset( iDataset+1);
          if OD_Dataset_Columns.Apres.Triggered
          then
              TraiteLigne( OD_Dataset_Columns.Apres.DCA);

          ds.Next;
          end;
   end;
begin
     Result:= False;

     WriteLn( T, '<table>');

     Init( ODRE_Table);
     if C.D.is_Calc then exit;
     ODRE_Table.from_Doc( C);

     OD_Datasets:= ODRE_Table.OD_Datasets;
     OD_SurTitre:= ODRE_Table.OD_SurTitre;
     OD_Merge   := ODRE_Table.OD_Merge;

     SetLength( MergeInfo, 0);

     if not C.Table_Existe
     then
         begin
         if not C.Bookmark_Existe then exit;
         if Dataset0_Empty        then exit;

         C.Insere_table_au_bookmark;
         end;

     ODRE_Table.Dimensionne_Colonnes( C);
     //Titres
     ODRE_Table.Ajoute_Titres( C);

     //Lignes
     TraiteDataset( 0);


     //Merge
     //NomStyleMerge:= C.NomStyleMerge;
     //StyleMerge_exists:= C.ParagraphStyles.hasByName( NomStyleMerge);
     //if Assigned( OD_Merge)
     //then
     //    while J > JTitre   //JTitre n° ligne des titres
     //    do
     //      begin
     //      for iMerge:= High(OD_Merge.Debut) downto Low(OD_Merge.Debut)
     //      do
     //        begin
     //        Debut     := OD_Merge.Debut  [iMerge];
     //        Fin       := OD_Merge.Fin    [iMerge];
     //
     //        NotEmpty_Count:= 0;
     //        for iColonne:= Debut to Fin
     //        do
     //          begin
     //          CellName:= CellName_from_XY(iColonne, J);
     //          CellCursor:= Table.getCellByName( CellName);
     //          sCellValue:= CellCursor.getString;
     //          if sCellValue <> ''
     //          then
     //              Inc( NotEmpty_Count);
     //          if NotEmpty_Count > 1 then break;
     //          end;
     //
     //        if NotEmpty_Count <= 1
     //        then
     //            begin
     //            //CellName:= CellName_from_XY(Debut, J);
     //            //CellCursor:= Table.getCellByName( CellName);
     //            //sCellValue:= CellCursor.getFormula;
     //
     //            CellName:= CellName_from_XY(Debut, J);
     //
     //            CellCursor:= Table.createCursorByCellName( CellName);
     //            CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //            //xray( CellCursor);
     //            CellCursor.mergeRange;
     //
     //            CellCursor:= Table.getCellByName( CellName);
     //            if StyleMerge_exists
     //            then
     //                begin
     //                TextCursor:= CellCursor.CreateTextCursor;
     //                TextCursor.ParaStyleName:= NomStyleMerge;
     //                end;
     //
     //            //CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //            //TextCursor:= CellCursor.CreateTextCursor;
     //            //CellCursor.insertString( TextCursor, sCellValue, false);
     //            end;
     //        end;
     //      Dec( J);
     //      end;
     //
     //Traite_MergeBookmarks;

     ODRE_Table.Traite_Bordure( C);


     //SurTitres
     //if     ODRE_Table.SurTitre_Actif
     //   and not C.MasquerTitreColonnes
     //then
     //    begin
     //    J:= 0;
     //    for iSurTitre:= High(OD_SurTitre.Libelle) downto Low(OD_SurTitre.Libelle)
     //    do
     //      begin
     //      sCellValue:= OD_SurTitre.Libelle[iSurTitre];
     //      Debut     := OD_SurTitre.Debut  [iSurTitre];
     //      Fin       := OD_SurTitre.Fin    [iSurTitre];
     //
     //      CellName:= CellName_from_XY(Debut, J);
     //      CellCursor:= Table.createCursorByCellName( CellName);
     //      CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
     //      //xray( CellCursor);
     //      CellCursor.mergeRange;
     //
     //      CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
     //      TextCursor:= CellCursor.CreateTextCursor;
     //      CellCursor.insertString( TextCursor, sCellValue, false);
     //      end;
     //    end;

     WriteLn( T, '</table>');
     Result:= True;
end;

end.
    <style:style style:name="P7" style:family="paragraph" style:parent-style-name="Standard">
      <style:paragraph-properties>
        <style:tab-stops>
          <style:tab-stop style:position="0.661cm"/>
          <style:tab-stop style:position="1.931cm"/>
          <style:tab-stop style:position="2.408cm"/>
          <style:tab-stop style:position="5.715cm"/>
          <style:tab-stop style:position="7.303cm"/>
          <style:tab-stop style:position="8.996cm"/>
          <style:tab-stop style:position="10.769cm"/>
          <style:tab-stop style:position="12.197cm"/>
          <style:tab-stop style:position="13.653cm"/>
          <style:tab-stop style:position="15.134cm"/>
          <style:tab-stop style:position="16.642cm"/>
          <style:tab-stop style:position="18.389cm"/>
          <style:tab-stop style:position="18.441cm"/>
          <style:tab-stop style:position="19.844cm"/>
          <style:tab-stop style:position="21.378cm"/>
          <style:tab-stop style:position="22.807cm"/>
          <style:tab-stop style:position="24.606cm"/>
          <style:tab-stop style:position="26.061cm"/>
        </style:tab-stops>
      </style:paragraph-properties>
    </style:style>


<text:span text:style-name="T3"> CAPITAL SOCIAL </text:span>

    <style:style style:name="T3" style:family="text">
      <style:text-properties fo:font-weight="bold" style:font-weight-asian="bold" style:font-weight-complex="bold"/>
    </style:style>

    <style:style style:name="stylecaractere" style:family="text" style:parent-style-name="Definition">
      <style:text-properties fo:font-size="10pt" fo:font-weight="bold"/>
    </style:style>
    
