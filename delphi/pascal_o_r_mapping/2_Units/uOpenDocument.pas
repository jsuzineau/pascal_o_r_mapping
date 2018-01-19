unit uOpenDocument;
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
    Xml.XMLDoc,
    uOD_Temporaire,
    uOD_Error,
    uOD_JCL,
    uOOoStrings,
    uuStrings,
    uOOoChrono,
    uOOoStringList,
    uOOoDelphiReportEngineLog,
    uWinUtils{pour MulDiv},

  SysUtils, Classes, Math, System.Zip;

type
 TOD_Root_Styles
 =
  (
  ors_xmlStyles_STYLES,
  ors_xmlStyles_AUTOMATIC_STYLES,
  ors_xmlContent_AUTOMATIC_STYLES
  );

 TODStringList
 =
  class( TStringList)
  //Méthodes surchargées
  protected
    function CompareStrings(const S1:String;const S2:String):Integer;override;
  end;

 TEnumere_field_Racine_Callback= procedure ( _e: IXMLNode) of object;

 TOpenDocument
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  //Extraction
  public
    Repertoire_Extraction: String;
  //Persistance
  private
    procedure XML_from_Repertoire_Extraction;
    procedure Repertoire_Extraction_from_XML;
    procedure Extrait;
  public
    procedure Save;
  //Attributs
  public
    Nom: String;
    is_Calc: Boolean;
  private
    function Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function Find_style_family_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles; _family: String): IXMLNode;
    function Find_style_text( _NomStyle: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function Find_style_text_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
  public
    xmlMeta             : IXMLDocument;
    xmlSettings         : IXMLDocument;
    xmlMETA_INF_manifest: IXMLDocument;
    xmlContent          : IXMLDocument;
    xmlStyles           : IXMLDocument;
    function CheminFichier_temporaire( _NomFichier: String): String;
  //Méthodes d'accés au XML
  public
    //Text
    function Get_xmlContent_TEXT: IXMLNode;
    function Get_xmlContent_USER_FIELD_DECLS: IXMLNode;
    function Get_xmlContent_AUTOMATIC_STYLES: IXMLNode;

    function Get_xmlStyles_STYLES: IXMLNode;
    function Get_xmlStyles_AUTOMATIC_STYLES: IXMLNode;
    function Get_xmlStyles_MASTER_STYLES: IXMLNode;

    function Get_STYLES( _Root: TOD_Root_Styles): IXMLNode;

    //Spreadsheet
    function Get_xmlContent_SPREADSHEET: IXMLNode;
    function Get_xmlContent_SPREADSHEET_first_TABLE: IXMLNode;
    function Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: IXMLNode;
  //Gestion des properties //deprecated -> uOD_JCL
  public
    function not_Get_Property( _e: IXMLNode;    //deprecated -> uOD_JCL
                               _FullName: String;
                               out _Value: String): Boolean;
    function not_Test_Property( _e: IXMLNode;   //deprecated -> uOD_JCL
                                _FullName: String;
                                _Values: array of String): Boolean;
    procedure Set_Property( _e: IXMLNode;       //deprecated -> uOD_JCL
                            _Fullname, _Value: String);
    procedure Delete_Property( _e: IXMLNode; _Fullname: String);
  //Gestion des items //deprecated -> uOD_JCL
  public
    function Cherche_Item( _eRoot: IXMLNode; _FullName: String; //deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): IXMLNode;
    function Cherche_Item_Recursif( _eRoot: IXMLNode; //deprecated -> uOD_JCL
                                    _FullName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): IXMLNode;
    function Ensure_Item( _eRoot: IXMLNode; _FullName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): IXMLNode;
    function Add_Item( _eRoot: IXMLNode; _FullName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): IXMLNode;
    procedure Supprime_Item( _e: IXMLNode);//deprecated -> uOD_JCL
    procedure Copie_Item( _Source, _Cible: IXMLNode);//deprecated -> uOD_JCL
  //Gestion des noms de cellules (tableur)
  public
    function  Named_Range_Cherche( _Nom: String): IXMLNode;
    function  Named_Range_Assure ( _Nom: String): IXMLNode;
    procedure Named_Range_Set    ( _Nom, _Base_Cell, _Cell_Range: String);
  //Méthodes créées pour compatibilité OOo
  private
    function Cherche_field( _Name: String): IXMLNode;
    function Find_style_family( _NomStyle: String;
                                _Root: TOD_Root_Styles;
                                _family: String): IXMLNode;
  public
    procedure Enumere_field_Racine( _Racine_Name: String; _CallBack: TEnumere_field_Racine_Callback);
    function Find_style_paragraph( _NomStyle: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function Find_style_paragraph_multiroot( _NomStyle: String;
                                     _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function Contient_Style_Enfant( _eRoot: IXMLNode;
                                    _NomStyleParent: String): Boolean;
    function Utilise_Style( _eRoot: IXMLNode;
                            _NomStyle: String): Boolean;
    function Style_NameFromDisplayName( _DisplayName: String): String;
    function Style_DisplayNameFromName( _Name: String): String;
    procedure Efface_Styles_Table( _NomTable: String);
  //Méthodes créées pour OpenDocument_DelphiReportEngine.exe
  public
    procedure Set_Field( _Name, _Value: String);
    procedure Get_Fields( _sl: TOOoStringList);
    function Field_Value( _Name: String): String;
    procedure Add_FieldGet( _Name: String);

    procedure Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
    procedure Duplique_Style_Colonne( _NomStyle_Source, _NomStyle_Cible: String);

    function Font_size_from_Style( _NomStyle: String): Integer;
  //Styles
  private
    function  Add_style( _NomStyle, _NomStyleParent: String;
                         _Root: TOD_Root_Styles;
                         _family, _class: String): IXMLNode;
    function  Add_style_with_text_properties( _NomStyle: String;
                                              _Root: TOD_Root_Styles;
                                              _family,
                                              _class: String;
                                              _NomStyleParent: String;
                                              _Gras: Boolean;
                                              _DeltaSize: Integer;
                                              _Size: Integer;
                                              _SizePourcent: Integer): IXMLNode;
    function  Add_automatic_style( _NomStyleParent: String;
                                   _Gras: Boolean;
                                   _DeltaSize: Integer;
                                   _Size: Integer;
                                   _SizePourcent: Integer;
                                   out _eStyle: IXMLNode;
                                   _Is_Header: Boolean;
                                   _family,
                                   _class,
                                   _number_prefix: String;
                                   var _number_counter: Integer): String;
  //Styles de paragraphe
  private
    Automatic_style_paragraph_number: Integer;
  public
    function  style_paragraph_not_found( _NomStyle: String;
                                      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): Boolean;
    function  Add_style_paragraph( _NomStyle, _NomStyleParent: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function  Ensure_style_paragraph( _NomStyle, _NomStyleParent: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    procedure Rename_style_paragraph( _NomStyle_Avant, _NomStyle_Apres: String;
                                      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES);
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer): String; overload;
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        out _eStyle: IXMLNode;
                                        _Is_Header: Boolean): String; overload;
  //Styles de caractères automatiques
  private
    Automatic_style_text_number: Integer;
  public
    function  Add_style_text( _NomStyle, _NomStyleParent: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
    function  Add_automatic_style_text( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer): String; overload;
    function  Add_automatic_style_text( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        out _eStyle: IXMLNode;
                                        _Is_Header: Boolean): String; overload;
  //Styles de cellule automatique
  private
    slStyles_Cellule_Properties: TODStringList;
  public
    function  Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): IXMLNode;
    function  Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): IXMLNode;
    function  Ensure_automatic_style_table_cell_properties( _NomTable: String; _X, _Y: Integer): IXMLNode;
  //Changer le style parent d'un style donné
  public
    procedure Change_style_parent( _NomStyle, _NomStyleParent: String);
  //Général
  private
    function Text_Traite_Field( FieldName, FieldContent: String;
                                CreeTextFields: Boolean): Boolean;
  public
    function Traite_Field( FieldName, FieldContent: String;
                           CreeTextFields: Boolean): Boolean;
  //Suppression des valeurs pour toute une sous-branche
  private
    procedure Field_Vide_Branche_CallBack( _e: IXMLNode);
  public
    procedure Field_Vide_Branche( _Racine_FieldName: String);
  //Propriétés TextDocument
  public
    function  Text_Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Text_Ecrire( _Nom: String; _Valeur : String);
  //Propriétés Calc
  public

  //Accés à une cellule par son nom
  public
    procedure Calc_SetText( _Name, _Value: String);
    function  Calc_GetText( _Name: String): String;
    property  Calc_Text[ _Name: String]: String read Calc_GetText write Calc_SetText;
    function  Calc_Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Calc_Ecrire( _Nom: String; _Valeur : String);
  //Contrôle d'existence d'un champ
  public
    function Existe( FieldName: String): Boolean;
  //Lecture de paramètres
  public
    function  Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Ecrire( _Nom: String; _Valeur : String);
  //Destruction de champs
  public
    procedure DetruitChamp( Champ: String);
  //Gestion des noms de fichiers
  public
    function URL_from_WindowsFileName( FileName: String): String;
    function WindowsFileName_from_URL( FileName: String): String;
  //Echappement d'une chaine en XML
  public
    function Escape_XML( S: String): String;
  //Remplace les références de champs par leur valeur
  public
    procedure Freeze_fields;
  //Enlève les styles inutilisés
  private
    procedure Try_Delete_Style( _eStyle: IXMLNode);
  public
    procedure Delete_unused_styles;
  //Propriétés de table
  public
    function Get_Table_Properties( _NomTable: String): IXMLNode;
    function Get_Table_Width     ( _NomTable: String): String;
  //Propriétés de cellule
  private
    Cell_Style: String;
  public
    procedure SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
    procedure Apply_Cell_Style( e: IXMLNode);
  //Affichage
  public
    procedure Show;
  //ajout d'espaces
  public
    procedure AddSpace( _e: IXMLNode; _c: Integer);
  //Ajout de texte
  public
    procedure AddText ( _e: IXMLNode; _Value: String;
                        _Escape_XML: Boolean= False; _Gras: Boolean= False;
                        _e_is_span: Boolean = False); overload;
    procedure AddText ( _Value: String;
                        _Escape_XML: Boolean= False; _Gras: Boolean= False); overload;
    function Append_SOFT_PAGE_BREAK( _eRoot: IXMLNode): IXMLNode;
  //Largeur_imprimable
  public
    function Largeur_Imprimable: double;
  //Entete
  public
    function FirstHeader: IXMLNode;
  //Style caractères gras
  public
    Name_style_text_bold: String;
    procedure Ensure_style_text_bold;
  //mimetype file
  private
    function mimetype_filename: String;
    function Getmimetype: String;
    procedure Setmimetype( _mimetype: String);
  public
    property mimetype: String read Getmimetype write Setmimetype;
  //Gestion modèle/document
  public
    Is_template: Boolean;
    procedure Is_template_from_extension;
    procedure MIMETYPE_and_MANIFEST_MEDIA_TYPE_from_Is_template;
  end;

//Gestion tables
function Cree_table( _e: IXMLNode; _Nom: String):IXMLNode;

function CellName_from_XY( X, Y: Integer): String;
procedure XY_from_CellName( CellName: String; var X, Y: Integer);

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;

implementation

function CellName_from_XY( X, Y: Integer): String;
   procedure Traite_X;
   var
      ln26: Integer;
      I: Integer;
      Value: Integer;
      Power26: Integer;
      Digit: Integer;
      procedure TraiteDigit;
      begin
           Result:= Result + Chr(Ord('A')+Digit-1);
      end;
   begin
        Value:= X+1;
        ln26:= Trunc( LogN( 26, Value));
        for I:= ln26 downto 0
        do
          begin
          Power26:= Trunc( IntPower( 26, I));
          Digit:= Value div Power26;
          Value:= Value mod Power26;
          TraiteDigit;
          end;
   end;
   procedure Traite_Y;
   begin
        Result:=  Result + IntToStr(Y+1);
   end;
begin
     Result:= '';
     Traite_X;
     Traite_Y;
end;

type
  EXY_from_CellName_Exception= class( Exception);

procedure XY_from_CellName( CellName: String; var X, Y: Integer);
var
   I: Integer;
   sX, sY: String;
   procedure Traite_sX;
   var
      LsX: Integer;
      J: Integer;
      C: Char;
      Value: Integer;
   begin
        X:= 0;
        LsX:= Length( sX);
        for J:= 0 to LsX-1
        do
          begin
          C:= sX[ LsX-J];
          Value:= Ord(C)-Ord('A')+1;
          X:= X + Trunc(Value * IntPower( 26, J));
          end;
   end;
   procedure Traite_sY;
   begin
        if not TryStrToInt( sY, Y)
        then
            raise EXY_from_CellName_Exception
                  .
                   Create(  'La syntaxe du numéro de ligne ('+sY+') '
                           +'est incorrecte dans '
                           +'la référence de cellule ('+CellName+')');
   end;
begin
     CellName:= UpperCase( CellName);
     sX:= '';
     sY:= '';
     I:= 1;
     while     (I < Length(CellName))
           and (CellName[I] in ['A'..'Z'])
     do
       Inc( I);
     sX:= Copy( CellName, 1, I-1);
     sY:= Copy( CellName, I, Length(CellName));

     Traite_sX;
     Traite_sY;
     Dec(X);
     Dec(Y);
end;

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;
begin
     Result:=  CellName_from_XY( Left , Top   )
              +':'
              +CellName_from_XY( Right, Bottom);
end;

function Cree_table( _e: IXMLNode; _Nom: String):IXMLNode;
begin
     //Result:= Cree_path( _e, 'text:p/table:table');
     Result:= Cree_path( _e, 'table:table');
     if Result = nil then exit;

     Result.SetAttribute( 'table:name', _Nom);
     Cree_path( Result, 'table:table-header-rows/table:table-row/table:table-cell');
     Cree_path( Result,                         'table:table-row/table:table-cell');

end;

{ TODStringList }

function TODStringList.CompareStrings(const S1, S2: String): Integer;
begin
     Result:= CompareStr( S1, S2);
end;


{ TOpenDocument }

constructor TOpenDocument.Create( _Nom: String);
   procedure Calcule_is_Calc;
   var
      Ext: String;
   begin
        Ext:= UpperCase( ExtractFileExt( Nom));
        is_Calc
        :=
            ('.OTS' = Ext)
          or('.ODS' = Ext);
   end;
begin
     Automatic_style_paragraph_number:= 0;
     Automatic_style_text_number:= 0;
     Nom:= _Nom;
     Calcule_is_Calc;
     Is_template_from_extension;

     slStyles_Cellule_Properties:= TODStringList.Create;

     Extrait;

     XML_from_Repertoire_Extraction;
end;

destructor TOpenDocument.Destroy;
begin
     FreeAndNil( xmlMeta             );
     FreeAndNil( xmlSettings         );
     FreeAndNil( xmlMETA_INF_manifest);
     FreeAndNil( xmlContent          );
     FreeAndNil( xmlStyles           );

     FreeAndNil( slStyles_Cellule_Properties);

     ChDir( ExtractFilePath( Nom));
     OD_Temporaire.DetruitRepertoire( Repertoire_Extraction);

     inherited;
end;

procedure TOpenDocument.XML_from_Repertoire_Extraction;
   procedure Cree_XML( _FileName: String; var _xml: IXMLDocument);
   var
      NomFichier: String;
   begin
         NomFichier:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_FileName;

        _xml:= LoadXMLDocument( NomFichier);
        _xml.Options:= _xml.Options-[doNodeAutoCreate]+[doNodeAutoIndent];
        _xml.Active:= True;
        (*_xml.IndentString:= '  ';
        with _xml do Options:= Options + [sxoAutoEncodeValue];*)

        OOoChrono.Stop( 'Chargement en objet du fichier xml '+_FileName);
   end;
begin
     OOoChrono.Stop( 'Extraction des fichiers xml');

     Cree_XML( 'meta.xml'             , xmlMeta             );
     Cree_XML( 'settings.xml'         , xmlSettings         );
     Cree_XML( 'META-INF'+PathDelim+'manifest.xml', xmlMETA_INF_manifest);
     Cree_XML( 'content.xml'          , xmlContent          );
     Cree_XML( 'styles.xml'           , xmlStyles           );
end;

procedure TOpenDocument.Repertoire_Extraction_from_XML;
   procedure Sauve_XML( _FileName: String; var _xml: IXMLDocument);
   var
      NomFichier: String;
   begin
        NomFichier:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_FileName;
        _xml.SaveToFile( NomFichier);
   end;
begin
     MIMETYPE_and_MANIFEST_MEDIA_TYPE_from_Is_template;
     Sauve_XML( 'meta.xml'             , xmlMeta             );
     Sauve_XML( 'settings.xml'         , xmlSettings         );
     Sauve_XML( 'META-INF'+PathDelim+'manifest.xml', xmlMETA_INF_manifest);
     Sauve_XML( 'content.xml'          , xmlContent          );
     Sauve_XML( 'styles.xml'           , xmlStyles           );
end;

procedure TOpenDocument.Extrait;
var
   zf: TZipFile;
   procedure Teste_ouverture;
   var
      FTest: File;
   begin
        try
           AssignFile( FTest, Nom);
           Reset( FTest, 1);
           CloseFile( FTest);
        except
              on E: Exception
              do
                OD_Error.Execute(  'Test ouverture: impossible d''ouvrir le fichier '+Nom+':'#13#10
                                  +E.Message);
              end;
   end;
   procedure Do_Open;
   begin
        OOoChrono.Stop( 'Ouverture de l''archive zip');
        try
           zf.Open( Nom, zmRead);
        except
              on E: Exception
              do
                OOoChrono.Stop( 'Echec de l''ouverture de l''archive zip:'+E.Message);
              end;
        OOoChrono.Stop( 'Fin ouverture de l''archive zip');
   end;
begin
     Repertoire_Extraction:= OD_Temporaire.Nouveau_Repertoire( 'OD');

     Teste_ouverture;

     zf:= TZipFile.Create;
     try
        try
           Do_Open;
        except
              on E: Exception
              do
                begin
                OD_Error.Execute(  'Impossible d''ouvrir le fichier '+Nom+', une seconde tentative sera faite aprés un délai de 5 s:'#13#10
                                  +E.Message);
                Sleep( 5000);
                Do_Open;
                end;
              end;
        zf.ExtractAll( IncludeTrailingPathDelimiter( Repertoire_Extraction));
        zf.Close;
     finally
            FreeAndNil( zf);
            end;
     OOoChrono.Stop( 'aprés Extraction des fichiers xml');
end;

procedure TOpenDocument.Save;
const
     s_mimetype='mimetype';
var
   zf: TZipFile;
   procedure Ajoute_SousRepertoire( _SousRepertoire: String);
   var
      F: TSearchRec;
      Erreur: Integer;
      DiskDirPath,
      ZipDirPath,
      DiskFileName,
      ZipFileName: String;
   begin
        ZipDirPath:= _SousRepertoire;
        DiskDirPath:= IncludeTrailingPathDelimiter( Repertoire_Extraction)
                            +_SousRepertoire;
        if 0 = FindFirst( DiskDirPath+'*', faAnyFile, F)
        then
            repeat
                  DiskFileName:= DiskDirPath+F.Name;
                  ZipFileName := ZipDirPath+F.Name;
                  if (F.Attr and faDirectory) = faDirectory
                  then
                      begin
                      if     (F.Name <> '.')
                         and (F.Name <> '..')
                      then
                          Ajoute_SousRepertoire( ZipFileName+PathDelim)
                      end
                  else if s_mimetype <> F.Name
                  then
                      zf.Add( DiskFileName, ZipFileName);
            until FindNext(F)<>0;
        FindClose( F);
   end;
begin
     Repertoire_Extraction_from_XML;
     //TZipFile.ZipDirectoryContents( Nom, Repertoire_Extraction);

     zf:= TZipFile.Create;
     try
        zf.Open( Nom, zmWrite);
        zf.Add( IncludeTrailingPathDelimiter( Repertoire_Extraction)+s_mimetype, s_mimetype, zcStored);
        Ajoute_SousRepertoire( '');
        zf.Close;
     finally
            FreeAndNil( zf);
            end;
end;

function TOpenDocument.CheminFichier_temporaire( _NomFichier: String): String;
begin
     Result:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_NomFichier;
end;

const
     URL_file_prefix= 'file:///';

function TOpenDocument.URL_from_WindowsFileName(FileName: String): String;
var
   I: Integer;
begin
     Result:= FileName;
     for I:= 1 to Length( Result)
     do
       if Result[I]= '\'
       then
           Result[I]:= '/';
     Result:= URL_file_prefix+Result;
end;

function TOpenDocument.WindowsFileName_from_URL( FileName: String): String;
var
   I: Integer;
begin
     Result:= FileName;
     if 1 = Pos( URL_file_prefix, Result)
     then
         Delete( Result, 1, Length( URL_file_prefix));
     for I:= 1 to Length( Result)
     do
       if Result[I]= '/'
       then
           Result[I]:= '\';
end;

function TOpenDocument.Get_xmlContent_TEXT: IXMLNode;
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, 'office:body/office:text')
end;

function TOpenDocument.Get_xmlContent_USER_FIELD_DECLS: IXMLNode;
const
     USER_FIELD_DECLS_path='office:body/office:text/text:user-field-decls';
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, USER_FIELD_DECLS_path);
     if Assigned( Result) then exit;

     Result:= Cree_path( xmlContent.DocumentElement, USER_FIELD_DECLS_path);
end;

function TOpenDocument.Get_xmlContent_AUTOMATIC_STYLES: IXMLNode;
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET: IXMLNode;
begin
     Result
     :=
       Elem_from_path( xmlContent.DocumentElement,
                       'office:body/office:spreadsheet');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_first_TABLE: IXMLNode;
var
   eRoot: IXMLNode;
   e: IXMLNode;
   I: Integer;
begin
     Result:= nil;
     eRoot:= Get_xmlContent_SPREADSHEET;

     for I:= 0 to eRoot.ChildNodes.Count -1
     do
       begin
       e:= eRoot.ChildNodes[0];
       if e = nil then continue;

       if 'table' = Name_from_FullName( e.NodeName)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: IXMLNode;
begin
     Result
     :=
       Elem_from_path( xmlContent.DocumentElement,
                       'office:body/office:spreadsheet/table:named-expressions');
end;

function TOpenDocument.Get_xmlStyles_STYLES: IXMLNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement,'office:styles')
end;

