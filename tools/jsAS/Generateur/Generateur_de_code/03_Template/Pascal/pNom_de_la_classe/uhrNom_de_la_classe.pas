unit uhrNomTable;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    SysUtils, DB,
    uhRequete,
    udpObserver;

type
 ThrNomTable
 =
  class( ThRequete)
  protected
    procedure qAfterPost( DataSet: TDataSet); override;
    procedure qBeforePost( DataSet: TDataSet); override;
    procedure qAfterInsert(DataSet: TDataSet); override;
  public
     
  end;

var
   uhrNomTable_Numero: Integer;
   dpoNomTable_AfterPost: TdpObserver= nil;

implementation

{ ThrNomTable }

procedure ThrNomTable.qBeforePost(DataSet: TDataSet);
begin
     inherited;
     uhrNomTable_Numero:= q.FieldByName( 'Numero').AsInteger;
end;

procedure ThrNomTable.qAfterPost(DataSet: TDataSet);
begin
     inherited;
     dpoNomTable_AfterPost.Publish;
end;

procedure ThrNomTable.qAfterInsert( DataSet: TDataSet);
var
   I: Integer;
   F: TField;
begin
     inherited;
     for I:= 0 to q.FieldCount-1
     do
       begin
       F:= q.Fields[ I];
       if Assigned( F)
       then
           begin
           case F.DataType
           of
             ftString  : F.AsString  := '###';
             ftInteger : F.AsInteger := 0;
             ftDate    : F.AsDateTime:= 0;
             ftDateTime: F.AsDateTime:= 0;
             ftFloat   : F.AsFloat   := 0;
             end;
           end;
       end;
     q.Post;
     q.Edit;
end;

initialization
              dpoNomTable_AfterPost:= TdpObserver.Create;
finalization
              FreeAndNil( dpoNomTable_AfterPost);
end.
