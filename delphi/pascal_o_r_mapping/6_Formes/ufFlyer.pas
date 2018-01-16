unit ufFlyer;
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
  udkProgression,
  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  Gauges, FMX.StdCtrls, FMX.ExtCtrls, ucDockScrollbox;

type
 TfFlyer
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
    procedure Demarre( Titre: String; Min, Max: Integer; _Immediat: Boolean = False);
    procedure DemarreImmediat( Titre: String; Min, Max: Integer);
    procedure Termine;
  //Progression
  private
    function  GetProgress: Integer;
    procedure SetProgress(const Value: Integer);
  public
    procedure AddProgress( Value: Integer);
    property Progress: Integer read GetProgress write SetProgress;
  end;

function fFlyer: TfFlyer;

implementation

uses
    uClean;

{$R *.dfm}

var
   FfFlyer: TfFlyer;

function fFlyer: TfFlyer;
begin
     Clean_Get( Result, FfFlyer, TfFlyer);
end;

{ TfFlyer }

procedure TfFlyer.FormCreate(Sender: TObject);
begin
     dsb.Classe_dockable:= TdkProgression;
end;

procedure TfFlyer.FormDestroy(Sender: TObject);
begin
     tAutoHide.Enabled:= False;
end;

procedure TfFlyer.Afficher;
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

procedure TfFlyer.Demarre( Titre: String; Min, Max: Integer; _Immediat: Boolean = False);
begin
     //########## PROVISOIRE ##########
                    exit;
     //########## PROVISOIRE ##########

     Immediat:= _Immediat;
     if dkBas = nil
     then
         dtDemarrage:= Now;
     Affichage_OK:= False;

     tAutoHide.Enabled:= False;

     dsb.Cree_Dockable( dkBas);
     if dkBas = nil then exit;

     dkBas.Demarre( Titre, Min, Max);

     tAutoHide.Enabled:= dkBas.ModeFlyer;

     Height:= Height + dsb.HauteurLigne;
     Afficher;
end;

procedure TfFlyer.DemarreImmediat(Titre: String; Min, Max: Integer);
begin
     Demarre( Titre, Min, Max, True);
end;

procedure TfFlyer.Termine;
begin
     if dkBas = nil then exit;

     dkBas:= dsb.Supprime_dockable( dkBas) as TdkProgression;
     Height:= Height - dsb.HauteurLigne;

     if dsb.IsEmpty
     then
         Hide;
end;

procedure TfFlyer.tAutoHideTimer(Sender: TObject);
begin
     tAutoHide.Enabled:= False;
     Termine;
end;

function TfFlyer.GetProgress: Integer;
begin
     Result:= 0;
     if dkBas = nil then exit;

     Result:= dkBas.Progress;
end;

procedure TfFlyer.SetProgress(const Value: Integer);
begin
     if dkBas = nil then exit;
     dkBas.Progress:= Value;
     Afficher;
end;

procedure TfFlyer.AddProgress(Value: Integer);
begin
     if dkBas = nil then exit;
     dkBas.AddProgress( Value);
     Afficher;
end;

initialization
              Clean_Create ( FfFlyer, TfFlyer);
finalization
              Clean_Destroy( FfFlyer);
end.
