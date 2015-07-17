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
    ufTemps,
    ufProject,
    ufType_Tag,
    ufTAG,

  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ucChampsGrid, ucDockableScrollbox,
  ucChamp_DateTimePicker, ucChamp_Edit, ucChamp_Memo, ucChamp_Lookup_ComboBox;

type

 { TfjsWorks }

 TfjsWorks
 =
  class(TForm)
   bBug: TButton;
   bPoint: TButton;
   bProject: TButton;
   bStart: TButton;
   bStop: TButton;
   bTAG: TButton;
   bTemps: TButton;
   bTest: TButton;
   bType_Tag: TButton;
   ceBeginning: TChamp_Edit;
   ceEnd: TChamp_Edit;
   clkcbCategorie: TChamp_Lookup_ComboBox;
   clkcbState: TChamp_Lookup_ComboBox;
   cmDevelopment_Description: TChamp_Memo;
   cmSolution: TChamp_Memo;
   cmWork_Description: TChamp_Memo;
   dsbDevelopment: TDockableScrollbox;
   dsbWork: TDockableScrollbox;
   gbDescription: TGroupBox;
   gbSolution: TGroupBox;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   Label7: TLabel;
   Label8: TLabel;
   Panel1: TPanel;
   Panel10: TPanel;
   Panel13: TPanel;
   Panel2: TPanel;
   Panel3: TPanel;
   Panel5: TPanel;
   Panel7: TPanel;
   Panel8: TPanel;
   Panel9: TPanel;
   pWork: TPanel;
   pDevelopment: TPanel;
   Splitter1: TSplitter;
   Splitter4: TSplitter;
   Splitter6: TSplitter;
   t: TTimer;
   procedure bBugClick(Sender: TObject);
   procedure bPointClick(Sender: TObject);
   procedure bProjectClick(Sender: TObject);
   procedure bStartClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure bTAGClick(Sender: TObject);
   procedure bTempsClick(Sender: TObject);
   procedure bTestClick(Sender: TObject);
   procedure bType_TagClick(Sender: TObject);
   procedure dsbWorkSelect(Sender: TObject);
   procedure dsbDevelopmentSelect(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure pDevelopmentClick(Sender: TObject);
   procedure tTimer(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( TheOwner: TComponent); override;
    destructor Destroy; override;
  //méthodes
  private
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
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

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
     dsbWork       .sl:= poolWork.slFiltre;
     dsbDevelopment.sl:= poolDevelopment.slFiltre;

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

procedure TfjsWorks.FormShow(Sender: TObject);
begin
     t.Enabled:= True;
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

procedure TfjsWorks.bTAGClick(Sender: TObject);
begin
     fTAG.Show;
end;

procedure TfjsWorks.bTempsClick(Sender: TObject);
begin
     fTemps.Show;
end;

procedure TfjsWorks.bTestClick(Sender: TObject);
begin
     fAutomatic.Show;
end;

procedure TfjsWorks.bType_TagClick(Sender: TObject);
begin
     fType_Tag.Execute;
end;

procedure TfjsWorks.bPointClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Point( 0);
     _from_pool;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsWorks.bProjectClick(Sender: TObject);
begin
     fProject.Execute;
end;

procedure TfjsWorks.bBugClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Bug( 0);
     _from_pool;
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
     poolWork       .ToutCharger();
     poolDevelopment.ToutCharger();
     _from_pool;
end;

end.

