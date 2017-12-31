unit ufcbBase;
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
    uForms,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, StdCtrls, Buttons, db, dbctrls, dbtables;

type
 TExecuteFunction= function :Boolean of object;

 TfcbBase
 =
  class(TForm)
    dbg: TDBGrid;
    Panel1: TPanel;
    bCancel: TBitBtn;
    bNouveau: TBitBtn;
    Panel2: TPanel;
    eFiltre: TEdit;
    procedure dbgDblClick(Sender: TObject);
    procedure dbgCellClick(Column: TColumn);
    procedure dbgKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure bNouveauClick(Sender: TObject);
    procedure eFiltreChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eFiltreKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
  private
    { Déclarations privées}
    Nouveau: TExecuteFunction;
  public
    { Déclarations publiques}
    Resultat, Valeur: TIntegerField;
    function DerouleListe( Editeur: TObject; ds: TDataSource;
                           unNouveau: TExecuteFunction;
                           unResultat, uneValeur:TIntegerField)
                           : Boolean; virtual;
    procedure Valide( ValeurValide: TIntegerField); virtual;
  end;

implementation

uses
    uClean,
    uWinUtils,

    uDataUtilsU,
    uDataUtilsF;

{$R *.dfm}

(*
procedure Affecte( Resultat, Valeur: TIntegerField);
var
   C: TComponent;
   D: TDataset;
begin
     if Resultat <> nil
     then
         begin
         C:= Resultat.GetParentComponent;

         if C is TDataset
         then
             begin
             D:= TDataset( C);
             Assure_Edit( D);
             Resultat.Value:= Valeur.Value;
             end
         else
             uForms_ShowMessage( Format( 'Erreur à signaler au développeur: '#13#10+
                                  'unité ufcb: '#13#10+
                                  'Le champ %s n''appartient pas à un TDataset',
                                  [Resultat.FullName]));
         end;
end;
*)
procedure TfcbBase.dbgDblClick(Sender: TObject);
begin
     Valide( Valeur);
end;

procedure TfcbBase.FormShow(Sender: TObject);
begin
     eFiltre.SetFocus;
     eFiltre.SelectAll;
end;

procedure TfcbBase.eFiltreChange(Sender: TObject);
var
   Datasource: TDataSource;
   Dataset: TDataSet;
   Filtre: String;
   Filtrer: Boolean;
begin
     Datasource:= dbg.Datasource;
     if Assigned( Datasource)
     then
         begin
         Dataset:= Datasource.Dataset;
         if Assigned( Dataset)
         then
             with Dataset
             do
               begin
               Filtre:= eFiltre.Text;
               Filtrer:= Filtre <> '';

               Filtered:= Filtrer;
               if Filtrer
               then
                   begin
                   FilterOptions:= [foCaseInsensitive];
                   Filter:= Format( 'Nom = ''%s*''', [Filtre]);
                   end;
               end;
         end;
end;

function TfcbBase.DerouleListe( Editeur: TObject; ds: TDataSource;
                            unNouveau: TExecuteFunction;
                            unResultat, uneValeur: TIntegerField)
                            : Boolean;
var
   P: TPoint;
   Haut, Bas: Integer;
begin
     dbg.DataSource:= ds;
     eFiltreChange( nil);
     Nouveau:= unNouveau;
     Resultat:= unResultat;
     Valeur:= uneValeur;

     if Editeur is TDBedit
     then
         begin
         P.X:= 0;
         P.Y:= 0;
         P:= (Editeur as TDBedit).ClientToScreen(P);
         Left:= P.x;

         Haut:= P.Y;
         Bas:= Haut+(Editeur as TDBedit).ClientHeight;
         end
     else
         if Editeur is TColumn
         then
             begin
//             P:= HautGetPos( Editeur as TColumn);
             Haut:= P.Y;
//             P:= BasGetPos( Editeur as TColumn);
             Bas:= P.Y;
             Left:= P.x;
             end
         else
             begin
             uForms_ShowMessage( 'Type non géré par l''unité ufcb.');
             Result:= False;
             exit;
             end;


     if Bas + Height > Screen.Height
     then
         begin
         Top := Haut-Height;
         Panel1.Align:= alTop;
         end
     else
         begin
         Top := Bas;
         Panel1.Align:= alBottom;
         end;
     Result:= ShowModal = mrOK;
end;

procedure TfcbBase.dbgCellClick(Column: TColumn);
begin
     Valide( Valeur);
end;

procedure TfcbBase.bNouveauClick(Sender: TObject);
begin
     if Nouveau
     then
         Valide( Valeur);
end;

procedure TfcbBase.dbgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_RETURN
     then
         dbg.OnDblClick( Sender);
end;

procedure TfcbBase.FormCreate(Sender: TObject);
begin
     inherited;
     dbg.Datasource:= nil;
end;

procedure TfcbBase.eFiltreKeyDown(Sender: TObject; var Key: Word;Shift:TShiftState);
begin
     case Key
     of
       VK_RETURN: begin dbg.SetFocus; Key:= 0;  end;
       VK_DOWN  : begin SendMessage( dbg.Handle, WM_KEYDOWN, VK_DOWN, 0); Key:= 0;  end;
       VK_UP    : begin SendMessage( dbg.Handle, WM_KEYDOWN, VK_UP  , 0); Key:= 0;  end;
       end;
end;

procedure TfcbBase.Valide( ValeurValide: TIntegerField);
begin
//     Affecte( Resultat, ValeurValide);
     ModalResult:= mrOK;
end;

end.
