unit ufAutomatic_VST;

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
    uRequete,

    udmDatabase,

    uBatpro_Ligne,

    ublAutomatic,
    upoolAutomatic,

  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, VirtualTrees, ucChampsGrid;

type

 { TfAutomatic_VST }

 TfAutomatic_VST = class(TForm)
  bExecute: TButton;
  bGenere: TButton;
  bGenere_Tout: TButton;
  cbDatabases: TComboBox;
  e: TEdit;
  Panel1: TPanel;
  vst: TVirtualStringTree;
  procedure bExecuteClick(Sender: TObject);
  procedure bGenereClick(Sender: TObject);
  procedure bGenere_ToutClick(Sender: TObject);
  procedure cbDatabasesChange(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure vstColumnClick(Sender: TBaseVirtualTree; Column: TColumnIndex;
   Shift: TShiftState);
  procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
   Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
  procedure vstHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
   Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure vstHeaderDraw(Sender: TVTHeader; HeaderCanvas: TCanvas;
   Column: TVirtualTreeColumn; const R: TRect; Hover, Pressed: Boolean;
   DropMark: TVTDropMarkMode);
  procedure vstInitNode(Sender: TBaseVirtualTree; ParentNode,
   Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
//atttributs
 private
  procedure Ajoute_Lignes(_Node: PVirtualNode; _sl: TBatpro_StringList);
 public
    sl: TslAutomatic;
 //Execution du SQL
 public
   procedure Execute_SQL;
   procedure _from_sl;
 //Gestion du tri
 public
   Tri: TTri_Ancetre;
 //Gestion du filtre
 public
   Filtre: ThFiltre_Ancetre;
 end;

function fAutomatic_VST: TfAutomatic_VST;

implementation

{$R *.lfm}

{ TfAutomatic_VST }

var
   FfAutomatic_VST: TfAutomatic_VST= nil;

function fAutomatic_VST: TfAutomatic_VST;
begin
     Clean_Get( Result, FfAutomatic_VST, TfAutomatic_VST);
end;

procedure TfAutomatic_VST.FormCreate(Sender: TObject);
begin
     vst.NodeDataSize:= SizeOf( Pointer);
     vst.RootNodeCount:= 0;
     with vst.Header do Options:= Options + [hoVisible];

     sl:= TslAutomatic.Create( ClassName+'.sl');

     Tri:= nil;
     Filtre:= nil;

     Tri   := poolAutomatic.Tri;
     Filtre:= poolAutomatic.hf;

     dmDatabase.Fill_with_databases( cbDatabases.Items);
     cbDatabases.Text:= dmDatabase.sqlc.DatabaseName;
end;

procedure TfAutomatic_VST.FormDestroy(Sender: TObject);
begin
     Free_nil( sl);
end;

procedure TfAutomatic_VST.bExecuteClick(Sender: TObject);
var
   Old_Database: String;
begin
     dmDatabase.sqlc.Close;
     Old_Database:= dmDatabase.sqlc.DatabaseName;
     try
        dmDatabase.sqlc.DatabaseName:= cbDatabases.Text;
        Execute_SQL;
     finally
            dmDatabase.sqlc.DatabaseName:= Old_Database;
            end;
end;

procedure TfAutomatic_VST.Execute_SQL;
begin
     poolAutomatic.Charge( e.Text, sl);
     Tri.Vide_SousDetails;
     _from_sl;
end;

procedure TfAutomatic_VST._from_sl;
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
         vtc.Tag:= Integer(Pointer( cd));
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

procedure TfAutomatic_VST.Ajoute_Lignes( _Node: PVirtualNode; _sl: TBatpro_StringList);
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

procedure TfAutomatic_VST.vstInitNode( Sender: TBaseVirtualTree;
                                       ParentNode,
                                       Node: PVirtualNode;
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


procedure TfAutomatic_VST.vstGetText( Sender: TBaseVirtualTree;
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
   begin
        CellText:= '';
        vtc:= vst.Header.Columns[Column];
        if vtc = nil then exit;

        if Affecte_( cd, TChampDefinition, TObject( Pointer(vtc.Tag))) then exit;

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

procedure TfAutomatic_VST.vstHeaderClick( Sender: TVTHeader;
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

     _from_sl;
     vst.FullExpand();
end;

procedure TfAutomatic_VST.vstHeaderDraw(Sender: TVTHeader;
 HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; const R: TRect; Hover,
 Pressed: Boolean; DropMark: TVTDropMarkMode);
begin

end;

procedure TfAutomatic_VST.vstColumnClick( Sender: TBaseVirtualTree;
                                          Column: TColumnIndex;
                                          Shift: TShiftState);
begin

end;

procedure TfAutomatic_VST.bGenereClick(Sender: TObject);
var
   bl: TblAutomatic;
   SQL: String;
   NomTable: String;

begin
     if sl.Count = 0                               then exit;
     if Affecte_( bl, TblAutomatic, sl.Objects[0]) then exit;

     NomTable:= '';
     SQL:= e.Text;
     if 1 = Pos( 'select', SQL)
     then
         begin
         StrToK( 'from ', SQL);
         NomTable:= StrToK( ' ', SQL);
         end;

     if '' = NomTable
     then
         NomTable:= 'Nouveau';
     if not InputQuery( 'Génération de code', 'Suffixe d''identification (nom de la table)', NomTable) then exit;

     bl.Genere_code( NomTable);
end;

procedure TfAutomatic_VST.bGenere_ToutClick(Sender: TObject);
var
   sl: TStringList;
   I: Integer;
begin
     try
        sl:= TStringList.Create;
        Requete.GetTableNames( sl);
        for I:= 0 to sl.Count -1
        do
          begin
          e.Text:= 'select * from '+sl[I]+' limit 0,5';
          bExecute.Click;
          bGenere.Click;
          end;
     finally
            FreeAndNil( sl);
            end;
end;

procedure TfAutomatic_VST.cbDatabasesChange(Sender: TObject);
begin

end;

initialization

finalization
            Clean_Destroy( FfAutomatic_VST);
end.

