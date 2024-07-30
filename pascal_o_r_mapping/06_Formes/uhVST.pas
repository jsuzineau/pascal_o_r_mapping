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
    uVide,
    uTri_Ancetre,
    uhFiltre_Ancetre,

    uBatpro_Element,
    uBatpro_Ligne,

  Classes, SysUtils, Controls, laz.VirtualTrees;

type

 { ThVST_Line }

 ThVST_Line
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String; _O: TObject);
    destructor Destroy; override;
  //Attributs
  public
    Nom: String;
    O: TObject;
  end;

 TIterateur_hVST_Line
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: ThVST_Line);
    function  not_Suivant( out _Resultat: ThVST_Line): Boolean;
  end;

 TslhVST_Line
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_hVST_Line;
    function Iterateur_Decroissant: TIterateur_hVST_Line;
  end;

 { ThVST }

 ThVST
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _vst: TLazVirtualStringTree;
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
    procedure vstHeaderClick( Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
  public
    vst: TLazVirtualStringTree;
    cds: array of TChampDefinition;
  //Liste des objets à afficher
  public
    sl: TBatpro_StringList;
  //Liste des descripteurs de lignes
  private
    slhVST_Line: TslhVST_Line;
    function New_Line( _Nom: String; _O: TObject): ThVST_Line;
    function Line_from_Node( _Node: PVirtualNode): ThVST_Line;
    function New_Node_from_Line( _Parent: PVirtualNode; _Line: ThVST_Line): PVirtualNode;
  //Gestion du tri
  public
    Tri: TTri_Ancetre;
  //Gestion du filtre
  public
    Filtre: ThFiltre_Ancetre;
  //_from_sl
  private
    procedure Ajoute_Ligne(_Node: PVirtualNode; _Nom: String; _o: TObject);
    procedure Ajoute_Lignes(_Node: PVirtualNode; _sl: TBatpro_StringList; _Use_S: Boolean= False);
    procedure _from_sl_interne;
  public
    procedure _from_sl;//avec vidage du tri en plus
  end;

implementation

{ ThVST_Line }

constructor ThVST_Line.Create( _Nom: String; _O: TObject);
begin
     inherited Create;

     Nom:= _Nom;
     O  := _O;
end;

destructor ThVST_Line.Destroy;
begin
     inherited Destroy;
end;

{ TIterateur_hVST_Line }

function TIterateur_hVST_Line.not_Suivant( out _Resultat: ThVST_Line): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_hVST_Line.Suivant( out _Resultat: ThVST_Line);
begin
     Suivant_interne( _Resultat);
end;

{ TslhVST_Line }

constructor TslhVST_Line.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, ThVST_Line);
end;

destructor TslhVST_Line.Destroy;
begin
     inherited;
end;

class function TslhVST_Line.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_hVST_Line;
end;

function TslhVST_Line.Iterateur: TIterateur_hVST_Line;
begin
     Result:= TIterateur_hVST_Line( Iterateur_interne);
end;

function TslhVST_Line.Iterateur_Decroissant: TIterateur_hVST_Line;
begin
     Result:= TIterateur_hVST_Line( Iterateur_interne_Decroissant);
end;

{ ThVST }

