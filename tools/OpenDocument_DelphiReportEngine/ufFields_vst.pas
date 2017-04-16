unit ufFields_vst;

{$mode delphi}

interface

uses
    uClean,
    uOD_Forms,
    uOOoChrono,
    uOOoStringList,
    uuStrings,
    uhVST_ODR,
    uOpenDocument,
  VirtualTrees, Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

 { TfFields_vst }

 TfFields_vst
 =
  class(TForm)
  published
   bChrono: TButton;
   bDupliquer: TButton;
   bExporter: TButton;
   bFermer: TButton;
   bFrom_OD: TButton;
   bImporter: TButton;
   bOuvrir: TButton;
   bSupprimer: TButton;
   bToutFermer: TButton;
   bToutOuvrir: TButton;
   gbBranche: TGroupBox;
   opendialog: TOpenDialog;
   Panel1: TPanel;
   sd: TSaveDialog;
   vst: TVirtualStringTree;
    procedure bChronoClick(Sender: TObject);
    procedure bDupliquerClick(Sender: TObject);
    procedure bExporterClick(Sender: TObject);
    procedure bFermerClick(Sender: TObject);
    procedure bFrom_ODClick(Sender: TObject);
    procedure bImporterClick(Sender: TObject);
    procedure bOuvrirClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bToutFermerClick(Sender: TObject);
    procedure bToutOuvrirClick(Sender: TObject);
    procedure vstEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
  //Gestion du cycle de vie
  public
    constructor Create( _Caption: String; _od: TOpenDocument); reintroduce;
    destructor Destroy; override;
  //od
  protected
    od: TOpenDocument;
  public
    procedure _from_od; virtual;
  //sl
  public
    sl: TOOoStringList;
  //hvst
  public
    hvst: ThVST_ODR;
  //Visiteurs des Fields du Document
  public
    procedure Document_Fields_Visitor_for_tv( _Name, _Value: String); virtual;
  //Méthodes
  public
    procedure Ajoute_Valeur_dans_tv( sKey, sValue: String);
    procedure Exporte_Sous_branche(tn: PVirtualNode; Source: String; sl: TOOoStringList);
    procedure Supprime_Sous_branche( tn: PVirtualNode; Selection: String);
    procedure Copie_Sous_branche( tn: PVirtualNode; Source, Cible: String);
  //Optimisation de l'arborescence
  private
    procedure Optimise( _vst: TVirtualStringTree;
                        _hvst: ThVST_ODR;
                        _sl: TOOoStringList);
  //Log des suppressions
  public
    slSuppressions: TOOoStringList;
  end;

implementation

{$R *.lfm}

{ TfFields_vst }

constructor TfFields_vst.Create( _Caption: String; _od: TOpenDocument);
begin
     inherited Create( nil);

     Caption:= _Caption;
     od:= _od;

     sl:= TOOoStringList.Create;
     sl.Sorted:= True;

     slSuppressions:= TOOoStringList.Create;

     hvst := ThVST_ODR.Create( vst);

     _from_od;
end;

destructor TfFields_vst.Destroy;
begin
     FreeAndNil( hvst );
     FreeAndNil( sl   );
     FreeAndNil( slSuppressions);

     inherited Destroy;
end;

procedure TfFields_vst._from_od;
begin
     vst .Clear; sl .Clear;
     od.Fields_Visite( Document_Fields_Visitor_for_tv);
     Optimise( vst, hvst, sl);
     vst.FullCollapse;
     slSuppressions.Clear;
end;

procedure TfFields_vst.Document_Fields_Visitor_for_tv(_Name, _Value: String);
begin
end;

procedure TfFields_vst.Ajoute_Valeur_dans_tv(sKey, sValue: String);
var
   sTreePath: String;
   procedure Recursif( Racine: String; Parent: PVirtualNode);
   var
      s, sCle: String;
      i: Integer;
      LsTreePath: Integer;
      sTreePath_has_final_underscore: Boolean;
   begin
        LsTreePath:= Length( sTreePath);
        if LsTreePath = 0
        then
            sTreePath_has_final_underscore:= False
        else
            sTreePath_has_final_underscore:= sTreePath[ LsTreePath] = '_';
        s:= StrTok( '_', sTreePath);
        if      sTreePath_has_final_underscore
           and (sTreePath = '')
        then
            s:= s+'_';

        sCle:= Racine+'_'+s;
        i:= sl.IndexOf( sCle);
        if i = -1
        then
            begin
            if sTreePath = ''
            then
                Parent:= hvst.Ajoute_Ligne_( Parent, s, sValue)
            else
                Parent:= hvst.Ajoute_Intermediaire( Parent, s);

            sl.AddObject( sCle, TObject(Parent));
            end
        else
            Parent:= PVirtualNode( sl.Objects[i]);

        if sTreePath = ''
        then //cas terminal
            begin
            end
        else
            Recursif( sCle, Parent);
   end;
begin
     sTreePath:= sKey;
     Recursif( '', nil);
