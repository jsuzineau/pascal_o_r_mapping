unit uOD_ExcelManager;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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
(*
uses
    DOM,
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
  {$IFNDEF FPC}
  Windows,{pour CopyFile}
  {$ELSE}
  fileutil,
  {$ENDIF}
    fpspreadsheet, fpscell, fpsTypes, xlsxooxml,
  Classes, sqlite3conn, DB, sqldb;

type

 { TOD_ExcelContext }

 TOD_ExcelContext
  =
   class
   //Cycle de vie
   public
     constructor Create( _ws: TsWorksheet);
     destructor Destroy; override;
   //Général
   public
     Nom: String;
     ws: TsWorksheet;
   end;

 { TOD_ExcelManager }

 TOD_ExcelManager
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
    wb: TsWorkbook;
    ws: TsWorksheet;
    C: TOD_ExcelContext;//créé pour Append_Row, pas trop propre on est en tableur pas en texte
    eTABLE: TDOMNode;
  //Gestion de la ligne courante
  private
    FnRow: Integer;
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
    function Cell            ( _nColumn, _nRow: Integer; _Value_Type: String= ''): PCell;
    function Cell_STRING     ( _nColumn, _nRow: Integer; _Value_Type: String= ''): PCell;
    procedure SetCell_Date    ( _nColumn, _nRow: Integer; _Value: double; _DisplayText: String);
    procedure SetCell_CURRENCY( _nColumn, _nRow: Integer; _Value: double; _DisplayText: String);
    procedure SetCell_NUMBER  ( _nColumn, _nRow: Integer; _Value: double; _DisplayText: String);
    procedure Name_Cell       ( _nColumn, _nRow: Integer; _Name: String);
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
  //Test
  public
    procedure Test;
  end;
*)
implementation
(*
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

{ TOD_ExcelContext }

constructor TOD_ExcelContext.Create(_ws: TsWorksheet);
begin
     ws:= _ws;
end;

destructor TOD_ExcelContext.Destroy;
begin
     inherited Destroy;
end;

{ TOD_ExcelManager }

constructor TOD_ExcelManager.Create( _NomFichierModele: String);
begin
     NomFichierModele:= _NomFichierModele;

     if ExtractFilePath( NomFichierModele) = ''
     then
         NomFichierModele:= ExtractFilePath( ParamStr(0))+ NomFichierModele;

     NomFichier:= OD_Temporaire.Nouveau_ODS( 'OD_Excel');
     CopyFile( PChar(NomFichierModele), PChar( NomFichier), False);

     Ouvert:= False;

     Ouvre;
end;

destructor TOD_ExcelManager.Destroy;
begin
     Ferme;
     inherited;
end;

procedure TOD_ExcelManager.Ouvre;
begin
     wb:= TsWorkbook.Create;
     ws:= wb.AddWorksheet('Feuille 1');

     C:= TOD_ExcelContext.Create( ws);

     FnRow:= -1;
     FNombreColonnes:= 0;

     Append_Row;

     Ouvert:= True;
end;

procedure TOD_ExcelManager.Ferme;
var
   Nom: String;
begin
     if not Ouvert then exit;

     FreeAndNil( C);

     wb.WriteToFile( NomFichier, true);

     FreeAndNil( wb);
     Ouvert:= False;

     ShowURL( NomFichier);
end;

procedure TOD_ExcelManager.SetNombreColonnes(const Value: Integer);
begin
     FNombreColonnes := Value;
end;

procedure TOD_ExcelManager.Append_Row;
begin
     Inc( FnRow);
end;

function TOD_ExcelManager.Cell( _nColumn, _nRow: Integer;
                                _Value_Type: String): PCell;
begin
     Result:= ws.WriteBlank( _nRow, _nColumn);

end;

function TOD_ExcelManager.Cell_STRING( _nColumn, _nRow: Integer; _Value_Type: String= ''): PCell;
begin
     Result:= Cell( _nColumn, _nRow, _Value_Type);
end;

procedure TOD_ExcelManager.SetCell_Date( _nColumn, _nRow: Integer;
                                           _Value: double;
                                           _DisplayText: String);
var
   C: PCell;
begin
     C:= ws.WriteDateTime( _nRow, _nColumn, _Value, nfLongDate);
     //ws.WriteDateTimeFormat( C, _Value, nfLongDate, '');
end;

procedure TOD_ExcelManager.SetCell_CURRENCY( _nColumn, _nRow: Integer;
                                               _Value: double;
                                               _DisplayText: String);
var
   C: PCell;
begin
     C:= ws.WriteCurrency( _nRow, _nColumn, _Value);
end;

procedure TOD_ExcelManager.SetCell_NUMBER ( _nColumn, _nRow: Integer;
                                                  _Value: double;
                                                  _DisplayText: String);
var
   C: PCell;
begin
     C:= ws.WriteNumber( _nRow, _nColumn, _Value, nfGeneral);
end;

procedure TOD_ExcelManager.Name_Cell( _nColumn, _nRow: Integer; _Name: String);
var
   CellName: String;
begin
     CellName:= '$Feuille1.$'+Chr(Ord('A')+_nColumn) + '$'+ IntToStr(nRow+1);
     //D.Named_Range_Set( _Name, CellName, CellName);
end;

procedure TOD_ExcelManager.Insert_Table( nColumn: Integer; ODRE_Table: TODRE_Table);
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

procedure TOD_ExcelManager.Insert_Table_with_format( nColumn: Integer; ODRE_Table: TODRE_Table);
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
     OD_Datasets:= ODRE_Table.OD_Datasets;
     //Lignes
     PremiereLigne:= True;
     TraiteDataset( 0);
end;

procedure TOD_ExcelManager.Test;
var
   c: TSQLite3Connection;
   t: TSQLTransaction;
   sqlq: TSQLQuery;
   sqlqTitre: TSQLQuery;
   ODRE_Table: TODRE_Table;
   OD_Styles: TOD_Styles;
   ec: TExcel_Context;
   dc: TOD_Dataset_Columns;
begin

     c:= TSQLite3Connection.Create( nil);

     OD_Styles:= TOD_Styles.Create( 'card,car');

     ODRE_Table:= TODRE_Table.Create( 'Corps');
     ODRE_Table.Pas_de_persistance:= True;
     ODRE_Table.AddColumn( 1, 'N°'     );
     ODRE_Table.AddColumn( 5, 'Libellé');

     ec:= TExcel_Context.Create;
     ec.XLSX_Name:= ExtractFilePath( ParamStr(0))+ClassName+'_Test.xlsx';
     try
        c.DatabaseName:= ExtractFilePath( ParamStr(0))+'test_db.sqlite';
        t:= TSQLTransaction.Create( nil);
        t.DataBase:= c;

        sqlq:= TSQLQuery.Create( nil);
        sqlq.Name:= 'sqlqTEST';
        sqlq.DataBase:= c;
        sqlq.SQL.Text:= 'select * from test';
        sqlq.Open;

        sqlqTitre:= TSQLQuery.Create( nil);
        sqlqTitre.Name:= 'sqlqTitre';
        sqlqTitre.DataBase:= c;
        sqlqTitre.SQL.Text:= 'select * from Entete';
        sqlqTitre.Open;

        dc:= ODRE_Table.AddDataset( sqlq);
        dc.OD_Styles:= OD_Styles;
        dc.Column_Avant( 'id'     , 0, 0);
        dc.Column_Avant( 'libelle', 1, 1);


        ec.Ajoute_Parametre( 'T1','Titre 1');
        ec.Ajoute_Parametre( 'T2','Titre 2');
        ec.Ajoute_Maitre( sqlqTitre);
        _from_ODRE_Table( ec, ODRE_Table);
     finally
            Free_nil( sqlq);
            Free_nil( t);
            Free_nil( ec);
            Free_nil( ODRE_Table);
            Free_nil( c);
            end;
end;
*)

