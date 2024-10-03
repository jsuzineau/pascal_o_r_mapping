unit ucBatproMaskElement;
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
    uBatpro_StringList,
    uSGBD,
    uEdit_WANTTAB,
    uDBEdit_WANTTAB,
    uChamps,
    uChamp,

    ufAccueil_Erreur,

  Windows, Messages, SysUtils, Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.StdCtrls, DB, VCL.ExtCtrls, Math,System.UITypes, VCL.Buttons;

type
 TBatproMaskElementDefault = (bmed_Aucun, bmed_Premier, bmed_Dernier);
 TBatproMaskElement = class;

 TAfficheListeExecute
 =
  function ( _bme: TBatproMaskElement; _bme_PreExecute: Boolean): Boolean of object;

 TAfterExecute
 =
  procedure ( Sender: TObject; ExecuteResult: Boolean) of object;

 TGetChamp_id= function : TChamp of object;

 //Pattern décorateur
 TBatproMaskElement_SQLConstraint_DecoreValeur= function ( _Valeur: String): String of object;

 TBatproMaskElement
 =
  class( TPanel)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  { Déclarations privées }
  private
    ButtonWidth: Integer;
    _E: TEdit_WANTTAB;
    DBE: TDBEdit_WANTTAB;
    L: TLabel;
    B: TSpeedButton;
    EChanging: Boolean;
    Modified: Boolean;
    ChangeWaiting: Boolean;
    LibelleOK: Boolean;
    PreExecution: Boolean;
    FLectureSeule: Boolean;
    procedure Positionne;

    procedure BClick( Sender: TObject);

    procedure EChange( Sender: TObject);
    procedure EEnter ( Sender: TObject);
    procedure EExit  ( Sender: TObject);
    procedure EKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EKeyUp  ( Sender: TObject; var Key: Word; Shift: TShiftState);

    function  Execute: Boolean;

    procedure DoChange;
    procedure DoAfterExecute( ExecuteResult: Boolean);

    procedure LabelLibelle_from_TextLibelle;

    procedure Debranche_EChange;
    procedure Rebranche_EChange;
    procedure Traite_EChange_Ajourne;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure Clear_Nexts;
  protected
    { Déclarations protégées }
    procedure Resize; override;
    procedure CreateWnd; override;

    procedure Go;
    procedure GoNext;
    procedure GoPrevious;
    function  DoExecute(Pre: Boolean): Boolean;
    procedure DoExit; override;
  public
    { Déclarations publiques }
    AutoLayout: Boolean;
    AfficheListeExecute: TAfficheListeExecute;
    ChangeAtExit: Boolean;
    slChamps: TBatpro_StringList;
    VK_RETURN_Execute: Boolean;
    TraiterTabulation: Boolean;
    function  SQL_Where( Filter: Boolean= False): String;
    function  PreExecute: Boolean;
    procedure TraiteHauteur;
    procedure TraitePrevious;
    procedure Set_DataSource_DataField(DS: TDataSource; DF: String);
    procedure Reset;
    procedure _from_Query( Q: TDataset);
    procedure _from_Champs( CS: TChamps; _bl: TObject; _id: Integer);
    procedure SetFocus; override;
    procedure SelectAll;
    procedure slChamps_from_Q_Fields(Q: TDataset);
    procedure slChamps_from_Champs(CS: TChamps);
  //SelStart
  private
    function  GetSelStart: Integer;
    procedure SetSelStart( Value: Integer);
  public
    property SelStart: Integer read GetSelStart write SetSelStart;
  //CharCase
  private
    procedure SetCharCase(Value: TEditCharCase);
    function GetCharCase: TEditCharCase;
  public
    property CharCase: TEditCharCase read GetCharCase write SetCharCase;
  //LectureSeule
  private
    function  GetLectureSeule: Boolean;
    procedure SetLectureSeule( Value: Boolean);
  public
    property LectureSeule: Boolean read GetLectureSeule write SetLectureSeule;
  //Pointeur vers le Batpro_Ligne sélectionné (uniquement avec fRechercheBatpro_Ligne)
  public
    bl: TObject;
    id: Integer;

  //Propriétés publiées
  published
    property Visible;
    property OnKeyDown;
    property OnEnter;
    property OnExit;
  //bme0Previous
  private
    Fbme0Previous : TBatproMaskElement;
    procedure Setbme0Previous( Value: TBatproMaskElement);
  published
    property bme0Previous :TBatproMaskElement read Fbme0Previous write Setbme0Previous;
  //bme1Next
  private
    Fbme1Next: TBatproMaskElement;
  published
    property bme1Next: TBatproMaskElement read Fbme1Next write Fbme1Next;
  //bme2Code
  private
    Fbme2Code: String;
  published
    property bme2Code: String read Fbme2Code write Fbme2Code;
  //bme3Libelle
  private
    Fbme3Libelle: String;
  published
    property bme3Libelle: String read Fbme3Libelle write Fbme3Libelle;
  //bme4WhereFixe
  private
    Fbme4WhereFixe: String;
  published
    property bme4WhereFixe: String read Fbme4WhereFixe write Fbme4WhereFixe;
  //bme5DataSource
  private
    Fbme5DataSource: TDataSource;
    procedure Setbme5DataSource( Value: TDataSource);
  published
    property bme5DataSource: TDataSource read Fbme5DataSource write Setbme5DataSource;
  //bme6DataField
  private
    Fbme6DataField: String;
    procedure Setbme6DataField( const Value: string);
  published
    property bme6DataField: String read Fbme6DataField write Setbme6DataField;
  //bme7LabelLibelle
  private
    Fbme7LabelLibelle: TLabel;
    procedure Setbme7LabelLibelle(Value: TLabel);
  published
    property bme7LabelLibelle: TLabel read Fbme7LabelLibelle write Setbme7LabelLibelle;
  //bme8RequeteExistence_Informix
  private
    Fbme8RequeteExistence_Informix: String;
  published
    property bme8RequeteExistence_Informix: String read Fbme8RequeteExistence_Informix write Fbme8RequeteExistence_Informix;
  //bme9RequeteExistence_MySQL
  private
    Fbme9RequeteExistence_MySQL: String;
  published
    property bme9RequeteExistence_MySQL: String read Fbme9RequeteExistence_MySQL write Fbme9RequeteExistence_MySQL;
  //MaxLength
  private
    function  GetMaxLength: Integer;
    procedure SetMaxLength( Value: Integer);
  published
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
  //Text
  private
    function  GetText: String;
    procedure SetText( Value: String);
  published
    property Text: String read GetText write SetText;
  //TextMin
  private
    FTextMin: String;
    procedure SetTextMin( Value: String);
  published
    property TextMin: String read FTextMin write SetTextMin;
  //TextLibelle
  private
    FTextLibelle: String;
    procedure SetTextLibelle(Value: String);
  published
    property TextLibelle: String read FTextLibelle write SetTextLibelle;
  //OrderBy
  private
    FOrderBy: String;
  published
    property OrderBy: String read FOrderBy write FOrderBy;
  //Default
  private
    FDefault: TBatproMaskElementDefault;
    procedure SetDefault( Value: TBatproMaskElementDefault);
  published
    property Default: TBatproMaskElementDefault read FDefault write SetDefault;
  //OnChange
  private
    FOnChange: TNotifyEvent;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  //AfterExecute
  private
    FAfterExecute: TAfterExecute;
  published
    property AfterExecute: TAfterExecute read FAfterExecute write FAfterExecute;
  //OnGoNext
  private
    FOnGoNext: TNotifyEvent;
  published
    property OnGoNext: TNotifyEvent read FOnGoNext write FOnGoNext;
  //OnGoPrevious
  private
    FOnGoPrevious: TNotifyEvent;
  published
    property OnGoPrevious: TNotifyEvent read FOnGoPrevious write FOnGoPrevious;
  //Champ id
  public
    GetChamp_id_function: TGetChamp_id;
    function GetChamp_id: TChamp;
  //Contrainte SQL
  private
    function Traite_Inf_Sup(S: String): String;
    function Traite_BETWEEN(S: String; Pos_2points: Integer): String;
    function Do_SQLConstraint_DecoreValeur( _Valeur: String): String;
  public
    SQLConstraint_DecoreValeur: TBatproMaskElement_SQLConstraint_DecoreValeur;
    function SQLConstraint: String;
  //Couleur de fond de l'éditeur
  private
    function  getColorEdit: TColor;
    procedure setColorEdit(const Value: TColor);
  public
    property ColorEdit: TColor read getColorEdit Write setColorEdit;
  //Gestion du label
  private
    FIsLabel: Boolean;
    procedure SetIsLabel( Value: Boolean);
  public
    property IsLabel: Boolean read FIsLabel write SetIsLabel;
  end;

