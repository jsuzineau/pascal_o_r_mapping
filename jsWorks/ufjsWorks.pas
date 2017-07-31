unit ufjsWorks;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode objfpc}{$H+}

interface

uses
    uChamp,
    uChamps,
    uuStrings,
    uBatpro_StringList,

    udmDatabase,

    ublType_Tag,
    ublTag,
    upoolTag,
    udkTag_LABEL,
    udkTag_LABEL_od,
    udkWork_haTag_LABEL,
    udkWork_haTag_from_Description_LABEL,

    ublWork,
    upoolWork,
    udkWork,

    ublDevelopment,
    upoolDevelopment,
    udkDevelopment,

    ublCategorie,
    upoolCategorie,

    ublState,
    upoolState,

    upoolProject,

    uodWork_from_Period,

    ufAutomatic,
    ufTemps,
    ufProject,
    ufType_Tag,
    ufTag,
    ufTest_VirtualTreeView,
    ufAutomatic_VST,
    ufTest_neo4j,
    ufTULEAP, sqlite3conn,

  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, ucChampsGrid,
  ucDockableScrollbox, ucChamp_DateTimePicker, ucChamp_Edit, ucChamp_Memo,
  ucChamp_Lookup_ComboBox, uDockable, dateutils;

type

 { TfjsWorks }

 TfjsWorks
 =
  class(TForm)
   bBug: TButton;
   bPoint: TButton;
   bProject_to_Tag: TButton;
   bStart: TButton;
   bStop: TButton;
   bTemps: TButton;
   bTULEAP: TButton;
   bCategorie_to_Tag: TButton;
   bDescription_to_Tag: TButton;
   bAutomatic_VST: TButton;
   bNEO4J: TButton;
   bStopAndStart: TButton;
   bNew_Tag_Project_from_Selection: TButton;
   bNew_Tag_Client_from_Selection: TButton;
   bBeginning_From: TButton;
   bVST: TButton;
   ceBeginning: TChamp_Edit;
   ceEnd: TChamp_Edit;
   clkcbCategorie: TChamp_Lookup_ComboBox;
   clkcbState: TChamp_Lookup_ComboBox;
   cmDevelopment_Description: TChamp_Memo;
   cmSolution: TChamp_Memo;
   cmWork_Description: TChamp_Memo;
   dtpBeginning_From: TDateTimePicker;
   dsbWork_Tag: TDockableScrollbox;
   dsbDevelopment: TDockableScrollbox;
   dsbWork: TDockableScrollbox;
   dsbWork_Tag_from_Description: TDockableScrollbox;
   dsbTag: TDockableScrollbox;
   gbDescription: TGroupBox;
   gbSolution: TGroupBox;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   Label7: TLabel;
   Label8: TLabel;
   Label9: TLabel;
   miTag: TMenuItem;
   miType_Tag: TMenuItem;
   miAutomatic: TMenuItem;
   miProject: TMenuItem;
   miVoir: TMenuItem;
   mm: TMainMenu;
   Panel1: TPanel;
   Panel10: TPanel;
   Panel13: TPanel;
   Panel2: TPanel;
   Panel3: TPanel;
   Panel4: TPanel;
   Panel5: TPanel;
   Panel6: TPanel;
   Panel7: TPanel;
   Panel8: TPanel;
   Panel9: TPanel;
   pWork: TPanel;
   pDevelopment: TPanel;
   Splitter1: TSplitter;
   Splitter2: TSplitter;
   Splitter4: TSplitter;
   Splitter6: TSplitter;
   t: TTimer;
   procedure bAutomatic_VSTClick(Sender: TObject);
   procedure bBeginning_FromClick(Sender: TObject);
   procedure bBugClick(Sender: TObject);
   procedure bCategorie_to_TagClick(Sender: TObject);
   procedure bDescription_to_TagClick(Sender: TObject);
   procedure bNEO4JClick(Sender: TObject);
   procedure bNew_Tag_Client_from_SelectionClick(Sender: TObject);
   procedure bNew_Tag_Project_from_SelectionClick(Sender: TObject);
   procedure bPointClick(Sender: TObject);
   procedure bProject_to_TagClick(Sender: TObject);
   procedure bStartClick(Sender: TObject);
   procedure bStopAndStartClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure bTempsClick(Sender: TObject);
   procedure bTULEAPClick(Sender: TObject);
   procedure bVSTClick(Sender: TObject);
   procedure dsbWorkSelect(Sender: TObject);
   procedure dsbDevelopmentSelect(Sender: TObject);
   procedure dsbWorkTraite_Message(_dk: TDockable; _iMessage: Integer);
   procedure dsbWork_TagSuppression(Sender: TObject);
   procedure dsbWork_Tag_from_DescriptionSuppression(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure miAutomaticClick(Sender: TObject);
   procedure miProjectClick(Sender: TObject);
   procedure miTagClick(Sender: TObject);
   procedure miType_TagClick(Sender: TObject);
   procedure pDevelopmentClick(Sender: TObject);
   procedure tTimer(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( TheOwner: TComponent); override;
    destructor Destroy; override;
  //méthodes
  private
    procedure Traite_Beginning_From;
    procedure _from_pool;
  //Work
  private
    blWork : TblWork;
    procedure _from_Work;
  //Development
  private
    blDevelopment: TblDevelopment;
    procedure _from_Development;
  end;

var
 fjsWorks: TfjsWorks;

implementation

{$R *.lfm}

{ TfjsWorks }

constructor TfjsWorks.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);

     dmDatabase.Ouvre_db;

     Caption:= Caption+' - '+dmDatabase.Base_sur;
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

     dsbWork.Classe_dockable:= TdkWork;
     dsbWork.Classe_Elements:= TblWork;

     dsbDevelopment.Classe_dockable:= TdkDevelopment;
     dsbDevelopment.Classe_Elements:= TblDevelopment;

     dsbWork_Tag.Classe_dockable:= TdkWork_haTag_LABEL;
     dsbWork_Tag.Classe_Elements:= TblTag;

     dsbWork_Tag_from_Description.Classe_dockable:= TdkWork_haTag_from_Description_LABEL;
     dsbWork_Tag_from_Description.Classe_Elements:= TblTag;

     dsbTag.Classe_dockable:= TdkTag_LABEL_od;
     dsbTag.Classe_Elements:= TblTag;
     dsbTag.Tri:= poolTag.Tri;
     dsbTag.Filtre:= poolTag.hfTag;

     dtpBeginning_From.Date:= Now-30;
end;

destructor TfjsWorks.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsWorks.FormShow(Sender: TObject);
begin
     t.Enabled:= True;
end;

procedure TfjsWorks.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Traite_Beginning_From;
end;

procedure TfjsWorks.Traite_Beginning_From;
var
   D: TDateTime;
begin
     D:= dtpBeginning_From.Date;
     //poolWork       .ToutCharger();
     poolWork       .Charge_Periode( D, Now);
     poolWork.TrierFiltre;
     //poolDevelopment.ToutCharger();
     _from_pool;
end;

procedure TfjsWorks._from_pool;
begin
     dsbWork       .sl:= poolWork.slFiltre;
     dsbDevelopment.sl:= poolDevelopment.slFiltre;

     poolTag.ToutCharger;
     poolTag.TrierFiltre;
     dsbTag        .sl:= poolTag.slFiltre;

     dsbWork       .Goto_Dernier;
     dsbDevelopment.Goto_Premier;
end;

procedure TfjsWorks._from_Work;
begin
     Champs_Affecte( blWork,
                     [
                      ceBeginning,
                      ceEnd,
                      cmWork_Description
                     ]);
     blWork.haTag.Charge;
     dsbWork_Tag.sl:= blWork.haTag.sl;

     blWork.haTag_from_Description.Charge;
     dsbWork_Tag_from_Description.sl:= blWork.haTag_from_Description.sl;
end;

procedure TfjsWorks._from_Development;
begin
     Champs_Affecte( blDevelopment,
                          [
                          clkcbCategorie,
                          clkcbState,
                          cmDevelopment_Description,
                          cmSolution
                          ]);
end;

procedure TfjsWorks.miType_TagClick(Sender: TObject);
begin
     fType_Tag.Execute;
end;

procedure TfjsWorks.miTagClick(Sender: TObject);
begin
     fTag.Show;
end;

procedure TfjsWorks.miProjectClick(Sender: TObject);
begin
     fProject.Execute;
end;

procedure TfjsWorks.miAutomaticClick(Sender: TObject);
begin
     fAutomatic.Show;
end;

procedure TfjsWorks.pDevelopmentClick(Sender: TObject);
begin

end;

procedure TfjsWorks.bStartClick(Sender: TObject);
var
   bl: TblWork;
begin
     bl:= poolWork.Start( 0);
     _from_pool;
     dsbWork.Goto_bl( bl);
end;

procedure TfjsWorks.bStopClick(Sender: TObject);
begin
     if blWork = nil then exit;
     blWork.Stop;
     _from_Work;
end;

procedure TfjsWorks.bStopAndStartClick(Sender: TObject);
var
   bl: TblWork;
begin
     if Assigned( blWork)
     then
         blWork.Stop;

     bl:= poolWork.Start( 0);
     _from_pool;
     dsbWork.Goto_bl( bl);
end;

procedure TfjsWorks.bTempsClick(Sender: TObject);
begin
     fTemps.Show;
end;

procedure TfjsWorks.bVSTClick(Sender: TObject);
begin
     fTest_VirtualTreeView.Show;
end;

procedure TfjsWorks.bPointClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Point( 0);
     _from_pool;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsWorks.bBugClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Bug( 0);
     _from_pool;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsWorks.bAutomatic_VSTClick(Sender: TObject);
begin
     fAutomatic_VST.Show;
end;

procedure TfjsWorks.bBeginning_FromClick(Sender: TObject);
begin
     Traite_Beginning_From;
end;

procedure TfjsWorks.bProject_to_TagClick(Sender: TObject);
begin
     poolProject.To_Tag;
end;

procedure TfjsWorks.bCategorie_to_TagClick(Sender: TObject);
begin
     poolCategorie.To_Tag;
end;

procedure TfjsWorks.bDescription_to_TagClick(Sender: TObject);
begin
     poolWork.Tag_from_Description;
end;

procedure TfjsWorks.bNEO4JClick(Sender: TObject);
begin
     fTest_neo4j.Show;
end;

procedure TfjsWorks.bNew_Tag_Client_from_SelectionClick(Sender: TObject);
begin
     poolTag.Assure( Type_Tag_id_Client, cmWork_Description.SelText);
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfjsWorks.bNew_Tag_Project_from_SelectionClick(Sender: TObject);
begin
     poolTag.Assure( Type_Tag_id_Project, cmWork_Description.SelText);
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfjsWorks.bTULEAPClick(Sender: TObject);
begin
     fTULEAP.Show;
end;

procedure TfjsWorks.dsbWorkSelect(Sender: TObject);
begin
     dsbWork .Get_bl( blWork );
     _from_Work ;
end;

procedure TfjsWorks.dsbDevelopmentSelect(Sender: TObject);
begin
     dsbDevelopment.Get_bl( blDevelopment);
     _from_Development;
end;

procedure TfjsWorks.dsbWorkTraite_Message( _dk: TDockable; _iMessage: Integer);
var
   dk: TdkWork;
   dk_bl: TblWork;
   cDescription: TChamp;
begin
     if blWork = nil                        then exit;
     if Affecte_( dk, TdkWork, _dk)         then exit;
     if Affecte_( dk_bl, TblWork, dk.Objet) then exit;

     if udkWork_Copy_to_current <> _iMessage then exit;
     Formate_Liste( blWork.Description, #13#10, dk_bl.Description);
     cDescription:= blWork.Champs.Champ['Description'];
     if nil = cDescription then exit;
     cDescription.Publie_Modifications;

end;

procedure TfjsWorks.dsbWork_TagSuppression(Sender: TObject);
var
   blTag: TblTag;
begin
     dsbWork_Tag.Get_bl( blTag);
     blWork.haTag.Supprime( blTag);
     blWork.haTag_from_Description.Ajoute( blTag);
     _from_Work;
end;

procedure TfjsWorks.dsbWork_Tag_from_DescriptionSuppression(Sender: TObject);
var
   blTag: TblTag;
begin
     dsbWork_Tag_from_Description.Get_bl( blTag);
     blWork.haTag_from_Description.Enleve( blTag);
     blWork.Tag( blTag);
     _from_Work;
end;

end.