end.
(*
uses
  Classes, SysUtils, uExcel_from_ODRE_Table, fpstypes, fpspreadsheet,
  fpsallformats, fpscell;

var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  MyDir: string;
  i: Integer;
  MyCell: PCell;

begin
  // Open the output file
  MyDir := ExtractFilePath(ParamStr(0));

  // Create the spreadsheet
  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('My Worksheet');

  MyWorksheet.WriteNumber      (0, 0, 1.0);
  MyWorksheet.WriteNumberFormat(0, 0, nfFixed, 2);

  // Save the spreadsheet to a file
  MyWorkbook.WriteToFile(MyDir + 'test.xlsx', sfOOXML, true);
  MyWorkbook.Free;

  WriteLn('Workbook written to "' + Mydir + 'test.xlsx' + '".');

  if ParamCount = 0 then
  begin
    {$IFDEF MSWINDOWS}
    WriteLn('Press ENTER to quit...');
    ReadLn;
    {$ENDIF}
  end;
end.


function TExcel_Context.Create_Item_from_Field( _Parent: TDOMNode;
                                                        _Item_Prefix: String;
                                                        _F: TField;
                                                        _Style: String;
                                                        _Triggered: Boolean): TDOMNode;
var
   Item_Name: String;
   Item_IsNull: Boolean;
   Item_IsNumeric: Boolean;
   function type_from_FieldType: String;
   const
        FieldtypeDefinitionsConst
        :
         array [TFieldType] of String[20]
         =
          (
            '',                 //ftUnknown,
            'VARCHAR(10)',      //ftString,
            'SMALLINT',         //ftSmallint,
            'INTEGER',          //ftInteger,
            '',                 //ftWord,
            'BOOLEAN',          //ftBoolean,
            'DOUBLE PRECISION', //ftFloat,
            '',                 //ftCurrency,
            'DECIMAL(18,4)',    //ftBCD,
            'DATE',             //ftDate,
            'TIME',             //ftTime,
            'TIMESTAMP',        //ftDateTime,
            '',                 //ftBytes,
            '',                 //ftVarBytes,
            '',                 //ftAutoInc,
            'BLOB',             //ftBlob,
            'TEXT',             //ftMemo,
            'BLOB',             //ftGraphic,
            '',                 //ftFmtMemo,
            '',                 //ftParadoxOle,
            '',                 //ftDBaseOle,
            '',                 //ftTypedBinary,
            '',                 //ftCursor,
            'CHAR(10)',         //ftFixedChar,
            '',                 //ftWideString,
            'BIGINT',           //ftLargeint,
            '',                 //ftADT,
            '',                 //ftArray,
            '',                 //ftReference,
            '',                 //ftDataSet,
            '',                 //ftOraBlob,
            '',                 //ftOraClob,
            '',                 //ftVariant,
            '',                 //ftInterface,
            '',                 //ftIDispatch,
            '',                 //ftGuid,
            'TIMESTAMP',        //ftTimeStamp,
            'NUMERIC(18,6)',    //ftFMTBcd,
            '',                 //ftFixedWideChar,
            ''                  //ftWideMemo);
          );
   begin
        case _F.DataType
        of
          ftString   : Result:= Format( 'VARCHAR(%d)', [_F.Size]);
          ftFixedChar: Result:= Format( 'CHAR(%d)'   , [_F.Size]);
          else Result:= FieldtypeDefinitionsConst[ _F.DataType];
          end;
   end;
   function Value_from_FieldType: String;
   begin
        case _F.DataType
        of
          ftString   : Result:= _F.DisplayText;
          ftMemo     : Result:= _F.AsString;
          ftSmallint : Result:= _F.AsString;
          else         Result:= _F.DisplayText;
          end;
        if uGenero_Report_from_ODRE_Table_workaround_bug_GRE_731
        then
            if '' = Trim( Result)
            then
                begin
                Result:= '<span>&nbsp;</span>'; //workaround pour le bug Genero Report Writer  #GRE-731
                if _Triggered
                then
                    Item_IsNull:= False;
                end;
   end;
   function isoValue_from_FieldType: String;
   var
      sDecimales: String;
      nDecimales: Integer;
      d: Double;
   begin
        Result:= '';
        if not Item_IsNumeric then exit;

        sDecimales:= Copy( _Style, 4, Length(_Style));
        if not TryStrToInt( sDecimales, nDecimales) then exit;

        try
           d:= _F.AsFloat;
        except
              on E: Exception do exit;
              end;

        Str( d:20:nDecimales, Result);//20: au pif nb chiffres maxi
   end;
begin
     Result:= nil;

     if nil = _F then exit;

     Item_IsNull:= _F.IsNull or not _Triggered;
     Item_IsNumeric:= 1 = Pos( 'num', _Style);

     Item_Name:= _Item_Prefix+_F.FieldName;
     Result:= _Parent.AppendChild( _Parent.OwnerDocument.CreateElement('Item'));
     Set_Property( Result, 'name'    , Item_Name              );
     Set_Property( Result, 'type'    ,     type_from_FieldType);
     Set_Property( Result, 'value'   ,    Value_from_FieldType);
     if Item_IsNumeric
     then
         Set_Property( Result, 'isoValue', isoValue_from_FieldType);
     Set_Property( Result, 'isNull'  , BoolToStr( Item_IsNull, '1','0'));

end;


*)
