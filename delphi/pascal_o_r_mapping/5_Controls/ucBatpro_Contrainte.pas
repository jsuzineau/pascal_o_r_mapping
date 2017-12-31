unit ucBatpro_Contrainte;
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
    uClean,
    uReels,
    uContrainte,
  SysUtils, Classes, Controls, ComCtrls, DB, StdCtrls, ExtCtrls, Graphics;

type
 TBatpro_Contrainte
 =
  class( TPanel)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Méthodes surchargées
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Resize; override;
  public

  //Attributs
  private
    FContrainte: TContrainte;
    function GetContrainte: TContrainte;
  public
    property Contrainte: TContrainte read GetContrainte;
  //Méthodes
  private
    procedure To_Chaine  ;
    procedure To_Entier  ;
    procedure To_Flottant;
    procedure To_Date    ;
    procedure From_Chaine  ;
    procedure From_Entier  ;
    procedure From_Flottant;
    procedure From_Date    ;
    procedure Change;
    procedure Change_Active;
  //Checkbox
  private
    procedure cbClick(Sender: TObject);
  public
    cb: TCheckBox;
  //Libelle
  public
    lLibelle: TLabel;
  //Operateur
  private
    procedure cbOperateurChange( Sender: TObject);
  public
    cbOperateur: TComboBox;
  //Edit
  private
    procedure eChange( Sender: TObject);
  public
    e: TEdit;
  //DateTimePicker
  private
    dtpChange_actif: Boolean;
    procedure dtpChange( Sender: TObject);
    procedure dtpDropDown(Sender: TObject);
    procedure dtpCloseUp(Sender: TObject);
  public
    dtp: TDateTimePicker;
  //Gestion de l'affichage
  private
    first_Layout_ok: Boolean;
    procedure Layout;
  // Propriété Libelle
  private
    function  GetLibelle: String;
    procedure SetLibelle(const Value: String);
  published
    property Libelle: String read GetLibelle write SetLibelle;
  // Propriété Active
  private
    function  GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  published
    property Active: Boolean read GetActive write SetActive;
  // Propriété NomChamp
  private
    function  GetNomChamp: String;
    procedure SetNomChamp(const Value: String);
  published
    property NomChamp: String read GetNomChamp write SetNomChamp;
  // Propriété Operateur
  private
    function  GetOperateur: TContrainte_Operateur;
    procedure SetOperateur(const Value: TContrainte_Operateur);
  published
    property Operateur: TContrainte_Operateur read GetOperateur write SetOperateur;
  //Propriété TypeOperande
  private
    function  GetTypeOperande: TContrainte_TypeOperande;
    procedure SetTypeOperande(const Value: TContrainte_TypeOperande);
  published
    property TypeOperande: TContrainte_TypeOperande read GetTypeOperande write SetTypeOperande;
  // Propriété Critere_Chaine
  private
    function  GetCritere_Chaine: String;
    procedure SetCritere_Chaine(const Value: String);
  public
    property Critere_Chaine: String read GetCritere_Chaine write SetCritere_Chaine;
  // Propriété Critere_Entier
  private
    function  GetCritere_Entier: Integer;
    procedure SetCritere_Entier(const Value: Integer);
  public
     property Critere_Entier: Integer read GetCritere_Entier write SetCritere_Entier;
  // Propriété Critere_Flottant
  private
    function  GetCritere_Flottant: double;
    procedure SetCritere_Flottant(const Value: double);
  public
    property Critere_Flottant: double read GetCritere_Flottant write SetCritere_Flottant;
  // Propriété Critere_Date
  private
    function  GetCritere_Date: TDateTime;
    procedure SetCritere_Date(const Value: TDateTime);
  public
    property Critere_Date: TDateTime read GetCritere_Date write SetCritere_Date;
  //OnChange
  private
    FOnChange: TNotifyEvent;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_Contrainte]);
end;

{ TBatpro_Contrainte }
const
     TBatpro_Contrainte_Largeur_operateur= 123;
