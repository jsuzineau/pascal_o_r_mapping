unit uDockable;
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
    uBatpro_StringList,
    uClean,
    uPublieur,
    uChamps,
    ucBatproMasque,
    ucChamp_Edit,
    ucChamp_Label,
    ucChamp_Lookup_ComboBox,
    ucChamp_CheckBox,
    //ucChamp_DateTimePicker,
    ucChamp_Integer_SpinEdit,
    //ucChamp_Float_SpinEdit,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.ExtCtrls, System.UITypes,FMX.Types,
  ucBatpro_Shape;

type
 TDockableScrollbox_Total
 =
  (
  dsbt_Aucun,
  dsbt_Decimal,
  dsbt_Heure
  );
 TDockable_Colonne
 =
  record
    Control : TControl;
    Titre   : String;
    NomChamp: String;
    Total   : TDockableScrollbox_Total;
  end;
 TDockable_Surtitre
 =
  record
    libelle: String ;
    debut  : Integer;
    fin    : Integer;
  end;
 TDockable
 =
  class( TForm)
    sSelection: TBatpro_Shape;
    procedure FormClick(Sender: TObject);
    procedure sSelectionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormDblClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Imprime: Boolean; virtual;
    function EnregistrerSous: Boolean; virtual;
  //Gestion du cycle de vie
  public
    constructor Create( _Owner: TComponent); override;
    destructor Destroy; override;
  // Gestion de l'accrochage/décrochage pour les dockables de saisie des
  // attributs d'un objet
  protected
    FObjet: TObject;
    procedure SetObjet( const Value: TObject); virtual;
  public
    property Objet: TObject read FObjet write SetObjet;
  //Etat de validité du dockable
  //(créé pour fiche travail: si valide on peut fermer)
  protected
    FValide: Boolean;
    procedure SetValide(const Value: Boolean);
  public
    pValide_Change: TPublieur;
    property Valide: Boolean read FValide write SetValide;
  //Pour prévenir avant la suppression dans un DockableScrollBox
  protected
    procedure Do_DockableScrollbox_Avant_Suppression;
  public
    DockableScrollbox_Avant_Suppression: TNotifyEvent;
  //Gestion de la suppression dans un DockableScrollBox
  protected
    procedure Do_DockableScrollbox_Suppression;
  public
    DockableScrollbox_Suppression: TNotifyEvent;
  //Gestion de la sélection dans un DockableScrollBox
  public
    DockableScrollbox_Selection : TNotifyEvent;
    DockableScrollbox_Validation: TNotifyEvent;
    procedure Do_DockableScrollbox_Selection;
    procedure Do_DockableScrollbox_Validation;
    procedure Affiche_Selection( Valeur: Boolean); virtual;
  //Gestion du déplacement vers le précédent dans un DockableScrollBox
  public
    DockableScrollbox_Precedent: TNotifyEvent;
    procedure Do_DockableScrollbox_Precedent;
  //Gestion du déplacement vers le suivant dans un DockableScrollBox
  public
    DockableScrollbox_Suivant: TNotifyEvent;
    procedure Do_DockableScrollbox_Suivant;
  //Gestion du clavier
  public
    function Traite_KeyDown( var Key: Word; Shift: TShiftState): Boolean;
  //Gestion de la création d'une nouvelle ligne
  public
    DockableScrollbox_Nouveau: TNotifyEvent;
    procedure Do_DockableScrollbox_Nouveau;
  //Gestion de la lecture seule
  public
    procedure Traite_LectureSeule( Valeur: Boolean); virtual;
  //Gestion des colonnes
  public
    Colonnes : array of TDockable_Colonne;
    Surtitres: array of TDockable_Surtitre;
    procedure Ajoute_Colonne( _C: TControl; _Titre: String = ''; _NomChamp: String = ''; _Total: TDockableScrollbox_Total = dsbt_Aucun);
    procedure Ajoute_Surtitre( _libelle: String; _debut, _fin: Integer);
  //Messages divers envoyés au niveau du DockableScrollBox
  public
    procedure Traite_Message( Sender: TObject; _iMessage: Integer); virtual; abstract;
  //Selection
  public
    Selected: Boolean;
  end;

 TDockableClass= class of TDockable;