function TOpenDocument.Get_xmlStyles_AUTOMATIC_STYLES: IXMLNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlStyles_MASTER_STYLES: IXMLNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement, 'office:master-styles');
end;

function TOpenDocument.not_Get_Property( _e: IXMLNode;
                                         _FullName: String;
                                         out _Value: String): Boolean;
begin
     Result:= uOD_JCL.not_Get_Property( _e, _FullName, _Value);
end;

function TOpenDocument.not_Test_Property( _e: IXMLNode;
                                          _FullName: String;
                                          _Values: array of String): Boolean;
begin
     Result:= uOD_JCL.not_Test_Property( _e, _FullName, _Values);
end;

procedure TOpenDocument.Set_Property( _e: IXMLNode;
                                      _Fullname, _Value: String);
begin
     uOD_JCL.Set_Property( _e, _Fullname, _Value);
end;

procedure TOpenDocument.Delete_Property( _e: IXMLNode; _Fullname: String);
begin
     uOD_JCL.Delete_Property( _e, _FullName);
end;

procedure TOpenDocument.Set_Field( _Name, _Value: String);
var
   e: IXMLNode;
begin
     e:= Ensure_Item( Get_xmlContent_USER_FIELD_DECLS, 'text:user-field-decl',
                      ['text:name'],
                      [_Name      ]
                    );
     if e= nil then exit;

     Set_Property( e, 'office:value-type'  , 'string');
     Set_Property( e, 'office:string-value', _Value  );
