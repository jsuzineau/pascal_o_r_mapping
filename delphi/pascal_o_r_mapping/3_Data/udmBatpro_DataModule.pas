unit udmBatpro_DataModule;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uForms,
    uOD_Forms,
    uClean,
    u_sys_,
    uChrono,
    uBatpro_StringList,
    {$IFNDEF FPC}
    uUseCase,
    {$ENDIF}
    uPublieur,
    uEtat,
    uParametres_Ligne_de_commande,
    uDataUtilsU,
    uDataUtilsF,

    udmDatabase,

    ufAccueil_Erreur,
    //ufClientDataset_Delta,
    ufReconcileError,
    ufProgression,

  SysUtils, Classes, 
  DB, DBClient, SQLExpr;

type
 TypeDataset
 =                  //                TdmBatpro_DataModule,Méthodes d'ouverture|
  (                 //                       Ouvrir_LectureSeule|Ouvrir_Edition|
  td_Lecture_Seule, // requêtes en lecture seule(défaut)     X  |              |
  td_Edition      , // requêtes à résultat modifiable        X  |     X        |
  td_Special        // instructions genre CREATE TABLE,DROP     |              |
  );
 TdmBatpro_DataModule
 =
  class(TDataModule)
  private
    { Déclarations privées }
    Suivant: TdmBatpro_DataModule;

    procedure Met_dans_liste;
    procedure Enleve_de_liste;
  protected
    DataSets     : array of TDataset ;
    DataSets_Type: array of TypeDataset;
    DatasetCount : Integer;

    //DBDataSets   : array of TDBDataset ;

    FOuvert: Boolean;
    FLectureSeule: Boolean;
    Designation: String;
    procedure Traite_ModeOuverture(D: TDataset);
    function Fin_LectureSeule: Boolean; virtual;
    function Fin__Edition: Boolean; virtual;

    // à surcharger dans les types dérivés pour déclarer les dataset éditables
    // ou spéciaux genre CREATE TABLE, DELETE FROM ...
    function Register_Dataset( D: TDataset): TypeDataset; virtual;

    procedure Initialise_DataSets;
    procedure ClientDatasetReconcileError( DataSet: TCustomClientDataSet;
                                           E: EReconcileError;
                                           UpdateKind: TUpdateKind;
                                           var Action: TReconcileAction);
  public
    { Déclarations publiques }
    Edition_en_memoire_cache: Boolean;
    Ouvrir_apres_login: Boolean;
    AfficherProgression: Boolean;
    AfficherChrono: Boolean;

    Apres_Ouverture, Avant_Fermeture: TPublieur;

    constructor Create(AOwner: TComponent); override;

    property Ouvert: Boolean read FOuvert;
    property LectureSeule: Boolean read FLectureSeule;
    function Ouverture( Edition: Boolean): Boolean; virtual;
    function Ouvrir_LectureSeule: Boolean;
    function Ouvrir_Edition     : Boolean;
    function ReOuvrir           : Boolean;
    function Fermer: Boolean; virtual;

    procedure Assure_Ouvert;
    function Edition_en_cours: Boolean;

    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    destructor Destroy; override;
    procedure Assure_DataSource( C: TComponent; Defaut: TDatasource);
    procedure Affiche_Requetes;
  //Gestion du verrouillage des champs
  private
    FEst_Verrouille: Boolean;
  protected
    procedure Verrouillage( Valeur: Boolean); virtual;
  public
    Verrouille_par_Defaut: Boolean;
    property Est_Verrouille: Boolean read FEst_Verrouille;
    procedure Traite_droits_de_modification; virtual;

    procedure   Verrouille;
    procedure DeVerrouille;
  end;

var
   TeteListeModules: TdmBatpro_DataModule= nil;
   Ouverture_en_cours: Boolean= False;
   pLogin: TPublieur= nil;

procedure Ouvre_Modules( isLogin: Boolean);
procedure Ouvre_Modules_Edition( isLogin: Boolean);
procedure Ouvre_Modules_Login;

procedure Ferme_Modules;

implementation

{$R *.dfm}

procedure Do_Ouvre_Modules( isLogin: Boolean; Edition: Boolean);
var
   L: TdmBatpro_DataModule;
   function Traiter: Boolean;
   begin
        if isLogin
        then
            Result:= L.Ouvrir_apres_login
        else
            Result:= True;
   end;
begin
     Ouverture_en_cours:= True;
     try
        L:= TeteListeModules;
        while Assigned( L)
        do
          begin
          with L
          do
            if Traiter
            then
                if not Ouvert
                then
                    Ouverture( Edition);
          L:= L.Suivant;
          end;
     finally
            Ouverture_en_cours:= False;
            end;
     uOD_Forms_ProcessMessages;
