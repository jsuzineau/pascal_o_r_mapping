{hint: Pascal files location: ...\AppLAMWProject1\jni }
unit ufNom_de_la_classe;

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


    ufAccueil_Erreur,
    ufUtilitaires,

    uchChamp_Edit, uchChamp_Button,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, Laz_And_Controls,
 menu, And_jni,
 radiogroup, downloadmanager;
 
type

 { TfNom_de_la_classe }

 TfNom_de_la_classe
 =
  class(jForm)
    bPrecedent: jButton;
    bSuivant: jButton;
    bSupprimer: jButton;
    bCacher: jButton;
    dynSupprimer: jDialogYN;
    eTitre: jEditText;
    hceTitre: ThChamp_Edit;
    jm: jMenu;
    Panel1: jPanel;
    procedure bCacherClick(Sender: TObject);
    procedure bPrecedentClick(Sender: TObject);
    procedure bSuivantClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure dynSupprimerClickYN(Sender: TObject; YN: TClickYN);
    procedure fNom_de_la_classeClickOptionMenuItem(Sender: TObject; jObjMenuItem: jObject;
     itemID: integer; itemCaption: string; checked: boolean);
    procedure fNom_de_la_classeCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure fNom_de_la_classeJNIPrompt(Sender: TObject);
    procedure fNom_de_la_classeRequestPermissionResult(Sender: TObject;
     requestCode: integer; manifestPermission: string;
     grantResult: TManifestPermissionResult);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Gestion de l'affichage
  public
    bl: TblNom_de_la_classe;
    Index_Courant: Integer;
    procedure Affiche( _Index: Integer);
    procedure Champs_Affecte_bl( _bl: TblNom_de_la_classe);
  end;

var
  fNom_de_la_classe: TfNom_de_la_classe;

implementation
 
{$R *.lfm}

{ TfNom_de_la_classe }

constructor TfNom_de_la_classe.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Index_Courant:= -1;
end;

destructor TfNom_de_la_classe.Destroy;
begin
     inherited Destroy;
end;

procedure TfNom_de_la_classe.fNom_de_la_classeJNIPrompt(Sender: TObject);
begin
     Affiche( poolNom_de_la_classe.slFiltre.Count-1);
     eTitre.Editable:= uOptions.Editable;

     bSupprimer.Visible:= uOptions.Editable;
end;

procedure TfNom_de_la_classe.Champs_Affecte_bl( _bl: TblNom_de_la_classe);
begin
     Champs_Affecte( _bl, [ hceTitre]);
end;

procedure TfNom_de_la_classe.Affiche( _Index: Integer);
begin
          if 0                        > _Index then _Index:= poolNom_de_la_classe.slFiltre.Count-1
     else if poolNom_de_la_classe.slFiltre.Count < _Index then _Index:= 0         ;

     Index_Courant:= _Index;
     bl:= blNom_de_la_classe_from_sl( poolNom_de_la_classe.slFiltre, Index_Courant);
     WriteLn( Classname+'.Affiche: Index_Courant=',Index_Courant);
     Champs_Affecte_bl( bl);
end;

procedure TfNom_de_la_classe.bSupprimerClick(Sender: TObject);
begin
     dynSupprimer.Show;
end;

procedure TfNom_de_la_classe.dynSupprimerClickYN(Sender: TObject; YN: TClickYN);
var
   blTrash: TblNom_de_la_classe;
begin
     WriteLn( Classname+'.dynSupprimerClickYN: début');
     if YN <> ClickYes then exit;

     blTrash:= bl;
     Champs_Affecte_bl( nil);
     WriteLn( Classname+'.dynSupprimerClickYN: avant suppression');
     poolNom_de_la_classe.Supprimer( blTrash);
     poolNom_de_la_classe.Vide;
     poolNom_de_la_classe.ToutCharger;
     Affiche( Index_Courant);
end;

procedure TfNom_de_la_classe.bSuivantClick(Sender: TObject);
begin
     Affiche( Index_Courant+1);
end;
procedure TfNom_de_la_classe.bPrecedentClick(Sender: TObject);
begin
     Affiche( Index_Courant-1);
end;

procedure TfNom_de_la_classe.bCacherClick(Sender: TObject);
begin
     Close;
end;

procedure TfNom_de_la_classe.fNom_de_la_classeCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
begin
     jm.AddItem( jObjMenu, 1, 'Utilitaires', 'ic_launcher', mitDefault, misIfRoomWithText);
end;

procedure TfNom_de_la_classe.fNom_de_la_classeClickOptionMenuItem( Sender: TObject;
                                             jObjMenuItem: jObject;
                                             itemID: integer;
                                             itemCaption: string;
                                             checked: boolean);
begin
     case itemID
     of
       1: fUtilitaires( Filename).Show;
       end;
end;

procedure TfNom_de_la_classe.fNom_de_la_classeRequestPermissionResult( Sender: TObject;
                                                 requestCode: integer;
                                                 manifestPermission: string;
                                                 grantResult: TManifestPermissionResult);
begin
     case requestCode
     of
       permission_READ_EXTERNAL_STORAGE_request_code:
         if grantResult = PERMISSION_GRANTED
         then
             ShowMessage('Succés! ['+manifestPermission+'] Permission accordée !!! ' )
         else  //PERMISSION_DENIED
             ShowMessage('Désolé... ['+manifestPermission+'] Permission non accordée ... ' );
       end;
end;

end.

