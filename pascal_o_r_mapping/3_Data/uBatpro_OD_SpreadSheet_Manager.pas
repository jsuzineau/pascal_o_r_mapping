unit uBatpro_OD_SpreadSheet_Manager;
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
    uClean,
    u_sys_,
    uReels,
    uOD_JCL,
    uOpenDocument,
    uOD_Temporaire,
    uOD_SurTitre,
    uOOoStrings,
    uOD_Column,
    uOD_Champ,
    uOD_TextTableContext,
    uOD_Batpro_Table,
    uOD_Dataset_Column,
    uOD_Styles,
    uOD_Niveau,
    uBatpro_StringList,
    uChamps,
    uChamp,

    uBatpro_Ligne,

    ufAccueil_Erreur,
  {$IFNDEF FPC}
  DOM,
  Windows, //pour CopyFile
  {$ELSE}
  DOM,
  FileUtil,	//pour CopyFile
  {$ENDIF}
  SysUtils, Classes, DB, Types, Math;

type
 TBatpro_OD_SpreadSheet_Manager
 =
  class
  //cycle de vie
  public
    constructor Create( _NomFichierModele: String);
    destructor Destroy; override;
  //Attributs
  public
    NomFichierModele: String;
    NomFichier: String;
    D: TOpenDocument;
    C: TOD_TextTableContext;//créé pour Append_Row, pas trop propre on est en tableur pas en texte
    eTABLE: TDOMNode;
  //Gestion de la ligne courante
  private
    FnRow: Integer;
    ROW: TOD_TABLE_ROW;
    property nRow: Integer read FnRow;
    procedure Append_Row;
  //Nombre de colonnes
  private
    FNombreColonnes: Integer;
    procedure SetNombreColonnes(const Value: Integer);
  public
    property NombreColonnes: Integer read FNombreColonnes write SetNombreColonnes;
  //Méthodes
  private
    function Cell            ( _nColumn: Integer; _Value_Type: String= ''): TOD_TABLE_CELL;
    function Cell_STRING     ( _nColumn: Integer; _Value_Type: String= ''): TOD_PARAGRAPH;
    procedure SetCell_Date    ( _nColumn: Integer; _Value: double; _DisplayText: String);
    procedure SetCell_CURRENCY( _nColumn: Integer; _Value: double; _DisplayText: String);
    procedure SetCell_NUMBER  ( _nColumn: Integer; _Value: double; _DisplayText: String);
    procedure Name_Cell       ( _nColumn: Integer; _Name: String);
  //Gestion de l'ouverture
  private
    Ouvert: Boolean;
  public
    procedure Ouvre;
    procedure Ferme;
  //Méthodes
  private
    procedure TraiteColonne( ColonneDebut, LigneDebut: Integer;
                             Nom: String;
                             Colonne: TStringDynArray);
  public
    function Ajoute_bl( ColonneDebut, LigneDebut: Integer;
                        Nom: String;
                        bl: TBatpro_Ligne): Integer;
    function Ajoute_bl_horizontal( ColonneDebut, LigneDebut: Integer;
                                   bl: TBatpro_Ligne; _Titre: Boolean= False): Integer;
    function Ajoute_sl( ColonneDebut, LigneDebut: Integer;
                        sl: TBatpro_StringList): Integer;
    function Ajoute_Tableau( ColonneDebut, LigneDebut: Integer;
                             Nom: String;
                             NomColonnes: array of String;
                             Colonnes: array of TStringDynArray): Integer;
  //Insertion d'une table
  public
    procedure Insert_Table( _nColumn: Integer; _OD_Batpro_Table: TOD_Batpro_Table);
    //procedure Insert_Table_with_format( _nColumn: Integer; _OD_Batpro_Table: TOD_Batpro_Table);
  end;

implementation

{ TBatpro_OD_SpreadSheet_Manager }

constructor TBatpro_OD_SpreadSheet_Manager.Create( _NomFichierModele: String);
begin
     NomFichierModele:= _NomFichierModele;

     if ExtractFilePath( NomFichierModele) = ''
     then
         NomFichierModele:= ExtractFilePath( ParamStr(0))+ NomFichierModele;

     NomFichier:= OD_Temporaire.Nouveau_ODS( 'OD_SpreadSheet');
     CopyFile( PChar(NomFichierModele), PChar( NomFichier), False);

     Ouvert:= False;

     Ouvre;
