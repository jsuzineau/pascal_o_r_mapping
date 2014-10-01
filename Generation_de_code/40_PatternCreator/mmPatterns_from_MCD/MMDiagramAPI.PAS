{
ModelMaker 7 code
Copyright (C) 1994-2004
ModelMaker Tools
http://www.modelmakertools.com

No part of this code may be used or copied without
written permission of ModelMaker Tools
}
unit MMDiagramAPI;

interface

uses SysUtils, Classes, MMEngineDefs, Windows;

const
// UML style visibility specifiers
  UMLVisibilitySpec: array[TVisibility] of Char = ('o', '~', '-', '§', '#', '+', '*', '=');

type
  TMMDiagramType = (diClassDiagram, diSequenceDiagram, diUseCaseDiagram,
                    diUnitDependencyDiagram, diActivityDiagram, diStateDiagram,
                    diImplementationDiagram, diMindMapDiagram, diCollaborationDiagram,
                    diRobustnessDiagram,
                    diDiagramFolder);
  TMMDiagramTypes = set of TMMDiagramType;

const
  AllMMDiagramTypes = [diClassDiagram, diSequenceDiagram, diUseCaseDiagram,
                       diUnitDependencyDiagram, diActivityDiagram, diStateDiagram,
                       diImplementationDiagram, diMindMapDiagram, diCollaborationDiagram,
                       diRobustnessDiagram];

  diNoDiagram = diDiagramFolder;

type
// Association end point style
  TMMClassAssocStyle = (casAuto, casUndefined, casAggregation, casComposition, casNavigable);
// Endpoint index type in IMMMemberVisualization properties like Multiplicity, RoleName etc.
  TMMAssocEndPoint = 1..2;

const
// For backward compatibility define masXXXX
  masAuto = casAuto;
  masUndefined = casUndefined;
  masAggregation = casAggregation;
  masComposition = casComposition;
  masNavigable = casNavigable;

type
  // Linkable entity types as used in HotLinkToEntity and AddEntityHyperlink
  // ID's of different entities are not exclusive, the type serves as qualifier for the ID.
  TLinkableEntity = (nttClass, nttMember, nttUnit, nttEventType, nttDiagram);

  TLinkableProp = (lpName, lpCategory, lpDocumentation, lpOneLiner, lpAbstract);
  TLinkableProps = set of TLinkableProp;

const
  lpStereotype = lpCategory;

type
  TPageOrientation = (poPortrait, poLandscape);
  TPageFormat = (pfA4, pfA3, pfA2, pfA1, pfA0,
                 psExecutive, psLetter, psFolio, psLegal, psTabloid);

  TSwimlaneOrientation = (sloVertical, sloHorizontal);

  TMessageKind = (mkGeneric, mkCall, mkAsync, mkReturn);

