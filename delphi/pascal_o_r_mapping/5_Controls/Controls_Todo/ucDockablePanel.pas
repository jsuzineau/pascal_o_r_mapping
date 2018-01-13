unit ucDockablePanel;
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
    uChamp,
    uChamps,
    uDataUtilsU,
    uBatpro_StringList,
    uProgression,
    u_sys_,
    uWinUtils,
    uPublieur,
    uTri_Ancetre,
    uDockable,
  SysUtils, Classes, FMX.Controls, FMX.Forms, ExtCtrls,FMX.Graphicso,StdCtrls,Types, Math;

type
 TDockable_Event= procedure ( _dk: TDockable) of object;
 TDockableScrollbox_Colonne
 =
  record
    Control  : TControl;
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
 TDockablePanel
 =
  class( TPanel)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Méthodes surchargées
  protected
    procedure Loaded; override;
    procedure Paint; override;
  //Panel
  public
    p: TPanel;
  //Classe des dockables
  public
    Classe_dockable: TDockableClass;
  //Liste d'objets
  private
    Fsl: TBatpro_StringList;
    Setsl_running: Boolean;
    procedure Setsl(const Value: TBatpro_StringList);
    procedure Vide;
    procedure Supprime_dockable( Index: Integer);
    procedure SetLectureSeule(const Value: Boolean);
  public
    property sl: TBatpro_StringList read Fsl write Setsl;
  // Liste des dockables et de leurs panels
  public
    slDockable: TBatpro_StringList;
    slPanel   : TBatpro_StringList;
    procedure Get_Dockable( nDockable: Integer; var dk);
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
  //Suppression
  private
    tSuppression: TTimer;
    iSuppression: Integer;
    procedure DemandeSuppression( Sender: TObject);
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
    pColumnFooter: TPanel;
    Colonnes: array of TDockableScrollbox_Colonne;
    Surtitres: array of TDockableScrollbox_Surtitre;
    procedure Ajoute_Surtitre( _Surtitre: TDockable_Surtitre);
    procedure Ajoute_Colonne( _C: TControl;
                              _Titre   : String  = ''   ;
                              _NomChamp: String  = ''   ;
                              _Total   : TDockableScrollbox_Total = dsbt_Aucun);
    procedure Enleve_Colonnes;
    procedure Initialise_Colonnes( _Premier: Boolean= False);
    procedure Colonne_MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
  //Gestion de la totalisation
  private
    Traiter_Totaux: Boolean;
    slChamps_abonnements: TBatpro_StringList;
    procedure lTotal_MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
    procedure RecalculeTotaux;
  //Gestion du tri
  public
    Tri: TTri_Ancetre;
  //Messages divers envoyés au niveau du DockablePanel
  public
    procedure Envoie_Message( _iMessage: Integer);
  //Gestion de l'ascenseur
  private
    sbV: TScrollbar;
    sbVChange_disabled: Boolean;
    sbVChange_running: Boolean;
    procedure sbVChange(Sender:TObject);
    procedure sbVScroll(Sender:TObject;ScrollCode:TScrollCode;var ScrollPos:Integer);
  //Texte quand le composant est vide
  private
    FTextVide: String;
  published
    property TextVide: String read FTextVide write FTextVide;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TDockablePanel]);
end;

{ TDockablePanel }

