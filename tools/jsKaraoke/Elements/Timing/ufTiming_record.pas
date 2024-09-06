unit ufTiming_record;
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
    udkTiming_display,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfTiming_record }

 TfTiming_record
 =
  class(TForm)
   aMoins: TAction;
   aPlus: TAction;
   al: TActionList;
   bRecord: TButton;
   bPlay: TButton;
    dsb: TDockableScrollbox;
    dsbTiming: TDockableScrollbox;
    Label3: TLabel;
    lStart: TLabel;
    Panel4: TPanel;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bImprimer: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    Splitter2: TSplitter;
    tPlay: TTimer;
    tShow: TTimer;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure aMoinsExecute(Sender: TObject);
    procedure aPlusExecute(Sender: TObject);
    procedure bPlayClick(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure dsbTimingSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tPlayTimer(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
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

function fTiming_record: TfTiming_record;

implementation

{$R *.lfm}

var
   FfTiming_record: TfTiming_record;

function fTiming_record: TfTiming_record;
begin
     Clean_Get( Result, FfTiming_record, TfTiming_record);
end;

{ TfTiming_record }

procedure TfTiming_record.FormCreate(Sender: TObject);
begin
     pool:= poolTexte;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, @NbTotal_Change);
     dsb.Classe_dockable:= TdkTexte_display_1;
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

procedure TfTiming_record.FormDestroy(Sender: TObject);
begin
     FreeAndNil( I);
     FreeAndNil( slTiming);
     pool.pFiltreChange.Desabonne( Self, @NbTotal_Change);
     inherited;
end;

procedure TfTiming_record.dsbSelect(Sender: TObject);
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

procedure TfTiming_record.dsbTimingSelect(Sender: TObject);
var
   bl: TblTiming;
begin
     dsbTiming.Get_bl( bl);
     if nil = bl then exit;
     Start:= Now - bl.t;
end;

procedure TfTiming_record.lStart_from_Start;
begin
     lStart.Caption:= FormatDateTime( 'hh:nn:ss', Start);
end;

procedure TfTiming_record.aPlusExecute(Sender: TObject);
begin
     Start:= Start+(1/3600)/24;
     lStart_from_Start;
end;

procedure TfTiming_record.aMoinsExecute(Sender: TObject);
begin
     Start:= Start-(1/3600)/24;
     lStart_from_Start;
end;

procedure TfTiming_record.Take_Start;
begin
     Start:= Now;
     lStart_from_Start;
end;

procedure TfTiming_record.bRecordClick(Sender: TObject);
begin
     Take_Start;
     poolTiming.Vider_table;
end;

procedure TfTiming_record.bPlayClick(Sender: TObject);
begin
     poolTiming.ToutCharger( slTiming);
     poolTiming.TrierListe( slTiming);
     I:= slTiming.Iterateur;
     tPlay.Enabled:= True;
     Take_Start;
     blPlay:= nil;
     blPlay_old:= nil;
end;

procedure TfTiming_record.tPlayTimer(Sender: TObject);
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
           end;
  end;
  procedure Place;
  var
     Texte_Index: Integer;
  begin
       Texte_Index:= poolTexte.slFiltre.IndexOfObject( blPlay.Texte_bl);
       dsb.Center_Index_Visible( Texte_Index);
       blPlay:= nil;
       Suivant;
  end;
begin
     if nil = blPlay then Suivant;

     if nil = blPlay then exit;

     if (Now-Start) >= blPlay.t then Place;

end;

procedure TfTiming_record.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfTiming_record.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;

     poolTiming.ToutCharger;
     dsbTiming.sl:= poolTiming.slFiltre;
     Result:= True;
     Show;
end;

procedure TfTiming_record._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfTiming_record._from_Texte;
begin
     Champs_Affecte( blTexte,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfTiming_record.bNouveauClick(Sender: TObject);
var
   blNouveau: TblTexte;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfTiming_record.bSupprimerClick(Sender: TObject);
var
   bl: TblTexte;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     if mrYes
        <>
        MessageDlg( 'Êtes vous sûr de vouloir supprimer la ligne ?'#13#10
                    +bl.GetLibelle,
                    mtConfirmation, [mbYes, mbNo], 0)
     then
         exit;

     pool.Supprimer( bl);
     _from_pool;
end;

procedure TfTiming_record.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fTiming_record.stw',
                                   'Texte',[],[],[],[],
                                   ['Texte'],
                                   [poolTexte.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

procedure TfTiming_record.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfTiming_record.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     _from_pool;
end;

initialization
              Clean_Create ( FfTiming_record, TfTiming_record);
finalization
              Clean_Destroy( FfTiming_record);
end.

