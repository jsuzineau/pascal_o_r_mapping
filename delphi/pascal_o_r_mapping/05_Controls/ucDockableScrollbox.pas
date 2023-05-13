unit ucDockableScrollbox;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uForms,
    uClean,
    uuStrings,
    uChampDefinition,
    uChamp,
    uChamps,
    uDataUtilsU,
    uBatpro_StringList,
    uProgression,
    u_sys_,
    uWinUtils,
    uPublieur,
    uTri_Ancetre,
    uhFiltre_Ancetre,
    uDockable,
  SysUtils, Classes,
  FMX.Controls, FMX.Forms, FMX.ExtCtrls,FMX.Graphics,FMX.StdCtrls,Types,
  System.UITypes, FMX.Objects, FMX.Types, FMX.Edit, FMX.Memo, Windows, StrUtils;

type
 TDockable_Event= procedure ( _dk: TDockable) of object;
 TDockableScrollbox_Colonne
 =
  record
    Control  : TControl;
    eFiltre  : TEdit;
    Titre    : String;
    NomChamp : String;
    Total_Type: TDockableScrollbox_Total;
    lTotal    : TLabel;
  end;
 TDockableScrollbox_Surtitre
 =
  record
    l: TLabel;
    libelle: String ;
    debut  : Integer;
    fin    : Integer;
  end;

 { TDockableScrollbox }

 TDockableScrollbox
 = class(TPanel)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Méthodes surchargées
  protected
    procedure Loaded; override;
    procedure Resize; override;
  //Gestion Redimensionnement
  private
    Ajuste_Nombre_Dockables_running: Boolean;
    procedure Ajuste_Nombre_Dockables;
  //Panel principal
  public
    p: TPanel;
    p_ClientHeight: Integer;
  //Scrollbar
  public
    s: TScrollBar;
    procedure s_Change( Sender: TObject);
    procedure _from_Scroll;
    procedure s_Set_MinMax;
  //Classe des dockables
  public
    Classe_dockable: TDockableClass;
  //Capacité: nombre maxi de dockables pouvant être affichés par le Scrollbox
  public
    Capacite: Integer;
    procedure Calcul_Capacite;
  //Liste d'objets
  private
    Fsl: TBatpro_StringList;
    sl_Offset: Integer;
    Setsl_running: Boolean;
    procedure Setsl(const Value: TBatpro_StringList);
    procedure Vide;
    function Cree_Panel_et_Dockable( _Bas: Integer; out _pa: TPanel): TDockable;
    procedure Supprime_dockable( _iDockable: Integer);
    procedure SetLectureSeule(const Value: Boolean);
    procedure Verifie_sl_Offset;
  public
    property sl: TBatpro_StringList read Fsl write Setsl;
  //Routines de conversion d'index
  public
    function Index_from_iDockable( _iDockable: Integer): Integer;
    function iDockable_from_Index( _Index: Integer): Integer;
    function Index_Visible( _Index: Integer): Boolean;
  // Liste des dockables et de leurs panels
  public
    slDockable: TBatpro_StringList;
    slPanel   : TBatpro_StringList;
    procedure Get_Dockable( _iDockable: Integer; var _dk);
  //Hauteur de panel
  private
    FHauteurLigne: Integer;
  published
    property HauteurLigne: Integer read FHauteurLigne write FHauteurLigne;
  //Bordure de lignes
  private
    FBordureLignes: Boolean;
  published
    property BordureLignes: Boolean read FBordureLignes write FBordureLignes;
  //Zebrage
  private
    FZebrage: Boolean;
  published
    property Zebrage: Boolean read FZebrage write FZebrage;
  //Zebrage 1
  private
    FZebrage1: TColor;
  published
    property Zebrage1: TColor read FZebrage1 write FZebrage1;
  //Zebrage 2
  private
    FZebrage2: TColor;
  published
    property Zebrage2: TColor read FZebrage2 write FZebrage2;
  //Etat de validité de l'ensemble des dockables
  //(créé pour fiche travail: si valide on peut fermer)
  protected
    FValide: Boolean;
    procedure Verifie_Validites;
    procedure SetValide(const Value: Boolean);
  public
    pValide_Change: TPublieur;
    property Valide: Boolean read FValide write SetValide;
  //Avant_Suppression
  private
    tAvant_Suppression: TTimer;
    iDockable_Avant_Suppression: Integer;
    procedure Dockable_Avant_Suppression( Sender: TObject);
    procedure tAvant_SuppressionTimer( Sender: TObject);
  //Gestion de l'évènement de Avant_suppression d'une ligne
  protected
    FAvant_Suppression: TNotifyEvent;
    procedure Do_Avant_Suppression;
  published
    property Avant_Suppression: TNotifyEvent read FAvant_Suppression write FAvant_Suppression;
  //Suppression
  private
    tSuppression: TTimer;
    iDockable_Suppression: Integer;
    procedure Dockable_Suppression( Sender: TObject);
    procedure tSuppressionTimer( Sender: TObject);
  //Gestion de l'évènement de suppression d'une ligne
  protected
    FOnSuppression: TNotifyEvent;
    procedure Do_OnSuppression;
  published
    property OnSuppression: TNotifyEvent read FOnSuppression write FOnSuppression;
  //Sélection
  private
    FIndex: Integer;
    Selection: TDockable;
    procedure SetIndex(const Value: Integer);
    procedure DemandeSelection( Sender: TObject);
    procedure DemandeValidation( Sender: TObject);
    procedure TraiteSelection( Sender: TObject);
  public
    property Index: Integer read FIndex write SetIndex;
    procedure Goto_Premier;
    procedure Goto_Dernier;
    procedure Goto_bl( _bl: TObject);
  //Gestion de l'évènement de sélection
  protected
    FOnSelect: TNotifyEvent;
    procedure Do_OnSelect;
  published
    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
  //Gestion de l'évènement de validation
  protected
    FOnValidate: TNotifyEvent;
    procedure Do_OnValidate;
  published
    property OnValidate: TNotifyEvent read FOnValidate write FOnValidate;
  //Récupération de la sélection
  public
    Classe_Elements: TClass; //pour le contrôle de type de bl
    procedure Get_bl( var bl);
  //Gestion du déplacement
  public
    procedure DockableScrollbox_Precedent( Sender: TObject);
    procedure DockableScrollbox_Suivant  ( Sender: TObject);
  //Gestion de la création d'une nouvelle ligne
  public
    procedure DockableScrollbox_Nouveau( Sender: TObject);
  //Gestion de l'évènement de création d'une nouvelle ligne
  protected
    FOnNouveau: TNotifyEvent;
    procedure Do_OnNouveau;
  published
    property OnNouveau: TNotifyEvent read FOnNouveau write FOnNouveau;
  //Gestion de l'évènement de création d'un dockable
  protected
    FOnCreateDockable: TDockable_Event;
    procedure Do_OnCreateDockable( _dk: TDockable);
  published
    property OnCreateDockable: TDockable_Event read FOnCreateDockable write FOnCreateDockable;
  //Gestion de la lecture seule
  private
    FLectureSeule: Boolean;
  published
    property _LectureSeule: Boolean
             read  FLectureSeule
             write SetLectureSeule;
  //Gestion de l'entete des colonnes
  private
    pColumnHeader: TPanel;
    pColumnHeader_Height_Replie: Integer;
    pColumnHeader_Height_Deplie: Integer;
    pColumnFooter: TPanel;
    Colonnes: array of TDockableScrollbox_Colonne;
    Surtitres: array of TDockableScrollbox_Surtitre;
    Enleve_Colonnes_running: Boolean;
    procedure Ajoute_Surtitre( _Surtitre: TDockable_Surtitre);
    procedure Ajoute_Colonne( _C: TControl;
                              _Titre   : String  = ''   ;
                              _NomChamp: String  = ''   ;
                              _Total   : TDockableScrollbox_Total = dsbt_Aucun);
    procedure Enleve_Colonnes;
    procedure Initialise_Colonnes( _Premier: Boolean= False);
    procedure Colonne_MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Single);
    procedure Colonne_eFiltre_Change(Sender: TObject);
    procedure Colonne_eFiltre_KeyPress(Sender: TObject; var Key: char);
    procedure Colonne_eFiltre_KeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure Place_Column_Header( I: Integer);
    procedure Replie_pColumnHeader;
    procedure Deplie_pColumnHeader;
  //Gestion de la totalisation
  private
    Traiter_Totaux: Boolean;
    slChamps_abonnements: TBatpro_StringList;
    procedure lTotal_MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Single);
    procedure RecalculeTotaux;
  //Gestion du tri
  public
    Tri: TTri_Ancetre;
  //Gestion du filtre
  public
    Filtre: ThFiltre_Ancetre;
  //Messages divers envoyés du DockableScrollBox au Dockable
  public
    procedure Envoie_Message( _iMessage: Integer);
  //Transmission vers la fiche d'un évènement envoyé  par un dockable
  protected
    FOnTraite_Message: TDockableScrollBox_Traite_Message;
    //appel de FOnTraite_Message
    procedure Do_OnTraite_Message( _dk: TDockable; _iMessage: Integer);
    //appelée par le Dockable
    procedure DockableScrollBox_Traite_Message( _dk: TDockable; _iMessage: Integer);
  published
    property OnTraite_Message: TDockableScrollBox_Traite_Message read FOnTraite_Message write FOnTraite_Message;

  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TDockableScrollbox]);
