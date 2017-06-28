unit ublG_BECPCTX;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    uBatpro_StringList,
    u_sys_,
    uClean,
    uuStrings,
    uDataUtilsU,
    uDrawInfo,
    u_db_Formes,
    u_ini_Formes,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
  {$IFNDEF FPC}
  Windows, Graphics, 
  {$ENDIF}
  SysUtils, Classes, DB;

type
 TblG_BECPCTX
 =
  class( TBatpro_Ligne)
  private
    procedure Fonte_Defaut;
    procedure Font_from_StringList;
    procedure StringList_from_Font;
  protected
  public
    NomClasse  : String;
    Contexte   : Integer;
    sLogFont   : String;
    Font       : TFont ;
    sStringList: String;
    StringList : TBatpro_StringList;
    Sauver     : Boolean;
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    constructor Create_New( unNomClasse: String);
    destructor Destroy; override;
    //procedure To_Q;
    procedure Save_to_database; override;
  //Gestion de la clé
  public
    class function sCle_from_( _nomclasse: String; _contexte: Integer): String;

    function sCle: String; override;
  //Flag de fonte non affectée
  public
    Is_Fonte_Defaut: Boolean;
  end;

var
   Fonte_Arial_8: TFont;
   blClasse_TBatpro_Element: TblG_BECPCTX= nil;

function blG_BECPCTX_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_BECPCTX;
function blG_BECPCTX_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_BECPCTX;

implementation

function blG_BECPCTX_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_BECPCTX;
begin
     _Classe_from_sl( Result, TblG_BECPCTX, sl, Index);
end;

function blG_BECPCTX_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_BECPCTX;
begin
     _Classe_from_sl_sCle( Result, TblG_BECPCTX, sl, sCle);
end;

{ TblG_BECPCTX }

procedure TblG_BECPCTX.Fonte_Defaut;
begin
     Is_Fonte_Defaut:= True;
     {$IFNDEF FPC}
     Font.Assign( Fonte_Arial_8);
     {$ELSE}
     {$ENDIF}
end;

procedure TblG_BECPCTX.Font_from_StringList;
var
   Couleur: Integer;
begin
     {$IFNDEF FPC}
     if TryStrToInt( StringList.Values[ inik_CouleurTexte], Couleur)
     then
         Font.Color:= Couleur;
     {$ELSE}
     {$ENDIF}

end;

procedure TblG_BECPCTX.StringList_from_Font;
begin
     {$IFNDEF FPC}
     StringList.Values[ inik_CouleurTexte]:= '$'+IntToHex( Font.Color, 4);
     {$ELSE}
     {$ENDIF}
end;

constructor TblG_BECPCTX.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
   {$IFNDEF FPC}
   LogFont: TLogFont;
   {$ENDIF}
   Taille_LogFont: Integer;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'ligne de la table g_becpctx';
         {$IFNDEF FPC}
         CP.Font.Name:= sys_SmallFonts;
         CP.Font.Size:= 6;
         {$ELSE}
         {$ENDIF}
         end;

     inherited Create( _sl, _jsdc, _pool);

     if Assigned( Champs.ChampDefinitions)
     then
         Champs.ChampDefinitions.NomTable:= 'g_becpctx';
     Champs. String_from_String ( NomClasse, dbf_nomclasse);
     //Trim rajouté à cause du curieux comportement de dbExpress
     NomClasse:= Trim( NomClasse);
     Champs.Integer_from_Integer( Contexte , dbf_contexte );

     //Champ fonte
     Champs.String_from_Blob( sLogFont, dbf_logfont);
     Font:= TFont.Create;

     {$IFNDEF FPC}
     Taille_LogFont:= SizeOf( LogFont);
     if Length( sLogFont) <> Taille_LogFont
     then
         Fonte_Defaut
     else
         begin
         Move( sLogFont[1], LogFont, Taille_LogFont);
         (*Font.Handle:= CreateFontIndirect( LogFont);*)
         Is_Fonte_Defaut:= False;
         end;
     {$ENDIF}

     //Champ StringList
     Champs.String_from_Memo( sStringList, dbf_stringlist);
     StringList:= TBatpro_StringList.Create;
     StringList.Text:= sStringList;

     Font_from_StringList;

end;

constructor TblG_BECPCTX.Create_New( unNomClasse: String);
begin
     inherited Create( nil, nil, nil);
     Font:= TFont.Create;
     StringList:= TBatpro_StringList.Create;

     NomClasse:= unNomClasse;
     Fonte_Defaut;
end;

destructor TblG_BECPCTX.Destroy;
begin
     //if Sauver
     //then
     //    To_Q;
     Free_nil( StringList);
     Free_nil( Font);
     inherited;
end;

//procedure TblG_BECPCTX.To_Q;
//var
//   LogFont: TLogFont;
//begin
//     if not Q.Locate( dbf_nomclasse, NomClasse, []) then exit;
//
//     StringList_from_Font;
//
//     GetObject( Font.Handle, SizeOf(LogFont), @LogFont);
//     sStringList:= StringList.Text;
//     if sStringList = sys_Vide
//     then
//         sStringList:= ' ';
//
//     uDataUtilsU.Edite( Q);
//     Set_StringField( dbf_nomclasse , NomClasse);
//     Set_BlobField  ( dbf_logfont   , LogFont       , SizeOf(LogFont));
//     Set_BlobField  ( dbf_stringlist, sStringList[1], Length(sStringList));
//     uDataUtilsU.Poste( Q);
//end;

procedure TblG_BECPCTX.Save_to_database;
{$IFNDEF FPC}
var
   LogFont: TLogFont;
   Taille_LogFont: Integer;
{$ENDIF}
begin
     Champs.ChampDefinitions.NomTable:= 'g_becpctx';

     StringList_from_Font;

     {$IFNDEF FPC}
     Taille_LogFont:= SizeOf( LogFont);
     //Champ fonte
     (*GetObject( Font.Handle, Taille_LogFont, @LogFont);*)
     SetLength( sLogFont, Taille_LogFont);
     Move( LogFont, sLogFont[1], Taille_LogFont);
     {$ENDIF}
     //Champ StringList
     sStringList:= StringList.Text;
     if sStringList = sys_Vide
     then
         sStringList:= ' ';

     inherited;
end;

class function TblG_BECPCTX.sCle_from_( _nomclasse: String; _contexte: Integer): String;
begin
     Result:= Fixe_Length( _nomclasse, 50)+IntToStr(_contexte);
end;

function TblG_BECPCTX.sCle: String;
begin
     Result:= sCle_from_( NomClasse, Contexte);
end;

initialization
              Fonte_Arial_8:= TFont.Create;
              Fonte_Arial_8.Name:= sys_Arial;
              Fonte_Arial_8.Size:= 8;
finalization
              Free_nil( Fonte_Arial_8);
end.
