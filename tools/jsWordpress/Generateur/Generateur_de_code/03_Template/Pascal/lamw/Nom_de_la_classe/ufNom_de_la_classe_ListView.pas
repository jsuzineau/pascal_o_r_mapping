unit ufNom_de_la_classe_ListView;

{$mode delphi}

interface

uses
  uuStrings,
  uForms,
  uOptions,

  ujsDataContexte,
  uSGBD,
  uSQLite_Android,
  uLog,
  uAndroid_Database,
  uChamps,
  ublNom_de_la_classe,

  udmDatabase,
  upool,
  upoolNom_de_la_classe,

  uRequete,

  ufNom_de_la_classe,
  ufOptions,
  ufAccueil_Erreur,
  ufUtilitaires, uchChamp_Edit,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, imagebutton,
  preferences, modaldialog, sharefile, customdialog;
  
type

  { TfNom_de_la_classe_ListView }

 TfNom_de_la_classe_ListView
 =
  class(jForm)
    bID: jButton;
    bTitre: jButton;
    bNouveau: jButton;
    cdNouveau: jCustomDialog;
    eTitre: jEditText;
    bNouveau_OK: jButton;
    bNouveau_Cancel: jButton;
    ivOptions: jImageView;
    jPanel3: jPanel;
    lv: jListView;
    pHaut: jPanel;
    Panel2: jPanel;
    pBas: jPanel;
    pf: jPreferences;
    sqlc: jSqliteCursor;
    sqlda: jSqliteDataAccess;
    tvTri: jTextView;
    procedure bIDClick(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bNouveau_CancelClick(Sender: TObject);
    procedure bNouveau_OKClick(Sender: TObject);
    procedure bTitreClick(Sender: TObject);
    procedure fNom_de_la_classe_ListViewJNIPrompt(Sender: TObject);
    procedure ivOptionsClick(Sender: TObject);
    procedure lvClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    NbNom_de_la_classe_ListView: Integer;
    FfNom_de_la_classe: TfNom_de_la_classe;
    FfOptions: TfOptions;
    procedure LogP( _Message_Developpeur: String; _Message: String = '');
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Gestion de l'affichage
  public
    procedure _from_sl;
    procedure Affiche( _Index: Integer);
  end;

var
  fNom_de_la_classe_ListView: TfNom_de_la_classe_ListView;

  
implementation
  
  
{$R *.lfm}
  

  
{ TfNom_de_la_classe_ListView }

constructor TfNom_de_la_classe_ListView.Create(AOwner: TComponent);
begin
     Filename:= 'jsNote.sqlite';
     FfNom_de_la_classe:= nil;
     FfOptions:= nil;
     inherited Create(AOwner);
end;

destructor TfNom_de_la_classe_ListView.Destroy;
begin
     inherited Destroy;
end;

procedure TfNom_de_la_classe_ListView.fNom_de_la_classe_ListViewJNIPrompt(Sender: TObject);
begin
     WriteLn( Classname+'.fNom_de_la_classe_ListViewJNIPrompt: début');
     sqlda.DataBaseName:= Filename;
     uSQLite_Android_jForm:= Self;
     uSQLite_Android_sda  := sqlda;
     uSQLite_Android_sc   := sqlc;
     fAccueil_log_procedure:= LogP;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     uOptions.pf:= pf;
     Options_Restore;
     WriteLn( Classname+'.fNom_de_la_classe_ListViewJNIPrompt: DatabasesDir='+DatabasesDir);
     if '' = DatabasesDir
     then
         uAndroid_Database_Traite_Environment( Self);

     if nil = dmDatabase.jsDataConnexion
     then
         begin
         SGBD_Set( sgbd_SQLite_Android);

         dmDatabase.Initialise;
         end;
     dmDatabase.jsDataConnexion.DataBase:= Filename;
     if 0 = poolNom_de_la_classe.slFiltre.Count
     then
         begin
         WriteLn( Classname+'.fNom_de_la_classe_ListViewJNIPrompt: 1: poolNom_de_la_classe.ToutCharger;');
         poolNom_de_la_classe.ToutCharger;
         if 0 = poolNom_de_la_classe.slFiltre.Count
         then
             begin
             uAndroid_Database_from_Assets( Self, FileName, FileName);
             WriteLn( Classname+'.fNom_de_la_classe_ListViewJNIPrompt: 2: poolNom_de_la_classe.ToutCharger;');
             poolNom_de_la_classe.ToutCharger;
             end;

         //workaround, sinon on obtient la base d'origine des assets au premier chargement
         poolNom_de_la_classe.Vide;
         poolNom_de_la_classe.ToutCharger;
         end;
     pBas.Visible:= uOptions.Editable;
     _from_sl;
end;

procedure TfNom_de_la_classe_ListView.bIDClick(Sender: TObject);
begin
     bID   .Text:= '#^';
     bTitre.Text:= 'A .. Z';
     poolNom_de_la_classe.Reset_ChampsTri;
     poolNom_de_la_classe.hf.Execute;
     _from_sl;
end;

procedure TfNom_de_la_classe_ListView.bTitreClick(Sender: TObject);
begin
     bID   .Text:= '#';
     bTitre.Text:= 'A .. Z ^';
     poolNom_de_la_classe.Reset_ChampsTri;
     poolNom_de_la_classe.ChampTri['Titre']:= +1;;
     poolNom_de_la_classe.TrierFiltre;
     _from_sl;
end;

procedure TfNom_de_la_classe_ListView.ivOptionsClick(Sender: TObject);
begin
     WriteLn( Classname+'.bOptionsClick: début');
     poolNom_de_la_classe.Vide;
     WriteLn( Classname+'.bOptionsClick: aprés poolNom_de_la_classe.Vide;');
     if nil = FfOptions
     then
         begin
         WriteLn( Classname+'.bOptionsClick: FfOptions = nil, CreateForm');
         gApp.CreateForm( TfOptions, FfOptions);
         if Assigned( FfOptions)
         then
             begin
             WriteLn( Classname+'.bOptionsClick: FfOptions assigned, InitShowing');
             FfOptions.InitShowing;
             end;
         end
     else
         begin
         WriteLn( Classname+'.bOptionsClick: FfOptions already assigned, Show');
         FfOptions.Show;
         end;
end;

procedure TfNom_de_la_classe_ListView.bNouveauClick(Sender: TObject);
begin
     eTitre.Text:= 'Nouveau Nom_de_la_classe';
     cdNouveau.Show('Titre du nouveau Nom_de_la_classe');
end;

procedure TfNom_de_la_classe_ListView.bNouveau_OKClick(Sender: TObject);
var
   bl: TblNom_de_la_classe;
begin
     poolNom_de_la_classe.Nouveau_Base( bl);
     bl.cLibelle.Chaine:= eTitre.Text;
     bl.Save_to_database;
     cdNouveau.Close;
     _from_sl;
end;

procedure TfNom_de_la_classe_ListView.bNouveau_CancelClick(Sender: TObject);
begin
     cdNouveau.Close;
end;

procedure TfNom_de_la_classe_ListView.LogP(_Message_Developpeur: String; _Message: String);
begin
     Log.PrintLn( _Message+_Message_Developpeur);
end;

procedure TfNom_de_la_classe_ListView._from_sl;
var
   I: TIterateur_Nom_de_la_classe;
   bl: TblNom_de_la_classe;
begin
     lv.Clear;
     I:= poolNom_de_la_classe.Iterateur_Filtre;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;
          lv.Add(bl.cLibelle.Chaine);
          end;
     finally
            FreeAndNil(I);
            end;

end;

procedure TfNom_de_la_classe_ListView.Affiche(_Index: Integer);
begin
  if nil = FfNom_de_la_classe
  then
      begin
      gApp.CreateForm( TfNom_de_la_classe, FfNom_de_la_classe);
      FfNom_de_la_classe.InitShowing;
      end
  else
      FfNom_de_la_classe.Show;
  FfNom_de_la_classe.Affiche( _Index);
end;

procedure TfNom_de_la_classe_ListView.lvClickItem(Sender: TObject; itemIndex: integer;itemCaption: string);
begin
     Affiche( itemIndex)
end;

end.