constructor TDockablePanel.Create(AOwner: TComponent);
begin
     inherited;
     Setsl_running:= False;

     slDockable:= TBatpro_StringList.Create;
     slPanel   := TBatpro_StringList.Create;
     slChamps_abonnements
     :=
       TBatpro_StringList.CreateE( 'TDockablePanel.slChamps_abonnements', TChamp);
     HauteurLigne:= 24;
     BordureLignes:= True;
     Classe_dockable:= nil;
     Classe_Elements:= nil;

     //Gestion de la validation
     FValide:= True;
     pValide_Change:= TPublieur.Create( Name+'.pValide_Change');

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
     pColumnHeader.Top  := 0;
     pColumnHeader.Left := 0;
     pColumnHeader.Align:= alTop;
     pColumnHeader.ParentBackground:= False;
     pColumnHeader.BevelOuter:= bvNone;

     //Gestion du pied des colonnes
     Traiter_Totaux:= False;
     pColumnFooter:= TPanel.Create( Self);
     pColumnFooter.Parent:= Self;
     pColumnFooter.Top  := 0;
     pColumnFooter.Left := 0;
     pColumnFooter.Align:= alBottom;
     pColumnFooter.ParentBackground:= False;
     pColumnFooter.BevelOuter:= bvNone;

     //Gestion de l'ascenseur
     sbV:= TScrollbar.Create( Self);
     sbV.Parent:= Self;
     sbV.Align:= alRight;
     sbV.Kind:= sbVertical;
     sbV.OnChange:= sbVChange;
     sbV.OnScroll:= sbVScroll;
     sbVChange_disabled:= False;
     sbVChange_running:= False;

     //Le panel
     p:= TPanel.Create( Self);
     p.Parent:= Self;
     p.Top  := 0;
     p.Left := 0;
     p.Align:= alClient;
     p.ParentBackground:= False;

     //pColumnHeader.Parent:= p;
     //pColumnHeader.Caption:= 'truc';
     //Couleurs
     Zebrage1:= $00E6FFE6;
     Zebrage2:= $00FFFFE8;


     Initialise_Colonnes( True);
     Tri:= nil;
     
     FTextVide:= '';
end;

destructor TDockablePanel.Destroy;
begin
     tSuppression.Enabled:= False;
     Free_nil( pValide_Change);
     Free_nil( slChamps_abonnements);
     Free_nil( slDockable);
     Free_nil( slPanel   );
     inherited;
end;

procedure TDockablePanel.Loaded;
begin
     inherited;
     p.OnDblClick:= OnDblClick;
end;

procedure TDockablePanel.Ajoute_Surtitre( _Surtitre: TDockable_Surtitre);
var
   I, NewLength: Integer;
begin
     I:= Length(Surtitres);
     NewLength:= I+1;
     SetLength( Surtitres, NewLength);
end;

procedure TDockablePanel.Ajoute_Colonne( _C: TControl;
                                             _Titre   : String  = ''   ;
                                             _NomChamp: String  = ''   ;
                                             _Total   : TDockableScrollbox_Total = dsbt_Aucun);
var
   I, NewLength: Integer;
   L: TLabel;
   _TopLeft: TPoint;
   sTri: String;
   C_Alignment: TAlignment;
begin
     I:= Length(Colonnes);
     NewLength:= I+1;
     SetLength( Colonnes, NewLength);

     _TopLeft:= pColumnHeader.ScreenToClient( _C.ClientToScreen( Point(0,0)));

          if _C is TLabel then C_Alignment:= TLabel(_C).Alignment
     else if _C is TMemo  then C_Alignment:= TMemo (_C).Alignment
     else                      C_Alignment:= taLeftJustify;

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
     L.Top   := 2;
     L.Left  := _TopLeft.X;
     L.Width := _C.Width;
     L.Height:= pColumnHeader.ClientHeight- L.Top;
     L.Caption:= _Titre + sTri;
     L.Tag   := I;
     L.Transparent:= False;
     with L.Font do Style:= Style + [fsBold];
     L.Alignment:= C_Alignment;
     L.OnMouseDown:= Colonne_MouseDown;
     L.Show;


     with Colonnes[I]
     do
       begin
       Control   := L;
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
           lTotal.Top   := 2;
           lTotal.Left  := _TopLeft.X;
           lTotal.Width := _C.Width;
           lTotal.Height:= pColumnFooter.ClientHeight-lTotal.Top;
           lTotal.Caption:= 'TOTAL';
           lTotal.Alignment:= taRightJustify;
           lTotal.Tag   := I;
           lTotal.Transparent:= False;
           with lTotal.Font do Style:= Style + [fsBold];
           lTotal.Alignment:= C_Alignment;
           lTotal.OnMouseDown:= lTotal_MouseDown;
           lTotal.Show;
           end
       else
           lTotal:= nil;
       end;

end;

procedure TDockablePanel.Enleve_Colonnes;
var
   I: Integer;
   C: TControl;
   Champ: TChamp;
begin
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
end;

procedure TDockablePanel.Initialise_Colonnes( _Premier: Boolean= False);
begin
     if not _Premier
     then
         Enleve_Colonnes;
     Traiter_Totaux:= False;
     SetLength( Colonnes , 0);
end;

procedure TDockablePanel.Colonne_MouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

     Setsl( sl);
end;

procedure TDockablePanel.lTotal_MouseDown( Sender: TObject;
                                               Button: TMouseButton;
                                               Shift: TShiftState;
                                               X, Y: Integer);
