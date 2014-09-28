unit ucBatproMasque;
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
    u_sys_,
    uUseCases,
    uEXE_INI,
    uDataUtilsU,
    uChamp,
    uChamps,
    ucBatproMaskElement,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  lmessages,
  {$ENDIF}
    Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, StdCtrls;

type
 TBatproMasqueStyle = (bms_Libelle, bms_Change, bms_PreExecute_after_SetChamps);
 TBatproMasqueStyles= set of TBatproMasqueStyle;
 TBatproMasque
 =
  class( TPanel, IChampsComponent)
  private
    { Déclarations privées }
    FOnChange: TNotifyEvent;
    FAfterExecute: TAfterExecute;
    FStyles  : TBatproMasqueStyles;
    FDefault:  TBatproMaskElementDefault;
    XMax   : Integer;
    Hauteur: Integer;
    FLectureSeule: Boolean;
    procedure bmeChange(Sender: TObject);
    procedure bmeKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bmeEnter( Sender: TObject);
    procedure bmeExit ( Sender: TObject);
    procedure bmeAfterExecute( Sender: TObject; ExecuteResult: Boolean);
    procedure SetStyles(Value: TBatproMasqueStyles);
    procedure SetDefault(Value: TBatproMaskElementDefault);
    function  GetLectureSeule: Boolean;
    procedure SetLectureSeule( Value: Boolean);
    procedure SetTraiterTabulation(const Value: Boolean);
  protected
    AutoLayout: Boolean;
    Premier, Dernier: TBatproMaskElement;
    Elements: array of TBatproMaskElement;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Resize; override;
    procedure Change; virtual;
    procedure DoAfterExecute( ExecuteResult: Boolean); virtual;
  public
    { Déclarations publiques }
    bm_lLIBELLE: TLabel;
    constructor Create(AOwner: TComponent); override;
    procedure PreExecute;
    procedure Set_Element_Pos(bme:TBatproMaskElement;aWidth,aMaxLength:Integer;
                              aCharCase: TEditCharCase = ecNormal);
    procedure Set_Element_Pos_2(bme:TBatproMaskElement;aMaxLength:Integer;
                                aCharCase: TEditCharCase = ecNormal);
    procedure Set_Control_Pos(  c:TControl          ;aWidth           :Integer);

    procedure Set_Element_Links( bme: TBatproMaskElement;
                                 abme0Previous, abme1Next:TBatproMaskElement);

    procedure Set_Element_SQL( bme: TBatproMaskElement;
                               abme2Code, abme3Libelle,abme4WhereFixe:String);
    procedure Cree_Element(var bme: TBatproMaskElement);

    procedure Cree_L(var l: TLabel);
    procedure Free_L(var l: TLabel);

    procedure Cree_RB(var rb: TRadioButton);
    procedure Free_RB(var rb: TRadioButton);

    procedure Cree_CB(var cb: TCheckBox);
    procedure Free_CB(var cb: TCheckBox);
    function OutputString( Separateur: String; UseLibelle: Boolean): String;
    procedure Reset;
    procedure SetFocus; override;
    property LectureSeule: Boolean read GetLectureSeule write SetLectureSeule;
    property TraiterTabulation: Boolean write SetTraiterTabulation;
  published
    property OnChange    : TNotifyEvent  read FOnChange     write FOnChange    ;
    property OnKeyDown;
    property OnEnter;
    property OnExit;
    property AfterExecute: TAfterExecute read FAfterExecute write FAfterExecute;
    property bm_0Styles :TBatproMasqueStyles       read FStyles  write SetStyles ;
    property bm_1Default:TBatproMaskElementDefault read FDefault write SetDefault;
  //Layout
  private
    Layout_running: Boolean;
    procedure Layout;
  //Navigation
  private
    FOnGoNext: TNotifyEvent;
    procedure GoNext( Sender: TObject);
    procedure GoPrevious( Sender: TObject);
    procedure Send_Tab_to_parent;
  published
    property OnGoNext    : TNotifyEvent  read FOnGoNext     write FOnGoNext    ;
  //Liaison avec TChamps
  protected
    FChamps: TChamps;
    Champs_OK_Champ_id_OK: Boolean;
    function GetChamps: TChamps; virtual;
    procedure SetChamps_interne( Value: TChamps); virtual;
    procedure SetChamps( Value: TChamps);
    function Champs_OK: Boolean; virtual;
  public
    property Champs: TChamps read GetChamps write SetChamps;
  //Gestion des mises à jours avec TChamps
  protected
    Champs_Changing: Boolean;
    procedure _from_Champs; virtual;
    procedure _to_Champs; virtual;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  //Gestion du bouton de création
  private
    FAutoriserCreation: Boolean;
    procedure SetAutoriserCreation( const Value: Boolean);
  protected
    bCreer: TButton;
    procedure Creation_bCreer; virtual;
  public
    function Assigned_bCreer: Boolean; //"prise diagnostic" pour le test
  published
    property bm_2AutoriserCreation: Boolean read FAutoriserCreation write SetAutoriserCreation;
  //Résultat de sélection sous forme de champ id
  private
    FID: String;
  protected
    cID: TChamp;
    function GetChamp_id: TChamp;
  published
    property bm1ID: String read FID write FID;
  //Contrainte SQL
  public
    function SQLConstraint: String; 
  //Couleur de fond de l'éditeur
  public
    procedure setColorEdit(const Value: TColor);
  end;

