unit ufTiming_Play;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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
    uChamps,
    uDataUtilsU,
    uBatpro_Ligne,
    ublTexte,
    ublTiming,

    uPool,
    upoolTexte,
    upoolTiming,

    //Pascal_uf_pc_uses_pas_aggregation

    uDockable,
    udkTexte_display_1,
    udkTexte_display_3,
    udkTiming_display,
    ufPlay,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,StrUtils;

type

 { TfTiming_Play }

 TfTiming_Play
 =
  class(TForm)
   aMoins: TAction;
   aPlus: TAction;
   al: TActionList;
   bPlay: TButton;
   bRecord: TButton;
   bfPlay: TButton;
   bPause: TButton;
   cbAccrocher_Timing: TCheckBox;
   cb: TComboBox;
    dsb: TDockableScrollbox;
    dsbTiming: TDockableScrollbox;
    Label3: TLabel;
    lStart: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter2: TSplitter;
    tPlay: TTimer;
    tShow: TTimer;
    procedure aMoinsExecute(Sender: TObject);
    procedure aPlusExecute(Sender: TObject);
    procedure bfPlayClick(Sender: TObject);
    procedure bPauseClick(Sender: TObject);
    procedure bPlayClick(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure cbSelect(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure dsbTimingSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tPlayTimer(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
  public
    { Déclarations publiques }
    pool: TpoolTexte;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Texte
  private
    blTexte: TblTexte;
    procedure _from_Texte;
  //Select
  private
    Select_running: Boolean;
  //Démarrage
  private
    Start: TDateTime;
    procedure Take_Start;
    procedure lStart_from_Start;
  //Rendu
  private
    slTiming: TslTiming;
    I: TIterateur_Timing;
    blPlay, blPlay_old: TblTiming;
  end;

function fTiming_Play: TfTiming_Play;

implementation

{$R *.lfm}

var
   FfTiming_Play: TfTiming_Play;

function fTiming_Play: TfTiming_Play;
begin
     Clean_Get( Result, FfTiming_Play, TfTiming_Play);
end;

{ TfTiming_Play }

procedure TfTiming_Play.FormCreate(Sender: TObject);
begin
     pool:= poolTexte;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkTexte_display_1;//TdkTexte_display_3;
     dsb.Classe_Elements:= TblTexte;
     dsbTiming.Classe_dockable:= TdkTiming_display;
     dsbTiming.Classe_Elements:= TblTiming;
     //Pascal_uf_pc_initialisation_pas_Aggregation
     Select_running:= False;
     slTiming:= TslTiming.Create( ClassName+'.slTiming');
     I:= nil;
     blPlay:= nil;
     blPlay_old:= nil;
end;

procedure TfTiming_Play.FormDestroy(Sender: TObject);
begin
     FreeAndNil( I);
     FreeAndNil( slTiming);
     inherited;
end;

procedure TfTiming_Play.dsbSelect(Sender: TObject);
var
   iDockable: Integer;
   dk: TDockable;

   blTiming: TblTiming;
   function Match( _bl: TblTiming): Boolean;
   begin
        Result:= Assigned(_bl) and (_bl.Texte_id = blTexte.id);
   end;
begin
     if Select_running then exit;
     try
        Select_running:= True;
        dsb.Get_bl( blTexte);
        _from_Texte;
        dsb.Center_Index_Visible( dsb.Index);
        iDockable:= dsb.iDockable_from_Index( dsb.Index);
        dsb.Get_Dockable( iDockable, dk);
        if Assigned( dk) then dk.Do_DockableScrollbox_Selection;

             if Match( blPlay    ) then blTiming:= blPlay
        else if Match( blPlay_old) then blTiming:= blPlay_old
        else
            begin
            blTiming:= poolTiming.Nouveau;
            blTiming.Texte_id:= blTexte.id;
            end;
        blTiming.t:= Now - Start;
        blTiming.Save_to_database;
     finally
            Select_running:= False;
            end;
end;

procedure TfTiming_Play.dsbTimingSelect(Sender: TObject);
var
   bl: TblTiming;
begin
     if Select_running then exit;

     dsbTiming.Get_bl( bl);
     if nil = bl then exit;
     Start:= Now - bl.t;
end;

procedure TfTiming_Play.lStart_from_Start;
begin
     lStart.Caption:= FormatDateTime( 'hh:nn:ss', Start);
end;

procedure TfTiming_Play.aPlusExecute(Sender: TObject);
begin
     Start:= Start+(1/3600)/24;
     lStart_from_Start;
end;

procedure TfTiming_Play.bfPlayClick(Sender: TObject);
begin
     fPlay.Show;
end;

procedure TfTiming_Play.bPauseClick(Sender: TObject);
begin
     with tPlay do Enabled:= not Enabled;
     bPause.Caption
     :=
       IfThen( tPlay.Enabled, 'Pause','Continue');
end;

procedure TfTiming_Play.aMoinsExecute(Sender: TObject);
begin
     Start:= Start-(1/3600)/24;
     lStart_from_Start;
end;

procedure TfTiming_Play.Take_Start;
begin
     Start:= Now;
     lStart_from_Start;
end;

procedure TfTiming_Play.bRecordClick(Sender: TObject);
begin
     Take_Start;
     poolTiming.Vider_table;
end;

procedure TfTiming_Play.cbSelect(Sender: TObject);
begin
     udkTexte_display_1_Field:= cb.Text;
end;

procedure TfTiming_Play.bPlayClick(Sender: TObject);
begin
     poolTiming.ToutCharger( slTiming);
     poolTiming.TrierListe( slTiming);
     I:= slTiming.Iterateur;
     tPlay.Enabled:= True;
     Take_Start;
     blPlay:= nil;
     blPlay_old:= nil;
end;

procedure TfTiming_Play.tPlayTimer(Sender: TObject);
  procedure Suivant;
  begin
       if I.Continuer
       then
           begin
           blPlay_old:= blPlay;
           I.not_Suivant( blPlay);
           end
       else
           begin
           tPlay.Enabled:= False;
           FreeAndNil( I);
           blPlay:= nil;
           end;
  end;
  procedure Place;
  var
     Texte_Index: Integer;
     Timing_Index: Integer;
  begin
       try
          Select_running:= True; //pour désactiver TfTiming_Play.dsbSelect(Sender: TObject);

          Texte_Index:= poolTexte.slFiltre.IndexOfObject( blPlay.Texte_bl);
          dsb.Index:= Texte_Index;
          fPlay._from( blPlay, blPlay_old);

          if cbAccrocher_Timing.Checked
          then
              begin
              Timing_Index:= poolTiming.slFiltre.IndexOfObject( blPlay);
              dsbTiming.Index:= Timing_Index;
              end;
       finally
              Select_running:= False;
              end;

       Suivant;
  end;
begin
     if nil = blPlay then Suivant;

     if nil = blPlay then exit;

     if (Now-Start) >= blPlay.t then Place;

end;

function TfTiming_Play.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;

     poolTiming.ToutCharger;
     poolTiming.TrierFiltre;
     dsbTiming.sl:= poolTiming.slFiltre;
     Result:= True;

     blPlay:= blTiming_from_sl( dsbTiming.sl, 0);
     fPlay._from( blPlay, nil);

     Show;
end;

procedure TfTiming_Play._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfTiming_Play._from_Texte;
begin
     Champs_Affecte( blTexte,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfTiming_Play.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfTiming_Play.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     _from_pool;
end;

initialization
              Clean_Create ( FfTiming_Play, TfTiming_Play);
finalization
              Clean_Destroy( FfTiming_Play);
end.

