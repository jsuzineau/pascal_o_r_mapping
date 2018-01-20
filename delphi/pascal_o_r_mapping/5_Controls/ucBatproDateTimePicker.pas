unit ucBatproDateTimePicker;
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
  System.SysUtils, System.Classes,
  FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  Data.db, FMX.DateTimeCtrls;

// établi en s'inspirant du code de TDBEdit de l'unité DBCtrls
type
 TBatproDateTimePicker
 =
  class(TDateEdit)
  private
    { Déclarations privées }
    Changing: Boolean;
    IsNull: Boolean;
    //FDataLink: TFieldDataLink;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure _from_DataLink;
  protected
    { Déclarations protégées }
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
     {
     ControlStyle := ControlStyle + [csReplicatable];
     FDataLink := TFieldDataLink.Create;
     FDataLink.Control := Self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnEditingChange := EditingChange;
     FDataLink.OnUpdateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     }
     ShowCheckbox:= True;
end;

destructor  TBatproDateTimePicker.Destroy;
begin
     //Free_nil( FDataLink);
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
        {
        Enabled:= FDataLink.Field <> nil;
        if Enabled
        then
            begin
            IsNull:= FDataLink.Field.IsNull;
            NewValue:= MySQL_DateTime( FDataLink.Field, Now);
            if DateTime <> NewValue
            then
                DateTime:= NewValue;
            Checked:= not IsNull;
            end;
        }
     finally
            Changing:= False;
            end;
end;

procedure TBatproDateTimePicker.DataChange(Sender: TObject);
begin
     _from_DataLink;
end;

procedure TBatproDateTimePicker.EditingChange(Sender: TObject);
begin
     //Enabled := FDataLink.Editing;
end;

function  TBatproDateTimePicker.GetDataField: string;
begin
     //Result := FDataLink.FieldName;
end;

function  TBatproDateTimePicker.GetDataSource: TDataSource;
begin
     //Result := FDataLink.DataSource;
end;

function  TBatproDateTimePicker.GetField: TField;
begin
     //Result := FDataLink.Field;
end;

function  TBatproDateTimePicker.GetReadOnly: Boolean;
begin
     //Result := FDataLink.ReadOnly;
end;

procedure TBatproDateTimePicker.SetDataField(const Value: string);
begin
     //FDataLink.FieldName := Value;
end;

procedure TBatproDateTimePicker.SetDataSource(Value: TDataSource);
begin
     {
     if not (FDataLink.DataSourceFixed and (csLoading in ComponentState))
     then
         FDataLink.DataSource := Value;

     if Value <> nil then Value.FreeNotification(Self);
     }
end;

procedure TBatproDateTimePicker.SetReadOnly(Value: Boolean);
begin
     //FDataLink.ReadOnly := Value;
end;

procedure TBatproDateTimePicker.UpdateData(Sender: TObject);
begin
     {
     if Checked
     then
         FDataLink.Field.AsDateTime:= DateTime
     else
         FDataLink.Field.Clear;
     }
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
     {
     if (Operation = opRemove) and (FDataLink <> nil) and
        (AComponent = DataSource)
     then
         DataSource := nil;
     }
end;

end.

