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
    ujsDataContexte,
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

 { TjsDataContexte_CD_from_Params }

 TjsDataContexte_CD_from_Params
 =
  class( TjsDataContexte)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String);
    destructor Destroy; override;
  //SQL
  protected
    procedure SetSQL( _SQL: String); override;
    function  GetSQL: String; override;
  //Contexte BufDataset
  private
    BufDataset: TBufDataset;
  // CD_from_Params
  private
     CD_from_Params: TCD_from_Params;
  public
     procedure _from_Params( _P: TParams);
  end;

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

{ TjsDataContexte_CD_from_Params }

constructor TjsDataContexte_CD_from_Params.Create(_Name: String);
begin
     inherited Create( _Name);
     BufDataset:= TBufDataset.Create( nil);
     CD_from_Params:= TCD_from_Params.Create;
end;

destructor TjsDataContexte_CD_from_Params.Destroy;
begin
     Free_nil( CD_from_Params);
     FreeAndNil( BufDataset);
     inherited Destroy;
end;

procedure TjsDataContexte_CD_from_Params.SetSQL(_SQL: String);
begin
     raise Exception.Create( Name+': '+ClassName+': méthode SetSQL non implémentée');
end;

function TjsDataContexte_CD_from_Params.GetSQL: String;
begin
     Result:=inherited GetSQL;
     raise Exception.Create( Name+': '+ClassName+': fonction GetSQL non implémentée');
end;

procedure TjsDataContexte_CD_from_Params._from_Params(_P: TParams);
begin
     CD_from_Params.Execute( BufDataset, _P);
end;

end.
