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
    uChamps,
    uBatpro_StringList,

    udmDatabase,

    ublProject,
    upoolProject,
    udkProject_LABEL,
    ufProject,

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

    uodWork_from_Period,

    ufAutomatic,

  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ucChampsGrid, ucDockableScrollbox,
  ucChamp_DateTimePicker, ucChamp_Edit, ucChamp_Memo, ucChamp_Lookup_ComboBox;

type

 { TfjsWorks }

 TfjsWorks
 =
  class(TForm)
   bStart: TButton;
   bStop: TButton;
   bPoint: TButton;
   bBug: TButton;
   bTemps: TButton;
   bTest: TButton;
   ceBeginning: TChamp_Edit;
   ceEnd: TChamp_Edit;
   clkcbState: TChamp_Lookup_ComboBox;
   clkcbCategorie: TChamp_Lookup_ComboBox;
   cmSolution: TChamp_Memo;
   cmDevelopment_Description: TChamp_Memo;
   cmWork_Description: TChamp_Memo;
   dsbDevelopment: TDockableScrollbox;
   dsbProject: TDockableScrollbox;
   dsbWork: TDockableScrollbox;
   gbDescription: TGroupBox;
   gbSolution: TGroupBox;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   Label7: TLabel;
   Label8: TLabel;
   lProject: TLabel;
   Panel1: TPanel;
   Panel10: TPanel;
   Panel11: TPanel;
   Panel12: TPanel;
   Panel13: TPanel;
   Panel2: TPanel;
   Panel3: TPanel;
   Panel4: TPanel;
   Panel5: TPanel;
   Panel6: TPanel;
   Panel7: TPanel;
   Panel8: TPanel;
   Panel9: TPanel;
   sbProject: TSpeedButton;
   Splitter1: TSplitter;
   Splitter2: TSplitter;
   Splitter3: TSplitter;
   Splitter4: TSplitter;
   Splitter5: TSplitter;
   t: TTimer;
   procedure bBugClick(Sender: TObject);
   procedure bPointClick(Sender: TObject);
   procedure bStartClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure bTempsClick(Sender: TObject);
   procedure bTestClick(Sender: TObject);
   procedure dsbProjectSelect(Sender: TObject);
   procedure dsbWorkSelect(Sender: TObject);
   procedure dsbDevelopmentSelect(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure sbProjectClick(Sender: TObject);
   procedure tTimer(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( TheOwner: TComponent); override;
    destructor Destroy; override;
  //méthodes
  private
    procedure _from_pool;
  //Project
  private
    blProject: TblProject;
    procedure _from_Project;
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
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

     dsbProject.Classe_dockable:= TdkProject_LABEL;
     dsbProject.Classe_Elements:= TblProject;

     dsbWork.Classe_dockable:= TdkWork;
     dsbWork.Classe_Elements:= TblWork;

     dsbDevelopment.Classe_dockable:= TdkDevelopment;
     dsbDevelopment.Classe_Elements:= TblDevelopment;
end;

destructor TfjsWorks.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsWorks._from_pool;
begin
     dsbProject.sl:= poolProject.slT;
     dsbProject.Goto_Premier;
end;

procedure TfjsWorks._from_Project;
begin
     if blProject = nil
     then
         lProject.Caption:= ''
     else
         lProject.Caption:= blProject.Name;

     if blProject = nil
     then
         dsbWork.sl:= nil
     else
         begin
         blProject.haWork       .Charge;
         blProject.haDevelopment.Charge;

         dsbWork       .sl:= blProject.haWork;
         dsbDevelopment.sl:= blProject.haDevelopment;
         end;
     dsbWork       .Goto_Premier;
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

procedure TfjsWorks.sbProjectClick(Sender: TObject);
begin
     fProject.Execute;
     _from_pool;
end;

procedure TfjsWorks.FormShow(Sender: TObject);
begin
     t.Enabled:= True;
end;

procedure TfjsWorks.dsbProjectSelect(Sender: TObject);
begin
     dsbProject.Get_bl( blProject);
     _from_Project;
end;

procedure TfjsWorks.bStartClick(Sender: TObject);
var
   bl: TblWork;
begin
     bl:= blProject.haWork.Start;
     _from_Project;
     dsbWork.Goto_bl( bl);
end;

procedure TfjsWorks.bStopClick(Sender: TObject);
begin
     if blWork = nil then exit;
     blWork.Stop;
     _from_Work;
end;

procedure TfjsWorks.bTempsClick(Sender: TObject);
begin
     odWork_from_Period.Init( 0, Now);
     SysUtils.ExecuteProcess( '/usr/bin/libreoffice', [odWork_from_Period.Visualiser]);
end;

procedure TfjsWorks.bTestClick(Sender: TObject);
begin
     fAutomatic.Show;
end;

procedure TfjsWorks.bPointClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= blProject.haDevelopment.Point;
     _from_Project;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsWorks.bBugClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= blProject.haDevelopment.Bug;
     _from_Project;
     dsbDevelopment.Goto_bl( bl);
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

procedure TfjsWorks.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     poolProject.ToutCharger();
     _from_pool;
end;

end.