begin

end;

procedure TDockablePanel.RecalculeTotaux;
var
   Colonne_Total: array of double;

   I: Integer;
   CP: TChampsProvider;
   Champs: TChamps;

   J: Integer;
   Champ: TChamp;
begin
     SetLength( Colonne_Total, Length(Colonnes));
     for J:= Low(Colonne_Total) to High( Colonne_Total)
     do
       Colonne_Total[J]:= 0;

     for I:= 0 to sl.Count - 1
     do
       begin
       CP:= TChampsProvider( sl.Objects[ I]);
       CheckClass( CP, TChampsProvider);
       if CP= nil then continue;

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
           dsbt_Decimal: lTotal.Caption:= FloatToStr( Colonne_Total[J]);
           dsbt_Heure  : lTotal.Caption:= sHeure    ( Colonne_Total[J]);
           end;
         end;
end;

procedure TDockablePanel.sbVScroll(Sender:TObject;ScrollCode:TScrollCode;var ScrollPos:Integer);
begin

end;

procedure TDockablePanel.sbVChange(Sender: TObject);
var
   I, IDebut, IFin, PageSize: Integer;
   dk: TDockable;
   O: TObject;
   pa: TPanel;
   Bas: Integer;
   sbV_Visible: Boolean;
   LargeurLigne: Integer;
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
        CP:= TChampsProvider(O);
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
     if Setsl_running then exit;

     if sbVChange_disabled then exit;
     if sbVChange_running  then exit;
     try
        sbVChange_running:= True;

        Bas:= 0;

        PageSize:= p.ClientHeight div HauteurLigne;
        LargeurLigne:= p.ClientWidth;
        sbV_Visible:= PageSize < sl.Count;
        sbv.ShowHint:= True;
        sbV.PageSize:= PageSize;
        sbV.LargeChange:= PageSize;
        //sbV.Visible:= sbV_Visible;

        if sbV_Visible
        then
            begin
            IDebut:= sbV.Position;
            IFin  := Min( sl.Count - 1, IDebut+PageSize-1);
            end
        else
            begin
            IDebut:= 0;
            IFin  := sl.Count - 1;
            end;
        sbv.Hint
        :=
           'IDebut        '+ IntToStr(IDebut        )+#13#10
          +'IFin          '+ IntToStr(IFin          )+#13#10
          +'sl.Count      '+ IntToStr(sl.Count      )+#13#10
          +'sbV.PageSize  '+ IntToStr(sbV.PageSize  )+#13#10
          +'sbV.SmallChange  '+ IntToStr(sbV.SmallChange  )+#13#10
          +'sbV.LargeChange  '+ IntToStr(sbV.LargeChange  )+#13#10
          +'p.ClientHeight'+ IntToStr(p.ClientHeight)+#13#10
          +'HauteurLigne  '+ IntToStr(HauteurLigne  )+#13#10
          +'p.ClientHeight div HauteurLigne '+ IntToStr(p.ClientHeight div HauteurLigne)+#13#10;


        //uProgression_Demarre( 'Remplissage de la boite de défilement', IDebut, IFin, False, True);

        for I:= 0 to IDebut-1
        do
          begin
          pa:= Panel_from_sl( slPanel, I);
          if Assigned( pa)
          then
              pa.Hide;
          end;
        for I:= IFin+1 to sl.Count-1
        do
          begin
          pa:= Panel_from_sl( slPanel, I);
          if Assigned( pa)
          then
              pa.Hide;
          end;
        for I:= IDebut to IFin
        do
          begin
          pa:= Panel_from_sl( slPanel, I);
          if Assigned( pa)
          then
              begin
              pa.Top:= Bas;
              Bas:= Bas + HauteurLigne;
              pa.Show;
              end
          else
              begin
              O:= sl.Objects[ I];

              pa:= TPanel.Create( nil);
              pa.Parent:= p;
              pa.Top:= Bas;

              pa.Left:= 0;
              pa.Width:= LargeurLigne;
              //pa.Align:= alTop;

              pa.DockSite:= True;
              pa.Height:= HauteurLigne;
              if BordureLignes
              then
                  pa.BevelOuter:= bvRaised
              else
                  pa.BevelOuter:= bvNone;

              Bas:= Bas + HauteurLigne;


              Create_Dockable( dk, Classe_dockable, pa);

              slDockable.Objects[ I]:= dk;
              slPanel   .Objects[ I]:= pa;

              dk.Objet:= O;
              dk.pValide_Change.Abonne( Self, Verifie_Validites);

              dk.DockableScrollbox_Suppression:= DemandeSuppression;
              dk.DockableScrollbox_Selection  := DemandeSelection  ;
              dk.DockableScrollbox_Validation := DemandeValidation ;
              dk.DockableScrollbox_Precedent  := DockableScrollbox_Precedent;
              dk.DockableScrollbox_Suivant    := DockableScrollbox_Suivant  ;
              dk.DockableScrollbox_Nouveau    := DockableScrollbox_Nouveau  ;

              if Zebrage
              then
                  if Odd( I)
                  then
                      dk.Color:= Zebrage1
                  else
                      dk.Color:= Zebrage2;

              dk.Traite_LectureSeule( FLectureSeule);

              Do_OnCreateDockable( dk);
              if I = 0
              then
                  begin
                  Traite_ColumnHeader;
                  if Length(Colonnes) > 0
                  then
                      begin
                      pColumnHeader.Show;
                      pa.Top:= Bas;
                      Bas:= Bas + HauteurLigne;
                      pColumnFooter.Visible:= Traiter_Totaux;
                      end;
                  end;
              TraiteTotaux;
              //uProgression_AddProgress( 1);
              //uForms_ProcessMessages;
              if uProgression_GetInterrompre
              then
                  break;
              end;
          end;
        //uProgression_Termine;
        if Traiter_Totaux
        then
            RecalculeTotaux;
     finally
            sbVChange_running:= False;
            end;