end;

procedure TOpenDocument.Get_Fields( _sl: TOOoStringList);
var
   eUSER_FIELD_DECLS: IXMLNode;
   I: Integer;
   e: IXMLNode;
   Name, String_Value: String;
begin
     _sl.Clear;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.ChildNodes[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name'          , Name        ) then continue;
       if not_Get_Property( e, 'office:string-value', String_Value) then continue;

       _sl.Add(Name+'='+String_Value);
       end;
     OOoChrono.Stop( 'Extraction des TextFields');
end;

procedure TOpenDocument.Add_FieldGet( _Name: String);
var
   eTEXT: IXMLNode;
   eP: IXMLNode;
   eUSER_FIELD_GET: IXMLNode;
begin
     eTEXT:= Get_xmlContent_TEXT;
     if eTEXT = nil then exit;

     eP:= eTEXT.AddChild( 'text:p');
     if eP = nil then exit;

     eUSER_FIELD_GET:= eP.AddChild( 'text:user-field-get');
     if eUSER_FIELD_GET = nil then exit;

     eUSER_FIELD_GET.SetAttribute( 'text:name', _Name);
end;

function TOpenDocument.Get_STYLES( _Root: TOD_Root_Styles): IXMLNode;
begin
     case _Root
     of
       ors_xmlStyles_STYLES           : Result:= Get_xmlStyles_STYLES;
       ors_xmlStyles_AUTOMATIC_STYLES : Result:= Get_xmlStyles_AUTOMATIC_STYLES;
       ors_xmlContent_AUTOMATIC_STYLES: Result:= Get_xmlContent_AUTOMATIC_STYLES;
       else                             Result:= nil;
       end;
end;

function TOpenDocument.Add_style( _NomStyle,
                                  _NomStyleParent: String;
                                  _Root: TOD_Root_Styles;
                                  _family, _class: String): IXMLNode;
var
   Name: String;
   Parent_Style_Name: String;
   eSTYLES: IXMLNode;
   e: IXMLNode;
begin
     Result:= nil;
     Name             := Style_NameFromDisplayName( _NomStyle      );
     Parent_Style_Name:= Style_NameFromDisplayName( _NomStyleParent);

     eSTYLES:= Get_STYLES( _Root);
     if eSTYLES = nil then exit;

     e:= eSTYLES.AddChild( 'style:style');
     if e= nil then exit;

     e.SetAttribute( 'style:name'             , Name             );
     e.SetAttribute( 'style:display-name'     , _NomStyle        );
     e.SetAttribute( 'style:parent-style-name', Parent_Style_Name);
     e.SetAttribute( 'style:family'           , _family          );
     if _class <> ''
     then
         e.SetAttribute( 'style:class'        , _class           );

     Result:= e;
end;

function TOpenDocument.Add_style_paragraph( _NomStyle, _NomStyleParent: String;
                                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, 'paragraph','text');
end;

function TOpenDocument.Add_style_text( _NomStyle, _NomStyleParent: String; _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, 'text','');
end;

function TOpenDocument.Add_style_with_text_properties( _NomStyle: String;
                                                       _Root: TOD_Root_Styles;
                                                       _family,
                                                       _class,
                                                       _NomStyleParent: String;
                                                       _Gras: Boolean;
                                                       _DeltaSize,
                                                       _Size,
                                                       _SizePourcent: Integer): IXMLNode;
var
   eTEXT_PROPERTIES: IXMLNode;
   Font_size: Integer;
   sFont_Size: String;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, _family, _class);
     if Result = nil then exit;

     eTEXT_PROPERTIES:= Ensure_Item(Result, 'style:text-properties', [], []);
     if eTEXT_PROPERTIES = nil then exit;

     if _Gras
     then
         Set_Property( eTEXT_PROPERTIES, 'fo:font-weight', 'bold');

     if _Size <> 0
     then
         begin
         sFont_Size:= IntToStr( _Size)+'pt';
         Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
         end;

     if _DeltaSize <> 0
     then
         begin
         Font_size:= Font_size_from_Style( _NomStyleParent);
         if Font_size <> 0
         then
             begin
             Font_size:= Font_size + _DeltaSize;
             sFont_Size:= IntToStr( Font_size)+'pt';
             Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
             end;
         end;
     if _SizePourcent <> 100
     then
         begin
         Font_size:= Font_size_from_Style( _NomStyleParent);
         if Font_size <> 0
         then
             begin
             Font_size:= MulDiv( Font_size , _SizePourcent, 100);
             sFont_Size:= IntToStr( Font_size)+'pt';
             Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
             end;
         end;