procedure Register;

implementation

uses
    uDataUtilsU,
    uWinUtils,
    u_sys_, uClean;

procedure Register;
begin
  RegisterComponents('Batpro', [TBatproMaskElement]);
end;

constructor TBatproMaskElement.Create(AOwner: TComponent);
var
   Bitmap: HBitmap;
begin
     inherited;

     SQLConstraint_DecoreValeur:= nil;

     BevelInner:= bvNone;
     BevelOuter:= bvNone;

     VK_RETURN_Execute:= True;
     TraiterTabulation:= False;
     AfficheListeExecute:= nil;
     AutoLayout  := True;
     bme0Previous:= nil;
     bme1Next    := nil;
     FOnChange   := nil;
     FOnGoNext   := nil;

     PreExecution:= False;

     ButtonWidth:= GetSystemMetrics(SM_CXVSCROLL);
     FLectureSeule:= False;

     B:= TSpeedButton.Create( Self);
     with B do ControlStyle:= ControlStyle + [csReplicatable];
     B.Width := ButtonWidth;
     B.Height:= ButtonWidth;
     B.Visible:= True;
     B.Parent:= Self;
     B.OnClick:= BClick;
     Bitmap:= Windows.LoadBitmap( 0, PChar(OBM_COMBO));
     //B.Glyph.Handle:= Bitmap;
     b.Cursor:= crArrow;

     EChanging:= False;

     _E:= TEdit_WANTTAB.Create( Self);
     with _E do ControlStyle:= ControlStyle + [csReplicatable];
     _E.Visible:= True;
     _E.Parent:= Self;
     _E.OnChange := EChange ;
     _E.OnEnter  := EEnter  ;
     _E.OnExit   := EExit   ;
     _E.OnKeyDown:= EKeyDown;
     _E.OnKeyUp  := EKeyUp  ;

     DBE:= TDBEdit_WANTTAB.Create( Self);
     DBE.Visible:= False;
     DBE.Parent:= Self;
     DBE.OnChange := EChange ;
     DBE.OnEnter  := EEnter  ;
     DBE.OnExit   := EExit   ;
     DBE.OnKeyDown:= EKeyDown;
     DBE.OnKeyUp  := EKeyUp  ;

     L:= TLabel.Create( Self);
     L.Visible := False;
     L.AutoSize:= False;
     L.Parent:= Self;

     bme5DataSource:= nil;
     bme6DataField := sys_Vide;

     bme7LabelLibelle:= nil;
     TextLibelle:= sys_Vide;

     Fbme8RequeteExistence_Informix:= sys_Vide;
     Fbme9RequeteExistence_MySQL   := sys_Vide;
     FOrderBy:= sys_Vide;
     Modified:= False;
     ChangeAtExit:= True;
     ChangeWaiting:= False;
     LibelleOK:= False;

     slChamps:= TBatpro_StringList.Create;
     bl:= nil;

     GetChamp_id_function:= nil;
