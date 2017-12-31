unit uOD;
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
    uOD_Forms,
    uLog,
    uForms,
    uEXE_INI,
    {$IFNDEF FPC}
    JclSimpleXml,
	  uUNO_DeskTop,
 	  uUNO_PropertyValue,
    {$ELSE}
	  DOM,
    {$ENDIF}
    uVersion,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uClean,
    uTri,
    uChamp,
    uChamps,
    uVide,
    uBatpro_Ligne,
    uOOoStrings,
    uINI_Batpro_OD_Report,
    uOD_Temporaire,
    uOpenDocument,

    ufAccueil_Erreur,
    {$IFDEF FPC}
    fglExt,
    {$ENDIF}

    {$IFNDEF FPC}
    ufOOo_NomFichier_Modele,
    ufOpenDocument_DelphiReportEngine,
    ufMailTo,
    ufMEL,
    Windows,Controls,Dialogs,Variants, ComObj, Menus,
    {$ENDIF}

  SysUtils, Classes, DB, Types;

type
 {$IFDEF FPC}
 TMenuItem= TObject;
 {$ENDIF}
 TOD_Menu_Click_Proc= procedure ( mi: TMenuItem) of object;
 TOD
 =
  class
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Répertoires
  private
    function Custom: String;
    function Standard: String;
  //Test du prefixe
  public
    Prefixe_Repertoire,
    Prefixe_Masque,
    Prefixe_Resultat: String;
    function Repertoire_Prefixe_Existe( Repertoire, Prefixe: String; Le_prefixe_est_le_nom: Boolean= False): Boolean; virtual;
    function Prefixe_Existe( Prefixe: String; Le_prefixe_est_le_nom: Boolean= False): Boolean; virtual;
  protected
    function Extension_Modele: String; virtual;
  //Gestion du nom de fichier
  protected
    function NomFichier_Modele_interne( Prefixes: array of String; Le_prefixe_est_le_nom: Boolean= False; _Creer: Boolean= False): String;
    function NomFichier_Modele_Surcharge( _Creer: Boolean= False): String; virtual;
  public
    function NomFichier_Modele( _Creer: Boolean= False): String;
  //Actions
  protected
    function  Editer_Modele_Impression_interne: String; virtual;
    function  Composer: String; virtual;
    function  Visualiser_interne: String; virtual;
    procedure Imprimer_interne( _NbExemplaires: Integer); virtual;
  public
    function  Editer_Modele_Impression: String;
    function  Visualiser              : String;
    procedure Imprimer( _NbExemplaires: Integer= 1);

    function  Action( c: Char  ): String; overload;virtual; 
    function  Action( s: String): String; overload;
  //Gestion état
  protected
    ReadOnly: Boolean;
    TitreEtat: String;
    ParametresNoms, ParametresValeurs: array of String;
    procedure Init; virtual;
    procedure Termine; virtual;
    procedure Ajoute_Parametre( _Nom, _Valeur: String);
  //Fonctionnement par liste de modèles
  private
    function Masque_Modeles_interne: String;
  public
    Prefixe_Modeles: String;
    FNomFichier_Modele: String;
    function Masque_Modeles_np: String;
    function Masque_Modeles: String;
    function NomFichier_Nouveau( Extension: String='ott'): String; virtual;
  //Fonctionnement par numéro de modèle
  public
    NumeroModele: String;
  //Gestion des images
  public
    logo: String;// nomfichier image pour image "logo", si vide => plogo
    procedure Traite_image( document: String; ODImage, NomFichierImage: String);
    procedure Traite_Logos( document: String);
  //PopupMenu pour choisir directement un modèle
  private
    RacineMenu: TMenuItem;
    OD_Menu_Click_Proc: TOD_Menu_Click_Proc;
    procedure MenuItemClick( Sender:TObject);
  public
    procedure Accroche_Menu( _RacineMenu: TMenuItem;
                             _OD_Menu_Click_Proc: TOD_Menu_Click_Proc);
    procedure Decroche_Menu;
  //Personnalisable
  public
    Personnalisable: Boolean;
  //Envoi par mail
  protected
    procedure SendMail( _Document: String);
  public
    SendMail_Active: Boolean;
    SendMail_To     ,
    SendMail_Subject,
    SendMail_Body   ,
    SendMail_G_MEL_fonction: String;
    SendMail_Attachments: TStringDynArray;
    procedure SendMail_Add_Attachment( _Attachment: String);
  //Prévisualisation
  public
    Previsualiser: Boolean;
  //Impression
  public
    NbExemplaires: Integer;
  end;