end;

procedure Ouvre_Modules( isLogin: Boolean);
begin
     Do_Ouvre_Modules( isLogin, False);
end;

procedure Ouvre_Modules_Login;
begin
     if not dmDatabase.Ouvert then exit; //peut se produire dans les tests unitaires

     Ouvre_Modules( True);
     pLogin.Publie;
end;

procedure Ouvre_Modules_Edition( isLogin: Boolean);
begin
     if not dmDatabase.Ouvert then exit; //peut se produire dans les tests unitaires

     Do_Ouvre_Modules( isLogin, True);
end;

procedure Ferme_Modules;
var
   L: TdmBatpro_DataModule;
begin
     L:= TeteListeModules;
     while Assigned( L)
     do
       begin
       with L
       do
         if Ouvert
         then
             Fermer;
       L:= L.Suivant;
       end;
end;

procedure TdmBatpro_DataModule.Met_dans_liste;
var
   L: TdmBatpro_DataModule;
begin
     Suivant:= nil;
     if TeteListeModules = nil
     then
         TeteListeModules:= Self
     else
         begin
         L:= TeteListeModules;
         while Assigned( L.Suivant) do L:= L.Suivant;
         L.Suivant:= Self;
         end;
end;

procedure TdmBatpro_DataModule.Enleve_de_liste;
var
   L: TdmBatpro_DataModule;
begin
     if Assigned( TeteListeModules)
     then
         if TeteListeModules = Self
         then
             TeteListeModules:= nil
         else
             begin
             L:= TeteListeModules;
             while not ( (L.Suivant = nil ) or
                         (L.Suivant = Self)   )
             do
               L:= L.Suivant;
             if L.Suivant = Self
             then
                 L.Suivant:= Suivant;
             end;
end;

function TdmBatpro_DataModule.Register_Dataset( D: TDataset): TypeDataset;
begin
     if D is TSQLQuery       //dans 99% des cas, on ne touche pas au TSQLQuery
     then                    //on ouvre simplement le TClientDataset qui y est
         Result:= td_Special //connecté par un TDataSetProvider
     else
         Result:= td_Lecture_Seule;
end;

procedure TdmBatpro_DataModule.Initialise_DataSets;
var
   I, ID: Integer;
   C: TComponent;
   D: TDataset;
   function C_Convient: Boolean;
   begin
        Result:= C is TClientDataset;
   end;
begin
     DatasetCount:= 0;
     for I:= 0 to ComponentCount-1
     do
       begin
       C:= Components[ I];
       if C_Convient
       then
           Inc( DatasetCount);
       end;

     SetLength( DataSets     , DatasetCount);
     SetLength( DataSets_Type, DatasetCount);
     ID:= 0;
     for I:= 0 to ComponentCount-1
     do
       begin
       C:= Components[ I];
       if C_Convient
       then
           begin
           D:= TDataset( C);

           DataSets[ID]:= D;
           D.Tag:= ID;

           DataSets_Type[ID]:= Register_Dataset( D);

           if D is TClientDataset
           then
               if not Assigned( TClientDataset(D).OnReconcileError)
               then
                   TClientDataset(D).OnReconcileError
                   :=
                     ClientDatasetReconcileError;

           Inc( ID);
           end;
       end;
end;

constructor TdmBatpro_DataModule.Create(AOwner: TComponent);
var
   Message: String;
   procedure Cree_Message;
   begin
        Message
        :=#13#10+
          'Création du datamodule : %s';
        Message:= Format( Message, [ Name]);
   end;
begin
     Designation:= sys_Vide;
     FOuvert:= False;
     Ouvrir_apres_login:= False;
     Edition_en_memoire_cache:= False;
     Verrouille_par_Defaut:= False;
     FEst_Verrouille:= False;
     AfficherProgression:= False;
     AfficherChrono:= False;

     try
        inherited;
     except
           on E: Exception
           do
             begin
             Cree_Message;
             fAccueil_Erreur( Message + sys_N+ ' Erreur:'+sys_N+
                              E.Message);
             end;
           end;
     Cree_Message;
     //fAccueil_Log( Message);
     fAccueil_Set_Has_Log( False);
     Etat.Change( 'Création du datamodule : '+Name);

     Met_dans_liste;

     Initialise_DataSets;
     Apres_Ouverture:= TPublieur.Create(Name+'.Apres_Ouverture');
     Avant_Fermeture:= TPublieur.Create(Name+'.Avant_Fermeture');
end;

