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
  e: TEdit;
  Panel1: TPanel;
  vst: TVirtualStringTree;
  procedure bExecuteClick(Sender: TObject);
  procedure bGenereClick(Sender: TObject);
  procedure bGenere_ToutClick(Sender: TObject);
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
//atttributs
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
end;

procedure TfAutomatic_VST.FormDestroy(Sender: TObject);
begin
     Free_nil( sl);
end;

procedure TfAutomatic_VST.bExecuteClick(Sender: TObject);
begin
     Execute_SQL;
end;

procedure TfAutomatic_VST.Execute_SQL;
begin
     poolAutomatic.Charge( e.Text, sl);
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
  begin
       Traite_Liste( sl);
  end;
  procedure Ajoute_Lignes;
  var
     I: TIterateur;
     bl: TBatpro_Ligne;
  begin
       I:= sl.Iterateur_interne;
       while I.Continuer
       do
         begin
         if I.not_Suivant_interne( bl) then continue;
         vst.AddChild( nil, Pointer(bl));
         end;
  end;
begin
     vst.Clear;
     vst.Header.Columns.Clear;

     Cree_Colonnes;
     Ajoute_Lignes;
end;

procedure TfAutomatic_VST.vstGetText( Sender: TBaseVirtualTree;
                                      Node: PVirtualNode;
                                      Column: TColumnIndex;
                                      TextType: TVSTTextType;
                                      var CellText: String);
var
   po: ^TObject;
   bl: TBatpro_Ligne;
   vtc: TVirtualTreeColumn;
   cd: TChampDefinition;
   c: TChamp;
begin
     CellText:= '';

     if -1 = Column then exit;
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
     Tri.Execute( sl);

     _from_sl;
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

initialization

finalization
            Clean_Destroy( FfAutomatic_VST);
end.