implementation

var
   Charger_pucMasques_BPL: Boolean = False;


constructor TBatproMasque.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     Premier:= nil;
     Dernier:= nil;
     SetLength( Elements, 0);
     bCreer:= nil;
     XMax:= 0;
     Hauteur:= 22;
     AutoLayout:= True;
     Layout_running:= False;
     FLectureSeule:= False;
     //if not (csDesigning in ComponentState)
     //then
         //if not UseCases.Is_loaded( ClassName)  quand on aura le temps
         //then
         //    UseCases[ClassName].Execute([]);
         //if Charger_pucMasques_BPL
         //then
         //    begin
         //    if not UseCases.Is_loaded( 'Masque')
         //    then
         //        UseCases['Masque'].Execute([]);
         //    Charger_pucMasques_BPL:= False;
         //    end;
end;

procedure TBatproMasque.Creation_bCreer;
begin
     if not EXE_INI.Delphi_autonome then exit;
     if Assigned( bCreer)           then exit;

     bCreer:= TButton.Create( Self);
     bCreer.Visible:= True;
     bCreer.Parent:= Self;
     bCreer.Caption:= 'Créer';
     bCreer.Width  := 35;
     bCreer.Height := 20;
end;

procedure TBatproMasque.Cree_Element(var bme: TBatproMaskElement);
begin
     bme:= TBatproMaskElement.Create( Self);
     bme.Parent     := Self;

     SetLength( Elements, Length(Elements)+1);
     Elements[High(Elements)]:= bme;

     if Premier = nil then Premier:= bme;
     Dernier:= bme;
end;

procedure TBatproMasque.Set_Control_Pos( c: TControl; aWidth: Integer);
begin
     if c = nil then exit;

     if C is TLabel
     then
         begin
         c.Left  := XMax;
         c.Top   := 3;
         end
     else
         begin
         if     (C is TBatproMaskElement)
            and TBatproMaskElement(C).IsLabel
         then
             Inc( XMax, 3);
         c.Left  := XMax   ;
         c.Top   := 0;
         c.Height:= Hauteur;
         end;
     c.Width := aWidth ;

     Inc( XMax, aWidth);
end;

procedure TBatproMasque.Set_Element_Pos( bme: TBatproMaskElement;
                                         aWidth, aMaxLength :Integer;
                                         aCharCase: TEditCharCase = ecNormal);
begin
     if bme = nil then exit;

     Set_Control_Pos( bme, aWidth);
     bme.Font.Height := -11            ;
     bme.Font.Name   := 'Courier New'  ;
     bme.MaxLength   := aMaxLength     ;
     bme.OnChange    := bmeChange      ;
     bme.OnKeydown   := bmeKeyDown     ;
     bme.OnEnter     := bmeEnter       ;
     bme.OnExit      := bmeExit        ;
     bme.AfterExecute:= bmeAfterExecute;
     bme.CharCase    := aCharCase      ;
end;

procedure TBatproMasque.Set_Element_Pos_2( bme: TBatproMaskElement;
                                           aMaxLength: Integer;
                                           aCharCase: TEditCharCase);
begin
     // largeur= nb_caracteres * 8 + 24
     Set_Element_Pos( bme, aMaxLength * 8 + 24, aMaxLength, aCharCase);
end;

procedure TBatproMasque.Set_Element_Links( bme: TBatproMaskElement;
     abme0Previous, abme1Next                               :TBatproMaskElement
                                    );
begin
     bme.bme0Previous:= abme0Previous ;
     bme.bme1Next    := abme1Next     ;
end;

procedure TBatproMasque.Set_Element_SQL( bme: TBatproMaskElement;
     abme2Code, abme3Libelle, abme4WhereFixe:String
                                    );
begin
     bme.bme2Code     := abme2Code     ;
     bme.bme3Libelle  := abme3Libelle  ;
     bme.bme4WhereFixe:= abme4WhereFixe;
