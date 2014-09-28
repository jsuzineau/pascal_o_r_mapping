unit ucBatproDateTimePicker;
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
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, db, DBCtrls,EditBtn;

// établi en s'inspirant du code de TDBEdit de l'unité DBCtrls
type
 TBatproDateTimePicker
 =
  class(TDateEdit)
  private
    { Déclarations privées }
    Changing: Boolean;
    IsNull: Boolean;
    FDataLink: TFieldDataLink;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure UpdateData(Sender: TObject);
    (*procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;*)
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure _from_DataLink;
  protected
    { Déclarations protégées }
    procedure Change; override;
    procedure Loaded; override;
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    { Déclarations publiées }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  //Checkbox à gérer
  public
    ShowCheckbox: Boolean;
    Checked: Boolean;
  end;

procedure Register;

implementation

uses
    uClean,
    uDataUtilsU;

procedure Register;
begin
     RegisterComponents('Batpro', [TBatproDateTimePicker]);
end;

constructor TBatproDateTimePicker.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Enabled:= False;
     Changing:= False;
     IsNull:= False;
     ControlStyle := ControlStyle + [csReplicatable];
     FDataLink := TFieldDataLink.Create;
     FDataLink.Control := Self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnEditingChange := EditingChange;
     FDataLink.OnUpdateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     ShowCheckbox:= True;
end;

destructor  TBatproDateTimePicker.Destroy;
begin
     Free_nil( FDataLink);
     inherited Destroy;
end;

procedure TBatproDateTimePicker.ActiveChange(Sender: TObject);
begin

end;

procedure TBatproDateTimePicker._from_DataLink;
var
   NewValue: TDateTime;
begin
     if Changing then exit;
     try
        Changing:= True;
        Enabled:= FDataLink.Field <> nil;
        if Enabled
        then
            begin
            IsNull:= FDataLink.Field.IsNull;
            NewValue:= MySQL_DateTime( FDataLink.Field, Now);
            if Date <> NewValue
            then
                Date:= NewValue;
            Checked:= not IsNull;
            end;
     finally
            Changing:= False;
            end;
end;

procedure TBatproDateTimePicker.DataChange(Sender: TObject);
begin
     _from_DataLink;
end;

procedure TBatproDateTimePicker.WMPaint(var Message: TWMPaint);
begin
     _from_DataLink;

     inherited;
end;

procedure TBatproDateTimePicker.EditingChange(Sender: TObject);
begin
     Enabled := FDataLink.Editing;
end;

function  TBatproDateTimePicker.GetDataField: string;
begin
     Result := FDataLink.FieldName;
end;

function  TBatproDateTimePicker.GetDataSource: TDataSource;
begin
     Result := FDataLink.DataSource;
end;

function  TBatproDateTimePicker.GetField: TField;
begin
     Result := FDataLink.Field;
end;

(*function  TBatproDateTimePicker.GetReadOnly: Boolean;
begin
     Result := FDataLink.ReadOnly;
end;*)

procedure TBatproDateTimePicker.SetDataField(const Value: string);
begin
     FDataLink.FieldName := Value;
end;

procedure TBatproDateTimePicker.SetDataSource(Value: TDataSource);
begin
     if not (FDataLink.DataSourceFixed and (csLoading in ComponentState))
     then
         FDataLink.DataSource := Value;

     if Value <> nil then Value.FreeNotification(Self);
end;

(*procedure TBatproDateTimePicker.SetReadOnly(Value: Boolean);
begin
     FDataLink.ReadOnly := Value;
end;*)

procedure TBatproDateTimePicker.UpdateData(Sender: TObject);
begin
     if Checked
     then
         FDataLink.Field.AsDateTime:= Date
     else
         FDataLink.Field.Clear;
end;

procedure TBatproDateTimePicker.Change;
begin
     if not Changing
     then
         try
            Changing:= True;

            if IsNull
            then
                Date:= SysUtils.Date;
            IsNull:= False;
            FDataLink.Edit;
            FDataLink.Modified;
            FDataLink.UpdateRecord;
         finally
                Changing:= False;
                end;
     inherited Change;
end;

procedure TBatproDateTimePicker.Loaded;
begin
     inherited Loaded;
     if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TBatproDateTimePicker.Notification( AComponent:TComponent;
                                              Operation:TOperation);
begin
     inherited Notification(AComponent, Operation);
     if (Operation = opRemove) and (FDataLink <> nil) and
        (AComponent = DataSource)
     then
         DataSource := nil;
end;

(*procedure TBatproDateTimePicker.CNNotify( var Message: TWMNotify);
var
  AllowChange: Boolean;
begin
     inherited;

     with Message, NMHdr^
     do
       begin
       case code
       of
         DTN_CLOSEUP:
           begin
           end;
         DTN_DATETIMECHANGE:
           begin
           end;
         DTN_DROPDOWN:
           begin
           end;
         DTN_USERSTRING:
           begin
           with PNMDateTimeString(NMHdr)^
           do
             begin
             AllowChange:= FDataLink.Edit;
             dwFlags := Ord(not AllowChange);
             end;
           end;
         else
           inherited;
         end;
       end;
end;*)

end.