end;

procedure TDockablePanel.Paint;
begin
     inherited;
end;

procedure TDockablePanel.Setsl(const Value: TBatpro_StringList);
var
   I: Integer;
   NewPageSize, NewMax: Integer;
   NewEnabled: Boolean;
begin
     try
        Setsl_running:= True;
        Vide;
        if Classe_dockable = nil then exit;

        Fsl := Value;
        if sl = nil then exit;
        if sl.Count = 0 then exit;

        p.Caption:= '';

        pColumnHeader.Height:= 17;
        pColumnHeader.Hide;

        pColumnFooter.Height:= 17;
        pColumnFooter.Hide;

        NewPageSize:= p.ClientHeight div HauteurLigne;
        NewMax     := sl.Count - 1;
        NewEnabled:= NewPageSize <= NewMax ;
        sbV.Enabled:= NewEnabled;
        if NewEnabled
        then
            try
               sbVChange_disabled:= True;

               sbV.PageSize:= NewPageSize;
               sbV.Min:= 0;
               sbV.Max:= NewMax;
            finally
                   sbVChange_disabled:= False;
                   end;
        for I:= 0 to sl.Count-1
        do
          begin
          slPanel   .AddObject( ' ', nil);
          slDockable.AddObject( ' ', nil);
          end;
     finally
            Setsl_running:= False;
            end;
     sbVChange( sbV);
end;

procedure TDockablePanel.SetValide( const Value: Boolean);
begin
     if FValide = Value then exit;

     FValide := Value;
     pValide_Change.Publie;
end;

procedure TDockablePanel.Verifie_Validites;
var
   I: Integer;
   dk: TDockable;
   Valide_AND: Boolean;
begin
     Valide_AND:= True;

     for I:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, I);
       if Assigned( dk)
       then
           begin
           Valide_AND:= dk.Valide;
           if not Valide_AND then break;
           end;
       end;

     Valide:= Valide_AND;
end;

procedure TDockablePanel.Supprime_dockable( Index: Integer);
var
   dk: TDockable;
   p: TPanel;
begin
     dk:= Dockable_from_sl( slDockable, Index);
     p :=    Panel_from_sl( slPanel   , Index);
     if     Assigned( dk)
        and Assigned( p )
     then
         begin
         dk.Objet:= nil;
         dk.pValide_Change.Desabonne( Self, Verifie_Validites);
         Destroy_Dockable( dk);
         Free_nil( p);
         end;
     slDockable.Delete( Index);
     slPanel   .Delete( Index)
end;

procedure TDockablePanel.Vide;
var
   I: Integer;
begin
     sbV.Position:= sbv.Min;
     Selection:= nil;
     //sbV.Hide;

     if sl = nil then exit;

     for I:= slDockable.Count - 1 downto 0
     do
       Supprime_dockable( I);

     p.Caption:= FTextVide;
