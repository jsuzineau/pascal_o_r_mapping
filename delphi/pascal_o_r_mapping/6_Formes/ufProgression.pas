unit ufProgression;
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
    uOD_Forms,
  uProgression,
  udkProgression,
  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, Dialogs,
  Gauges, StdCtrls, ExtCtrls, ucDockScrollbox, Buttons;

type
 TfProgression
 =
  class(TForm)
    dsb: TDockScrollbox;
    tAutoHide: TTimer;
    procedure tAutoHideTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Bas
  private
    dkBas: TdkProgression;
  //Affichage
  private
    Affichage_OK: Boolean;
  public
    procedure Afficher;
  //Début et fin
  private
    Immediat: Boolean;
    dtDemarrage: TDatetime;
  public
    procedure Demarre( Titre: String; Min, Max: Integer;
                       _Immediat     : Boolean = False;
                       _Interruptible: Boolean= False);
    procedure DemarreImmediat( Titre: String; Min, Max: Integer;
                               _Interruptible: Boolean= False);
    procedure Termine;
  //Progression
  private
    function  GetProgress: Integer;
    procedure SetProgress(const Value: Integer);
  public
    procedure AddProgress( Value: Integer);
    property Progress: Integer read GetProgress write SetProgress;
  //Interruption
  public
    function GetInterrompre: boolean;
  end;

function fProgression: TfProgression;

implementation

uses
    uClean;

{$R *.dfm}

var
   FfProgression: TfProgression;

function fProgression: TfProgression;
begin
     Clean_Get( Result, FfProgression, TfProgression);
end;

{ TfProgression }

procedure TfProgression.FormCreate(Sender: TObject);
begin
     dsb.Classe_dockable:= TdkProgression;
end;

procedure TfProgression.FormDestroy(Sender: TObject);
begin
     tAutoHide.Enabled:= False;
end;

procedure TfProgression.Afficher;
var
   H, M, S, MS,
   Secondes: Word;
   procedure Rafraichir;
   begin
        Refresh;
        //uOD_Forms_ProcessMessages;
   end;
begin
     if Affichage_OK
     then
         begin
         Rafraichir;
         exit;
         end;

     DecodeTime( Now - dtDemarrage, H, M, S, MS);
     Secondes:= ((H*60)+M)*60+S;
     if     (Secondes < 2)
        and not Immediat
     then
         exit;

     Affichage_OK:= True;

     Show;
     Rafraichir;
end;

procedure TfProgression.Demarre( Titre: String; Min, Max: Integer;
                                 _Immediat: Boolean = False;
                                 _Interruptible: Boolean= False);
begin
     Immediat:= _Immediat;
     if dkBas = nil
     then
         dtDemarrage:= Now;
     Affichage_OK:= False;

     tAutoHide.Enabled:= False;

     Height:= dsb.Calcule_Hauteur+dsb.HauteurLigne;
     dsb.Cree_Dockable( dkBas);
     if dkBas = nil then exit;

     dkBas.Demarre( Titre, Min, Max, _Interruptible);
     if dkBas = nil then exit;// il semble qu'un appel à Termine puisse passer pendant Demarre

     tAutoHide.Enabled:= dkBas.ModeFlyer;

     Afficher;
end;

procedure TfProgression.DemarreImmediat(Titre: String; Min, Max: Integer; _Interruptible: Boolean= False);
begin
     Demarre( Titre, Min, Max, True, _Interruptible);
end;

procedure TfProgression.Termine;
begin
     if dkBas = nil then exit;

     dkBas:= dsb.Supprime_dockable( dkBas) as TdkProgression;
     Height:= dsb.Calcule_Hauteur;

     if dsb.IsEmpty
     then
         Hide;
end;

procedure TfProgression.tAutoHideTimer(Sender: TObject);
begin
     tAutoHide.Enabled:= False;
     Termine;
end;

function TfProgression.GetProgress: Integer;
begin
     Result:= 0;
     if dkBas = nil then exit;

     Result:= dkBas.Progress;
end;

procedure TfProgression.SetProgress(const Value: Integer);
begin
     if dkBas = nil then exit;
     dkBas.Progress:= Value;
     Afficher;
end;

procedure TfProgression.AddProgress(Value: Integer);
begin
     if dkBas = nil then exit;
     try
        dkBas.AddProgress( Value);
     except
           on Exception
           do
             begin
             end;
           end;
     Afficher;
     if Affichage_OK
     then
         BringToFront;
end;

function TfProgression.GetInterrompre: boolean;
begin
     Result:= False;

     if dkBas = nil then exit;

     Result:= dkBas.Interrompre;
end;

initialization
              Clean_Create ( FfProgression, TfProgression);
              uProgression_Demarre        := FfProgression.Demarre        ;
              uProgression_DemarreImmediat:= FfProgression.DemarreImmediat;
              uProgression_Termine        := FfProgression.Termine        ;
              uProgression_AddProgress    := FfProgression.AddProgress    ;
              uProgression_GetInterrompre := FfProgression.GetInterrompre ;
finalization
              uProgression_Demarre        := nil;
              uProgression_DemarreImmediat:= nil;
              uProgression_Termine        := nil;
              uProgression_AddProgress    := nil;
              uProgression_GetInterrompre := nil;
              Clean_Destroy( FfProgression);
end.
