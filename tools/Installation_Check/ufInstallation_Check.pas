unit ufInstallation_Check;

{$mode objfpc}{$H+}

//La gestion du thread de la connections ssh2 provient du code du sshtest.pas
//trouvé sur le forum.lazarus.freepascal.org
interface

uses
    uClean,
    uBatpro_StringList,
    uuStrings,
    uVide,
    uEXE_INI,
    ublCommande,

    ucDockableScrollbox,
    udkCommande, Classes, SysUtils, FileUtil, SynHighlighterPas, SynEdit,
    uPSComponent, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
    LCLType;

type

 TInstallation_Check= class;

 { TfInstallation_Check }

 TfInstallation_Check
 =
  class(TForm)
   bRun: TButton;
   bCtrlC: TButton;
   dsb: TDockableScrollbox;
    m: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ps: TPSScript;
    se: TSynEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SynPasSyn: TSynPasSyn;
    procedure bCtrlCClick(Sender: TObject);
    procedure bRunClick(Sender: TObject);
    procedure dsbResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure psCompile(Sender: TPSScript);
    procedure psExecute(Sender: TPSScript);
   //
  private
   ic: TInstallation_Check;
   NomScript: String;
   procedure Add_Line(_S: String);
   procedure Vide;
   procedure Refresh_List;
   procedure Charge_script;
   procedure Sauve_script;
   procedure Run;
  end;

 { TTraite_ll }

 TTraite_ll
 =
  class( TblCommande)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList);

    destructor Destroy; override;
  //Initialisation
  public
    function Init( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                   _Repertoire: String): TTraite_ll;
  //Attributs
  public
    Repertoire: String;
  // Consolidation
  protected
    Rights: String;
    sOwner: String;
    Group: String;
    Info: String;
    procedure Calcule_Info; virtual;
  //CallBack appelé à la fin du thread
  public
     procedure Commande_Terminated; override;
  //Résultat
  public
    slConsolidation: TStringList;
    procedure Affiche_Resultat; virtual;
  //Succes
  public
    Succes: Boolean;
    procedure Calcule_Succes; virtual;
  end;

 { TVerifie_CHMOD_777 }

 TVerifie_CHMOD_777
 =
  class( TTraite_ll)
  //Initialisation
  public
    function Init( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                   _Repertoire: String): TVerifie_CHMOD_777;
  // Consolidation
  protected
    procedure Calcule_Info; override;
  //Résultat
  public
    procedure Affiche_Resultat; override;
  //Succes
  public
    procedure Calcule_Succes; override;
  end;

 { TVerifie_Owner_Group }

 TVerifie_Owner_Group
 =
  class( TTraite_ll)
  //Initialisation
  public
    function Init( _th: TthCommand; _Add_Line: TInstallation_Check_String_Proc;
                    _Repertoire, _OwnerConstraint, _GroupConstraint: String): TVerifie_Owner_Group;
  //Attributs
  public
    OwnerConstraint, GroupConstraint: String;
  // Consolidation
  protected
    procedure Calcule_Info; override;
  //Résultat
  public
    procedure Affiche_Resultat; override;
  //Succes
  public
    procedure Calcule_Succes; override;
  end;

 { TInstallation_Check }

 TInstallation_Check
 =
  class
   //Gestion du cycle de vie
   public
     constructor Create( _Add_Line: TInstallation_Check_String_Proc);
     destructor Destroy; override;
  //Attributs
  public
    th: TthCommand;
    Add_Line: TInstallation_Check_String_Proc;
  //Liste de commandes
  public
    sl: TslCommande;
    procedure Vide;
  //Résultat brut d'une commande
  public
    procedure Traite_Commande( _Commande: String;_Libelle: String);
  //Listage des droits dans un répertoire
  public
    procedure Traite_ll( _Repertoire: String);
  //Vérification droits 777
  public
    procedure Verifie_CHMOD_777( _Repertoire: String);
  //Vérification propriétaire et groupe
  public
    procedure Verifie_Owner_Group( _Repertoire, _OwnerConstraint, _GroupConstraint: String);
  end;


var
 fInstallation_Check: TfInstallation_Check;

implementation

{$R *.lfm}

{ TTraite_ll }

constructor TTraite_ll.Create(_sl: TBatpro_StringList);
begin
     inherited;
     slConsolidation:= TStringList.Create;
end;

destructor TTraite_ll.Destroy;
begin
     FreeAndNil( slConsolidation);
     inherited Destroy;
end;

function TTraite_ll.Init( _th: TthCommand;
                          _Add_Line: TInstallation_Check_String_Proc;
                          _Repertoire: String): TTraite_ll;
begin
     Repertoire:= _Repertoire;
     inherited Init( _th, _Add_Line, 'll -R '+Repertoire);
     Libelle:= 'Consolidation droits ll sur '+Repertoire;
     Result:= Self;
end;

procedure TTraite_ll.Commande_Terminated;
var
   slBrut: TStringList;
   i: Integer;
   s: String;
