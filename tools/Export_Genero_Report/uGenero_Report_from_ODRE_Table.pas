unit uGenero_Report_from_ODRE_Table;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_Temporaire,
    uOD_JCL,
    uOD_Styles,
    uOD_Column,
    uOD_Dataset_Column,
    uODRE_Table,
    uOD_Dataset_Columns,
    uOpenDocument,
 Classes, SysUtils, XMLRead, XMLWrite, sqlite3conn, DOM, DB, sqldb;

type

 { TGenero_Report_Context }

 TGenero_Report_Context
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _XML_Model_Name, _RP_Model_Name: String);
    destructor Destroy; override;
  //Nom du modèle pour le XML
  public
    XML_Model_Name: String;
  //Nom du fichier XML de sortie
  public
    XML_Output_Name: String;
  //Nom du modèle pour le 4RP
  public
    RP_Model_Name: String;
  //Nom du fichier 4RP de sortie
  public
    RP_Output_Name: String;
  //XML
  public
    xml: TXMLDocument;
    exml_Report: TDOMNode;
    procedure Ecrit_XML;
  //4RP
  public
    rp: TXMLDocument;
    erp_Report: TDOMNode;
    erp_TBODY: TDOMNode;
    procedure Ecrit_4RP;
  //Gestion des noms
  private
    slNoms: TStringList;
    function Nomme( _Prefixe: String): String; overload;
    procedure Nomme( _e : TDOMNode; _Prefixe: String);
  //Génération pour un ODRE_Table donné
  private
    function AC( _Parent: TDOMNode; _Name: String): TDOMNode;
    function Create_Item_from_Field( _Parent: TDOMNode;
                                     _Item_Name: String;
                                     _F: TField;
                                     _Triggered: Boolean): TDOMNode;
  private
    procedure  rp_Traite_entetes_colonnes;
    procedure  rp_TraiteDataset(  _rp_Parent: TDOMNode; iDataset: Integer);
    procedure xml_TraiteDataset( _xml_Parent: TDOMNode; iDataset: Integer);
  public
    ODRE_Table: TODRE_Table;
    procedure _from_ODRE_Table( _ODRE_Table: TODRE_Table);
  end;

 { TGenero_Report_from_ODRE_Table }

 TGenero_Report_from_ODRE_Table
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //XML et 4rp pour un ODRE_Table donné
  public
    procedure _from_ODRE_Table( _GRC: TGenero_Report_Context; _ODRE_Table: TODRE_Table);
  //Test
  public
    procedure Test;
  end;

implementation

{ TGenero_Report_Context }

constructor TGenero_Report_Context.Create( _XML_Model_Name, _RP_Model_Name: String);
begin
     XML_Model_Name:= _XML_Model_Name;
      RP_Model_Name:=  _RP_Model_Name;

     XML_Output_Name:= OD_Temporaire.Nouveau_Extension( 'GR','xml');
      RP_Output_Name:= OD_Temporaire.Nouveau_Extension( 'GR','4rp');

     ReadXMLFile( xml, XML_Model_Name);
     ReadXMLFile(  rp,  RP_Model_Name);

     exml_Report:= xml.FindNode( 'Report');
     erp_Report :=  rp.FindNode( 'report:Report');

     slNoms:= TStringList.Create;
end;

destructor TGenero_Report_Context.Destroy;
begin
     Free_nil( slNoms);
     inherited Destroy;
end;

procedure TGenero_Report_Context.Ecrit_XML;
begin
     WriteXMLFile( xml, XML_Output_Name);
end;

procedure TGenero_Report_Context.Ecrit_4RP;
begin
     WriteXMLFile( rp, RP_Output_Name);
end;

function TGenero_Report_Context.Nomme( _Prefixe: String): String;
var
   sCount: String;
   nCount: Integer;
begin
     sCount:= slNoms.Values[ _Prefixe];
     Result:= _Prefixe+sCount;

     if not TryStrToInt( sCount, nCount) then nCount:= 0;
     Inc( nCount);
     slNoms.Values[ _Prefixe]:= IntToStr( nCount)
end;

procedure TGenero_Report_Context.Nomme(_e: TDOMNode; _Prefixe: String);
begin
     Set_Property( _e, 'name', Nomme( _Prefixe));
end;

function TGenero_Report_Context.AC(_Parent: TDOMNode; _Name: String): TDOMNode;
begin
     Result:= Cree_path( _Parent, _Name);