procedure Create_Dockable( var _Reference; _Classe: TDockableClass;
                           _Parent: TFmxObject);
procedure Destroy_Dockable( _Dockable: TDockable);

function Dockable_from_sl( _sl: TBatpro_StringList; _I: Integer): TDockable;

implementation

{$R *.dfm}

procedure Create_Dockable( var _Reference; _Classe: TDockableClass;
                           _Parent: TFmxObject);
begin
     TDockable( _Reference):= _Classe.Create( nil);
     TDockable( _Reference).Parent:= _Parent;
     TDockable( _Reference).Show;
     TDockable( _Reference).Left:= 0;
     TDockable( _Reference).Top := 0;
     //TDockable( _Reference).Align:= alClient;
     //TDockable( _Reference).BorderStyle:= bsNone;
end;

procedure Destroy_Dockable( _Dockable: TDockable);
begin
     _Dockable.Objet:= nil;
     _Dockable.Hide;
     _Dockable.Parent:= nil;
     FreeAndNil( _Dockable);
end;

function Dockable_from_sl( _sl: TBatpro_StringList; _I: Integer): TDockable;
begin
     _Classe_from_sl( Result, TDockable, _sl, _I);
end;

{ TDockable }

constructor TDockable.Create( _Owner: TComponent);
begin
     inherited;
     pValide_Change:= TPublieur.Create( Name+'.pValide_Change');
     FObjet:= nil;
     FValide := True;
     //OnHelp:= Application.OnHelp;
     //HelpContext:= 1;
     //HelpFile:= Name;
     sSelection.Batpro_Shape:= bstCursor;
     SetLength( Colonnes , 0);
     SetLength( Surtitres, 0);
     DockableScrollbox_Selection:= nil;
     DockableScrollbox_Validation:= nil;
end;

destructor TDockable.Destroy;
begin
     Objet:= nil;
     FreeAndNil( pValide_Change);
     inherited;
end;

function TDockable.EnregistrerSous: Boolean;
begin
     Result:= True;
end;

function TDockable.Imprime: Boolean;
begin
     Result:= True;
end;

procedure TDockable.SetObjet( const Value: TObject);
begin
     FObjet:= Value;
end;

procedure TDockable.SetValide(const Value: Boolean);
begin
     if FValide = Value then exit;

     FValide := Value;
     pValide_Change.Publie;
end;

procedure TDockable.Do_DockableScrollbox_Avant_Suppression;
begin
     if Assigned( DockableScrollbox_Avant_Suppression)
     then
         DockableScrollbox_Avant_Suppression( Self);
end;

procedure TDockable.Do_DockableScrollbox_Suppression;
begin
     if Assigned( DockableScrollbox_Suppression)
     then
         DockableScrollbox_Suppression( Self);
end;

procedure TDockable.Do_DockableScrollbox_Selection;
begin
     if Assigned( DockableScrollbox_Selection)
     then
         DockableScrollbox_Selection( Self);
end;

procedure TDockable.Do_DockableScrollbox_Validation;
begin
     if Assigned( DockableScrollbox_Validation)
     then
         DockableScrollbox_Validation( Self);
end;

procedure TDockable.Affiche_Selection( Valeur: Boolean);
begin
     Selected:= Valeur;

     if Valeur
     then
         begin
         with sSelection.Fill
         do
           begin
           Kind:= TBrushKind.Solid;
           Color:= TColorRec.Black;
           end;
         with sSelection.Stroke
         do
           begin
           Dash:= TStrokeDash.Solid;
           Color:= TColorRec.Black;
           end;
         //SetFocused( Self);
         end
     else
         begin
         with sSelection.Fill
         do
           begin
           Kind:= TBrushKind.None;
           end;
         with sSelection.Stroke
         do
           begin
           Dash:= TStrokeDash.Custom;
           end;
         end;