end;

procedure TBatproMasque.PreExecute;
//var
//   I: Integer;
//   C: TComponent;
//   bme: TBatproMaskElement;
begin
     //for I:= 0 to ComponentCount-1
     //do
     //  begin
     //  C:= Components[ I];
     //  if C is TBatproMaskElement
     //  then
     //      begin
     //      bme:= TBatproMaskElement(C);
     //      bme.PreExecute;
     //      end;
     //  end;

     if LectureSeule then exit;

     if Assigned( Premier)
     then
         Premier.PreExecute;
end;

procedure TBatproMasque.Layout;
var
   bme: TBatproMaskElement;
begin
     if not AutoLayout then exit;
     if Premier = nil then exit;

     if Layout_running then exit;

     try
        Layout_running:= True;

        XMax:= 0;

        Premier.Left:= 0;
        bme:= Premier;
        while Assigned( bme)
        do
          begin
          if bme <> Premier
          then
              bme.TraitePrevious;
          bme.Default:= bm_1Default;

          bme.TraiteHauteur;
          bme.bme7LabelLibelle:= bm_lLIBELLE;
          bme:= bme.bme1Next;
          end;

        XMax:= Dernier.Left+Dernier.Width;
        if Assigned( bCreer)
        then
            Set_Control_Pos( bCreer,  bCreer.Width);

        Inc( XMax, 8);//8 pour marge texte
        Set_Control_Pos( bm_lLIBELLE,  ClientWidth - XMax);
        //ClientHeight:= Dernier.Height;
     finally
            Layout_running:= False;
            end;
end;

procedure TBatproMasque.CreateWnd;
begin
     inherited;
     Layout;
end;

procedure TBatproMasque.Loaded;
var
   bme: TBatproMaskElement;
begin
     inherited;
     Premier.OnGoPrevious:= GoPrevious;
     Dernier.OnGoNext    := GoNext;
     if bms_Change in FStyles
     then
         begin
         bme:= Premier;
         while Assigned( bme)
         do
           begin
           bme.ChangeAtExit:= False;
           bme:= bme.bme1Next;
           end;
         end;
     if FAutoriserCreation
     then
         Creation_bCreer;
end;

procedure TBatproMasque.SetStyles(Value: TBatproMasqueStyles);
begin
     if FStyles = Value then exit;

     FStyles:= Value;

     if bms_Libelle in FStyles then Cree_L( bm_lLIBELLE)
                               else Free_L( bm_lLIBELLE);

     Layout;
end;

procedure TBatproMasque.SetDefault(Value: TBatproMaskElementDefault);
begin
     if FDefault = Value then exit;
     FDefault:= Value;
     Layout;
end;

procedure TBatproMasque.bmeChange(Sender: TObject);
begin
     Change;
end;

procedure TBatproMasque.bmeAfterExecute( Sender: TObject;ExecuteResult:Boolean);
begin
     DoAfterExecute( ExecuteResult);
end;

procedure TBatproMasque.Change;
begin
     if Assigned( OnChange)
     then
         OnChange( Self);
     if Assigned( FChamps)
     then
         _to_Champs;
end;

procedure TBatproMasque.DoAfterExecute( ExecuteResult: Boolean);
begin
     if Assigned( FAfterExecute)
     then
         FAfterExecute( Self, ExecuteResult);
     if Assigned( FChamps)
     then
         _to_Champs;
end;

procedure TBatproMasque.Cree_L(var l: TLabel);
begin
     l:= TLabel.Create( Self);
     l.Parent:= Self;
     l.Transparent:= True;
end;

procedure TBatproMasque.Free_L(var l: TLabel);
begin
     FreeAndNil( l);
end;

procedure TBatproMasque.Cree_RB(var rb: TRadioButton);
begin
     rb:= TRadioButton.Create( Self);
     rb.Parent:= Self;
end;

procedure TBatproMasque.Free_RB(var rb: TRadioButton);
begin
     Free_nil( rb);
end;

procedure TBatproMasque.Cree_CB(var cb: TCheckBox);
begin
     if Assigned( cb) then exit;

     cb:= TCheckBox.Create( Self);
     cb.Parent:= Self;
end;

procedure TBatproMasque.Free_CB(var cb: TCheckBox);
begin
     Free_nil( cb);
end;

function TBatproMasque.OutputString( Separateur: String;
                                     UseLibelle: Boolean): String;
var
   bme: TBatproMaskElement;
   S: String;
