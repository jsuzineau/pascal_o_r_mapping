unit ucChampsGrid;
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
    uBatpro_StringList,
    ubtString,
    u_sys_,
    uDessin,
    uWinUtils,
    uForms,
    {$IFNDEF FPC}
    uWindows,
    {$ENDIF}
    uDataUtilsU,
    uChamps,
    uChampDefinitions,
    uChamp,
    uChampDefinition,
    ufChampsGrid_Colonnes,
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  SysUtils, Classes, Controls, DB, Grids,Dialogs, StdCtrls, Buttons, Graphics;

const
     CXEDGE= 10;
type
 TChampsGrid = class;

 TChampsGrid
 =
  class( TStringGrid)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Type de source
  private
    slbts_: Boolean;
    procedure _from_source;
  //Liste des TBatproElement
  private
    Fsl: TBatpro_StringList;
    procedure SetSL( Value: TBatpro_StringList);
  public
    property sl: TBatpro_StringList read Fsl write SetSL;
  //Arbre binaire des TBatproElement
  private
    Fbts: TbtString;
    procedure SetBTS( Value: TbtString);
  public
    property bts: TbtString read Fbts write SetBTS;
  //Gestion des entêtes de colonnes
  public
    function Definition( I: Integer): TChampDefinition;
    procedure Titres_from_Definitions;
  //Gestion des modifications
  private
    procedure Cellule_Vide(X, Y: Integer);
  //Rafraichissement
  public
    procedure Refresh_from_sl;
  //Récupération de la sélection
  public
    Classe_Elements: TClass; //pour le contrôle de type de bl
    procedure Get_bl_at_Row( _Row: Integer; var bl);
    procedure Get_bl( var bl);
    function Champ_from_XY( X, Y: Integer): TChamp;
    function Champ_courant: TChamp;
  //Gestion de l'affichage
  protected
    procedure DrawCell( ACol, ARow: Longint; ARect: TRect;
              AState: TGridDrawState); override;
  //Gestion du clic
  protected
    procedure Click; override;
  //Persistance
  private
    FPersistance: Boolean;
    procedure sbColonnesClick( Sender: TObject);
  protected
    sbColonnes: TSpeedButton;
    slColonnes: TBatpro_StringList;
    function  slColonnes_NomFichier: String;
    procedure slColonnes_Charge;
    procedure slColonnes_Sauve;
    procedure slColonnes_Assure;
  published
    property Persistance: Boolean read FPersistance write FPersistance;
  //Gestion des colonnes définies en dur
  private
    FColonnes: TStrings;
    procedure SetColonnes( Value: TStrings);
  published
    property Colonnes: TStrings read FColonnes write SetColonnes;
  //Nombre de colonne réel
  //ColCount ne peut pas être à 0, mais slColonnes si
  private
    FReal_ColCount: Integer;
    procedure SetReal_ColCount(const Value: Integer);
  public
    property Real_ColCount: Integer read FReal_ColCount write SetReal_ColCount;
    procedure Real_ColCount_from_slColonnes;
  //Gestion de la sélection
  protected
    function SelectCell(ACol, ARow: Longint): Boolean; override;
  //Recopie vers le bas
  public
    procedure Recopie_vers_le_bas;
  //Gestion de l'évènement d'insertion d'une ligne
  protected
    FOnNouveau: TNotifyEvent;
    procedure Do_OnNouveau;
  published
    property OnNouveau: TNotifyEvent read FOnNouveau write FOnNouveau;
  //Gestion du clavier
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  //Accés au données
  private
    procedure Initialise;
    function Donnees_indisponibles: Boolean;
    function NbLignes_from_Donnees: Integer;
    function Objects_from_Index( Index: Integer): TObject;
    function  Champs_from_Index( Index: Integer): TChamps;
    function  Index_from_Row( _Row: Integer): Integer;
    function Champs_from_Row( _Row: Integer): TChamps;
    function Premier_Champs: TChamps;
  end;

procedure Register;

implementation

uses uBinary_Tree;

procedure Register;
begin
     RegisterComponents('Batpro', [TChampsGrid]);
end;

{ TChampsGrid }

constructor TChampsGrid.Create(AOwner: TComponent);
var
   ButtonWidth: Integer;