end;

procedure TfFields_vst.vstEditing( Sender: TBaseVirtualTree;
                                   Node: PVirtualNode;
                                   Column: TColumnIndex;
                                   var Allowed: Boolean);
var
   I: Integer;
   sKey, sValue: String;
   OldTitre: String;
begin
     Allowed:= False;

     I:= sl.IndexOfObject( TObject(Node));
     if i = -1 then exit;

     sKey:= sl.Strings[ I];
     Delete( sKey, 1, 1);

     sValue:= od.Field_Value( sKey);
     OldTitre:= hvst.Key_from_Node( Node);

     if InputQuery( 'Modification', OldTitre, sValue)
     then
         begin
         od.Set_Field( sKey, sValue);
         hvst.Node_set_Key( Node, sValue);
         od.pChange.Publie;
         end;
end;

procedure TfFields_vst.Exporte_Sous_branche( tn: PVirtualNode;
                                             Source: String;
                                             sl: TOOoStringList);
var
   Child: PVirtualNode;
   _Name: String;
   Child_Source: String;
begin
     Child:= vst.GetFirstChild(tn);
     while Assigned( Child)
     do
       begin
       _Name:= '_'+hvst.Key_from_Node( Child);
       Child_Source:= Source + _Name;
       if hvst.HasValue( Child)
       then
           sl.Values[Child_Source]:= od.Field_Value( Child_Source);

       Exporte_Sous_branche( Child, Child_Source, sl);

       Child:= Child.NextSibling;
       end;
end;

procedure TfFields_vst.Supprime_Sous_branche( tn: PVirtualNode; Selection: String);
var
   Child, Trash: PVirtualNode;
   _Name: String;
   procedure Supprime_Champ( Champ: String);
   begin
        slSuppressions.Add( Champ);
        od.DetruitChamp( Champ);
   end;
begin
     Child:= vst.GetFirstChild(tn);
     while Assigned( Child)
     do
       begin
       _Name:= Selection+'_'+hvst.Key_from_Node( Child);

       Supprime_Sous_branche( Child, _Name);

       Trash:= Child;
       Child:= Child.NextSibling;
       vst.DeleteNode( Trash);
       end;

     Supprime_Champ( Selection);
end;

procedure TfFields_vst.Copie_Sous_branche( tn: PVirtualNode; Source, Cible: String);
var
   Child: PVirtualNode;
   _Name: String;
   Child_Source,
   Child_Cible : String;
begin
     Child:= vst.GetFirstChild( tn);

     while Assigned( Child)
     do
       begin
       _Name:= '_'+hvst.Key_from_Node( Child);
       Child_Source:= Source + _Name;
       Child_Cible := Cible  + _Name;
       if hvst.HasValue( Child)
       then
           od.Set_Field( Child_Cible, od.Field_Value( Child_Source));

       Copie_Sous_branche( Child, Child_Source, Child_Cible);

       Child:= Child.NextSibling;
       end;
end;

procedure TfFields_vst.bExporterClick(Sender: TObject);
var
   tn: PVirtualNode;
   Source: String;
   slExport: TOOoStringList;
begin
     tn:= vst.GetFirstSelected();
     if tn = nil then exit;

     slExport:= TOOoStringList.Create;
     try
        Source:= hvst.Cle_from_Node( tn);
        if hvst.HasValue( tn)
        then
            slExport.Values[Source]:= od.Field_Value( Source);
        Exporte_Sous_branche( tn, Source, slExport);

        if sd.Execute
        then
            slExport.SaveToFile( sd.FileName);
     finally
            FreeAndNil( slExport);
            end;
end;

procedure TfFields_vst.bFrom_ODClick(Sender: TObject);
begin
     _from_od;
end;

procedure TfFields_vst.bImporterClick(Sender: TObject);
var
   sl: TOOoStringList;
   I: Integer;
   Source: String;
begin
     sl:= TOOoStringList.Create;
     try
        if opendialog.Execute
        then
            sl.LoadFromFile( opendialog.FileName);
        for I:= 0 to sl.Count - 1
        do
          begin
          Source:= sl.Names[ I];
          od.Set_Field( Source, sl.Values[ Source]);
          end;
     finally
            FreeAndNil( sl);
            end;
     _from_od;
     od.pChange.Publie;
end;

procedure TfFields_vst.bOuvrirClick(Sender: TObject);
var
   tn: PVirtualNode;
begin
     tn:= vst.GetFirstSelected();
     if tn = nil then exit;

     vst.Expanded[tn]:= True;
end;

procedure TfFields_vst.bFermerClick(Sender: TObject);
var
   tn: PVirtualNode;
begin
     tn:= vst.GetFirstSelected();
     if tn = nil then exit;

     vst.Expanded[tn]:= False;
end;

procedure TfFields_vst.bDupliquerClick(Sender: TObject);
var
   tn: PVirtualNode;
   Source, Cible: String;
