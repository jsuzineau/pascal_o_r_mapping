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
    uLog,
    uMimeType,
    uCSS_Style_Parser_PYACC,
    uDimensions_Image,
    uPublieur,
    uOD_Temporaire,
    uOD_Error,
    uOD_JCL,
    uOOoStrings,
    uuStrings,
    uOOoChrono,
    uOOoStringList,
    uOOoDelphiReportEngineLog,

  {$IFDEF MSWINDOWS}Windows,{pour MulDiv}{$ENDIF}
  JclSimpleXml,
  JclStreams,
  SysUtils, Classes, Math, System.Zip, IOUtils,
  httpsend, NetEncoding, StrUtils;

type
 {$IFNDEF FPC}
   TDOMNode= TJclSimpleXMLElem;
   DOMString = String;
 {$ENDIF}

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
    (*function CompareStrings(const S1:String;const S2:String):Integer;override;*)
  end;

 TEnumere_field_Racine_Callback= procedure ( _e: TJclSimpleXMLElem) of object;

 TFields_Visitor= procedure ( _Name, _Value: String) of object;

 { TOpenDocument_Fields_Publieur }

 TOpenDocument_Fields_Publieur
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Owner_Name: String);
    destructor Destroy; override;
  //Owner_Name
  public
    Owner_Name: String;
  //Publieur
  public
    p: TPublieur;
    procedure Abonne   ( _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
    procedure Desabonne( _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
    procedure Publie( _Name, _Value: String);
  //Paramètree
  public
    Name, Value: String;
  end;

 TOpenDocument= class;

 { TStyle_DateTime }

 TStyle_DateTime
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _od: TOpenDocument; _Root: TOD_Root_Styles; _Style_Name: String);
    destructor Destroy; override;
  //Attributs
  public
    od: TOpenDocument;
    Root: TOD_Root_Styles;
    Style_Name: String;
  //Formatage
  protected
    function Find_Style: TDOMNode; virtual; abstract;
  protected
    Format_e: TDOMNode; //non réentrant/multithread
    Format_Result: String; //non réentrant/multithread
    function number_style_SHORT_from_(_e: TDOMNode): Boolean;
    function number_textual_from_(_e: TDOMNode): Boolean;
    function Format_from_number_style(_e: TDOMNode; _Short, _Long: String): String;
    procedure Add_Format(_Short, _Long: String);
    procedure Add_Format_textual(_Short, _Long, _Textual_Short, _Textual_Long: String);
    procedure Add_Text;
    procedure Traite_Node; virtual; abstract;
  public
    function Format: String; //non réentrant/multithread
  end;

 TStyle_DateTime_class= class of TStyle_DateTime;

 { TStyle_Date }

 TStyle_Date
 =
  class( TStyle_DateTime)
  //Formatage
  protected
   function Find_Style: TDOMNode; override;
   procedure Traite_Node; override;
  end;

 { TStyle_Time }

 TStyle_Time
 =
  class( TStyle_DateTime)
  //Formatage
  protected
   function Find_Style: TDOMNode; override;
   procedure Traite_Node; override;
  end;


 TOD_TAB = class;
 TOD_SPAN= class;
 TOD_PARAGRAPH_PROPERTIES=class;
 TOD_TEXT_PROPERTIES=class;

 { TOD_XML_Element }

 TOD_XML_Element
 =
  class
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); virtual;
    destructor Destroy; override;
  //Attributs
  public
    D: TOpenDocument;
    eRoot: TDOMNode;
    e: TDOMNode;
  //Méthodes
  public
    function  not_Get_Property( _NodeName: String; out _Value: String): Boolean;
    procedure     Set_Property( _NodeName,             _Value: String);
    procedure  Delete_Property( _Fullname: String);
  //Text
  private
    function  GetText: DOMString;
    procedure SetText( _Value: DOMString);
  public
    property Text: DOMString read GetText write SetText;
  //Insertion de texte
  public
    procedure AddText ( _Value: String;
                        _NomStyle: String= '';
                        _Gras: Boolean = False;
                        _DeltaSize: Integer= 0;
                        _Size: Integer= 0;
                        _SizePourcent: Integer= 100);
    procedure AddText_with_span(  _Value: String;
                                  _NomStyle: String= '';
                                  _Gras: Boolean = False;
                                  _DeltaSize: Integer= 0;
                                  _Size: Integer= 0;
                                  _SizePourcent: Integer= 100);
    procedure Add_Line_Break;
    function AddTab: TOD_TAB;
    function AddSpan: TOD_SPAN;
  //Style automatique
  protected
    FStyle_Automatique: TDOMNode;
    NomStyleApplique: String;
    function Nom_Style_automatique( _NomStyle: String; _Gras: Boolean = False;
                                    _DeltaSize: Integer= 0; _Size: Integer= 0;
                                    _SizePourcent: Integer= 100): String; virtual;
    function GetStyle_Automatique( _NomStyleColonne: String): TDOMNode;
  public
    Is_Header: boolean;
    property Style_Automatique[ _NomStyleColonne: String]: TDOMNode read GetStyle_Automatique;
    procedure Applique_Style( _NomStyle: String);
    procedure Set_Style( _NomStyle: String; _Gras: Boolean = False;
                         _DeltaSize: Integer= 0; _Size: Integer= 0;
                         _SizePourcent: Integer= 100);
  // PARAGRAPH_PROPERTIES
  public
    FPARAGRAPH_PROPERTIES: TOD_PARAGRAPH_PROPERTIES;
    function GetPARAGRAPH_PROPERTIES( _NomStyleColonne: String): TOD_PARAGRAPH_PROPERTIES;
    property PARAGRAPH_PROPERTIES[ _NomStyleColonne: String]: TOD_PARAGRAPH_PROPERTIES read GetPARAGRAPH_PROPERTIES;
  // TOD_TEXT_PROPERTIES
  public
    FTEXT_PROPERTIES: TOD_TEXT_PROPERTIES;
    function GetTEXT_PROPERTIES( _NomStyleColonne: String): TOD_TEXT_PROPERTIES;
    property TEXT_PROPERTIES[ _NomStyleColonne: String]: TOD_TEXT_PROPERTIES read GetTEXT_PROPERTIES;
  end;

 TOD_Style_Alignment
 =
  (
  osa_Left  ,
  osa_Center,
  osa_Right
  );
 TOD_Styles
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Styles: String);
    destructor Destroy; override;
  //Attributs
  public
    Styles: array of String;
    Alignments: array of TOD_Style_Alignment;
  //Initialisation
  public
    procedure Init( _Styles: String);
  end;

 TOD_TAB_STOP
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    procedure SetPositionCM( _PositionCM: double);
    procedure SetStyle( _A: TOD_Style_Alignment);
  end;

 TOD_TAB_STOPS
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    function Cree_TAB_STOP( _A: TOD_Style_Alignment): TOD_TAB_STOP;
  end;

 TOD_TEXT_PROPERTIES
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  end;

 TOD_PARAGRAPH_PROPERTIES
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    function TAB_STOPS: TOD_TAB_STOPS;
  end;

 TOD_SPAN
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Style automatique
  protected
    function Nom_Style_automatique( _NomStyle: String; _Gras: Boolean = False;
                                    _DeltaSize: Integer= 0; _Size: Integer= 0;
                                    _SizePourcent: Integer= 100): String; override;
  end;

 { TOD_LIST }

 TOD_LIST
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Style
  public
    Style: String;
    function Cree_Style: String;
  end;

 { TOD_LIST_ITEM }

 TOD_LIST_ITEM
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  end;

 TOD_TAB
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  end;

 TOD_IMAGE
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    procedure Set_xlink_href( _xlink_href: String);
  end;

 TOD_FRAME
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    function NewImage_as_Character( _Filename: String): TOD_IMAGE;
  end;

 TOD_TABLE
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Nom
  private
    function  GetNom: String;
    procedure SetNom( _Value: String);
  public
    property Nom: String read getNom write SetNom;
  end;

 { TOD_PARAGRAPH }

 TOD_PARAGRAPH
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Méthodes
  public
    function NewFrame: TOD_FRAME;
    function NewTable: TOD_TABLE;
  //Style automatique
  protected
    function Nom_Style_automatique( _NomStyle: String; _Gras: Boolean = False;
                                    _DeltaSize: Integer= 0; _Size: Integer= 0;
                                    _SizePourcent: Integer= 100): String; override;
  end;

 TOD_SOFT_PAGE_BREAK
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  end;

 { TOpenDocument_Element }

 TOpenDocument_Element
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom_relatif: String);
    destructor Destroy; override;
  //Attributs
  public
    Nom_relatif: String;
    xml: {$IFDEF FPC}TXMLDocument{$ELSE}TJclSimpleXml{$ENDIF};
    NomFichier: String;
  //méthodes
  public
    procedure XML_from_Repertoire_Extraction( _Repertoire_Extraction: String);
    procedure Repertoire_Extraction_from_XML( _Repertoire_Extraction: String);
  end;

 { TOpenDocument }

 TOpenDocument
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    constructor Create_from_template( _Template_Filename: String);
    destructor Destroy; override;
  //initialisation
  private
    procedure Init( _Nom: String);
  //Extraction
  public
    Repertoire_Extraction: String;
  //Repertoire_Pictures
  private
    FRepertoire_Pictures: String;
  public
    function Repertoire_Pictures: String;
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
    //F: TJclZipUpdateArchive;
    function Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    function Find_style_family_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles; _family: String): TJclSimpleXMLElem;
    function Find_style_text( _NomStyle: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    function Find_style_text_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
  public

    odeMeta             : TOpenDocument_Element;
    odeSettings         : TOpenDocument_Element;
    odeMETA_INF_manifest: TOpenDocument_Element;
    odeContent          : TOpenDocument_Element;
    odeStyles           : TOpenDocument_Element;
    function CheminFichier_temporaire( _NomFichier: String): String;
  //Méthodes d'accés au XML
  private
    Get_xmlContent_USER_FIELD_DECLS_Premier: Boolean;
  public
    //Text
    function Get_xmlContent_TEXT: TJclSimpleXMLElem;
    function Get_xmlContent_USER_FIELD_DECLS: TJclSimpleXMLElem;
    function Get_xmlContent_AUTOMATIC_STYLES: TJclSimpleXMLElem;

    function Get_xmlStyles_STYLES: TJclSimpleXMLElem;
    function Get_xmlStyles_AUTOMATIC_STYLES: TJclSimpleXMLElem;
    function Get_xmlStyles_MASTER_STYLES: TJclSimpleXMLElem;

    function Get_STYLES( _Root: TOD_Root_Styles): TJclSimpleXMLElem;

    //Spreadsheet
    function Get_xmlContent_SPREADSHEET: TJclSimpleXMLElem;
    function Get_xmlContent_SPREADSHEET_first_TABLE: TJclSimpleXMLElem;
    function Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: TJclSimpleXMLElem;
  //Gestion des properties //deprecated -> uOD_JCL
  private
    function Get_Property_Name( _e: TDOMNode; _NodeName: String): String; //deprecated -> uOD_JCL
  public
    function not_Get_Property( _e: TJclSimpleXMLElem;    //deprecated -> uOD_JCL
                               _FullName: String;
                               out _Value: String): Boolean;
    function not_Test_Property( _e: TJclSimpleXMLElem;   //deprecated -> uOD_JCL
                                _FullName: String;
                                _Values: array of String): Boolean;
    procedure Set_Property( _e: TJclSimpleXMLElem;       //deprecated -> uOD_JCL
                            _Fullname, _Value: String);
    procedure Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);
  //Gestion des items //deprecated -> uOD_JCL
  public
    function Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String; //deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TJclSimpleXMLElem;
    function Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem; //deprecated -> uOD_JCL
                                    _FullName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): TJclSimpleXMLElem;
    function Ensure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TJclSimpleXMLElem;
    function Add_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TJclSimpleXMLElem;
    procedure Supprime_Item( _e: TJclSimpleXMLElem);//deprecated -> uOD_JCL
    procedure Copie_Item( _Source, _Cible: TJclSimpleXMLElem);//deprecated -> uOD_JCL
  //Gestion des noms de cellules (tableur)
  public
    function  Named_Range_Cherche( _Nom: String): TJclSimpleXMLElem;
    function  Named_Range_Assure ( _Nom: String): TJclSimpleXMLElem;
    procedure Named_Range_Set    ( _Nom, _Base_Cell, _Cell_Range: String);
  //Méthodes créées pour compatibilité OOo
  private
    function Cherche_field( _Name: String): TJclSimpleXMLElem;
    function Find_style_family( _NomStyle: String;
                                _Root: TOD_Root_Styles;
                                _family: String): TJclSimpleXMLElem;
  public
    procedure Enumere_field_Racine( _Racine_Name: String; _CallBack: TEnumere_field_Racine_Callback);
    function Find_style_paragraph( _NomStyle: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    function Find_style_paragraph_multiroot( _NomStyle: String;
                                     _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    function Contient_Style_Enfant( _eRoot: TJclSimpleXMLElem;
                                    _NomStyleParent: String): Boolean;
    function Utilise_Style( _eRoot: TJclSimpleXMLElem;
                            _NomStyle: String): Boolean;
    function Style_NameFromDisplayName( _DisplayName: String): String;
    function Style_DisplayNameFromName( _Name: String): String;
    procedure Efface_Styles_Table( _NomTable: String);
  //Méthodes créées pour OpenDocument_DelphiReportEngine.exe
  public
    procedure Fields_Visite( _fv: TFields_Visitor);
    procedure Set_Field( _Name, _Value: String);
    function Field_Assure( _Name: String): TDOMNode;
    function Field_Value( _Name: String): String;
    procedure Add_FieldGet( _Name: String);

    procedure Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
    procedure Duplique_Style_Colonne( _NomStyle_Source, _NomStyle_Cible: String);

    function Font_size_from_Style( _NomStyle: String): Integer;
  //Styles de liste
  private
    Automatic_list_style_number: Integer;
    procedure Add_List_level_label_alignment( _eList_level_properties: TDOMNode; _left: String);
    procedure Add_list_level_properties( _eList_level_style_bullet: TDOMNode; _left: String);
    procedure Add_list_level_style_bullet( _eListStyle: TDOMNode; _level, _left, _bullet_char: String);
    function  Add_list_style( _NomStyle: String;
                              _Root: TOD_Root_Styles): TDOMNode;
    function  Add_automatic_list_style( out _eStyle: TDOMNode; _Is_Header: Boolean= False): String; overload;
    function  Add_automatic_list_style( _Is_Header: Boolean= False): String; overload;
  //Styles
  private
    function  Add_style( _NomStyle, _NomStyleParent: String;
                         _Root: TOD_Root_Styles;
                         _family, _class: String): TJclSimpleXMLElem;
    function  Add_style_with_text_properties( _NomStyle: String;
                                              _Root: TOD_Root_Styles;
                                              _family,
                                              _class: String;
                                              _NomStyleParent: String;
                                              _Gras: Boolean;
                                              _DeltaSize: Integer;
                                              _Size: Integer;
                                              _SizePourcent: Integer): TJclSimpleXMLElem;
    function  Add_automatic_style( _NomStyleParent: String;
                                   _Gras: Boolean;
                                   _DeltaSize: Integer;
                                   _Size: Integer;
                                   _SizePourcent: Integer;
                                   out _eStyle: TJclSimpleXMLElem;
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
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    function  Ensure_style_paragraph( _NomStyle, _NomStyleParent: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
    procedure Rename_style_paragraph( _NomStyle_Avant, _NomStyle_Apres: String;
                                      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES);
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        _Page_break_before: Boolean= False): String; overload;
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        out _eStyle: TJclSimpleXMLElem;
                                        _Is_Header: Boolean;
                                        _Page_break_before: Boolean= False): String; overload;
  //Styles de caractères automatiques
  private
    Automatic_style_text_number: Integer;
  public
    function  Add_style_text( _NomStyle, _NomStyleParent: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
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
                                        out _eStyle: TJclSimpleXMLElem;
                                        _Is_Header: Boolean): String; overload;
  //Styles de cellule automatique
  private
    slStyles_Cellule_Properties: TODStringList;
  public
    function  Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TJclSimpleXMLElem;
    function  Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TJclSimpleXMLElem;
    function  Ensure_automatic_style_table_cell_properties( _NomTable: String; _X, _Y: Integer): TJclSimpleXMLElem;
  //Changer le style parent d'un style donné
  public
    procedure Change_style_parent( _NomStyle, _NomStyleParent: String);
  //Styles de date
  public
    function Find_date_style( _NomStyle: String;_Root: TOD_Root_Styles): TDOMNode;
  //Styles de Time
  public
    function Find_Time_style( _NomStyle: String;_Root: TOD_Root_Styles): TDOMNode;
  //Général
  private
    function Text_Traite_Field( FieldName, FieldContent: String;
                                CreeTextFields: Boolean): Boolean;
  public
    function Traite_Field( FieldName, FieldContent: String;
                           CreeTextFields: Boolean): Boolean;
  //Suppression des valeurs pour toute une sous-branche
  private
    procedure Field_Vide_Branche_CallBack( _e: TJclSimpleXMLElem);
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
    procedure Try_Delete_Style( _eStyle: TJclSimpleXMLElem);
  public
    procedure Delete_unused_styles;
  //Propriétés de table
  public
    function Get_Table_Properties( _NomTable: String): TJclSimpleXMLElem;
    function Get_Table_Width     ( _NomTable: String): String;
  //Propriétés de cellule
  private
    Cell_Style: String;
  public
    procedure SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
    procedure Apply_Cell_Style( e: TJclSimpleXMLElem);
  //Affichage
  public
    procedure Show;
  //ajout d'espaces
  public
    procedure AddSpace( _e: TJclSimpleXMLElem; _c: Integer);
  //Ajout de texte
  public
    procedure AddText_( _e: TJclSimpleXMLElem; _Value: String; _Gras: Boolean= False); overload;
    procedure AddText_(                        _Value: String; _Gras: Boolean= False); overload;
    function Append_SOFT_PAGE_BREAK( _eRoot: TJclSimpleXMLElem): TJclSimpleXMLElem;
  //Ajout de HTML
  public
    procedure AddHtml( _e: TDOMNode; _Value: String; _Gras: Boolean= False); overload;
    procedure AddHtml(_Value: String; _Gras: Boolean= False); overload;
  //Largeur_imprimable
  public
    function Largeur_Imprimable: double;
  //Entete
  public
    function FirstHeader: TJclSimpleXMLElem;
  //Style caractères gras
  public
    Name_style_text_bold: String;
    procedure Ensure_style_text_bold;
  //Embed_Image
  private
    slEmbed_Image: TslDimensions_Image;
    Embed_Image_counter: Cardinal;
    Embed_Image_counter_New_name: String;
    procedure Manifeste(_FullPath, _Extension: String);
    function Embed_Image_New_name_exists: Boolean;
    function Embed_Image_New: String;
  public
    function Embed_Image( _NomFichier: String): TDimensions_Image;
  //Publication des modifications
  public
    pChange: TPublieur;
    pFields_Change: TOpenDocument_Fields_Publieur;
    pFields_Delete: TOpenDocument_Fields_Publieur;
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
function Cree_table( _e: TJclSimpleXMLElem; _Nom: String):TJclSimpleXMLElem;

function CellName_from_XY( X, Y: Integer): String;
procedure XY_from_CellName( CellName: String; var X, Y: Integer);

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;

function Root_Styles_from_Is_Header( _Is_Header: Boolean): TOD_Root_Styles;

implementation

function Root_Styles_from_Is_Header( _Is_Header: Boolean): TOD_Root_Styles;
begin
     if _Is_Header
     then
         Result:= ors_xmlStyles_AUTOMATIC_STYLES
     else
         Result:= ors_xmlContent_AUTOMATIC_STYLES;
end;


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

function Cree_table( _e: TJclSimpleXMLElem; _Nom: String):TJclSimpleXMLElem;
begin
     //Result:= Cree_path( _e, 'text:p/table:table');
     Result:= Cree_path( _e, 'table:table');
     if Result = nil then exit;

     Result.Properties.Add( 'table:name', _Nom);
     Cree_path( Result, 'table:table-header-rows/table:table-row/table:table-cell');
     Cree_path( Result,                         'table:table-row/table:table-cell');

end;

{ TOpenDocument_Element }

constructor TOpenDocument_Element.Create(_Nom_relatif: String);
begin
     Nom_relatif:= _Nom_relatif;
     xml:= nil;
end;

destructor TOpenDocument_Element.Destroy;
begin
     FreeAndNil( xml);
     inherited Destroy;
end;

procedure TOpenDocument_Element.XML_from_Repertoire_Extraction( _Repertoire_Extraction: String);
{$IFDEF FPC}
begin
     NomFichier:= _Repertoire_Extraction+Nom_relatif;
     FreeAndNil( xml);
     ReadXMLFile( xml, NomFichier);
     (*_xml.IndentString:= '  ';
     with _xml do Options:= Options + [sxoAutoEncodeValue];*)

     OOoChrono.Stop( 'Chargement en objet du fichier xml '+Nom_relatif);
end;
{$ELSE}
//var
//   Stream: TStream;
begin
     xml:= TJclSimpleXml.Create;
     xml.IndentString:= '  ';

     with xml do Options:= Options + [sxoAutoEncodeValue];

     //Stream:= ci.Stream;
     //xml.LoadFromStream( Stream);
     NomFichier:= _Repertoire_Extraction+Nom_relatif;
     xml.LoadFromFile( NomFichier, seUTF8);

     OOoChrono.Stop( 'Chargement en objet du fichier xml '+Nom_relatif);
end;
{$ENDIF}

procedure TOpenDocument_Element.Repertoire_Extraction_from_XML( _Repertoire_Extraction: String);
begin
     NomFichier:= _Repertoire_Extraction+Nom_relatif;
     {$IFDEF FPC}
     WriteXMLFile( xml, NomFichier);
     {$ELSE}
     xml.SaveToFile( NomFichier, seUTF8);
     {$ENDIF}
end;

{ TOpenDocument_Fields_Publieur }

constructor TOpenDocument_Fields_Publieur.Create(_Owner_Name: String);
begin
     Owner_Name:= _Owner_Name;
     p:= TPublieur.Create( Owner_Name+'::'+ClassName+'.p');
end;

destructor TOpenDocument_Fields_Publieur.Destroy;
begin
     FreeAndNil( p);
     inherited Destroy;
end;

procedure TOpenDocument_Fields_Publieur.Abonne( _Objet: TObject;
                                                _Proc: TAbonnement_Objet_Proc);
begin
     p.Abonne( _Objet, _Proc);
end;

procedure TOpenDocument_Fields_Publieur.Desabonne( _Objet: TObject;
                                                   _Proc: TAbonnement_Objet_Proc);
begin
     p.Desabonne( _Objet, _Proc);
end;

procedure TOpenDocument_Fields_Publieur.Publie( _Name, _Value: String);
begin
     Name := _Name ;
     Value:= _Value;
     p.Publie;
end;

{ TStyle_DateTime }

constructor TStyle_DateTime.Create(_od: TOpenDocument; _Root: TOD_Root_Styles; _Style_Name: String);
begin
     inherited Create;
     od        := _od        ;
     Root      := _Root      ;
     Style_Name:= _Style_Name;
end;

destructor TStyle_DateTime.Destroy;
begin
     inherited Destroy;
end;

function TStyle_DateTime.number_style_SHORT_from_( _e: TDOMNode): Boolean;
var
   sNUMBER_STYLE: String;
begin
     Result:= True;
     if not_Get_Property( _e, 'number:style', sNUMBER_STYLE) then exit;

     Result:= 'short' = sNUMBER_STYLE;
end;

function TStyle_DateTime.number_textual_from_( _e: TDOMNode): Boolean;
var
   sNUMBER_TEXTUAL: String;
begin
     Result:= False;
     if not_Get_Property( _e, 'number:textual', sNUMBER_TEXTUAL) then exit;

     Result:= 'true' = sNUMBER_TEXTUAL;
end;

function TStyle_DateTime.Format_from_number_style( _e: TDOMNode; _Short, _Long: String): String;
var
   IsShort: Boolean;
begin
     IsShort:= number_style_SHORT_from_( _e);
     if IsShort
     then
         Result:= _Short
     else
         Result:= _Long;
end;

procedure TStyle_DateTime.Add_Format( _Short, _Long: String);
begin
     Format_Result:= Format_Result+ Format_from_number_style( Format_e, _Short, _Long);
end;

procedure TStyle_DateTime.Add_Format_textual( _Short, _Long, _Textual_Short, _Textual_Long: String);
var
   IsTextual: Boolean;
begin
     IsTextual:= number_textual_from_( Format_e);
     if IsTextual
     then
         Add_Format( _Textual_Short, _Textual_Long)
     else
         Add_Format( _Short, _Long);
end;

procedure TStyle_DateTime.Add_Text;
var
   Text: String;
begin
     Text:= Text_from_path( Format_e,'');
     if '' = Text then Text:= ' ';
     Format_Result:= Format_Result+ '"'+Text+'"';
end;

function TStyle_DateTime.Format: String;
var
   eStyle: TDOMNode;
   I: Integer;
begin
     Result:= '';
     Format_Result:= '';

     eStyle:= Find_Style;
     if nil = eStyle then exit;

     for I:= 0 to eStyle.Items.Count-1
     do
       begin
       Format_e:= eStyle.Items.Item[ I];
       if nil = Format_e then continue;

       Traite_Node;
       end;

     Result:= Format_Result;
end;

{ TStyle_Date }

function TStyle_Date.Find_Style: TDOMNode;
begin
     Result:= od.Find_date_style( Style_Name, Root);
     if Assigned( Result) or (Root = ors_xmlStyles_AUTOMATIC_STYLES) then exit;

     Result:= od.Find_date_style( Style_Name, ors_xmlStyles_AUTOMATIC_STYLES);
end;

procedure TStyle_Date.Traite_Node;
var
   NodeName: DOMString;
begin
     NodeName:= Format_e.FullName;
          if NodeName =  'number:day'         then Add_Format        ( 'd'  , 'dd'  )
     else if NodeName =  'number:day-of-week' then Add_Format        ( 'ddd', 'dddd')
     else if NodeName =  'number:month'       then Add_Format_textual( 'm'  , 'mm'  , 'mmm', 'mmmm')
     else if NodeName =  'number:year'        then Add_Format        ( 'yy' , 'yyyy')
     else if NodeName =  'number:text'        then Add_Text;
end;

{ TStyle_Time }

function TStyle_Time.Find_Style: TDOMNode;
begin
     Result:= od.Find_Time_style( Style_Name, Root);
     if Assigned( Result) or (Root = ors_xmlStyles_AUTOMATIC_STYLES) then exit;

     Result:= od.Find_Time_style( Style_Name, ors_xmlStyles_AUTOMATIC_STYLES);
end;

procedure TStyle_Time.Traite_Node;
var
   NodeName: DOMString;
begin
     NodeName:= Format_e.FullName;
          if NodeName =  'number:hours'       then Add_Format( 'h', 'hh')
     else if NodeName =  'number:minutes'     then Add_Format( 'n', 'nn')
     else if NodeName =  'number:seconds'     then Add_Format( 's', 'ss')
     else if NodeName =  'number:am-pm'       then Add_Format( 'am/pm', 'am/pm')
     else if NodeName =  'number:text'        then Add_Text;
end;

{ TODStringList }

(*function TODStringList.CompareStrings(const S1, S2: String): Integer;
begin
     Result:= CompareStr( S1, S2);
end;*)

{ TOD_Styles }

constructor TOD_Styles.Create( _Styles: String);
begin
     inherited Create;
     Init( _Styles);
end;

destructor TOD_Styles.Destroy;
begin

     inherited;
end;

procedure TOD_Styles.Init( _Styles: String);
begin
     SetLength( Styles, 0);
     while Length( _Styles) > 0
     do
       begin
       SetLength( Styles, Length( Styles)+1);
       Styles[ High( Styles)]:= Trim( StrTok( ',', _Styles));
       end;
     SetLength( Alignments, Length( Styles));
end;

{ TOD_TAB_STOP }

constructor TOD_TAB_STOP.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'style:tab-stop');
end;

procedure TOD_TAB_STOP.SetPositionCM(_PositionCM: double);
var
   sPositionCM: String;
begin
     sPositionCM:= StrCM_from_double( _PositionCM);
     Set_Property( 'style:position', sPositionCM);
end;

procedure TOD_TAB_STOP.SetStyle(_A: TOD_Style_Alignment);
begin
     case _A
     of
       osa_Left  : Delete_Property( 'style:type');
       osa_Center:    Set_Property( 'style:type', 'center');
       osa_Right :    Set_Property( 'style:type', 'right' );
       else        Delete_Property( 'style:type');
       end;
end;

{ TOD_TAB_STOPS }

constructor TOD_TAB_STOPS.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Assure_path( eRoot, 'style:tab-stops');
end;

function TOD_TAB_STOPS.Cree_TAB_STOP( _A: TOD_Style_Alignment): TOD_TAB_STOP;
begin
     Result:= TOD_TAB_STOP.Create( D, e);
     Result.SetStyle( _A);
end;

{ TOD_TEXT_PROPERTIES }

constructor TOD_TEXT_PROPERTIES.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Assure_path( eRoot, 'style:text-properties');
end;


{ TOD_PARAGRAPH_PROPERTIES }

constructor TOD_PARAGRAPH_PROPERTIES.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Assure_path( eRoot, 'style:paragraph-properties');
end;

function TOD_PARAGRAPH_PROPERTIES.TAB_STOPS: TOD_TAB_STOPS;
begin
     Result:= TOD_TAB_STOPS.Create( D, e);
end;

{ TOD_XML_Element }

constructor TOD_XML_Element.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     D:= _D;
     eRoot:= _eRoot;

     FStyle_Automatique:= nil;
     FPARAGRAPH_PROPERTIES:= nil;
     Is_Header:= False;
     NomStyleApplique:= '';
end;

destructor TOD_XML_Element.Destroy;
begin

     inherited;
end;

function TOD_XML_Element.GetText: DOMString;
begin
     Result:= e.Value;
end;

procedure TOD_XML_Element.SetText( _Value: DOMString);
begin
     e.Value:= _Value;
end;

function TOD_XML_Element.not_Get_Property( _NodeName: String; out _Value: String): Boolean;
begin
     Result:= uOD_JCL.not_Get_Property( e, _NodeName, _Value);
end;

procedure TOD_XML_Element.Set_Property( _NodeName, _Value: String);
begin
     uOD_JCL.Set_Property( e, _NodeName, _Value);
end;

procedure TOD_XML_Element.Delete_Property(_Fullname: String);
begin
     uOD_JCL.Delete_Property( e, _Fullname);
end;

procedure TOD_XML_Element.AddText_with_span(_Value: String; _NomStyle: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer);
var
   span: TOD_SPAN;
begin
     span:= AddSpan;
     span.Set_Style( _NomStyle, _Gras, _DeltaSize, _Size, _SizePourcent);
     span.AddText( _Value);
     FreeAndNil( span);
end;

procedure TOD_XML_Element.AddText( _Value: String;
                                   _NomStyle: String= '';
                                   _Gras: Boolean = False;
                                   _DeltaSize: Integer= 0;
                                   _Size: Integer= 0;
                                   _SizePourcent: Integer= 100);
begin
     if Trim( _Value) = '' then exit;

     if    (_DeltaSize <> 0) or (_Size <> 0)
        or (
              (_SizePourcent <>   0)
           and(_SizePourcent <> 100)
           )
     then
         AddText_with_span(_Value,_NomStyle,_Gras,_DeltaSize,_Size,_SizePourcent)
     else
         D.AddHtml( e, _Value, _Gras);
end;

procedure TOD_XML_Element.Add_Line_Break;
begin
     Cree_path( e, 'text:line-break');
end;

function TOD_XML_Element.AddTab: TOD_TAB;
begin
     Result:= TOD_TAB.Create( D, e);
end;

function TOD_XML_Element.AddSpan: TOD_SPAN;
begin
     Result:= TOD_SPAN.Create( D, e);
end;

function TOD_XML_Element.Nom_Style_automatique(_NomStyle: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer
 ): String;
begin
     Result:= D.Add_automatic_style_text( _NomStyle,
                                      _Gras,
                                      _DeltaSize,
                                      _Size,
                                      _SizePourcent,
                                      FStyle_Automatique,
                                      Is_Header
                                      );
end;

procedure TOD_XML_Element.Applique_Style( _NomStyle: String);
var
   Style_Name: String;
begin
     NomStyleApplique:= _NomStyle;
     Style_Name:= D.Style_NameFromDisplayName( NomStyleApplique);

     Set_Property( 'text:style-name', Style_Name);
end;

procedure TOD_XML_Element.Set_Style( _NomStyle: String; _Gras: Boolean = False;
                                   _DeltaSize: Integer= 0; _Size: Integer= 0; _SizePourcent: Integer= 100);
var
   NomStyleApplique: String;
begin
     if    _Gras or (_DeltaSize <> 0) or (_Size <> 0)
        or (
              (_SizePourcent <>   0)
           and(_SizePourcent <> 100)
           )
     then
         NomStyleApplique:= Nom_Style_automatique( _NomStyle, _Gras, _DeltaSize, _Size, _SizePourcent)
     else
         NomStyleApplique:= _NomStyle;

     Applique_Style( NomStyleApplique);
end;

function TOD_XML_Element.GetStyle_Automatique( _NomStyleColonne: String): TDOMNode;
   procedure Cree;
   var
      NomStyleApplique: String;
      NomStyleParent: String;
   begin
        if Is_Header
        then
            NomStyleParent:= 'Table_20_Heading'
        else
            NomStyleParent:= _NomStyleColonne;
        NomStyleApplique:= Nom_Style_automatique( NomStyleParent);
        Applique_Style( NomStyleApplique);
   end;
begin
     if nil = FStyle_Automatique
     then
         Cree;
     Result:= FStyle_Automatique;
end;

function TOD_XML_Element.GetTEXT_PROPERTIES( _NomStyleColonne: String): TOD_TEXT_PROPERTIES;
begin
     if nil = FTEXT_PROPERTIES
     then
         FTEXT_PROPERTIES:= TOD_TEXT_PROPERTIES.Create( D, Style_Automatique[ _NomStyleColonne]);

     Result:= FTEXT_PROPERTIES;
end;

function TOD_XML_Element.GetPARAGRAPH_PROPERTIES( _NomStyleColonne: String): TOD_PARAGRAPH_PROPERTIES;
begin
     if nil = FPARAGRAPH_PROPERTIES
     then
         FPARAGRAPH_PROPERTIES:= TOD_PARAGRAPH_PROPERTIES.Create( D, Style_Automatique[ _NomStyleColonne]);

     Result:= FPARAGRAPH_PROPERTIES;
end;

{ TOD_SPAN }

constructor TOD_SPAN.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:span');
end;

function TOD_SPAN.Nom_Style_automatique( _NomStyle: String;
                                         _Gras: Boolean;
                                         _DeltaSize,
                                         _Size,
                                         _SizePourcent: Integer): String;
begin
     if      _Gras
        and (_DeltaSize = 0)
        and (_Size = 0)
        and ((_SizePourcent=100) or (_SizePourcent=0))
     then
         Result:= D.Name_style_text_bold
     else
         Result:= D.Add_automatic_style_text( _NomStyle,
                                          _Gras,
                                          _DeltaSize,
                                          _Size,
                                          _SizePourcent,
                                          FStyle_Automatique,
                                          Is_Header
                                          );
end;

{ TOD_LIST }

constructor TOD_LIST.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:list');
     Style:= '';
end;

function TOD_LIST.Cree_Style: String;
begin
     Style:= D.Add_automatic_list_style( Is_Header);
     D.Set_Property( e, 'text:style-name', Style);
     Result:= Style;
end;

{ TOD_LIST_ITEM }

constructor TOD_LIST_ITEM.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:list-item');
end;

{ TOD_TAB }

constructor TOD_TAB.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:tab');
end;

{ TOD_IMAGE }

constructor TOD_IMAGE.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'draw:image');