begin
     Result:= sys_Vide;
     bme:= Premier;
     while Assigned( bme)
     do
       begin
       if UseLibelle
       then
           S:= bme.TextLibelle // on utilise le libellé
       else
           S:= bme.Text;       // on utilise le code

       if     (Result <> sys_Vide)
          and (S      <> sys_Vide)
       then
           Result:= Result + Separateur;

       Result:= Result + S;
       bme:= bme.bme1Next;
       end;
end;

procedure TBatproMasque.Reset;
begin
     Premier.Reset;
     Layout;
end;

procedure TBatproMasque.Resize;
begin
     inherited;
     Layout;
end;

procedure TBatproMasque.SetFocus;
begin
     inherited;
     if Assigned( Premier)
     then
         Premier.SetFocus;
end;

procedure TBatproMasque.SetLectureSeule(Value: Boolean);
var
   bme: TBatproMaskElement;
begin
     if FLectureSeule = Value then exit;
     FLectureSeule:= Value;

     bme:= Premier;
     while Assigned( bme)
     do
       begin
       bme.LectureSeule:= FLectureSeule;
       bme:= bme.bme1Next;
       end;

     Enabled:= not FLectureSeule;
     if not FLectureSeule
     then
         PreExecute;
end;

function TBatproMasque.GetLectureSeule: Boolean;
begin
     Result:= csLoading in ComponentState;
     if Result then exit;
     Result:= FLectureSeule;
end;

procedure TBatproMasque.SetTraiterTabulation( const Value: Boolean);
var
   bme: TBatproMaskElement;
begin
     bme:= Premier;
     while Assigned( bme)
     do
       begin
       bme.TraiterTabulation:= Value;
       bme:= bme.bme1Next;
       end;
end;

function TBatproMasque.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

procedure TBatproMasque.SetChamps_interne(Value: TChamps);
begin
     FChamps:= Value;
end;

procedure TBatproMasque.SetChamps(Value: TChamps);
begin
     SetChamps_interne( Value);
     if     (bms_PreExecute_after_SetChamps in bm_0Styles)
        and Assigned( Value)
     then
         PreExecute;
end;

procedure TBatproMasque._from_Champs;
begin

end;

procedure TBatproMasque._to_Champs;
begin

end;

procedure TBatproMasque.GoNext( Sender: TObject);
begin
     if Assigned( OnGoNext)
     then
         OnGoNext( Self)
     else
         Send_Tab_to_parent;
end;

procedure TBatproMasque.GoPrevious(Sender: TObject);
begin
     // si la majuscule est enfoncée,
     //le parent le verra par appel de la fonction de l'api windows
     //pas besoin de lui spécifier ici
     Send_Tab_to_parent;
end;

procedure TBatproMasque.Send_Tab_to_parent;
var
   F: TCustomForm;
begin
     F:= GetParentForm( Self);
     if F.Visible
     then
         F.Perform( CM_DIALOGKEY, VK_TAB, 0);
end;

function TBatproMasque.GetComponent: TComponent;
begin
     Result:= Self;
end;

procedure TBatproMasque.SetAutoriserCreation(const Value: Boolean);
begin
     FAutoriserCreation:= Value;
     if     FAutoriserCreation
        and (bCreer = nil)
     then
         Creation_bCreer;
     Layout;
end;

function TBatproMasque.Assigned_bCreer: Boolean;
begin
     Result:= Assigned( bCreer);
end;

procedure TBatproMasque.bmeKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     KeyDown( Key, Shift);
end;

procedure TBatproMasque.bmeEnter(Sender: TObject);
begin
     DoEnter;
end;

procedure TBatproMasque.bmeExit(Sender: TObject);
begin
     DoExit;
end;

function TBatproMasque.Champs_OK: Boolean;
begin
     Result:= Assigned( FChamps);
     Champs_OK_Champ_id_OK:= Result;

     if Result
     then
         begin
         cID:= FChamps.Champ_from_Field( FID);
         Champs_OK_Champ_id_OK:= Assigned( cID);
         end;
end;

function TBatproMasque.GetChamp_id: TChamp;
begin
     Result:= cID;
end;

function TBatproMasque.SQLConstraint: String;
var
   bme: TBatproMaskElement;
begin
     Result:= '';
     bme:= Premier;
     while Assigned( bme)
     do
       begin
       SQL_AND( Result, bme.SQLConstraint);
       bme:= bme.bme1Next;
       end;
end;

procedure TBatproMasque.setColorEdit(const Value: TColor);
var
   bme: TBatproMaskElement;
begin
     bme:= Premier;
     while Assigned( bme)
     do
       begin
       bme.ColorEdit:= Value;

       bme:= bme.bme1Next;
       end;
end;

end.
