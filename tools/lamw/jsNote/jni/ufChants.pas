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
  ufUtilitaires,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, imagebutton, midimanager,
  preferences;
  
type

  { TfChants }

 TfChants
 =
  class(jForm)
    bOptions: jButton;
    bID: jButton;
    bTitre: jButton;
    bjsNote: jButton;
    lv: jListView;
    mm: jMidiManager;
    Panel1: jPanel;
    pf: jPreferences;
    TextView1: jTextView;
    procedure bIDClick(Sender: TObject);
    procedure bjsNoteClick(Sender: TObject);
    procedure bOptionsClick(Sender: TObject);
    procedure bTitreClick(Sender: TObject);
    procedure fChantsJNIPrompt(Sender: TObject);
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
     uSQLite_Android_jForm:= Self;
     fAccueil_log_procedure:= LogP;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     uOptions.mm:= mm;
     uOptions.pf:= pf;
     Options_Restore;
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
         poolChant.ToutCharger;
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
     if nil = FfOptions
     then
         begin
         gApp.CreateForm( TfOptions, FfOptions);
         FfOptions.InitShowing;
         end
     else
         FfOptions.Show;
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