unit ufInstallation_Check;

{$mode objfpc}{$H+}

//La gestion du thread de la connections ssh2 provient du code du sshtest.pas
//trouvé sur le forum.lazarus.freepascal.org
interface

uses
    uBatpro_StringList,
    uuStrings,
    uEXE_INI, ucDockableScrollbox,
    ublCommande,
    udkCommande,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
 ExtCtrls, LCLType;

type

 TInstallation_Check= class;

 { TfInstallation_Check }

 TfInstallation_Check
 =
  class(TForm)
   dsb: TDockableScrollbox;
    m: TMemo;
    Splitter1: TSplitter;
    procedure dsbResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
   //
  private
   ic: TInstallation_Check;
   procedure Add_Line(_S: String);
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
  //Résultat brut d'une commande
  public
    procedure Traite_Commande( _Commande: String;_Libelle: String= '');
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
     inherited Init( _th, _Add_Line, 'll '+Repertoire);
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
     finally
            FreeAndNil( slBrut);
            end;

     Calcule_Succes;
     Affiche_Resultat;
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

procedure TInstallation_Check.Traite_Commande( _Commande: String; _Libelle: String= '');
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
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_777');
     ic.Verifie_CHMOD_777  ( './tmp/test_ll/droits_differents');
     ic.Verifie_Owner_Group( './tmp/test_ll/non_partage','jean','jean');
     ic.Verifie_Owner_Group( './tmp/test_ll/partage','jean','jean');
     ic.Traite_Commande( 'fpc -v', 'Version de FreePascal');
     ic.Traite_ll( './');

     dsb.Classe_dockable:= TdkCommande;
     dsb.Classe_Elements:= TblCommande;
     dsb.sl:= ic.sl;

     m.Clear;
end;

procedure TfInstallation_Check.FormDestroy(Sender: TObject);
begin
     FreeAndNil( ic);
end;

procedure TfInstallation_Check.Add_Line( _S: String);
begin
     m.Lines.add( _S);
end;

procedure TfInstallation_Check.dsbResize(Sender: TObject);
begin
     dsb.sl:= ic.sl;
end;

end.