end;

function TOpenDocument.Add_automatic_style( _NomStyleParent: String;
                                            _Gras: Boolean;
                                            _DeltaSize,
                                            _Size,
                                            _SizePourcent: Integer;
                                            out _eStyle: IXMLNode;
                                            _Is_Header: Boolean;
                                            _family,
                                            _class,
                                            _number_prefix: String;
                                            var _number_counter: Integer): String;
var
   Style_Root: TOD_Root_Styles;
   eTEXT_PROPERTIES: IXMLNode;
   Font_size: Integer;
   sFont_Size: String;
begin
     Result:= _number_prefix+IntToStr( _number_counter);

     if _Is_Header
     then
         Style_Root:= ors_xmlStyles_AUTOMATIC_STYLES
     else
         Style_Root:= ors_xmlContent_AUTOMATIC_STYLES;

     _eStyle
     :=
       Add_style_with_text_properties( Result,
                                       Style_Root,
                                       _family,
                                       _class,
                                       _NomStyleParent,
                                       _Gras,
                                       _DeltaSize,
                                       _Size,
                                       _SizePourcent
                                       );

     Inc( _number_counter);
end;


function TOpenDocument.Add_automatic_style_paragraph( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize,
                                                      _Size,
                                                      _SizePourcent: Integer;
                                                      out _eStyle: IXMLNode;
                                                      _Is_Header: Boolean): String;
begin
     Result:= Add_automatic_style( _NomStyleParent,
                                   _Gras,
                                   _DeltaSize,
                                   _Size,
                                   _SizePourcent,
                                   _eStyle,
                                   _Is_Header,
                                   'paragraph',
                                   'text',
                                   'ODP',
                                   Automatic_style_paragraph_number);
end;

function TOpenDocument.Add_automatic_style_text( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize,
                                                      _Size,
                                                      _SizePourcent: Integer;
                                                      out _eStyle: IXMLNode;
                                                      _Is_Header: Boolean): String;
begin
     Result:= Add_automatic_style( _NomStyleParent,
                                   _Gras,
                                   _DeltaSize,
                                   _Size,
                                   _SizePourcent,
                                   _eStyle,
                                   _Is_Header,
                                   'text',
                                   '',
                                   'ODT',
                                   Automatic_style_text_number);
end;

function TOpenDocument.Add_automatic_style_paragraph( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer): String;
var
   e: IXMLNode;
begin
     Result:= Add_automatic_style_paragraph( _NomStyleParent,
                                             _Gras,
                                             _DeltaSize,
                                             _Size,
                                             _SizePourcent,
                                             e,
                                             False);
end;

function TOpenDocument.Add_automatic_style_text( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer): String;
var
   e: IXMLNode;
begin
     Result:= Add_automatic_style_text( _NomStyleParent,
                                             _Gras,
                                             _DeltaSize,
                                             _Size,
                                             _SizePourcent,
                                             e,
                                             False);
end;

function TOpenDocument.Font_size_from_Style( _NomStyle: String): Integer;
var
   eSTYLE: IXMLNode;
   NomStyle_Parent: String;

   eTEXT_PROPERTIES: IXMLNode;
   sFont_Size: String;
begin
     Result:= 0;
     eSTYLE:= Find_style_paragraph_multiroot( _NomStyle, ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLE = nil then exit;

     if not_Get_Property( eSTYLE, 'style:parent-style-name', NomStyle_Parent)
     then
         NomStyle_Parent:= '';

     eTEXT_PROPERTIES:= Cherche_Item( eSTYLE, 'style:text-properties', [], []);
     if eTEXT_PROPERTIES = nil then exit;

     if not_Get_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size)
     then
         begin
         if NomStyle_Parent = ''
         then
             exit
         else
             Result:= Font_size_from_Style( NomStyle_Parent);
         end
     else
         begin
         //"8pt"
         Delete( sFont_Size, Length( sFont_Size)-1, 2);
         if not TryStrToInt( sFont_Size, Result)
         then
             Result:= 0;
         end;
end;

