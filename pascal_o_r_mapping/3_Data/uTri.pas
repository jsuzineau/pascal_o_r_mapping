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
    uContrainte,

    uTri_Ancetre,
    uBatpro_Ligne;

type

 { TTri }

 TTri
 =
  class( TTri_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    procedure Execute( _StringList: TBatpro_StringList); override;
  //Sous détails
  private
    slListes: TslBatpro_StringList;
    procedure Vide_SousDetails;
  private
    sl: TBatpro_StringList;
    iSL: Integer;
    procedure Traite_Niveau( _slDetail: TBatpro_StringList; _iChamp_Tri: Integer; _a: array of TContrainte);
  public
    procedure Execute_et_Cree_SousDetails( _StringList: TBatpro_StringList); override;
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

constructor TTri.Create;
begin
     inherited Create;
     slListes:= TslBatpro_StringList.Create( ClassName+'.slListes');
end;

destructor TTri.Destroy;
begin
     Vide_SousDetails;

     Free_nil( slListes);
     inherited Destroy;
end;

procedure TTri.Vide_SousDetails;
var
   I: TIterateur_Batpro_StringList;
   sl: TBatpro_StringList;
begin
     slSousDetails.Clear;
     I:= slListes.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( sl) then continue;
       I.Supprime_courant;
       Free_nil( sl);
       end;
end;

procedure TTri.Execute(_StringList: TBatpro_StringList);
begin
     Vide_SousDetails;

     if _StringList = nil      then exit;
     if slChampsTri.Count = 0 then exit;
     try
        uTri_slChampsTri:= slChampsTri;

        _StringList.CustomSort( uTri_StringListSortCompare);
     finally
            uTri_slChampsTri:= nil;
            end;
end;

procedure TTri.Execute_et_Cree_SousDetails( _StringList: TBatpro_StringList);
begin
     Vide_SousDetails;

     if _StringList = nil      then exit;
     if slChampsTri.Count = 0 then exit;

     Execute( _StringList);

     sl:= _StringList;
     iSL:= 0;
     Traite_Niveau( slSousDetails, -1, []);
end;

procedure TTri.Traite_Niveau( _slDetail: TBatpro_StringList;
                              _iChamp_Tri: Integer;
                              _a: array of TContrainte);
var
   Valeur_originale: String;
   Contrainte: TContrainte;
   Contraintes: array of TContrainte;
   procedure Cree_Contrainte;
   var
      bl: TBatpro_Ligne;
      NomChamp: String;
      c: TChamp;
      c_Chaine: String;
   begin
        Contrainte:= nil;
        Valeur_originale:= '';

        if -1 = _iChamp_Tri then exit;

        bl:= Batpro_Ligne_from_sl( sl, iSL);
        if nil= bl then exit;

        NomChamp:= slChampsTri.Strings[_iChamp_Tri];
        c:= bl.Champs.Champ_from_Field( NomChamp);
        if nil = c then exit;

        c_Chaine:= c.Chaine;
        Valeur_originale:= c.Definition.Libelle+': '+c_Chaine;
        Contrainte:= TContrainte.Create;
        Contrainte.Active:= True;
        Contrainte.NomChamp:= NomChamp;
        Contrainte.Operateur:= co_Egal;
        Contrainte.TypeOperande:= cto_Chaine;
        Contrainte.Critere_Chaine:= c_Chaine;
   end;
   procedure Cree_Contraintes;
   var
      i: Integer;
   begin
        SetLength( Contraintes, Length( _a)+1);
        for I:= Low(_a) to High(_a)
        do
          Contraintes[I]:= _a[I];
        Contraintes[High(Contraintes)]:= Contrainte;
   end;
   function Dernier_niveau: Boolean;
   begin
        Result:= _iChamp_Tri = slChampsTri.Count-1;
   end;
   function Iteration_terminee: Boolean;
   begin
        Result:= iSL >= sl.Count;
   end;
   function Passe_les_Contraintes: Boolean;
   var
      bl: TBatpro_Ligne;
   begin
        Result:= True;

        if -1 = _iChamp_Tri then exit;

        bl:= Batpro_Ligne_from_sl( sl, iSL);
        if nil= bl then exit;

        Result:= bl.Passe_les_Contraintes( Contraintes);
   end;
   function Niveau_Termine: Boolean;
   begin
        Result
        :=
              Iteration_terminee
          or not Passe_les_Contraintes;
   end;
   procedure Boucle_Lignes;
   var
      bl: TBatpro_Ligne;
   begin
        repeat
              bl:= Batpro_Ligne_from_sl( sl, iSL);
              Inc( iSL);

              if nil= bl then continue;
              _slDetail.AddObject( bl.sCle, bl);
        until Niveau_Termine;
   end;
   procedure Boucle_Listes;
   var
      iChamp_Tri_suivant: Integer;
      slNiveauSuivant: TslObject;
   begin
        iChamp_Tri_suivant:= _iChamp_Tri+1;
        repeat
              slNiveauSuivant:= TslObject.Create;

              slListes .AddObject( '',slNiveauSuivant);
              _slDetail.AddObject( '', slNiveauSuivant);

              Traite_Niveau( slNiveauSuivant, iChamp_Tri_suivant, Contraintes);
        until Niveau_Termine;
   end;
begin
     Contrainte:= nil;
     try
        Cree_Contrainte;

        _slDetail.Nom:= Valeur_originale;

        Cree_Contraintes;

        if Dernier_niveau
        then
            Boucle_Lignes
        else
            Boucle_Listes;
     finally
            Free_nil( Contrainte);
            end;
end;

end.