const
     sys_modeles_np= 'modeles_np';

function uOD_repertoire_standard: String;

implementation

function uOD_repertoire_standard: String;
var
   Repertoire_racine: String;
begin
     Repertoire_racine:= uClean_Racine_from_EXE( uOD_Forms_EXE_Name);

     Result:= Repertoire_racine+PathDelim+sys_modeles_np+PathDelim;
     Log.PrintLn( 'Résultat uOD_repertoire_standard : '+ Result);
end;

{ TOD }

constructor TOD.Create;
begin
     inherited;
     Personnalisable:= True;
     FNomFichier_Modele:= sys_Vide;
     NumeroModele:= sys_Vide;
     logo:= '';
     Previsualiser:= False;
     NbExemplaires:= 1;
     //Init;
end;

destructor TOD.Destroy;
begin
     inherited;
end;

procedure TOD.Init;
var
   Cartouche: String;
begin
     SendMail_Active:= False;
     SendMail_To     := '';
     SendMail_Subject:= '';
     SendMail_Body   := '';
     SendMail_G_MEL_fonction:= '';
     SetLength( SendMail_Attachments, 0);

     TitreEtat:= sys_Vide;
     SetLength( ParametresNoms   , 0);
     SetLength( ParametresValeurs, 0);

     Ajoute_Parametre( 'Batpro_Editions_GED_OD_Emetteur',
                       ExtractFilePath( uOD_Forms_EXE_Name)
                       +'Batpro_Editions_GED_OD_Emetteur.exe');

     Cartouche
     :=
         //'Modèle: <désactivé>'// + NomFichier_Modele
         'Modèle: ' + NomFichier_Modele
       + ', version: '+ GetVersionProgramme
       {$IFNDEF FPC}+ ', '+poolG_PAM.version_V6{$ENDIF};
     Ajoute_Parametre( 'Cartouche', Cartouche);
end;

procedure TOD.SendMail_Add_Attachment( _Attachment: String);
var
   NewLength, iFin, I: Integer;
begin
     NewLength:= Length(SendMail_Attachments)+1;
     iFin:= NewLength-1;
     SetLength( SendMail_Attachments, NewLength);
     for I:= High(SendMail_Attachments) downto 1
     do
       SendMail_Attachments[I]:= SendMail_Attachments[I-1];

     SendMail_Attachments[0]:= _Attachment;
end;

function TOD.Repertoire_Prefixe_Existe( Repertoire, Prefixe: String;
                                        Le_prefixe_est_le_nom: Boolean= False): Boolean;
var
   F: TSearchRec;
   Erreur: Integer;
begin
     Prefixe_Repertoire:= Repertoire;
     if Le_prefixe_est_le_nom
     then
         Prefixe_Masque:= Prefixe_Repertoire + Prefixe+ '.'+Extension_Modele
     else
         Prefixe_Masque:= Prefixe_Repertoire + Prefixe+'*.'+Extension_Modele;

     Erreur:= SysUtils.FindFirst( Prefixe_Masque, faAnyFile, F);
     Result:= Erreur = 0;
     if Result
     then
         begin
         Prefixe_Resultat:= Prefixe_Repertoire + F.Name;
         SysUtils.FindClose( F);
         end;
end;

function TOD.Prefixe_Existe( Prefixe: String;
                              Le_prefixe_est_le_nom: Boolean= False): Boolean;
var
   Custom, Standard: String;