end;

procedure TOD_IMAGE.Set_xlink_href( _xlink_href: String);
begin
     D.Set_Property( e, 'xlink:href'      , _xlink_href                );
     D.Set_Property( e, 'xlink:type'      , 'simple'                  );
     D.Set_Property( e, 'xlink:show'      , 'embed'                   );
     D.Set_Property( e, 'xlink:actuate'   , 'onLoad'                  );
     D.Set_Property( e, 'draw:filter-name', '&lt;Tous les formats&gt;');// localisé?
end;

{ TOD_FRAME }

constructor TOD_FRAME.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'draw:frame');
end;

function TOD_FRAME.NewImage_as_Character( _Filename: String): TOD_IMAGE;
var
   dfp: TDimensions_Image;
   svgWidth, svgHeight: String;
begin
     Result:= TOD_IMAGE.Create( D, e);
     D.Set_Property( e, 'text:anchor-type', 'as-char');

     dfp:= D.Embed_Image( _Filename);
     if nil = dfp then exit;

     try
        svgWidth := dfp.svgWidth ;
        svgHeight:= dfp.svgHeight;
        if '' <> svgWidth  then D.Set_Property( e, 'svg:width' , svgWidth );
        if '' <> svgHeight then D.Set_Property( e, 'svg:height', svgHeight);
        Result.Set_xlink_href( dfp.URL);
     finally
            FreeAndNil( dfp);
            end;
