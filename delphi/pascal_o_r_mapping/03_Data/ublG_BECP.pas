unit ublG_BECP;
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
//BECP:   Batpro_ElementClassParams;

interface

uses
    uBatpro_StringList,
    u_sys_,
    u_db_Formes,
    uClean,
    uDrawInfo,
    uuStrings,
    uDataUtilsU,
    uChampDefinitions,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
  {$IFDEF MSWINDOWS}
  FMX.Graphics, FMX.Dialogs,
  {$ENDIF} 
  SysUtils, Classes, DB;

type
 TblG_BECP
 =
  class( TBatpro_Ligne)
  private
    procedure Fonte_Defaut;
    procedure CreeObjets;
  protected
    FNomClasse: String;
    FLibelle    : String;
    FFont     : TFont ;

    FSauver   : Boolean;
    FEditeur: IBatpro_Element_Editeur;
    function GetCell( Contexte: Integer): String; override;
  public
    function GetLibelle    : String; override;
  protected
    function GetNomClasse: String;
    function GetContexteFont( Contexte: Integer): TFont ;
    function GetFont: TFont ;
    function GetSauver   : Boolean;
    function GetEditeur: IBatpro_Element_Editeur;

    procedure SetLibelle    (Value: String );
    procedure SetNomClasse(Value: String );
    procedure SetSauver   (Value: Boolean);
    procedure SetEditeur( Value: IBatpro_Element_Editeur);
  public
    Is_blClasse_TBatpro_Element: Boolean; // si composant d'amorçage
    slG_BECPCTX: TBatpro_StringList;
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    constructor Create_New( unNomClasse: String);
    destructor Destroy; override;

    //pas trés propre,ces propriétés sont également définies sur l'interface
    property NomClasse: String  read GetNomClasse write SetNomClasse;
    property Libelle    : String  read GetLibelle     write SetLibelle    ;
    property Sauver   : Boolean read GetSauver    write SetSauver   ;
    property Editeur: IBatpro_Element_Editeur read GetEditeur write SetEditeur;

    procedure Edit_ContexteFont( Contexte: Integer);
  //Gestion de la clé
  public
    class function sCle_from_( _nomclasse: String): String;
    function sCle: String; override;
  //BECP: Batpro_ElementClassParams
  //alternative à l'interface IblG_BECP utilisée précédemment
  //jeu de méthodes seulement définies dans TblG_BECP
  public
    function BECP_GetNomClasse: String; override;
    function BECP_GetLibelle  : String; override;
    function BECP_GetContexteFont( Contexte: Integer): TFont ; override;
    function BECP_GetFont: TFont ; override;
    function BECP_GetSauver   : Boolean; override;
    function BECP_GetEditeur: IBatpro_Element_Editeur; override;

    procedure BECP_SetNomClasse(Value: String ); override;
    procedure BECP_SetLibelle  (Value: String ); override;
    procedure BECP_SetSauver   (Value: Boolean); override;
    procedure BECP_SetEditeur( Value: IBatpro_Element_Editeur); override;

    procedure BECP_Edit_ContexteFont( Contexte: Integer); override;

    procedure BECP_Save_to_database; override;
  //Persistance SQL
  public
    procedure Save_to_database; override;
  end;

var
   Fonte_Arial_8: TFont;

function blG_BECP_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_BECP;
function blG_BECP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_BECP;

implementation

uses
    ublG_BECPCTX,
    upoolG_BECPCTX;

function blG_BECP_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_BECP;
begin
     _Classe_from_sl( Result, TblG_BECP, sl, Index);
end;

function blG_BECP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_BECP;
begin
     _Classe_from_sl_sCle( Result, TblG_BECP, sl, sCle);
end;

{ TblG_BECP }

procedure TblG_BECP.Fonte_Defaut;
begin
     FFont.Assign( Fonte_Arial_8);
end;

constructor TblG_BECP.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create( _sl, _q, _pool);

     CreeObjets;

     Champs.ChampDefinitions.NomTable:= 'g_becp';

     Champs.String_from_String( FNomClasse, dbf_nomclasse);
     //Trim rajouté à cause du curieux comportement de dbExpress
     FNomClasse:= Trim( FNomClasse);
     Champs.String_from_String( FLibelle, dbf_libelle);

     Fonte_Defaut;

     Is_blClasse_TBatpro_Element:= False;

     FEditeur:= nil;

     poolG_BECPCTX.Charge_Classe( NomClasse, slG_BECPCTX);
end;

constructor TblG_BECP.Create_New( unNomClasse: String);
begin
     inherited Create( nil, nil, nil);

     CreeObjets;

     FNomClasse:= unNomClasse;
     FLibelle    := FNomClasse;
     Fonte_Defaut;
     Is_blClasse_TBatpro_Element:= False;
end;

procedure TblG_BECP.CreeObjets;
begin
     slG_BECPCTX:= TBatpro_StringList.Create;
     slG_BECPCTX.Sorted:= True;

     FFont:= TFont.Create;
end;

destructor TblG_BECP.Destroy;
begin
     if not Is_blClasse_TBatpro_Element
     then   //blClasse_TBatpro_Element ne peut être enregistré (amorçage)
         if FSauver
         then
             Save_to_database;
     Free_nil( FFont);

     Free_nil( slG_BECPCTX);
     inherited;
end;

function TblG_BECP.GetCell( Contexte: Integer): String;
begin
     Result:= FLibelle;
end;

