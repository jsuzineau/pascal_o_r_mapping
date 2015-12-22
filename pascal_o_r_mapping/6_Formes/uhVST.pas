unit uhVST;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uBatpro_StringList,
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
    uuStrings,
    uTri_Ancetre,
    uhFiltre_Ancetre,

    uBatpro_Ligne,

  Classes, SysUtils, Controls, VirtualTrees;

type
 { ThVST }

 ThVST
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _vst: TVirtualStringTree;
                        _sl : TBatpro_StringList;
                        _Tri   : TTri_Ancetre     = nil;
                        _Filtre: ThFiltre_Ancetre = nil);
    destructor Destroy; override;
  //vst
  private
    procedure vstInitNode( Sender: TBaseVirtualTree;
                           ParentNode, Node: PVirtualNode;
                           var InitialStates: TVirtualNodeInitStates);
    procedure vstGetText( Sender: TBaseVirtualTree;
                          Node: PVirtualNode;
                          Column: TColumnIndex;
                          TextType: TVSTTextType;
                          var CellText: String);
    procedure vstHeaderClick( Sender: TVTHeader;
                              Column: TColumnIndex;
                              Button: TMouseButton;
                              Shift: TShiftState;
                              X, Y: Integer);
  public
    vst: TVirtualStringTree;
    cds: array of TChampDefinition;
  //Liste de lignes
  public
    sl: TBatpro_StringList;
  //Gestion du tri
  public
    Tri: TTri_Ancetre;
  //Gestion du filtre
  public
    Filtre: ThFiltre_Ancetre;
  //_from_sl
  private
    procedure Ajoute_Lignes(_Node: PVirtualNode; _sl: TBatpro_StringList);
    procedure _from_sl_interne;
  public
    procedure _from_sl;//avec vidage du tri en plus
  end;

implementation

{ ThVST }

constructor ThVST.Create( _vst: TVirtualStringTree;
                          _sl : TBatpro_StringList;
                          _Tri   : TTri_Ancetre    = nil;
                          _Filtre: ThFiltre_Ancetre= nil);
begin
     vst:= _vst;
     sl := _sl;

     vst.NodeDataSize:= SizeOf( Pointer);
     vst.RootNodeCount:= 0;
     with vst.Header do Options:= Options + [hoVisible];

     vst.OnInitNode   := vstInitNode;
     vst.OnGetText    := vstGetText;
     vst.OnHeaderClick:= vstHeaderClick;

     Tri    := _Tri;
     Filtre:= _Filtre;
end;

destructor ThVST.Destroy;
begin
     vst.OnInitNode   := nil;
     vst.OnGetText    := nil;
     vst.OnHeaderClick:= nil;
     inherited Destroy;
end;

procedure ThVST._from_sl_interne;
  procedure Traite_Liste( _sl: TBatpro_StringList);
  var
     bl: TBatpro_Ligne;
     I: TIterateur_Champ;
     c: TChamp;
     cd: TChampDefinition;
     Nom: String;
     vtc: TVirtualTreeColumn;
     sTri: String;
  begin
       bl:= Batpro_Ligne_from_sl( _sl, 0);
       if nil = bl then exit;

       SetLength( cds,
                   vst.Header.Columns.Count //éventuelle colonne d'arborescence
                  +bl.Champs.sl      .Count // 1 colonne par champ
                  );
       if vst.Header.Columns.Count > 0
       then
           cds[0]:= nil;

       I:= bl.Champs.sl.Iterateur;
       while I.Continuer
       do
         begin
         if I.not_Suivant( c) then continue;

         cd:= c.Definition;
         Nom:= cd.Nom;
         //if -1 <> slColonnes.IndexOf( Nom) then continue;

         if Tri = nil
         then
             sTri:= sys_Vide
         else
             case Tri.ChampTri[ Nom]
             of
               -1:  sTri:= ' \';
                0:  sTri:= sys_Vide;
               +1:  sTri:= ' /';
               else sTri:= sys_Vide;
               end;

         vtc:= vst.Header.Columns.Add;
         vtc.Text:= cd.Libelle + sTri;
         vtc.MinWidth:= cd.Longueur*10;
         cds[vtc.Index]:= cd;

         //slColonnes.Add( Nom);
         end;
  end;
  procedure Cree_Colonnes;
  var
     vtc: TVirtualTreeColumn;
  begin
       if Tri.slSousDetails.Count > 0
       then
           begin
           vtc:= vst.Header.Columns.Add;
           vtc.Text:= '';
           vtc.MinWidth:= 100;
           end;
       Traite_Liste( sl);
  end;