begin
     inherited;
      FColonnes:= TBatpro_StringList.Create;
     slColonnes:= TBatpro_StringList.Create;

     ButtonWidth:= 10;//au pif//GetSystemMetrics(SM_CXVSCROLL);

     sbColonnes:= TSpeedButton.Create( Self);
     with sbColonnes do ControlStyle:= ControlStyle + [csReplicatable];
     sbColonnes.Width := ButtonWidth;
     sbColonnes.Height:= ButtonWidth;
     sbColonnes.Visible:= True;
     sbColonnes.Parent:= Self;
     sbColonnes.OnClick:= sbColonnesClick;
     //Bitmap:= Windows.LoadBitmap( 0, PChar(OBM_COMBO));
     //sbColonnes.Glyph.Handle:= Bitmap;
     sbColonnes.Cursor:= crArrow;

     Classe_Elements:= TObject;
     slbts_:= True;
     FPersistance:= True;
     Initialise;
end;

destructor TChampsGrid.Destroy;
begin
     slColonnes_Sauve;
     Initialise;
     Free_nil( slColonnes);
     Free_nil(  FColonnes);
     inherited;
end;

function TChampsGrid.Definition( I: Integer): TChampDefinition;
var
   O: TObject;
begin
     Result:= nil;
     if RowCount < 1 then exit;
     if (I < 0) or (Real_ColCount <= I) then exit;

     O:= Objects[ I, 0];
     if O = nil then exit;
     if not (O is TChampDefinition) then exit;

     Result:= TChampDefinition( O);
end;

procedure TChampsGrid.Cellule_Vide( X, Y: Integer);
begin
     Objects[ X, Y]:= nil;
     Cells  [ X, Y]:= sys_Vide;
end;

procedure TChampsGrid.Titres_from_Definitions;
var
   Champs: TChamps;
   ChampDefinitions: TChampDefinitions;
   I: Integer;
   Champ: TChamp;
   ChampDefinition: TChampDefinition;
   Champ_Nom  ,
   Champ_Titre: String;
begin
     Real_ColCount_from_slColonnes;

     Champs:= Premier_Champs;
     if Champs = nil then exit;

     ChampDefinitions:= Champs.ChampDefinitions;
     if ChampDefinitions = nil then exit;

     for I:= 0 to Real_ColCount - 1
     do
       begin
       Champ_Nom  := slColonnes.Names         [ I];
       Champ_Titre:= slColonnes.ValueFromIndex[ I];
       Champ:= Champs.Champ_from_Field( Champ_Nom);
       if Assigned( Champ)
       then
           begin
           ChampDefinition:= Champ.Definition;
           if Assigned( ChampDefinition)
           then
               begin
               Cells  [ I, 0]:= Champ_Titre;
               Objects[ I, 0]:= ChampDefinition;
               end;
           end;
       end;
end;

procedure TChampsGrid._from_source;
var
   NbLignes: Integer;
   Champs: TChamps;
   ChampDefinitions: TChampDefinitions;
begin
     slbts_:= Fbts = nil;

     RowCount:= 0;
     Real_ColCount:= 0;

     if Donnees_indisponibles then exit;

     NbLignes:= NbLignes_from_Donnees;
     if NbLignes = 0 then exit;

     slColonnes_Charge;

     Champs:= Premier_Champs;
     if Champs = nil then exit;

     ChampDefinitions:= Champs.ChampDefinitions;
     if ChampDefinitions = nil then exit;

     //Dimensionnement de la grille
     RowCount:= 1+ NbLignes;

     FixedRows:= 1;
     FixedCols:= 0;


     Titres_from_Definitions;

     Refresh_from_sl;
end;

procedure TChampsGrid.SetSL( Value: TBatpro_StringList);
begin
     //Desaffecte_source;
     Fsl:= Value;
     _from_source;
end;

procedure TChampsGrid.SetBTS(Value: TbtString);
begin
     //Desaffecte_source;
     Fbts:= Value;
     _from_source;
end;

procedure TChampsGrid.Refresh_from_sl;
var
   NbLignes    ,
   J: Integer;
   Champs: TChamps;
   IColonne: Integer;
   Champ_Nom: String;
   Champ: TChamp;
   ChampDefinition: TChampDefinition;
   L, LargeurColonne: Integer;