function TblG_BECP.GetLibelle  :String ;begin Result:=FLibelle  ;end;
function TblG_BECP.GetNomClasse:String ;begin Result:=FNomClasse;end;
function TblG_BECP.GetSauver   :Boolean;begin Result:=FSauver   ;end;

procedure TblG_BECP.SetLibelle  (Value:String );begin FLibelle  :=Value;end;
procedure TblG_BECP.SetNomClasse(Value:String );begin FNomClasse:=Value;end;
procedure TblG_BECP.SetSauver   (Value:Boolean);begin FSauver   :=Value;end;

function TblG_BECP.GetContexteFont( Contexte: Integer):TFont;
{$IFDEF MSWINDOWS}
var
   sContexte: String;
   blG_BECPCTX: TblG_BECPCTX;
{$ENDIF}
begin
     {$IFDEF MSWINDOWS}
     sContexte:= IntToStr( Contexte);
     blG_BECPCTX:= blG_BECPCTX_from_sl_sCle( slG_BECPCTX, sContexte);
     if blG_BECPCTX = nil
     then
         begin
         blG_BECPCTX:= poolG_BECPCTX.Get_by_Cle( NomClasse, Contexte);
         if Assigned( blG_BECPCTX)
         then
             begin
             slG_BECPCTX.AddObject( sContexte, blG_BECPCTX);
             if blG_BECPCTX.Is_Fonte_Defaut
             then
                 blG_BECPCTX.Font.Assign( FFont);
             end;
         end;

     if Assigned( blG_BECPCTX)
     then
         Result:= blG_BECPCTX.Font
     else
     {$ENDIF}
         Result:=FFont;
end;

procedure TblG_BECP.Edit_ContexteFont( Contexte: Integer);
{$IFDEF MSWINDOWS}
var
   sContexte: String;
   blG_BECPCTX: TblG_BECPCTX;
   Fonte_a_editer: TFont;
   FontDialog: TFontDialog;
begin
     sContexte:= IntToStr( Contexte);
     blG_BECPCTX:= blG_BECPCTX_from_sl_sCle( slG_BECPCTX, sContexte);
     if blG_BECPCTX = nil
     then
         begin
         blG_BECPCTX:= poolG_BECPCTX.Get_by_Cle( NomClasse, Contexte);
         if Assigned( blG_BECPCTX)
         then
             begin
             slG_BECPCTX.AddObject( sContexte, blG_BECPCTX);
             blG_BECPCTX.Font.Assign( FFont);
             end;
         end;

     if Assigned( blG_BECPCTX)
     then
         Fonte_a_editer:= blG_BECPCTX.Font
     else
         Fonte_a_editer:=FFont;

     FontDialog:= TFontDialog.Create( nil);
     try
        FontDialog.Font:= Fonte_a_editer;
        if FontDialog.Execute
        then
            begin
            Fonte_a_editer.Assign( FontDialog.Font);
            if Assigned( blG_BECPCTX)
            then
                blG_BECPCTX.Save_to_database;
            Sauver:= True;
            Save_to_database;
            end;
     finally
            Free_nil( FontDialog);
            end;
end;
{$ELSE}
begin
end;
{$ENDIF}

function TblG_BECP.GetFont:TFont;
begin
     Result:=FFont;
end;

function TblG_BECP.GetEditeur: IBatpro_Element_Editeur;
begin
     Result:= FEditeur;
end;

procedure TblG_BECP.SetEditeur(Value: IBatpro_Element_Editeur);
begin
     FEditeur:= Value;
end;

class function TblG_BECP.sCle_from_(_nomclasse: String): String;
begin                      // pas de FixeLength :
     Result:=  _nomclasse; // doit correspondre exactement au ClassName
end;

function TblG_BECP.sCle: String;
begin
     Result:= sCle_from_( FNomClasse);
end;

function TblG_BECP.BECP_GetNomClasse: String;
begin
     Result:= GetNomClasse;
end;

function TblG_BECP.BECP_GetLibelle: String;
begin
     Result:= GetLibelle;
end;

function TblG_BECP.BECP_GetContexteFont(Contexte: Integer): TFont;
begin
     Result:= GetContexteFont( Contexte);
end;

function TblG_BECP.BECP_GetFont: TFont;
begin
     Result:= GetFont;
end;

function TblG_BECP.BECP_GetSauver: Boolean;
begin
     Result:= GetSauver;
end;

function TblG_BECP.BECP_GetEditeur: IBatpro_Element_Editeur;
begin
     Result:= GetEditeur;
end;

procedure TblG_BECP.BECP_SetNomClasse(Value: String);
begin
     SetNomClasse( Value);
end;

procedure TblG_BECP.BECP_SetLibelle(Value: String);
begin
     SetLibelle( Value);
end;

procedure TblG_BECP.BECP_SetSauver(Value: Boolean);
begin
     SetSauver( Value);
end;

procedure TblG_BECP.BECP_SetEditeur(Value: IBatpro_Element_Editeur);
begin
     SetEditeur( Value);
end;

procedure TblG_BECP.BECP_Edit_ContexteFont(Contexte: Integer);
begin
     Edit_ContexteFont( Contexte);
end;

procedure TblG_BECP.BECP_Save_to_database;
begin
     Save_to_database;
end;

procedure TblG_BECP.Save_to_database;
begin
     if Is_blClasse_TBatpro_Element then exit;

     inherited;
end;

initialization
              Fonte_Arial_8:= TFont.Create;
              Fonte_Arial_8.Name:= sys_Arial;
              Fonte_Arial_8.Size:= 8;
finalization
              Free_nil( Fonte_Arial_8);
end.
