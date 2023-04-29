unit ucDockScrollbox;
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
    SysUtils, Classes, FMX.Controls, FMX.Forms, FMX.ExtCtrls,FMX.Graphics,
    uBatpro_StringList,
    uClean,
    u_sys_,
    uWinUtils,
    uPublieur,
    uDockable,
    FMX.Layouts, System.UITypes, FMX.StdCtrls;

type
 TDockScrollbox
 =
  class(TScrollBox)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Classe des dockables
  public
    Classe_dockable: TDockableClass;
  // Liste des dockables et de leurs panels
  public
    slDockable: TBatpro_StringList;
    slPanel   : TBatpro_StringList;
    procedure Cree_Dockable( var dk);
    procedure Get_Dockable( nDockable: Integer; var dk);
    function  Supprime_dockable( Index: Integer): TDockable; overload;
    function  Supprime_dockable( dk: TDockable): TDockable; overload;
    procedure Vide;
    function IsEmpty: Boolean;
  //Hauteur de panel
  private
    FHauteurLigne: Integer;
  published
    property HauteurLigne: Integer read FHauteurLigne write FHauteurLigne;
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
    procedure DemandeSuppression( Sender: TObject);
  //Calcul de la hauteur
  public
    function Calcule_Hauteur: Integer;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TDockScrollbox]);
end;

{ TDockScrollbox }

constructor TDockScrollbox.Create(AOwner: TComponent);
begin
     inherited;
     slDockable:= TBatpro_StringList.Create;
     slPanel   := TBatpro_StringList.Create;
     HauteurLigne:= 24;
     Classe_dockable:= nil;
     FValide:= True;
     pValide_Change:= TPublieur.Create( Name+'.pValide_Change');
end;

destructor TDockScrollbox.Destroy;
begin
     FreeAndnil( pValide_Change);
     FreeAndnil( slDockable);
     FreeAndnil( slPanel   );
     inherited;
end;

procedure TDockScrollbox.Cree_Dockable(var dk);
var
   I: Integer;
   p: TPanel;
   Bas: Integer;
   Old_Visible: Boolean;
begin
     Old_Visible:= Visible;
     if Old_Visible then Hide;
     try
        Bas:= Calcule_Hauteur;
        Height:= Bas + HauteurLigne;

        p:= TPanel.Create( nil);
        p.Parent:= Self;
        p.Position.X:= Bas;
        //p.Align:= alTop;
        //p.DockSite:= True;
        p.Height:= HauteurLigne;

        Create_Dockable( dk, Classe_dockable, p);

        I:= slDockable.AddObject( sys_Vide, TDockable(dk));
            slPanel   .AddObject( sys_Vide, p );

        TDockable(dk).Objet:= nil;
        TDockable(dk).pValide_Change.Abonne( Self, Verifie_Validites);

        TDockable(dk).DockableScrollbox_Suppression:= DemandeSuppression;

        {
        if Zebrage
        then
            if Odd( I)
            then
                TDockable(dk).Brush.Color:= Zebrage1
            else
                TDockable(dk).Color:= Zebrage2;
        }
     finally
            if Old_Visible then Show;
            end;
end;

procedure TDockScrollbox.SetValide( const Value: Boolean);
begin
     if FValide = Value then exit;

     FValide := Value;
     pValide_Change.Publie;
end;

procedure TDockScrollbox.Verifie_Validites;
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

function TDockScrollbox.Supprime_dockable( Index: Integer): TDockable;
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
         FreeAndNil( p);
         end;
     slDockable.Delete( Index);
     slPanel   .Delete( Index);

     Result:= Dockable_from_sl( slDockable, slDockable.Count - 1);

     Height:= Calcule_Hauteur;
end;

procedure TDockScrollbox.Vide;
var
   I: Integer;
begin
     for I:= slDockable.Count - 1 downto 0
     do
       Supprime_dockable( I);
end;

procedure TDockScrollbox.DemandeSuppression(Sender: TObject);
var
   I: Integer;
begin
     I:= slDockable.IndexOfObject( Sender);
     if I <> -1
     then
         Supprime_dockable( I);

     Verifie_Validites;
     pValide_Change.Publie;
end;

procedure TDockScrollbox.Get_Dockable( nDockable: Integer; var dk);
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

function TDockScrollbox.Supprime_dockable(dk: TDockable): TDockable;
var
   I: Integer;
begin
     Result:= nil;

     I:= slDockable.IndexOfObject( dk);
     if I = -1 then exit;

     Result:= Supprime_dockable( I);
end;

function TDockScrollbox.IsEmpty: Boolean;
begin
     Result:= slDockable.Count = 0;
end;

function TDockScrollbox.Calcule_Hauteur: Integer;
begin
     Result:= slDockable.Count * HauteurLigne;
end;

end.