end;

{ TOD_TABLE }

constructor TOD_TABLE.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'table:table');
     Cree_path( e, 'table:table-header-rows/table:table-row/table:table-cell');
     Cree_path( e,                         'table:table-row/table:table-cell');
end;

function TOD_TABLE.GetNom: String;
begin
     if D.not_Get_Property( e, 'table:name', Result)
     then
         Result:= '';

end;

procedure TOD_TABLE.SetNom( _Value: String);
begin
     D.Set_Property( e, 'table:name', _Value);
end;

{ TOD_PARAGRAPH }

constructor TOD_PARAGRAPH.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:p');
end;

function TOD_PARAGRAPH.NewFrame: TOD_FRAME;
begin
     Result:= TOD_FRAME.Create( D, e);
end;

function TOD_PARAGRAPH.NewTable: TOD_TABLE;
begin
     Result:= TOD_TABLE.Create( D, e);
end;

function TOD_PARAGRAPH.Nom_Style_automatique( _NomStyle: String;
                                              _Gras: Boolean;
                                              _DeltaSize: Integer;
                                              _Size: Integer;
                                              _SizePourcent: Integer): String;
begin
     Result:= D.Add_automatic_style_paragraph( _NomStyle,
                                               _Gras,
                                               _DeltaSize,
                                               _Size,
                                               _SizePourcent,
                                               FStyle_Automatique,
                                               Is_Header
                                               );