constructor ThVST.Create( _vst: TLazVirtualStringTree;
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

     slhVST_Line:= TslhVST_Line.Create( ClassName+'.slhVST_Line');
end;

destructor ThVST.Destroy;
begin
     Detruit_StringList( slhVST_Line);
     vst.OnInitNode   := nil;
     vst.OnGetText    := nil;
     vst.OnHeaderClick:= nil;
     inherited Destroy;
end;

function ThVST.New_Line( _Nom: String; _O: TObject): ThVST_Line;
begin
     Result:= ThVST_Line.Create( _Nom, _O);
     slhVST_Line.AddObject( _Nom,Result);
end;

function ThVST.New_Node_from_Line( _Parent: PVirtualNode; _Line: ThVST_Line): PVirtualNode;
begin
     Result:= vst.AddChild( _Parent, Pointer(_Line));
end;

function ThVST.Line_from_Node( _Node: PVirtualNode): ThVST_Line;
var
   po: ^TObject;
begin
     Result:= nil;
     if nil = _Node then exit;

     po:= vst.GetNodeData( _Node);
     Affecte( Result, ThVST_Line, po^);
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
       try
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
       finally
              FreeAndNil( I);
              end;
  end;
  procedure Cree_Colonnes;
  var
     vtc: TVirtualTreeColumn;
  begin
       if True//Tri.slSousDetails.Count > 0
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
     Vide_StringList( slhVST_Line);

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

procedure ThVST.Ajoute_Ligne( _Node: PVirtualNode; _Nom: String; _o: TObject);
var
   hVST_Line: ThVST_Line;
   n: PVirtualNode;
   function not_Traite_Batpro_Ligne: Boolean;
   var
      bl: TBatpro_Ligne;
      Ia: TIterateur_hAggregation;
      ha: ThAggregation;
   begin
        Result:= Affecte_( bl, TBatpro_Ligne, _o);
        if Result then exit;

        Ajoute_Lignes( n, bl.Champs.sl, True);
        Ajoute_Lignes( n, bl.Connectes, True);

        Ia:= bl.Aggregations.Iterateur;
        try
           while Ia.Continuer
           do
             begin
             if Ia.not_Suivant( ha) then continue;
             Ajoute_Ligne( n, ha.Nom, ha.sl);
             end;
        finally
               FreeAndNil( Ia);
               end;
   end;
   function not_Traite_Batpro_StringList: Boolean;
   var
      sl: TBatpro_StringList;
   begin
        Result:= Affecte_( sl, TBatpro_StringList, _o);
        if Result then exit;

        if _Nom = ''
        then
            hVST_Line.Nom:= sl.Nom;
   end;
begin
     hVST_Line:= New_Line( _Nom, _o);

     n:= New_Node_from_Line( _Node, hVST_Line);
     if nil = n then exit;

          if not_Traite_Batpro_Ligne
     then    not_Traite_Batpro_StringList;
end;

procedure ThVST.Ajoute_Lignes( _Node: PVirtualNode;
                               _sl: TBatpro_StringList;
                               _Use_S: Boolean= False);
var
   I: TIterateur;
   S: String;
   o: TObject;
begin
     I:= _sl.Iterateur_interne;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant_interne( o) then continue;

          if _Use_S
          then
              S:= I.Current_S
          else
              S:= '';
          Ajoute_Ligne( _Node, S, o);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure ThVST.vstInitNode( Sender: TBaseVirtualTree;
                             ParentNode, Node: PVirtualNode;
                             var InitialStates: TVirtualNodeInitStates);
var
   hVST_Line: ThVST_Line;
   StringList: TBatpro_StringList;
begin
     hVST_Line:= Line_from_Node( Node);
     if nil = hVST_Line then exit;

     if Affecte_( StringList, TBatpro_StringList, hVST_Line.O) then exit;

     Ajoute_Lignes( Node, StringList);
end;

procedure ThVST.vstGetText( Sender: TBaseVirtualTree;
                            Node: PVirtualNode;
                            Column: TColumnIndex;
                            TextType: TVSTTextType;
                            var CellText: String);
var
   hVST_Line: ThVST_Line;

   procedure Traite_autres_colonnes;
   var
      Column_Count: Integer;
      vtc: TVirtualTreeColumn;
      cd: TChampDefinition;
      bl: TBatpro_Ligne;
      c: TChamp;
      procedure Traite_Champ_Colonne;
      begin
           c:= bl.Champs.Champ_from_Field( cd.Nom);
           if nil = c then exit;

           CellText:= c.Chaine;
      end;
      procedure Traite_Champ_Ligne;
      begin
           case Column
           of
             0: CellText:= hVST_Line.Nom; //normalement on ne peut pas passer ici
             //1: CellText:= c.Definition.Nom;
             //2: CellText:= c.Chaine;
             1: CellText:= c.Chaine;
             else CellText:= '';
             end;
      end;
   begin
        Column_Count:= vst.Header.Columns.Count;
        if Column > Column_Count-1 then exit;
        vtc:= vst.Header.Columns[Column];
        if vtc = nil then exit;

        cd:= cds[ Column];
        if nil = cd then exit;

             if Affecte( bl, TBatpro_Ligne, hVST_Line.O) then Traite_Champ_Colonne
        else if Affecte( c , TChamp       , hVST_Line.O) then Traite_Champ_Ligne  ;

   end;
   procedure Traite_Colonne_0;
   var
      sl: TBatpro_StringList;
   begin
        CellText:= hVST_Line.Nom;
        if CellText <> '' then exit;

        if Affecte_( sl, TBatpro_StringList, hVST_Line.O) then exit;
        CellText:= sl.Nom;
   end;
begin
     CellText:= '';
     hVST_Line:= Line_from_Node( Node);
     if nil = hVST_Line  then exit;

     case Column
     of
       -1:  begin end;
        0:  Traite_Colonne_0;
       else Traite_autres_colonnes;
       end;
 end;

procedure ThVST.vstHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
var
   vtc: TVirtualTreeColumn;
   cd: TChampDefinition;
   NomChamp: String;
   NewChampTri: Integer;
begin
     if Tri = nil                then exit;
     if -1 = HitInfo.Column then exit;
     vtc:= vst.Header.Columns[HitInfo.Column];
     if vtc = nil then exit;

     cd:= cds[ HitInfo.Column];
     if nil = cd then exit;

     if not (ssShift in HitInfo.Shift) then Tri.Reset_ChampsTri;

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

