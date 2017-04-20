unit uBatpro_OD_TextTableManager;
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
    {$IFNDEF FPC}
    DOM,
    {$ELSE}
    DOM,
    {$ENDIF}
    uClean,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    //uUNO_ParagraphStyle,
    uOOoStrings,
    uOpenDocument,
    uOD_SurTitre,
    uOD_Merge,
    uOD_Styles,
    uODRE_Table,
    uOD_Column,
    uOD_TextTableContext,

    uChampDefinitions,
    uChampDefinition,
    uChamps,
    uChamp,
    uBatpro_Ligne,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Champ,
    uOD_BatproTextTableContext,
    uBatpro_OD_TextFieldsCreator,

  SysUtils, Classes, DB;

type
 TBatpro_OD_TextTableManager
 =
  class
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //Attributs
  public
    C: TOD_BatproTextTableContext;
  //Général
  private
    sl: TBatpro_StringList;
    Champs: TChamps;

    procedure Init( _Editing_Modele: Boolean; _NomFichierModele: String; _sl: TBatpro_StringList; _Nom: String);
    function  ComposeNomStyle_from_Field( I: Integer): String;
  //Gestion du titre des colonnes
  private
    slTitreColonne: TBatpro_StringList;
    procedure slTitreColonne_from_Document;
    function  ComposeNomTitreColonne_from_Field( I: Integer): String;
  //Gestion des largeurs de colonnes
  private
    slLargeurColonne: TBatpro_StringList;
    function  ComposeNomLargeurColonne_from_Field( I: Integer): String;
    procedure slLargeurColonne_from_Document;
  //Gestion de la composition
  private
    function  ComposeNomComposition: String;
  // Création d'une table maitre-détail à partir d'un tableau d'aggrégations
  public
    function Execute_Modele( _NomFichierModele: String;
                             _OD_Batpro_Table: TOD_Batpro_Table;
                             _Nouveau_Modele: Boolean): Boolean; overload;
    function Remplit( _NomFichierModele: String; _OD_Batpro_Table: TOD_Batpro_Table): Boolean; overload;
  end;

var
   premier: boolean = true;

function CellName_from_XY( X, Y: Integer): String;

implementation

function CellName_from_XY( X, Y: Integer): String;
begin
     Result:=  Chr(Ord('A')+X) + IntToStr(Y+1);
end;

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;
begin
     Result:=  CellName_from_XY( Left , Top   )
              +':'
              +CellName_from_XY( Right, Bottom);
end;

{ TBatpro_OD_TextTableManager }

constructor TBatpro_OD_TextTableManager.Create( _D: TOpenDocument);
begin
     C:= TOD_BatproTextTableContext.Create( _D);
     slTitreColonne  := TBatpro_StringList.Create;
     slLargeurColonne:= TBatpro_StringList.Create;
end;

destructor TBatpro_OD_TextTableManager.Destroy;
begin
     FreeAndNil( C);
     FreeAndNil( slLargeurColonne);
     FreeAndNil( slTitreColonne  );
     inherited;
end;

procedure TBatpro_OD_TextTableManager.Init( _Editing_Modele: Boolean; _NomFichierModele: String; _sl: TBatpro_StringList; _Nom: String);
var
   bl: TBatpro_Ligne;
begin
     C.Init( _Nom);

     sl:= _sl;
     bl:= Batpro_Ligne_from_sl( sl, 0);
     if Assigned( bl)
     then
         Champs:= bl.Champs
     else
         Champs:= nil;
end;

function TBatpro_OD_TextTableManager.ComposeNomStyle_from_Field( I: Integer): String;
begin
     Result:= C.ComposeNomStyle_from_FieldName( Champs.Field_from_Index(I));
end;

function TBatpro_OD_TextTableManager.ComposeNomTitreColonne_from_Field( I: Integer): String;
begin
     Result:= C.ComposeNomTitreColonne_from_FieldName( Champs.Field_from_Index(I));
end;

function TBatpro_OD_TextTableManager.ComposeNomLargeurColonne_from_Field( I: Integer): String;
begin
     Result:= C.ComposeNomLargeurColonne_from_FieldName( Champs.Field_from_Index(I));
end;

function TBatpro_OD_TextTableManager.ComposeNomComposition: String;
begin
     Result:= '_Composition_'+C.Nom;
