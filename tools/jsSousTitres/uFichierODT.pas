unit uFichierODT;

{$mode objfpc}{$H+}

interface

uses
  uuStrings,
  uOpenDocument,
  uOD_JCL,
 Classes, SysUtils,fgl, DOM, Math;

type

 { TColonne }

 TColonne
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    i: Integer;
    sl: TStringList;
  end;
type
 TColonne_List= specialize TFPGObjectList<TColonne>;

type

 { TTableau }

 TTableau
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Nom  : String;
    Debut: Integer;
    e: TDOMNode;
    cl: TColonne_List;
    procedure Check_( var _iColonne: Integer);
    function Check( _iColonne: Integer): Integer;
  //Méthodes
  public
    procedure Charger;
  end;

type
 TTableau_List= specialize TFPGObjectList<TTableau>;

 { TFichierODT }

 TFichierODT
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    NomFichier: String;
    d: TOpenDocument;
    tl: TTableau_List;
  //Méthodes
  public
    procedure Charger( _NomFichier: String);
  end;

implementation

{ TColonne }

constructor TColonne.Create;
begin
     i:= 0;
     sl:= TStringList.Create;
end;

destructor TColonne.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

{ TTableau }

constructor TTableau.Create;
begin
     Nom  := '';
     Debut:= 0;
     e:= nil;
     cl:= TColonne_List.Create( True);
end;

destructor TTableau.Destroy;
begin
     FreeAndNil( cl);
     inherited Destroy;
end;

procedure TTableau.Check_( var _iColonne: Integer);
begin
     _iColonne:= Check( _iColonne);
end;

function TTableau.Check( _iColonne: Integer): Integer;
begin
     Result:= Min( _iColonne, cl.Count-1);
end;

procedure TTableau.Charger;
   procedure Boucle_Paragraphe( _eCell: TDOMNode; _iColonne: Integer);
   var
      c: TColonne;
      cir: TCherche_Items_Recursif;
      e: TDOMNode;
      s: String;
   begin
        s:= '';
        cir:= TCherche_Items_Recursif.Create( _eCell, 'text:p', [], []);
        try
           for e in cir.l
           do
             begin
             Formate_Liste( s, ' ', e.TextContent);
             end;
        finally
               FreeAndNil( cir);
               end;
        c:= cl[ _iColonne];
        c.sl.Add( s);
   end;
   procedure Boucle_Cell( _eRow: TDOMNode);
   var
      cir: TCherche_Items_Recursif;
      i: Integer;
      e: TDOMNode;
   begin
        cir:= TCherche_Items_Recursif.Create( _eRow, 'table:table-cell', [], []);
        try
           for i:= 0 to cir.l.Count-1
           do
             begin
             e:= cir.l.Items[i];
             Boucle_Paragraphe( e, i);
             end;
        finally
               FreeAndNil( cir);
               end;
   end;
   procedure Boucle_Row;
   var
      cir: TCherche_Items_Recursif;
      e: TDOMNode;
   begin
        cir:= TCherche_Items_Recursif.Create( Self.e, 'table:table-row', [], []);
        try
           for e in cir.l
           do
             Boucle_Cell( e);
        finally
               FreeAndNil( cir);
               end;
   end;
   procedure Principal;
   var
      cir: TCherche_Items_Recursif;
      e: TDOMNode;
      c: TColonne;
      sNumber_columns_repeated: String;
      procedure Cree_Colonnes;
      var
         Number_columns_repeated: Integer;
         i: Integer;
      begin
           if not TryStrToInt( sNumber_columns_repeated, Number_columns_repeated)
           then
               Number_columns_repeated:= 1;
           for i:= 1 to Number_columns_repeated
           do
             begin
             c:= TColonne.Create;
             cl.Add( c);
             end;
      end;
   begin
        cir:= TCherche_Items_Recursif.Create( Self.e, 'table:table-column', [], []);
        try
           for e in cir.l
           do
             begin
             if not_Get_Property( e, 'table:number-columns-repeated', sNumber_columns_repeated)
             then
                 sNumber_columns_repeated:= '1';
             Cree_Colonnes;
             end;
        finally
               FreeAndNil( cir);
               end;
        Boucle_Row;
   end;
begin
     Principal;
end;

{ TFichierODT }

constructor TFichierODT.Create;
begin
     d:= nil;
     tl:= TTableau_List.Create( True);
end;

destructor TFichierODT.Destroy;
begin
     FreeAndNil( d);
     FreeAndNil( tl);
     inherited Destroy;
end;

procedure TFichierODT.Charger( _NomFichier: String);
var
   cir: TCherche_Items_Recursif;
   e: TDOMNode;
   NomTableau: String;
   t: TTableau;
   Debut: Integer;
begin
     NomFichier:= _NomFichier;

     tl.Clear;
     FreeAndNil( d);
     d:= TOpenDocument.Create( NomFichier);

     Debut:= 0;
     cir:= TCherche_Items_Recursif.Create( d.Get_xmlContent_TEXT, 'table:table', [], []);
     try
        for e in cir.l
        do
          begin
          if not_Get_Property( e, 'table:name', NomTableau) then continue;

          t:= TTableau.Create;
          t.Nom:= NomTableau;
          t.Debut:= Debut;
          t.e:= e;
          tl.Add( t);
          t.Charger;
          Inc(Debut, t.cl[0].sl.Count);
          end;
     finally
            FreeAndNil( cir);
            end;
end;

end.