end;

destructor TBatproMaskElement.Destroy;
begin
     Free_nil( slChamps);
     inherited;
end;

procedure TBatproMaskElement.Positionne;
var
   Largeur, Hauteur: Integer;
begin
     //Calcul largeur
     Largeur:= ClientWidth;
     if not IsLabel
     then
         Largeur:= Largeur-ButtonWidth;

     Hauteur:= ClientHeight;

     _E.Left  := 0;
     _E.Width := Largeur;
     _E.Height:= Hauteur;

     DBE.Left  := 0;
     DBE.Width := Largeur;
     DBE.Height:= Hauteur;

     L.Left  := 0;
     L.Width := Largeur;
     L.Height:= Hauteur;

     B.Left  := Largeur;
     B.Height:= Hauteur;
end;

procedure TBatproMaskElement.Resize;
begin
     Positionne;
     inherited;
end;

function  TBatproMaskElement.DoExecute( Pre: Boolean): Boolean;
begin
     Result:= Assigned( AfficheListeExecute);
     if LectureSeule then exit;

     if Result
     then
         begin
         Result:= AfficheListeExecute( Self, Pre);
         DoAfterExecute( Result);
         if Result
         then
             GoNext;
         end;
end;

function  TBatproMaskElement.PreExecute: Boolean;
begin
     Result:= True;
     if LectureSeule then exit;
     try
        PreExecution:= True;
        Result:= DoExecute( True);
     finally
            PreExecution:= False;
            end;