begin
     Custom:= INI_Batpro_OD_Report.Repertoire_Modeles;
     Standard:= uOD_repertoire_standard;

     if Personnalisable
     then
         Result:= Repertoire_Prefixe_Existe( Custom  , Prefixe, Le_prefixe_est_le_nom)
     else
         Result:= False;

     if not Result
     then
         Result:= Repertoire_Prefixe_Existe( Standard, Prefixe, Le_prefixe_est_le_nom);
end;

function TOD.Custom: String;
begin
     Result:= INI_Batpro_OD_Report.Repertoire_Modeles;
end;

function TOD.Standard: String;
begin
     Result:= uOD_repertoire_standard;
end;

function TOD.NomFichier_Nouveau( Extension: String='ott'): String;
var
   Prefixe_Repertoire: String;
begin
     if Personnalisable
     then
         Prefixe_Repertoire:= Custom
     else
         Prefixe_Repertoire:= Standard;

     Result:= Prefixe_Repertoire + Prefixe_Modeles+'_Nouveau.'+Extension;
end;

function TOD.NomFichier_Modele_interne( Prefixes: array of String; Le_prefixe_est_le_nom: Boolean= False; _Creer: Boolean= False): String;
var
   I: Integer;
   Trouve: Boolean;
   RacinePrefixe,
   Prefixe,
   Suffixe: String;

begin
     Trouve:= False;

     for I:= Low( Prefixes) to High( Prefixes)
     do
       if Le_prefixe_est_le_nom
       then
           begin
           Trouve:= Prefixe_Existe( Prefixes[ I], Le_prefixe_est_le_nom); if Trouve then break;
           end
       else
           begin
           {$IFDEF LINUX}
           if '?' = NumeroModele
           then
               RacinePrefixe:= Prefixes[ I]+'*'
           else
               RacinePrefixe:= Prefixes[ I]+NumeroModele;
           {$ELSE}
           RacinePrefixe:= Prefixes[ I]+NumeroModele;
           {$ENDIF}

           Prefixe:= RacinePrefixe;
           Trouve:= Prefixe_Existe( Prefixe); if Trouve then break;
           end;

     if Trouve
     then
         Result:= Prefixe_Resultat
     else if _Creer
     then
         begin
         if    (NumeroModele = '?')
            or Le_prefixe_est_le_nom
         then
             Suffixe:= sys_Vide
         else
             Suffixe:= NumeroModele;
         {$IFNDEF FPC}
         fOOo_NomFichier_Modele.Execute( Prefixe_Masque, Suffixe);
         {$ENDIF}
         Result:= Prefixe_Repertoire+Prefixes[High( Prefixes)]+Suffixe+'.ott';
         end
     else
         Result:= '';
end;

function TOD.NomFichier_Modele_Surcharge( _Creer: Boolean= False): String;
begin
     if NumeroModele = sys_Vide
     then
         begin
         Result:= FNomFichier_Modele;
         if     (Result = sys_vide)
            and _Creer
         then

             if uForms_Message_Yes( 'Confirmation',
                             'Pas de nom de modèle spécifié.'+sys_N
                            +'Voulez vous créer un nouveau modèle ?'+sys_N
                            +'Personnalisables dans : '+Custom+sys_N
                            +'Non personnalisables dans : '+Standard+sys_N
                            +'Préfixe : '+Prefixe_Modeles+sys_N)
             then
                 Result:= NomFichier_Nouveau;
         end
     else
         Result:= NomFichier_Modele_interne( [Prefixe_Modeles],False, _Creer);
end;

function TOD.NomFichier_Modele( _Creer: Boolean= False): String;
begin
     Result:= NomFichier_Modele_Surcharge( _Creer);
     fAccueil_Log( 'function TOD.NomFichier_Modele: String; => >'+Result+'<');
end;

procedure TOD.Termine;
begin

end;

function TOD.Editer_Modele_Impression_interne: String;
begin

end;

procedure TOD.Imprimer_interne( _NbExemplaires: Integer);
var
   //impression
   NomFichier: String;
   F: Variant;
   PrintOptions: Variant;
   Listener: Variant;
   LastState: Integer;