end;

destructor TBatpro_OD_SpreadSheet_Manager.Destroy;
begin
     Ferme;
     inherited;
end;

procedure TBatpro_OD_SpreadSheet_Manager.Ouvre;
begin
     D:= TOpenDocument.Create( NomFichier);
     C:= TOD_TextTableContext.Create( D);
     eTABLE:= D.Get_xmlContent_SPREADSHEET_first_TABLE;
     RemoveChilds( eTABLE);
     FnRow:= -1;
     ROW:= nil;
     FNombreColonnes:= 0;

     Append_Row;

     Ouvert:= True;
end;

procedure TBatpro_OD_SpreadSheet_Manager.Ferme;
var
   Nom: String;
begin
     if not Ouvert then exit;

     FreeAndNil( C);

     Nom:= D.Nom;

     D.Save;

     FreeAndNil( D);
     Ouvert:= False;

     ShowURL( Nom);
end;

procedure TBatpro_OD_SpreadSheet_Manager.SetNombreColonnes(const Value: Integer);
begin
     FNombreColonnes := Value;
     ROW.Formate( FNombreColonnes);
end;

procedure TBatpro_OD_SpreadSheet_Manager.Append_Row;
begin
     ROW:= TOD_TABLE_ROW.Create( C, eTABLE);
     Inc( FnRow);
     if NombreColonnes > 0
     then
         ROW.Formate( NombreColonnes);
end;

function TBatpro_OD_SpreadSheet_Manager.Cell( _nColumn: Integer;
                                      _Value_Type: String): TOD_TABLE_CELL;
begin
     Result:= nil;
     if Length( ROW.Cells) = 0     then exit;
     if _nColumn > High(ROW.Cells) then exit;

     Result:= ROW.Cells[ _nColumn];
     if _Value_Type <> ''
     then
         Result.Value_Type:= _Value_Type;
end;

function TBatpro_OD_SpreadSheet_Manager.Cell_STRING( _nColumn: Integer; _Value_Type: String= ''): TOD_PARAGRAPH;
begin
     Result:= nil;
     if Length( ROW.Paragraphs) = 0     then exit;
     if _nColumn > High(ROW.Paragraphs) then exit;

     Cell( _nColumn, _Value_Type);
     Result:= ROW.Paragraphs[ _nColumn];
end;

procedure TBatpro_OD_SpreadSheet_Manager.SetCell_Date( _nColumn: Integer;
                                           _Value: double;
                                           _DisplayText: String);
var
   C: TOD_TABLE_CELL;
   sValue: String;
begin
     Cell_STRING( _nColumn, 'date');

     Str( _Value, sValue);
     C:= Cell( _nColumn);
     C.Value:= sValue;
end;

procedure TBatpro_OD_SpreadSheet_Manager.SetCell_CURRENCY( _nColumn: Integer;
                                               _Value: double;
                                               _DisplayText: String);
var
   C: TOD_TABLE_CELL;
   sValue: String;
begin
     Cell_STRING( _nColumn, 'currency');

     Str( _Value, sValue);
     C:= Cell( _nColumn);
     C.Value:= sValue;
end;

procedure TBatpro_OD_SpreadSheet_Manager.SetCell_NUMBER ( _nColumn: Integer;
                                                  _Value: double;
                                                  _DisplayText: String);
var
   C: TOD_TABLE_CELL;
   sValue: String;
begin
     Cell_STRING( _nColumn, 'float').Text:= _DisplayText;

     Str( _Value, sValue);
     C:= Cell( _nColumn);
     C.Value:= sValue;
end;

procedure TBatpro_OD_SpreadSheet_Manager.Name_Cell( _nColumn: Integer; _Name: String);
var
   CellName: String;
begin
     CellName:= '$Feuille1.$'+Chr(Ord('A')+_nColumn) + '$'+ IntToStr(nRow+1);
     D.Named_Range_Set( _Name, CellName, CellName);
end;

function TBatpro_OD_SpreadSheet_Manager.Ajoute_bl( ColonneDebut, LigneDebut: Integer;
                                       Nom: String;
                                       bl: TBatpro_Ligne): Integer;