end;

function  TBatproMaskElement.Execute: Boolean;
begin
     Result:= DoExecute( False);
     DoChange;

     uForms_ProcessMessages;
     B.Refresh;
end;

procedure TBatproMaskElement.BClick(Sender: TObject);
begin
     SetFocus;

     if bme5DataSource = nil
     then
         try
            Debranche_EChange;
            Text:= sys_Vide;
         finally
                Rebranche_EChange;
                end;
     Execute;
     Traite_EChange_Ajourne;
end;

procedure TBatproMaskElement.TraiteHauteur;
var
   Largeur: Integer;
begin
     //if not HandleAllocated then exit;
     if IsLabel
     then
         begin
         Largeur:= LargeurTexte(L.Font,L.Caption)+2*10(*GetSystemMetrics(SM_CXEDGE)*);
         ClientWidth:= Largeur;

         ClientHeight:= LineHeight( L.Font)+2*10(*GetSystemMetrics(SM_CYEDGE)*)+1;
         end
     else
         begin
         Largeur:= LargeurTexte( _E.Font, StringOfChar('W', _E.MaxLength+1))+
                   2*10(*GetSystemMetrics(SM_CXEDGE)*);
         ClientWidth:= Largeur + ButtonWidth;

         ClientHeight:= Max( LineHeight( _E.Font)+2*10(*GetSystemMetrics(SM_CYEDGE)*)+1,
                             ButtonWidth);
         end;
end;

procedure TBatproMaskElement.CreateWnd;
begin
     inherited;
     TraiteHauteur;
     Positionne;
end;

procedure TBatproMaskElement.EKeyDown( Sender: TObject;
                                       var Key: Word; Shift: TShiftState);
begin
     KeyDown( Key, Shift);
     case Key
     of
       VK_F8:
         Execute;
       VK_TAB:
              if ssShift in Shift
         then
             GoPrevious
         else if TraiterTabulation
         then
             Execute
         else
             GoNext;
       VK_RETURN:
         if VK_RETURN_Execute
         then
             Execute
         else
             GoNext;
       end;
end;

procedure TBatproMaskElement.EKeyUp  ( Sender: TObject;
                                       var Key: Word; Shift: TShiftState);
begin
     case Key
     of
       VK_BACK:
         if Length( Text) = 0
         then
             GoPrevious;
       VK_F9:
         GoPrevious;
       VK_LEFT:
         if SelStart = 0
         then
             GoPrevious;
       else
         if Length( Text) = MaxLength
         then
             GoNext;
       end;
end;


procedure TBatproMaskElement.Clear_Nexts;
var
   bme: TBatproMaskElement;
begin
     TextLibelle:= sys_Vide;
     bme:= bme1Next;
     while Assigned( bme)
     do
       begin
       bme.Text:= sys_Vide;
       bme:= bme.bme1Next;
       end;
end;