end;

{ TOD_SOFT_PAGE_BREAK }

constructor TOD_SOFT_PAGE_BREAK.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'text:soft-page-break');
end;

{ TOpenDocument }

constructor TOpenDocument.Create( _Nom: String);
begin
     Init( _Nom);
end;

procedure MyCopyFile( _Source, _Cible: String);
var
   FSource, FCible: File;
   Buffer: array[1..4096] of byte;
   read, written: Integer;
begin
     AssignFile( FSource, _Source);
     try
        Reset(FSource, 1);
        AssignFile( FCible, _Cible);
        try
           Rewrite( FCible, 1);
           repeat
                 BlockRead ( FSource, Buffer, SizeOf( Buffer), read);
                 BlockWrite( FCible , Buffer, read           , written);
           until (read = 0) or (written <> read);
        finally
               CloseFile( FCible);
               end;
     finally
            CloseFile( FSource);
            end;
end;

//procedure XCopy( _Source, _Cible: String);
//begin
//     ExecuteProcess( 'cmd.exe',['/C','xcopy',_Source, _Cible]);
//end;

var temp: Integer= 0;
constructor TOpenDocument.Create_from_template(_Template_Filename: String);
var
   Prefixe: String;
begin
     Prefixe:= ChangeFileExt( ExtractFileName(_Template_Filename), '');
     //Nom:= OD_Temporaire.Nouveau_ODT( Prefixe);
     //Nom:= IncludeTrailingPathDelimiter(OD_Temporaire.RepertoireTemp)+'temp_'+IntToStr(temp)+'.odt';
     //Nom:= IncludeTrailingPathDelimiter(GetTempDir)+'temp_'+IntToStr(temp)+'.odt';
     Nom:= 'temp_'+IntToStr(temp)+'.odt';
     Inc(temp);
     (*
     {$IFDEF MSWINDOWS}
     Windows.CopyFile( PChar(_Template_Filename), PChar( Nom), False);
     {$ELSE}
     CopyFile( PChar(_Template_Filename), PChar( Nom), [cffOverwriteFile], True);
     {$ENDIF}
     *)
     //MyCopyFile( _Template_Filename, Nom);
     //XCopy( _Template_Filename, Nom);
     {$IFDEF FPC}
     CopyFile( PChar(_Template_Filename), PChar( Nom), [cffOverwriteFile], True);
     {$ELSE}
     CopyFile( PChar(_Template_Filename), PChar( Nom), True);
     {$ENDIF}
     Init( Nom);
end;