//var
//   I:Integer;
//   C: TChamp;
//   nCD, nCV: Integer;
//   procedure Init_C;
//   begin
//        nRow:= LigneDebut + I;
//        Cell( nCD).Formula:= C.Definition.Libelle;
//        Name_Cell( nFeuille, nCV, Nom+'_'+C.Definition.Nom);
//   end;
//   function Init_Cell: Variant;
//   begin
//        Init_C;
//        Result:= Cell( nCV);
//   end;
//   procedure C_String ( Valeur: String ); begin Init_Cell.Formula:= Valeur; end;
//   procedure C_Double ( Valeur: Double ); begin Init_Cell.Value  := Valeur; end;
//   procedure C_Integer( Valeur: Integer); begin Init_Cell.Value  := Valeur; end;
//   procedure C_Date( Valeur: TDateTime);
//   begin
//        Init_C;
//        Cell_Date( nCV).Value:= Valeur;
//   end;
//   procedure C_DateTime( Valeur: TDateTime);
//   begin
//        Init_C;
//        Cell_DateTime( nCV).Value:= Valeur;
//   end;
//   procedure C_Boolean( Valeur: Boolean);
//   begin
//        Init_C;
//        Cell_BOOLEAN( nCV).Value:= Valeur;
//   end;
begin
//     Result:= 0;
//
//     if bl = nil then exit;
//
//     nRow:= LigneDebut;
//     //Titre
//     Cell( ColonneDebut).Formula:= Nom;
//     Inc( LigneDebut);
//
//     //Valeurs des champs
//     nCD:= ColonneDebut;
//     nCV:= ColonneDebut+1;
//     for I:= 0 to bl.Champs.Count - 1
//     do
//       begin
//       C:= bl.Champs.Champ_from_Index( I);
//       if Assigned( C)
//       then
//           begin
//           case C.Definition.Typ
//           of
//             ftString  : C_String  ( PString  ( C.Valeur)^);
//             ftMemo    : C_String  ( PString  ( C.Valeur)^);
//             ftBlob    : C_String  ( PString  ( C.Valeur)^);
//             ftDate    : C_Date    ( PDateTime( C.Valeur)^);
//             ftInteger : C_Integer ( PInteger ( C.Valeur)^);
//             ftSmallint: C_Integer ( PInteger ( C.Valeur)^);
//             ftBCD     : C_Double  ( PCurrency( C.Valeur)^);
//             ftDateTime: C_DateTime( PDateTime( C.Valeur)^);
//             ftTimeStamp:C_DateTime( PDateTime( C.Valeur)^);
//             ftFloat   : C_Double  ( PDouble  ( C.Valeur)^);
//             ftBoolean : C_Boolean ( PBoolean ( C.Valeur)^);
//             end;
//           end;
//       end;
//
//     Inc( nRow);
//     Result:= nRow; //prochaine ligne vide
end;

function TBatpro_OD_SpreadSheet_Manager.Ajoute_bl_horizontal( ColonneDebut, LigneDebut: Integer; bl: TBatpro_Ligne;
                                                  _Titre: Boolean): Integer;