begin
     slBrut:= TStringList.Create;
     try
        slBrut.Text:= th.Resultat;
        //Suppression du prompt à la fin
        while
                 (slBrut.Count>0)
             and (slBrut[slBrut.Count-1] = th.Prompt)
        do
          slBrut.Delete( slBrut.Count-1); //le prompt

        slBrut.Delete( 1         ); //total
        slBrut.Delete( 0         ); //l'écho de la commande
        for i:= slBrut.Count-1 downto 0
        do
          begin
          s:= slBrut[i];
               if 1 = Pos( Repertoire, s) then slBrut.Delete( i)
          else if 1 = Pos( 'total'   , s) then slBrut.Delete( i)
          else if '' = s                  then slBrut.Delete( i);
          end;
(*
drwxrwxr-x  3 jean jean    4096 janv.  9  2016 analyseur_4gl
*)
        for i:= 0 to slBrut.Count-1
        do
          begin
          s:= slBrut[i];
          Rights:= StrToK( ' ', s);
          s:= TrimLeft( s);
          StrToK( ' ', s); //hardlinks #
          sOwner:= StrToK( ' ', s);
          Group:= StrToK( ' ', s);

          Delete(Rights, 1, 1);//on enlève le type de fichier : directory, link, fichier...

          Calcule_Info;
          if -1 = slConsolidation.IndexOf(Info) then slConsolidation.Add( Info);
          end;
        Calcule_Succes;
        Affiche_Resultat;
        if not Succes
        then
            Add_Line( slBrut.Text);
     finally
            FreeAndNil( slBrut);
            end;

end;

procedure TTraite_ll.Calcule_Info;
begin
     Info:= Rights + ' '+ sOwner + ' ' + Group;
end;

procedure TTraite_ll.Calcule_Succes;
begin
     Succes:= True;
end;

procedure TTraite_ll.Affiche_Resultat;
begin
     cLED_Color.asInteger:= clLime;
     Add_Line( Libelle+':');
     slConsolidation.Sort;
     Add_Line( slConsolidation.Text);
     Add_Line( 'fin consolidation droits ll:');
     //Add_Line( 'Retour commande brut:');
     //Add_Line( _Resultat);
     //Add_Line( 'Fin Retour commande brut');
end;

{ TVerifie_CHMOD_777 }

function TVerifie_CHMOD_777.Init( _th: TthCommand;
                                  _Add_Line: TInstallation_Check_String_Proc;
                                  _Repertoire: String): TVerifie_CHMOD_777;
begin
     inherited Init( _th, _Add_Line, _Repertoire);
     Libelle:= ' vérification droits 777 sur '+Repertoire;
     Result:= Self;
end;

procedure TVerifie_CHMOD_777.Calcule_Info;
begin
     Info:= Rights;
end;

procedure TVerifie_CHMOD_777.Calcule_Succes;
begin
     Succes:= slConsolidation.Count = 1;
     if not Succes then exit;

     Succes:= slConsolidation[0] = 'rwxrwxrwx';//777
end;

procedure TVerifie_CHMOD_777.Affiche_Resultat;
begin
     if Succes
     then
         cLED_Color.asInteger:= clLime
     else
         cLED_Color.asInteger:= clRed;

     Add_Line( BoolToStr( Succes, 'Succés','Echec ')+Libelle);
end;

{ TVerifie_Owner_Group }
function TVerifie_Owner_Group.Init( _th: TthCommand;
                                    _Add_Line: TInstallation_Check_String_Proc;
                                    _Repertoire, _OwnerConstraint, _GroupConstraint: String): TVerifie_Owner_Group;
begin
     inherited Init( _th, _Add_Line, _Repertoire);
     OwnerConstraint:= _OwnerConstraint;
     GroupConstraint:= _GroupConstraint;
     Libelle:= 'vérification propriétaire '+OwnerConstraint + ' groupe ' + GroupConstraint+' sur '+Repertoire;
     Result:= Self;
end;

procedure TVerifie_Owner_Group.Calcule_Info;
begin
     Info:= sOwner + ' ' + Group;
end;

procedure TVerifie_Owner_Group.Calcule_Succes;
begin
     Succes:= slConsolidation.Count = 1;
     if not Succes then exit;

     Succes:= slConsolidation[0] = OwnerConstraint + ' ' + GroupConstraint;
end;

procedure TVerifie_Owner_Group.Affiche_Resultat;
begin
     if Succes
     then
         cLED_Color.asInteger:= clLime
     else
         cLED_Color.asInteger:= clRed;
     Add_Line( BoolToStr( Succes, 'Succcés ','Echec   ')+Libelle);
end;

{ TInstallation_Check }

constructor TInstallation_Check.Create( _Add_Line: TInstallation_Check_String_Proc);
begin
     Add_Line:= _Add_Line;
     th:= TthCommand.Create( Add_Line);
     sl:= TslCommande.Create( ClassName+'.sl');
end;

destructor TInstallation_Check.Destroy;
begin
     th.FreeOnTerminate:= True;
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TInstallation_Check.Vide;
begin
     Vide_StringList( sl);
