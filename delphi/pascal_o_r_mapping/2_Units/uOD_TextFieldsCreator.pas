unit uOD_TextFieldsCreator;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    Xml.XMLIntf,
    uOpenDocument,
  SysUtils, Classes, DB,
  Types;

type
 TOD_TextFieldsCreator
 =
  class
  //cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //Général
  public
    D: TOpenDocument;
  protected
    function Traite_Field( FieldName, FieldContent: String;
                           CreeTextFields: Boolean): Boolean;
  //Suppression des valeurs pour toute une sous-branche
  protected
    procedure Field_Vide_Branche( _Racine_FieldName: String);
  //création de champs à partir de tous les champs d'un dataset
  private
    function Execute_interne( _D: TDataset;
                              UtiliseValeurs, CreeTextFields, Prefixe: Boolean): Boolean;
                              overload;
  public
    //juste pour les tests
    class function OD_FieldName_from_DisplayLabel( DisplayLabel: String): String;

    function Execute_Modele( _D: TDataset; Nouveau_Modele: Boolean;
                             Prefixe: Boolean= False): Boolean;
                             overload;
    function Execute       ( _D: TDataset;
                             Prefixe: Boolean= False): Boolean;
                             overload;
  //création d'un seul champ
  private
    function Execute_interne( FieldName, FieldContent: String;
                              CreeTextFields: Boolean): Boolean;
                              overload;
  public
    function Execute_Modele( FieldName: String;
                             Nouveau_Modele: Boolean): Boolean;
                             overload;
    function Execute       ( FieldName, FieldContent: String): Boolean;
                             overload;
  // Création et lecture de paramètres
  public
    function Assure_Parametre( Nom, ValeurInitiale: String): Boolean;
  //Destruction de champs
  public
    procedure DetruitChamps( slListeChamps: TStringList);
  //Chercher/Remplacer sur les champs
  public
    procedure Search_and_Replace( _Search, _Replace_by: String;
                                  _KeepValue: Boolean= False); overload;
    procedure Search_and_Replace( _Search, _Replace_by: TStringDynArray;
                                  _KeepValue: Boolean= False); overload;
  //Chercher/Remplacer sur les champs
  public
    procedure Search_and_Replace_Value( _DisplayLabel: String;
                                        _Search, _Replace_by: TStringDynArray;
                                        _IgnoreCase: Boolean= True);
  end;

implementation

{ TOD_TextFieldsCreator }

constructor TOD_TextFieldsCreator.Create( _D: TOpenDocument);
begin
     D:= _D;
end;

destructor TOD_TextFieldsCreator.Destroy;
begin
     inherited;
end;

class function TOD_TextFieldsCreator.OD_FieldName_from_DisplayLabel( DisplayLabel: String): String;
var
   I: Integer;