//var
//   I:Integer;
//   C: TChamp;
//   nLD, nLV: Integer;
//   nColonne: Integer;
//   procedure Init_C;
//   begin
//        Inc(nColonne);
//        nRow:= nLD;
//        if _Titre
//        then
//            Cell( nColonne).Formula:= C.Definition.Libelle;
//        nRow:= nLV;
//        Name_Cell( nFeuille, nColonne, C.Definition.Nom);
//   end;
//   function Init_Cell: Variant;
//   begin
//        Init_C;
//        Result:= Cell( nColonne);
//   end;
//   procedure C_String ( Valeur: String ); begin Init_Cell.Formula:= Valeur; end;
//   procedure C_Double ( Valeur: Double ); begin Init_Cell.Value  := Valeur; end;
//   procedure C_Integer( Valeur: Integer); begin Init_Cell.Value  := Valeur; end;
//   procedure C_Date( Valeur: TDateTime);
//   begin
//        Init_C;
//        Cell_Date( nColonne).Value:= Valeur;
//   end;
//   procedure C_DateTime( Valeur: TDateTime);
//   begin
//        Init_C;
//        Cell_DateTime( nColonne).Value:= Valeur;
//   end;
//   procedure C_Boolean( Valeur: Boolean);
//   begin
//        Init_C;
//        Cell_BOOLEAN( nColonne).Value:= Valeur;
//   end;
begin
//     Result:= 0;
//
//     if bl = nil then exit;
//
//     //Valeurs des champs
//     nLD:= LigneDebut;
//     nLV:= LigneDebut+1;
//     nColonne:= ColonneDebut -1;//on incrémente avant usage
//     for I:= 0 to bl.Champs.Count - 1
//     do
//       begin
//       C:= bl.Champs.Champ_from_Index( I);
//       if Assigned( C)
//       then
//           begin
//           if not C.Definition.Visible then continue;
//
//           case C.Definition.Typ
//           of
//             ftString  : C_String  ( PString  ( C.Valeur)^);
//             ftMemo    : C_String  ( PString  ( C.Valeur)^);
//             ftBlob    : C_String  ( PString  ( C.Valeur)^);
//             ftDate    : C_Date    ( PDateTime( C.Valeur)^);
//             ftInteger : C_Integer ( PInteger ( C.Valeur)^);
//             ftSmallint: C_Integer ( PInteger ( C.Valeur)^);
//             ftBCD     : C_Double  ( PCurrency( C.Valeur)^);
//             ftDateTime: C_DateTime( PDateTime( C.Valeur)^);
//             ftTimeStamp:C_DateTime( PDateTime( C.Valeur)^);
//             ftFloat   : C_Double  ( PDouble  ( C.Valeur)^);
//             ftBoolean : C_Boolean ( PBoolean ( C.Valeur)^);
//             end;
//           end;
//       end;
//
//     Result:= nColonne + 1; //prochaine colonne vide
end;

function TBatpro_OD_SpreadSheet_Manager.Ajoute_sl( ColonneDebut, LigneDebut: Integer;
                                       sl: TBatpro_StringList): Integer;
//var
//   bl: TBatpro_Ligne;
begin
//     sl.Iterateur_Start;
//     try
//        sl.Iterateur_Suivant( bl);
//        if Assigned(bl)
//        then
//            begin
//            Ajoute_bl_horizontal( ColonneDebut, LigneDebut, bl, True);
//            Inc( LigneDebut, 2);
//            end;
//
//        while not sl.Iterateur_EOF
//        do
//          begin
//          sl.Iterateur_Suivant( bl);
//          if bl = nil then continue;
//
//          Ajoute_bl_horizontal( ColonneDebut, LigneDebut, bl);
//          Inc( LigneDebut, 1);
//          end;
//     finally
//            sl.Iterateur_Stop;
//            end;
end;

function TBatpro_OD_SpreadSheet_Manager.Ajoute_Tableau( ColonneDebut, LigneDebut: Integer; Nom: String;
                                            NomColonnes: array of String;
                                            Colonnes: array of TStringDynArray): Integer;
//var
//   I: Integer;
//   NbLignes: Integer;
begin
//     //Titre
//     nRow:= LigneDebut;
//     Cell( ColonneDebut).Formula:= Nom;
//     Inc( LigneDebut);
//
//     if Length( NomColonnes) <> Length( Colonnes)
//     then
//         fAccueil_Erreur(  'Erreur à signaler au développeur:'+sys_N
//                          +'TBatpro_OD_SpreadSheet_Manager.Ajoute_Tableau:'+sys_N
//                          +Format( ' il y a %d noms de colonnes pour %d colonnes',
//                                   [Length( NomColonnes), Length( Colonnes)]));
//
//     NbLignes:= 0;
//     for I:= Low( NomColonnes) to High( NomColonnes)
//     do
//       begin
//       TraiteColonne( ColonneDebut+I, LigneDebut, NomColonnes[I], Colonnes[I]);
//       NbLignes:= Max( NbLignes, Length(Colonnes[I]));
//       end;
//     Result:= LigneDebut+NbLignes;
end;

procedure TBatpro_OD_SpreadSheet_Manager.TraiteColonne( ColonneDebut, LigneDebut: Integer;
                                            Nom: String;
                                            Colonne: TStringDynArray);