begin
     {$IFNDEF FPC}
     PrintOptions:= VarArrayCreate([0, 0], varVariant);
     uUNO_PropertyValue_Set( PrintOptions, 0, 'CopyCount', _NbExemplaires);

     NomFichier:= Composer;

     F:= UNO_DeskTop.OpenFile( NomFichier, True, False);
     Listener:= CreateOleObject( 'dllOOoDelphiReportEngineAutomation.UNOPrintJobListener');
     F.addPrintJobListener( Listener);

     F.Print( PrintOptions);

     LastState:= 0;
     while LastState < 1
     do
       begin
       uOD_Forms_ProcessMessages;
       LastState:= Listener.LastState;
       end;

     if not Previsualiser then F.Close( True);
     {$ENDIF}
end;

function TOD.Composer: String;
begin

end;

function TOD.Editer_Modele_Impression: String;
begin
     Result:= Editer_Modele_Impression_interne;
     if not FileExists( Result) then exit;
     {$IFNDEF FPC}
     ufOpenDocument_DelphiReportEngine_Execute( Result);
     {$ENDIF}
     ShowURL( Result);
     Termine;
end;

procedure TOD.Imprimer( _NbExemplaires: Integer= 1);
var
   NFM: String;
begin
     NFM:= NomFichier_Modele;
     if not FileExists( NFM)
     then
         begin
         if NFM = ''
         then
             NFM:= Prefixe_Masque;
         Modele_inexistant( NFM);
         exit;
         end;
     Imprimer_interne( _NbExemplaires);

     (* non codé pour l'instant,
        nécessiterait de modifier Imprimer_interne en fonction retournant le document
     if SendMail_Active
     then
         SendMail( Result);
     *)

     Termine;
end;

function TOD.Visualiser: String;
var
   dwFileAttributes: Cardinal;
begin
     Result:= NomFichier_Modele;
     if not FileExists( Result)
     then
         begin
         if Result = ''
         then
             Result:= Prefixe_Masque;
         Modele_inexistant( Result);
         exit;
         end;
     Result:= Visualiser_interne;

     //dwFileAttributes:= FILE_ATTRIBUTE_TEMPORARY;
     //if ReadOnly
     //then
     //    dwFileAttributes:= dwFileAttributes or FILE_ATTRIBUTE_READONLY;
     //SetFileAttributes( PChar( Result), dwFileAttributes);

     {$IFNDEF FPC}
     if ReadOnly
     then
         begin
         dwFileAttributes:= FILE_ATTRIBUTE_READONLY;
         SetFileAttributes( PChar( Result), dwFileAttributes);
         end;
     {$ENDIF}
     Termine;

     if SendMail_Active
     then
         SendMail( Result);

     if Previsualiser and (Result <> '')
     then
         ShowURL( Result);

     Log.PrintLn( classname+'.Visualiser: Result= '+result);
end;

function TOD.Visualiser_interne: String;
begin
     Result:= Composer;
end;

function TOD.Action( c: Char): String;
begin
     Result:= sys_Vide;
     case c
     of
       'M': Result:= Editer_Modele_Impression;
       //'V': Result:= Visualiser;
       'I': Imprimer( NbExemplaires);
       'V','G':
         begin
         Result:= Visualiser;
         end;
       end;
     Log.PrintLn( classname+'.Action: Result= '+result);
end;

function  TOD.Action( s: String): String;
   procedure Cas_Vide;
   begin
        Result:= Visualiser;
   end;
   procedure Cas_SendMail;
   begin
        Delete( s, 1, Length('SENDMAIL')+1);//en principe syntaxe SENDMAIL=truc@troc.com
        SendMail_Active:= True;
        if s <> ''
        then
            SendMail_To:= s;
        Result:= Visualiser;
   end;
   (*
   procedure Cas_ISendMail;
   begin
        Delete( s, 1, Length('ISENDMAIL')+1);//en principe syntaxe ISENDMAIL=truc@troc.com
        SendMail_Active:= True;
        SendMail_To:= s;
        Result:= Null;
        Imprimer;
   end;
   *)
   procedure Cas_Defaut;
   begin
        Result:= Action( s[1]);
   end;
