unit ufChants;

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
  ublChant,

  udmDatabase,
  upool,
  upoolChant,

  uRequete,

  ufChant,
  ufOptions,
  ufjsNote,
  ufAccueil_Erreur,
  ufUtilitaires, uchChamp_Edit,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, imagebutton, midimanager,
  preferences, modaldialog, sharefile, customdialog;
  
type

  { TfChants }

 TfChants
 =
  class(jForm)
    bID: jButton;
    bTitre: jButton;
    bjsNote: jButton;
    bNouveau: jButton;
    cdNouveau: jCustomDialog;
    eTitre: jEditText;
    bNouveau_OK: jButton;
    bNouveau_Cancel: jButton;
    ivOptions: jImageView;
    jPanel3: jPanel;
    lv: jListView;
    mm: jMidiManager;
    pHaut: jPanel;
    Panel2: jPanel;
    pBas: jPanel;
    pf: jPreferences;
    sqlc: jSqliteCursor;
    sqlda: jSqliteDataAccess;
    tvTri: jTextView;
    procedure bIDClick(Sender: TObject);
    procedure bjsNoteClick(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bNouveau_CancelClick(Sender: TObject);
    procedure bNouveau_OKClick(Sender: TObject);
    procedure bOptionsClick(Sender: TObject);
    procedure bTitreClick(Sender: TObject);
    procedure fChantsJNIPrompt(Sender: TObject);
    procedure ivOptionsClick(Sender: TObject);
    procedure lvClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    NbChants: Integer;
    FfChant: TfChant;
    FfOptions: TfOptions;
    FfjsNote: TfjsNote;
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
  fChants: TfChants;

  
implementation
  
  
{$R *.lfm}
  

  
{ TfChants }

constructor TfChants.Create(AOwner: TComponent);
begin
     Filename:= 'jsNote.sqlite';
     FfChant:= nil;
     FfOptions:= nil;
     FfjsNote:= nil;
     inherited Create(AOwner);
end;

destructor TfChants.Destroy;
begin
     inherited Destroy;
end;

procedure TfChants.fChantsJNIPrompt(Sender: TObject);
begin
     WriteLn( Classname+'.fChantsJNIPrompt: début');
     sqlda.DataBaseName:= Filename;
     uSQLite_Android_jForm:= Self;
     uSQLite_Android_sda  := sqlda;
     uSQLite_Android_sc   := sqlc;
     fAccueil_log_procedure:= LogP;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     uOptions.mm:= mm;
     uOptions.pf:= pf;
     Options_Restore;
     WriteLn( Classname+'.fChantsJNIPrompt: DatabasesDir='+DatabasesDir);
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
     if 0 = poolChant.slFiltre.Count
     then
         begin
         WriteLn( Classname+'.fChantsJNIPrompt: 1: poolChant.ToutCharger;');
         poolChant.ToutCharger;
         if 0 = poolChant.slFiltre.Count
         then
             begin
             uAndroid_Database_from_Assets( Self, FileName, FileName);
             WriteLn( Classname+'.fChantsJNIPrompt: 2: poolChant.ToutCharger;');
             poolChant.ToutCharger;
             end;

         //workaround, sinon on obtient la base d'origine des assets au premier chargement
         poolChant.Vide;
         poolChant.ToutCharger;
         end;
     pBas.Visible:= uOptions.Editable;
     _from_sl;
end;

procedure TfChants.bIDClick(Sender: TObject);
begin
     bID   .Text:= '#^';
     bTitre.Text:= 'A .. Z';
     poolChant.Reset_ChampsTri;
     poolChant.hf.Execute;
     _from_sl;
end;

procedure TfChants.bTitreClick(Sender: TObject);
begin
     bID   .Text:= '#';
     bTitre.Text:= 'A .. Z ^';
     poolChant.Reset_ChampsTri;
     poolChant.ChampTri['Titre']:= +1;;
     poolChant.TrierFiltre;
     _from_sl;
end;

procedure TfChants.bOptionsClick(Sender: TObject);
begin

end;

procedure TfChants.ivOptionsClick(Sender: TObject);
begin
     WriteLn( Classname+'.bOptionsClick: début');
     poolChant.Vide;
     WriteLn( Classname+'.bOptionsClick: aprés poolChant.Vide;');
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

procedure TfChants.bjsNoteClick(Sender: TObject);
begin
     if nil = FfjsNote
     then
         begin
         gApp.CreateForm( TfjsNote, FfjsNote);
         FfjsNote.InitShowing;
         end
     else
         FfjsNote.Show;
end;

procedure TfChants.bNouveauClick(Sender: TObject);
begin
     eTitre.Text:= 'Nouveau chant';
     cdNouveau.Show('Titre du nouveau chant');
end;

procedure TfChants.bNouveau_OKClick(Sender: TObject);
var
   bl: TblChant;
begin
     poolChant.Nouveau_Base( bl);
     bl.Titre:= eTitre.Text;
     bl.Save_to_database;
     cdNouveau.Close;
     _from_sl;
end;

procedure TfChants.bNouveau_CancelClick(Sender: TObject);
begin
     cdNouveau.Close;
end;

procedure TfChants.LogP(_Message_Developpeur: String; _Message: String);
begin
     Log.PrintLn( _Message+_Message_Developpeur);
end;

procedure TfChants._from_sl;
var
   I: TIterateur_Chant;
   bl: TblChant;
begin
     lv.Clear;
     I:= poolChant.Iterateur_Filtre;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;
          lv.Add(bl.Titre);
          end;
     finally
            FreeAndNil(I);
            end;

end;

procedure TfChants.Affiche(_Index: Integer);
begin
  if nil = FfChant
  then
      begin
      gApp.CreateForm( TfChant, FfChant);
      FfChant.InitShowing;
      end
  else
      FfChant.Show;
  FfChant.Affiche( _Index);
end;

procedure TfChants.lvClickItem(Sender: TObject; itemIndex: integer;itemCaption: string);
begin
     Affiche( itemIndex)
end;

end.