end;

{ TDockableScrollbox }

constructor TDockableScrollbox.Create(AOwner: TComponent);
begin
     inherited;
     slDockable:= TBatpro_StringList.Create;
     slPanel   := TBatpro_StringList.Create;
     slChamps_abonnements
     :=
       TBatpro_StringList.CreateE( 'TDockableScrollbox.slChamps_abonnements', TChamp);
     HauteurLigne:= 24;
     BordureLignes:= True;
     Classe_dockable:= nil;
     Classe_Elements:= nil;
     Enleve_Colonnes_running:= False;

     //Gestion de la validation
     FValide:= True;
     pValide_Change:= TPublieur.Create( Name+'.pValide_Change');

     //Avant_Suppression
     tAvant_Suppression:= TTimer.Create( Self);
     tAvant_Suppression.OnTimer:= tAvant_SuppressionTimer;
     tAvant_Suppression.Enabled:= False;
     tAvant_Suppression.Interval:= 50;

     //Gestion de la suppression
     tSuppression:= TTimer.Create( Self);
     tSuppression.OnTimer:= tSuppressionTimer;
     tSuppression.Enabled:= False;
     tSuppression.Interval:= 50;

     //Gestion de la sélection
     Selection:= nil;
     FIndex:= -1;

     //Gestion de l'évènement de sélection
     FOnSelect:= nil;

     //Gestion de l'évènement de validation
     FOnValidate:= nil;

     //Gestion de l'entete des colonnes
     pColumnHeader:= TPanel.Create( Self);
     pColumnHeader.Parent:= Self;
     pColumnHeader.Position.Y  := 0;
     pColumnHeader.Position.X := 0;
     pColumnHeader.Align:= TAlignLayout.Top;
     pColumnHeader.StyleLookup:= 'pushpanel';

     //pColumnHeader.ParentBackground:= False;
     //pColumnHeader.BevelOuter:= bvNone;

     //Gestion du pied des colonnes
     Traiter_Totaux:= False;
     pColumnFooter:= TPanel.Create( Self);
     pColumnFooter.Parent:= Self;
     pColumnFooter.Position.Y  := 0;
     pColumnFooter.Position.X := 0;
     pColumnFooter.Align:= TAlignLayout.Bottom;
     pColumnFooter.StyleLookup:= 'calloutpanelstyle';
     //pColumnFooter.ParentBackground:= False;
     //pColumnFooter.BevelOuter:= bvNone;

     //Le scrollbox
     p:= TPanel.Create( Self);
     p.Parent:= Self;
     p.Position.Y  := 0;
     p.Position.X := 0;
     p.Align:= TALignLAyout.alClient;
     //p.ParentBackground:= False;
     p.Visible:= True;

     s:= TScrollBar.Create( Self);
     s.Parent:= Self;
     s.Position.Y  := 0;
     s.Position.X := 0;
     s.Align:= TALignLAyout.alRight;
     s.Orientation:= TOrientation.Vertical;
     s.OnChange:= s_Change;

     //pColumnHeader.Parent:= dsb;
     //pColumnHeader.Caption:= 'truc';
     //Couleurs
     Zebrage1:= $00E6FFE6;
     Zebrage2:= $00FFFFE8;


     Initialise_Colonnes( True);
     Tri:= nil;
     Filtre:= nil;

     Setsl_running:= False;
     Ajuste_Nombre_Dockables_running:= False;