begin
     Result:= DisplayLabel;
     for I:= 1 to Length( Result)
     do
       case Result[I]
       of
         ' ',  '''': Result[I]:= '_';
         end;
end;

function TOD_TextFieldsCreator.Traite_Field( FieldName,
                                             FieldContent: String;
                                             CreeTextFields: Boolean
                                             ): Boolean;
begin
     Result:= D.Traite_Field( FieldName, FieldContent, CreeTextFields);
end;

procedure TOD_TextFieldsCreator.Field_Vide_Branche( _Racine_FieldName: String);
begin
     D.Field_Vide_Branche( _Racine_FieldName);
end;

function TOD_TextFieldsCreator.Execute_interne( _D: TDataset;
                                                UtiliseValeurs,
                                                CreeTextFields, Prefixe: Boolean): Boolean;
var
   NbColonnes: Integer;
   I: Integer;
   Field: TField;
   sOD_FieldName    ,
   sOD_FieldContent : String;
   D_Owner: TComponent;
begin
     NbColonnes:= _D.FieldCount;

     for I:= 0 to NbColonnes-1
     do
       begin
       Field:= _D.Fields[I];
       sOD_FieldName:= OD_FieldName_from_DisplayLabel( Field.DisplayLabel);
       if Prefixe
       then
           begin
           sOD_FieldName:= _D.Name + '_' + sOD_FieldName;
           D_Owner:= _D.Owner;
           if Assigned( D_Owner)
           then
               sOD_FieldName:= D_Owner.Name + '_' + sOD_FieldName;
           end;
       if UtiliseValeurs
       then
           sOD_FieldContent:= Field.DisplayText
       else
           sOD_FieldContent:= sOD_FieldName;

       Traite_Field( sOD_FieldName, sOD_FieldContent, CreeTextFields);
       end;

     Result:= True;
end;

function TOD_TextFieldsCreator.Execute_interne( FieldName,
                                                FieldContent: String;
                                                CreeTextFields: Boolean): Boolean;
begin
     Traite_Field( FieldName, FieldContent, CreeTextFields);

     Result:= True;
end;

function TOD_TextFieldsCreator.Execute_Modele ( _D: TDataset;
                                                Nouveau_Modele: Boolean;
                                                Prefixe: Boolean= False): Boolean;
begin
     Result:= Execute_interne( _D, False, Nouveau_Modele, Prefixe);
end;

function TOD_TextFieldsCreator.Execute        ( _D: TDataset;
                                                Prefixe: Boolean= False): Boolean;
begin
     Result:= Execute_interne( _D, True, False, Prefixe);
end;

function TOD_TextFieldsCreator.Execute_Modele ( FieldName: String;
                                                Nouveau_Modele: Boolean): Boolean;
begin
     Result:= Execute_interne( FieldName, FieldName, Nouveau_Modele);
end;

function TOD_TextFieldsCreator.Execute        ( FieldName,
                                                FieldContent: String): Boolean;
begin
     Result:= Execute_interne( FieldName, FieldContent, False);
end;

function TOD_TextFieldsCreator.Assure_Parametre( Nom, ValeurInitiale: String): Boolean;
begin
     Result:= D.Existe( Nom);
     if Result then exit;

     Result:= Execute_interne( Nom, ValeurInitiale, False);
end;

procedure TOD_TextFieldsCreator.DetruitChamps( slListeChamps: TStringList);
var
   I: Integer;
begin
     for I:= 0 to slListeChamps.Count - 1
     do
       D.DetruitChamp( slListeChamps[I]);
end;

procedure TOD_TextFieldsCreator.Search_and_Replace( _Search, _Replace_by: String;
                                                    _KeepValue: Boolean= False);
   procedure Avant_Apres_decl( _Avant, _Apres: String);
      procedure Traite_Root( _Root: IXMLNode);
      var
         e: IXMLNode;
         function Get_Item_Apres: Boolean;
         var
            eApres: IXMLNode;
         begin
              eApres:= D.Cherche_Item_Recursif( _Root,'text:user-field-decl',
                                           ['office:value-type', 'text:name'],
                                           ['string'           , _Apres]);
              Result:= Assigned( eApres);
         end;
         function Get_Item: Boolean;
         begin
              e:= D.Cherche_Item_Recursif( _Root,'text:user-field-decl',
                                           ['office:value-type', 'text:name'],
                                           ['string'           , _Avant]);
              Result:= Assigned( e);
         end;
      begin
           //Mise à jour de la déclaration. on garde la boucle du Avant_Apres_get
           // mais à priori on y passe qu'une fois
           while Get_Item
           do
             begin
             if Get_Item_Apres //l'item cible existe déjà, on supprime pour ne pas avoir de doublon
             then
                 D.Supprime_Item( e)
             else
                 begin
                 D.Set_Property( e, 'text:name'          , _Apres);
                 if not _KeepValue
                 then
                     D.Set_Property( e, 'office:string-value', _Apres);
                 end;
             end;
      end;
   begin
        Traite_Root( D.xmlContent.DocumentElement);
        Traite_Root( D.xmlStyles .DocumentElement);

        //On assure que le paramètre sera déclaré même si la boucle précédente
        //ne l'a pas trouvé
        Assure_Parametre( _Apres, _Apres);

        D.DetruitChamp( _Avant);
   end;
   procedure Avant_Apres_get( _Avant, _Apres: String);
      procedure Traite_Root( _Root: IXMLNode);
      var
         e: IXMLNode;
         function Get_Item: Boolean;
         begin
              e:= D.Cherche_Item_Recursif( _Root,'text:user-field-get',
                                           ['text:name'],[_Avant]);
              Result:= Assigned( e);
         end;
      begin
           while Get_Item
           do
             begin
             e.Text:= _Apres;
             D.Set_Property( e, 'text:name', _Apres);
             end;
      end;
   begin
        Traite_Root( D.xmlContent.DocumentElement);
        Traite_Root( D.xmlStyles .DocumentElement);
   end;
begin
     Avant_Apres_decl( _Search, _Replace_by);
     Avant_Apres_get ( _Search, _Replace_by);
end;

procedure TOD_TextFieldsCreator.Search_and_Replace( _Search, _Replace_by: TStringDynArray;
                                                    _KeepValue: Boolean= False);
var
   I: Integer;
   Search, Replace_By: String;
begin
     if Length( _Search) <> Length( _Replace_by) then exit;

     for I:= Low( _Search) to High( _Search)
     do
       begin
       Search    := _Search    [I];
       Replace_By:= _Replace_by[I];
       Search_and_Replace( Search, Replace_By, _KeepValue);
       end;
end;

procedure TOD_TextFieldsCreator.Search_and_Replace_Value( _DisplayLabel: String;
                                                          _Search,
                                                          _Replace_by: TStringDynArray;
                                                          _IgnoreCase: Boolean= True);
var
   Flags: TReplaceFlags;
   function Do_Search_Replace( _Value: String): String;
   var
      I: Integer;
      Avant, Apres: String;
   begin
        Result:= _Value;
        for I:= Low( _Search) to High(_Search)
        do
          begin
          Avant:= _Search[I];
          Apres:= _Replace_by[I];
          Result:= StringReplace( Result, Avant, Apres, Flags);
          end;
   end;
   procedure Traite_Root( _Root: IXMLNode);
   var
      e: IXMLNode;
      Value: String;
      function Get_Item: Boolean;
      begin
           e:= D.Cherche_Item_Recursif( _Root,'text:user-field-decl',
                                        ['office:value-type', 'text:name'  ],
                                        ['string'           , _DisplayLabel]);
           Result:= Assigned( e);
      end;
   begin
        //Mise à jour de la déclaration. on garde la boucle du Avant_Apres_get
        // mais à priori on y passe qu'une fois
        if not Get_Item then exit;

        if D.not_Get_Property( e, 'office:string-value', Value) then exit;

        Value:= Do_Search_Replace( Value);
        D.Set_Property( e, 'office:string-value', Value);
   end;
begin
     Flags:= [rfReplaceAll];
     if _IgnoreCase
     then
         Flags:= Flags+[rfIgnoreCase];
     Traite_Root( D.xmlContent.DocumentElement);
     Traite_Root( D.xmlStyles .DocumentElement);
end;

end.