end;

procedure TDockable.FormClick(Sender: TObject);
begin
     Do_DockableScrollbox_Selection;
end;

procedure TDockable.FormDblClick(Sender: TObject);
begin
     Do_DockableScrollbox_Validation;
end;

procedure TDockable.sSelectionMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     Do_DockableScrollbox_Selection;
end;

procedure TDockable.Do_DockableScrollbox_Precedent;
begin
     if Assigned( DockableScrollbox_Precedent)
     then
         DockableScrollbox_Precedent( Self);
end;

procedure TDockable.Do_DockableScrollbox_Suivant;
begin
     if Assigned( DockableScrollbox_Suivant)
     then
         DockableScrollbox_Suivant( Self);
end;

procedure TDockable.Do_DockableScrollbox_Nouveau;
begin
     if Assigned( DockableScrollbox_Nouveau)
     then
         DockableScrollbox_Nouveau( Self);
end;

function TDockable.Traite_KeyDown( var Key: Word; Shift: TShiftState): Boolean;
begin
     Result:= True;
     case Key
     of
       VK_UP    : Do_DockableScrollbox_Precedent;
       VK_DOWN  : Do_DockableScrollbox_Suivant  ;
       VK_RETURN:
         if ssShift	in Shift
         then
             Do_DockableScrollbox_Precedent
         else
             Do_DockableScrollbox_Suivant;
       VK_INSERT: Do_DockableScrollbox_Nouveau  ;
       else     Result:= False;
       end;
end;

procedure TDockable.Traite_LectureSeule( Valeur: Boolean);
var
   I:Integer;
   C: TComponent;

   Valeur_Enabled, Valeur_ReadOnly: Boolean;
begin
     Valeur_Enabled := not Valeur;
     Valeur_ReadOnly:= Valeur;

     for I:= 0 to ComponentCount - 1
     do
       begin
       C:= Components[I];
       if Assigned( C)
       then
           begin
                if C is TBatproMasque then TBatproMasque( C).Enabled := Valeur_Enabled
           else if C is TChamp_Edit   then TChamp_Edit  ( C).ReadOnly:= Valeur_ReadOnly
           else if C is TChamp_Label  then TChamp_Label ( C).Enabled := Valeur_Enabled
           else if C is TChamp_Lookup_ComboBox
                                      then TChamp_Lookup_ComboBox( C)
                                                            .Enabled := Valeur_Enabled
           else if C is TChamp_CheckBox
                                      then TChamp_CheckBox( C)
                                                            .Enabled := Valeur_Enabled
           else if C is TChamp_Integer_SpinEdit
                                      then TChamp_Integer_SpinEdit( C)
                                                            .ReadOnly:= Valeur_ReadOnly;
           end;
       end;
end;

procedure TDockable.Ajoute_Colonne( _C       : TControl;
                                    _Titre   : String = '';
                                    _NomChamp: String = '';
                                    _Total: TDockableScrollbox_Total = dsbt_Aucun);
var
   I, NewLength: Integer;
begin
     I:= Length( Colonnes);
     NewLength:= I+1;

     SetLength( Colonnes  , NewLength);

     with Colonnes[I]
     do
       begin
       Control := _C       ;
       Titre   := _Titre   ;
       NomChamp:= _NomChamp;
       Total   := _Total   ;
       end;
end;

procedure TDockable.Ajoute_Surtitre( _libelle: String; _debut, _fin: Integer);
var
   I, NewLength: Integer;
begin
     I:= Length( Surtitres);
     NewLength:= I+1;

     SetLength( Surtitres, NewLength);

     with Surtitres[I]
     do
       begin
       debut:= _debut;
       fin  := _fin  ;
       end;
end;

procedure TDockable.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     if not Traite_KeyDown( Key, Shift)
     then
         inherited;
end;

procedure TDockable.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
     Do_DockableScrollbox_Suivant  ;
end;

procedure TDockable.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
     Do_DockableScrollbox_Precedent;
end;

end.