procedure TOpenDocument.Init(_Nom: String);
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
     Get_xmlContent_USER_FIELD_DECLS_Premier:= True;
     Automatic_list_style_number     :=0;
     Automatic_style_paragraph_number:= 0;
     Automatic_style_text_number     := 0;
     pChange:= TPublieur.Create( Classname+'.pChange');
     Nom:= _Nom;

     odeMeta             := TOpenDocument_Element.Create( 'meta.xml'                         );
     odeSettings         := TOpenDocument_Element.Create( 'settings.xml'                     );
     odeMETA_INF_manifest:= TOpenDocument_Element.Create( 'META-INF'+{$IFDEF FPC}PathDelim{$ELSE}'\'{$ENDIF}+'manifest.xml');
     odeContent          := TOpenDocument_Element.Create( 'content.xml'                      );
     odeStyles           := TOpenDocument_Element.Create( 'styles.xml'                       );

     Calcule_is_Calc;
     Is_template_from_extension;

     slStyles_Cellule_Properties:= TODStringList.Create;

     Extrait;

     XML_from_Repertoire_Extraction;
     Embed_Image_counter:= 0;
     slEmbed_Image:= TslDimensions_Image.Create( ClassName+'.slEmbed_Image');
     pFields_Change:= TOpenDocument_Fields_Publieur.Create(ClassName+'.pFields_Change');
     pFields_Delete:= TOpenDocument_Fields_Publieur.Create(ClassName+'.pFields_Delete');
end;

destructor TOpenDocument.Destroy;
begin
     FreeAndNil( pFields_Change      );
     FreeAndNil( pFields_Delete      );
     FreeAndNil( slEmbed_Image       );
     FreeAndNil( slStyles_Cellule_Properties);


     {$IFDEF FPC}ChDir{$ELSE}TDirectory.SetCurrentDirectory{$ENDIF}( ExtractFilePath( Nom));
     //OD_Temporaire.DetruitRepertoire( Repertoire_Extraction);

     FreeAndNil( odeMeta             );
     FreeAndNil( odeSettings         );
     FreeAndNil( odeMETA_INF_manifest);
     FreeAndNil( odeContent          );
     FreeAndNil( odeStyles           );

     FreeAndNil( pChange);
     inherited;
end;


const
     sPictures='Pictures';

function TOpenDocument.Repertoire_Pictures: String;
begin
     if '' = FRepertoire_Pictures
     then
         FRepertoire_Pictures
         :=
           IncludeTrailingPathDelimiter( Repertoire_Extraction)
           +sPictures+PathDelim;
     Result:= FRepertoire_Pictures;
end;

procedure TOpenDocument.XML_from_Repertoire_Extraction;
var
   R: String;
begin
     R:= IncludeTrailingPathDelimiter( Repertoire_Extraction);
     odeMeta             .XML_from_Repertoire_Extraction( R);
     odeSettings         .XML_from_Repertoire_Extraction( R);
     odeMETA_INF_manifest.XML_from_Repertoire_Extraction( R);
     odeContent          .XML_from_Repertoire_Extraction( R);
     odeStyles           .XML_from_Repertoire_Extraction( R);
end;

procedure TOpenDocument.Repertoire_Extraction_from_XML;
var
   R: String;
begin
     MIMETYPE_and_MANIFEST_MEDIA_TYPE_from_Is_template;

     R:= IncludeTrailingPathDelimiter( Repertoire_Extraction);
     odeMeta             .Repertoire_Extraction_from_XML( R);
     odeSettings         .Repertoire_Extraction_from_XML( R);
     odeMETA_INF_manifest.Repertoire_Extraction_from_XML( R);
     odeContent          .Repertoire_Extraction_from_XML( R);
     odeStyles           .Repertoire_Extraction_from_XML( R);
end;

{$IFDEF FPC}
procedure TOpenDocument.Extrait;
var
   UnZipper: TUnZipper;
begin
     Repertoire_Extraction:= OD_Temporaire.Nouveau_Repertoire('OD');
     FRepertoire_Pictures:= '';
     UnZipper := TUnZipper.Create;
     try
        UnZipper.FileName := Nom;
        UnZipper.OutputPath := Repertoire_Extraction;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
     finally
            UnZipper.Free;
            end;
     OOoChrono.Stop( 'Extraction des fichiers xml');
end;
{$ELSE}
procedure TOpenDocument.Extrait;
var
   zf: TZipFile;
   I: Integer;
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
begin
     Teste_ouverture;

     zf:= TZipFile.Create;
     try
        zf.Open( Nom, zmRead);
        Repertoire_Extraction:= OD_Temporaire.Nouveau_Repertoire( 'OD');
        zf.ExtractAll( Repertoire_Extraction);
        OOoChrono.Stop( 'Extraction des fichiers xml');
     finally
            FreeAndNil( zf);
            end;
end;
{$ENDIF}

procedure TOpenDocument.Save;
var
   {$IFDEF FPC}
   Zipper: TZipper;
   {$ELSE}
   zf: TZipFile;
   {$ENDIF}
   procedure Ajoute_SousRepertoire( _SousRepertoire: String);
   var
      F: TSearchRec;
      Erreur: Integer;
      DiskDirPath,
      ZipDirPath,
      DiskFileName,
      ZipFileName: String;
      procedure AjouteMIMETYPE;
      {$IFDEF FPC}
      var
         zfe: TZipFileEntry;
      {$ENDIF}
      begin
           F.Name:= 'mimetype';
           DiskFileName:= DiskDirPath+F.Name;
           ZipFileName :=  ZipDirPath+F.Name;
           {$IFDEF FPC}
             zfe:= Zipper.Entries.AddFileEntry( DiskFileName, ZipFileName);
             zfe.CompressionLevel:= clnone;
           {$ELSE}
             zf.Add( DiskFileName, ZipFileName, zcStored);
           {$ENDIF}
      end;
   begin
        ZipDirPath:= _SousRepertoire;
        DiskDirPath:= IncludeTrailingPathDelimiter( Repertoire_Extraction)
                            +_SousRepertoire;
        //Le fichier mimetype doit être ajouté en premier et non compressé
        if ''=_SousRepertoire
        then
            AjouteMIMETYPE;
        if 0 = FindFirst( DiskDirPath+'*', faAnyFile, F)
        then
            repeat
                  //Le fichier mimetype de la racine est ajouté séparément ci-dessus
                  if (''=_SousRepertoire) and ('mimetype' = F.Name)then continue;

                  DiskFileName:= DiskDirPath+F.Name;
                  ZipFileName :=  ZipDirPath+F.Name;
                  if (F.Attr and faDirectory) = faDirectory
                  then
                      begin
                      if     (F.Name <> '.')
                         and (F.Name <> '..')
                      then
                          Ajoute_SousRepertoire( ZipFileName+PathDelim)
                      end
                  else
                      {$IFDEF FPC}
                        Zipper.Entries.AddFileEntry( DiskFileName, ZipFileName);
                      {$ELSE}
                        zf.Add( DiskFileName, ZipFileName);
                      {$ENDIF}
            until FindNext(F)<>0;
        FindClose( F);
   end;
begin
     Repertoire_Extraction_from_XML;
     {$IFDEF FPC}
       Zipper := TZipper.Create;
     {$ELSE}
       zf:= TZipFile.Create;
     {$ENDIF}
     try
       {$IFDEF FPC}
         Zipper.FileName := Nom;
       {$ELSE}
         zf.Open( Nom, zmWrite);
       {$ENDIF}

        Ajoute_SousRepertoire( '');

       {$IFDEF FPC}
         Zipper.ZipAllFiles;
       {$ENDIF}
     finally
            {$IFDEF FPC}
              Zipper.Free;
            {$ELSE}
              FreeAndNil( zf);
            {$ENDIF}
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

procedure TOpenDocument.Manifeste( _FullPath, _Extension: String);
var
   root, e: TDOMNode;
   MimeType: String;
begin
     //==> META-INF/manifest.xml
     //  <manifest:manifest manifest:version="1.2">
     //     <manifest:file-entry manifest:full-path="Pictures/1000020100000064000000323F4469E66C808866.png" manifest:media-type="image/png"/>
     root:= odeMETA_INF_manifest.xml.Root;
     e:= Cherche_Item_Recursif( root,
                                'manifest:file-entry',
                                ['manifest:full-path'],
                                [_FullPath]);
    if Assigned(e) then exit;

    MimeType:= MimeType_from_Extension(_Extension);
    Add_Item( root,
              'manifest:file-entry',
              ['manifest:full-path', 'manifest:media-type'],
              [_FullPath           , MimeType             ]);
end;

function TOpenDocument.Embed_Image_New_name_exists: Boolean;
var
   sr: TSearchRec;
   sWildCards: String;
begin
     {$IFDEF WINDOWS}
     sWildCards:= '*.*';
     {$ELSE}
     sWildCards:= '*';
     {$ENDIF}
     Embed_Image_counter_New_name
     :=
       IntToHex( Embed_Image_counter, 40);
     Result:= 0 = FindFirst( Repertoire_Pictures+Embed_Image_counter_New_name+sWildCards, faAnyFile, sr);
     FindClose( sr);
end;

function TOpenDocument.Embed_Image_New: String;
begin
     while Embed_Image_New_name_exists
     do
       Inc( Embed_Image_counter);
     Result:= Embed_Image_counter_New_name;
end;

function TOpenDocument.Embed_Image( _NomFichier: String): TDimensions_Image;
var
   iEmbed_Image: Integer;
   procedure Copie_dans_Pictures;
   var
      Extension: String;
      sFileName: String;
      sRepertoirePictures: String;
      sNomFichierCible: String;
      sURL: String;
   begin
        sRepertoirePictures
        :=
           IncludeTrailingPathDelimiter(Repertoire_Extraction)
          +sPictures;
        ForceDirectories( sRepertoirePictures);

        Extension:= ExtractFileExt( _NomFichier);

        sFileName:= Embed_Image_New+Extension;
        //sFileName:= ExtractFileName( _NomFichier);

        sURL:= sPictures+'/'+sFileName;
        Manifeste( sURL, Extension);

        sNomFichierCible:= Repertoire_Pictures+sFileName;

        CopyFile( PWideChar( _NomFichier), PWideChar( sNomFichierCible), False);

        Result:= TDimensions_Image.Create( sNomFichierCible, sURL);
        slEmbed_Image.AddObject( _NomFichier, Result);
   end;
begin
     Result:= nil;
     if not FileExists( _NomFichier) then exit;

     Result:= Dimensions_Image_from_sl_sCle( slEmbed_Image, _NomFichier);
     if Assigned( Result) then exit;

     Copie_dans_Pictures;
end;

function TOpenDocument.Get_xmlContent_TEXT: TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( odeContent.xml.Root, 'office:body/office:text')
end;

function TOpenDocument.Get_xmlContent_USER_FIELD_DECLS: TJclSimpleXMLElem;
const
     USER_FIELD_DECLS_path='office:body/office:text/text:user-field-decls';
begin
     Result:= Elem_from_path( odeContent.xml.Root, USER_FIELD_DECLS_path);
     if Assigned( Result) then exit;

     Result:= Cree_path( odeContent.xml.Root, USER_FIELD_DECLS_path);
end;

function TOpenDocument.Get_xmlContent_AUTOMATIC_STYLES: TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( odeContent.xml.Root, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET: TJclSimpleXMLElem;
begin
     Result
     :=
       Elem_from_path( odeContent.xml.Root,
                       'office:body/office:spreadsheet');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_first_TABLE: TJclSimpleXMLElem;
var
   eRoot: TJclSimpleXMLElem;
   e: TJclSimpleXMLElem;
   I: Integer;
begin
     Result:= nil;
     eRoot:= Get_xmlContent_SPREADSHEET;

     for I:= 0 to eRoot.Items.Count -1
     do
       begin
       e:= eRoot.Items.Item[0];
       if e = nil then continue;

       if 'table' = Name_from_FullName( e.Name)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: TJclSimpleXMLElem;
begin
     Result
     :=
       Elem_from_path( odeContent.xml.Root,
                       'office:body/office:spreadsheet/table:named-expressions');
end;

function TOpenDocument.Get_xmlStyles_STYLES: TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( odeStyles.xml.Root,'office:styles')
end;

function TOpenDocument.Get_xmlStyles_AUTOMATIC_STYLES: TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( odeStyles.xml.Root, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlStyles_MASTER_STYLES: TJclSimpleXMLElem;
begin
     Result:= Elem_from_path( odeStyles.xml.Root, 'office:master-styles');
end;

function TOpenDocument.Get_Property_Name( _e: TDOMNode; _NodeName: String): String;
begin
     Result:= uOD_JCL.Get_Property_Name( _e, _NodeName);
end;

function TOpenDocument.not_Get_Property( _e: TJclSimpleXMLElem;
                                         _FullName: String;
                                         out _Value: String): Boolean;
begin
     Result:= uOD_JCL.not_Get_Property( _e, _FullName, _Value);
end;

function TOpenDocument.not_Test_Property( _e: TJclSimpleXMLElem;
                                          _FullName: String;
                                          _Values: array of String): Boolean;
begin
     Result:= uOD_JCL.not_Test_Property( _e, _FullName, _Values);
end;

procedure TOpenDocument.Set_Property( _e: TJclSimpleXMLElem;
                                      _Fullname, _Value: String);
begin
     uOD_JCL.Set_Property( _e, _Fullname, _Value);
end;

procedure TOpenDocument.Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);
begin
     uOD_JCL.Delete_Property( _e, _Fullname);
end;

function TOpenDocument.Field_Assure( _Name: String): TDOMNode;
begin
     Result
     :=
       Ensure_Item( Get_xmlContent_USER_FIELD_DECLS, 'text:user-field-decl',
                    ['text:name'],
                    [_Name      ]
                    );
end;

procedure TOpenDocument.Set_Field( _Name, _Value: String);
var
   e: TJclSimpleXMLElem;
begin
     e:= Field_Assure( _Name);
     if e= nil then exit;

     Set_Property( e, 'office:value-type'  , 'string');
     Set_Property( e, 'office:string-value', _Value  );

     pFields_Change.Publie( _Name, _Value);
end;

procedure TOpenDocument.Fields_Visite( _fv: TFields_Visitor);
var
   eUSER_FIELD_DECLS: TDOMNode;
   I: Integer;
   e: TDOMNode;
   Name, String_Value: String;
begin
     if not Assigned( _fv) then exit;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.Items.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.Items.Item[ I];
       if e = nil                              then continue;
       if e.Fullname <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name'          , Name        ) then continue;
       if not_Get_Property( e, 'office:string-value', String_Value) then continue;

       _fv( Name, String_Value);
       end;
     OOoChrono.Stop( 'Extraction des TextFields');
end;

procedure TOpenDocument.Add_FieldGet( _Name: String);
var
   eTEXT: TJclSimpleXMLElem;
   eP: TJclSimpleXMLElem;
   eUSER_FIELD_GET: TJclSimpleXMLElem;
begin
     eTEXT:= Get_xmlContent_TEXT;
     if eTEXT = nil then exit;

     eP:= eTEXT.Items.Add( 'text:p');
     if eP = nil then exit;

     eUSER_FIELD_GET:= eP.Items.Add( 'text:user-field-get');
     if eUSER_FIELD_GET = nil then exit;

     eUSER_FIELD_GET.Properties.Add( 'text:name', _Name);
end;

function TOpenDocument.Get_STYLES( _Root: TOD_Root_Styles): TJclSimpleXMLElem;
begin
     case _Root
     of
       ors_xmlStyles_STYLES           : Result:= Get_xmlStyles_STYLES;
       ors_xmlStyles_AUTOMATIC_STYLES : Result:= Get_xmlStyles_AUTOMATIC_STYLES;
       ors_xmlContent_AUTOMATIC_STYLES: Result:= Get_xmlContent_AUTOMATIC_STYLES;
       else                             Result:= nil;
       end;
end;

function TOpenDocument.Add_list_style(_NomStyle: String; _Root: TOD_Root_Styles): TDOMNode;
var
   Name: String;
   eSTYLES: TDOMNode;
   e: TDOMNode;
begin
     Result:= nil;
     Name:= Style_NameFromDisplayName( _NomStyle);

     eSTYLES:= Get_STYLES( _Root);
     if nil = eSTYLES then exit;

     e:= Cree_path( eSTYLES, 'text:list-style');
     if nil = e then exit;

     Set_Property(e, 'style:name', Name);

     Result:= e;
end;

function TOpenDocument.Add_automatic_list_style( out _eStyle: TDOMNode; _Is_Header: Boolean= False): String;
const
     bullet_char_1='•';//'&#x25CF;'U25CF
     bullet_char_2='◦';//'&#x25CB;'U25CB
     bullet_char_3='▪';//'&#x25A0;'U25A0
var
   Name: String;
begin
     Result:= '';

     Name:= 'ODL'+IntToStr( Automatic_list_style_number);

     _eStyle:= Add_list_style( Name, Root_Styles_from_Is_Header( _Is_Header));
     if nil = _eStyle then exit;

     Result:= Name;
     Inc( Automatic_list_style_number);

     Add_list_level_style_bullet( _eStyle,  '1', '1.0cm', bullet_char_1);
     Add_list_level_style_bullet( _eStyle,  '2', '1.5cm', bullet_char_2);
     Add_list_level_style_bullet( _eStyle,  '3', '2.0cm', bullet_char_3);
     Add_list_level_style_bullet( _eStyle,  '4', '2.5cm', bullet_char_1);
     Add_list_level_style_bullet( _eStyle,  '5', '3.0cm', bullet_char_2);
     Add_list_level_style_bullet( _eStyle,  '6', '3.5cm', bullet_char_3);
     Add_list_level_style_bullet( _eStyle,  '7', '4.0cm', bullet_char_1);
     Add_list_level_style_bullet( _eStyle,  '8', '4.5cm', bullet_char_2);
     Add_list_level_style_bullet( _eStyle,  '9', '5.0cm', bullet_char_3);
     Add_list_level_style_bullet( _eStyle, '10', '5.5cm', bullet_char_1);
end;

(*
<text:list-style style:name="L1">
text:level= "1" fo:margin-left="1.27cm"  text:list-tab-stop-position="1.27cm"/>
text:level= "2" fo:margin-left="1.905cm" text:list-tab-stop-position="1.905cm"/>
text:level= "3" fo:margin-left="2.54cm"  text:list-tab-stop-position="2.54cm"/>
text:level= "4" fo:margin-left="3.175cm" text:list-tab-stop-position="3.175cm"/>
text:level= "5" fo:margin-left="3.81cm"  text:list-tab-stop-position="3.81cm"/>
text:level= "6" fo:margin-left="4.445cm" text:list-tab-stop-position="4.445cm"/>
text:level= "7" fo:margin-left="5.08cm"  text:list-tab-stop-position="5.08cm"/>
text:level= "8" fo:margin-left="5.715cm" text:list-tab-stop-position="5.715cm"/>
text:level= "9" fo:margin-left="6.35cm"  text:list-tab-stop-position="6.35cm"/>
text:level="10" fo:margin-left="6.985cm" text:list-tab-stop-position="6.985cm"/>
</text:list-style>

*)
procedure TOpenDocument.Add_list_level_style_bullet( _eListStyle: TDOMNode;
                                                     _level, _left, _bullet_char: String);
const
     Bullet_Style_display_name='Bullet Symbols';
     Bullet_Style='Bullet_20_Symbols';
var
   e: TDOMNode;
   procedure Assure_Bullet_20_Symbols;
   var
      eBullet_Style: TDOMNode;
      eProperties: TDOMNode;
   begin
        //Styles.xml
        //<style:style style:name="Bullet_20_Symbols" style:family="text" style:display-name="Bullet Symbols">
        //  <style:text-properties fo:font-family="OpenSymbol" style:font-name="OpenSymbol" style:font-charset="x-symbol" style:font-name-asian="OpenSymbol" style:font-family-asian="OpenSymbol" style:font-name-complex="OpenSymbol" style:font-charset-asian="x-symbol" style:font-family-complex="OpenSymbol" style:font-charset-complex="x-symbol"/>
        //</style:style>
        eBullet_Style:= Find_style_text( Bullet_Style_display_name);
        if Assigned( eBullet_Style) then exit;

        eBullet_Style:= Add_style_text( Bullet_Style_display_name, '');

        eProperties:= Cree_path( eBullet_Style, 'style:text-properties');

        Set_Property( eProperties, 'fo:font-family'            , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-name'           , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-charset'        , 'x-symbol'  );

        Set_Property( eProperties, 'style:font-family-asian'   , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-name-asian'     , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-charset-asian'  , 'x-symbol'  );

        Set_Property( eProperties, 'style:font-family-complex' , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-name-complex'   , 'OpenSymbol');
        Set_Property( eProperties, 'style:font-charset-complex', 'x-symbol'  );
   end;
begin
     e:= Cree_path( _eListStyle, 'text:list-level-style-bullet');
     Set_Property(e, 'text:level'      , _level);
     Assure_Bullet_20_Symbols;
     Set_Property(e, 'text:style-name' , Bullet_Style);
     Set_Property(e, 'text:bullet-char', _bullet_char);
     Add_list_level_properties( e, _left);
end;

procedure TOpenDocument.Add_list_level_properties( _eList_level_style_bullet: TDOMNode;
                                                   _left: String);
var
   e: TDOMNode;
begin
     e:= Cree_path( _eList_level_style_bullet, 'style:list-level-properties');
     Set_Property(e, 'text:list-level-position-and-space-mode', 'label-alignment');
     Add_List_level_label_alignment( e, _left);
end;

procedure TOpenDocument.Add_List_level_label_alignment( _eList_level_properties: TDOMNode; _left: String);
var
   e: TDOMNode;
begin
     e:= Cree_path( _eList_level_properties, 'style:list-level-label-alignment');
     Set_Property( e, 'fo:margin-left'             , _left);
     Set_Property( e, 'fo:text-indent'             , '-0.635cm');
     Set_Property( e, 'text:label-followed-by'     , 'listtab');
     Set_Property( e, 'text:list-tab-stop-position', _left);
end;

(*
<text:list-style style:name="L1">
  <text:list-level-style-bullet text:level="1" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="1.27cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="1.27cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="2" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="1.905cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="1.905cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="3" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="2.54cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="2.54cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="4" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="3.175cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="3.175cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="5" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="3.81cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="3.81cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="6" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="4.445cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="4.445cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="7" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="5.08cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="5.08cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="8" text:style-name="Bullet_20_Symbols" text:bullet-char="◦">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="5.715cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="5.715cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="9" text:style-name="Bullet_20_Symbols" text:bullet-char="▪">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="6.35cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="6.35cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

  <text:list-level-style-bullet text:level="10" text:style-name="Bullet_20_Symbols" text:bullet-char="•">
    <style:list-level-properties text:list-level-position-and-space-mode="label-alignment">
      <style:list-level-label-alignment fo:margin-left="6.985cm" fo:text-indent="-0.635cm" text:label-followed-by="listtab" text:list-tab-stop-position="6.985cm"/>
    </style:list-level-properties>
  </text:list-level-style-bullet>

</text:list-style>

*)

function TOpenDocument.Add_automatic_list_style( _Is_Header: Boolean= False): String;
var
   eStyle: TDOMNode;
begin
     Result:= Add_automatic_list_style( eStyle, _Is_Header);
end;

function TOpenDocument.Add_style( _NomStyle,
                                  _NomStyleParent: String;
                                  _Root: TOD_Root_Styles;
                                  _family, _class: String): TJclSimpleXMLElem;
var
   Name: String;
   Parent_Style_Name: String;
   eSTYLES: TJclSimpleXMLElem;
   e: TJclSimpleXMLElem;
begin
     Result:= nil;
     Name             := Style_NameFromDisplayName( _NomStyle      );
     Parent_Style_Name:= Style_NameFromDisplayName( _NomStyleParent);

     eSTYLES:= Get_STYLES( _Root);
     if eSTYLES = nil then exit;

     e:= eSTYLES.Items.Add( 'style:style');
     if e= nil then exit;

     e.Properties.Add( 'style:name'             , Name             );
     e.Properties.Add( 'style:display-name'     , _NomStyle        );
     e.Properties.Add( 'style:parent-style-name', Parent_Style_Name);
     e.Properties.Add( 'style:family'           , _family          );
     if _class <> ''
     then
         e.Properties.Add( 'style:class'        , _class           );

     Result:= e;
end;

function TOpenDocument.Add_style_paragraph( _NomStyle, _NomStyleParent: String;
                                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, 'paragraph','text');
end;

function TOpenDocument.Add_style_text( _NomStyle, _NomStyleParent: String; _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
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
                                                       _SizePourcent: Integer): TJclSimpleXMLElem;
var
   eTEXT_PROPERTIES: TJclSimpleXMLElem;
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
                                            out _eStyle: TJclSimpleXMLElem;
                                            _Is_Header: Boolean;
                                            _family,
                                            _class,
                                            _number_prefix: String;
                                            var _number_counter: Integer): String;
var
   Style_Root: TOD_Root_Styles;
   eTEXT_PROPERTIES: TJclSimpleXMLElem;
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
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer;
                                                      out _eStyle: TJclSimpleXMLElem;
                                                      _Is_Header: Boolean;
                                                      _Page_break_before: Boolean= False): String;
var
   ePARAGRAPH_PROPERTIES: TDOMNode;
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
     if not _Page_break_before then exit; // ## à surveiller si d'autres propriétés de paragraphe sont rajoutées

     if _eStyle = nil then exit;

     ePARAGRAPH_PROPERTIES:= Ensure_Item(_eStyle, 'style:paragraph-properties', [], []);
     if ePARAGRAPH_PROPERTIES = nil then exit;

     if _Page_break_before
     then
         Set_Property( ePARAGRAPH_PROPERTIES, 'fo:break-before', 'page');
end;

function TOpenDocument.Add_automatic_style_text( _NomStyleParent: String;
                                                 _Gras: Boolean;
                                                 _DeltaSize: Integer;
                                                 _Size: Integer;
                                                 _SizePourcent: Integer;
                                                 out _eStyle: TJclSimpleXMLElem;
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
                                                      _SizePourcent: Integer;
                                                      _Page_break_before: Boolean= False): String;
var
   e: TJclSimpleXMLElem;
begin
     Result:= Add_automatic_style_paragraph( _NomStyleParent,
                                             _Gras,
                                             _DeltaSize,
                                             _Size,
                                             _SizePourcent,
                                             e,
                                             False,
                                             _Page_break_before);
end;

function TOpenDocument.Add_automatic_style_text( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer): String;
var
   e: TJclSimpleXMLElem;
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
   eSTYLE: TJclSimpleXMLElem;
   NomStyle_Parent: String;

   eTEXT_PROPERTIES: TJclSimpleXMLElem;
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

function TOpenDocument.Get_Table_Properties( _NomTable: String): TJclSimpleXMLElem;
var
   eSTYLES: TJclSimpleXMLElem;
   eSTYLE: TJclSimpleXMLElem;
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
   eTABLE_PROPERTIES: TJclSimpleXMLElem;
begin
     Result:= '';
     eTABLE_PROPERTIES:= Get_Table_Properties( _NomTable);
     not_Get_Property( eTABLE_PROPERTIES, 'style:width', Result);
end;

procedure TOpenDocument.SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
var
   eTABLE_CELL_PROPERTIES: TJclSimpleXMLElem;
   sPadding: String;
begin
     eTABLE_CELL_PROPERTIES:= Ensure_automatic_style_table_cell_properties( _NomTable, _X, _Y);

     Str( Padding_cm:5:3, sPadding);
     sPadding:= sPadding + 'cm';

     Set_Property( eTABLE_CELL_PROPERTIES, 'fo:padding', sPadding);

     //<style:table-cell-properties fo:padding="0cm" fo:border-left="" fo:border-right="none" fo:border-top="0.05pt dotted #000000" fo:border-bottom="0.05pt solid #000000"/>
end;

procedure TOpenDocument.Apply_Cell_Style( e: TJclSimpleXMLElem);
begin
     Set_Property( e, 'table:style-name', Cell_Style);
end;


procedure TOpenDocument.Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
var
   eSTYLES: TJclSimpleXMLElem;
   eSTYLE: TJclSimpleXMLElem;

   eTABLE_COLUMN_PROPERTIES: TJclSimpleXMLElem;

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

     eTABLE_COLUMN_PROPERTIES.Properties.Delete( 'column-width');
     eTABLE_COLUMN_PROPERTIES.Properties.Delete( 'rel-column-width');

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
   eSTYLES: TJclSimpleXMLElem;

   eSTYLE_Source, eSTYLE_Cible: TJclSimpleXMLElem;
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
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
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
   e: TJclSimpleXMLElem;
   StyleName_Apres: String;
begin
     e:= Find_style_paragraph( _NomStyle_Avant, _Root);

     if nil = e then exit;

     StyleName_Apres:= Style_NameFromDisplayName( _NomStyle_Apres);
     Set_Property( e, 'style:name'        , StyleName_Apres);
     Set_Property( e, 'style:display-name', _NomStyle_Apres);
end;

function TOpenDocument.Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
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

function TOpenDocument.Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TJclSimpleXMLElem;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: TJclSimpleXMLElem;
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

function TOpenDocument.Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TJclSimpleXMLElem;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: TJclSimpleXMLElem;
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
                                                        _X, _Y: Integer): TJclSimpleXMLElem;
