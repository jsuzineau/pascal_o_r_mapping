unit udkdNomTable;
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
  udkdBase,
  udmt;

type
 TdkdNomTable
 =
  class(TdkdBase)
    cbIndexName: TComboBox;
    Label2: TLabel;
    procedure dbgCellClick(Column: TColumn);
    procedure dbgKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
    procedure cbIndexNameChange(Sender: TObject);
  private
    { Déclarations privées }
    Prefixe_Index: String;
    LPrefixe_Index: Integer;
    procedure Index_cb_to_dm;
  public
    { Déclarations publiques }
    procedure Accroche(_dmt: Tdmt; _pc: TPageControl); override;
    procedure Decroche(_dmt: Tdmt; _pc: TPageControl); override;
  end;

function dkdNomTable: TdkdNomTable;

implementation

uses
    uClean,
    uOOoDetailPrinter,
{dkd_implementation_uses_key}
    udmdNomTable;

{$R *.dfm}

var
   FdkdNomTable: TdkdNomTable;

function dkdNomTable: TdkdNomTable;
begin
     Clean_Get( Result, FdkdNomTable, TdkdNomTable);
end;

{ TdkdNomTable }

const
     s_Ne_Pas_Trier= '----- Ne pas trier -------------';

procedure TdkdNomTable.FormCreate(Sender: TObject);
begin
     dmd:= dmdNomTable;
     Nom:= 'NomTable';
     dbg.DataSource:= dmd.ds;
     dbn.DataSource:= dmd.ds;
     inherited;
end;

procedure TdkdNomTable.dbgCellClick(Column: TColumn);
begin
     inherited;
     if dbg.ReadOnly then exit;
     //dkd_dbgCellClick_Key
end;

procedure TdkdNomTable.dbgKeyPress(Sender: TObject; var Key: Char);
//dkd_dbgKeyPress_Key_Variables
begin
     inherited;
     if dbg.ReadOnly then exit;
     //dkd_dbgKeyPress_Key
end;

procedure TdkdNomTable.bImprimerClick(Sender: TObject);
var
   fLibelle: TField;
   sLibelle: String;
begin
     inherited;
     fLibelle:= dmt.t.FindField( 'Libelle');
     if Assigned( fLibelle)
     then
         sLibelle:= 'NomTable de '+fLibelle.DisplayText
     else
         sLibelle:= 'NomTable';
     OOoDetailPrinter.Execute( 'dkdNomTable.ott', sLibelle, [], [], dmt.t,dmdNomTable.t);
end;

procedure TdkdNomTable.Accroche(_dmt: Tdmt; _pc: TPageControl);
var
   I: Integer;
   IndexName, FieldName: String;
begin
     inherited;

     Prefixe_Index:= 'iNomTable_n'+dmd.Nom_Maitre;
     LPrefixe_Index:= Length( Prefixe_Index);

     dmd.t.GetIndexNames( cbIndexName.Items);
     for I:= cbIndexName.Items.Count-1 downto 0
     do
       begin
       IndexName:= cbIndexName.Items[ I];
       if Pos( Prefixe_Index, IndexName) <> 1
       then
           cbIndexName.Items.Delete( I)
       else
           begin
           Delete( IndexName, 1, LPrefixe_Index);
           if IndexName = ''
           then
               IndexName:= s_Ne_Pas_Trier;
           cbIndexName.Items[ I]:= IndexName;
           end;
       end;

     for I:= 0 to cbIndexName.Items.Count-1
     do
       begin
       FieldName:= cbIndexName.Items[ I];
       if FieldName <> s_Ne_Pas_Trier
       then
           if Pos( '_n', FieldName) <> 1 //Ce n'est pas un index de clé étrangère
           then
               begin
               cbIndexName.ItemIndex:= I;
               break;
               end;
       end;
end;

procedure TdkdNomTable.Decroche(_dmt: Tdmt; _pc: TPageControl);
begin
     inherited;
     cbIndexName.Clear;
end;

procedure TdkdNomTable.Index_cb_to_dm;
var
   IndexName: String;
begin
     IndexName:= cbIndexName.Text;
     if IndexName = s_Ne_Pas_Trier
     then
         IndexName:= '';
     IndexName:= Prefixe_Index+IndexName;
     dmd.t.IndexName:= IndexName;
end;

procedure TdkdNomTable.cbIndexNameChange(Sender: TObject);
begin
     Index_cb_to_dm;
end;

initialization
              Clean_Create ( FdkdNomTable, TdkdNomTable);
finalization
              Clean_Destroy( FdkdNomTable);
end.