end;

procedure TBatpro_OD_TextTableManager.slTitreColonne_from_Document;
var
   NomComposition: String;
   ValeurComposition: String;
   NomTitreColonne: String;
   NomColonne: String;
   Titre_Colonne: String;
begin
     NomComposition:= ComposeNomComposition;
     ValeurComposition:= C.Lire( NomComposition);

     //NomTitreColonne:= ComposeNomTitreColonne_from_Field( I);
     slTitreColonne.Clear;
     while ValeurComposition <> sys_Vide
     do
       begin
       NomColonne:= StrToK( ',', ValeurComposition);
       NomTitreColonne:= C.ComposeNomTitreColonne_from_FieldName( NomColonne);
       Titre_Colonne:= C.Lire( NomTitreColonne);
       slTitreColonne.Values[ NomColonne]:= Titre_Colonne;
       end;
end;

procedure TBatpro_OD_TextTableManager.slLargeurColonne_from_Document;
var
   NomComposition: String;
   ValeurComposition: String;
   NomLargeurColonne: String;
   NomColonne: String;
   Largeur_Colonne: String;
begin
     NomComposition:= ComposeNomComposition;
     ValeurComposition:= C.Lire( NomComposition);

     //NomLargeurColonne:= ComposeNomLargeurColonne_from_Field( I);
     slLargeurColonne.Clear;
     while ValeurComposition <> sys_Vide
     do
       begin
       NomColonne:= StrToK( ',', ValeurComposition);
       NomLargeurColonne:= C.ComposeNomLargeurColonne_from_FieldName( NomColonne);
       Largeur_Colonne:= C.Lire( NomLargeurColonne);
       slLargeurColonne.Values[ NomColonne]:= Largeur_Colonne;
       end;
end;

function TBatpro_OD_TextTableManager.Execute_Modele( _NomFichierModele: String;
                                                     _OD_Batpro_Table: TOD_Batpro_Table;
                                                     _Nouveau_Modele: Boolean): Boolean;
var
   Niveaux: TOD_Niveau_array;
   procedure TraiteNiveau( iDataset: Integer; blParent: TBatpro_Ligne = nil);
   var
      Niveau: TOD_Niveau;
      bl: TBatpro_Ligne;
      Prefixe: String;
      procedure TraiteLigne( L: array of TOD_Champ);
      var
         I:Integer;
         OD_Champ: TOD_Champ;
         NomStyle: String;
      begin
           for I:= Low( L) to High( L)
           do
             begin
             OD_Champ:= L[ I];
             NomStyle:= Prefixe+'_'+OD_Champ.FieldName;
             C.Modelise_style_champ( NomStyle);
             end;
      end;
   begin
        if High( Niveaux) < iDataset then exit;

        Niveau:= Niveaux[iDataset];

        bl:= Niveau.Go_to( 0);

        Prefixe:= '_'+_OD_Batpro_Table.Nom+'_'+Niveau.Nom;
        if _Nouveau_Modele
        then
            Niveau.Ajoute_Tout_Avant;
        TraiteLigne( Niveau.Avant.CA);
        TraiteNiveau( iDataset+1, bl);
        TraiteLigne( Niveau.Apres.CA);
   end;
begin
     Init( True, _NomFichierModele, nil, _OD_Batpro_Table.Nom);
     _OD_Batpro_Table.Assure_Modele( C);
     _OD_Batpro_Table.from_Doc( C);
     C.Cree_Styles_de_base;

     Niveaux:= _OD_Batpro_Table.Niveaux;

     TraiteNiveau( 0);

     C.Insere_table( _Nouveau_Modele);

     Result:= True;
end;

function TBatpro_OD_TextTableManager.Remplit( _NomFichierModele: String;
                                              _OD_Batpro_Table: TOD_Batpro_Table): Boolean;
type
    TMergeInfo
    =
     record
       Line, Start, Stop: Integer;
     end;