var
   sCle: String;
   I: Integer;
   procedure Get_from_XML;
   var
      eStyle: TJclSimpleXMLElem;
   begin                                 
        eStyle:= Add_automatic_style_table_cell( _NomTable, _X, _Y);
        if eStyle = nil then exit;

        Result:= Add_Item( eStyle, 'style:table-cell-properties',[],[]);
        slStyles_Cellule_Properties.AddObject( sCle, Result);
   end;
   procedure Get_from_sl;
   var
      O: TObject;
   begin
        O:= slStyles_Cellule_Properties.Objects[ I];
        if O = nil                      then exit;
        if not (O is TJclSimpleXMLElem) then exit;
        Result:= TJclSimpleXMLElem( O);
   end;
begin
     Result:= nil;

     sCle:= _NomTable+IntToHex(_X,8)+IntToHex(_Y,8);
     I:= slStyles_Cellule_Properties.IndexOf( sCle);
     if I = -1
     then
         Get_from_XML
     else
         Get_from_sl;
end;

procedure TOpenDocument.Change_style_parent( _NomStyle, _NomStyleParent: String);
var
   e: TJclSimpleXMLElem;
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

function TOpenDocument.Cherche_field( _Name: String): TJclSimpleXMLElem;
(*
var
   eUSER_FIELD_DECLS: TJclSimpleXMLElem;
   I: Integer;
   e: TJclSimpleXMLElem;
   Name: String;
begin
     Result:= nil;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.Items.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.Items.Item[ I];
       if e = nil                     then continue;
       if e.FullName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if UpperCase(Name) = UpperCase(_Name)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;
*)
//2017 04 21: passage de "case insensitive" à "case sensitive"
begin
     Result
     :=
       Cherche_Item( Get_xmlContent_USER_FIELD_DECLS, 'text:user-field-decl',
                     ['text:name'],
                     [_Name      ]);
end;

procedure TOpenDocument.Enumere_field_Racine( _Racine_Name: String;
                                              _CallBack: TEnumere_field_Racine_Callback);
var
   eUSER_FIELD_DECLS: TJclSimpleXMLElem;
   I: Integer;
   e: TJclSimpleXMLElem;
   Name: String;
begin
     if not Assigned( _CallBack) then exit;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.Items.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.Items.Item[ I];
       if e = nil                     then continue;
       if e.FullName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if 1 = Pos( _Racine_Name, Name)
       then
           _CallBack( e);
       end;
end;

function TOpenDocument.Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                     _Properties_Names ,
                                     _Properties_Values: array of String): TJclSimpleXMLElem;
begin
     Result
     :=
       uOD_JCL.Cherche_Item( _eRoot, _FullName,
                                   _Properties_Names , _Properties_Values);
end;

function TOpenDocument.Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                              _Properties_Names ,
                                              _Properties_Values: array of String): TJclSimpleXMLElem;
begin
     Result
     :=
       uOD_JCL.Cherche_Item_Recursif( _eRoot, _FullName,
                                            _Properties_Names ,
                                            _Properties_Values);
end;

function TOpenDocument.Ensure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): TJclSimpleXMLElem;
begin
     Result
     :=
       uOD_JCL.Ensure_Item( _eRoot, _FullName,
                                  _Properties_Names, _Properties_Values);
end;

function TOpenDocument.Add_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): TJclSimpleXMLElem;
begin
     Result
     :=
       uOD_JCL.Add_Item( _eRoot, _FullName,
                                  _Properties_Names, _Properties_Values);
end;

procedure TOpenDocument.Copie_Item( _Source, _Cible: TJclSimpleXMLElem);
begin
     uOD_JCL.Copie_Item( _Source, _Cible);
end;

function TOpenDocument.Find_style_family( _NomStyle: String;
                                          _Root: TOD_Root_Styles;
                                          _family: String): TJclSimpleXMLElem;
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

function TOpenDocument.Find_date_style( _NomStyle: String; _Root: TOD_Root_Styles): TDOMNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'number:date-style',
                              ['style:name'],
                              [Name        ]);
end;

function TOpenDocument.Find_Time_style( _NomStyle: String; _Root: TOD_Root_Styles): TDOMNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'number:time-style',
                              ['style:name'],
                              [Name        ]);
end;