constructor TBatpro_Contrainte.Create(AOwner: TComponent);
begin
     inherited;

     Width:= TBatpro_Contrainte_Largeur_operateur+186;
     FContrainte:= TContrainte.Create;

     cb:= TCheckBox.Create( Self);
     cb.Parent:= Self;
     cb.OnClick:= cbClick;

     lLibelle:= TLabel.Create( Self);
     lLibelle.Name:= 'lLibelle';
     lLibelle.Parent:= Self;
     lLibelle.Caption:= '';

     cbOperateur:= TComboBox.Create( Self);
     cbOperateur.Name:= 'cbOperateur';
     cbOperateur.Parent:= Self;
     cbOperateur.OnChange:= cbOperateurChange;

     e:= TEdit.Create( Self);
     e.Name:= 'e';
     e.Parent:= Self;
     e.Text:= '';
     e.OnChange:= eChange;

     dtpChange_actif:= True;
     dtp:= TDateTimePicker.Create( Self);
     dtp.Name:= 'dtp';
     dtp.Parent:= Self;
     dtp.DateTime:= Now;
     dtp.OnChange  := dtpChange;
     dtp.OnDropDown:= dtpDropDown;
     dtp.OnCloseUp := dtpCloseUp;

     first_Layout_ok:= False;
end;

destructor TBatpro_Contrainte.Destroy;
begin
     Free_nil( FContrainte);
     inherited;
end;

procedure TBatpro_Contrainte.Layout;
const
     Marge_horizontale= 1;
     Marge_verticale  = 1;
var
   IsDate: Boolean;
   procedure Enchaine( _Avant, _Apres: TControl; _Top: Integer= Marge_verticale; _Left: Integer= 0);
   begin
        if _Avant = nil
        then
            _Apres.Left:= _Left
        else
            _Apres.Left:= _Avant.Left+_Avant.Width;
        _Apres.Top := _Top;
   end;

begin
     IsDate:= FContrainte.IsDate;

     cb.Width:= 15;
     cb.Checked:= FContrainte.Active;

     lLibelle.AutoSize:= True;

     cbOperateur.Width:= TBatpro_Contrainte_Largeur_operateur;
     cbOperateur.Clear;
     cbOperateur.Items.Add( 'est égal à');
     cbOperateur.Items.Add( 'est différent de');
     cbOperateur.Items.Add( 'commence par');
     case FContrainte.TypeOperande
     of
       cto_Entier,cto_Flottant: cbOperateur.Items.Add( 'est inférieur ou égal à');
       else                     cbOperateur.Items.Add( 'est avant'      );
       end;
     case FContrainte.TypeOperande
     of
       cto_Entier,cto_Flottant: cbOperateur.Items.Add( 'est supérieur ou égal à');
       else                     cbOperateur.Items.Add( 'est aprés');
       end;

     cbOperateur.Style:= csDropDownList;
     cbOperateur.ItemIndex:= Integer( FContrainte.Operateur);

     e  .Visible:= not IsDate;

     dtp.Visible:= IsDate;

     Enchaine( nil        , cb         , Marge_verticale+3, Marge_horizontale+2);
     Enchaine( cb         , lLibelle   , Marge_verticale+4);
     Enchaine( lLibelle   , cbOperateur);
     Enchaine( cbOperateur, e          );
     Enchaine( cbOperateur, dtp        );

     e.Width:= ClientWidth - e.Left-Marge_horizontale;
     with e do Anchors:= Anchors + [akRight];

     dtp.Width:= ClientWidth - dtp.Left-Marge_horizontale;
     with dtp do Anchors:= Anchors + [akRight];

     ClientHeight:= cbOperateur.Top+cbOperateur.Height+Marge_verticale;

     first_Layout_ok:= True;
end;

procedure TBatpro_Contrainte.CreateWnd;
begin
     inherited;
     Layout;
end;

procedure TBatpro_Contrainte.Loaded;
begin
     inherited;
end;


procedure TBatpro_Contrainte.Resize;
begin
     inherited;
     Layout;
end;

procedure TBatpro_Contrainte.From_Chaine;
begin
     e.Text:= FContrainte.Critere_Chaine;
end;

procedure TBatpro_Contrainte.To_Chaine;
begin
     FContrainte.Critere_Chaine:= e.Text;
end;

procedure TBatpro_Contrainte.From_Entier;
begin
     e.Text:= IntToStr( FContrainte.Critere_Entier);
end;

procedure TBatpro_Contrainte.To_Entier;
begin
     if not TryStrToInt( e.Text, FContrainte.Critere_Entier)
     then
         FContrainte.Critere_Entier:= 0;
end;

procedure TBatpro_Contrainte.From_Flottant;
begin
     e.Text:= FloatToStr( FContrainte.Critere_Flottant);
end;

procedure TBatpro_Contrainte.To_Flottant;
begin
     if not TryStrToFloat( e.Text, FContrainte.Critere_Flottant)
     then
         FContrainte.Critere_Flottant:= 0;
end;