begin
     s:= UpperCase(s);
          if s = sys_Vide             then Cas_Vide
     else if 1 = Pos( 'SENDMAIL' , s) then Cas_SendMail
     //else if 1 = Pos( 'ISENDMAIL', s) then Cas_ISendMail
     else                                  Cas_Defaut;
    Log.PrintLn( classname+'.Action(S:String): Result= '+Result);
end;

function TOD.Masque_Modeles_interne: String;
begin
     {$IFNDEF FPC}
     Result:= Prefixe_Modeles +'*.ot?';
     {$ELSE}
     Result:= Prefixe_Modeles +'*.ot*';
     {$ENDIF}
end;

function TOD.Masque_Modeles_np: String;
begin
     Result:= uOD_repertoire_standard+Masque_Modeles_interne;
end;

function TOD.Masque_Modeles: String;
begin
     {$IFNDEF FPC}
     Result
     :=
        INI_Batpro_OD_Report.Repertoire_Modeles
       +Masque_Modeles_interne;
     {$ELSE}
     Result:='/a/modeles_oo_miradec/'+Masque_Modeles_interne;
     {$ENDIF}
end;

procedure TOD.Traite_image( document: String; ODImage, NomFichierImage: String);
var
   OD: TOpenDocument;
   urlImage: String;
   procedure TI_Root( _eRoot: TJclSimpleXMLElem);
   var
      eDF, eDI: TJclSimpleXMLElem;
   begin
        eDF:= OD.Cherche_Item( _eRoot, 'draw:frame', ['draw:name'], [ODImage]);
        if Assigned( eDF)
        then
            begin
            eDI:= OD.Cherche_Item_Recursif( eDF, 'draw:image', [], []);
            if Assigned( EDI)
            then
                OD.Set_Property( eDI, 'xlink:href', urlImage);
            end;
   end;
   procedure TI;
   begin
        TI_Root( OD.Get_xmlContent_TEXT);
        TI_Root( OD.Get_xmlStyles_MASTER_STYLES);
   end;
begin
     if NomFichierImage = '' then exit;

     {$IFNDEF FPC}
     urlImage:= UNO_DeskTop.URL_from_WindowsFileName( NomFichierImage);
     {$ELSE}
     urlImage:= '';
     {$ENDIF}
     OD:= TOpenDocument.Create( document);
     try
        TI;
     finally
            OD.Save;
            end;
end;

procedure TOD.Traite_Logos( document: String);
var
   NomFichierLogo: String;
   OD: TOpenDocument;
   procedure TI_Root( _eRoot: TJclSimpleXMLElem; ODImage, NomFichierImage: String);
   var
      eDF, eDI: TJclSimpleXMLElem;
      urlImage: String;
   begin
        {$IFNDEF FPC}
        urlImage:= UNO_DeskTop.URL_from_WindowsFileName( NomFichierImage);
        {$ELSE}
        urlImage:= '';
        {$ENDIF}
        eDF:= OD.Cherche_Item_Recursif( _eRoot, 'draw:frame', ['draw:name'], [ODImage]);
        if Assigned( eDF)
        then
            begin
            eDI:= OD.Cherche_Item( eDF, 'draw:image', [], []);
            if Assigned( EDI)
            then
                OD.Set_Property( eDI, 'xlink:href', urlImage);
            end;
   end;
   procedure TI( ODImage, NomFichierImage: String);
   begin
        TI_Root( OD.Get_xmlContent_TEXT        , ODImage, NomFichierImage);
        TI_Root( OD.Get_xmlStyles_MASTER_STYLES, ODImage, NomFichierImage);
   end;