begin
     if Donnees_indisponibles then exit;

     NbLignes:= NbLignes_from_Donnees;
     if NbLignes = 0 then exit;

     Champs:= Premier_Champs;
     if Champs = nil then exit;

     //Ecriture des lignes
     for J:= 1 to NbLignes
     do
       begin
       Champs:= Champs_from_Row( J);
       if nil=Champs
       then
           begin
           for IColonne:= 0 to Real_ColCount-1
           do
             Cellule_Vide( IColonne, J);
           end
       else
           begin
           for IColonne:= 0 to Real_ColCount-1
           do
             if     (J        = Row)
                and (IColonne = Col)
                and Assigned( InplaceEditor)
                and InplaceEditor.Visible
             then
                 begin
                 if InplaceEditor.Focused
                 then
                     begin
                     //on ne fait rien
                     end
                 else
                     begin
                     Champ_Nom:= slColonnes.Names[IColonne];
                     Champ:= Champs.Champ_from_Field( Champ_Nom);
                     //Champ.InplaceEditUpdateContents( InplaceEditor as TInplaceEdit_Champ);
                     end;
                 end
             else
                 begin
                 Champ_Nom:= slColonnes.Names[IColonne];
                 Champ:= Champs.Champ_from_Field( Champ_Nom);
                 if Champ = nil
                 then
                     Cellule_Vide( IColonne, J)
                 else
                     begin
                     Cells  [IColonne, J]:= Champ.Chaine;
                     Objects[IColonne, J]:= Champ;
                     end;
                 end;
           end;
       end;

     //Dimensionnement des colonnes
     for IColonne:= 0 to Real_ColCount -1
     do
       begin
       LargeurColonne:= 0;
       Champ_Nom:= slColonnes.Names[IColonne];
       for J:= 0 to RowCount -1
       do
         begin
         L:= LargeurTexte( Font, Cells[IColonne, J]);

         Champs:= Champs_from_Row( J);
         if Assigned( Champs)
         then
             begin
             Champ:= Champs.Champ_from_Field( Champ_Nom);
             if Assigned( Champ)
             then
                 begin
                 ChampDefinition:= Champ.Definition;
                 if    (ChampDefinition.Typ in [ftDate, ftDateTime])
                    or ChampDefinition.Is_Lookup
                 then
                     begin end;//Inc( L, GetSystemMetrics( SM_CXVSCROLL))
                 (*else if ChampDefinition.Typ = ftBoolean
                 then
                     L:= 30*);

                 end;
             end;
         if LargeurColonne < L then LargeurColonne:= L;
         end;
       ColWidths[ IColonne]:= GridLineWidth + LargeurColonne+2*CXEDGE;
       end;
end;

procedure TChampsGrid.Get_bl_at_Row( _Row: Integer; var bl);
var
   Index: Integer;
begin
     TObject( bl):= nil;

     Index:= _Row - 1;

     TObject( bl):= Objects_from_Index( Index);

     if TObject( bl) = nil then exit;

     if TObject( bl) is Classe_Elements then exit; // OK

     //on renvoie nil si ce n'est pas un élément de la bonne classe
     TObject( bl):= nil;
end;

procedure TChampsGrid.Get_bl( var bl);
begin
     Get_bl_at_Row( Row, bl);
end;

function TChampsGrid.Champ_from_XY( X, Y: Integer): TChamp;
var
   O: TObject;
begin
     Result:= nil;

     O:= Objects[ X, Y];
     if O = nil then exit;
     if not (O is TChamp) then exit;

     Result:= TChamp(O);
end;

function TChampsGrid.Champ_courant: TChamp;
begin
     Result:= Champ_from_XY( Col, Row);
end;

procedure SetTextAlign( _C: TCanvas; _a: TAlignment);
var
   ts: TTextStyle;
begin
     ts:= _C.TextStyle;
     ts.Alignment:= taLeftJustify;
     _C.TextStyle:= ts;
end;