end;

procedure TInstallation_Check.Traite_Commande( _Commande: String; _Libelle: String);
begin
     TblCommande.Create(sl).Init( th, Add_Line, _Commande, _Libelle).Execute;
end;

procedure TInstallation_Check.Traite_ll( _Repertoire: String);
begin
     TTraite_ll.Create(sl).Init( th, Add_Line, _Repertoire).Execute;
end;

procedure TInstallation_Check.Verifie_CHMOD_777( _Repertoire: String);
begin
     TVerifie_CHMOD_777.Create(sl).Init( th, Add_Line, _Repertoire).Execute;
end;

procedure TInstallation_Check.Verifie_Owner_Group( _Repertoire, _OwnerConstraint, _GroupConstraint: String);
begin
     TVerifie_Owner_Group.Create(sl).Init( th, Add_Line, _Repertoire, _OwnerConstraint, _GroupConstraint).Execute;
end;

{ TfInstallation_Check }

procedure TfInstallation_Check.FormCreate(Sender: TObject);
begin
     ic:= TInstallation_Check.Create( @Add_Line);

     dsb.Classe_dockable:= TdkCommande;
     dsb.Classe_Elements:= TblCommande;
     Refresh_List;

     m.Clear;
     Charge_script;
end;

procedure TfInstallation_Check.FormDestroy(Sender: TObject);
begin
     Sauve_script;
     FreeAndNil( ic);
end;

procedure TfInstallation_Check.psCompile(Sender: TPSScript);
begin
     Sender.AddMethod( ic, @TInstallation_Check.Traite_Commande    , 'procedure Traite_Commande( _Commande: String;_Libelle: String)'                         );
     Sender.AddMethod( ic, @TInstallation_Check.Traite_ll          , 'procedure Traite_ll( _Repertoire: String)'                                              );
     Sender.AddMethod( ic, @TInstallation_Check.Verifie_CHMOD_777  , 'procedure Verifie_CHMOD_777( _Repertoire: String)'                                      );
     Sender.AddMethod( ic, @TInstallation_Check.Verifie_Owner_Group, 'procedure Verifie_Owner_Group( _Repertoire, _OwnerConstraint, _GroupConstraint: String)');
     //Sender.AddRegisteredPTRVariable( 'ic', ic.ClassName);
end;

procedure TfInstallation_Check.psExecute(Sender: TPSScript);
begin
     //ps.SetPointerToData( 'ic',@ic, ps.FindNamedType( ic.ClassName));
end;

procedure TfInstallation_Check.Add_Line( _S: String);
begin
     m.Lines.add( _S);
end;

procedure TfInstallation_Check.Vide;
begin
     dsb.sl:= nil;
     ic.Vide;
end;

procedure TfInstallation_Check.Refresh_List;
begin
     dsb.sl:= ic.sl;
end;

procedure TfInstallation_Check.Charge_script;
var
   Repertoire_etc: String;
begin
     Repertoire_etc:= uClean_ETC_from_EXE( uClean_EXE_Name);
     ForceDirectories( Repertoire_etc);
     NomScript:= Repertoire_etc+PathDelim+'script.pas';
     if FileExists( NomScript)
     then
         se.Lines.LoadFromFile( NomScript);

end;

procedure TfInstallation_Check.Sauve_script;
begin
     if     se.Modified
        and (
            mrYes = MessageDlg( 'Enregistrer les modifications dans le script ?',
                                mtConfirmation,[mbYes, mbNo],0))
     then
         se.Lines.SaveToFile( NomScript);
end;

procedure TfInstallation_Check.dsbResize(Sender: TObject);
begin
     Refresh_List;
end;

procedure TfInstallation_Check.bRunClick(Sender: TObject);
begin
     Run;
end;

procedure TfInstallation_Check.bCtrlCClick(Sender: TObject);
begin
     ic.th.Send_Ctrl_C;
end;

procedure TfInstallation_Check.Run;
var
   compiled: boolean;
   i: Integer;
begin
     {
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_777');
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_differents');
     ic.Verifie_Owner_Group( './tmp/test_ll/non_partage','jean','jean');
     ic.Verifie_Owner_Group( './tmp/test_ll/partage','jean','jean');
     ic.Traite_Commande( 'fpc -v', 'Version de FreePascal');
     ic.Traite_ll( './');
     }
     Vide;
     m.Clear;

     ps.Script.Text := se.Lines.Text;
     Compiled := ps.Compile;
     for i := 0 to ps.CompilerMessageCount -1
     do
       m.Lines.Add( ps.CompilerMessages[i].MessageToString);
     if Compiled
     then
         m.Lines.Add( 'Succesfully compiled');
     if Compiled
     then
         begin
         if ps.Execute
         then
             m.Lines.Add( 'Succesfully Executed')
         else
             m.Lines.Add( 'Error while executing script: '+ps.ExecErrorToString);
         end;
     Refresh_List;
end;

end.