var
   Niveaux: TOD_Niveau_array;
   OD_SurTitre: TOD_SurTitre;
   OD_Merge: TOD_Merge;

   NbColonnes: Integer;
   iColonne, J, JTitre: Integer;
   OD_Column: TOD_Column;
   NomStyle: String;
   ColumnLengths: array of Integer;
   ColumnEnds: array of Integer;

   //Merge
   IMerge: Integer;
   NotEmpty_Count: Integer;
   NomStyleMerge: String;
   StyleMerge_exists: Boolean;

   //Surtitre
   iSurTitre,
   OffSet_SurTitre: Integer;
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
   //   Cursor: OLEVariant;
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

   function Niveau0_Empty: Boolean;
   var
      Niveau: TOD_Niveau;
   begin
        Result:= True;
        if Length(Niveaux) = 0 then exit;
        Niveau:= Niveaux[0];
        Result:= Niveau.IsEmpty;
   end;
   procedure TraiteNiveau( iDataset: Integer; blParent: TBatpro_Ligne);
   var
      Niveau: TOD_Niveau;
      Row : TOD_TABLE_ROW;
      Cell: TOD_TABLE_CELL;
      Paragraph: TOD_PARAGRAPH;
      Frame: TOD_FRAME;
      Image: TOD_IMAGE;
      iNiveauLigne: Integer;
      bl: TBatpro_Ligne;
      Prefixe: String;

      cBoldLine  : TChamp; BoldLine : Boolean;
      cNewGroup  : TChamp; NewGroup : Boolean;
      cEndGroup  : TChamp; EndGroup : Boolean;
      cGroupSize : TChamp; GroupSize: Integer;
      cSizePourcent     : TChamp; SizePourcent     : Integer;
      cLineSize         : TChamp; LineSize         : Integer;
      cNewPage          : TChamp; NewPage          : Boolean;
      cLigneStylePrefixe: TChamp; LigneStylePrefixe: String;
      cGroupTitle: TChamp; GroupTitle: String;
      cGroupTitle_Column: TChamp; GroupTitle_Column: Integer;
      cGroupTitle_Style : TChamp; GroupTitle_Style : String;
      GroupDefined: Boolean;

      function GroupTitle_defined: Boolean;
      begin
           Result:= nil <> bl.Champs.Champ_from_Field( 'GroupTitle');
      end;

      procedure Insere_Ligne;
      begin
           Inc(J);
           ROW:= C.NewRow;
           Row.Formate( NbColonnes);
      end;

      procedure Ecrit_Cellule( _Colonne, _Ligne: Integer;
                               _Style : String;
                               _Valeur: String;
                               _FieldName: String= '');
      var
         Gras: Boolean;
      begin
           if _Colonne <= High( _OD_Batpro_Table.Columns)
           then
               begin
               Gras:= NewGroup or EndGroup or BoldLine;

               Cell     := Row.Cells     [_Colonne];
               Paragraph:= Row.Paragraphs[_Colonne];
               Paragraph.Set_Style( NomStyle, Gras, GroupSize, LineSize, SizePourcent);
               if     (1 = Pos('graphic',_FieldName))
                  and (_Valeur <> '')
               then
                   begin
                   Frame:= Paragraph.NewFrame;
                   Image:= Frame.NewImage_as_Character( _Valeur);
                   end
               else
                   Paragraph.AddText( _Valeur);

               //if _OD_Batpro_Table.Bordure_Ligne plante sur OD_ 3.2
               //then
               //    begin
               //    CellCursor.TopBorder   := BorderLine_NewGroup;
               //    CellCursor.BottomBorder:= BorderLine_EndGroup;
               //    end;
               end;
      end;

      procedure TraiteLigne( L: array of TOD_Champ);
      var
         I:Integer;
         OD_Champ: TOD_Champ;
         Champs: TChamps;
         Champ: TChamp;
         sCellValue: String;
      begin
           if bl = nil then exit;
           if Length( L) =0 then exit;


           if NewPage
           then
               _OD_Batpro_Table.NewPage( C, J, OffSet_SurTitre, JTitre);

           Insere_Ligne;
           Champs:= bl.Champs;

           for I:= Low( L) to High( L)
           do
             begin
             OD_Champ:= L[ I];

             Champ:= Champs.Champ_from_Field( OD_Champ.FieldName);
             if Assigned( Champ)
             then
                 begin
                 iColonne:= OD_Champ.Debut;

                 sCellValue:= Champ.Chaine;
                 NomStyle:= Prefixe+'_'+LigneStylePrefixe+OD_Champ.FieldName;

                 if nil = C.D.Find_style_paragraph_multiroot( NomStyle)
                 then
                     NomStyle:= Prefixe+'_'+OD_Champ.FieldName;

                 Ecrit_Cellule( iColonne, J, NomStyle, sCellValue, OD_Champ.FieldName);
                 Add_Merge_Bookmark( J, iColonne, OD_Champ.Fin);
                 C.Formate_Cellule( iColonne, Row.Row,
                                    NewGroup and _OD_Batpro_Table.Bordure_Ligne,
                                    EndGroup and _OD_Batpro_Table.Bordure_Ligne);
                 Row.Fusionne( OD_Champ.Debut, OD_Champ.Fin);
                 end
             else
                 Ecrit_Cellule( iColonne+1, J, '','Unknown field "'+OD_Champ.FieldName+'"');
             end;
      end;
      procedure TraiteStyles;
      var
         iChamp:Integer;
         //OD_Champ: TOD_Champ;
         Champs: TChamps;
         Champ: TChamp;
         OD_Styles: TOD_Styles;
      begin
           if bl = nil  then exit;

           Champs:= bl.Champs;

           OD_Styles:= Niveau.OD_Styles;
           if     Assigned( OD_Styles)
           then
               begin
               for iChamp:= 0 to Champs.Count - 1
               do
                 if iChamp <= High( OD_Styles.Styles)
                 then
                     begin
                     Champ:= Champs.Champ_from_Index( iChamp);
                     NomStyle:= Prefixe+'_'+Champ.Definition.Nom;
                     C.Change_style_parent( NomStyle, OD_Styles.Styles[ iChamp]);
                     end;
               end;
      end;
   begin
        if High( Niveaux) < iDataset then exit;

        Niveau:= Niveaux[iDataset];

        bl:= nil;

        Prefixe:= '_'+_OD_Batpro_Table.Nom+'_'+Niveau.Nom;
        for iNiveauLigne:= 0 to Niveau.Count - 1
        do
          begin
          bl:= Niveau.Go_to( iNiveauLigne);

          if Assigned( bl)
          then
              begin
              BooleanFieldValue( bl, 'BoldLine'         , cBoldLine         , BoldLine         );
              BooleanFieldValue( bl, 'NewGroup'         , cNewGroup         , NewGroup         );
              BooleanFieldValue( bl, 'EndGroup'         , cEndGroup         , EndGroup         );
              IntegerFieldValue( bl, 'GroupSize'        , cGroupSize        , GroupSize        );
              IntegerFieldValue( bl, 'SizePourcent'     , cSizePourcent     , SizePourcent     );
              IntegerFieldValue( bl, 'LineSize'         , cLineSize         , LineSize         );
              BooleanFieldValue( bl, 'NewPage'          , cNewPage          , NewPage          );
               StringFieldValue( bl, 'LigneStylePrefixe', cLigneStylePrefixe, LigneStylePrefixe);
               StringFieldValue( bl, 'GroupTitle'       , cGroupTitle       , GroupTitle       );
               StringFieldValue( bl, 'GroupTitle_Style' , cGroupTitle_Style , GroupTitle_Style );
              IntegerFieldValue( bl, 'GroupTitle_Column', cGroupTitle_Column, GroupTitle_Column);

              //if NewGroup
              //then
              //    begin
              //    BorderLine_NewGroup.InnerLineWidth:= 1;
              //    BorderLine_NewGroup.OuterLineWidth:= 1;
              //    end
              //else
              //    begin
              //    BorderLine_NewGroup.InnerLineWidth:= 0;
              //    BorderLine_NewGroup.OuterLineWidth:= 0;
              //    end;
              //
              //if    EndGroup
              //   or (cEndGroup = nil)
              //then
              //    begin
              //    BorderLine_EndGroup.InnerLineWidth:= 1;
              //    BorderLine_EndGroup.OuterLineWidth:= 1;
              //    end
              //else
              //    begin
              //    BorderLine_EndGroup.InnerLineWidth:= 0;
              //    BorderLine_EndGroup.OuterLineWidth:= 0;
              //    end;
              GroupDefined
              :=
                   Assigned( cNewGroup )
                or Assigned( cEndGroup )
                or Assigned( cGroupSize);

              if GroupTitle_defined
              then
                  begin
                  Insere_Ligne;
                  Ecrit_Cellule( GroupTitle_Column, J, GroupTitle_Style, GroupTitle);
                  end;
              GroupDefined
              :=
                   Assigned( cNewGroup )
                or Assigned( cEndGroup )
                or Assigned( cGroupSize);
              end
          else
              begin
              LigneStylePrefixe:= '';
              GroupDefined:= False;
              end;

          if Niveau.Avant_Triggered
          then
              TraiteLigne( Niveau.Avant.CA);
          TraiteNiveau( iDataset+1, bl);
          if Niveau.Apres_Triggered
          then
              TraiteLigne( Niveau.Apres.CA);
          end;

        //Styles de colonnes
        TraiteStyles;
   end;
