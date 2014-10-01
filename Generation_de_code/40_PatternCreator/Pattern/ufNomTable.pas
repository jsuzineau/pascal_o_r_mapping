unit ufNomTable;
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
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,
  uDataUtilsU,
  uf,
  ufBase;

type
 TfNomTable
 =
  class(TfBase)
    Label2: TLabel;
    cbIndexName: TComboBox;
    procedure dbgCellClick(Column: TColumn);
    procedure dbgKeyPress(Sender: TObject; var Key: Char);
    procedure bImprimerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbIndexNameChange(Sender: TObject);
  private
    { Déclarations privées }
    Prefixe_Index: String;
    LPrefixe_Index: Integer;
    procedure Index_cb_to_dm;
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fNomTable: TfNomTable;

implementation

uses
    uClean,
    uOOoDatasetPrinter,
{f_implementation_uses_key}
    udmNomTable; {AUTOOPENUNIT udmNomTable}

{$R *.dfm}

var
   FfNomTable: TfNomTable;

function fNomTable: TfNomTable;
begin
     Clean_Get( Result, FfNomTable, TfNomTable);
end;

{ TfNomTable }

const
     s_Ne_Pas_Trier= '----- Ne pas trier -------------';

procedure TfNomTable.FormCreate(Sender: TObject);
var
   I: Integer;
   IndexName, FieldName: String;
begin
     inherited;
     Prefixe_Index:= 'iNomTable';
     LPrefixe_Index:= Length( Prefixe_Index);

     dmNomTable.t.GetIndexNames( cbIndexName.Items);
     cbIndexName.Items.Insert(0, s_Ne_Pas_Trier);
     for I:= cbIndexName.Items.Count-1 downto 1
     do
       begin
       IndexName:= cbIndexName.Items[ I];
       if Pos( Prefixe_Index, IndexName) <> 1
       then
           cbIndexName.Items.Delete( I)
       else
           begin
           Delete( IndexName, 1, LPrefixe_Index);
           cbIndexName.Items[ I]:= IndexName;
           end;
       end;

     for I:= 1 to cbIndexName.Items.Count-1
     do
       begin
       FieldName:= cbIndexName.Items[ I];
       if FieldName <> ''
       then
           if Pos( '_n', FieldName) <> 1 //Ce n'est pas un index de clé étrangère
           then
               begin
               cbIndexName.ItemIndex:= I;
               break;
               end;
       end;
end;

function TfNomTable.Execute: Boolean;
var
   Initial_Ouvert : Boolean;
begin
     Initial_Ouvert:= dmNomTable.Ouvert;
     Result:= dmNomTable.Ouvrir_Edition;
     if Result
     then
         try
            try
               //f_Execute_Before_Key
               Index_cb_to_dm;
               Result:= inherited Execute;
            finally
                   //f_Execute_After_Key
                   end;
         finally
                if Initial_Ouvert
                then
                    dmNomTable.Ouvrir_LectureSeule
                else
                    dmNomTable.Fermer;
                end;
end;

procedure TfNomTable.dbgCellClick(Column: TColumn);
begin
     inherited;
     if dbg.ReadOnly then exit;
     //f_dbgCellClick_Key
end;

procedure TfNomTable.dbgKeyPress(Sender: TObject; var Key: Char);
//f_dbgKeyPress_Key_Variables
begin
     inherited;
     if dbg.ReadOnly then exit;
     //f_dbgKeyPress_Key
end;

procedure TfNomTable.bImprimerClick(Sender: TObject);
begin
     inherited;
     OOoDatasetPrinter.Execute( 'fNomTable.ott', 'NomTable', dmNomTable.t);
end;

procedure TfNomTable.Index_cb_to_dm;
var
   IndexName: String;
begin
     IndexName:= cbIndexName.Text;
     if IndexName <> ''
     then
         if IndexName = s_Ne_Pas_Trier
         then
             IndexName:= ''
         else
             IndexName:= Prefixe_Index+IndexName;
     dmNomTable.t.IndexName:= IndexName;
end;

procedure TfNomTable.cbIndexNameChange(Sender: TObject);
begin
     Index_cb_to_dm;
end;

initialization
              Clean_Create ( FfNomTable, TfNomTable);
finalization
              Clean_Destroy( FfNomTable);
end.
