unit ufClientDataset;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ufpBas, DB, BufDataset, Grids, DBGrids, ActnList, StdCtrls, ComCtrls,
  Buttons, ExtCtrls, DBCtrls;

type
  TfClientDataset = class(TfpBas)
    dbg: TDBGrid;
    ds: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    mField: TMemo;
    Panel4: TPanel;
    edbmField: TEdit;
    pc: TPageControl;
    tsMemo: TTabSheet;
    dbm: TDBMemo;
    tsImage: TTabSheet;
    Panel3: TPanel;
    bSaveAs: TButton;
    bOpen: TButton;
    dbi: TDBImage;
    Splitter1: TSplitter;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    lUpdateStatus: TLabel;
    procedure dbgCellClick(Column: TColumn);
    procedure edbmFieldChange(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure bSaveAsClick(Sender: TObject);
    procedure cdAfterScroll(DataSet: TDataSet);
  private
    { Déclarations privées }
    cd: TBufDataset;
  public
    { Déclarations publiques }
    function Execute( ClientDataset: TBufDataset): Boolean; reintroduce;
  end;

function fClientDataset: TfClientDataset;

implementation

uses
    uClean,
    u_sys_,
    uDataUtilsU,
    uDataUtilsF;

{$R *.dfm}

var
  FfClientDataset: TfClientDataset;

function fClientDataset: TfClientDataset;
begin
     Clean_Get( Result, FfClientDataset, TfClientDataset);
end;

function sUpdateStatus( cd: TBufDataset): String;
begin
     case cd.UpdateStatus
     of
       usUnmodified:Result:='L''enregistrement actuel n''a pas de mise àjour non appliquée.                                                 ';
       usModified	 :Result:='L''enregistrement actuel a des modifications non appliquées.                                                   ';
       usInserted	 :Result:='L''enregistrement actuel a été inséré mais l''insertion n''a pas étéappliquée.                                 ';
       usDeleted	 :Result:='L''enregistrement actuel représente un enregistrement supprimé,mais la suppression n''est pas encore appliquée.';
       else         Result:= 'Valeur TUpdateStatus inconnue: '+IntToStr( Integer(cd.UpdateStatus));
       end;
end;

{ TfClientDataset }

function TfClientDataset.Execute( ClientDataset: TBufDataset): Boolean;
var
   I: Integer;
   C: TColumn;
begin
     cd:= ClientDataset;
     ds.DataSet:= cd;

     //Masquage des colonnes avec mot de passe
     for I:= 0 to dbg.Columns.Count-1
     do
       begin
       C:= dbg.Columns.Items[ I];
       if IsPassword_Field( C.FieldName)
       then
           C.Visible:= False;
       end;

     try
        Traite_Titres_Boutons;

        Caption := 'Visualisation des modifications sur '+NamePath( ClientDataset);
        edbmField.Text:= sys_Vide;
        Result:= inherited Execute;
     finally
            ds.DataSet:= nil;
            cd:= nil;
            end;
end;

procedure TfClientDataset.dbgCellClick(Column: TColumn);
var
   F: TField;
begin
     edbmField.Text:= Column.FieldName;
     F:= Column.Field;
     if F = nil
     then
         mField.Text:= sys_Vide
     else
         mField.Text:= 'Type  : '+F.ClassName+sys_N+
                       'Taille: '+IntToStr( F.Size);
end;

procedure TfClientDataset.edbmFieldChange(Sender: TObject);
var
   F: TField;
begin
     F:= cd.FindField( edbmField.Text);

     dbm.DataSource:= nil;
     dbm.DataField:= sys_Vide;

     dbi.DataSource:= nil;
     dbi.DataField:= sys_Vide;

     if Assigned( F)
     then
         if F is TGraphicField
         then
             begin
             dbi.DataSource:= ds;
             dbi.DataField:= F.FieldName;
             pc.ActivePage:= tsImage;
             end
         else
             begin
             dbm.DataSource:= ds;
             dbm.DataField:= F.FieldName;
             pc.ActivePage:= tsMemo;
             end;
end;

procedure TfClientDataset.bOpenClick(Sender: TObject);
begin
     if OpenDialog.Execute
     then
         dbi.Picture.LoadFromFile( SaveDialog.FileName);
end;

procedure TfClientDataset.bSaveAsClick(Sender: TObject);
begin
     if SaveDialog.Execute
     then
         dbi.Picture.SaveToFile( SaveDialog.FileName);
end;

procedure TfClientDataset.cdAfterScroll(DataSet: TDataSet);
begin
     inherited;
     lUpdateStatus.Caption:= sUpdateStatus( cd);
end;

initialization
              Clean_CreateD( FfClientDataset, TfClientDataset);
finalization
              Clean_Destroy( FfClientDataset);
end.