procedure TChampsGrid.DrawCell( ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
   Hold: Integer;

   ChampDefinition: TChampDefinition;
   procedure Aligne_a_gauche;
   begin
        SetTextAlign( Canvas, taLeftJustify);
        Canvas.TextRect(ARect,ARect.Left+2,ARect.Top+2,Cells[ACol,ARow]);
   end;
   procedure Aligne_a_droite;
   begin
        SetTextAlign( Canvas, taRightJustify);
        Canvas.TextRect(ARect,ARect.Right-2,ARect.Top+2,Cells[ACol,ARow]);
        SetTextAlign( Canvas, taLeftJustify);
   end;
   procedure Coche;
   var
      Champ: TChamp;
   begin
        if ARow = 0 //titre
        then
            begin
            Aligne_a_gauche;
            exit;
            end;

        Champ:= Champ_from_XY( ACol, ARow);
        if Champ = nil then exit;

        Dessinne_Coche( Canvas, Color, Font.Color, ARect, Champ.asBoolean);
   end;
begin
     //on est obligé de casser l'héritage, du coup les codes sources des
     // ancêtres sont recopiés ici.

     ChampDefinition:= Definition( ACol);
     if Assigned( ChampDefinition)
     then
         begin
         case ChampDefinition.Typ
         of
           ftString  : Aligne_a_gauche;
           ftMemo    : Aligne_a_gauche;
           ftDate    : Aligne_a_droite;
           ftInteger : Aligne_a_droite;
           ftSmallint: Aligne_a_droite;
           ftBCD     : Aligne_a_droite;
           ftDateTime: Aligne_a_droite;
           ftFloat   : Aligne_a_droite;
           ftBoolean : Coche;
           else        Aligne_a_gauche;
           end;
         end
     else
         // TStringGrid.DrawCell
         if DefaultDrawing
         then
             Aligne_a_gauche;


     // TCustomDrawGrid.DrawCell
     if Assigned(OnDrawCell) then
     begin
       if UseRightToLeftAlignment then
       begin
         ARect.Left := ClientWidth - ARect.Left;
         ARect.Right := ClientWidth - ARect.Right;
         Hold := ARect.Left;
         ARect.Left := ARect.Right;
         ARect.Right := Hold;
         //ChangeGridOrientation(False);
       end;
       OnDrawCell(Self, ACol, ARow, ARect, AState);
       //if UseRightToLeftAlignment then ChangeGridOrientation(True);
     end;
end;

procedure TChampsGrid.Click;
var
   ChampDefinition: TChampDefinition;
   Champ: TChamp;
begin
     inherited;
     ChampDefinition:= Definition( Col);
     if      Assigned( ChampDefinition)
        and (ChampDefinition.Typ = ftBoolean)
     then
         begin
         Champ:= Champ_from_XY( Col, Row);
         if Assigned( Champ)
         then
             begin
             with Champ
             do
               asBoolean:= not asBoolean;

             DrawCell( Col, Row, CellRect( Col, Row), [gdSelected, gdFocused]);
             end;
         end;
end;

function TChampsGrid.slColonnes_NomFichier: String;
begin
     Result:= ExtractFilePath(uForms_EXE_Name)+'etc'+PathDelim+NamePath(Self)+'.txt';
end;

procedure TChampsGrid.slColonnes_Charge;
var
   sColonnes: String;
   sColonnes_vide: Boolean;
   _NomFichier: String;

begin
     //initialisation à partir du paramétrage en dur.
     sColonnes:= Colonnes.Text;
     slColonnes.Text:= sColonnes;
     sColonnes_vide:= Trim(sColonnes) = sys_Vide;
     sbColonnes.Visible:= sColonnes_vide;
     if not sColonnes_vide then exit;

     //initialisation à partir du paramétrage personnalisé
     if Persistance
     then
         begin
         _NomFichier:= slColonnes_NomFichier;
         if FileExists( _NomFichier)
         then
             slColonnes.LoadFromFile( _NomFichier)
         else
             slColonnes.Clear;
         end;
     slColonnes_Assure;
end;

procedure TChampsGrid.slColonnes_Sauve;
begin
     slColonnes_Assure;
     if Persistance
     then
         slColonnes.SaveToFile( slColonnes_NomFichier);
end;

procedure TChampsGrid.sbColonnesClick(Sender: TObject);
begin
     slColonnes_Assure;

     if fChampsGrid_Colonnes.Execute( slColonnes)
     then
         begin
         slColonnes_Sauve;
         SetSL( sl);
         end;
end;

procedure TChampsGrid.slColonnes_Assure;
var
   Champs: TChamps;
   ChampDefinitions: TChampDefinitions;
   I: Integer;
   Champ: TChamp;
   ChampDefinition: TChampDefinition;
   Champ_Nom  ,
   Champ_Titre: String;
begin
     Real_ColCount_from_slColonnes;
     if Real_ColCount > 0 then exit;

     Champs:= Premier_Champs;
     if Champs = nil then exit;

     ChampDefinitions:= Champs.ChampDefinitions;
     if ChampDefinitions = nil then exit;

     for I:= 0 to Champs.Count - 1
     do
       begin
       Champ:= Champs.Champ_from_Index( I);
       if Assigned( Champ)
       then
           begin
           ChampDefinition:= Champ.Definition;
           if Assigned( ChampDefinition)
           then
               begin
               if Champ.Owner <> Champs
               then
                   begin
                   Champ_Nom  := Champs.sl.Strings[ I];
                   Champ_Titre:= Champ_Nom;
                   end
               else
                   begin
                   Champ_Nom  := ChampDefinition.Nom;
                   Champ_Titre:= ChampDefinition.Libelle;
                   end;
               slColonnes.Values[Champ_Nom]:= Champ_Titre;
               end;
           end;
       end;
end;

procedure TChampsGrid.SetReal_ColCount(const Value: Integer);
begin
     FReal_ColCount:= Value;
     ColCount:= Real_ColCount;
end;

procedure TChampsGrid.Real_ColCount_from_slColonnes;
begin
     Real_ColCount:= slColonnes.Count;
end;

function TChampsGrid.SelectCell( ACol, ARow: Integer): Boolean;
var
   ChampDefinition: TChampDefinition;
   C: TChamp;
begin
     Result:= inherited SelectCell( ACol, ARow);
     if not Result then exit;

     ChampDefinition:= Definition( ACol);
     if Assigned( ChampDefinition)
     then
         if ftBoolean = ChampDefinition.Typ
         then
             begin
             Result:= False;
             C:= Champ_from_XY( ACol, ARow);
             if Assigned( C)
             then
                 with C do asBoolean:= not asBoolean;
             Refresh;
             end;
end;

procedure TChampsGrid.Recopie_vers_le_bas;
var
   Colonne, Ligne: Integer;
   Courant, Au_dessus: TChamp;
begin
     Ligne:= Row;
     if Ligne < 2 then exit;

     Colonne:= Col;

     Courant  := Champ_from_XY( Colonne, Ligne  );
     Au_dessus:= Champ_from_XY( Colonne, Ligne-1);
     if Courant   = nil then exit;
     if Au_dessus = nil then exit;

     if Courant  .Definition.Is_Lookup then Courant  := Courant  .LookupKey;
     if Au_dessus.Definition.Is_Lookup then Au_dessus:= Au_dessus.LookupKey;

     if Courant   = nil then exit;
     if Au_dessus = nil then exit;
     Courant.Chaine:= Au_dessus.Chaine;
     Row:= Ligne + 1;
     DrawCell( Colonne, Ligne, CellRect( Colonne, Ligne), []);
end;

procedure TChampsGrid.Do_OnNouveau;
begin
     if Assigned( OnNouveau)
     then
         OnNouveau( Self);
end;

procedure TChampsGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
     case Key
     of
       VK_DOWN:
         if Row < RowCount-1
         then
             inherited
         else
             Do_OnNouveau;
       VK_INSERT:
         Do_OnNouveau;
       else
           inherited;
       end;
end;

function TChampsGrid.Champs_from_Index( Index: Integer): TChamps;
begin
     Result:= Champs_from_Object( Objects_from_Index( Index));
end;

function TChampsGrid.Champs_from_Row( _Row: Integer): TChamps;
begin
     Result:= Champs_from_Index( Index_from_Row( _Row));
end;

function TChampsGrid.Index_from_Row(_Row: Integer): Integer;
begin
     Result:= _Row-1;
end;

procedure TChampsGrid.Initialise;
begin
     sl := nil;
     bts:= nil;
end;

function TChampsGrid.Donnees_indisponibles: Boolean;
begin
     if slbts_
     then
         Result:= sl  = nil
     else
         Result:= bts = nil;
end;

function TChampsGrid.NbLignes_from_Donnees: Integer;
begin
     if slbts_
     then
         Result:= sl .Count
     else
         Result:= bts.Count;
end;

function TChampsGrid.Objects_from_Index( Index: Integer): TObject;
begin
     Result:= Object_from_sl( sl, Index);
     //reste à gérer le cas bts, peut être en utilisant l'itérateur au lieu
     //de Objects_from_Index
end;

function TChampsGrid.Premier_Champs: TChamps;
begin

     if slbts_
     then
         Result:= Champs_from_Index( 0)
     else
         Result:= Champs_from_Object( bts.First_Value);
end;

procedure TChampsGrid.SetColonnes( Value: TStrings);
begin
     if Value = nil
     then
         Colonnes.Clear
     else
         Colonnes.Assign( Value);
end;

end.
