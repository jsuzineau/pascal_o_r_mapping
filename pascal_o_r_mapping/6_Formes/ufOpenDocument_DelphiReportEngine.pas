unit ufOpenDocument_DelphiReportEngine;

{$MODE Delphi}

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    uOD_Forms,
    uODRE_Table,
    uOD_TextTableContext,
    uOD_Dataset_Columns,
    uOD_Dataset_Column,
    uOOoStrings,
    uOOoStringList,
    uOpenDocument,
    uhdODRE_Table,
    uhVST_ODR,
    uVide,

    Zipper ,
    DOM,
    uOOoChrono, 
    ucChampsGrid, ucChamp_Lookup_ComboBox, ucChamp_Edit, ucDockableScrollbox,
    uLog,

    ublODRE_Table,
    ublOD_Dataset_Columns,

    uhdmOpenDocument_DelphiReportEngine_Test,
    uodOpenDocument_DelphiReportEngine_Test,

    udkODRE_Table,

    ufXML_Editor,
    ufFields_vle,
    ufTextFile,
    ufFields_vstInsertion,
    ufFields_vstTables   ,

  LCLIntf, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, ValEdit, Registry,
  Spin,LCLType, Menus, VirtualTrees,XMLWrite,XMLRead,StrUtils;

type
 { TfOpenDocument_DelphiReportEngine }

 TfOpenDocument_DelphiReportEngine
 =
  class(TForm)
   bDecalerChampsApresColonne: TButton;
   bInsererColonne: TButton;
   bSupprimerColonne: TButton;
   ceTitre: TChamp_Edit;
   clkcbNomChamp: TChamp_Lookup_ComboBox;
   dsbODRE_Table: TDockableScrollbox;
   Label2: TLabel;
   Label3: TLabel;
   miNormal: TMenuItem;
   miNormal_Insertion: TMenuItem;
   miMode_Expert: TMenuItem;
   miInsertion: TMenuItem;
   miTables: TMenuItem;
   miMIMETYPE: TMenuItem;
   miFormatNatif: TMenuItem;
   miChamps: TMenuItem;
   miOutils: TMenuItem;
   miCree_Test: TMenuItem;
   miVoir_XML: TMenuItem;
   mixmlStyles: TMenuItem;
   mixmlContent: TMenuItem;
   mixmlMETA_INF_manifest: TMenuItem;
   mixmlSettings: TMenuItem;
   mixmlMeta: TMenuItem;
   miVoir: TMenuItem;
   mm: TMainMenu;
    odODF: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    sgODRE_Table: TStringGrid;
    speDecalerChampsApresColonne_Numero: TSpinEdit;
    speInsererColonne_Numero: TSpinEdit;
    tShow: TTimer;
    gbBranche_Insertion: TGroupBox;
    bSupprimer_Insertion: TButton;
    procedure dsbODRE_TableSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormShow(Sender: TObject);
    procedure miCree_TestClick(Sender: TObject);
    procedure miFormatNatifClick(Sender: TObject);
    procedure miInsertionClick(Sender: TObject);
    procedure miNormal_InsertionClick(Sender: TObject);
    procedure miMIMETYPEClick(Sender: TObject);
    procedure miTablesClick(Sender: TObject);
    procedure mixmlContentClick(Sender: TObject);
    procedure mixmlMetaClick(Sender: TObject);
    procedure mixmlMETA_INF_manifestClick(Sender: TObject);
    procedure mixmlSettingsClick(Sender: TObject);
    procedure mixmlStylesClick(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bSupprimerColonneClick(Sender: TObject);
    procedure bInsererColonneClick(Sender: TObject);
    procedure bDecalerChampsApresColonneClick(Sender: TObject);
  //Affichage des XML
  private
    fxmleMeta             : TfXML_Editor;
    fxmleSettings         : TfXML_Editor;
    fxmleMETA_INF_manifest: TfXML_Editor;
    fxmleContent          : TfXML_Editor;
    fxmleStyles           : TfXML_Editor;
  //Affichage des champs
  public
    fFields_vle: TfFields_vle;
  //Affichage du type mime
  public
    fMIMETYPE: TfTextFile;
  //Affichage en arbres
  public
    fFields_vstInsertion:TfFields_vstInsertion;
    fFields_vstTables   :TfFields_vstTables   ;
    procedure fFields_vstInsertion_Show;
    procedure fFields_vstTables_Show;
  //Attributs et méthodes privés généraux
  private
    Embedded: Boolean; //pour distinguer l'appel par Execute de l'affichage comme fiche principale
    Document: TOpenDocument;
    procedure Affiche_XMLs;
    procedure From_Document;
  //Visiteurs des Fields du Document
  public
    procedure Document_Fields_Visitor_for_ODRE_Table     ( _Name, _Value: String);
    procedure Document_Fields_Visitor_for_Traite_Tables  ( _Name, _Value: String);//détection des datasets dans les tables
    procedure Document_Fields_Visitor_for_Traite_Datasets( _Name, _Value: String);//détection des champs dans les datasets
  //Gestion de l'ouverture
  public
    procedure Ouvre( _NomDocument: String);
    procedure Ferme;
  //Méthodes générales
  public
    function Execute( _NomDocument: String): Boolean;
  //Inscription dans la base de registre
  private
    procedure Enregistre_Extension;
  //Gestion des ODRE_Tables
  public
   OD_TextTableContext: TOD_TextTableContext;
   slT: TslODRE_Table;
   blODRE_Table: TblODRE_Table;
   hd: ThdODRE_Table;
  //Gestion des VST
  public
    hvsti: ThVST_ODR;
  end;

var
   //seulement utile dans le projet OpenDocument_DelphiReportEngine.dpr
   //ailleurs utiliser ufOpenDocument_DelphiReportEngine_Execute ci dessous
   fOpenDocument_DelphiReportEngine: TfOpenDocument_DelphiReportEngine= nil;

function ufOpenDocument_DelphiReportEngine_Execute( _NomDocument: String): Boolean;

implementation

{$R *.lfm}

function ufOpenDocument_DelphiReportEngine_Execute( _NomDocument: String): Boolean;
var
   F: TfOpenDocument_DelphiReportEngine;
begin
     Result:= False;
     F:= TfOpenDocument_DelphiReportEngine.Create( nil);
     try
        Result:= F.Execute( _NomDocument);
     finally
            FreeAndNil( F);
            end;
end;

{ TfOpenDocument_DelphiReportEngine }

procedure TfOpenDocument_DelphiReportEngine.FormCreate(Sender: TObject);
begin
     Document:= nil;
     OD_TextTableContext:= nil;
     blODRE_Table:= nil;

     Embedded:= False;
     slT:= TslODRE_Table.Create( Classname+'.slT');
     hd:= ThdODRE_Table.Create( 1, sgODRE_Table, 'hdODRE_Table');

     hd.clkcbNomChamp:=  clkcbNomChamp;
     hd.ceTitre      :=  ceTitre;

     dsbODRE_Table.Classe_dockable:= TdkODRE_Table;
     dsbODRE_Table.Classe_Elements:= TblODRE_Table;
end;

procedure TfOpenDocument_DelphiReportEngine.FormDestroy(Sender: TObject);
begin
     Free_nil( hd);
     Detruit_StringList( slT);
     Ferme;
end;

procedure TfOpenDocument_DelphiReportEngine.FormShow(Sender: TObject);
begin
     if Embedded then exit;

     Enregistre_Extension;

     if ParamCount > 0
     then
         Ouvre( ParamStr( 1))
     else
         tShow.Enabled:= True;
end;

procedure TfOpenDocument_DelphiReportEngine.miCree_TestClick(Sender: TObject);
var
   hdm: ThdmOpenDocument_DelphiReportEngine_Test;
   opendialog: TodOpenDocument_DelphiReportEngine_Test;
begin
     hdm:= ThdmOpenDocument_DelphiReportEngine_Test.Create;
     try
        hdm.Execute;
        opendialog:= TodOpenDocument_DelphiReportEngine_Test.Create;
        try
           opendialog.Init( hdm);
           opendialog.Editer_Modele_Impression;
        finally
               FreeAndNil( opendialog);
               end;
     finally
            FreeAndNil( hdm);
            end;
end;

procedure TfOpenDocument_DelphiReportEngine.miFormatNatifClick(Sender: TObject); begin Assure_fFields_vle( fFields_vle, Document).Show; end;

procedure TfOpenDocument_DelphiReportEngine.fFields_vstInsertion_Show; begin Assure_fFields_vstInsertion( fFields_vstInsertion, miInsertion.Caption, Document).Show; end;
procedure TfOpenDocument_DelphiReportEngine.fFields_vstTables_Show   ; begin Assure_fFields_vstTables   ( fFields_vstTables   , miTables   .Caption, Document).Show; end;
procedure TfOpenDocument_DelphiReportEngine.miInsertionClick       (Sender: TObject);begin fFields_vstInsertion_Show;end;
procedure TfOpenDocument_DelphiReportEngine.miNormal_InsertionClick(Sender: TObject);begin fFields_vstInsertion_Show;end;
procedure TfOpenDocument_DelphiReportEngine.miTablesClick          (Sender: TObject);begin fFields_vstTables_Show   ;end;

procedure TfOpenDocument_DelphiReportEngine.mixmlMetaClick             (Sender: TObject); begin Assure_fXML_Editor( fxmleMeta             ,'Meta'             , Document, @Document.xmlMeta             ).Show; end;
procedure TfOpenDocument_DelphiReportEngine.mixmlSettingsClick         (Sender: TObject); begin Assure_fXML_Editor( fxmleSettings         ,'Settings'         , Document, @Document.xmlSettings         ).Show; end;
procedure TfOpenDocument_DelphiReportEngine.mixmlMETA_INF_manifestClick(Sender: TObject); begin Assure_fXML_Editor( fxmleMETA_INF_manifest,'META_INF_manifest', Document, @Document.xmlMETA_INF_manifest).Show; end;
procedure TfOpenDocument_DelphiReportEngine.mixmlContentClick          (Sender: TObject); begin Assure_fXML_Editor( fxmleContent          ,'Content'          , Document, @Document.xmlContent          ).Show; end;
procedure TfOpenDocument_DelphiReportEngine.mixmlStylesClick           (Sender: TObject); begin Assure_fXML_Editor( fxmleStyles           ,'Styles'           , Document, @Document.xmlStyles           ).Show; end;

procedure TfOpenDocument_DelphiReportEngine.miMIMETYPEClick(Sender: TObject); begin Assure_fTextFile( fMIMETYPE, 'mimetype', Document.CheminFichier_temporaire( 'mimetype')).Show; end;

procedure TfOpenDocument_DelphiReportEngine.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;

     //odODF.InitialDir:= '\\linuxm\p\tmp';
     //odODF.InitialDir:= 'C:\2_source\03_Batpro_Editions\00_bin\modeles_np\';
     odODF.InitialDir:= '\\Linuxm\a\modeles_oo_hollywood';
     odODF.DefaultExt:= 'ott';
     odODF.FileName:= 'DEV*.ott';
     if odODF.Execute
     then
         Ouvre( odODF.FileName);
end;

procedure TfOpenDocument_DelphiReportEngine.Ouvre( _NomDocument: String);
begin
     Ferme;

     OOoChrono.Start;
     Document:= TOpenDocument.Create( _NomDocument);

     fxmleMeta             := nil;
     fxmleSettings         := nil;
     fxmleMETA_INF_manifest:= nil;
     fxmleContent          := nil;
     fxmleStyles           := nil;
     fFields_vle           := nil;
     fMIMETYPE             := nil;
     fFields_vstInsertion  := nil;
     fFields_vstTables     := nil;

     OD_TextTableContext:= TOD_TextTableContext.Create( Document);

     Caption:= ExtractFileName( Document.Nom);

     Document.pChange.Abonne( Self, From_Document);
     From_Document;
end;

procedure TfOpenDocument_DelphiReportEngine.Ferme;
begin
     if Document = nil then exit;

     FreeAndNil( fxmleMeta             );
     FreeAndNil( fxmleSettings         );
     FreeAndNil( fxmleMETA_INF_manifest);
     FreeAndNil( fxmleContent          );
     FreeAndNil( fxmleStyles           );
     FreeAndNil( fFields_vle           );
     FreeAndNil( fMIMETYPE             );
     FreeAndNil( fFields_vstInsertion  );
     FreeAndNil( fFields_vstTables     );

     if idYes
        =
        MessageDlg( 'Voulez vous enregistrer les modifications ?',
                    mtConfirmation, [mbYes, mbNo], 0)
     then
         Document.Save;

     Document.pChange.Desabonne( Self, From_Document);
     FreeAndNil( OD_TextTableContext);
     FreeAndNil( Document);
     Caption:= 'OpenDocument_DelphiReportEngine';
end;

function TfOpenDocument_DelphiReportEngine.Execute( _NomDocument: String): Boolean;
begin
     Embedded:= True;
     Ouvre( _NomDocument);
     try
        Result:= inherited ShowModal = mrOK;
     finally
            Ferme;
            end;
end;

var
   sys_Racine_Champ          : String= 'com.sun.star.text.FieldMaster.User.';
   sys_Racine_Champ_UpperCase: String= 'COM.SUN.STAR.TEXT.FIELDMASTER.USER.';
   
function FieldName_from_FieldPathName( _FieldPathName: String): String;
begin
     Result:= Copy( _FieldPathName, Length( sys_Racine_Champ)+1, Length( _FieldPathName));
end;

function FieldPathName_from_FieldName( _FieldName    : String): String;
begin
     Result:= sys_Racine_Champ+_FieldName;
end;

procedure TfOpenDocument_DelphiReportEngine.Affiche_XMLs;
begin
     if Assigned( fxmleMeta             ) then fxmleMeta             ._from_xml;
     if Assigned( fxmleSettings         ) then fxmleSettings         ._from_xml;
     if Assigned( fxmleMETA_INF_manifest) then fxmleMETA_INF_manifest._from_xml;
     if Assigned( fxmleContent          ) then fxmleContent          ._from_xml;
     if Assigned( fxmleStyles           ) then fxmleStyles           ._from_xml;
end;

procedure TfOpenDocument_DelphiReportEngine.From_Document;
begin
     OOoChrono.Stop('Début From_Document');
     Affiche_XMLs;

     if Assigned( fFields_vle         ) then fFields_vle         ._from_od;
     if Assigned( fFields_vstInsertion) then fFields_vstInsertion._from_od;
     if Assigned( fFields_vstTables   ) then fFields_vstTables   ._from_od;

     Document.Fields_Visite( Document_Fields_Visitor_for_ODRE_Table);
     OOoChrono.Stop('avant Document.Fields_Visite( Document_Fields_Visitor_for_Traite_Tables);');
     Document.Fields_Visite( Document_Fields_Visitor_for_Traite_Tables);
     OOoChrono.Stop('avant boucle Document.Fields_Visite( Document_Fields_Visitor_for_Traite_Datasets);');
     Document.Fields_Visite( Document_Fields_Visitor_for_Traite_Datasets);

     OOoChrono.Stop( 'Affichage des TextFields');

     dsbODRE_Table.sl:= slT;
     dsbODRE_Table.Goto_Premier;
end;

procedure TfOpenDocument_DelphiReportEngine.Document_Fields_Visitor_for_ODRE_Table(_Name, _Value: String);
var
   Nom_ODRE_Table: String;
   function Is_NbColonnes: Boolean;
   const
        sNbColonnes= '_NbColonnes';
   var
      iNbColonnes: Integer;
   begin //Test si se termine par NbColonnes
        iNbColonnes:= Pos( sNbColonnes, _Name);
        Result:= iNbColonnes = Length( _Name)-Length(sNbColonnes)+1;
        if Result
        then
            Nom_ODRE_Table:= Copy( _Name, 2, iNbColonnes-2)
        else
            Nom_ODRE_Table:= '';
   end;
   procedure Ajoute_ODRE_Table;
   var
      bl: TblODRE_Table;
   begin
        bl:= TblODRE_Table.Create( slT, nil, nil);
        bl.Charge( Nom_ODRE_Table, OD_TextTableContext);
        slT.AddObject( bl.sCle, bl);
   end;
begin
     if 1 <> Pos( '_', _Name) then exit;
     if not Is_NbColonnes   then exit;

     Ajoute_ODRE_Table;
end;

procedure TfOpenDocument_DelphiReportEngine.Document_Fields_Visitor_for_Traite_Tables( _Name, _Value: String);
const
     sAvant_Composition='_avant_composition';
     lAvant_Composition=Length(sAvant_Composition);
var
   I: TIterateur_ODRE_Table;
   bl: TblODRE_Table;
   Prefixe: String;
   iAvant_Composition: Integer;
   iPos: Integer;
begin
     if 1 <> Pos( '_', _Name) then exit;

     I:= slT.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl)     then continue;

       Prefixe:= '_'+bl.Nom+'_';
       if 1 <> Pos( Prefixe, _Name) then continue;

       {
       if 0<pos('avant', lowercase(Nom))
       then
           ShowMessage( 'avant');
       }
       Delete( _Name, 1, Length(Prefixe));
       iAvant_Composition:= Length( _Name)-lAvant_Composition+1;
       if iAvant_Composition <= 0    then continue;
       iPos:= Pos(sAvant_Composition, lowercase(_Name));
       if iAvant_Composition <> iPos then continue;

       Delete( _Name, iAvant_Composition, lAvant_Composition);
       //Log.PrintLn( 'TfOpenDocument_DelphiReportEngine.From_Document::Traite_Tables; Nom= '+Nom);
       bl.haOD_Dataset_Columns.AddDataset( _Name, OD_TextTableContext);
       end;