procedure TBatproMaskElement.EChange( Sender: TObject);
begin
     if EChanging then exit;

     try
        EChanging:= True;

        if ChangeWaiting
        then
            ChangeWaiting:= False;

        if LibelleOK
        then
            LibelleOK:= False
        else
            TextLibelle:= sys_Vide;
        bl:= nil;
        id:= 0;

        //FDataLink.Edit;
        //FDataLink.Modified;
        //FDataLink.UpdateRecord;

        if ChangeAtExit
        then
            Modified:= True
        else
            DoChange;

        if Sender = _E
        then
            Clear_Nexts;
     finally
            EChanging:= False;
            end;
end;

procedure TBatproMaskElement.EEnter(Sender: TObject);
begin
     DoEnter;
end;

procedure TBatproMaskElement.EExit( Sender: TObject);
begin
     DoExit;
end;

procedure TBatproMaskElement.DoExit;
begin
     inherited;
     if Modified and ChangeAtExit
     then
         begin
         Modified:= False;
         PreExecute;
         DoChange;
         end;
end;

procedure TBatproMaskElement.Go;
begin
     //2013/01/24 PreExecute désactivé car trop long chez SAMPLUS sur les chantiers
     //if    (Text = '')
     //   or not PreExecute
     //then
     //    begin
         SetFocus;
         SelectAll;
     //    end;
end;

procedure TBatproMaskElement.GoNext;
begin
          if Assigned( bme1Next) then bme1Next.Go
     else if Assigned( OnGoNext) then OnGoNext( Self)
     else                             DoExit;
end;

procedure TBatproMaskElement.GoPrevious;
begin
          if Assigned( bme0Previous) then bme0Previous.Go
     else if Assigned( OnGoPrevious) then OnGoPrevious( Self)
     else                                 DoExit;
end;

function TBatproMaskElement.SQL_Where( Filter: Boolean= False): String;
var
   Texte: String;
   NomChamp, Valeur: String;
   ContrainteValeur: String;
begin
     Texte:= Text;

     if Copy( Texte, 1, 1) = '!'
     then
         begin
         NomChamp:= bme3Libelle;
         Valeur  := Copy( Texte, 2, Length(Texte));
         end
     else
         begin
         NomChamp:= bme2Code;
         if Length( Texte) >= MaxLength
         then
             Valeur:= sys_Vide // rajouté pour Pl. Production/Ed. Chantier/equipe
         else
             Valeur:= Texte;
         end;

     if Filter
     then
         ContrainteValeur:= SQL_EGAL_DEBUT    ( NomChamp, Valeur)
     else
         ContrainteValeur:= SQL_Racine( NomChamp, Valeur);

     Result:= SQL_AND( [
                       bme4WhereFixe,
                       ContrainteValeur,
                       SQL_OP     ( bme2Code, '>=', TextMin)
                       ]);
end;

function TBatproMaskElement.GetMaxLength: Integer;
begin
          if L  .Visible then Result:= Length( L.Caption)//à vérifier, n'a peut être pas de sens
     else if DBE.Visible then Result:= DBE.MaxLength
     else                     Result:= _E .MaxLength;
end;

procedure TBatproMaskElement.SetMaxLength(Value: Integer);
begin
     DBE.MaxLength:= Value;
     _E .MaxLength:= Value;
     //TraiteHauteur;
end;

function TBatproMaskElement.GetText: String;
//var
//   DBE_F: TField;
begin
          if L  .Visible then Result:= L.Caption
     else if DBE.Visible
     then
         begin
         // mis en commentaire 2004 09 17
         // pour le problème des équipes sur le détail chantier du
         // planning production.
         // Pas sûr que cela n'aura pas d'effets secondaires
         //DBE_F:= DBE.Field;
         //if Assigned( DBE_F)
         //then
         //    Result:= DBE_F.AsString
         //else
         //    Result:= sys_Vide;

         Result:= DBE.Text;
         end
     else
         Result:= _E .Text;
end;

procedure TBatproMaskElement.SetText(Value: String);
var
   D: TDataset;
   F: TField;
