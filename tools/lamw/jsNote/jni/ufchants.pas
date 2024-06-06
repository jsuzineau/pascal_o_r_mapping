unit ufChants;

{$mode delphi}

interface

uses
  uuStrings,
  uForms,

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
  ufAccueil_Erreur,
  ufUtilitaires,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TfChants }

 TfChants
 =
  class(jForm)
    lv: jListView;
    procedure fChantsJNIPrompt(Sender: TObject);
    procedure lvClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    sl: TslChant;
    NbChants: Integer;
    Filename: String;
    FfChant: TfChant;
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
     FfChant:= nil;
     inherited Create(AOwner);
     sl:= TslChant.Create( ClassName+'.sl');
end;

destructor TfChants.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TfChants.fChantsJNIPrompt(Sender: TObject);
var
   NbChants_ok: Boolean;
begin
     Filename:= 'jsNote.sqlite';

     uSQLite_Android_jForm:= Self;
     fAccueil_log_procedure:= LogP;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     uAndroid_Database_Traite_Environment( Self);
     SGBD_Set( sgbd_SQLite_Android);

     dmDatabase.Initialise;
     dmDatabase.jsDataConnexion.DataBase:= Filename;
     poolChant.ToutCharger( sl);
     WriteLn( Classname+'.fChantsJNIPrompt: sl.Count=',sl.Count);
     _from_sl;

     NbChants_ok:= Requete.Integer_from( 'select count(*) as NbLignes from Chant', 'NbLignes', NbChants);
     WriteLn( Classname+'.fChantsJNIPrompt: Requete NbLignes= ',NbChants, ', NbLignes_ok= ',NbChants_ok);
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
     I:= sl.Iterateur;
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