end;

function TGenero_Report_Context.Create_Item_from_Field( _Parent: TDOMNode;
                                                        _Item_Name: String;
                                                        _F: TField;
                                                        _Triggered: Boolean): TDOMNode;
var
   Item_IsNull: Boolean;
   function Value_from_FieldType: String;
   begin
        case _F.DataType
        of
          ftString   : Result:= _F.DisplayText;
          ftMemo     : Result:= _F.AsString;
          else         Result:= _F.DisplayText;
          end;
   end;
begin
     Result:= nil;

     if nil = _F then exit;

     Item_IsNull:= _F.IsNull or not _Triggered;

     Result:= _Parent.AppendChild( _Parent.OwnerDocument.CreateElement('Item'));
     Set_Property( Result, 'name', _F.FieldName);
     Set_Property( Result, 'type', 'TEXT');
     if not Item_IsNull
     then
         Set_Property( Result, 'value', Value_from_FieldType);
     Set_Property( Result, 'isNull', BoolToStr( Item_IsNull, '1','0'));
end;

procedure TGenero_Report_Context.rp_Traite_entetes_colonnes;
var
   eTABLE: TDOMNode;
   eCOLDEFS: TDOMNode;
   eCOLDEF: TDOMNode;

   eTHEAD: TDOMNode;
   eROW  : TDOMNode;
   eCOL  : TDOMNode;
   eWORDBOX: TDOMNode;
var
   iColonne: Integer;
   OD_Column: TOD_Column;
begin
     eTABLE:=  Cherche_Item_Recursif( erp_Report, 'TABLE', ['name'],['Table']);
     if nil = eTABLE then exit;

     eCOLDEFS:= Cherche_Item( eTABLE, 'COLDEFS',[],[]);
     if nil = eCOLDEFS then exit;

     eTHEAD:= Cherche_Item( eTABLE, 'THEAD',[],[]);
     if nil = eTHEAD then exit;

     erp_TBODY:= Cherche_Item( eTABLE, 'TBODY',[],[]);

     eROW:= Cherche_Item( eTHEAD, 'ROW',[],[]);
     if nil = eROW then exit;


     for iColonne:= Low(ODRE_Table.Columns) to High( ODRE_Table.Columns)
     do
       begin
       OD_Column:= ODRE_Table.Columns[iColonne];

       eCOLDEF:= AC( eCOLDEFS, 'COLDEF');
       Nomme( eCOLDEF, 'GR_COLDEF');
       Set_Property( eCOLDEF, 'pWidth', IntToStr( OD_Column.Largeur));


       eCOL:= AC( eROW, 'COL');
       Nomme( eCOL, 'GR_COL');

       eWORDBOX:= AC( eCOL, 'WORDBOX');
       Nomme( eWORDBOX, 'GR_WORDBOX');

       Set_Property( eWORDBOX, 'class'           , 'grwTableStringColumnTitle');
       Set_Property( eWORDBOX, 'anchorX'         , '1'                        );
       Set_Property( eWORDBOX, 'floatingBehavior', 'enclosed'                 );
       Set_Property( eWORDBOX, 'textAlignment'   , 'center'                   );
       Set_Property( eWORDBOX, 'text'            , OD_Column.Titre            );
       end;
end;