begin
          if L  .Visible then L.Caption:= Value
     else if DBE.Visible
     then
         begin
         F:= nil;
         D:= nil;
         if Assigned( Fbme5DataSource)
         then
             begin
             D:= Fbme5DataSource.DataSet;
             if Assigned( D)
             then
                 begin
                 F:= D.FieldByName( Fbme6DataField);
                 if F= nil
                 then
                     uForms_ShowMessage( NamePath(Self)+
                                  ': TBatproMaskElement.SetText: Fbme5DataSource.DataSet.FieldByName('+
                                  DBE.DataField +') = nil');
                 end
             else
                 uForms_ShowMessage( NamePath(Self)+
                              ': TBatproMaskElement.SetText: bme5DataSource.DataSet'+
                              ' = nil');
             end
         else
             uForms_ShowMessage( NamePath(Self)+
                          ': TBatproMaskElement.SetText: bme5DataSource'+
                          ' = nil');

         if     Assigned( D)
            and Assigned( F)
            and not PreExecution
         then
             begin

             if     D.Active
                and (F.AsString <> Value)
             then
                 begin
                 Edite( D);
                 F.AsString:= Value;
                 Poste( D);
                 end;
             end;
         end
     else
         _E .Text:= Value;
end;

function TBatproMaskElement.GetSelStart: Integer;
begin
          if L  .Visible then Result:= 0
     else if DBE.Visible
     then
         Result:= DBE.SelStart
     else
         Result:= _E .SelStart;
end;

procedure TBatproMaskElement.SetSelStart(Value: Integer);
begin
          if L  .Visible then begin end
     else if DBE.Visible
     then
         DBE.SelStart:= Value
     else
         _E .SelStart:= Value;
end;

procedure TBatproMaskElement.SetCharCase( Value: TEditCharCase);
begin
     //L
     DBE.CharCase:= Value;
     _E .CharCase:= Value;
end;

function TBatproMaskElement.GetCharCase: TEditCharCase;
begin
          if L  .Visible then Result:= ecNormal
     else if DBE.Visible
     then
         Result:= DBE.CharCase
     else
         Result:=  _E.CharCase;
end;

procedure TBatproMaskElement.SetFocus;
var
   CE: TCustomEdit;
begin
     inherited;
     if not Visible then exit;
     if IsLabel
     then
         GoNext
     else
         begin
         if DBE.Visible
         then
             CE:= DBE
         else
             CE:= _E ;

         if CE.CanFocus
         then
             begin
             CE.SetFocus;
             CE.SelectAll;
             end;
         end;
end;

procedure TBatproMaskElement.SelectAll;
begin
     if IsLabel then exit;
     
     if DBE.Visible
     then
         DBE.SelectAll
     else
         _E .SelectAll;
end;

procedure TBatproMaskElement.Setbme0Previous( Value: TBatproMaskElement);
begin
     Fbme0Previous:= Value;
     TraitePrevious;
end;

procedure TBatproMaskElement.TraitePrevious;
var
   NewLeft: Integer;
begin
     if not AutoLayout then exit;
     if Assigned( Fbme0Previous)
     then
         begin
         NewLeft:= Fbme0Previous.Left+Fbme0Previous.Width;
         if IsLabel
         then
             Inc( NewLeft, 3);
         Left:= NewLeft;
         end;
end;

(*
procedure TBatproMaskElement.Show;
begin
     inherited;
     PreExecute;
end;
*)

procedure TBatproMaskElement.DoChange;
begin
     if Assigned( OnChange)
     then
         OnChange( Self);
end;

procedure TBatproMaskElement.DoAfterExecute( ExecuteResult: Boolean);
begin
     if Assigned( FAfterExecute)
     then
         FAfterExecute( Self, ExecuteResult);
end;

procedure TBatproMaskElement.WMPaint(var Message: TWMPaint);
begin
     inherited;
end;

procedure TBatproMaskElement.Setbme5DataSource(Value: TDataSource);
var
   DBE_Visible: Boolean;
begin
     Fbme5DataSource:= Value;

     DBE.DataSource:= Fbme5DataSource;

     DBE_Visible:= Assigned( Fbme5DataSource);
     DBE.Visible:=     DBE_Visible;
     _E .Visible:= not DBE_Visible;
end;

procedure TBatproMaskElement.Setbme6DataField(const Value: string);
begin
     Fbme6DataField:= Value;

     DBE.DataField:= Fbme6DataField;
end;