function TOpenDocument.Get_Table_Properties( _NomTable: String): IXMLNode;
var
   eSTYLES: IXMLNode;
   eSTYLE: IXMLNode;
begin
     Result:= nil;
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name','style:family'],
                    [_NomTable   ,'table'       ]);
     if eSTYLE = nil then exit;

     Result:= Ensure_Item( eSTYLE,'style:table-properties',[],[]);
end;

function TOpenDocument.Get_Table_Width(_NomTable: String): String;
var
   eTABLE_PROPERTIES: IXMLNode;
begin
     Result:= '';
     eTABLE_PROPERTIES:= Get_Table_Properties( _NomTable);
     not_Get_Property( eTABLE_PROPERTIES, 'style:width', Result);
end;

procedure TOpenDocument.SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
var
   eTABLE_CELL_PROPERTIES: IXMLNode;
   sPadding: String;
begin
     eTABLE_CELL_PROPERTIES:= Ensure_automatic_style_table_cell_properties( _NomTable, _X, _Y);

     Str( Padding_cm:5:3, sPadding);
     sPadding:= sPadding + 'cm';

     Set_Property( eTABLE_CELL_PROPERTIES, 'fo:padding', sPadding);

     //<style:table-cell-properties fo:padding="0cm" fo:border-left="" fo:border-right="none" fo:border-top="0.05pt dotted #000000" fo:border-bottom="0.05pt solid #000000"/>
end;

procedure TOpenDocument.Apply_Cell_Style( e: IXMLNode);
begin
     Set_Property( e, 'table:style-name', Cell_Style);
end;


procedure TOpenDocument.Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
var
   eSTYLES: IXMLNode;
   eSTYLE: IXMLNode;

   eTABLE_COLUMN_PROPERTIES: IXMLNode;

   sColumn_Width: String;

   Rel_Column_Width: Integer;
   sRel_Column_Width: String;
begin
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name','style:family'],
                    [_NomStyle   ,'table-column']);
     if eSTYLE = nil then exit;

     eTABLE_COLUMN_PROPERTIES
     :=
       Ensure_Item( eSTYLE,'style:table-column-properties',[],[]);
     if eTABLE_COLUMN_PROPERTIES= nil then exit;

     eTABLE_COLUMN_PROPERTIES.AttributeNodes.Delete( 'column-width');
     eTABLE_COLUMN_PROPERTIES.AttributeNodes.Delete( 'rel-column-width');

     if _Relatif
     then
         begin
         Rel_Column_Width:= Trunc( _Column_Width);
         sRel_Column_Width:= IntToStr( Rel_Column_Width)+'*';
         Set_Property( eTABLE_COLUMN_PROPERTIES, 'style:rel-column-width', sRel_Column_Width);
         end
     else
         begin
         Str( _Column_Width:5:3,sColumn_Width);
         sColumn_Width:= sColumn_Width+'cm';
         Set_Property( eTABLE_COLUMN_PROPERTIES, 'style:column-width', sColumn_Width);
         end;

end;

procedure TOpenDocument.Duplique_Style_Colonne( _NomStyle_Source, _NomStyle_Cible: String);
var
   eSTYLES: IXMLNode;

   eSTYLE_Source, eSTYLE_Cible: IXMLNode;
begin
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE_Source
     :=
       Cherche_Item( eSTYLES,
                    'style:style',
                    ['style:name'    ,'style:family'],
                    [_NomStyle_Source,'table-column']);
     if eSTYLE_Source = nil then exit;

     eSTYLE_Cible
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name'   ,'style:family'],
                    [_NomStyle_Cible,'table-column']);
     if eSTYLE_Cible = nil then exit;

     Copie_Item( eSTYLE_Source, eSTYLE_Cible);
     Set_Property( eSTYLE_Cible, 'style:name', _NomStyle_Cible);//écrasé par Copie_Item
end;

function TOpenDocument.style_paragraph_not_found( _NomStyle: String;
                                               _Root: TOD_Root_Styles): Boolean;
begin
     Result:= nil = Find_style_paragraph( _NomStyle, _Root);
end;