end;

procedure TfOpenDocument_DelphiReportEngine.Document_Fields_Visitor_for_Traite_Datasets( _Name, _Value: String);
     procedure Traite_Dataset( _blODRE_Table: TblODRE_Table);
     var
        I: TIterateur_OD_Dataset_Columns;
        bl: TblOD_Dataset_Columns;
        Prefixe: String;
        function not_Traite_Avant: Boolean;
        const
             sAvant='Avant_';
             lAvant=Length( sAvant);
        var
           DCs: TOD_Dataset_Columns;
           NomAvant: String;
           DC: TOD_Dataset_Column;
        begin
             Result:= True;
             if 1 <> Pos( sAvant, _Name) then exit;

             Result:= False;
             Delete( _Name, 1, lAvant);

             DCs:= bl.DCs;
             DC:= DCs.AssureAvant( _Name);
             if nil = DC then exit;

             NomAvant:= DCs.Nom_Avant( '_'+_blODRE_Table.Nom+'_'+Prefixe);
             DC.from_Doc( NomAvant+'_', OD_TextTableContext);
        end;
        function not_Traite_Apres: Boolean;
        const
             sApres='Apres_';
             lApres=Length( sApres);
        var
           DCs: TOD_Dataset_Columns;
           NomApres: String;
           DC: TOD_Dataset_Column;
        begin
             Result:= True;
             if 1 <> Pos( sApres, _Name) then exit;

             Result:= False;
             Delete( _Name, 1, lApres);

             DCs:= bl.DCs;
             DC:= DCs.AssureApres( _Name);
             if nil = DC then exit;

             NomApres:= DCs.Nom_Apres( '_'+_blODRE_Table.Nom+'_'+Prefixe);
             DC.from_Doc( NomApres+'_', OD_TextTableContext);
        end;
     begin
          I:= _blODRE_Table.haOD_Dataset_Columns.Iterateur;
          while I.Continuer
          do
            begin
            if I.not_Suivant( bl)     then continue;

            Prefixe:= bl.Nom+'_';
            if 1 <> Pos( Prefixe, _Name) then continue;

            Delete( _Name, 1, Length(Prefixe));

            if   not_Traite_Avant
            then not_Traite_Apres;

            bl.haAvant.Charge;
            bl.haApres.Charge;
            end;
     end;