procedure TBatproMaskElement.Set_DataSource_DataField( DS: TDataSource;
                                                       DF: String);
begin
     bme6DataField := DF;
     bme5DataSource:= DS;
end;

procedure TBatproMaskElement.LabelLibelle_from_TextLibelle;
begin
     if Assigned( bme7LabelLibelle)
     then
         begin
         bme7LabelLibelle.Caption:= TextLibelle;
         bme7LabelLibelle.Refresh;
         end;
end;

procedure TBatproMaskElement.Setbme7LabelLibelle( Value: TLabel);
begin
     if Fbme7LabelLibelle = Value then exit;

     Fbme7LabelLibelle:= Value;
     LabelLibelle_from_TextLibelle;
end;

procedure TBatproMaskElement.SetTextLibelle( Value: String);
begin
     FTextLibelle:= Value;
     LabelLibelle_from_TextLibelle;
end;

procedure TBatproMaskElement.SetTextMin(Value: String);
begin
     if FTextMin = Value then exit;

     FTextMin:= Value;
     PreExecute;
end;

procedure TBatproMaskElement.SetDefault( Value: TBatproMaskElementDefault);
begin
     if FDefault = Value then exit;

     FDefault:= Value;
     PreExecute;
end;

procedure TBatproMaskElement.Reset;
begin
     EChanging:= True;
     try
        Text:= sys_Vide;
        PreExecute;
     finally
            EChanging:= False;
            end;
     EChange( Self);
end;


procedure TBatproMaskElement.Debranche_EChange;
begin
     EChanging:= True;
end;

procedure TBatproMaskElement.Rebranche_EChange;
begin
     EChanging:= False;
     ChangeWaiting:= True;
end;

procedure TBatproMaskElement.Traite_EChange_Ajourne;
begin
     if ChangeWaiting
     then
         EChange( nil);
end;

procedure TBatproMaskElement.slChamps_from_Q_Fields(Q: TDataset);
var
   I: Integer;
   F: TField;
begin
     slChamps.Clear;
     for I:= 0 to Q.FieldCount - 1
     do
       begin
       F:= Q.Fields[ I];
       if Assigned( F)
       then
           slChamps.Values[F.FieldName]:= F.AsString;
       end;
end;

procedure TBatproMaskElement._from_Query( Q: TDataset);
var
   F: TField;
begin
     slChamps_from_Q_Fields( Q);

     if EChanging then exit;

     try
        EChanging:= True;    //passé avec EChanging:= True pour libellé dans
                             //BatproPlanning - fdA_CHT__A_PLA

        F:= q.FindField( bme3Libelle);
        if Assigned( F)
        then
            TextLibelle:= F.AsString
        else
            TextLibelle:= sys_Vide;
        LibelleOK:= True;

        Text:= q.FieldByName( bme2Code).AsString;
     finally
            EChanging:= False;
            end;
end;

procedure TBatproMaskElement.slChamps_from_Champs( CS: TChamps);
var
   I: Integer;
   C: TChamp;
begin
     slChamps.Clear;
     for I:= 0 to CS.Count - 1
     do
       begin
       C:= CS.Champ_from_Index( I);
       if Assigned( C)
       then
           slChamps.Values[C.Definition.Nom]:= C.Chaine;
       end;
end;

procedure TBatproMaskElement._from_Champs( CS: TChamps; _bl: TObject; _id: Integer);
var
   cLibelle, cCode: TChamp;
begin
     bl:= _bl;
     id:= _id;

     if CS = nil then exit;
     slChamps_from_Champs( CS);

     if EChanging then exit;

     try
        EChanging:= True;    //passé avec EChanging:= True pour libellé dans
                             //BatproPlanning - fdA_CHT__A_PLA

        cLibelle:= CS.Champ_from_Field( bme3Libelle);
        if Assigned( cLibelle)
        then
            TextLibelle:= cLibelle.Chaine;
        LibelleOK:= True;

        cCode:= CS.Champ_from_Field( bme2Code);
        if Assigned( cCode)
        then
            Text:= cCode.Chaine;
     finally
            EChanging:= False;
            end;
end;