end;

destructor TDockableScrollbox.Destroy;
begin
     tSuppression.Enabled:= False;
     tAvant_Suppression.Enabled:= False;
     Free_nil( pValide_Change);
     Free_nil( slChamps_abonnements);
     Free_nil( slDockable);
     Free_nil( slPanel   );
     inherited;
end;

procedure TDockableScrollbox.Loaded;
begin
     inherited;
     p.OnDblClick:= OnDblClick;
     Calcul_Capacite;
end;

procedure TDockableScrollbox.Ajoute_Surtitre( _Surtitre: TDockable_Surtitre);
var
   I, NewLength: Integer;
begin
     I:= Length(Surtitres);
     NewLength:= I+1;
     SetLength( Surtitres, NewLength);
end;

procedure TDockableScrollbox.Ajoute_Colonne( _C: TControl;
                                             _Titre   : String  = ''   ;
                                             _NomChamp: String  = ''   ;
                                             _Total   : TDockableScrollbox_Total = dsbt_Aucun);
var
   I, NewLength: Integer;
   L: TLabel;
   E: TEdit;
   _TopLeft: TPointF;
   sTri: String;
   C_Alignment: TTextAlign;
begin
     I:= Length(Colonnes);
     NewLength:= I+1;
     SetLength( Colonnes, NewLength);

     _TopLeft:= _C.Position.Point;

          if _C is TLabel then C_Alignment:= TLabel(_C).TextAlign
     else if _C is TMemo  then C_Alignment:= TMemo (_C).TextAlign
     else                      C_Alignment:= TTextAlign.Leading;

     if Tri = nil
     then
         sTri:= sys_Vide
     else
         case Tri.ChampTri[ _NomChamp]
         of
           -1:  sTri:= ' \';
            0:  sTri:= sys_Vide;
           +1:  sTri:= ' /';
           else sTri:= sys_Vide;
           end;

     if Pos( #13, _Titre) > 0
     then
        pColumnHeader.Height:= 30;

     L:= TLabel.Create( Self);
     L.Parent:= pColumnHeader;
     L.AutoSize:= False;
     L.Position.Y   := 2;
     L.Position.X  := _TopLeft.X;
     L.Width := _C.Width;
     L.Height:= pColumnHeader.Height- L.Position.Y;
     L.Text:= _Titre + sTri;
     L.Tag   := I;
     //L.Transparent:= False;
     with L.Font do Style:= Style + [TFontStyle.fsBold];
     L.TextAlign:= C_Alignment;
     L.OnMouseDown:= Colonne_MouseDown;
     L.Visible:= True;

     E:= TEdit.Create( Self);
     E.Parent:= pColumnHeader;
     //E.AutoSize:= False;
     //E.Left  := _TopLeft.X;
     E.Width := _C.Width;
     E.Height:= 26;
     E.Tag   := I;
     with E.Font do Style:= Style + [TFontStyle.fsBold];
     //E.Align:= C_Alignment;
     //E.OnMouseDown:= Colonne_MouseDown;
     E.OnKeyDown:= Colonne_eFiltre_KeyDown;
     //E.Show;
     E.Visible:= False;

     pColumnHeader_Height_Replie:= 17+14*Char_Count( #13, _Titre);

     pColumnHeader_Height_Deplie:= pColumnHeader_Height_Replie+Trunc(E.Height);
     pColumnHeader.Height:= pColumnHeader_Height_Replie;

     with Colonnes[I]
     do
       begin
       Control   := L;
       eFiltre   := E;
       Total_Type:= _Total;
       Titre     := _Titre;
       NomChamp  := _NomChamp;
       if _Total <> dsbt_Aucun
       then
           begin
           Traiter_Totaux:= True;
           lTotal:= TLabel.Create( Self);
           lTotal.Parent:= pColumnFooter;
           lTotal.AutoSize:= False;
           lTotal.Position.Y   := 2;
           lTotal.Position.X  := _TopLeft.X;
           lTotal.Width := _C.Width;
           lTotal.Height:= pColumnFooter.Height-lTotal.Position.Y;
           lTotal.Text:= 'TOTAL';
           lTotal.TextAlign:= TTextAlign.Trailing;
           lTotal.Tag   := I;
           //lTotal.Transparent:= False;
           with lTotal.Font do Style:= Style + [TFontStyle.fsBold];
           lTotal.TextAlign:= C_Alignment;
           lTotal.OnMouseDown:= lTotal_MouseDown;
           lTotal.Visible:= True;
           end
       else
           lTotal:= nil;
       end;
     Place_Column_Header( I);

end;

procedure TDockableScrollbox.Enleve_Colonnes;
var
   I: Integer;
   C: TControl;
   Champ: TChamp;
begin
     if Enleve_Colonnes_running then exit;

     Enleve_Colonnes_running:= True;
     try
        for I:= Low(Colonnes) to High(Colonnes)
        do
          begin
          with Colonnes[I]
          do
            begin
            C:= Control;
            Control:= nil;
            RemoveComponent( C);
            FreeAndNil( C);

            C:= lTotal;
            if C = nil then continue;

            lTotal:= nil;
            RemoveComponent( C);
            FreeAndNil( C);
            end;
          end;

        slChamps_abonnements.Iterateur_Start;
        try
           while not slChamps_abonnements.Iterateur_EOF
           do
             begin
             slChamps_abonnements.Iterateur_Suivant( Champ);
             if Champ = nil then continue;
             Champ.OnChange.Desabonne( Self, RecalculeTotaux);
             end;
        finally
               slChamps_abonnements.Iterateur_Stop;
               end;
        Initialise_Colonnes;
     finally
            Enleve_Colonnes_running:= False;
            end;
end;

procedure TDockableScrollbox.Initialise_Colonnes( _Premier: Boolean= False);
begin
     if not _Premier
     then
         Enleve_Colonnes;
     Traiter_Totaux:= False;
     SetLength( Colonnes , 0);
end;

procedure TDockableScrollbox.Colonne_MouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
   C: TControl;
   I: Integer;
   NomChamp: String;
   NewChampTri: Integer;
begin
     if Tri = nil                then exit;
     if Sender = nil             then exit;
     if not (Sender is TControl) then exit;

     C:= TControl( Sender);
     I:= C.Tag;
     if (I < Low(Colonnes))or(High(Colonnes)<I) then exit;

     if not (ssShift in Shift) then Tri.Reset_ChampsTri;

     if Button = TMouseButton.mbRight
     then
         begin
         if pColumnHeader_Height_Replie = pColumnHeader.Height
         then
             Deplie_pColumnHeader
         else
             Replie_pColumnHeader;

         Place_Column_Header(I);
         end
     else
         begin
         NomChamp:= Colonnes[ I].NomChamp;
         case Tri.ChampTri[ NomChamp]
         of
           -1:  NewChampTri:=  0;
            0:  NewChampTri:= +1;
           +1:  NewChampTri:= -1;
           else NewChampTri:=  0;
           end;
         Tri.ChampTri[ NomChamp]:= NewChampTri;
         Tri.Execute( sl);
         end;

    // Setsl( sl);
end;

procedure TDockableScrollbox.Colonne_eFiltre_Change( Sender: TObject);
var
   E: TEdit;
   I: Integer;
begin
     if Sender = nil          then exit;
     if not (Sender is TEdit) then exit;

     E:= TEdit( Sender);
     I:= E.Tag;
     if (I < Low(Colonnes))or(High(Colonnes)<I) then exit;

end;

procedure TDockableScrollbox.Colonne_eFiltre_KeyPress( Sender: TObject; var Key: char);
var
   E: TEdit;
   I: Integer;
begin
     if Key <> #13 then exit;

     if Sender = nil          then exit;
     if not (Sender is TEdit) then exit;

     E:= TEdit( Sender);
     I:= E.Tag;
     if (I < Low(Colonnes))or(High(Colonnes)<I) then exit;


end;

procedure TDockableScrollbox.Colonne_eFiltre_KeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
   E: TEdit;
   I: Integer;
begin
     if Key <> VK_RETURN then exit;

     if Filtre = nil          then exit;
     if Sender = nil          then exit;
     if not (Sender is TEdit) then exit;

     E:= TEdit( Sender);
     I:= E.Tag;
     if (I < Low(Colonnes))or(High(Colonnes)<I) then exit;

     if not (ssShift in Shift) then Filtre.Clear;

     if E.Text <> ''
     then
         Filtre.AjouteCritereCONTIENT( Colonnes[ I].NomChamp, E.Text);
     Filtre.Execute;
     Setsl( sl);
end;

procedure TDockableScrollbox.Place_Column_Header( I: Integer);
var
   eFiltre_Height: Integer;
   eFiltre_Top   : Integer;
begin
     with Colonnes[I]
     do
       begin
       if eFiltre.Visible
       then
           eFiltre_Height:= 26
       else
           eFiltre_Height:= 0;
       eFiltre_Top:= Trunc(pColumnHeader.Height) - eFiltre_Height;

       //eFiltre.Top   := eFiltre_Top;

       //Control.Height:= eFiltre_Top- Control.Top;
       //pColumnHeader.Hint:= IntToStr( Control.Height);
       end;
end;

procedure TDockableScrollbox.Replie_pColumnHeader;
var
   I: Integer;
begin
     pColumnHeader.Height:= pColumnHeader_Height_Replie;
     for I:= Low(Colonnes) to High(Colonnes)
     do
       Colonnes[I].eFiltre.Visible:= False;
end;

procedure TDockableScrollbox.Deplie_pColumnHeader;
var
   I: Integer;
begin
     pColumnHeader.Height:= pColumnHeader_Height_Deplie;
     for I:= Low(Colonnes) to High(Colonnes)
     do
       Colonnes[I].eFiltre.Visible:= True;
end;

procedure TDockableScrollbox.lTotal_MouseDown( Sender: TObject;
                                               Button: TMouseButton;
                                               Shift: TShiftState;
                                               X, Y: Single);
begin

end;

procedure TDockableScrollbox.RecalculeTotaux;
var
   Colonne_Total: array of double;
   Definitions: array of TChampDefinition;

   I: Integer;
   CP: TChampsProvider;
   Champs: TChamps;

   J: Integer;
   Champ: TChamp;
begin
     SetLength( Colonne_Total, Length(Colonnes));
     SetLength( Definitions  , Length(Colonnes));

     for J:= Low(Colonne_Total) to High( Colonne_Total)
     do
       Colonne_Total[J]:= 0;

     for J:= Low(Definitions) to High( Definitions)
     do
       Definitions[J]:= nil;

     for I:= 0 to sl.Count - 1
     do
       begin
       CP:= TChampsProvider( sl.Objects[ I]);
       CheckClass( CP, TChampsProvider);
       if CP = nil then continue;

       Champs:= CP.GetChamps;
       if Champs = nil then continue;

       for J:= Low(Colonnes) to High(Colonnes)
       do
         with Colonnes[J]
         do
           begin
           if lTotal = nil then continue;

           Champ:= Champs.Champ[ NomChamp];
           if Champ = nil then continue;

           Definitions[J]:= Champ.Definition;
           Colonne_Total[J]:= Colonne_Total[J] + Champ.asDouble;
           end;
       end;

     for J:= Low(Colonnes) to High(Colonnes)
     do
       with Colonnes[J]
       do
         begin
         case Total_Type
         of
           dsbt_Aucun  : continue;
           dsbt_Decimal:
             if Definitions[J] = nil
             then
                 lTotal.Text:= FloatToStr( Colonne_Total[J])
             else
                 lTotal.Text:= Definitions[J].Format_Float( Colonne_Total[J]);
           dsbt_Heure  : lTotal.Text:= sHeure    ( Colonne_Total[J]);
           end;
         end;
end;

procedure TDockableScrollbox.Setsl(const Value: TBatpro_StringList);
var
   I: Integer;
   pa: TPanel;
   dk: TDockable;
   O: TObject;
   p_Height: Integer;
   Bas: Integer;
   procedure Traite_ColumnHeader;
   var
      J: Integer;
   begin
        for J:= Low(dk.Colonnes) to High(dk.Colonnes)
        do
          with dk.Colonnes[J]
          do
            Ajoute_Colonne( Control, Titre, NomChamp, Total);
        for J:= Low(dk.Surtitres) to High(dk.Surtitres)
        do
          Ajoute_Surtitre( dk.Surtitres[J]);
   end;
   procedure TraiteTotaux;
   var
      CP: TChampsProvider;
      Champs: TChamps;
      J: Integer;
      Champ: TChamp;
   begin
        CP:= TChampsProvider( O);
        CheckClass( CP, TChampsProvider);
        if CP= nil then exit;

        Champs:= CP.GetChamps;
        if Champs = nil then exit;

        for J:= Low(Colonnes) to High( Colonnes)
        do
          with Colonnes[J]
          do
            begin
            if lTotal = nil then continue;

            Champ:= Champs.Champ[ NomChamp];
            if Champ = nil then continue;

            slChamps_abonnements.AddObject( '', Champ);
            Champ.OnChange.Abonne( Self, RecalculeTotaux);
            end;
   end;
begin
     Setsl_running:= True;
     try
        Vide;
        if Classe_dockable = nil then exit;

        Fsl := Value;
        if sl = nil then exit;
        try
           if sl.Count= 0 then exit;
        except
              on E: Exception
              do
                exit;
              end;

        pColumnHeader.Height:= 17;
        pColumnHeader.Visible:= False;

        pColumnFooter.Height:= 17;
        pColumnFooter.Visible:= False;

        //p.Refresh;

        Bas:= 0;

        if Assigned( uProgression_Demarre)
        then
            uProgression_Demarre( 'Remplissage de la boite de défilement', 0, sl.Count - 1, False, True);

        p_Height:= Trunc( p.Height);
        if 0 = p_Height then p_Height:= Trunc( Size.Height);
        

        for I:= 0 to sl.Count - 1
        do
          begin
          if Bas > p_Height then break;

          Bas:= Bas + HauteurLigne;

          O:= sl.Objects[ I];

          pa:= TPanel.Create( nil);
          pa.Parent:= p;
          pa.Position.Y:= Bas;
          pa.Align:= TAlignLayout.Top;
          pa.Height:= HauteurLigne;
          pa.StyleLookup:= ifthen( Odd(I),'calloutpanelstyle','pushpanel');

       {
       if BordureLignes
       then
           pa.BevelOuter:= bvRaised
       else
           pa.BevelOuter:= bvNone;
       }
       Create_Dockable( dk, Classe_dockable, pa);

       slDockable.AddObject( sys_Vide, dk);
       slPanel   .AddObject( sys_Vide, pa );

       dk.Objet:= O;
       dk.pValide_Change.Abonne( Self, Verifie_Validites);

       dk.DockableScrollbox_Avant_Suppression:= Dockable_Avant_Suppression;
       dk.DockableScrollbox_Suppression:= Dockable_Suppression;
       dk.DockableScrollbox_Selection  := DemandeSelection  ;
       dk.DockableScrollbox_Validation := DemandeValidation ;
       dk.DockableScrollbox_Precedent  := DockableScrollbox_Precedent;
       dk.DockableScrollbox_Suivant    := DockableScrollbox_Suivant  ;
       dk.DockableScrollbox_Nouveau    := DockableScrollbox_Nouveau  ;

       {
       if Zebrage
       then
           if Odd( I)
           then
               dk.Color:= Zebrage1
           else
               dk.Color:= Zebrage2;
       }

       dk.Traite_LectureSeule( FLectureSeule);

       Do_OnCreateDockable( dk);
       if I = 0
       then
           begin
           Traite_ColumnHeader;
           if Length(Colonnes) > 0
           then
               begin
               pColumnHeader.Visible:= True;
               pa.Position.Y:= Bas;
               Bas:= Bas + HauteurLigne;
               pColumnFooter.Visible:= Traiter_Totaux;
               end;
           end;
       TraiteTotaux;
       if Assigned(uProgression_AddProgress)
       then
           uProgression_AddProgress( 1);
       uForms_ProcessMessages;
       if Assigned(uProgression_GetInterrompre)
       then
           if uProgression_GetInterrompre
           then
               break;
       end;

     s_Set_MinMax;
     if Assigned(uProgression_GetInterrompre)
     then
         uProgression_Termine;

     if Traiter_Totaux
     then
         RecalculeTotaux;
     Verifie_Validites;
     finally
            Setsl_running:= False;
            end;
end;

procedure TDockableScrollbox.SetValide( const Value: Boolean);
begin
     if FValide = Value then exit;

     FValide := Value;
     pValide_Change.Publie;
end;

procedure TDockableScrollbox.Verifie_Validites;
var
   iDockable: Integer;
   dk: TDockable;
   Valide_AND: Boolean;
begin
     Valide_AND:= True;

     for iDockable:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, iDockable);
       if Assigned( dk)
       then
           begin
           Valide_AND:= dk.Valide;
           if not Valide_AND then break;
           end;
       end;

     Valide:= Valide_AND;
end;

procedure TDockableScrollbox.Supprime_dockable( _iDockable: Integer);
var
   dk: TDockable;
   p: TPanel;
begin
     try
        dk:= Dockable_from_sl( slDockable, _iDockable);
        p :=    Panel_from_sl( slPanel   , _iDockable);
        if     Assigned( dk)
           and Assigned( p )
        then
            begin
            if Selection = dk then Selection:= nil;
            dk.Objet:= nil;
            dk.pValide_Change.Desabonne( Self, Verifie_Validites);
            Destroy_Dockable( dk);
            Free_nil( p);
            end;
        slDockable.Delete( _iDockable);
        slPanel   .Delete( _iDockable)
     except
           on E:Exception
           do
             begin
             uClean_Log( ClassName+'.Supprime_dockable( '+IntToStr(_iDockable)+')'#13#10+E.Message);
             //raise;
             end;
           end;
end;

procedure TDockableScrollbox.Vide;
var
   iDockable: Integer;
begin
     //s.PageSize:= 1;
     s.Value:= 0;
     sl_Offset:= 0;

     Selection:= nil;

     if sl = nil then exit;

     Enleve_Colonnes;

     for iDockable:= slDockable.Count - 1 downto 0
     do
       Supprime_dockable( iDockable);
     //p.Caption:= FTextVide;
end;

function TDockableScrollbox.Cree_Panel_et_Dockable( _Bas: Integer; out _pa: TPanel): TDockable;
var
   dk: TDockable;
   I: Integer;
begin
     _pa:= TPanel.Create( nil);
     _pa.Parent:= p;
     //_pa.Top:= _Bas;
     _pa.Align:= TALignLayout.alTop;
     _pa.Height:= HauteurLigne;
//     if BordureLignes
//     then
//         _pa.BevelOuter:= bvRaised
//     else
//         _pa.BevelOuter:= bvNone;

     Create_Dockable( dk, Classe_dockable, _pa);

     I:= slDockable.AddObject( sys_Vide, dk);
         slPanel   .AddObject( sys_Vide, _pa );

     dk.pValide_Change.Abonne( Self, Verifie_Validites);

     dk.DockableScrollbox_Avant_Suppression:= Dockable_Avant_Suppression;
     dk.DockableScrollbox_Suppression:= Dockable_Suppression;
     dk.DockableScrollbox_Selection  := DemandeSelection  ;
     dk.DockableScrollbox_Validation := DemandeValidation ;
     dk.DockableScrollbox_Precedent  := DockableScrollbox_Precedent;
     dk.DockableScrollbox_Suivant    := DockableScrollbox_Suivant  ;
     dk.DockableScrollbox_Nouveau    := DockableScrollbox_Nouveau  ;
     dk.DockableScrollBox_Traite_Message:= DockableScrollBox_Traite_Message;

     if Zebrage
     then
         if Odd( I)
         then
             dk.Couleur:= Zebrage1
         else
             dk.Couleur:= Zebrage2;

     dk.Traite_LectureSeule( FLectureSeule);
     Result:= dk;
end;

procedure TDockableScrollbox.Dockable_Avant_Suppression(Sender: TObject);
begin
     iDockable_Avant_Suppression:= slDockable.IndexOfObject( Sender);
     if iDockable_Avant_Suppression <> -1
     then
         tAvant_Suppression.Enabled:= True;
end;

procedure TDockableScrollbox.tAvant_SuppressionTimer( Sender: TObject);
begin
     if iDockable_Avant_Suppression = -1 then exit;
     try
        tAvant_Suppression.Enabled:= False;

        Verifie_Validites;

        Do_Avant_Suppression;

        pValide_Change.Publie;
     except
           on E:Exception
           do
             begin
             uClean_Log( ClassName+'.tAvant_SuppressionTimer, iDockable_Avant_Suppression= '+IntToStr(iDockable_Avant_Suppression)+''#13#10+E.Message);
             //raise;
             end;
           end;
end;

procedure TDockableScrollbox.Do_Avant_Suppression;
begin
     if Assigned( Avant_Suppression)
     then
         Avant_Suppression( Self);
end;

procedure TDockableScrollbox.Dockable_Suppression(Sender: TObject);
begin
     iDockable_Suppression:= slDockable.IndexOfObject( Sender);
     if iDockable_Suppression <> -1
     then
         tSuppression.Enabled:= True;
end;

procedure TDockableScrollbox.tSuppressionTimer( Sender: TObject);
begin
     if iDockable_Suppression = -1 then exit;
     try
        tSuppression.Enabled:= False;

        if sl.Count < slDockable.Count
        then
            Setsl( sl)
        else
            begin
            s_Set_MinMax;
            Verifie_sl_Offset;
            _from_Scroll;

            Verifie_Validites;
            end;

        Do_OnSuppression;

        pValide_Change.Publie;
     except
           on E:Exception
           do
             begin
             uClean_Log( ClassName+'.tSuppressionTimer, iDockable_Suppression= '+IntToStr(iDockable_Suppression)+''#13#10+E.Message);
             //raise;
             end;
           end;
end;

procedure TDockableScrollbox.Do_OnSuppression;
begin
     if Assigned( OnSuppression)
     then
         OnSuppression( Self);
end;

procedure TDockableScrollbox.Get_Dockable( _iDockable: Integer; var _dk);
var
   O: TObject;
begin
     TDockable( _dk):= nil;
     if _iDockable < 0                 then exit;
     if _iDockable >= slDockable.Count then exit;
     O:= slDockable.Objects[ _iDockable];
     if O = nil then exit;
     if not (O is Classe_dockable) then exit;

     TDockable( _dk):= TDockable( O);
end;

procedure TDockableScrollbox.TraiteSelection(Sender: TObject);
var
   iDockable: Integer;
begin
     if Selection = Sender then exit;

     if Assigned( Selection)
     then
         Selection.Affiche_Selection( False);

     if Sender is TDockable
     then
         begin
         Selection:= TDockable( Sender);
         Selection.Affiche_Selection( True);
         iDockable:= slDockable.IndexOfObject( Selection);
         FIndex:= Index_from_iDockable( iDockable);
         end
     else
         begin
         Selection:= nil;
         FIndex:= -1;
         end;
end;

procedure TDockableScrollbox.DemandeSelection(Sender: TObject);
begin
     TraiteSelection( Sender);

     Do_OnSelect;
end;

procedure TDockableScrollbox.DemandeValidation(Sender: TObject);
begin
     TraiteSelection( Sender);

     Do_OnValidate;
end;

procedure TDockableScrollbox.Do_OnSelect;
begin
     if Assigned( OnSelect)
     then
         OnSelect( Self);
end;

procedure TDockableScrollbox.Do_OnValidate;
begin
     if Assigned( OnValidate)
     then
         OnValidate( Self);
end;

procedure TDockableScrollbox.Get_bl(var bl);
begin
     TObject( bl):= nil;

     if Selection = nil then exit;

     TObject( bl):= Selection.Objet;

     if TObject( bl) = nil then exit;

     if TObject( bl) is Classe_Elements then exit; // OK

     //on renvoie nil si ce n'est pas un élément de la bonne classe
     TObject( bl):= nil;
end;

procedure TDockableScrollbox.SetIndex(const Value: Integer);
var
   iDockable: Integer;
   dk: TDockable;
begin
     if not Index_Visible( Value)
     then
         begin
         sl_Offset:= Value-slDockable.Count div 2;
         Verifie_sl_Offset;
         _from_Scroll;
         end;

     iDockable:= iDockable_from_Index( Value);

     Get_Dockable( iDockable, dk);
     if dk = nil then exit;
     dk.Do_DockableScrollbox_Selection;//affecte FIndex:= Value
     Do_OnSelect;
end;

procedure TDockableScrollbox.Goto_bl( _bl: TObject);
begin
     if sl = nil then exit;

     Index:= sl.IndexOfObject( _bl);
end;

procedure TDockableScrollbox.Goto_Premier;
begin
     if sl.Count > 0
     then
         Index:= 0;
end;

procedure TDockableScrollbox.Goto_Dernier;
begin
     if sl.Count > 0
     then
         Index:= sl.Count - 1;
end;

procedure TDockableScrollbox.DockableScrollbox_Precedent(Sender: TObject);
begin
     Index:= Index - 1;
end;

procedure TDockableScrollbox.DockableScrollbox_Suivant(Sender: TObject);
begin
     if Index = sl.Count-1
     then
         Do_OnNouveau
     else
         Index:= Index + 1;
end;

procedure TDockableScrollbox.DockableScrollbox_Nouveau(Sender: TObject);
begin
     Do_OnNouveau;
end;

procedure TDockableScrollbox.Do_OnNouveau;
begin
     if Assigned( OnNouveau)
     then
         OnNouveau( Self);
end;

procedure TDockableScrollbox.SetLectureSeule(const Value: Boolean);
var
   iDockable: Integer;
   dk: TDockable;
begin
     FLectureSeule:= Value;

     for iDockable:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, iDockable);
       if Assigned( dk)
       then
           dk.Traite_LectureSeule( FLectureSeule);
       end;
end;

procedure TDockableScrollbox.Do_OnCreateDockable( _dk: TDockable);
begin
     if Assigned( OnCreateDockable)
     then
         OnCreateDockable( _dk);
end;

procedure TDockableScrollbox.Envoie_Message( _iMessage: Integer);
var
   iDockable: Integer;
   dk: TDockable;
begin
     for iDockable:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, iDockable);
       if Assigned( dk)
       then
           dk.Traite_Message( Self, _iMessage);
       end;
end;

procedure TDockableScrollbox.Do_OnTraite_Message(_dk: TDockable; _iMessage: Integer);
begin
     if Assigned( OnTraite_Message)
     then
         OnTraite_Message( _dk, _iMessage);
end;

procedure TDockableScrollbox.DockableScrollBox_Traite_Message( _dk: TDockable; _iMessage: Integer);
begin
     Do_OnTraite_Message( _dk, _iMessage);
end;

procedure TDockableScrollbox.s_Change( Sender: TObject);
begin
     sl_Offset:= Trunc(s.Value);
     Verifie_sl_Offset;

     _from_Scroll;
end;

procedure TDockableScrollbox._from_Scroll;
var
   iDockable: Integer;
   dk: TDockable;
   iSL: Integer;
begin
     s.Value:= sl_Offset;
     for iDockable:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, iDockable);
       if dk = nil then continue;

       iSL:= Index_from_iDockable( iDockable);
       if (0 <= iSL)and(iSL <= sl.Count-1)
       then
           dk.Objet:= sl.Objects[ iSL]
       else
           dk.Objet:= nil;
       end;
end;

function TDockableScrollbox.iDockable_from_Index( _Index: Integer): Integer;
begin
     Result:= _Index - sl_Offset;
end;

function TDockableScrollbox.Index_from_iDockable( _iDockable: Integer): Integer;
begin
     Result:= sl_Offset + _iDockable;
end;

function TDockableScrollbox.Index_Visible( _Index: Integer): Boolean;
var
   iDockable: Integer;
begin
     iDockable:= iDockable_from_Index( _Index);
     Result:= (0<= iDockable)and(iDockable <= slDockable.Count-1);
end;

procedure TDockableScrollbox.Verifie_sl_Offset;
var
   iMin, iMax: Integer;
begin
     if sl         = nil then exit;
     if slDockable = nil then exit;
     iMin:= 0;
     iMax:= sl.Count-slDockable.Count;
     if sl_Offset < iMin then sl_Offset:= iMin;
     if sl_Offset > iMax then sl_Offset:= iMax;
end;

procedure TDockableScrollbox.s_Set_MinMax;
var
   sl_Count, slDockable_Count: Integer;
   s_Enabled: Boolean;
begin
     sl_Count        := sl.Count;
     slDockable_Count:= slDockable.Count;
     s_Enabled:= (sl_Count > 0) and (sl_Count > slDockable_Count);
     s.Enabled:= s_Enabled;
     s.Visible:= s_Enabled;

     if not s_Enabled then exit;

     s.Value:=0;
     //s.PageSize:= 1;
     s.Min:= 0;
     s.Max:= sl.Count;
     //s.PageSize:= slDockable.Count;
end;

procedure TDockableScrollbox.Calcul_Capacite;
begin
     Capacite:= Trunc(p.Height) div HauteurLigne;
end;

procedure TDockableScrollbox.Resize;
begin
     inherited;
     Setsl( sl);
end;

procedure TDockableScrollbox.Ajuste_Nombre_Dockables;
var
   Bas: Integer;
   iLastPanel: Integer;
   LastPanel: TPanel;
   Delta: Integer;

   procedure Cas_Ajoute;
   var
      pa: TPanel;
      dk: TDockable;
   begin
        if sl.Count = slDockable.Count then exit;

        while Bas <= p_ClientHeight-HauteurLigne
        do
          begin
          dk:= Cree_Panel_et_Dockable( Bas, pa);
          Bas:= Bas + HauteurLigne;
          end;
        s_Set_MinMax;
        _from_Scroll;
   end;
   procedure Cas_Enleve;
   var
      iDockable: Integer;
      pa: TPanel;
      dk: TDockable;
   begin
        while Bas > p_ClientHeight-HauteurLigne
        do
          begin
          iDockable:= slDockable.Count - 1;
          Supprime_dockable( iDockable);
          Bas:= Bas - HauteurLigne;
          end;
        s_Set_MinMax;
        _from_Scroll;
   end;
begin
     if Ajuste_Nombre_Dockables_running then exit;
     Ajuste_Nombre_Dockables_running:= True;
     try
        if slPanel.Count = 0 then exit;

        p_ClientHeight:= Trunc(p.Height);

        iLastPanel:= slPanel.Count - 1;
        LastPanel:= Panel_from_sl( slPanel, iLastPanel);
        if nil = LastPanel then exit;

        Bas:= (*LastPanel.Top*)+Trunc(LastPanel.Height);
        Delta:= p_ClientHeight - Bas;

              if Delta < 0             then Cas_Enleve
        else  if Delta > HauteurLigne  then Cas_Ajoute;
     finally
            Ajuste_Nombre_Dockables_running:= False;
            end;
end;


end.

