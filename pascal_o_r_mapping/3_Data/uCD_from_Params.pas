unit uCD_from_Params;
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
    SysUtils, Classes,
    DB, BufDataset,
    uClean,
    uBatpro_StringList,
    uChamp,
    uChampDefinition,
    uChamps,
    uBatpro_Ligne;

type
 TCD_from_Params
 =
  class
  public
    function Execute(  _cd: TBufDataSet; _P: TParams): Boolean;
  private
    cd: TBufDataSet;
    cd_Name: String;
    P: TParams;
    procedure Libere;
    procedure Cree;
    procedure Remplit;
  end;

var
   CD_from_Params: TCD_from_Params = nil;

implementation

{ TCD_from_Params }

function TCD_from_Params.Execute( _cd: TBufDataSet; _P: TParams): Boolean;
begin
     cd:= _cd;
     P := _P;

     cd_Name:= cd.Name;

     Libere;

     Cree;

     Remplit;
     Result:= True;
end;

procedure TCD_from_Params.Libere;
var
   F: TField;
begin
     cd.Close;

     while cd.FieldCount > 0
     do
       begin
       F:= cd.Fields.Fields[0];
       cd.Fields.Remove( F);
       F.Free;
       end;

     cd.FieldDefs.Clear;
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     cd.ObjectView:= False;
     {$ENDIF}
end;

procedure TCD_from_Params.Cree;
var
   I: Integer;
   Param: TParam;
   FD: TFieldDef;
   F: TField;
begin
     for I:= 0 to P.Count -1
     do
       begin
       Param:= P.Items[I];
       FD:= cd.FieldDefs.AddFieldDef;
       FD.Name:= Param.Name;
       FD.DataType:= Param.DataType;
       FD.Size:= Param.Size;
       end;

     cd.CreateDataset;

     for I:= 0 to P.Count -1
     do
       begin
       Param:= P.Items[I];
       F:= cd.Fields.Fields[ I];
       F.Name:= cd_Name+ Param.Name;
       F.DisplayLabel:= Param.Name;
       F.Visible:= True;
       end;
end;

procedure TCD_from_Params.Remplit;
var
   I: Integer;
   Param: TParam;
   F: TField;
begin
     cd.Append;

     for I:= 0 to P.Count -1
     do
       begin
       Param:= P.Items[I];
       F:= cd.Fields.Fields[ I];
       F.Value:= Param.Value;
       end;

     cd.Post;
end;

initialization
              CD_from_Params:= TCD_from_Params.Create;
finalization
              Free_nil( CD_from_Params);
end.