procedure TBatpro_Contrainte.From_Date;
begin
     dtp.DateTime:= FContrainte.Critere_Date;
end;

procedure TBatpro_Contrainte.To_Date;
begin
     FContrainte.Critere_Date:= dtp.DateTime;
end;

function TBatpro_Contrainte.GetContrainte: TContrainte;
begin
     FContrainte.Active   := cb.Checked;
     FContrainte.Operateur:= TContrainte_Operateur( cbOperateur.ItemIndex);
     case FContrainte.TypeOperande
     of
       cto_Chaine  : To_Chaine;
       cto_Entier  : To_Entier;
       cto_Flottant: To_Flottant;
       cto_Date    : To_Date;
       else          To_Chaine;
       end;
     Result:= FContrainte;
end;

function TBatpro_Contrainte.GetLibelle: String;
begin
     Result:= lLibelle.Caption;
end;

procedure TBatpro_Contrainte.SetLibelle(const Value: String);
begin
     lLibelle.Caption:= Value;
     if first_Layout_ok
     then
         Layout;
end;

function TBatpro_Contrainte.GetActive: Boolean;
begin
     Result:= FContrainte.Active;
end;

procedure TBatpro_Contrainte.SetActive(const Value: Boolean);
begin
     FContrainte.Active:= Value;
end;

function TBatpro_Contrainte.GetNomChamp: String;
begin
     Result:= FContrainte.NomChamp;
end;

procedure TBatpro_Contrainte.SetNomChamp(const Value: String);
begin
     FContrainte.NomChamp:= Value;
end;

function TBatpro_Contrainte.GetOperateur: TContrainte_Operateur;
begin
     Result:= FContrainte.Operateur;
end;

procedure TBatpro_Contrainte.SetOperateur( const Value: TContrainte_Operateur);
begin
     FContrainte.Operateur:= Value;
     Layout;
end;

function TBatpro_Contrainte.GetTypeOperande: TContrainte_TypeOperande;
begin
     Result:= FContrainte.TypeOperande;
end;

procedure TBatpro_Contrainte.SetTypeOperande( const Value: TContrainte_TypeOperande);
begin
     FContrainte.TypeOperande:= Value;
     Layout;
end;

function TBatpro_Contrainte.GetCritere_Chaine: String;
begin
     To_Chaine;
     Result:= FContrainte.Critere_Chaine;
end;

procedure TBatpro_Contrainte.SetCritere_Chaine(const Value: String);
begin
     FContrainte.Critere_Chaine:= Value;
     From_Chaine;
end;

function TBatpro_Contrainte.GetCritere_Entier: Integer;
begin
     To_Entier;
     Result:= FContrainte.Critere_Entier;
end;

procedure TBatpro_Contrainte.SetCritere_Entier(const Value: Integer);
begin
     FContrainte.Critere_Entier:= Value;
     From_Entier;
end;

function TBatpro_Contrainte.GetCritere_Flottant: double;
begin
     To_Flottant;
     Result:= FContrainte.Critere_Flottant;
end;

procedure TBatpro_Contrainte.SetCritere_Flottant(const Value: double);
begin
     FContrainte.Critere_Flottant:= Value;
     From_Flottant;
end;

function TBatpro_Contrainte.GetCritere_Date: TDateTime;
begin
     To_Date;
     Result:= FContrainte.Critere_Date;
end;

procedure TBatpro_Contrainte.SetCritere_Date(const Value: TDateTime);
begin
     FContrainte.Critere_Date:= Value;
     From_Date;
end;

procedure TBatpro_Contrainte.cbClick(Sender: TObject);
begin
     Change;
end;

procedure TBatpro_Contrainte.cbOperateurChange(Sender: TObject);
begin
     Change_Active;
end;

procedure TBatpro_Contrainte.eChange(Sender: TObject);
begin
     Change_Active;
end;

procedure TBatpro_Contrainte.dtpDropDown(Sender: TObject);
begin
     dtpChange_actif:= False;
end;

procedure TBatpro_Contrainte.dtpCloseUp(Sender: TObject);
begin
     dtpChange_actif:= True;
     Change_Active;
end;

procedure TBatpro_Contrainte.dtpChange(Sender: TObject);
begin
     if dtpChange_actif
     then
         Change_Active;
end;

procedure TBatpro_Contrainte.Change_Active;
begin
     if not Active
     then
         cb.Checked:= True
     else
         Change;
end;

procedure TBatpro_Contrainte.Change;
begin
     if Assigned( OnChange)
     then
         OnChange( Self);
end;

end.