function TOpenDocument.Ensure_style_paragraph( _NomStyle, _NomStyleParent: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
var
   StyleName: String;
begin
     Result:= Find_style_paragraph( _NomStyle, _Root);

     if nil = Result
     then
         Result:= Add_style_paragraph( _NomStyle, _NomStyleParent, _Root)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( Result, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( Result, 'style:class', 'text');
             Set_Property( Result, 'style:parent-style-name', StyleName);
             end;
         end;
end;

procedure TOpenDocument.Rename_style_paragraph( _NomStyle_Avant, _NomStyle_Apres: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES);
var
   e: IXMLNode;
   StyleName_Apres: String;
begin
     e:= Find_style_paragraph( _NomStyle_Avant, _Root);

     if nil = e then exit;

     StyleName_Apres:= Style_NameFromDisplayName( _NomStyle_Apres);
     Set_Property( e, 'style:name'        , StyleName_Apres);
     Set_Property( e, 'style:display-name', _NomStyle_Apres);
end;

function TOpenDocument.Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
var
   StyleName: String;
begin
     Result:= Find_style_text( _NomStyle, _Root);

     if nil = Result
     then
         Result:= Add_style_text( _NomStyle, _NomStyleParent, _Root)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( Result, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( Result, 'style:parent-style-name', StyleName);
             end;
         end;
end;

function TOpenDocument.Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): IXMLNode;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: IXMLNode;
begin
     Result:= nil;
     eSTYLES:= Get_STYLES( ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLES = nil then exit;

     CellName:= CellName_from_XY( _X, _Y);
     NomStyle:= _NomTable+'.'+CellName;
     Result:= Ensure_Item( eSTYLES, 'style:style',
                           ['style:name', 'style:family'],
                           [NomStyle    , 'table-cell'  ]);
end;

function TOpenDocument.Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): IXMLNode;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: IXMLNode;
begin
     Result:= nil;
     eSTYLES:= Get_STYLES( ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLES = nil then exit;

     CellName:= CellName_from_XY( _X, _Y);
     NomStyle:= _NomTable+'.'+CellName;
     Result:= Add_Item( eSTYLES, 'style:style',
                        ['style:name', 'style:family'],
                        [NomStyle    , 'table-cell'  ]);
end;

function TOpenDocument.Ensure_automatic_style_table_cell_properties( _NomTable: String;
                                                        _X, _Y: Integer): IXMLNode;
var
   sCle: String;
   I: Integer;
   procedure Get_from_XML;
   var
      eStyle: IXMLNode;
   begin                                 
        eStyle:= Add_automatic_style_table_cell( _NomTable, _X, _Y);
        if eStyle = nil then exit;

        Result:= Add_Item( eStyle, 'style:table-cell-properties',[],[]);
        //slStyles_Cellule_Properties.AddObject( sCle, Result);
   end;
   {
   procedure Get_from_sl;
   var
      O: TObject;
   begin
        O:= slStyles_Cellule_Properties.Objects[ I];
        if O = nil                      then exit;
        if not (O is IXMLNode) then exit;
        Result:= IXMLNode( O);
   end;
   }
begin
     Result:= nil;

     sCle:= _NomTable+IntToHex(_X,8)+IntToHex(_Y,8);
     I:= slStyles_Cellule_Properties.IndexOf( sCle);
     if I = -1
     then
         Get_from_XML{
     else
         Get_from_sl};
end;

procedure TOpenDocument.Change_style_parent( _NomStyle, _NomStyleParent: String);
var
   e: IXMLNode;
   StyleName: String;
begin
     e:= Find_style_paragraph( _NomStyle);
     if e = nil
     then
         Add_style_paragraph( _NomStyle, _NomStyleParent)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( e, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( e, 'style:class', 'text');
             Set_Property( e, 'style:parent-style-name', StyleName);
             end;
         end;
end;

function TOpenDocument.Cherche_field( _Name: String): IXMLNode;
var
   eUSER_FIELD_DECLS: IXMLNode;
   I: Integer;
   e: IXMLNode;
   Name: String;
begin
     Result:= nil;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.ChildNodes[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if UpperCase(Name) = UpperCase(_Name)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;

var
   debug_count: integer= 0;
procedure TOpenDocument.Enumere_field_Racine( _Racine_Name: String;
                                              _CallBack: TEnumere_field_Racine_Callback);
var
   eUSER_FIELD_DECLS: IXMLNode;
   I: Integer;
   e: IXMLNode;
   Name: String;
begin
     if not Assigned( _CallBack) then exit;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       Inc( debug_count);
       e:= eUSER_FIELD_DECLS.ChildNodes[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if 1 = Pos( _Racine_Name, Name)
       then
           _CallBack( e);
       end;
end;

function TOpenDocument.Cherche_Item( _eRoot: IXMLNode; _FullName: String;
                                     _Properties_Names ,
                                     _Properties_Values: array of String): IXMLNode;
begin
     Result
     :=
       uOD_JCL.Cherche_Item( _eRoot, _FullName,
                                   _Properties_Names , _Properties_Values);
end;

function TOpenDocument.Cherche_Item_Recursif( _eRoot: IXMLNode; _FullName: String;
                                              _Properties_Names ,
                                              _Properties_Values: array of String): IXMLNode;
begin
     Result
     :=
       uOD_JCL.Cherche_Item_Recursif( _eRoot, _FullName,
                                            _Properties_Names ,
                                            _Properties_Values);
end;

function TOpenDocument.Ensure_Item( _eRoot: IXMLNode; _FullName: String;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): IXMLNode;
begin
     Result
     :=
       uOD_JCL.Ensure_Item( _eRoot, _FullName,
                                  _Properties_Names, _Properties_Values);
end;

function TOpenDocument.Add_Item( _eRoot: IXMLNode; _FullName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): IXMLNode;
begin
     Result
     :=
       uOD_JCL.Add_Item( _eRoot, _FullName,
                                  _Properties_Names, _Properties_Values);
end;

procedure TOpenDocument.Copie_Item( _Source, _Cible: IXMLNode);
begin
     uOD_JCL.Copie_Item( _Source, _Cible);
end;

function TOpenDocument.Find_style_family( _NomStyle: String;
                                          _Root: TOD_Root_Styles;
                                          _family: String): IXMLNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'style:style',
                              ['style:name','style:family'],
                              [Name        ,_family       ]);
end;

function TOpenDocument.Find_style_paragraph( _NomStyle: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text( _NomStyle: String;
                                        _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'text');
end;

function TOpenDocument.Find_style_family_multiroot( _NomStyle: String;
                                                    _Root: TOD_Root_Styles;
                                                    _family: String): IXMLNode;
     function CR( _R: TOD_Root_Styles): IXMLNode;
     begin
          Result:= Find_style_family( _NomStyle, _R, _family);
     end;
begin
     Result:= CR( _Root);
     if Assigned( Result) then exit;

     case _Root
     of
       ors_xmlStyles_STYLES: exit;
       ors_xmlStyles_AUTOMATIC_STYLES : Result:= CR( ors_xmlStyles_STYLES);
       ors_xmlContent_AUTOMATIC_STYLES: Result:= CR( ors_xmlStyles_STYLES);
       end;
end;

function TOpenDocument.Find_style_paragraph_multiroot( _NomStyle: String;
                                                       _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text_multiroot( _NomStyle: String;
                                                  _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): IXMLNode;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Contient_Style_Enfant( _eRoot: IXMLNode;
                                              _NomStyleParent: String): Boolean;
begin
     Result
     :=
       nil
       <>
       Cherche_Item( _eRoot,
                     'style:style',
                     ['style:family','style:parent-style-name'],
                     ['paragraph'   ,_NomStyleParent          ]);
end;

function TOpenDocument.Utilise_Style( _eRoot: IXMLNode;
                                      _NomStyle: String): Boolean;
begin
     Result:=nil<>Cherche_Item_Recursif(_eRoot,'text:p'   ,['text:style-name'],[_NomStyle]);
     if Result then exit;

     Result:=nil<>Cherche_Item_Recursif(_eRoot,'text:span',['text:style-name'],[_NomStyle]);
end;


function TOpenDocument.Text_Traite_Field( FieldName, FieldContent: String;
                                          CreeTextFields: Boolean): Boolean;
begin
     Set_Field( FieldName, FieldContent);

     if CreeTextFields
     then
         Add_FieldGet( FieldName);

     Result:= True;
end;

function TOpenDocument.Traite_Field( FieldName, FieldContent: String;
                                     CreeTextFields: Boolean): Boolean;
begin
     Result:= False;
     if is_Calc
     then
         begin end //Calc_SetText( FieldName, FieldContent)
     else
         Result:= Text_Traite_Field( FieldName, FieldContent, CreeTextFields)
end;

procedure TOpenDocument.Field_Vide_Branche_CallBack( _e: IXMLNode);
begin
     Set_Property( _e, 'office:string-value', '');
end;

procedure TOpenDocument.Field_Vide_Branche( _Racine_FieldName: String);
begin
     Enumere_field_Racine( _Racine_FieldName, Field_Vide_Branche_CallBack);
end;

function TOpenDocument.Existe( FieldName: String): Boolean;
begin
     Result:= nil <> Cherche_field( FieldName);
end;

procedure TOpenDocument.Calc_SetText( _Name, _Value: String);
//var
//   Cell: Variant;
begin
     //Cell:= CellByName( _Name);
     //if varDispatch = VarType( Cell)
     //then
     //    Cell.Formula:= _Value
     //else
     //    OOoDelphiReportEngineLog.Entree(  'TOOo_Document_Context.Calc_SetText: '
     //                                      +'échec  à la définition de '+_Name );
end;

function TOpenDocument.Calc_Lire( _Nom: String; _Default: String= ''): String;
//var
//   Cell: Variant;
begin
     //Result:= _Default;
     //if not Calc_hasByName( _Nom) then exit;
     //
     //Cell:= CellByName( _Nom);
     //if varDispatch	 <> VarType( Cell) then exit;
     //
     //Result:= Cell.Formula;
end;

procedure TOpenDocument.Calc_Ecrire( _Nom: String; _Valeur: String);
//var
//   Cell: Variant;
begin
     //Result:= _Default;
     //if not Calc_hasByName( _Nom) then exit;
     //
     //Cell:= CellByName( _Nom);
     //if varDispatch	 <> VarType( Cell) then exit;
     //
     //Result:= Cell.Formula;
end;

function TOpenDocument.Text_Lire( _Nom: String; _Default: String= ''): String;
var
   e: IXMLNode;
begin
     Result:= _Default;

     e:= Cherche_field( _Nom);
     if e = nil then exit;

     not_Get_Property( e, 'office:string-value', Result);
end;

procedure TOpenDocument.Text_Ecrire( _Nom: String; _Valeur: String);
var
   e: IXMLNode;
begin
     e:= Cherche_field( _Nom);
     if e = nil then exit;

     Set_Property( e, 'office:string-value', _Valeur);
end;

function TOpenDocument.Lire( _Nom: String; _Default: String= ''): String;
begin
     if Is_Calc
     then
         Result:= Calc_Lire( _Nom, _Default)
     else
         Result:= Text_Lire( _Nom, _Default);
end;

procedure TOpenDocument.Ecrire( _Nom: String; _Valeur: String);
begin
     if Is_Calc
     then
         Calc_Ecrire( _Nom, _Valeur)
     else
         Text_Ecrire( _Nom, _Valeur);
end;

function  TOpenDocument.Calc_GetText( _Name: String): String;
begin
     Result:= Calc_Lire( _Name, '');
end;

procedure TOpenDocument.DetruitChamp(Champ: String);
var
   eUSER_FIELD_DECLS: IXMLNode;
   e: IXMLNode;
begin
     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     e:= Cherche_field( Champ);
     if e = nil then exit;

     eUSER_FIELD_DECLS.ChildNodes.Remove( e);
end;

function TOpenDocument.Style_NameFromDisplayName( _DisplayName: String): String;
var
   I: Integer;
   C: Char;
begin
     Result:= '';
     for I:= 1 to Length( _DisplayName)
     do
       begin
       C:= _DisplayName[I];
       case C
       of
         'a'..'z','A'..'Z','0'..'9': Result:= Result + C;
         else Result:= Result + '_'+LowerCase( IntToHex(Ord(C), 2))+'_';
         end;
       end;
end;

function TOpenDocument.Style_DisplayNameFromName(_Name: String): String;
var
   I: Integer;
   C: Char;
   hex: String;
begin
     Result:= '';
     I:= 1;
     while I<= Length( _Name)
     do
       begin
       C:= _Name[I];
       if     (C = '_')
          and (I+3 < Length( _Name))
       then
           begin
           hex:= '$'+_Name[I+1]+_Name[I+2];
           Inc( I, 3);
           C:= Chr( StrToInt( hex));
           end;
       Result:= Result + C;
       Inc( I)
       end;
end;

function TOpenDocument.Field_Value(_Name: String): String;
var
   e: IXMLNode;
   String_Value: String;
begin
     Result:= '';

     e:= Cherche_field( _Name);
     if e = nil then exit;

     if not_Get_Property( e, 'office:string-value', String_Value) then exit;
     Result:= String_Value;
end;

procedure TOpenDocument.Supprime_Item( _e: IXMLNode);
var
   Parent: IXMLNode;
begin
     if _e = nil then exit;

     Parent:= _e.ParentNode;
     if Parent= nil then exit;

     Parent.ChildNodes.Remove( _e);
end;

function TOpenDocument.Escape_XML( S: String): String;
var
   I: Integer;
   C: Char;
   X: String;
begin
     Result:= '';
     for I:= 1 to Length( S)
     do
       begin
       C:= S[I];
       case C
       of
         '<'       : X:= '&lt;'  ;
         '>'       : X:= '&gt;'  ;
         '&'       : X:= '&amp;' ;
         ''''      : X:= '&apos;';
         '"'       : X:= '&quot;';
         ' '       {,
         #128..#255}: X:= '&#x'+IntToHex( Ord(C),2)+';';
         else        X:= C;
         end;
       Result:= Result + X;
       end;
end;

procedure TOpenDocument.AddSpace( _e: IXMLNode; _c: Integer);
begin
     if _c < 1 then exit;

     if _c = 1
     then
         Add_Item( _e, 'text:s',[],[])
     else
         Add_Item( _e, 'text:s', ['text:c'], [IntToStr( _c)]);
end;

procedure TOpenDocument.AddText( _e: IXMLNode; _Value: String;
                                 _Escape_XML: Boolean= False;
                                 _Gras: Boolean= False;
                                 _e_is_span: Boolean = False);
var
   I: Integer;
   C: Char;
   S: String;
   procedure Ajoute_SautLigne;
   begin
        _e.AddChild('text:line-break');
   end;
   procedure Ajoute_Tabulation;
   begin
        _e.AddChild('text:tab');
   end;
   procedure Ajoute_S;
   var
      eSPAN: IXMLNode;
   begin
        if S = '' then exit;

        if _Escape_XML
        then
            S:= Escape_XML( S);

        if _e_is_span
        then
            eSPAN:= _e
        else
            eSPAN:= _e.AddChild( 'text:span');
        eSPAN.Text:= S;
        if _Gras then Set_Property( eSPAN, 'text:style-name', Name_style_text_bold);
        S:= '';
   end;
   procedure Traite_Espaces;
   var
      L: Integer;
      function Index: Integer;
      begin
           Result:= I+L-1;
      end;
   begin
        S:= S + C;
        Ajoute_S;

        L:= 2;//le premier caractère a déjà été testé
        while     (Index <= Length( _Value))
              and (_Value[Index] = ' ')
        do
          Inc( L);
        if Index <= Length( _Value)
        then
            Dec( L);

        AddSpace( _e, L-1); // le premier espace est déjà rajouté

        Inc( I, L-1); // on se place sur le dernier caractère
   end;
   procedure Traite_SautLigne_Windows_Mac;
   begin
        Ajoute_S;
        Ajoute_SautLigne;
        if     (I < Length( _Value))
           and (_Value[I+1] = #10)
        then
            Inc( I);

   end;
   procedure Traite_SautLigne_Linux;
   begin
        Ajoute_S;
        Ajoute_SautLigne;
   end;
   procedure Traite_Tabulation;
   begin
        Ajoute_S;
        Ajoute_Tabulation;
   end;
   procedure Traite_non_imprimable;
   begin
        S:= S+' ';
   end;
begin
     S:= '';
     I:= 1;
     while I<= Length( _Value)
     do
       begin
       C:= _Value[ I];
       case C
       of
         #0..#8  : Traite_non_imprimable;
         #9      : Traite_Tabulation;
         #10     : Traite_SautLigne_Linux;
         #11,
         #12     : Traite_non_imprimable;
         #13     : Traite_SautLigne_Windows_Mac;
         #14..#31: Traite_non_imprimable;
         ' '     : Traite_Espaces;
         //désactivé, on travaille en UTF8
         //#128..#255: S:= S + ' &#x'+IntToHex( Ord(C),2)+'; ';
         else        S:= S + C;
         end;
       Inc( I);
       end;

     Ajoute_S;
end;

procedure TOpenDocument.AddText( _Value: String; _Escape_XML: Boolean= False;
                                 _Gras: Boolean= False);
begin
     AddText( Get_xmlContent_TEXT, _Value, _Escape_XML, _Gras);
end;

procedure TOpenDocument.Freeze_fields;
    procedure Traite_USER_FIELD_GET( _e: IXMLNode);
    var
       FieldName: String;
       I: Integer;
       Parent: IXMLNode;
       eSPAN: IXMLNode;
       Value: String;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'text:name', FieldName) then exit;

         Parent:= _e.ParentNode;
         if Parent= nil then exit;


         I:= Parent.ChildNodes.IndexOf( _e);
         eSPAN:= Parent.AddChild('text:span', I);
         if eSPAN = nil then exit;

         Value:= Field_Value( FieldName);
         AddText( eSPAN, Value, False, False, True);

         Parent.ChildNodes.Remove( _e);
    end;
    procedure Traite_DATE( _e: IXMLNode);
    var
       I: Integer;
       DataStyleName, DateFixe: String;
       Parent: IXMLNode;
       eSPAN: IXMLNode;
       Value: String;
       procedure Insecable_to_Space;
       var
          J: Integer;
       begin
            if Value = '' then exit;

            for J:= 1 to Length( Value)
            do
              begin
              if Value[J] = #160
              then
                  Value[J]:= #32;
              end;
       end;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'style:data-style-name', DataStyleName)
         then
             DataStyleName:='';

         if not_Get_Property( _e, 'text:fixed', DateFixe) // non utilisé pour l'instant
         then
             DateFixe:= '';

         Parent:= _e.ParentNode;
         if Parent= nil then exit;

         I:= Parent.ChildNodes.IndexOf( _e);
         eSPAN:= Parent.AddChild( 'text:span', I);
         if eSPAN = nil then exit;

         //il faudrait aller interpréter le style fourni par DataStyleName
         Value:= FormatDateTime( 'dddddd', Now);
         //Insecable_to_Space;
         AddText( eSPAN, Value, False, False, True);

         Parent.ChildNodes.Remove( _e);
    end;
    procedure Traite_TIME( _e: IXMLNode);
    var
       I: Integer;
       DataStyleName, DateFixe: String;
       Parent: IXMLNode;
       eSPAN: IXMLNode;
       Value: String;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'style:data-style-name', DataStyleName)
         then
             DataStyleName:='';

         if not_Get_Property( _e, 'text:fixed', DateFixe) // non utilisé pour l'instant
         then
             DateFixe:= '';

         Parent:= _e.ParentNode;
         if Parent= nil then exit;

         I:= Parent.ChildNodes.IndexOf( _e);
         eSPAN:= Parent.AddChild( 'text:span', I);
         if eSPAN = nil then exit;

         //il faudrait aller interpréter le style fourni par DataStyleName
         Value:= FormatDateTime( 'tt', Now);
         AddText( eSPAN, Value, False, False, True);

         Parent.ChildNodes.Remove( _e);
    end;
    procedure T( _e: IXMLNode);
    var
       I: Integer;
    begin
         if _e = nil then exit;

              if _e.NodeName = 'text:user-field-get' then Traite_USER_FIELD_GET( _e)
         else if _e.NodeName = 'text:date'           then Traite_DATE( _e)
         else if _e.NodeName = 'text:time'           then Traite_TIME( _e)
         else
             for I:= 0 to _e.ChildNodes.Count-1
             do
               T( _e.ChildNodes[ I]);
    end;
    procedure Efface_Declarations;
    var
       e: IXMLNode;
    begin
         e:= Get_xmlContent_USER_FIELD_DECLS;
         e.ChildNodes.Clear;

         while True
         do
           begin
           e:= Cherche_Item_Recursif( Get_xmlStyles_MASTER_STYLES,
                                      'text:user-field-decls', [], []);
           if e = nil then break;
           Supprime_Item( e);
           end;
    end;
begin
     T( Get_xmlContent_TEXT);
     T( Get_xmlStyles_MASTER_STYLES);
     Efface_Declarations;
end;

procedure TOpenDocument.Try_Delete_Style( _eStyle: IXMLNode);
var
   Style_Name: String;
begin
     if not_Test_Property( _eStyle, 'style:family', ['paragraph']) then exit;

     if not_Get_Property( _eStyle, 'style:name'  , Style_Name  ) then exit;

     if Contient_Style_Enfant( Get_xmlStyles_STYLES           , Style_Name) then exit;
     if Contient_Style_Enfant( Get_xmlStyles_AUTOMATIC_STYLES , Style_Name) then exit;
     if Contient_Style_Enfant( Get_xmlContent_AUTOMATIC_STYLES, Style_Name) then exit;

     if Utilise_Style( Get_xmlStyles_MASTER_STYLES, Style_Name) then exit;
     if Utilise_Style( Get_xmlContent_TEXT        , Style_Name) then exit;

     OOoDelphiReportEngineLog.Entree( 'Style '+Style_Name+' inutilisé.');
     Supprime_Item( _eStyle);
end;

procedure TOpenDocument.Delete_unused_styles;
var
   eSTYLES: IXMLNode;
   I: Integer;
   e: IXMLNode;
begin
     eSTYLES:= Get_xmlStyles_STYLES;
     I:= eSTYLES.ChildNodes.Count - 1;
     while I >= 0
     do
       begin
       e:= eSTYLES.ChildNodes[ I];
       Try_Delete_Style( e);
       Dec( I);
       end;
end;

procedure TOpenDocument.Efface_Styles_Table( _NomTable: String);
var
   Prefixe: String;
   eAUTOMATIC_STYLES: IXMLNode;
   I: Integer;
   e: IXMLNode;
   Name: String;
   function Supprimer: Boolean;
   begin
        Result:= False;
        if e = nil                                               then exit;
        if not_Test_Property( e, 'style:family',[
                                                'table-column',
                                                'table-cell'
                                                ]
                                                )
                                                                 then exit;
        if  not_Get_Property( e, 'style:name'  , Name          ) then exit;
        if 1 <> Pos( Prefixe, Name)                              then exit;
        Result:= True;
   end;
begin
     Prefixe:= _NomTable+'.';

     slStyles_Cellule_Properties.Clear;

     eAUTOMATIC_STYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     I:= eAUTOMATIC_STYLES.ChildNodes.Count - 1;
     while I >= 0
     do
       begin
       e:= eAUTOMATIC_STYLES.ChildNodes[ I];
       if Supprimer
       then
           Supprime_Item( e);
       Dec( I);
       end;
end;

function TOpenDocument.Named_Range_Cherche( _Nom: String): IXMLNode;
begin
     Result:= Cherche_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                            'table:named-range',
                            ['table:name'],
                            [_Nom        ]);
end;

function TOpenDocument.Named_Range_Assure( _Nom: String): IXMLNode;
begin
     Result:= Ensure_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                           'table:named-range',
                           ['table:name'],
                           [_Nom        ]);
end;

procedure TOpenDocument.Named_Range_Set( _Nom, _Base_Cell, _Cell_Range: String);
var
   e: IXMLNode;
begin
     e:= Named_Range_Assure( _Nom);
     if e = nil then exit;

     Set_Property( e, 'table:base-cell-address' , _Base_Cell );
     Set_Property( e, 'table:cell-range-address', _Cell_Range);
end;

procedure TOpenDocument.Show;
begin
     ShowURL( Nom);
end;

function TOpenDocument.Largeur_Imprimable: double;
var
   ePage_Layout_Properties: IXMLNode;
   sPage_width  : String;
   sMargin_left : String;
   sMargin_right: String;

   dPage_width  : double;
   dMargin_left : double;
   dMargin_right: double;
begin
     Result:= 0;

     ePage_Layout_Properties
     :=
       Elem_from_path( Get_xmlStyles_AUTOMATIC_STYLES, 'style:page-layout/style:page-layout-properties');

     if not_Get_Property( ePage_Layout_Properties, 'fo:page-width'  , sPage_width  ) then exit;
     if not_Get_Property( ePage_Layout_Properties, 'fo:margin-left' , sMargin_left ) then exit;
     if not_Get_Property( ePage_Layout_Properties, 'fo:margin-right', sMargin_right) then exit;

     dPage_width  := double_from_StrCM( sPage_width  ); if dPage_width  = 0 then exit;
     dMargin_left := double_from_StrCM( sMargin_left ); if dMargin_left = 0 then exit;
     dMargin_right:= double_from_StrCM( sMargin_right); if dMargin_right= 0 then exit;

     Result:= dPage_width - dMargin_left - dMargin_right;
end;

function TOpenDocument.FirstHeader: IXMLNode;
begin
     Result
     :=
       Elem_from_path( Get_xmlStyles_MASTER_STYLES, 'style:master-page/style:header');
end;

procedure TOpenDocument.Ensure_style_text_bold;
var
   e: IXMLNode;
begin
     Name_style_text_bold:= 'bold';
     e
     :=
       Add_style_with_text_properties( Name_style_text_bold,
                                       ors_xmlStyles_STYLES,
                                       'text',
                                       '',
                                       '',
                                       True,
                                       0,0,100);
end;

function TOpenDocument.Append_SOFT_PAGE_BREAK( _eRoot: IXMLNode): IXMLNode;
begin
     Result:= Cree_path( _eRoot, 'text:soft-page-break');
end;

procedure TOpenDocument.Is_template_from_extension;
var
   Extension: String;
begin
     Is_template:= False;

     Extension:= UpperCase( ExtractFileExt( Nom));
     if 4 > Length(Extension) then exit;

                                     // .ODT .OTT .ODS .OTS
     Is_template:= 'T'=Extension[3]; // 1234 1234 1234 1234
end;

function TOpenDocument.mimetype_filename: String;
begin
     Result:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+'mimetype';
end;

function TOpenDocument.Getmimetype: String;
begin
     Result:= String_from_File( mimetype_filename);
end;

procedure TOpenDocument.Setmimetype( _mimetype: String);
begin
     String_to_File( mimetype_filename, _mimetype);
end;

procedure TOpenDocument.MIMETYPE_and_MANIFEST_MEDIA_TYPE_from_Is_template;
const
     sTemplate='-template';
var
   sMIMETYPE: String;
   sMIMETYPE_is_template: Boolean;
   procedure Traite_Document;
   begin
        sMIMETYPE:= Delete_suffix( sMIMETYPE, sTemplate);
   end;
   procedure Traite_Template;
   begin
        sMIMETYPE:= sMIMETYPE + sTemplate;
   end;
   procedure Modifie_mimetype;
   begin
        if Is_template
        then
            Traite_Template
        else
            Traite_Document;
   end;
   procedure Enregistre;
   var
      root, e: IXMLNode;
   begin
        //modification fichier mimetype
        mimetype:= sMIMETYPE;

        //modification manifest.xml
        root:= xmlMETA_INF_manifest.DocumentElement;
        e:= Cherche_Item_Recursif( root,
                                   'manifest:file-entry',
                                   ['manifest:full-path'],
                                   ['/']);
       if nil = e then exit;
       uOD_JCL.Set_Property( e, 'manifest:media-type', sMIMETYPE);
   end;
begin
     sMIMETYPE:= mimetype;
     sMIMETYPE_is_template:= String_has_suffix( sMIMETYPE, sTemplate);
     if sMIMETYPE_is_template <> Is_template
     then
         Modifie_mimetype;

     Enregistre;
end;

end.
