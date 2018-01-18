unit uOD_SpreadsheetManager;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    Xml.omnixmldom, Xml.XMLIntf,
    uOOoStrings,
    uOD_Column,
    uOD_JCL,
    uODRE_Table,
    uOD_Dataset_Column,
    uOD_Dataset_Columns,
    uOD_Styles,
    uOD_Temporaire,
    uOD_TextTableContext,
    uOpenDocument,
  SysUtils,
  {$IFDEF MSWINDOWS}
  Windows,{pour CopyFile}
  {$ELSE}
  fileutil,
  {$ENDIF}
  Classes, DB;

type
 TOD_SpreadsheetManager
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
    eTABLE: IXMLNode;
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
  //Insertion d'une table
  public
    procedure Insert_Table( nColumn: Integer; ODRE_Table: TODRE_Table);
    procedure Insert_Table_with_format( nColumn: Integer; ODRE_Table: TODRE_Table);
  end;

implementation

resourcestring
   sError='''%s'' n''est pas une valeur en virgule flottante correcte';
function Number_from_Field( _F: TField): double;
var
   Format_Valide: Boolean;
   Code: Integer;
   ValueString: String;
   procedure RaiseError( const Args: array of const); local;
   begin
        raise EConvertError.CreateResFmt(@sError, Args);
   end;
begin
     ValueString:= _F.AsString;
     Format_Valide:= TryStrToFloat( ValueString, Result);
     if not Format_Valide
     then
         begin
         Val( ValueString, Result, Code);
         Format_Valide:= Code = 0;
         end;
     if not Format_Valide
     then
         RaiseError( [ ValueString]);
end;

{ TOD_SpreadsheetManager }

constructor TOD_SpreadsheetManager.Create( _NomFichierModele: String);
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

destructor TOD_SpreadsheetManager.Destroy;
begin
     Ferme;
     inherited;
end;

procedure TOD_SpreadsheetManager.Ouvre;
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

procedure TOD_SpreadsheetManager.Ferme;
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

procedure TOD_SpreadsheetManager.SetNombreColonnes(const Value: Integer);
begin
     FNombreColonnes := Value;
     ROW.Formate( FNombreColonnes);
end;

procedure TOD_SpreadsheetManager.Append_Row;
begin
     ROW:= TOD_TABLE_ROW.Create( C, eTABLE);
     Inc( FnRow);
     if NombreColonnes > 0
     then
         ROW.Formate( NombreColonnes);
end;

function TOD_SpreadsheetManager.Cell( _nColumn: Integer;
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

function TOD_SpreadsheetManager.Cell_STRING( _nColumn: Integer; _Value_Type: String= ''): TOD_PARAGRAPH;
begin
     Result:= nil;
     if Length( ROW.Paragraphs) = 0     then exit;
     if _nColumn > High(ROW.Paragraphs) then exit;

     Cell( _nColumn, _Value_Type);
     Result:= ROW.Paragraphs[ _nColumn];
end;

procedure TOD_SpreadsheetManager.SetCell_Date( _nColumn: Integer;
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

procedure TOD_SpreadsheetManager.SetCell_CURRENCY( _nColumn: Integer;
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

procedure TOD_SpreadsheetManager.SetCell_NUMBER ( _nColumn: Integer;
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

procedure TOD_SpreadsheetManager.Name_Cell( _nColumn: Integer; _Name: String);
var
   CellName: String;
begin
     CellName:= '$Feuille1.$'+Chr(Ord('A')+_nColumn) + '$'+ IntToStr(nRow+1);
     D.Named_Range_Set( _Name, CellName, CellName);
end;

procedure TOD_SpreadsheetManager.Insert_Table( nColumn: Integer; ODRE_Table: TODRE_Table);
var
   PremiereLigne: Boolean;
   OD_Datasets: TOD_Dataset_Columns_array;
   procedure TraiteDataset( iDataset: Integer; nColumn_Dataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      OD_Styles: TOD_Styles;
      ds: TDataset;
      procedure TraiteEntetesColonnes;
      var
         I:Integer;
         F: TField;
      begin
           NombreColonnes:= nColumn_Dataset+ds.FieldCount;
           for I:= 0 to ds.FieldCount-1
           do
             begin
             F:= ds.Fields[ I];
             if Assigned( F)
             then
                 Cell_STRING( nColumn_Dataset+I).Text:= F.DisplayLabel;
             end;
           Append_Row;
      end;
      procedure TraiteLigne;
      var
         I:Integer;
         F: TField;
         iChamp: Integer;
         Style: String;
         procedure Traite_Date;
         var
            S: String;
         begin
              S:= F.DisplayText;
              if S <> ''
              then
                  SetCell_Date( nColumn_Dataset+I, F.AsDateTime, S);
         end;
      begin
           for I:= 0 to ds.FieldCount-1
           do
             begin
             F:= ds.Fields[ I];
             if Assigned( F)
             then
                 begin
                 iChamp:= F.Index;
                 if     Assigned( OD_Styles)
                    and (iChamp <= High(OD_Styles.Styles))
                 then
                     Style:= LowerCase( OD_Styles.Styles[ iChamp])
                 else
                     Style:= '';
     if Style='currency'then SetCell_CURRENCY(nColumn_Dataset+I, F.AsCurrency, F.DisplayText)
else if Style='number'  then SetCell_NUMBER  (nColumn_Dataset+I, F.AsFloat   , F.DisplayText)
else if Style='date'    then Traite_Date
else                            Cell_STRING  (nColumn_Dataset+I).Text:=F.DisplayText;
                 end;
             end;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;//en principe,ne se produit pas

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;
        OD_Styles:= OD_Dataset_Columns.OD_Styles;

        //Entêtes de colonnes
        if PremiereLigne
        then
            TraiteEntetesColonnes;

        ds.First;
        while not ds.Eof
        do
          begin
          TraiteLigne;
          if iDataset = High( OD_Datasets)
          then
              begin
              Append_Row;
              PremiereLigne:= False;
              end
          else
              TraiteDataset( iDataset+1,nColumn_Dataset+ds.FieldCount);

          ds.Next;
          end;
   end;
begin
     OD_Datasets:= ODRE_Table.OD_Datasets;
     //Lignes
     PremiereLigne:= True;
     TraiteDataset( 0, nColumn);
end;

procedure TOD_SpreadsheetManager.Insert_Table_with_format( nColumn: Integer; ODRE_Table: TODRE_Table);
var
   PremiereLigne: Boolean;
   OD_Datasets: TOD_Dataset_Columns_array;
   procedure TraiteDataset( iDataset: Integer);
   var
      OD_Dataset_Columns: TOD_Dataset_Columns;
      OD_Styles: TOD_Styles;
      ds: TDataset;
      procedure TraiteEntetesColonnes;
      var
         I:Integer;
         OD_Column: TOD_Column;
         sCellValue: String;
      begin
           NombreColonnes:= Length( ODRE_Table.Columns);
           for I:= Low(ODRE_Table.Columns) to High( ODRE_Table.Columns)
           do
             begin
             OD_Column:= ODRE_Table.Columns[I];
             sCellValue:= OD_Column.Titre;
             Cell_STRING( nColumn+I).Text:= sCellValue;
             end;

           Append_Row;
      end;
      procedure TraiteLigne( L: array of TOD_Dataset_Column);
      var
         I:Integer;
         OD_Dataset_Column: TOD_Dataset_Column;
         FieldName: String;
         F: TField;
         iChamp: Integer;
         Style: String;

         iColonne: Integer;

         procedure Traite_Date;
         var
            S: String;
         begin
              S:= F.DisplayText;
              if S <> ''
              then
                  SetCell_Date( nColumn+iColonne, F.AsDateTime, S);
         end;
      begin
           if Length( L) =0 then exit;

           for I:= Low( L) to High( L)
           do
             begin
             OD_Dataset_Column:= L[ I];
             FieldName:= OD_Dataset_Column.FieldName;

             F:= ds.FindField( FieldName);
             if Assigned( F)
             then
                 begin
                 iColonne:= OD_Dataset_Column.Debut;

                 iChamp:= F.Index;
                 if     Assigned( OD_Styles)
                    and (iChamp <= High(OD_Styles.Styles))
                 then
                     Style:= LowerCase( OD_Styles.Styles[ iChamp])
                 else
                     Style:= '';
     if Style='currency'then SetCell_CURRENCY(nColumn+iColonne, f.AsCurrency, F.DisplayText)
else if Style='number'  then SetCell_NUMBER  (nColumn+iColonne, f.AsFloat   , F.DisplayText)
else if Style='date'    then Traite_Date
else                            Cell_STRING  (nColumn+iColonne).Text:= F.DisplayText;
                 end;
             end;
           Append_Row;
      end;
   begin
        if High( OD_Datasets) < iDataset then exit;//en principe,ne se produit pas

        OD_Dataset_Columns:= OD_Datasets[iDataset];
        ds:= OD_Dataset_Columns.D;
        if not ds.Active
        then
            ds.Open;
        OD_Styles:= OD_Dataset_Columns.OD_Styles;

        //Entêtes de colonnes
        if PremiereLigne
        then
            begin
            TraiteEntetesColonnes;
            PremiereLigne:= False;
            end;

        ds.First;
        while not ds.Eof
        do
          begin
          if OD_Dataset_Columns.Avant_Triggered
          then
              TraiteLigne( OD_Dataset_Columns.FAvant);
          TraiteDataset( iDataset+1);
          if OD_Dataset_Columns.Apres_Triggered
          then
              TraiteLigne( OD_Dataset_Columns.FApres);

          ds.Next;
          end;
   end;
begin
     OD_Datasets:= ODRE_Table.OD_Datasets;
     //Lignes
     PremiereLigne:= True;
     TraiteDataset( 0);
end;

end.
