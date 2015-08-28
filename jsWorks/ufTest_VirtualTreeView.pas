unit ufTest_VirtualTreeView;

{$mode delphi}

interface

uses
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    ublTag,
    upoolTag,

    ublWork,
    upoolWork,

 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 VirtualTrees;

type
 { TfTest_VirtualTreeView }

 TfTest_VirtualTreeView = class(TForm)
  Panel1: TPanel;
  vst: TVirtualStringTree;
  procedure FormCreate(Sender: TObject);
  procedure vstBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
   Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode;
   CellRect: TRect; var ContentRect: TRect);
  procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
   Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
  procedure vstInitNode(Sender: TBaseVirtualTree; ParentNode,
   Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
 //Premier
 private
  Premier: Boolean;
   procedure Traite_Premier;
 end;

var
 fTest_VirtualTreeView: TfTest_VirtualTreeView;

implementation

{$R *.lfm}

{ TfTest_VirtualTreeView }

procedure TfTest_VirtualTreeView.FormCreate(Sender: TObject);
begin
     vst.NodeDataSize:= SizeOf( Pointer);
     vst.RootNodeCount:= 1;
     with vst.Header do Options:= Options + [hoVisible];

     Premier:= True;
end;

procedure TfTest_VirtualTreeView.Traite_Premier;
var
   slColonnes: TBatpro_StringList;
   procedure Traite_Liste( _sl: TBatpro_StringList);
   var
      bl: TBatpro_Ligne;
      I: TIterateur_Champ;
      c: TChamp;
      cd: TChampDefinition;
      Nom: String;
      vtc: TVirtualTreeColumn;
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
          if -1 <> slColonnes.IndexOf( Nom) then continue;

          vtc:= vst.Header.Columns.Add;
          vtc.Text:= Nom;
          vtc.DisplayName:= cd.Libelle;
          slColonnes.Add( Nom);
          end;
   end;
begin
     if not Premier then exit;

     Premier:= False;

     vst.Header.Columns.Add;//colonne pour l'arborescence

     slColonnes:= TBatpro_StringList.Create;
     try
        poolWork.ToutCharger;
        Traite_Liste( poolWork.slT);

        poolTag.ToutCharger; //pas propre, un peu lourd
        Traite_Liste( poolTag.slT);
     finally
            FreeAndNil( slColonnes);
     end;
end;

procedure TfTest_VirtualTreeView.vstInitNode( Sender: TBaseVirtualTree;
                                              ParentNode,
                                              Node: PVirtualNode;
                                              var InitialStates: TVirtualNodeInitStates);
   procedure Traite_Work;
   var
      I: TIterateur;
      bl: TBatpro_Ligne;
   begin
        I:= poolWork.slT.Iterateur_interne;
        while I.Continuer
        do
          begin
          if I.not_Suivant_interne( bl) then continue;

          vst.AddChild( Node, Pointer(bl));
          end;
   end;
   procedure Traite_ha;
   var
      pbl: ^TblWork;
      bl: TblWork;
      procedure Traite_ha_interne( _ha: ThAggregation);
      var
         n: PVirtualNode;
         I: TIterateur;
         bl: TBatpro_Ligne;
      begin
           _ha.Charge;
           if 0 = _ha.Count then exit;
           n:= vst.AddChild( Node, Pointer(_ha));
           I:= _ha.Iterateur_interne;
           while I.Continuer
           do
             begin
             if I.not_Suivant_interne( bl) then continue;

             vst.AddChild( n, Pointer(bl));
             end;
      end;
   begin
        pbl:= vst.GetNodeData( Node);
        if Affecte_( bl, TblWork, pbl^) then exit;

        Traite_ha_interne( bl.haTag);
        Traite_ha_interne( bl.haTag_from_Description);
   end;
begin
     Traite_Premier;

     if Node = nil        then exit;

     if ParentNode = nil
     then
         Traite_Work
     else
         Traite_ha;
end;

procedure TfTest_VirtualTreeView.vstGetText( Sender: TBaseVirtualTree;
                                             Node: PVirtualNode;
                                             Column: TColumnIndex;
                                             TextType: TVSTTextType;
                                             var CellText: String);
var
   po: ^TObject;
   bl: TBatpro_Ligne;
   ha: ThAggregation;
   procedure Traite_bl;
   var
      vtc: TVirtualTreeColumn;
      c: TChamp;
   begin
        CellText:= '';
        if -1 = Column then exit;

        vtc:= vst.Header.Columns[Column];
        if vtc = nil then exit;

        c:= bl.Champs.Champ_from_Field( vtc.Text);
        if nil = c then exit;

        CellText:= c.Chaine;
   end;
   procedure Traite_ha;
   begin
        if -1 = Column then exit;

        if Column < 1
        then
            CellText:= ha.Nom
        else
            CellText:= '';
   end;
   procedure Traite_Racine;
   begin
        if Column < 1
        then
            CellText:= 'Racine'
        else
            CellText:= '';
   end;
begin
     if nil = Node then exit;

     po:= vst.GetNodeData( Node);
          if Affecte( bl, TBatpro_Ligne, po^) then Traite_bl
     else if Affecte( ha, ThAggregation, po^) then Traite_ha
     else                                          Traite_Racine;
end;

procedure TfTest_VirtualTreeView.vstBeforeCellPaint( Sender: TBaseVirtualTree;
                                                     TargetCanvas: TCanvas;
                                                     Node: PVirtualNode;
                                                     Column: TColumnIndex;
                                                     CellPaintMode: TVTCellPaintMode;
                                                     CellRect: TRect;
                                                     var ContentRect: TRect);
var
   po: ^TObject;
   bl: TBatpro_Ligne;
   ha: ThAggregation;
   procedure Traite_bl;
   var
      blWork: TblWork;
      blTag: TblTag;
   begin
             if Affecte( blWork, TblWork, bl) then TargetCanvas.Brush.Color := $8080FF
        else if Affecte( blTag , TblTag , bl) then TargetCanvas.Brush.Color := $80FFFF
        else                                       TargetCanvas.Brush.Color := clCream
   end;
begin
     if nil = Node then exit;

     po:= vst.GetNodeData( Node);
          if Affecte( bl, TBatpro_Ligne, po^) then Traite_bl
     else if Affecte( ha, ThAggregation, po^) then TargetCanvas.Brush.Color := clLime
     else                                          TargetCanvas.Brush.Color := clAqua;

     TargetCanvas.FillRect(CellRect);
end;

end.