begin
     tn:= vst.GetFirstSelected;
     if tn = nil then exit;

     Source:= hvst.Cle_from_Node( tn);
     Cible:= Source+'_Copie';

     if InputQuery( 'Duplication', 'Nouvelle clé pour Open Office', Cible)
     then
         begin
         if hvst.HasValue( tn)
         then
             od.Set_Field( Cible, od.Field_Value( Source));
         Copie_Sous_branche( tn, Source, Cible);
         _from_od;
         od.pChange.Publie;
         end;
end;

procedure TfFields_vst.bChronoClick(Sender: TObject);
begin
     uOD_Forms_ShowMessage( OOoChrono.Get_Liste);
end;

procedure TfFields_vst.bSupprimerClick(Sender: TObject);
var
   tn: PVirtualNode;
   Selection: String;
begin
     tn:= vst.GetFirstSelected;
     if tn = nil then exit;

     Selection:= hvst.Cle_from_Node( tn);

     Supprime_Sous_branche( tn, Selection);
     vst.DeleteNode( tn);
     od.pChange.Publie;
end;

procedure TfFields_vst.bToutFermerClick(Sender: TObject);
begin
     vst.FullExpand;
end;

procedure TfFields_vst.bToutOuvrirClick(Sender: TObject);
begin
     vst.FullCollapse;
end;
procedure TfFields_vst.Optimise( _vst: TVirtualStringTree;
                                 _hvst: ThVST_ODR;
                                 _sl: TOOoStringList);
var
   TreeNode: PVirtualNode;
     procedure T( _Root: PVirtualNode);
     var
        Cle_Root: String;
        iRoot: Integer;
        tv_root_node: PVirtualNode;
        ok_singlechild: Boolean;
        Root_Line: ThVST_ODR_Ligne;
        tv_root_node_Line: ThVST_ODR_Ligne;
        procedure Move_Child( _Parent: PVirtualNode);
        var
           tn, fish: PVirtualNode;
        begin
             tn:= _vst.GetFirstChild( _Parent);
             while Assigned( tn)
             do
               begin
               fish:= tn.NextSibling;
               _vst.MoveTo( tn, _Root, amAddChildLast, False);
               tn:= fish;
               end;
        end;
        procedure Traite_SingleChild;
        var
           iRoot: Integer;

           SingleChild: PVirtualNode;
           SingleChild_Line: ThVST_ODR_Ligne;
           Root_Line: ThVST_ODR_Ligne;
           iSingleChild: Integer;
           S: String;
        begin
             SingleChild:= _vst.GetFirstChild( _Root);

             Move_Child( SingleChild);

             SingleChild_Line:= _hvst.Line_from_Node( SingleChild);
             Root_Line:= _hvst.Line_from_Node( _Root);

             with Root_Line do Key:= Key + '_' + SingleChild_Line.Key;

             iRoot:= _sl.IndexOfObject( TObject( _Root));
             if iRoot <> -1
             then
                 begin
                 S:= _sl[iRoot];
                 _sl[iRoot]:= S+'_'+SingleChild_Line.Key;
                 end;

             iSingleChild:= _sl.IndexOfObject( TObject(SingleChild));
             if iSingleChild <> -1 then _sl.Delete( iSingleChild);

             _vst.DeleteNode( SingleChild);
        end;
        procedure Recursive;
        var
           tn: PVirtualNode;
        begin
             tn:= _vst.getFirstChild( _Root);
             while Assigned( tn)
             do
               begin
               T( tn);
               tn:= tn.NextSibling;
               end;
        end;
     begin
          if _Root = nil then exit;
          Root_Line:= _hvst.Line_from_Node( _Root);
          if Root_Line = nil then exit;

          ok_singlechild:= not Root_Line.IsLeaf;
          if ok_singlechild
          then
              begin
              Cle_Root:= _hvst.Cle_from_Node( _Root);
              iRoot:= _sl.IndexOf( '_'+Cle_Root);
              ok_singlechild:= iRoot <> -1;
              if ok_singlechild
              then
                  begin
                  tv_root_node:= PVirtualNode( _sl.Objects[iRoot]);
                  ok_singlechild
                  :=
                        tv_root_node <> nil;
                  if ok_singlechild
                  then
                      begin
                      tv_root_node_Line:= _hvst.Line_from_Node( tv_root_node);
                      ok_singlechild:= Assigned( tv_root_node_Line);
                      if ok_singlechild
                      then
                          ok_singlechild:= not tv_root_node_Line.IsLeaf;
                      end;
                  end;
              end;


          if ok_singlechild
          then
              while _vst.ChildCount[_Root] = 1
              do
                Traite_SingleChild;

          if _vst.ChildCount[_Root] > 0
          then
              Recursive;
     end;
begin
     TreeNode:= _vst.GetFirst();
     while TreeNode <> nil
     do
       begin
       if TreeNode.Parent =  nil
       then
           T( TreeNode);
       TreeNode:= TreeNode.NextSibling;
       end;
end;

end.

