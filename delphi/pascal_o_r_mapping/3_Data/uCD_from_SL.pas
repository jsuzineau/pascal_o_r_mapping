unit uCD_from_SL;
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
    SysUtils, Classes,
    DB, DBClient,
    uClean,
    uBatpro_StringList,
    uChamp,
    uChampDefinition,
    uChamps,
    uBatpro_Ligne;

type
 TCD_from_SL
 =
  class
  public
    function Execute(  _cd: TClientDataset; _sl: TBatpro_StringList): Boolean;
  private
    cd: TClientDataset;
    cd_Name: String;
    sl: TBatpro_StringList;
    procedure Libere;
    procedure Cree;
    procedure Remplit;
  end;

var
   CD_from_SL: TCD_from_SL = nil;

implementation

{ TCD_from_SL }

function TCD_from_SL.Execute( _cd: TClientDataset; _sl: TBatpro_StringList): Boolean;
begin
     cd:= _cd;
     sl:= _sl;

     cd_Name:= cd.Name;

     Libere;

     Cree;

     Remplit;
     Result:= True;
end;

procedure TCD_from_SL.Libere;
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
     cd.ObjectView:= False;
end;

procedure TCD_from_SL.Cree;
var
   bl: TBatpro_Ligne;
   iC: Integer;
   Champs: TChamps;
   C: TChamp;
   D: TChampDefinition;
   FD: TFieldDef;
   F: TField;
begin
     bl:= Batpro_Ligne_from_sl( sl, 0);
     if bl = nil then exit;

     Champs:= bl.Champs;
     for iC:= 0 to Champs.Count - 1
     do
       begin
       C:= Champs.Champ_from_Index( iC);
       D:= C.Definition;
       FD:= cd.FieldDefs.AddFieldDef;
       FD.Name:= D.Nom;
       FD.DataType:= D.Typ;
       FD.Size:= D.Longueur;
       end;

     cd.CreateDataset;

     for iC:= 0 to Champs.Count - 1
     do
       begin
       C:= Champs.Champ_from_Index( iC);
       D:= C.Definition;
       F:= cd.Fields.Fields[ iC];
       F.Name:= cd_Name+ D.Nom;
       F.DisplayLabel:= D.Libelle;
       F.Visible:= D.Visible;
       end;
end;

procedure TCD_from_SL.Remplit;
var
   iBL, iC: Integer;
   bl: TBatpro_Ligne;
   Champs: TChamps;
   C: TChamp;
   F: TField;
begin
     for iBL:= 0 to sl.Count - 1
     do
       begin
       bl:= Batpro_Ligne_from_sl( sl, iBL);
       if bl = nil then exit;
       Champs:= bl.Champs;

       cd.Append;

       for iC:= 0 to Champs.Count - 1
       do
         begin
         C:= Champs.Champ_from_Index( iC);
         F:= cd.Fields.Fields[ iC];
         F.Value:= C.Chaine;
         end;

       cd.Post;
       end;
end;

initialization
              CD_from_SL:= TCD_from_SL.Create;
finalization
              Free_nil( CD_from_SL);
end.