destructor TdmBatpro_DataModule.Destroy;
//var
//   truc: TBatpro_StringList;
begin
     //truc:= TBatpro_StringList.Create;
     //try
     //   truc.Text:= Name;
     //   truc.SaveToFile( ChangeFileExt( ParamStr(0), '.log.txt'));
     //finally
     //       Free_nil( truc);
     //       end;
     Fermer;

     Free_nil( Apres_Ouverture);
     Free_nil( Avant_Fermeture);

     Enleve_de_liste;
     //uClean_Log_Start( Name+'.Destroy: inherited Destroy;');
     inherited Destroy;
     //uClean_Log_Succes( Name+'.Destroy: inherited Destroy;');
end;

procedure TdmBatpro_DataModule.Traite_ModeOuverture(D: TDataset);
var
   C: TClientDataset;
   Typ: TypeDataset;
begin
          if D is TClientDataset
     then
         begin
         C:= TClientDataset( D);
         Typ:= DataSets_Type[ C.Tag];
         C.ReadOnly:= LectureSeule  or (Typ <> td_Edition)
         end;
end;

function TdmBatpro_DataModule.Ouverture( Edition: Boolean): Boolean;
var
   I: Integer;
   D: TDataset;
   TitreProgression_et_Chrono: String;
begin
     Result:= Fermer;
     if Result
     then
         begin
         FLectureSeule:= not Edition;

         if AfficherProgression or AfficherChrono
         then
             begin
             if Designation = sys_Vide
             then
                 TitreProgression_et_Chrono:= Name
             else
                 TitreProgression_et_Chrono:= Designation;
             TitreProgression_et_Chrono
             :=
               TitreProgression_et_Chrono+' - Exécution des requêtes SQL';
             end;

         if AfficherChrono
         then
             Chrono.Start;

         {$IFDEF MSWINDOWS}
         if AfficherProgression
         then
             fProgression.Demarre( TitreProgression_et_Chrono,
                                   Low( DataSets), High( DataSets));
         {$ENDIF}
         try
            //Gestion du mode d'ouverture
            for I:= Low( DataSets) to High( DataSets)
            do
              begin
              if DataSets_Type[I] <> td_Special
              then
                  begin
                  D:= Datasets[I];
                  Traite_ModeOuverture( D);
                  end;
              end;

            //Ouverture
            for I:= Low( DataSets) to High( DataSets)
            do
              begin
              if DataSets_Type[I] <> td_Special
              then
                  begin
                  D:= Datasets[I];
                  if not D.Active
                  then
                      Result:= Result and Ouvre( D);
                  if AfficherChrono
                  then
                      Chrono.Stop( Name+'.'+D.Name);
                  end;
              {$IFDEF MSWINDOWS}
              if AfficherProgression then fProgression.AddProgress( 1);
              {$ENDIF}
              end;


            if Result
            then
                begin
                if not LectureSeule
                then
                    Traite_droits_de_modification;
                end
            else
                Fermer;

            FOuvert:= Result;
         finally
                {$IFDEF MSWINDOWS}
                if AfficherProgression then fProgression.Termine;
                {$ENDIF}
                end;
         if AfficherChrono
         then
             fAccueil_Erreur( sys_N+sys_N+TitreProgression_et_Chrono+sys_N+
                              Chrono.Get_Liste);
         end;
     if Result
     then
         if Assigned( Apres_Ouverture)
         then
             Apres_Ouverture.Publie;
end;

function TdmBatpro_DataModule.Ouvrir_LectureSeule: Boolean;
begin
     Result:= Ouverture( False);
end;

function TdmBatpro_DataModule.Ouvrir_Edition: Boolean;
begin
     Result:= Ouverture( True);
end;

function TdmBatpro_DataModule.ReOuvrir: Boolean;
begin
     Result:= Ouverture( not FLectureSeule);
end;

function TdmBatpro_DataModule.Fin_LectureSeule: Boolean;
var
   I: Integer;
   D: TDataset;
begin
     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
       D.Active:= False;
       end;

     FOuvert:= False;
     Result:= True;
end;

function TdmBatpro_DataModule.Fin__Edition: Boolean;
var
   I: Integer;
   D: TDataset;
   Modifications_presentes: Boolean;
   sMessage: String;
