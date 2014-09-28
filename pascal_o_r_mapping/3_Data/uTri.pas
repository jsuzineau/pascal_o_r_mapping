unit uTri;
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
    SysUtils, Classes, DB,
    uBatpro_StringList,
    u_sys_,
    uClean,
    uChamp,
    uTri_Ancetre,
    uBatpro_Ligne;

type
 TTri
 =
  class( TTri_Ancetre)
  //Méthodes
  public
    procedure Execute( StringList: TBatpro_StringList); override;
  end;


implementation

uses DateUtils;

var
   uTri_slChampsTri: TBatpro_StringList= nil;

function uTri_StringListSortCompare( List:TStringList;
                                     Index1,
                                     Index2:Integer):Integer;
var
   bl_1, bl_2: TBatpro_Ligne;
   sCle_1, sCle_2: String;
   I: Integer;
   NomChamp: String;
   Decroissant: Boolean;
   TypeChamp: TFieldType;
   cA, cB: TChamp;
   OK: Boolean;
   procedure CompareChaines( S1, S2: String);
   begin
        Result:= CompareStr( S1, S2);
        OK:= Result <> 0;
   end;
   procedure CompareDates( D1, D2: TDateTime);
   begin
        OK:= False;
        Result:= 0;
        if D1 = D2 then exit;

        OK:= True;
        if D1 < D2
        then
            Result:= -1
        else
            Result:= 1;
   end;
   procedure CompareEntiers( I1, I2: Integer);
   begin
        OK:= False;
        Result:= 0;
        if I1 = I2 then exit;

        OK:= True;
        if I1 < I2
        then
            Result:= -1
        else
            Result:= 1;
   end;
begin
     Result:= 0;
     if uTri_slChampsTri = nil then exit;

     bl_1:= Batpro_Ligne_from_sl( List, Index1);
     bl_2:= Batpro_Ligne_from_sl( List, Index2);

     if    (bl_1 = nil)
        or (bl_2 = nil)
     then
         begin  //ce cas ne devrait pas se produire. Au cas où, on trie par chaines
         sCle_1:= List.Strings[ Index1];
         sCle_2:= List.Strings[ Index2];
         CompareChaines( sCle_1, sCle_2);
         exit;
         end;

     for I:= 0 to uTri_slChampsTri.Count-1
     do
       begin
       NomChamp:= uTri_slChampsTri.Strings[ I];
       Decroissant
       :=
         -1 = Integer(Pointer(uTri_slChampsTri.Objects[I]));

       if Decroissant
       then
           begin //on croise
           cA:= bl_2.Champs.Champ_from_Field( NomChamp);
           cB:= bl_1.Champs.Champ_from_Field( NomChamp);
           end
       else
           begin //direct
           cA:= bl_1.Champs.Champ_from_Field( NomChamp);
           cB:= bl_2.Champs.Champ_from_Field( NomChamp);
           end;

       if     Assigned( cA)
          and Assigned( cB)
       then
           begin
           TypeChamp:= cA.Definition.Typ;
           if TypeChamp = cB.Definition.Typ
           then
               begin
                    if TypeChamp in [ftDate, ftDateTime]
               then
                   CompareDates  ( PDateTime(cA.Valeur)^,
                                   PDateTime(cB.Valeur)^)
               else if TypeChamp in [ftInteger, ftSmallInt]
               then
                   CompareEntiers( PInteger(cA.Valeur)^,
                                   PInteger(cB.Valeur)^)
               else
                   CompareChaines( cA.Chaine, cB.Chaine);
               end;
           end;
       if OK then break;
       end;
end;

{ TTri }

procedure TTri.Execute( StringList: TBatpro_StringList);
begin
     if StringList = nil      then exit;
     if slChampsTri.Count = 0 then exit;
     try
        uTri_slChampsTri:= slChampsTri;

        StringList.CustomSort( uTri_StringListSortCompare);
     finally
            uTri_slChampsTri:= nil;
            end;
end;

end.