procedure TGenero_Report_Context.rp_TraiteDataset( _rp_Parent: TDOMNode; iDataset: Integer);
var
   OD_Dataset_Columns: TOD_Dataset_Columns;
   OD_Styles: TOD_Styles;

   OD_Column: TOD_Column;
   Item_Prefix: String;
   Niveau_le_plus_bas: Boolean;

   erp_Niveau: TDOMNode;
   eROW: TDOMNode;

   procedure Cree_Niveau;
   var
      Niveau_Name: String;
      Niveau_Constraint: String;
   begin
        if Niveau_le_plus_bas
        then
            begin
            Niveau_Name:= 'OnEveryRow '+OD_Dataset_Columns.Nom;
            Niveau_Constraint:= 'OnEveryRow';
            end
        else
            begin
            Niveau_Name:= 'Group '+OD_Dataset_Columns.Nom;
            Niveau_Constraint:= 'Group';
            end;
        erp_Niveau:= AC( _rp_Parent, 'rtl:match');
        Set_Property( erp_Niveau, 'name', Niveau_Name);
        Set_Property( erp_Niveau, 'nameConstraint', Niveau_Constraint);
        Set_Property( erp_Niveau, 'minOccurs', '0');
        Set_Property( erp_Niveau, 'maxOccurs', 'unbounded');
   end;
   procedure TraiteLigne( _eROW: TDOMNode; L: array of TOD_Dataset_Column; _Triggered: Boolean);
   var
      I:Integer;
      iColonne: Integer;
      OD_Dataset_Column: TOD_Dataset_Column;
      FieldName: String;
      F: TField;

      CellStyle_FieldName: String;
      CellStyle_Field: TField;
      CellStyle: String;
      sCellValue: String;
      Item_Name: String;
      Gras: Boolean;

      Cells: array of String;
      NomStyle: String;
      sTD, s_TD: String;

      eCOL: TDOMNode;
      eRTL_INPUT_VARIABLE: TDOMNode;
      eWORDBOX: TDOMNode;

      FieldPath: String;
      BoldExpr: String;
   begin
        if Length( L) =0 then exit;
        if nil = _eROW then exit;
        //if NewPage
        //then
        //    ODRE_Table.NewPage( C);
        //ROW:= C.NewRow;
        BoldExpr
        :=
           '{{'
          +  '('+Item_Prefix+'NewGroup==1)'
          +'||('+Item_Prefix+'EndGroup==1)'
          +'||('+Item_Prefix+'BoldLine==1)'
          +'}}';
          {
          //Gras:= NewGroup or EndGroup or BoldLine;
          BooleanFieldValue( ds, 'BoldLine'    , fBoldLine    , BoldLine );
          BooleanFieldValue( ds, 'NewGroup'    , fNewGroup    , NewGroup );
          BooleanFieldValue( ds, 'EndGroup'    , fEndGroup    , EndGroup );
          IntegerFieldValue( ds, 'GroupSize'   , fGroupSize   , GroupSize);
          IntegerFieldValue( ds, 'SizePourcent', fSizePourcent, SizePourcent);
          IntegerFieldValue( ds, 'LineSize'    , fLineSize    , LineSize );
          BooleanFieldValue( ds, 'NewPage'     , fNewPage     , NewPage  );
          }

        SetLength( Cells, Length( ODRE_Table.Columns));
        for I:= Low( L) to High( L)
        do
          begin
          OD_Dataset_Column:= L[ I];
          FieldName:= OD_Dataset_Column.FieldName;
          CellStyle_FieldName:= FieldName+'_CellStyle';
          FieldPath:= Item_Prefix+FieldName;

          eCOL:= AC( _eROW, 'COL');
          Nomme( eCOL, 'GR_COL');

          eRTL_INPUT_VARIABLE:= AC( eCOL, 'rtl:input-variable');
          Set_Property( eRTL_INPUT_VARIABLE, 'name'            , FieldPath     );
          Set_Property( eRTL_INPUT_VARIABLE, 'type'            , 'FGLString'   );
          Set_Property( eRTL_INPUT_VARIABLE, 'expectedLocation', 'expectedHere');

          eWORDBOX:= AC( eCOL, 'WORDBOX');
          Nomme( eWORDBOX, 'GR_WORDBOX');

          Set_Property( eWORDBOX, 'class'           , 'grwTableStringColumnValue');
          Set_Property( eWORDBOX, 'anchorX'         , '1'                        );
          Set_Property( eWORDBOX, 'floatingBehavior', 'enclosed'                 );
          Set_Property( eWORDBOX, 'textAlignment'   , 'left'                     );
          Set_Property( eWORDBOX, 'value'            , '{{'+FieldPath+'}}');
          Set_Property( eWORDBOX, 'fontBold'         , BoldExpr);
          end;
   end;
begin
     if High( ODRE_Table.OD_Datasets) < iDataset then exit;
     if nil = _rp_Parent then exit;

     Niveau_le_plus_bas:= High( ODRE_Table.OD_Datasets) = iDataset;
     OD_Dataset_Columns:= ODRE_Table.OD_Datasets[iDataset];

     Item_Prefix:= ODRE_Table.Nom+'.'+OD_Dataset_Columns.Nom+'.';
     Cree_Niveau;
     if Niveau_le_plus_bas
     then
         begin
         eROW:= AC( erp_Niveau, 'ROW');
         Nomme(eROW, 'GR_ROW');
         TraiteLigne( eROW, OD_Dataset_Columns.FAvant, OD_Dataset_Columns.Avant_Triggered);
         TraiteLigne( eROW, OD_Dataset_Columns.FApres, OD_Dataset_Columns.Apres_Triggered);
         end
     else
         begin
         eROW:= AC( erp_Niveau, 'ROW');
         Nomme(eROW, 'GR_ROW');
         TraiteLigne( eROW, OD_Dataset_Columns.FAvant, OD_Dataset_Columns.Avant_Triggered);

         rp_TraiteDataset( erp_Niveau, iDataset+1);

         eROW:= AC( erp_Niveau, 'ROW');
         Nomme(eROW, 'GR_ROW');
         TraiteLigne( eROW, OD_Dataset_Columns.FApres, OD_Dataset_Columns.Apres_Triggered);
         end;