const
     sDebut='_debut';
     lDebut=Length(sDebut);
var
   I: TIterateur_ODRE_Table;
   bl: TblODRE_Table;
   Prefixe: String;
   iDebut: Integer;
   iPos: Integer;
begin
     I:= slT.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl)     then continue;

       Prefixe:= '_'+bl.Nom+'_';
       if 1 <> Pos( Prefixe, _Name) then continue;

       Delete( _Name, 1, Length(Prefixe));
       iDebut:= Length( _Name)-lDebut+1;
       iPos:= Pos(sDebut, lowercase(_Name));
       if iDebut <> iPos then continue;

       Delete( _Name, iDebut, lDebut);
       Traite_Dataset( bl);
       end;
end;

procedure TfOpenDocument_DelphiReportEngine.FormCloseQuery( Sender: TObject;
                                                            var CanClose: Boolean);
begin
     Ferme;
end;

procedure TfOpenDocument_DelphiReportEngine.FormDropFiles(Sender: TObject;
 const FileNames: array of String);
begin
     if Length( FileNames) = 0 then exit;
     Ouvre( FileNames[0]);
end;

procedure TfOpenDocument_DelphiReportEngine.Enregistre_Extension;
const
     //extension= '.ott';
     extension_modele= 'opendocument.WriterTemplate.1';
     extension_texte = 'opendocument.WriterDocument.1';
     extension_feuille = 'opendocument.CalcDocument.1';
     extension_modele_feuille = 'opendocument.CalcTemplate.1';