// References, used in diagrams and messages

  IMMReference = interface (IUnknown)
    ['{80E3CAE7-5B25-11D5-A500-0002B34B0C20}']
    function GetLocation: WideString; safecall;
    procedure Locate(DoShow: Boolean = False; DoFocus: Boolean = False); safecall;
    function Valid: Boolean; safecall;
    property Location: WideString read GetLocation;
  end;
  
  IMMEntityReference = interface (IMMReference)
    ['{80E3CAE8-5B25-11D5-A500-0002B34B0C20}']
    function GetEntityRef: IUnknown; safecall;
    property EntityRef: IUnknown read GetEntityRef;
  end;
  
  IMMSourceFileReference = interface (IMMReference)
    ['{80E3CAE9-5B25-11D5-A500-0002B34B0C20}']
    function GetColumn: Integer; safecall;
    function GetFileName: WideString; safecall;
    function GetLineNr: Integer; safecall;
    property Column: Integer read GetColumn;
    property FileName: WideString read GetFileName;
    property LineNr: Integer read GetLineNr;
  end;
  
  IMMSymbolLink = interface (IMMEntityReference)
    ['{B50A2DC2-8040-419A-8A1F-E6386F053C54}']
    {:
    Deletes the hyperlink and clears the HotLink if the Hyperlink is the Hotlink.
    If the hyperlink is locked, the call has no effect.
    }
    procedure Delete; safecall;
    function GetIsHotlink: Boolean; safecall;
    function GetIsLocked: Boolean; safecall;
    function GetNavigable: Boolean; safecall;
    function GetSelectable: Boolean; safecall;
    {:
    Invokes the 'Navigate to' logic.
    }
    procedure Navigate; safecall;
    {:
    Invokes the 'Select entity' logic.
    }
    procedure Select; safecall;
    procedure SetNavigable(Value: Boolean); safecall;
    procedure SetSelectable(Value: Boolean); safecall;
    {:
    Returns true if this link is the symbol's HotLink.
    }
    property IsHotlink: Boolean read GetIsHotlink;
    {:
    Returns true if this link is the symbol's HotLink and the symbol does not allow
    deleting the or allows only limited sets of entity types. Such as in a class symbol
    which only accepts links to existing classes.
    }
    property IsLocked: Boolean read GetIsLocked;
    {:
    Returns / Modifies the navigable property of the link.
    }
    property Navigable: Boolean read GetNavigable write SetNavigable;
    {:
    Returns / Modifies the Selectable property of the link.
    }
    property Selectable: Boolean read GetSelectable write SetSelectable;
  end;
  
  IMMDiagramExplorer = interface;

  IMMDiagram = interface (IUnknown)
    ['{1BE5B6F1-EE4A-11D2-AA5B-204C4F4F5020}']
    function CreateMetaFile: HENHMETAFILE; safecall;
    function CreatePrintSchemeMF: HENHMETAFILE; safecall;
    procedure Delete; safecall;
    function Edit: Boolean; safecall;
    {:
    The interface returned by Explore gives access to all symbols and associations on a 
    diagram.
    Note: each time Explore is called the diagram is re-explored and a different
    set of symbols is created.
    }
    function Explore: IMMDiagramExplorer; safecall;
    {:
    ExportAsImage recognizes the .png .bmp .jpg and .wmf extensions. Other extensions are 
    ignored
    }
    function ExportAsImage(const ImageFileName: wideString): Boolean; safecall;
    function GetContentsAsXML: WideString; safecall;
    function GetDiagramType: TMMDiagramType; safecall;
    function GetID: Integer; safecall;
    function GetName: WideString; safecall;
    function GetParent: IMMDiagram; safecall;
    function GetValid: Boolean; safecall;
    {:
    Print uses the current printing scheme and DiagramPrintOptions. To modify these 
    options,
    use EnvOptions: IMMOptions with keys 'DiagramPrintOptions\xyz' and 
    'DiagramPrintStyle\xyz'
    }
    procedure Print; safecall;
    procedure SetName(const Value: WideString); safecall;
    property ContentsAsXML: WideString read GetContentsAsXML;
    property DiagramType: TMMDiagramType read GetDiagramType;
    property ID: Integer read GetID;
    property Name: WideString read GetName write SetName;
    property Parent: IMMDiagram read GetParent;
    property Valid: Boolean read GetValid;
  end;
  
  IMMDiagramManager = interface (IUnknown)
    ['{1BE5B6F2-EE4A-11D2-AA5B-204C4F4F5020}']
    function AddDiagram(DiagType: TMMDiagramType): IMMDiagram; overload; safecall;
    function AddDiagram(DiagType: TMMDiagramType; const Name: WideString; Parent: 
            Integer): IMMDiagram; overload; safecall;
    procedure DeleteDiagram(Index: Integer); safecall;
    function FindDiagram(ID: Integer; var Index: Integer): Boolean; safecall;
    function GetDiagramCount: Integer; safecall;
    function GetDiagrams(Index: Integer): IMMDiagram; safecall;
    function GetValid: Boolean; safecall;
    {:
    Prints diagrams using the current DiagramPrintOptions and DiagramPrintStyle
    To modify these use EnvOptions: IMMOptions with keys 'DiagramPrintOptions\xyz'
    and 'DiagramPrintStyle\xyz'
    }
    procedure PrintDiagrams(List: IInterfaceList); safecall;
    property DiagramCount: Integer read GetDiagramCount;
    property Diagrams[Index: Integer]: IMMDiagram read GetDiagrams;
    property Valid: Boolean read GetValid;
  end;
  
  IMMShape = interface (IUnknown)
    ['{E78F1061-F508-41C1-AC23-1D9B1999F605}']
    {:
    Adds a hyperlink to the entity.
    }
    function AddEntityHyperlink(EntityType: TLinkableEntity; EntityID: Integer): 
            IMMSymbolLink; safecall;
    {:
    Add a hyperlink to the external document.
    }
    function AddExternalDocHyperlink(const FileName: WideString): IMMSymbolLink; safecall;
    {:
    Changes Z-Order of symbols.
    }
    procedure BringToFront; safecall;
    {:
    Deletes the symbol from the diagram. If the symbol contains other symbols, these are
    deleted too.
    }
    procedure Delete; safecall;
    {:
    Invokes dialog editing the shape.
    }
    function Edit: Boolean; safecall;
    function GetCategory: WideString; safecall;
    function GetDocumentation: WideString; safecall;
    function GetHotLink: IMMReference; safecall;
    function GetHyperlinkCount: Integer; safecall;
    function GetHyperlinks(Index: Integer): IMMSymbolLink; safecall;
    function GetIsAbstract: Boolean; safecall;
    function GetLinkedProps: TLinkableProps; safecall;
    function GetName: WideString; safecall;
    function GetOneLiner: WideString; safecall;
    function GetPropValue(const PropName: WideString): WideString; safecall;
    function GetShapeIndex: Integer; safecall;
    function GetSymbolStyle: WideString; safecall;
    function GetTaggedValueCount: Integer; safecall;
    function GetTaggedValueNames(Index: Integer): WideString; safecall;
    function GetTaggedValues(const TagName: WideString): WideString; safecall;
    function GetTypeName: WideString; safecall;
    function GetValid: Boolean; safecall;
    {:
    Returns bounding rectangle for shape and it's adornments. Note that IMMSymbol.Bounds
    only returns the symbol's rectangle, and does ot include any adornments that might be
    located outside this main symbol bounds (for example: actorsymbol's name will be
    contained in GetVisualRect, but not in Bounds.
    }
    procedure GetVisualRect(var R: TRect); safecall;
    function GetVisualStyle: WideString; safecall;
    {:
    Adds a hyperlink to the entity and marks it as hotlink. An existing hotlink is
    deleted. If an existing hotlink does not allow deletion (locked type), and the entity
    type is accepted by the symbo, the existing hotlink will be relinked to the entity.
    If hotlink type is not supported, the call has no effect.
    }
    function HotlinkToEntity(EntityType: TLinkableEntity; EntityID: Integer): 
            IMMSymbolLink; safecall;
    {:
    Moves the shape dx, dy. For Associations this moves the shape nodes.
    }
    procedure Move(dX, dY: Integer); safecall;
    {:
    Changes Z-Order, see also BringToFront.
    }
    procedure SendToBack; safecall;
    procedure SetCategory(const Value: WideString); safecall;
    procedure SetDocumentation(const Value: WideString); safecall;
    procedure SetIsAbstract(Value: Boolean); safecall;
    procedure SetLinkedProps(Value: TLinkableProps); safecall;
    procedure SetName(const Value: WideString); safecall;
    procedure SetOneLiner(const Value: WideString); safecall;
    procedure SetPropValue(const PropName: WideString; const Value: WideString); safecall;
    procedure SetSymbolStyle(const Value: WideString); safecall;
    procedure SetTaggedValues(const TagName: WideString; const Value: WideString); 
            safecall;
    procedure SetVisualStyle(const Value: WideString); safecall;
    {:
    Returns and modifies category. If shape is hotlinked, also modifies the hotlinked
    entity's category.
    }
    property Category: WideString read GetCategory write SetCategory;
    {:
    Returns and modifies documentation. If shape is hotlinked, also modifies the
    hotlinked entity's documentation.
    }
    property Documentation: WideString read GetDocumentation write SetDocumentation;
    {:
    Returns the hyperlink marked as HotLink. Can be nil.
    }
    property HotLink: IMMReference read GetHotLink;
    {:
    Returns number of hyperlinks including the hotlink (if any)
    }
    property HyperlinkCount: Integer read GetHyperlinkCount;
    {:
    Returns the hyperlinks including the hotlink.
    }
    property Hyperlinks[Index: Integer]: IMMSymbolLink read GetHyperlinks;
    {:
    Returns and modifies abstract state. If shape is hotlinked, also modifies the
    hotlinked entity's abstract state.
    }
    property IsAbstract: Boolean read GetIsAbstract write SetIsAbstract;
    {:
    Returns and modifies hot linked properties.
    }
    property LinkedProps: TLinkableProps read GetLinkedProps write SetLinkedProps;
    {:
    Returns and modifies Name. If shape is hotlinked, also modifies the hotlinked
    entity's Name.
    Since the name is usually the entity's key, there are two ways a hotlinked shape can
    react to changing the name:
    -1- rename the linked entity (class symbol, package symbol linked to unit)
    -2- relink to an entity with that name. (most symbols).
    }
    property Name: WideString read GetName write SetName;
    {:
    Returns and modifies OneLiner. If shape is hotlinked, also modifies the hotlinked
    entity's OneLiner.
    }
    property OneLiner: WideString read GetOneLiner write SetOneLiner;
    {:
    Reads/Writes a property of the symbol. Property names depend on the shape type.
    Property names are identical to the attributes as used in the xml format as used in
    copy to clipboard and export diagrams.
    }
    property PropValue[const PropName: WideString]: WideString read GetPropValue write 
            SetPropValue;
    {:
    Returns the index of this shape in the Explorer's Shapes property. -1 is returned if
    the shape is invalid.
    }
    property ShapeIndex: Integer read GetShapeIndex;
    {:
    Returns the symbol style (which members are displayed etc) as a list of name=value
    pairs.
    To modify the symbol style, read the style into a TStrings, modifiy the appropriate
    Values[] and write back the entire TStrings.Text.
    }
    property SymbolStyle: WideString read GetSymbolStyle write SetSymbolStyle;
    {:
    Returns the number of (external) tagged values stored with this shape.
    }
    property TaggedValueCount: Integer read GetTaggedValueCount;
    {:
    Returns tha tagged value names.
    }
    property TaggedValueNames[Index: Integer]: WideString read GetTaggedValueNames;
    {:
    Reads/writes tagged values. External applications can store additional data in this
    property.
    The TagName should be unique identifier. The best way to garantuee this is to use
    names like: "myexpertname.propname". Expert names (as defined by IMMExpert) must be
    unqiue and therefore the property names will be garantueed to be unique.
    }
    property TaggedValues[const TagName: WideString]: WideString read GetTaggedValues 
            write SetTaggedValues;
    {:
    Returns the shape's typename which is identical to the xml tag name.
    }
    property TypeName: WideString read GetTypeName;
    {:
    Returns True if the shape is connected to the actual internal symbol. A shape might
    be deleted but still be referred to in the expert. In this case Valid will return 
    False.
    }
    property Valid: Boolean read GetValid;
    {:
    Returns the visual style (colors and fonts) as a list of name=value pairs.
    To modify the visual style, read the style into a TStrings, modifiy the appropriate 
    Values[] and write back the entire TStrings.Text.
    }
    property VisualStyle: WideString read GetVisualStyle write SetVisualStyle;
  end;
  
  {:
  }
  IMMSymbol = interface (IMMShape)
    ['{E0F0EED9-9E6B-4202-89A2-C58EAB32F5A2}']
    {:
    Invokes the auto arrange associations logic.
    }
    procedure ArrangeAssociations; safecall;
    {:
    Performs an auto size without actually modifying the AutoSizeX/Y properties.
    }
    procedure AutoSize(Width, Height: Boolean); safecall;
    function GetAutoSizeX: Boolean; safecall;
    function GetAutoSizeY: Boolean; safecall;
    function GetBounds: TRect; safecall;
    function GetExtent: TPoint; safecall;
    function GetHeight: Integer; safecall;
    function GetLocation: TPoint; safecall;
    function GetParent: IMMSymbol; safecall;
    function GetWidth: Integer; safecall;
    procedure SetAutoSizeX(Value: Boolean); safecall;
    procedure SetAutoSizeY(Value: Boolean); safecall;
    procedure SetExtent(Value: TPoint); safecall;
    procedure SetHeight(Value: Integer); safecall;
    procedure SetLocation(Value: TPoint); safecall;
    procedure SetWidth(Value: Integer); safecall;
    {:
    AutoSizeX will auto update the width of a symbol. The Width property will returns the
    actual width, but cannot be used to modify the width.
    }
    property AutoSizeX: Boolean read GetAutoSizeX write SetAutoSizeX;
    {:
    AutoSizeY will auto update the height of a symbol. The Height property will return
    the actual height, but if AutoSizeY = True it  cannot be used to modify the height.
    }
    property AutoSizeY: Boolean read GetAutoSizeY write SetAutoSizeY;
    {:
    Returns the bounding rectangle of the symbol. Does not include adornments outside the
    symbol.
    See also IMMShape.GetVisualRect
    }
    property Bounds: TRect read GetBounds;
    {:
    Used to read write the symbol's Extent = Point(Width, Height). See remarks on Height
    and Width with repespect to AutoSizeX/Y.
    }
    property Extent: TPoint read GetExtent write SetExtent;
    {:
    Used to read write the symbol's Height. If AutoSizeY is True, writing to this
    property is ignored. Values are auto adjusted to the grid.
    }
    property Height: Integer read GetHeight write SetHeight;
    {:
    Reads/writes the symbol's location. Will be auto adjusted to the grid.
    }
    property Location: TPoint read GetLocation write SetLocation;
    {:
    The containing parent symbol. Usually "nil" meaning that the symbol is owned by the
    diagram itself.
    }
    property Parent: IMMSymbol read GetParent;
    {:
    Used to read write the symbol's Width. If AutoSizeX is True, writing to this property
    is ignored. Values are auto adjusted to the grid.
    }
    property Width: Integer read GetWidth write SetWidth;
  end;
  
  {:
  Role symbols in sequence diagrams can be cast as IMMRoleSymbol
  }
  IMMRoleSymbol = interface (IMMSymbol)
    ['{FDE159CC-9391-438D-BDE8-9FD48E0ABEB0}']
    function GetActivations: WideString; safecall;
    procedure SetActivations(const Value: WideString); safecall;
    {:
    Activations returns a list of activations formatted as
    "(start1,end1)(start2,end2)...(startn,endn)" (omit quotes)
    }
    property Activations: WideString read GetActivations write SetActivations;
  end;
  
  IMMAssociation = interface (IMMShape)
    ['{2EECD1E9-5320-472C-B225-F9ABED926EBF}']
    procedure ArrangeAnchors; safecall;
    function GetSourceShape: IMMShape; safecall;
    function GetTargetShape: IMMShape; safecall;
    function IsRecurrent: Boolean; safecall;
    {:
    Resets anchors and (re-)connects the association to the centre of the connected
    symbols.
    }
    procedure ResetAnchors; safecall;
    {:
    Returns the shape (either symbol or association) at the beginning of the association
    path.
    }
    property SourceShape: IMMShape read GetSourceShape;
    {:
    Returns the shape (either symbol or association) at the end of the association path.
    }
    property TargetShape: IMMShape read GetTargetShape;
  end;
  
  IMMClassAssociation = interface (IMMShape)
    ['{3AE2AE74-A7B2-459A-B866-B871835B6A9F}']
    function GetAssocClassID: Integer; safecall;
    function GetID: Integer; safecall;
    function GetIndex: Integer; safecall;
    function GetSourceClassID: Integer; safecall;
    function GetSourceMultiplicity: WideString;
    function GetSourceQualifier: WideString;
    function GetSourceRole: WideString;
    function GetSourceStyle: TMMClassAssocStyle;
    function GetTargetClassID: Integer; safecall;
    function GetTargetMultiplicity: WideString;
    function GetTargetQualifier: WideString;
    function GetTargetRole: WideString;
    function GetTargetStyle: TMMClassAssocStyle;
    procedure SetAssocClassID(const Value: Integer); safecall;
    procedure SetSourceClassID(const Value: Integer); safecall;
    procedure SetSourceMultiplicity(const Value: WideString);
    procedure SetSourceQualifier(const Value: WideString);
    procedure SetSourceRole(const Value: WideString);
    procedure SetSourceStyle(Value: TMMClassAssocStyle);
    procedure SetTargetClassID(const Value: Integer); safecall;
    procedure SetTargetMultiplicity(const Value: WideString);
    procedure SetTargetQualifier(const Value: WideString);
    procedure SetTargetRole(const Value: WideString);
    procedure SetTargetStyle(Value: TMMClassAssocStyle);
    property AssocClassID: Integer read GetAssocClassID write SetAssocClassID;
    property ID: Integer read GetID;
    property Index: Integer read GetIndex;
    property SourceClassID: Integer read GetSourceClassID write SetSourceClassID;
    property SourceMultiplicity: WideString read GetSourceMultiplicity write 
            SetSourceMultiplicity;
    property SourceQualifier: WideString read GetSourceQualifier write SetSourceQualifier;
    property SourceRole: WideString read GetSourceRole write SetSourceRole;
    property SourceStyle: TMMClassAssocStyle read GetSourceStyle write SetSourceStyle;
    property TargetClassID: Integer read GetTargetClassID write SetTargetClassID;
    property TargetMultiplicity: WideString read GetTargetMultiplicity write 
            SetTargetMultiplicity;
    property TargetQualifier: WideString read GetTargetQualifier write SetTargetQualifier;
    property TargetRole: WideString read GetTargetRole write SetTargetRole;
    property TargetStyle: TMMClassAssocStyle read GetTargetStyle write SetTargetStyle;
  end;
  
  IMMClassAssocManager = interface (IUnknown)
    ['{CE8D7278-5592-4EC0-BDA0-7870752B1F08}']
    function Add(SourceClassID, TargetClassID: Integer): IMMClassAssociation; safecall;
    procedure Delete(Index: Integer); safecall;
    function GetAssociations(Index: Integer): IMMClassAssociation; safecall;
    function GetCount: Integer; safecall;
    function IndexOfAssoc(AssocID: Integer): Integer; safecall;
    property Associations[Index: Integer]: IMMClassAssociation read GetAssociations; 
            default;
    property Count: Integer read GetCount;
  end;
  
  IMMShapeExplorer = interface (IUnknown)
    ['{A7A6CCB0-424C-496B-B3B5-2AE7AA14EA13}']
    function GetAssociationCount: Integer; safecall;
    function GetAssociations(Index: Integer): IMMAssociation; safecall;
    function GetShapeCount: Integer; safecall;
    function GetShapes(Index: Integer): IMMShape; safecall;
    function GetSymbolCount: Integer; safecall;
    function GetSymbols(Index: Integer): IMMSymbol; safecall;
    {:
    Returns number of associations in diagram
    }
    property AssociationCount: Integer read GetAssociationCount;
    {:
    Returns association [Index]
    Use AssociationCount to iterate Associations.
    }
    property Associations[Index: Integer]: IMMAssociation read GetAssociations;
    {:
    Combines Symbols[] and Associations[].
    ShapeCount returns SymbolCount + AssociationCount.
    }
    property ShapeCount: Integer read GetShapeCount;
    {:
    Combines Symbols[] and Associations[]. Use ShapeCount to iterate Shapes.
    }
    property Shapes[Index: Integer]: IMMShape read GetShapes;
    {:
    Returns number of symbols in  diagram
    }
    property SymbolCount: Integer read GetSymbolCount;
    {:
    Returns symbols, use SymbolCount to iterate symbols.
    }
    property Symbols[Index: Integer]: IMMSymbol read GetSymbols;
  end;
  
  IMMDiagramPage = interface (IUnknown)
    ['{1CCDE101-9469-4937-9D0A-7B58A87B25AE}']
    function GetExtent: TPoint; safecall;
    function GetPageFormat: TPageFormat; safecall;
    function GetPageOrientation: TPageOrientation; safecall;
    function GetSymbolStyle: WideString; safecall;
    function GetValid: Boolean; safecall;
    function GetVisualStyle: WideString; safecall;
    {:
    Changes page size and orientation.
    }
    procedure SetPage(Format: TPageFormat; Orientation: TPageOrientation); safecall;
    procedure SetSymbolStyle(Value: WideString); safecall;
    procedure SetVisualStyle(Value: WideString); safecall;
    {:
    Returns the diagram extent in pixels.
    }
    property Extent: TPoint read GetExtent;
    {:
    Returns the page format (size). Use SetPage to modifiy both format and orientation at
    once.
    }
    property PageFormat: TPageFormat read GetPageFormat;
    {:
    Returns the page orientation: portrait or landscape. Use SetPage to modifiy both 
    format and orientation at once.
    }
    property PageOrientation: TPageOrientation read GetPageOrientation;
    {:
    Returns the default symbol style (which members are displayed etc) as a list of 
    name=value pairs.
    To modify the symbol style, read the style into a TStrings, modifiy the appropriate 
    Values[] and write back the entire TStrings.Text.
    }
    property SymbolStyle: WideString read GetSymbolStyle write SetSymbolStyle;
    {:
    Returns True is the page is associated with a diagram.
    }
    property Valid: Boolean read GetValid;
    {:
    Returns the default visual style (colors and fonts) as a list of name=value pairs. To 
    modify the visual style, read the style into a TStrings, modifiy the appropriate 
    Values[] and write back the entire TStrings.Text.
    }
    property VisualStyle: WideString read GetVisualStyle write SetVisualStyle;
  end;
  
  IMMDiagramExplorer = interface (IMMShapeExplorer)
    ['{44D510A7-F755-442F-AC19-3CB2F4FDF94C}']
    {:
    Commit will save all changes made to the explorer such added, modified or deleted 
    shapes. Without calling Commit, no modifications are stored. There's no need to call 
    UpdateShapes before calling Commit.
    }
    procedure Commit; safecall;
    {:
    Creates an association of TypeName between source and target. Usually the source and 
    target shapes are symbols, but a few associations can be connected to other
    associations (constraint and doclink)
    }
    function CreateAssociation(const TypeName: WideString; Source, Target: IMMShape): 
            IMMAssociation; safecall;
    {:
    Creates a symbol of TypeName. If the diagram does not accept this type, nil is 
    returned. If parent is not a valid parent for the symbol, the diagram will  be made
    parent.
    }
    function CreateSymbol(const TypeName: WideString; Parent: IMMSymbol): IMMSymbol; 
            safecall;
    function GetDiagramID: Integer; safecall;
    function GetPage: IMMDiagramPage; safecall;
    function GetValid: Boolean; safecall;
    {:
    Modified symbol or association properties will not automatically be reflected in size 
    and location. UpdateShapes will validate and reflect all modified properties. Note 
    that the UpdateShapes does not commit changes yet. If properties are only read or 
    written, there's no need to ever call UpdateShapes. Only if a write is followed by a 
    read, UpdateShapes will ensure the correct status.
    }
    procedure UpdateShapes; safecall;
    {:
    Returns the associated diagram's ID.
    }
    property DiagramID: Integer read GetDiagramID;
    {:
    Returns the diagram page which defines, page format, orientation and default visual 
    and symbol style.
    }
    property Page: IMMDiagramPage read GetPage;
    {:
    Returns true if explorer is connected to a diagram and can be used to access symbols 
    and associations.
    }
    property Valid: Boolean read GetValid;
  end;
  
  TMMDiagramNames = class (TObject)
  private
    function GetNames(Idx: TMMDiagramType): string;
  public
    property Names[Idx: TMMDiagramType]: string read GetNames; default;
  end;
  

var
  MMDiagramNames: TMMDiagramNames = nil;


function UMLVisSpecToVisibility(C: Char): TVisibility;

implementation

function UMLVisSpecToVisibility(C: Char): TVisibility;
var
  V: TVisibility;
begin
  for V := Low(TVisibility) to High(TVisibility) do
    if UMLVisibilitySpec[V] = C then
    begin
      Result := V;
      Exit;
    end;
  Assert(False);
  Result := scPublic;
end;

resourcestring
  SMMToolsApi_ClassDiagram = 'Class Diagram';
  SMMToolsApi_SequenceDiagram = 'Sequence Diagram';
  SMMToolsApi_UseCaseDiagram = 'Use Case Diagram';
  SMMToolsApi_PackageDiagram = 'Package Diagram';
  SMMToolsApi_ActivityDiagram = 'Activity Diagram';
  SMMToolsApi_StateDiagram = 'State Diagram';
  SMMToolsApi_ImplementationDiagram = 'Implementation Diagram';
  SMMToolsApi_MindMapDiagram = 'Mind Map Diagram';
  SMMToolsApi_CollaborationDiagram = 'Collaboration Diagram';
  SMMToolsApi_RobustnessDiagram = 'Robustness Diagram';
  SMMToolsApi_DiagramFolder = 'Folder';

{
************************************ TMMDiagramNames *************************************
}
function TMMDiagramNames.GetNames(Idx: TMMDiagramType): string;
begin
  case Idx of
    diClassDiagram: Result := SMMToolsApi_ClassDiagram;
    diSequenceDiagram: Result := SMMToolsApi_SequenceDiagram;
    diUseCaseDiagram: Result := SMMToolsApi_UseCaseDiagram;
    diUnitDependencyDiagram: Result := SMMToolsApi_PackageDiagram;
    diActivityDiagram: Result := SMMToolsApi_ActivityDiagram;
    diStateDiagram: Result := SMMToolsApi_StateDiagram;
    diImplementationDiagram: Result := SMMToolsApi_ImplementationDiagram;
    diMindMapDiagram: Result := SMMToolsApi_MindMapDiagram;
    diCollaborationDiagram: Result := SMMToolsApi_CollaborationDiagram;
    diRobustnessDiagram: Result := SMMToolsApi_RobustnessDiagram;
    diDiagramFolder: Result := SMMToolsApi_DiagramFolder;
  else
    Assert(False);
    Result := '';
  end;
end;

initialization
  MMDiagramNames := TMMDiagramNames.Create;
finalization
  MMDiagramNames.Free;
  MMDiagramNames := nil;
end.