end;


procedure TGenero_Report_Context.xml_TraiteDataset( _xml_Parent: TDOMNode; iDataset: Integer);
var
   OD_Dataset_Columns: TOD_Dataset_Columns;
   OD_Styles: TOD_Styles;
   ds: TDataset;

   OD_Column: TOD_Column;
   eBalise: TDOMNode;
   ePrint: TDOMNode;
   eBeforeGroup: TDOMNode;
   eBeforeGroup_Print: TDOMNode;
   eAfterGroup: TDOMNode;
   eAfterGroup_Print: TDOMNode;
   Item_Prefix: String;
   Niveau_le_plus_bas: Boolean;
   procedure Cree_Ligne;
   begin
        if Niveau_le_plus_bas
        then
            begin
            eBalise:= AC( _xml_Parent, 'OnEveryRow');
            eBeforeGroup      := nil;
            eBeforeGroup_Print:= nil;
            eAfterGroup       := nil;
            eAfterGroup_Print := nil;
            end
        else
            begin
            eBalise:= AC( _xml_Parent, 'Group');
            eBeforeGroup      := AC( eBalise     , 'BeforeGroup');
            eBeforeGroup_Print:= AC( eBeforeGroup, 'Print'      );
            eAfterGroup       := AC( eBalise     , 'AfterGroup' );
            eAfterGroup_Print := AC( eAfterGroup , 'Print'      );
            end;

        ePrint            := AC( eBalise     , 'Print'      );
   end;
   procedure TraiteLigne( _ePrint: TDOMNode; L: array of TOD_Dataset_Column; _Triggered: Boolean);
   var
      I:Integer;
      iColonne: Integer;
      OD_Dataset_Column: TOD_Dataset_Column;
      FieldName: String;
      F: TField;

      CellStyle_FieldName: String;
      CellStyle_Field: TField;
      CellStyle: String;
      sCellValue: String;
      Item_Name: String;
      Gras: Boolean;

      Cells: array of String;
      NomStyle: String;
      sTD, s_TD: String;
   begin
        if Length( L) =0 then exit;
        if nil = _ePrint then exit;
        //if NewPage
        //then
        //    ODRE_Table.NewPage( C);
        //ROW:= C.NewRow;
        SetLength( Cells, Length( ODRE_Table.Columns));
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
              Item_Name:= Item_Prefix+F.FieldName;

              Create_Item_from_Field( _ePrint, Item_Name, F, _Triggered);
              //if CellStyle = ''
              //then
              //    NomStyle:= Prefixe+'_'+OD_Dataset_Column.FieldName
              //else
              //    NomStyle:= CellStyle;

              if iColonne <= High( ODRE_Table.Columns)
              then
                  begin
                  Cells[iColonne]:= sCellValue;
                  //Gras:= NewGroup or EndGroup or BoldLine;

                  //Cell     := Row.Cells     [iColonne];
                  //Paragraph:= Row.Paragraphs[iColonne];
                  //Paragraph.Set_Style( NomStyle, Gras, GroupSize, LineSize);

                  //if     (1 = Pos('graphic',FieldName))
                  //   and (sCellValue <> '')
                  //then
                  //    begin
                  //    Frame:= Paragraph.NewFrame;
                  //    Image:= Frame.NewImage_as_Character;
                  //    Image.Set_Filename( sCellValue);
                  //    end
                  //else
                  //    Paragraph.AddText( sCellValue);

                  //if ODRE_Table.Bordure_Ligne
                  //then
                  //    begin
                  //    //Cell.TopBorder   := BorderLine_NewGroup;
                  //    //Cell.BottomBorder:= BorderLine_EndGroup;
                  //    end;
                  //Row.Fusionne( OD_Dataset_Column.Debut, OD_Dataset_Column.Fin);
                  end;
              end;
          end;
   end;