procedure TBatproMaskElement.SetLectureSeule(Value: Boolean);
begin
     if FLectureSeule = Value then exit;
     FLectureSeule:= Value;

      _E.ReadOnly:= FLectureSeule;
     DBE.ReadOnly:= FLectureSeule;
end;

function TBatproMaskElement.GetLectureSeule: Boolean;
begin
     Result:= csLoading in ComponentState;
     if Result then exit;
     Result:= FLectureSeule;
end;

function TBatproMaskElement.GetChamp_id: TChamp;
begin
     if Assigned( GetChamp_id_function)
     then
         Result:= GetChamp_id_function
     else
         Result:= nil;
end;

function TBatproMaskElement.Traite_Inf_Sup( S: String): String;
var
   LS: Integer;
   Operateur, Valeur: String;
begin
     Result:= sys_Vide;
     LS:= Length( S);
     if LS < 2 then exit;

     if S[2] = '='
     then
         begin
         Operateur:= Copy( S, 1, 2 );
         Valeur   := Copy( S, 3, LS);
         end
     else
         begin
         Operateur:= Copy( S, 1, 1 );
         Valeur   := Copy( S, 2, LS);
         end;
     Valeur:= Do_SQLConstraint_DecoreValeur( Valeur);
     Result:= SQL_OP( bme6DataField, Operateur, Valeur);
end;

function TBatproMaskElement.Traite_BETWEEN( S: String; Pos_2points: Integer): String;
var
   Valeur1, Valeur2: String;
begin
     Valeur1:= Copy( S, 1, Pos_2points-1);
     Valeur2:= Copy( S, Pos_2points+1, Length(S));
     Valeur1:= Do_SQLConstraint_DecoreValeur(Valeur1);
     Valeur2:= Do_SQLConstraint_DecoreValeur(Valeur2);
     Result:= SQL_BETWEEN( bme6DataField, Valeur1, Valeur2);
end;

function TBatproMaskElement.SQLConstraint: String;
var
   S: String;
   Pos_2points: Integer;
   Valeur: String;
begin
     Result:= sys_Vide;
     if IsLabel then exit;

     S:= Text;
     if S = sys_Vide then exit;

     case S[1]
     of
       '<','>': Result:= Traite_Inf_Sup( S);
       else
         begin
         Pos_2points:= Pos(':', S);
              if Pos_2points > 0
         then
             Result:= Traite_BETWEEN( S, Pos_2points)
         else
             begin
             Valeur:= Do_SQLConstraint_DecoreValeur( S);
             if (Pos('*', Valeur) > 0) and (SGBD in [sgbd_Informix, sgbd_MySQL])
             then
                 begin
                 case SGBD
                 of
                   sgbd_Informix: Result:= SQL_MATCHES( bme6DataField, Valeur);
                   sgbd_MySQL   : Result:= SQL_REGEXP ( bme6DataField, Valeur);
                   end;
                 end
             else if (Pos('%', Valeur) > 0) and sgbdPOSTGRES
             then
                 Result:= SQL_SIMILAR_TO( bme6DataField, Valeur)
             else
                 Result:= SQL_EGAL( bme6DataField, Valeur);
             end;
         end;
       end;
end;

function TBatproMaskElement.getColorEdit: TColor;
begin
     if DBE.Visible
     then
         Result:= DBE.Color
     else
         Result:= _E .Color;
end;

procedure TBatproMaskElement.setColorEdit(const Value: TColor);
begin
     if DBE.Visible
     then
         DBE.Color:= Value
     else
         _E .Color:= Value;
end;

procedure TBatproMaskElement.SetIsLabel(Value: Boolean);
begin
     FIsLabel:= Value;
     L  .Visible:= True ;
     DBE.Visible:= False;
     _E .Visible:= False;
     B  .Visible:= False;
     B  .Left:= 0;
end;

function TBatproMaskElement.Do_SQLConstraint_DecoreValeur( _Valeur: String): String;
begin
     if Assigned( SQLConstraint_DecoreValeur)
     then
         Result:= SQLConstraint_DecoreValeur( _Valeur)
     else
         Result:= _Valeur;
end;

end.