//var
//   I: Integer;
begin
//     //Titre
//     nRow:= LigneDebut;
//     Cell( ColonneDebut).Formula:= Nom;
//     Inc( LigneDebut);
//
//     for I:= Low( Colonne) to High( Colonne)
//     do
//       begin
//       nRow:= LigneDebut+I;
//       Cell( ColonneDebut).Formula:= Colonne[I];
//       Name_Cell( nFeuille, ColonneDebut, Nom+IntToStr(I+1));
//       end;
end;

procedure TBatpro_OD_SpreadSheet_Manager.Insert_Table( _nColumn: Integer; _OD_Batpro_Table: TOD_Batpro_Table);
//var
//   OD_Column: TOD_Column;
//   iColonne: Integer;
//   Niveaux: TOD_Niveau_array;
//   OD_SurTitre: TOD_SurTitre;
//   //Surtitre
//   iSurTitre,
//   OffSet_SurTitre: Integer;
//   Debut, Fin: Integer;
//   CellName: String;
//   sCellValue: String;
//   //juste pour debug/mise au point
//   BorderLine_NewGroup,
//   BorderLine_EndGroup,
//   BorderLine_Vide: Variant;
//   cNewGroup : TChamp; NewGroup : Boolean;
//   cEndGroup : TChamp; EndGroup : Boolean;
//   cGroupSize: TChamp; GroupSize: Integer;
//   cGroupTitle: TChamp; GroupTitle: String;
//   cGroupTitle_Column: TChamp; GroupTitle_Column: Integer;
//   cGroupTitle_Style : TChamp; GroupTitle_Style : String;
//   GroupDefined: Boolean;
//   procedure TraiteNiveau( iDataset: Integer; blParent: TBatpro_Ligne = nil);
//   var
//      Niveau: TOD_Niveau;
//      OD_Styles: TOD_Styles;
//      iNiveauLigne: Integer;
//      bl: TBatpro_Ligne;
//      Prefixe: String;
//      function GroupTitle_defined: Boolean;
//      begin
//           Result:= nil <> bl.Champs.Champ_from_Field( 'GroupTitle');
//      end;
//
//      procedure TraiteLigne( L: array of TOD_Champ);
//      var
//         I:Integer;
//         OD_Champ: TOD_Champ;
//         NomChamp: String;
//         Champs: TChamps;
//         Champ: TChamp;
//         iChamp: Integer;
//         Style: String;
//         iColonne: Integer;
//         procedure Traite_Date;
//         var
//            D: TDateTime;
//         begin
//              D:= Champ.asDatetime;
//              if not Reel_Zero( D)
//              then
//                  Cell_Date( iColonne).Value:= VarAsType( D, varDate);
//         end;
//      begin
//           if bl = nil then exit;
//           if Length( L) =0 then exit;
//
//           Inc( nRow);
//           Champs:= bl.Champs;
//
//           for I:= Low( L) to High( L)
//           do
//             begin
//             OD_Champ:= L[ I];
//
//             NomChamp:= OD_Champ.FieldName;
//             Champ:= Champs.Champ_from_Field( NomChamp);
//             if Assigned( Champ)
//             then
//                 begin
//                 iColonne:= OD_Champ.Debut;
//                 iChamp:= Champs.Index_from_Field( NomChamp);
//
//                 if     Assigned( OD_Styles)
//                    and (iChamp <= High(OD_Styles.Styles))
//                 then
//                     Style:= LowerCase( OD_Styles.Styles[ iChamp])
//                 else
//                     Style:= '';
//                      if Style='currency'then Cell_CURRENCY(iColonne).Value:=Champ.asDouble
//                 else if Style='date'    then Traite_Date
//                 else
//                     begin
//                     case Champ.Definition.Typ
//                     of
//                       ftString  : Cell         (iColonne).Formula:= Champ.Chaine;
//                       ftMemo    : Cell         (iColonne).Formula:= Champ.Chaine;
//                       ftBlob    : Cell         (iColonne).Formula:= Champ.Chaine;
//                       ftDate    : Cell_Date    (iColonne).Value  := Champ.asDatetime;
//                       ftInteger : Cell         (iColonne).Value  := Champ.asInteger;
//                       ftSmallint: Cell         (iColonne).Value  := Champ.asInteger;
//                       ftBCD     : Cell         (iColonne).Value  := Champ.asDouble;
//                       ftDateTime: Cell_DateTime(iColonne).Value  := Champ.asDatetime;
//                       ftTimeStamp:Cell_DateTime(iColonne).Value  := Champ.asDatetime;
//                       ftFloat   : Cell         (iColonne).Value  := Champ.asDouble;
//                       ftBoolean : Cell_BOOLEAN (iColonne).Value  := Champ.asBoolean;
//                       end;
//                     end;
//                 end;
//             end;
//      end;
//   begin
//        if High( Niveaux) < iDataset then exit;//en principe,ne se produit pas
//
//        Niveau:= Niveaux[iDataset];
//        bl:= nil;
//        Prefixe:= '_'+OD_Batpro_Table.Nom+'_'+Niveau.Nom;
//        OD_Styles:= Niveau.OD_Styles;
//        for iNiveauLigne:= 0 to Niveau.Count - 1
//        do
//          begin
//          bl:= Niveau.Go_to( iNiveauLigne);
//
//          if Assigned( bl)
//          then
//              begin
//              BooleanFieldValue( bl, 'NewGroup'         , cNewGroup         , NewGroup  );
//              BooleanFieldValue( bl, 'EndGroup'         , cEndGroup         , EndGroup  );
//              IntegerFieldValue( bl, 'GroupSize'        , cGroupSize        , GroupSize );
//               StringFieldValue( bl, 'GroupTitle'       , cGroupTitle       , GroupTitle);
//               StringFieldValue( bl, 'GroupTitle_Style' , cGroupTitle_Style , GroupTitle_Style );
//              IntegerFieldValue( bl, 'GroupTitle_Column', cGroupTitle_Column, GroupTitle_Column);
//
//              (*
//              if NewGroup
//              then
//                  begin
//                  BorderLine_NewGroup.InnerLineWidth:= 1;
//                  BorderLine_NewGroup.OuterLineWidth:= 1;
//                  end
//              else
//                  begin
//                  BorderLine_NewGroup.InnerLineWidth:= 0;
//                  BorderLine_NewGroup.OuterLineWidth:= 0;
//                  end;
//
//              if    EndGroup
//                 or (cEndGroup = nil)
//              then
//                  begin
//                  BorderLine_EndGroup.InnerLineWidth:= 1;
//                  BorderLine_EndGroup.OuterLineWidth:= 1;
//                  end
//              else
//                  begin
//                  BorderLine_EndGroup.InnerLineWidth:= 0;
//                  BorderLine_EndGroup.OuterLineWidth:= 0;
//                  end;
//              *)
//              GroupDefined
//              :=
//                   Assigned( cNewGroup )
//                or Assigned( cEndGroup )
//                or Assigned( cGroupSize);
//
//              if GroupTitle_defined
//              then
//                  begin
//                  Inc( nRow);
//                  Cell( GroupTitle_Column).Formula:= GroupTitle;//GroupTitle_Style
//                  end;
//              GroupDefined
//              :=
//                   Assigned( cNewGroup )
//                or Assigned( cEndGroup )
//                or Assigned( cGroupSize);
//              end
//          else
//              GroupDefined:= False;
//
//          if Niveau.Avant_Triggered
//          then
//              TraiteLigne( Niveau.Avant);
//          TraiteNiveau( iDataset+1, bl);
//          if Niveau.Apres_Triggered
//          then
//              TraiteLigne( Niveau.Apres);
//          end;
//   end;
begin
//     Niveaux:= OD_Batpro_Table.Niveaux;
//     OD_SurTitre:= OD_Batpro_Table.OD_SurTitre;
//     nRow:= 0;
//
//     //Ajout éventuel ligne pour SurTitres
//     if OD_Batpro_Table.SurTitre_Actif
//     then
//         begin
//         Inc( nRow);
//         OffSet_SurTitre:= 1;
//         end
//     else
//         OffSet_SurTitre:= 0;
//
//     //Entêtes de colonnes
//     for iColonne:= Low(OD_Batpro_Table.Columns) to High( OD_Batpro_Table.Columns)
//     do
//       begin
//       OD_Column:= OD_Batpro_Table.Columns[iColonne];
//       //ColumnLengths[iColonne]:= OD_Column.Largeur;
//       Cell( iColonne).Formula:= OD_Column.Titre;
//       end;
//
//     //Lignes
//     Inc(nRow);
//     TraiteNiveau( 0);
//
//     //SurTitres
//     if     OD_Batpro_Table.SurTitre_Actif
//     then
//         begin
//         nRow:= 0;
//         for iSurTitre:= High(OD_SurTitre.Libelle) downto Low(OD_SurTitre.Libelle)
//         do
//           begin
//           sCellValue:= OD_SurTitre.Libelle[iSurTitre];
//           Debut     := OD_SurTitre.Debut  [iSurTitre];
//           Fin       := OD_SurTitre.Fin    [iSurTitre];
//
//           Cell( Debut).Formula:= sCellValue;
//           (*
//           CellName:= CellName_from_XY(Debut, J);
//           CellCursor:= Table.createCursorByCellName( CellName);
//           CellCursor.gotoCellByName( CellName_from_XY(Fin, J), true);
//           //xray( CellCursor);
//           CellCursor.mergeRange;
//
//           CellCursor:= Table.getCellByName( CellName_from_XY(Debut, J));
//           TextCursor:= CellCursor.CreateTextCursor;
//           CellCursor.insertString( TextCursor, sCellValue, false);
//           *)
//           end;
//         end;
//     
end;