begin
     vst.Clear;
     vst.Header.Columns.Clear;

     Cree_Colonnes;
     if Tri.slSousDetails.Count > 0
     then
         Ajoute_Lignes( nil, Tri.slSousDetails)
     else
         Ajoute_Lignes( nil, sl);
end;

procedure ThVST._from_sl;
begin
     Tri.Vide_SousDetails;
     _from_sl_interne;
end;

procedure ThVST.Ajoute_Lignes(_Node: PVirtualNode; _sl: TBatpro_StringList);
var
   I: TIterateur;
   o: TObject;
begin
     I:= _sl.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( o) then continue;
       vst.AddChild( _Node, Pointer(o));
       end;
end;

procedure ThVST.vstInitNode( Sender: TBaseVirtualTree;
                             ParentNode, Node: PVirtualNode;
                             var InitialStates: TVirtualNodeInitStates);
var
   po: ^TObject;
   StringList: TBatpro_StringList;
begin
     if nil = Node then exit;

     po:= vst.GetNodeData( Node);
     if Affecte_( StringList, TBatpro_StringList, po^) then exit;

     Ajoute_Lignes( Node, StringList);
end;

procedure ThVST.vstGetText( Sender: TBaseVirtualTree;
                            Node: PVirtualNode;
                            Column: TColumnIndex;
                            TextType: TVSTTextType;
                            var CellText: String);
  procedure Traite_Donnees;
  var
     po: ^TObject;
     bl: TBatpro_Ligne;
     vtc: TVirtualTreeColumn;
     cd: TChampDefinition;
     c: TChamp;
     Column_Count: Integer;
  begin
       CellText:= '';
       Column_Count:= vst.Header.Columns.Count;
       if Column > Column_Count-1 then exit;
       vtc:= vst.Header.Columns[Column];
       if vtc = nil then exit;

       cd:= cds[ Column];
       if nil = cd then exit;

       if nil = Node  then exit;
       po:= vst.GetNodeData( Node);

       if Affecte_( bl, TBatpro_Ligne, po^) then exit;

       c:= bl.Champs.Champ_from_Field( cd.Nom);
       if nil = c then exit;

       CellText:= c.Chaine;
  end;
  procedure Traite_Liste;
  var
     po: ^TObject;
     sl: TBatpro_StringList;
  begin
       CellText:= '';

       if nil = Node  then exit;
       po:= vst.GetNodeData( Node);

       if Affecte_( sl, TBatpro_StringList, po^) then exit;

       CellText:= sl.Nom;
  end;
begin
     case Column
    of
      -1:  CellText:= '';
       0:  Traite_Liste;
      else Traite_Donnees;
    end;
end;

procedure ThVST.vstHeaderClick( Sender: TVTHeader;
                                Column: TColumnIndex;
                                Button: TMouseButton;
                                Shift: TShiftState;
                                X, Y: Integer);
var
   vtc: TVirtualTreeColumn;
   cd: TChampDefinition;
   NomChamp: String;
   NewChampTri: Integer;
begin
     if Tri = nil                then exit;
     if -1 = Column then exit;
     vtc:= vst.Header.Columns[Column];
     if vtc = nil then exit;

     if Affecte_( cd, TChampDefinition, TObject( Pointer(vtc.Tag))) then exit;

     if not (ssShift in Shift) then Tri.Reset_ChampsTri;

     NomChamp:= cd.Nom;
     case Tri.ChampTri[ NomChamp]
     of
       -1:  NewChampTri:=  0;
        0:  NewChampTri:= +1;
       +1:  NewChampTri:= -1;
       else NewChampTri:=  0;
       end;
     Tri.ChampTri[ NomChamp]:= NewChampTri;
     Tri.Execute_et_Cree_SousDetails( sl);

     _from_sl_interne;
     vst.FullExpand();
end;

end.