var
   r: TRegistry;
   Failed: Boolean;
   procedure T( _extension: String);
   var
      Key, Value: String;
   begin
        if Failed then exit;

        //verbe OpenDocument_DelphiReportEngine
        Key:= '\'+_extension+'\shell\OpenDocument_DelphiReportEngine\command';
        Value:= '"'+Application.ExeName+'" "%1"';

        try
           if not r.OpenKey( Key, True)
           then
               begin
               //MessageDlg( 'Echec de l''ouverture de la clé '+Key, mtError, [mbOK], 0);
               Failed:= True;
               exit;
               end;

           r.WriteString( '', Value);
        except
              on E: ERegistryException
              do
                begin
                Failed:= True;
                MessageDlg( 'Echec de l''inscription dans la base de registre '#13#10
                           +'pour accés avec le bouton droit de la souris '#13#10
                           +'sur un document Open document'#13#10
                           +'dans l''explorateur de fichiers.'#13#10
                           +'Peut-être que vous devriez exécuter '
                           +'le programme en temps qu''administrateur.'#13#10
                           +E.Message, mtError, [mbOK], 0);
                end;
              end;
   end;
begin
     Failed:= False;
     r:= TRegistry.Create;
     try
        r.RootKey:= HKEY_CLASSES_ROOT;
        T( extension_modele);
        T( extension_texte );
        T( extension_feuille);
        T( extension_modele_feuille);
     finally
            FreeAndNil( r);
            end;
end;

procedure TfOpenDocument_DelphiReportEngine.dsbODRE_TableSelect(Sender: TObject);
var
   I: Integer;
begin
     dsbODRE_Table.Get_bl( blODRE_Table);
     if nil = blODRE_Table then exit;

     hd.blODRE_Table:= blODRE_Table;
     hd._from_pool;
end;

procedure TfOpenDocument_DelphiReportEngine.bSupprimerColonneClick( Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     hd.Supprimer_Colonne( OD_TextTableContext);
end;

procedure TfOpenDocument_DelphiReportEngine.bInsererColonneClick( Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     ShowMessage('à déboguer');
     blODRE_Table.T.InsererColonneApres(speInsererColonne_Numero.Value);
     blODRE_Table.T.To_Doc( OD_TextTableContext);
end;

procedure TfOpenDocument_DelphiReportEngine.bDecalerChampsApresColonneClick(
  Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     ShowMessage('à déboguer');
     blODRE_Table.T.DecalerChampsApresColonne(speDecalerChampsApresColonne_Numero.Value);
     blODRE_Table.T.To_Doc( OD_TextTableContext);
end;

end.


