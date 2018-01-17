unit udkProgression;
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
    uDockable,
  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.StdCtrls, FMX.ExtCtrls, ucBatpro_Shape, FMX.Controls.Presentation,
  FMX.Types, FMX.Objects;

type
 TdkProgression
 =
  class(TDockable)
    p: TPanel;
    pLabels: TPanel;
    lcompte: TLabel;
    lTitre: TLabel;
    pInterrompre: TPanel;
    bInterrompre: TSpeedButton;
    pb: TProgressBar;
    procedure bInterrompreClick(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Début et fin
  public
    ModeFlyer: Boolean;
    procedure Demarre( Titre: String; Min, Max: Single; _Interruptible: Boolean= False);
  //Progression
  private
    FProgress: Single;
    function  GetProgress: Single;
    procedure SetProgress(const Value: Single);
  public
    procedure AddProgress( Value: Single);
    property Progress: Single read GetProgress write SetProgress;
  //Interruption
  public
    Interrompre: Boolean;
  end;

function dkProgression: TdkProgression;

implementation

uses
    uClean;

{$R *.fmx}

var
   FdkProgression: TdkProgression;

function dkProgression: TdkProgression;
begin
     Clean_Get( Result, FdkProgression, TdkProgression);
end;

{ TdkProgression }

constructor TdkProgression.Create(AOwner: TComponent);
begin
     inherited;
     Interrompre:= False;
end;

destructor TdkProgression.Destroy;
begin

     inherited;
end;

procedure TdkProgression.Demarre( Titre: String; Min, Max: Single;
                                  _Interruptible: Boolean= False);
begin
     if Max <= Min then Max:= Min+1;
     lTitre.Text:= Titre;
     pb.Min:= Min;
     pb.Max:= Max;
     pb.Value:= Min;
     lCompte.Text:= '';
     ModeFlyer:= Max = Min + 1;
     pb.Visible:= not ModeFlyer;
     pInterrompre.Visible:= _Interruptible;

     ClientHeight:= Trunc( p.Height);
     //Show;

     //Refresh;
     //uOD_Forms_ProcessMessages;
end;

function TdkProgression.GetProgress: Single;
begin
     if ModeFlyer
     then
         Result:= FProgress
     else
         Result:= pb.Value;
end;

procedure TdkProgression.SetProgress(const Value: Single);
begin
     if ModeFlyer
     then
         FProgress:= Value
     else
         pb.Value:= Value;
     //if Visible and Enabled
     //then
     //    begin
     //    Refresh;
     //    uOD_Forms_ProcessMessages;
     //    end;
end;

procedure TdkProgression.AddProgress( Value: Single);
begin
     Progress:= Progress + Value;
     if ModeFlyer
     then
         lCompte.Text:= Format( '%d', [FProgress])
     else
         lCompte.Text:= Format( '%d de %d', [pb.Value, pb.Max]);
     //if Visible and Enabled
     //then
     //    begin
     //    Refresh;
     //    uOD_Forms_ProcessMessages;
     //    end;
end;

procedure TdkProgression.bInterrompreClick(Sender: TObject);
begin
     Interrompre:= bInterrompre.IsPressed;
end;

initialization
              Clean_Create ( FdkProgression, TdkProgression);
finalization
              Clean_Destroy( FdkProgression);
end.
