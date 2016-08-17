unit udkSession;
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

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,
    ublSession,
    ublWork,
    uDockable,
    ucBatpro_Shape,
    ucChamp_Label, ucChamp_Edit, ucChamp_Memo, Classes, SysUtils, FileUtil,
    Forms, Controls, Graphics, Dialogs, ClipBrd, ExtCtrls, StdCtrls;

type

 { TdkSession }

 TdkSession
 =
  class(TDockable)
   ceBeginning: TChamp_Edit;
   ceEnd_: TChamp_Edit;
   cmLibelle: TChamp_Memo;
   Label1: TLabel;
   lCumul_Global_Depassement: TLabel;
   Panel1: TPanel;
   Panel2: TPanel;
   Splitter1: TSplitter;
    procedure ceBeginningEnter(Sender: TObject);
    procedure ceEnd_Enter(Sender: TObject);
    procedure cmLibelleEnter(Sender: TObject);
    procedure FormClick(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blSession: TblSession;
 end;

implementation

{$R *.lfm}

{ TdkSession }

constructor TdkSession.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Ajoute_Colonne( cmLibelle, 'Libelle', 'Libelle');
end;

destructor TdkSession.Destroy;
begin
     inherited Destroy;
end;

procedure TdkSession.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blSession, TblSession, Value);

     Champs_Affecte( blSession, [ceBeginning, ceEnd_, cmLibelle]);
     if Assigned( blSession)
     then
         lCumul_Global_Depassement.Caption:= sNb_Heures_from_DateTime( blSession.Cumul_Global.Depassement);
end;

procedure TdkSession.FormClick(Sender: TObject);
begin
     inherited;
end;

procedure TdkSession.ceBeginningEnter(Sender: TObject);
begin
     Clipboard.AsText:= ceBeginning.Text;
end;

procedure TdkSession.ceEnd_Enter(Sender: TObject);
begin
     Clipboard.AsText:= ceEnd_.Text;
end;

procedure TdkSession.cmLibelleEnter(Sender: TObject);
begin
     Clipboard.AsText:= cmLibelle.Text;
end;

end.