begin
     Result:= False;

     //BorderLine_NewGroup:= CreateUnoStruct('com.sun.star.table.BorderLine');
     //BorderLine_EndGroup:= CreateUnoStruct('com.sun.star.table.BorderLine');
     //BorderLine_Vide    := CreateUnoStruct('com.sun.star.table.BorderLine');
     //BorderLine_Vide.InnerLineWidth:= 0;
     //BorderLine_Vide.OuterLineWidth:= 0;

     Init( False, _NomFichierModele, nil, _OD_Batpro_Table.Nom);
     _OD_Batpro_Table.from_Doc( C);

     Niveaux:= _OD_Batpro_Table.Niveaux;
     OD_SurTitre:= _OD_Batpro_Table.OD_SurTitre;
     OD_Merge   := _OD_Batpro_Table.OD_Merge;

     SetLength( MergeInfo, 0);

     if not C.Table_Existe
     then
         begin
         if not C.Bookmark_Existe then exit;
         C.Insere_table_au_bookmark;
         end;

     NbColonnes:= Length( _OD_Batpro_Table.Columns);

     SetLength( ColumnLengths, NbColonnes);
     SetLength( ColumnEnds   , NbColonnes);

     _OD_Batpro_Table.Dimensionne_Colonnes( C);
     //Titres
     _OD_Batpro_Table.Ajoute_Titres( C, J, OffSet_SurTitre, JTitre);

     //Lignes
     TraiteNiveau( 0, nil);


     //Gestion de la largeur des colonnes
     //ColumnLengths_Sum:= 0;
     //for iColonne:= 0 to NbColonnes -1
     //do
     //  Inc( ColumnLengths_Sum, ColumnLengths[iColonne]);
     //ColumnWidths_Sum:= Table.TableColumnRelativeSum;
     //LastEnd:= 0;
     //for iColonne:= 0 to NbColonnes -1
     //do
     //  begin
     //  LastEnd:= LastEnd+MulDiv( ColumnLengths[iColonne], ColumnWidths_Sum, ColumnLengths_Sum);
     //  ColumnEnds[iColonne]:= LastEnd;
     //  end;
     //TableColumnSeparators:= VarArrayCreate([0, NbColonnes-2], varDispatch);
     //for iColonne:= VarArrayLowBound (TableColumnSeparators,1)
     //           to  VarArrayHighBound(TableColumnSeparators,1)
     //do
     //  begin
     //  TableColumnSeparator:= TUNO_TableColumnSeparator.Create;
     //  try
     //     TableColumnSeparator.Position:= ColumnEnds[iColonne];
     //     TableColumnSeparator.IsVisible:= True;
     //     TableColumnSeparators[iColonne]:= TableColumnSeparator.ole;
     //  finally
     //         FreeAndNil( TableColumnSeparator);
     //         end;
     //  end;
     //Table.TableColumnSeparators:= TableColumnSeparators;

     //Suppression éventuelle du titre
     //if C.MasquerTitreColonnes
     //then
     //    Rows.removeByIndex( 0, OffSet_SurTitre+1);

     //Merge
     //NomStyleMerge:= C.NomStyleMerge;
     //StyleMerge_exists:= C.ParagraphStyles.hasByName( NomStyleMerge);
     //if Assigned( OD_Merge)
     //then
     //    while J > JTitre
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

     //Traite_MergeBookmarks;

     _OD_Batpro_Table.Traite_Bordure( C);
     //SurTitres
     //if     _OD_Batpro_Table.SurTitre_Actif
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

end.