function TOpenDocument.Find_style_paragraph( _NomStyle: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text( _NomStyle: String;
                                        _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'text');
end;

function TOpenDocument.Find_style_family_multiroot( _NomStyle: String;
                                                    _Root: TOD_Root_Styles;
                                                    _family: String): TJclSimpleXMLElem;
     function CR( _R: TOD_Root_Styles): TJclSimpleXMLElem;
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
                                                       _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text_multiroot( _NomStyle: String;
                                                  _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TJclSimpleXMLElem;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Contient_Style_Enfant( _eRoot: TJclSimpleXMLElem;
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

function TOpenDocument.Utilise_Style( _eRoot: TJclSimpleXMLElem;
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

procedure TOpenDocument.Field_Vide_Branche_CallBack( _e: TJclSimpleXMLElem);
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
   e: TJclSimpleXMLElem;
begin
     Result:= _Default;

     e:= Cherche_field( _Nom);
     if e = nil then exit;

     not_Get_Property( e, 'office:string-value', Result);
end;

procedure TOpenDocument.Text_Ecrire( _Nom: String; _Valeur: String);
var
   e: TJclSimpleXMLElem;
begin
     e:= Field_Assure( _Nom);
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
   eUSER_FIELD_DECLS: TJclSimpleXMLElem;
   e: TJclSimpleXMLElem;
begin
     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     e:= Cherche_field( Champ);
     if e = nil then exit;

     eUSER_FIELD_DECLS.Items.Remove( e);
     pFields_Delete.Publie( Champ, '');
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
   e: TJclSimpleXMLElem;
   String_Value: String;
begin
     Result:= '';

     e:= Cherche_field( _Name);
     if e = nil then exit;

     if not_Get_Property( e, 'office:string-value', String_Value) then exit;
     Result:= String_Value;
end;

procedure TOpenDocument.Supprime_Item( _e: TJclSimpleXMLElem);
var
   Parent: TJclSimpleXMLElem;
   CONTAINER: TJclSimpleXMLElems;
   //Index: Integer;
begin
     if _e = nil then exit;

     Parent:= _e.Parent;
     if Parent= nil then exit;

     CONTAINER:= Parent.Items;
     if CONTAINER = nil then exit;

     //Index:= CONTAINER.IndexOf( _e);
     //CONTAINER.Delete( Index);
     CONTAINER.Remove( _e);
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

procedure TOpenDocument.AddSpace( _e: TJclSimpleXMLElem; _c: Integer);
begin
     if _c < 1 then exit;

     if _c = 1
     then
         Add_Item( _e, 'text:s',[],[])
     else
         Add_Item( _e, 'text:s', ['text:c'], [IntToStr( _c)]);
end;

procedure TOpenDocument.AddText_( _e: TJclSimpleXMLElem; _Value: String; _Gras: Boolean= False);
var
   I: Integer;
   C: Char;
   S: String;
   procedure Ajoute_SautLigne;
   begin
        Cree_path( _e, 'text:line-break');
   end;
   procedure Ajoute_Tabulation;
   begin
        Cree_path( _e, 'text:tab');
   end;
   procedure Ajoute_S;
   var
      eSpan: TJclSimpleXMLElem;
   begin
        if S = '' then exit;

        eSpan:= Cree_path( _e, 'text:span');
        if _Gras then Set_Property( eSpan, 'text:style-name', Name_style_text_bold);
        eSpan.Value:= S;
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

//Copié collé de http://wiki.freepascal.org/Synapse#Downloading_files
function DownloadHTTP(URL, TargetFile: string): Boolean;
// Download file; retry if necessary.
// Could use Synapse HttpGetBinary, but that doesn't deal
// with result codes (i.e. it happily downloads a 404 error document)
const
  MaxRetries = 3;
var
  HTTPGetResult: Boolean;
  HTTPSender: THTTPSend;
  RetryAttempt: Integer;
begin
  Result := False;
  RetryAttempt := 1;
  HTTPSender := THTTPSend.Create;
  try
    try
      // Try to get the file
      HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
      while (HTTPGetResult = False) and (RetryAttempt < MaxRetries) do
      begin
        Sleep(500 * RetryAttempt);
        HTTPSender.Clear;
        HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
        RetryAttempt := RetryAttempt + 1;
      end;
      // If we have an answer from the server, check if the file
      // was sent to us.
      case HTTPSender.Resultcode of
        100..299:
          begin
            HTTPSender.Document.SaveToFile(TargetFile);
            Result := True;
          end; //informational, success
        300..399: Result := False; // redirection. Not implemented, but could be.
        400..499: Result := False; // client error; 404 not found etc
        500..599: Result := False; // internal server error
        else Result := False; // unknown code
      end;
    except
      // We don't care for the reason for this error; the download failed.
      Result := False;
    end;
  finally
    HTTPSender.Free;
  end;
end;
procedure TOpenDocument.AddHtml( _e: TDOMNode; _Value: String; _Gras: Boolean= False);
var
   html: {$IFDEF FPC}THTMLDocument{$ELSE}TJclSimpleXML{$ENDIF};
   html_root: TDOMNode;
   p: TCSS_Style_Parser_PYACC;
   function not_Cree_html: Boolean;
   var
      ss: TStringStream;
   begin
        html_root:= nil;
        Result:= True;
        if 1 <> Pos( '<', _Value) then exit;

        ss:= TStringStream.Create( _Value);
        try
           try
              {$IFDEF FPC}
              ReadHTMLFile( html, ss);
              html_root:= html.FirstChild;
              {$ELSE}
              html:= TJclSimpleXml.Create;
              html.IndentString:= '  ';
              with html do Options:= Options + [sxoAutoEncodeValue];
              html.LoadFromStream( ss);
              html_root:= html.Root;
              {$ENDIF}
              Result:= html_root = nil;
           except
                 on E: Exception
                 do
                   begin
                   Log.PrintLn('Echec de '+ClassName+'.AddHtml: _Value=>'+_Value+'<'#13#10'Message: '+E.Message);
                   Result:= True;
                   end;
                 end;
        finally
               FreeAndNil( ss);
               end;
   end;
   procedure Traite_html_node( _od_Parent, _html_Parent: TDOMNode; _NomStyleParent: String; _list_style: String);
   var
      html_style:String;
      NodeName: DOMString;
      NodeValue: DOMString;
      od_node: TDOMNode;
      NomStyle: String;
      list_style: String;
      procedure Traite_parsed_styles_interne( _tp:TOD_TEXT_PROPERTIES);
         procedure T_Color( _html_style_name, _od_style_name: String);
         var
            i: Integer;
            Value: String;
            Couleur: String;
            procedure Couleur_from_RGB;
            var
               S: String;
               sR, sG, sB: String;
               R, G, B: Integer;
               hR, hG, hB: String;
               procedure Try_convert( _S: String; var _I: Integer);
               begin
                    if TryStrToInt( _S, _I) then exit;
                    _I:= 0;
               end;
            begin
                 S:= Value;
                 StrTok( '(',S);

                 sR:= StrTok( ',',S);
                 sG:= StrTok( ',',S);
                 sB:= StrTok( ')',S);

                 Try_convert( sR, R);
                 Try_convert( sG, G);
                 Try_convert( sB, B);

                 hR:= IntToHex( R, 2);
                 hG:= IntToHex( G, 2);
                 hB:= IntToHex( B, 2);

                 Couleur:= '#'+hR+hG+hB;
            end;
         begin
              i:= p.sl.IndexOfName( _html_style_name);
              if -1 = i then exit;

              Value:= p.sl.ValueFromIndex[ i];
                    if 1 = Pos('RGB(', UpperCase(Value)) then Couleur_from_RGB
              else                                            Couleur:= Value;
              Log.PrintLn( ClassNAme+'.AddHtml::T_Color:Couleur_from_RGB: Value='+Value+' , Couleur='+Couleur);
              _tp.Set_Property( _od_style_name, Couleur);
         end;
         procedure T_font_weight;
         var
            i: Integer;
            Value: String;
         begin
              i:= p.sl.IndexOfName( 'font-weight');
              if -1 = i then exit;

              Value:= p.sl.ValueFromIndex[ i];

              _tp.Set_Property( 'fo:font-weight'           , Value);
              _tp.Set_Property( 'style:font-weight-asian'  , Value);
              _tp.Set_Property( 'style:font-weight-complex', Value);
         end;
         procedure T_font_style;
         var
            i: Integer;
            Value: String;
         begin
              i:= p.sl.IndexOfName( 'font-style');
              if -1 = i then exit;

              Value:= p.sl.ValueFromIndex[ i];

              _tp.Set_Property( 'fo:font-style'           , Value);
              _tp.Set_Property( 'style:font-style-asian'  , Value);
              _tp.Set_Property( 'style:font-style-complex', Value);
         end;
      begin
           if 0 = p.sl.Count then exit;

           T_Color( 'color'           , 'fo:color'           );
           T_Color( 'background-color', 'fo:background-color');
           T_font_weight;
           T_font_style;
      end;

      procedure Traite_parsed_styles( _o: TOD_XML_Element);
      var
         tp:TOD_TEXT_PROPERTIES;
      begin
           if 0 = p.sl.Count then exit;
           tp:= _o.TEXT_PROPERTIES[_NomStyleParent];
           Traite_parsed_styles_interne( tp);
      end;
      procedure Traite_text;
      begin
           {$IFDEF FPC}
           od_node:= _e.OwnerDocument.CreateTextNode( NodeValue);
           _od_Parent.AppendChild( od_node);
           {$ELSE}
           _od_Parent.Value:= NodeValue;
           {$ENDIF}
      end;
      procedure Traite_br;
      begin
           od_node:= Cree_path( _od_Parent, 'text:line-break');
      end;
      procedure Traite_span;
      var
         span: TOD_SPAN;
      begin
           span:= TOD_SPAN.Create( Self, _od_Parent);
           try
              span.Set_Style( _NomStyleParent, False);
              NomStyle:= span.NomStyleApplique;
              Traite_parsed_styles( span);
              od_node:= span.e;
           finally
                  FreeAndNil( span);
                  end;
      end;
      procedure Traite_p;
      var
         p: TOD_PARAGRAPH;
      begin
           p:= TOD_PARAGRAPH.Create( Self, _od_Parent);
           try
              Traite_parsed_styles( p);
              od_node:= p.e;
           finally
                  FreeAndNil( p);
                  end;
      end;
      procedure Set_Bold;
      begin
           p.sl.Values[ 'font-weight']:= 'bold';
      end;
      procedure Traite_strong;
      var
         span: TOD_SPAN;
         tp:TOD_TEXT_PROPERTIES;
      begin
           span:= TOD_SPAN.Create( Self, _od_Parent);
           try
              span.Set_Style( _NomStyleParent, False);
              NomStyle:= span.NomStyleApplique;
              Set_Bold;

              tp:= span.TEXT_PROPERTIES[_NomStyleParent];
              Traite_parsed_styles_interne( tp);
              od_node:= span.e;
           finally
                  FreeAndNil( span);
                  end;
      end;
      procedure Traite_em;
      var
         span: TOD_SPAN;
         tp:TOD_TEXT_PROPERTIES;
      begin
           span:= TOD_SPAN.Create( Self, _od_Parent);
           try
              span.Set_Style( _NomStyleParent, False);
              NomStyle:= span.NomStyleApplique;
              tp:= span.TEXT_PROPERTIES[_NomStyleParent];
              p.sl.Values[ 'font-style']:= 'italic';
              Traite_parsed_styles_interne( tp);
              od_node:= span.e;
           finally
                  FreeAndNil( span);
                  end;
      end;
      procedure Traite_u;
      var
         span: TOD_SPAN;
         tp:TOD_TEXT_PROPERTIES;
      begin
           span:= TOD_SPAN.Create( Self, _od_Parent);
           try
              span.Set_Style( _NomStyleParent, False);
              NomStyle:= span.NomStyleApplique;
              tp:= span.TEXT_PROPERTIES[_NomStyleParent];
//<style:text-properties style:text-underline-color="font-color" style:text-underline-style="solid" style:text-underline-width="auto"/>
              tp.Set_Property( 'style:text-underline-color', 'font-color');
              tp.Set_Property( 'style:text-underline-style', 'solid'     );
              tp.Set_Property( 'style:text-underline-width', 'auto'      );
              Traite_parsed_styles_interne( tp);
              od_node:= span.e;
           finally
                  FreeAndNil( span);
                  end;
      end;
      procedure Traite_ul;
      var
         //textbox: TDOMNode;
         Parent: TDOMNode;
         Parent_NodeName: String;
         list: TOD_LIST;
      begin
           Parent:= _od_Parent;
           Parent_NodeName:= Parent.FullName;
           while   ('text:p'    = Parent_NodeName)
                 or('text:span' = Parent_NodeName)
           do
             begin
             {$IFDEF FPC}
             Parent:= Parent.ParentNode;
             {$ELSE}
             Parent:= Parent.Parent;
             {$ENDIF}
             Parent_NodeName:= Parent.FullName;
             end;
           //table:table-cell
           //Log.PrintLn( ClassName+'.AddHTML::Traite_ul: _od_Parent.FullName='+Parent.FullName);
           list:= TOD_LIST.Create( Self, Parent);
           try
              od_node:= list.e;
              if '' = list_style
              then
                  list_style:= list.Cree_Style;
           finally
                  FreeAndNil( list);
                  end;
      end;
      procedure Traite_li;
      //<style:style style:name="troc" style:family="paragraph" style:list-style-name="L1" style:parent-style-name="_5f_t_5f_Root_5f_Pied"/>
      var
         list_item: TOD_LIST_ITEM;
         p: TOD_PARAGRAPH;
         eStyle: TDOMNode;
      begin
           list_item:= TOD_LIST_ITEM.Create( Self, _od_Parent);
           try
              od_node:= list_item.e;
           finally
                  FreeAndNil( list_item);
                  end;
           p:= TOD_PARAGRAPH.Create( Self, od_node);
           try
              Traite_parsed_styles( p);
              od_node:= p.e;
              eStyle:= p.GetStyle_Automatique( _NomStyleParent);
              Set_Property( eStyle, 'style:list-style-name', list_style);
              NomStyle:= p.NomStyleApplique;
           finally
                  FreeAndNil( p);
                  end;
      end;
      procedure Traite_img;
      var
         src: String;
         NomFichierImage: String;
         Frame: TOD_FRAME;
         Image: TOD_IMAGE;
         procedure Traite_http;
         begin
              //<img alt="Menu creation order.png" src="http://wiki.lazarus.freepascal.org/images/6/69/Menu_creation_order.png" width="610" height="253">
              NomFichierImage:= OD_Temporaire.Nouveau_Extension( ChangeFileExt(ExtractFileName( src),''), ExtractFileExt( src));
              DownloadHTTP( src, NomFichierImage);
         end;
         procedure Traite_data;
         var
            mimetype: String;
            encodage: String;
            extension: String;
            ss: TStringStream;
            {$IFDEF FPC}
            bds: TBase64DecodingStream;
            {$ENDIF}
            fs: TFileStream;
         begin
              //<img src="data:image/png;base64,iVBO
              NomFichierImage:='';
              StrToK( 'data:', src);
              mimetype := StrToK( ';', src);
              encodage := StrToK( ',', src);

              extension:= Extension_from_mimetype( mimetype);
              if '' = extension then exit;

              NomFichierImage:= OD_Temporaire.Nouveau_Extension( 'IMG', extension);
              ss:= TStringStream.Create( src);
              try
                 {$IFDEF FPC}
                 bds:= TBase64DecodingStream.Create( ss);
                 try
                    fs:= TFileStream.Create( NomFichierImage, fmCreate);
                    try
                       fs.CopyFrom( bds, bds.Size);
                    finally
                           FreeAndNil( fs);
                           end;
                 finally
                        FreeAndNil( bds);
                        end;
                {$ELSE}
                fs:= TFileStream.Create( NomFichierImage, fmCreate);
                try
                   TNetEncoding.Base64.Decode( ss, fs);
                finally
                       FreeAndNil( fs);
                       end;
                {$ENDIF}
              finally
                     FreeAndNil( ss);
                     end;
         end;
      begin
           if not_Get_Property( _html_Parent, 'src', src) then exit;
                if 1=Pos('http:', src) then Traite_http
           else if 1=Pos('data:', src) then Traite_data
           else                             exit;

           if '' = NomFichierImage then exit;
           Frame:= TOD_FRAME.Create( Self, _od_Parent);
           try
              Image:= Frame.NewImage_as_Character( NomFichierImage);
              try
              finally
                     FreeAndNil( Image);
                     end;
           finally
                  FreeAndNil( Frame);
                  end;
      end;
      procedure Parse_html_style;
      var
         ss: TStringStream;
      begin
           p.sl.Clear;
           if '' = html_style then exit;

           ss:= TStringStream.Create( html_style);
           try
              try
                 p.Parse( ss);
              except
                    on E: Exception
                    do
                      Log.PrintLn( 'Echec de '+ClassName+'.AddHTML::Traite_html_node::Parse_html_style: '+html_style+#13#10+E.Message);
                    end;
           finally
                  FreeAndNil( ss);
                  end;
      end;
      procedure Traite_ChildNodes;
      var
         i: Integer;

         cn: {$IFDEF FPC}TDOMNodeList{$ELSE}TJclSimpleXMLElems{$ENDIF};
         n: TDOMNode;
      begin
           cn:= _html_Parent.{$IFDEF FPC}ChildNodes{$ELSE}Items{$ENDIF};
           for i:= 0 to cn.Count-1
           do
             begin
             n:= cn.Item[i];
             if nil = n then continue;
             Traite_html_node( od_node, n, NomStyle, list_style);
             end;
      end;
   begin
        NodeName:= _html_Parent.FullName;
        NodeValue:= _html_Parent.{$IFDEF FPC}NodeValue{$ELSE}Value{$ENDIF};

        //extraction rustique de la couleur, il faudrait extraire proprement tous les éléments de style html
        if ('#text' =NodeName) or uOD_JCL.not_Get_Property( _html_Parent, 'style', html_style) then html_style:= '';

        Parse_html_style;
        if _Gras then Set_Bold;

        od_node:= nil;
        NomStyle:= '';
        list_style:= _list_style;

             if '#text' =NodeName then Traite_text
        else if 'body'  =NodeName then begin end
        else if 'br'    =NodeName then Traite_br
        else if 'del'   =NodeName then Traite_span
        else if 'em'    =NodeName then Traite_em
        else if 'head'  =NodeName then begin end
        else if 'html'  =NodeName then begin end
        else if 'img'   =NodeName then Traite_img
        else if 'ins'   =NodeName then Traite_span
        else if 'li'    =NodeName then Traite_li
        else if 'p'     =NodeName then Traite_span //Traite_p text:p can't be nested
        else if 'span'  =NodeName then Traite_span
        else if 'strong'=NodeName then Traite_strong
        else if 'title' =NodeName then begin end
        else if 'u'     =NodeName then Traite_u
        else if 'ul'    =NodeName then Traite_ul
        else                           AddText_( _od_Parent, 'balise html non geree: <'+_html_Parent.FullName+'>'#13#10);

        if nil = od_node then od_node:= _od_Parent;
        if '' = NomStyle then NomStyle:= _NomStyleParent;

        Traite_ChildNodes;
   end;
   procedure Traite_html_ChildNodes;
   var
      i: Integer;
      cn: {$IFDEF FPC}TDOMNodeList{$ELSE}TJclSimpleXMLElems{$ENDIF};
      n: TDOMNode;
   begin
        cn:= html.{$IFDEF FPC}ChildNodes{$ELSE}Root.Items{$ENDIF};
        for i:= 0 to cn.Count-1
        do
          begin
          n:= cn.Item[i];
          if nil = n then continue;
          Traite_html_node( _e, n, '', '');
          end;
   end;
begin
     if not_Cree_html
     then
         begin
         AddText_( _e, _Value, _Gras);
         exit;
         end;
     try
        p:= TCSS_Style_Parser_PYACC.Create;
        try
           //Traite_html_node( _e, html.DocumentElement,'');
           //while Assigned( html_root)
           //do
           //  begin
           //  Traite_html_node( _e, html_root, '', '');
           //  html_root:=html_root.NextSibling;
           //  end;
           Traite_html_ChildNodes;
        finally
               FreeAndNil( p);
               end;
     finally
            FreeAndNil( html);
            end;

end;


procedure TOpenDocument.AddText_( _Value: String; _Gras: Boolean= False);
begin
     AddText_( Get_xmlContent_TEXT, _Value, _Gras);
end;

procedure TOpenDocument.AddHtml(_Value: String; _Gras: Boolean= False);
begin
     AddHtml(Get_xmlContent_TEXT, _Value, _Gras);
end;


procedure TOpenDocument.Freeze_fields;
    procedure Traite_USER_FIELD_GET( _e: TJclSimpleXMLElem);
    var
       FieldName: String;
       I: Integer;
       Parent: TJclSimpleXMLElem;
       CONTAINER: TJclSimpleXMLElems;
       eSPAN: TJclSimpleXMLElem;
       Value: String;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'text:name', FieldName) then exit;

         Parent:= _e.Parent;
         if Parent= nil then exit;

         CONTAINER:= Parent.Items;
         if CONTAINER = nil then exit;

         I:= CONTAINER.IndexOf( _e);
         eSPAN:= CONTAINER.Insert( 'text:span', I);
         if eSPAN = nil then exit;

         Value:= Field_Value( FieldName);
         AddText_( eSPAN, Value, False);

         CONTAINER.Remove( _e);
    end;
    procedure Traite_DATE_TIME( _e: TDOMNode; _Root: TOD_Root_Styles; _sdtClass: TStyle_DateTime_class; _Default_Format: String);
    var
       I: Integer;
       DataStyleName, DateFixe: String;
       Parent: TJclSimpleXMLElem;
       CONTAINER: TJclSimpleXMLElems;
       eSPAN: TJclSimpleXMLElem;
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
       function Style_Format: String;
       var
          sdt: TStyle_DateTime;
       begin
            sdt:= _sdtClass.Create( Self, _Root, DataStyleName);
            try
               Result:= sdt.Format;
            finally
                   FreeAndNil( sdt);
                   end;
            if '' = Result
            then
                Result:= _Default_Format;
       end;
       function Value_from_: String;
       var
          sFormat: String;
          d: TDateTime;
       begin
            d:= Now;
                  if '' = DataStyleName then sFormat:= _Default_Format
            else                             sFormat:=    Style_Format;
            Result:= FormatDateTime( sFormat, d);
       end;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'style:data-style-name', DataStyleName)
         then
             DataStyleName:='';

         if not_Get_Property( _e, 'text:fixed', DateFixe) // non utilisé pour l'instant
         then
             DateFixe:= '';

         Parent:= _e.Parent;
         if Parent= nil then exit;

         CONTAINER:= Parent.Items;
         if CONTAINER = nil then exit;

         I:= CONTAINER.IndexOf( _e);
         eSPAN:= CONTAINER.Insert( 'text:span', I);
         if eSPAN = nil then exit;

         Value:= Value_from_;
         //Insecable_to_Space;
         AddHtml( eSPAN, Value);

         CONTAINER.Remove( _e);
    end;
    procedure Traite_DATE( _e: TDOMNode; _Root: TOD_Root_Styles);
    begin
         Traite_DATE_TIME( _e, _Root, TStyle_Date, 'dddddd');
    end;
    procedure Traite_TIME( _e: TDOMNode; _Root: TOD_Root_Styles);
    begin
         Traite_DATE_TIME( _e, _Root, TStyle_Time, 'tt');
    end;
    procedure T( _e: TJclSimpleXMLElem; _Root: TOD_Root_Styles);
    var
       I: Integer;
    begin
         if _e = nil then exit;

              if _e.FullName = 'text:user-field-get' then Traite_USER_FIELD_GET( _e)
         else if _e.FullName = 'text:date'           then Traite_DATE( _e, _Root)
         else if _e.FullName = 'text:time'           then Traite_TIME( _e, _Root)
         else
             for I:= 0 to _e.Items.Count-1
             do
               T( _e.Items.Item[ I], _Root);
    end;
    procedure Efface_Declarations;
    var
       e: TJclSimpleXMLElem;
    begin
         e:= Get_xmlContent_USER_FIELD_DECLS;
         RemoveChilds( e);

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
     T( Get_xmlContent_TEXT, ors_xmlContent_AUTOMATIC_STYLES);
     T( Get_xmlStyles_MASTER_STYLES, ors_xmlStyles_AUTOMATIC_STYLES);
     Efface_Declarations;
end;

procedure TOpenDocument.Try_Delete_Style( _eStyle: TJclSimpleXMLElem);
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
   eSTYLES: TJclSimpleXMLElem;
   I: Integer;
   e: TJclSimpleXMLElem;
begin
     eSTYLES:= Get_xmlStyles_STYLES;
     I:= eSTYLES.Items.Count - 1;
     while I >= 0
     do
       begin
       e:= eSTYLES.Items.Item[ I];
       Try_Delete_Style( e);
       Dec( I);
       end;
end;

procedure TOpenDocument.Efface_Styles_Table( _NomTable: String);
var
   Prefixe: String;
   eAUTOMATIC_STYLES: TJclSimpleXMLElem;
   I: Integer;
   e: TJclSimpleXMLElem;
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
     I:= eAUTOMATIC_STYLES.Items.Count - 1;
     while I >= 0
     do
       begin
       e:= eAUTOMATIC_STYLES.Items.Item[ I];
       if Supprimer
       then
           Supprime_Item( e);
       Dec( I);
       end;
end;

function TOpenDocument.Named_Range_Cherche( _Nom: String): TJclSimpleXMLElem;
begin
     Result:= Cherche_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                            'table:named-range',
                            ['table:name'],
                            [_Nom        ]);
end;

function TOpenDocument.Named_Range_Assure( _Nom: String): TJclSimpleXMLElem;
begin
     Result:= Ensure_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                           'table:named-range',
                           ['table:name'],
                           [_Nom        ]);
end;

procedure TOpenDocument.Named_Range_Set( _Nom, _Base_Cell, _Cell_Range: String);
var
   e: TJclSimpleXMLElem;
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
   ePage_Layout_Properties: TJclSimpleXMLElem;
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

function TOpenDocument.FirstHeader: TJclSimpleXMLElem;
begin
     Result
     :=
       Elem_from_path( Get_xmlStyles_MASTER_STYLES, 'style:master-page/style:header');
end;

procedure TOpenDocument.Ensure_style_text_bold;
var
   e: TJclSimpleXMLElem;
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

function TOpenDocument.Append_SOFT_PAGE_BREAK( _eRoot: TJclSimpleXMLElem): TJclSimpleXMLElem;
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
      root, e: TDOMNode;
   begin
        //modification fichier mimetype
        mimetype:= sMIMETYPE;

        //modification manifest.xml
        root:= odeMETA_INF_manifest.xml.{$IFDEF FPC}DocumentElement{$ELSE}Root{$ENDIF};

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