begin
     if High( ODRE_Table.OD_Datasets) < iDataset then exit;
     if nil = _xml_Parent then exit;

     Niveau_le_plus_bas:= High( ODRE_Table.OD_Datasets) = iDataset;
     OD_Dataset_Columns:= ODRE_Table.OD_Datasets[iDataset];

     Item_Prefix:= ODRE_Table.Nom+'.'+OD_Dataset_Columns.Nom+'.';
     ds:= OD_Dataset_Columns.D;
     if not ds.Active
     then
         ds.Open;

     ds.First;
     while not ds.Eof
     do
       begin
       Cree_Ligne;
       if Niveau_le_plus_bas
       then
           begin
           TraiteLigne( ePrint, OD_Dataset_Columns.FAvant, OD_Dataset_Columns.Avant_Triggered);
           TraiteLigne( ePrint, OD_Dataset_Columns.FApres, OD_Dataset_Columns.Apres_Triggered);
           end
       else
           begin
           TraiteLigne( eBeforeGroup_Print, OD_Dataset_Columns.FAvant, OD_Dataset_Columns.Avant_Triggered);
           xml_TraiteDataset( eBalise, iDataset+1);
           TraiteLigne( eAfterGroup_Print, OD_Dataset_Columns.FApres, OD_Dataset_Columns.Apres_Triggered);
           end;
       ds.Next;
       end;
     ds.Close;
end;

procedure TGenero_Report_Context._from_ODRE_Table( _ODRE_Table: TODRE_Table);
begin
     if nil = exml_Report then exit;

     ODRE_Table:= _ODRE_Table;

     xml_TraiteDataset( exml_Report, 0);
     Ecrit_XML;

      rp_Traite_entetes_colonnes;
      rp_TraiteDataset( erp_TBODY  , 0);
      Ecrit_4RP;

end;

{ TGenero_Report_from_ODRE_Table }

constructor TGenero_Report_from_ODRE_Table.Create;
begin

end;

destructor TGenero_Report_from_ODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure TGenero_Report_from_ODRE_Table._from_ODRE_Table( _GRC: TGenero_Report_Context; _ODRE_Table: TODRE_Table);
begin
     _GRC._from_ODRE_Table( _ODRE_Table);
end;

procedure TGenero_Report_from_ODRE_Table.Test;
var
   c: TSQLite3Connection;
   t: TSQLTransaction;
   sqlq: TSQLQuery;
   ODRE_Table: TODRE_Table;
   OD_Styles: TOD_Styles;
   grc: TGenero_Report_Context;
   dc: TOD_Dataset_Columns;
begin

     c:= TSQLite3Connection.Create( nil);

     OD_Styles:= TOD_Styles.Create( 'card,car');

     ODRE_Table:= TODRE_Table.Create( 'Corps');
     ODRE_Table.Pas_de_persistance:= True;
     ODRE_Table.AddColumn( 1, 'N°'     );
     ODRE_Table.AddColumn( 5, 'Libellé');

     grc
     :=
       TGenero_Report_Context.Create( ExtractFilePath( ParamStr(0))+ClassName+'_Template.xml',
                                      ExtractFilePath( ParamStr(0))+ClassName+'_Template.4rp');
     grc. RP_Output_Name:= ExtractFilePath( ParamStr(0))+ClassName+'_Test.4rp';
     grc.XML_Output_Name:= ExtractFilePath( ParamStr(0))+ClassName+'_Test.xml';
     try
        c.DatabaseName:= ExtractFilePath( ParamStr(0))+'test_db.sqlite';
        t:= TSQLTransaction.Create( nil);
        t.DataBase:= c;
        sqlq:= TSQLQuery.Create( nil);
        sqlq.Name:= 'sqlqTEST';

        sqlq.DataBase:= c;
        sqlq.SQL.Text:= 'select * from test';
        sqlq.Open;

        dc:= ODRE_Table.AddDataset( sqlq);
        dc.OD_Styles:= OD_Styles;
        dc.Column_Avant( 'id'     , 0, 0);
        dc.Column_Avant( 'libelle', 1, 1);

        _from_ODRE_Table( grc, ODRE_Table);
     finally
            Free_nil( sqlq);
            Free_nil( t);
            Free_nil( grc);
            Free_nil( ODRE_Table);
            Free_nil( c);
            end;
end;

end.