begin
     OD:= TOpenDocument.Create( document);
     try
        {$IFNDEF FPC}
        (*if logo = ''
        then
            NomFichierLogo:= poolG_PAR.plogo
        else
            NomFichierLogo:= logo;
        TI(  'logo'  , NomFichierLogo );
        TI( 'plogo'  , poolG_PAR.plogo);
        TI( 'glogo'  , poolG_PAR.glogo);
        TI( 'dlogo'  , poolG_PAR.dlogo);
        TI( 'flogo'  , poolG_PAR.flogo);
        TI( 'alogo'  , poolG_PAR.alogo);
        TI( 'zlogo'  , poolG_PAR.zlogo);
        TI( 'testdxf', '\\linuxm\p\schuco\EWDATA45\DXF\8281B.dxf')*)
        {$ENDIF}
     finally
            OD.Save;
            end;
end;

procedure TOD.Ajoute_Parametre(_Nom, _Valeur: String);
begin
     SetLength( ParametresNoms   , Length( ParametresNoms   )+1);
     SetLength( ParametresValeurs, Length( ParametresValeurs)+1);

     ParametresNoms   [ High( ParametresNoms   )]:= _Nom   ;
     ParametresValeurs[ High( ParametresValeurs)]:= _Valeur;
end;

procedure TOD.MenuItemClick(Sender: TObject);
{$IFNDEF FPC}
var
   mi: TMenuItem;
begin
     if not Assigned(RacineMenu     ) then exit;

     if not (Sender is TMenuITem)     then exit;
     mi:= TMenuItem( Sender);

     NumeroModele:= sys_Vide;
     FNomFichier_Modele
     :=
         INI_Batpro_OD_Report.Repertoire_Modeles
       + Prefixe_Modeles
       + Enleve( mi.Caption, '&')+'.ott';

     if Assigned( OD_Menu_Click_Proc)
     then
         OD_Menu_Click_Proc( mi);
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TOD.Accroche_Menu( _RacineMenu: TMenuItem;
                              _OD_Menu_Click_Proc: TOD_Menu_Click_Proc);
{$IFNDEF FPC}
var
   F: TSearchRec;
   procedure Ajoute( _NomFichier: String);
   var
      mi: TMenuItem;
      mi_Caption: String;
   begin
        mi_Caption:= ChangeFileExt( ExtractFileName(_NomFichier), sys_Vide);
        StrToK( Prefixe_Modeles, mi_Caption);//on enlève le préfixe

        mi:= TMenuItem.Create( RacineMenu);
        mi.Caption:= mi_Caption;
        mi.OnClick:= MenuItemClick;
        RacineMenu.Add( mi);
   end;
begin
     RacineMenu         := _RacineMenu;
     RacineMenu         .Clear;
     OD_Menu_Click_Proc:= _OD_Menu_Click_Proc;

     if 0 = SysUtils.FindFirst( Masque_Modeles, faAnyFile, F)
     then
         begin
         repeat
               Ajoute( F.Name);
         until 0 <> SysUtils.FindNext( F);
         SysUtils.FindClose( F);
         end;
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TOD.Decroche_Menu;
{$IFNDEF FPC}
begin
     if RacineMenu = nil then exit;

     RacineMenu.Clear;
     RacineMenu:= nil;
     OD_Menu_Click_Proc:= nil;
end;
{$ELSE}
begin
end;
{$ENDIF}

function TOD.Extension_Modele: String;
begin
     Result:= 'ott';
end;

procedure TOD.SendMail( _Document: String);
var
   NomfichierPDF: String;
begin
     {$IFNDEF FPC}
     NomfichierPDF:= UNO_DeskTop.Save_as_PDF( _Document);
     SendMail_Add_Attachment( NomfichierPDF);

     if SendMail_G_MEL_fonction <> ''
     then
         fMEL.Execute( SendMail_G_MEL_fonction,
                       SendMail_To,
                       SendMail_Subject,
                       SendMail_Attachments,
                       Previsualiser,
                       SendMail_Body
                       )
     else
         fMailTo.Execute( SendMail_To,
                          SendMail_Subject,
                          SendMail_Body,
                          SendMail_Attachments,
                          Previsualiser);
     {$ENDIF}
end;

initialization
finalization
end.