begin
     Result:= False;
     Modifications_presentes:= False;

     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
       Poste( D);
       if D is TClientDataset
       then
           if     (TClientDataset(D).ChangeCount   > 0       )
              and (TClientDataset(D).ProviderName <> sys_Vide)
           then
               begin
               {$IFDEF MSWINDOWS}
               //if ModeDEBUG_1
               //then
               //    fClientDataset_Delta.Execute( TClientDataset(D));
               {$ENDIF}
               Modifications_presentes:= True;
               end;
       end;

     if Modifications_presentes
     then
         begin
         sMessage:= 'Voulez-vous enregistrer les modifications ';
         if Designation <> sys_Vide
         then
             sMessage:= sMessage+' dans '+Designation;
         sMessage:= sMessage+' ?';

         if uForms_Message_Yes( 'Fermeture de '+Name, sMessage)
         then
             ApplyUpdates;
         end;

     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
       D.Active:= False;
       end;

     FOuvert:= False;
     Result:= True;
end;

function TdmBatpro_DataModule.Fermer: Boolean;
begin
     //Dans le planning, il peut arriver que Fermer soit appelé
     // dans DataModuleDestroy et alors Avant_Fermeture est déjà détruit
     if Assigned( Avant_Fermeture)
     then
         Avant_Fermeture.Publie;

     if FOuvert
     then
         if Edition_en_cours
         then
             Result:= Fin__Edition
         else
             Result:= Fin_LectureSeule
     else
         Result:= True;
end;

procedure TdmBatpro_DataModule.Assure_Ouvert;
begin
     if not Ouvert
     then
         Ouvrir_LectureSeule;
end;

procedure TdmBatpro_DataModule.Verrouillage( Valeur: Boolean);
var
   ID: Integer;
   D: TDataset;

   I: Integer;
begin
     for ID:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[ID];
       for I:= 0 to D.FieldCount - 1
       do
         D.Fields[ I].ReadOnly:= Valeur;
       end;
     FEst_Verrouille:= Valeur;
end;

procedure TdmBatpro_DataModule.Traite_droits_de_modification;
begin
     Verrouillage( Verrouille_par_Defaut);
end;

procedure TdmBatpro_DataModule.Verrouille;
begin
     Verrouillage( True);
end;

procedure TdmBatpro_DataModule.DeVerrouille;
begin
     Verrouillage( False);
end;

procedure TdmBatpro_DataModule.ApplyUpdates;
var
   I: Integer;
   D: TDataset;
begin

     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
       if D is TClientDataset
       then
           begin
           Poste( D);
           with TClientDataset(D)
           do
             if    (ChangeCount > 0)
                and(ProviderName <> sys_Vide)
             then
                 ApplyUpdates( 0);
           end;

       end;
end;

procedure TdmBatpro_DataModule.CancelUpdates;
var
   I: Integer;
   D: TDataset;
begin
     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
            if D is TClientDataSet
       then
           TClientDataSet( D).CancelUpdates;
       end;
end;

function TdmBatpro_DataModule.Edition_en_cours: Boolean;
begin
     Result:= FOuvert and not FLectureSeule;
end;

procedure TdmBatpro_DataModule.Assure_DataSource( C: TComponent; Defaut: TDatasource);
begin
     uDataUtilsU.Assure_DataSource( Name, C, Defaut);
end;

procedure TdmBatpro_DataModule.Affiche_Requetes;
var
   I: Integer;
   D: TDataset;
begin
     fAccueil_Log( sys_N+sys_N+'Affichage des datasets du module '+Name);
     fAccueil_Log( 'Note sur les paramètres: ":" devant un identificateur '+sys_N+
                   'symbolise un paramètre traité par Delphi avant envoi  '+sys_N+
                   'de la requête au serveur. Si le paramètre a le même   '+sys_N+
                   'nom qu''un champ dans la "source pour les paramètres" '+sys_N+
                   'Delphi remplace le paramètre par la valeur de ce champ'
                   );
     for I:= Low( DataSets) to High( DataSets)
     do
       begin
       D:= Datasets[I];
       LogRequete( D);
       end;
     fAccueil_Execute;
end;

procedure TdmBatpro_DataModule.ClientDatasetReconcileError( DataSet: TCustomClientDataSet;
                                                            E: EReconcileError;
                                                            UpdateKind: TUpdateKind;
                                                            var Action: TReconcileAction);
begin
     inherited;
     {$IFDEF MSWINDOWS}
     Action:= HandleReconcileError( Dataset, UpdateKind, E);
     {$ENDIF}
end;

initialization
              {$IFNDEF FPC}
              uUseCase.Ouvre_Modules_LoginProc:= Ouvre_Modules_Login;
              {$ENDIF}
              pLogin:= TPublieur.Create('udmBatpro_DataModule.pLogin');
finalization
              Free_nil( pLogin);
              {$IFNDEF FPC}
              uUseCase.Ouvre_Modules_LoginProc:= nil;
              {$ENDIF}
end.