end;

procedure TDockablePanel.DemandeSuppression(Sender: TObject);
begin
     iSuppression:= slDockable.IndexOfObject( Sender);
     if iSuppression <> -1
     then
         tSuppression.Enabled:= True;
end;

procedure TDockablePanel.tSuppressionTimer( Sender: TObject);
begin
     if iSuppression = -1 then exit;
     tSuppression.Enabled:= False;

     Supprime_dockable( iSuppression);

     Verifie_Validites;

     Do_OnSuppression;

     pValide_Change.Publie;
end;

procedure TDockablePanel.Do_OnSuppression;
begin
     if Assigned( OnSuppression)
     then
         OnSuppression( Self);
end;

procedure TDockablePanel.Get_Dockable( nDockable: Integer; var dk);
var
   O: TObject;
begin
     TDockable( dk):= nil;
     if nDockable < 0                 then exit;
     if nDockable >= slDockable.Count then exit;
     O:= slDockable.Objects[ nDockable];
     if O = nil then exit;
     if not (O is Classe_dockable) then exit;

     TDockable( dk):= TDockable( O);
end;

procedure TDockablePanel.TraiteSelection(Sender: TObject);
begin
     if Assigned( Selection)
     then
         Selection.Affiche_Selection( False);

     if Sender is TDockable
     then
         begin
         Selection:= TDockable( Sender);
         Selection.Affiche_Selection( True);
         FIndex:= slDockable.IndexOfObject( Selection);
         end
     else
         begin
         Selection:= nil;
         FIndex:= -1;
         end;
end;

procedure TDockablePanel.DemandeSelection(Sender: TObject);
begin
     TraiteSelection( Sender);

     Do_OnSelect;
end;

procedure TDockablePanel.DemandeValidation(Sender: TObject);
begin
     TraiteSelection( Sender);

     Do_OnValidate;
end;

procedure TDockablePanel.Do_OnSelect;
begin
     if Assigned( OnSelect)
     then
         OnSelect( Self);
end;

procedure TDockablePanel.Do_OnValidate;
begin
     if Assigned( OnValidate)
     then
         OnValidate( Self);
end;

procedure TDockablePanel.Get_bl(var bl);
begin
     TObject( bl):= nil;

     if Selection = nil then exit;

     TObject( bl):= Selection.Objet;

     if TObject( bl) = nil then exit;

     if TObject( bl) is Classe_Elements then exit; // OK

     //on renvoie nil si ce n'est pas un élément de la bonne classe
     TObject( bl):= nil;
end;

procedure TDockablePanel.SetIndex(const Value: Integer);
var
   dk: TDockable;
begin
     Get_Dockable( Value, dk);
     if dk = nil then exit;
     dk.Do_DockableScrollbox_Selection;
     Do_OnSelect;
end;

procedure TDockablePanel.DockableScrollbox_Precedent(Sender: TObject);
begin
     Index:= Index - 1;
end;

procedure TDockablePanel.DockableScrollbox_Suivant(Sender: TObject);
begin
     if Index = sl.Count-1
     then
         Do_OnNouveau
     else
         Index:= Index + 1;
end;

procedure TDockablePanel.DockableScrollbox_Nouveau(Sender: TObject);
begin
     Do_OnNouveau;
end;

procedure TDockablePanel.Do_OnNouveau;
begin
     if Assigned( OnNouveau)
     then
         OnNouveau( Self);
end;

procedure TDockablePanel.SetLectureSeule(const Value: Boolean);
var
   I: Integer;
   dk: TDockable;
begin
     FLectureSeule:= Value;

     for I:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, I);
       if Assigned( dk)
       then
           dk.Traite_LectureSeule( FLectureSeule);
       end;
end;

procedure TDockablePanel.Do_OnCreateDockable( _dk: TDockable);
begin
     if Assigned( OnCreateDockable)
     then
         OnCreateDockable( _dk);
end;

procedure TDockablePanel.Envoie_Message( _iMessage: Integer);
var
   I: Integer;
   dk: TDockable;
begin
     for I:= 0 to slDockable.Count - 1
     do
       begin
       dk:= Dockable_from_sl( slDockable, I);
       if Assigned( dk)
       then
           dk.Traite_Message( Self, _iMessage);
       end;
end;

end.

