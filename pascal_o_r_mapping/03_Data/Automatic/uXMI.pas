unit uXMI;

{$mode objfpc}{$H+}

interface

uses
    uOD_JCL,
 Classes, SysUtils, XMLRead, DOM;

type

  { TXMI }

  TXMI
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _Filename: String);
     destructor Destroy; override;
   //Attributs
   public
     Filename: String;
     xml: {$IFDEF FPC}TXMLDocument{$ELSE}TJclSimpleXml{$ENDIF};
   //Méthodes
   public
     function Get_Model: TDOMNode;
     function Get_Model_Logical_View: TDOMNode;
   //éléments du modèle
   public
     function Get_Classes: TCherche_Items_Recursif;
     function Get_Associations: TCherche_Items_Recursif;
   //éléments d'une classe
   public
     function Get_Class_Properties( _Classe: TDOMNode): TCherche_Items_Recursif;
     function Get_Class_Operations( _Classe: TDOMNode): TCherche_Items_Recursif;
   //éléments d'une association
   public
     function Get_Association_ends( _Association: TDOMNode): TCherche_Items_Recursif;
   //recherche d'un type
   public
     function Get_type( _type: string): TDOMNode;
   end;

implementation

{ TXMI }

constructor TXMI.Create( _Filename: String);
begin
     Filename:= _Filename;
     ReadXMLFile( xml, Filename);
end;

destructor TXMI.Destroy;
begin
     FreeAndNil( xml);
     inherited Destroy;
end;

function TXMI.Get_Model: TDOMNode;
begin
     Result:= Elem_from_path( xml.DocumentElement, 'uml:Model');
end;

function TXMI.Get_Model_Logical_View: TDOMNode;
begin
     Result
     :=
       Cherche_Item
         (
         Get_Model,
         'packagedElement',
         ['xmi:type' ,'xmi:id'      ],
         ['uml:Model','Logical_View']
         );
end;

function TXMI.Get_Classes: TCherche_Items_Recursif;
begin
     Result
     :=
       TCherche_Items_Recursif.Create
         ( Get_Model_Logical_View,'packagedElement', ['xmi:type'], ['uml:Class']);
end;

function TXMI.Get_Associations: TCherche_Items_Recursif;
begin
     Result
     :=
       TCherche_Items_Recursif.Create
         ( Get_Model_Logical_View,'packagedElement', ['xmi:type'], ['uml:Association']);
end;

function TXMI.Get_Class_Properties( _Classe: TDOMNode): TCherche_Items_Recursif;
begin
     Result
     :=
       TCherche_Items_Recursif.Create
         ( _Classe,'ownedAttribute', ['xmi:type'], ['uml:Property']);
end;

function TXMI.Get_Class_Operations( _Classe: TDOMNode): TCherche_Items_Recursif;
begin
     Result
     :=
       TCherche_Items_Recursif.Create
         ( _Classe,'ownedOperation', ['xmi:type'], ['uml:Operation']);
end;

function TXMI.Get_Association_ends( _Association: TDOMNode): TCherche_Items_Recursif;
begin
     Result
     :=
       TCherche_Items_Recursif.Create
         ( _Association,'ownedEnd', ['xmi:type'], ['uml:AssociationEnd']);
end;

function TXMI.Get_type(_type: string): TDOMNode;
begin
     Result
     :=
       Cherche_Item_Recursif
         ( Get_Model_Logical_View,'packagedElement', ['xmi:id'], [_type]);

end;

end.