//procedure TBatpro_OD_SpreadSheet_Manager.Insert_Table( _nColumn: Integer; _ODRE_Table: TODRE_Table);
//var
//   PremiereLigne: Boolean;
//   OD_Datasets: TOD_Dataset_Columns_array;
//   procedure TraiteDataset( iDataset: Integer; nColumn_Dataset: Integer);
//   var
//      OD_Dataset_Columns: TOD_Dataset_Columns;
//      OD_Styles: TOD_Styles;
//      ds: TDataset;
//      procedure TraiteEntetesColonnes;
//      var
//         I:Integer;
//         F: TField;
//      begin
//           NombreColonnes:= nColumn_Dataset+ds.FieldCount;
//           for I:= 0 to ds.FieldCount-1
//           do
//             begin
//             F:= ds.Fields[ I];
//             if Assigned( F)
//             then
//                 Cell_STRING( nColumn_Dataset+I).Text:= F.DisplayLabel;
//             end;
//           Append_Row;
//      end;
//      procedure TraiteLigne;
//      var
//         I:Integer;
//         F: TField;
//         iChamp: Integer;
//         Style: String;
//         procedure Traite_Date;
//         var
//            S: String;
//         begin
//              S:= F.DisplayText;
//              if S <> ''
//              then
//                  SetCell_Date( nColumn_Dataset+I, F.AsDateTime, S);
//         end;
//      begin
//           for I:= 0 to ds.FieldCount-1
//           do
//             begin
//             F:= ds.Fields[ I];
//             if Assigned( F)
//             then
//                 begin
//                 iChamp:= F.Index;
//                 if     Assigned( OD_Styles)
//                    and (iChamp <= High(OD_Styles.Styles))
//                 then
//                     Style:= LowerCase( OD_Styles.Styles[ iChamp])
//                 else
//                     Style:= '';
//     if Style='currency'then SetCell_CURRENCY(nColumn_Dataset+I, F.AsCurrency, F.DisplayText)
//else if Style='number'  then SetCell_NUMBER  (nColumn_Dataset+I, F.AsFloat   , F.DisplayText)
//else if Style='date'    then Traite_Date
//else                            Cell_STRING  (nColumn_Dataset+I).Text:=F.DisplayText;
//                 end;
//             end;
//      end;
//   begin
//        if High( OD_Datasets) < iDataset then exit;//en principe,ne se produit pas
//
//        OD_Dataset_Columns:= OD_Datasets[iDataset];
//        ds:= OD_Dataset_Columns.D;
//        if not ds.Active
//        then
//            ds.Open;
//        OD_Styles:= OD_Dataset_Columns.OD_Styles;
//
//        //Entêtes de colonnes
//        if PremiereLigne
//        then
//            TraiteEntetesColonnes;
//
//        ds.First;
//        while not ds.Eof
//        do
//          begin
//          TraiteLigne;
//          if iDataset = High( OD_Datasets)
//          then
//              begin
//              Append_Row;
//              PremiereLigne:= False;
//              end
//          else
//              TraiteDataset( iDataset+1,nColumn_Dataset+ds.FieldCount);
//
//          ds.Next;
//          end;
//   end;
//begin
//     OD_Datasets:= ODRE_Table.OD_Datasets;
//     //Lignes
//     PremiereLigne:= True;
//     TraiteDataset( 0, nColumn);
//end;
//
//procedure TBatpro_OD_SpreadSheet_Manager.Insert_Table_with_format( nColumn: Integer; ODRE_Table: TODRE_Table);
//var
//   PremiereLigne: Boolean;
//   OD_Datasets: TOD_Dataset_Columns_array;
//   procedure TraiteDataset( iDataset: Integer);
//   var
//      OD_Dataset_Columns: TOD_Dataset_Columns;
//      OD_Styles: TOD_Styles;
//      ds: TDataset;
//      procedure TraiteEntetesColonnes;
//      var
//         I:Integer;
//         OD_Column: TOD_Column;
//         sCellValue: String;
//      begin
//           NombreColonnes:= Length( ODRE_Table.Columns);
//           for I:= Low(ODRE_Table.Columns) to High( ODRE_Table.Columns)
//           do
//             begin
//             OD_Column:= ODRE_Table.Columns[I];
//             sCellValue:= OD_Column.Titre;
//             Cell_STRING( nColumn+I).Text:= sCellValue;
//             end;
//
//           Append_Row;
//      end;
//      procedure TraiteLigne( L: array of TOD_Dataset_Column);
//      var
//         I:Integer;
//         OD_Dataset_Column: TOD_Dataset_Column;
//         FieldName: String;
//         F: TField;
//         iChamp: Integer;
//         Style: String;
//
//         iColonne: Integer;
//
//         procedure Traite_Date;
//         var
//            S: String;
//         begin
//              S:= F.DisplayText;
//              if S <> ''
//              then
//                  SetCell_Date( nColumn+iColonne, F.AsDateTime, S);
//         end;
//      begin
//           if Length( L) =0 then exit;
//
//           for I:= Low( L) to High( L)
//           do
//             begin
//             OD_Dataset_Column:= L[ I];
//             FieldName:= OD_Dataset_Column.FieldName;
//
//             F:= ds.FindField( FieldName);
//             if Assigned( F)
//             then
//                 begin
//                 iColonne:= OD_Dataset_Column.Debut;
//
//                 iChamp:= F.Index;
//                 if     Assigned( OD_Styles)
//                    and (iChamp <= High(OD_Styles.Styles))
//                 then
//                     Style:= LowerCase( OD_Styles.Styles[ iChamp])
//                 else
//                     Style:= '';
//     if Style='currency'then SetCell_CURRENCY(nColumn+iColonne, f.AsCurrency, F.DisplayText)
//else if Style='number'  then SetCell_NUMBER  (nColumn+iColonne, f.AsFloat   , F.DisplayText)
//else if Style='date'    then Traite_Date
//else                            Cell_STRING  (nColumn+iColonne).Text:= F.DisplayText;
//                 end;
//             end;
//           Append_Row;
//      end;
//   begin
//        if High( OD_Datasets) < iDataset then exit;//en principe,ne se produit pas
//
//        OD_Dataset_Columns:= OD_Datasets[iDataset];
//        ds:= OD_Dataset_Columns.D;
//        if not ds.Active
//        then
//            ds.Open;
//        OD_Styles:= OD_Dataset_Columns.OD_Styles;
//
//        //Entêtes de colonnes
//        if PremiereLigne
//        then
//            begin
//            TraiteEntetesColonnes;
//            PremiereLigne:= False;
//            end;
//
//        ds.First;
//        while not ds.Eof
//        do
//          begin
//          if OD_Dataset_Columns.Avant_Triggered
//          then
//              TraiteLigne( OD_Dataset_Columns.Avant);
//          TraiteDataset( iDataset+1);
//          if OD_Dataset_Columns.Apres_Triggered
//          then
//              TraiteLigne( OD_Dataset_Columns.Apres);
//
//          ds.Next;
//          end;
//   end;
//begin
//     OD_Datasets:= ODRE_Table.OD_Datasets;
//     //Lignes
//     PremiereLigne:= True;
//     TraiteDataset( 0);
//end;

end.
