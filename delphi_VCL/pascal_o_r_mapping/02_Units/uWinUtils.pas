unit uWinUtils;

// Copyright (C) Jean SUZINEAU 1997, 2000

interface

uses
    uForms,
    uClean,
    ufAccueil_Erreur,
    uBatpro_StringList,
    u_sys_,
    uuStrings,

  Classes,
  Windows,
  System.UITypes,
  VCL.Graphics, VCL.Controls, VCL.Menus,
  VCL.CheckLst,
  SysUtils,
  ShlObj, ActiveX, VCL.StdCtrls, VCL.ExtCtrls, VCL.Consts;

function sGetLastError: String;

procedure TraiteLastError( Messag: String);

function SelectionnneRepertoire( Parent: HWnd;
                                 Titre: String; var Path: String): Boolean;

procedure Enable_MenuItem( MenuItem: TMenuItem; Enabled: Boolean);

procedure Concat_Espace( var S1: String; S2, Espace: String);

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
function LineHeight( F: TFont): Integer;

function HauteurTexte( F: TFont; S: String; Largeur: Integer): Integer;
function HauteurTexte_2( F: TFont; S: String; Largeur: Integer): Integer;
function LargeurTexte( F: TFont; S: String                  ): Integer;

function NbChars( F: TFont; Width: Integer): Integer;

procedure Aligne_Sommet( Source, Cible: TControl);

function Try_ShortPathName( var Path: String): Boolean;

procedure CheckAll( cb: TCheckListBox);
procedure UnCheckAll( cb: TCheckListBox);
procedure Check( cb: TCheckListBox; C: array of integer; C0: Integer = 0);


type TControlProc = procedure ( C: TControl);
procedure EnumereControls( W: TWinControl; Proc: TControlProc);

function Panel_from_sl( sl: TBatpro_StringList; I: Integer): TPanel;


procedure uWinUtils_Control_Color( Color: TColor; _Controls: array of TControl);
function uWinUtils_RepertoireTemporaire: String;

implementation

type
 TWinUtils_Contexte
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Graphique
  public
    C: TCanvas;
    C_Font: TFont;

    procedure Init( F: TFont);
    procedure Termine;

    function DrawText_interne( S:String;var lpRect:TRect;uFormat:UINT):Integer;
    function DrawText        ( F: TFont;
                               S:String;var lpRect:TRect;uFormat:UINT):Integer;
  end;

var
   WinUtils_Contexte: TWinUtils_Contexte= nil;

{ TWinUtils_Contexte }

constructor TWinUtils_Contexte.Create;
begin
     C:= TCanvas.Create;
     C_Font:= TFont.Create;
end;

destructor TWinUtils_Contexte.Destroy;
begin
     //Graphique
     Free_nil( C_Font);
     Free_nil( C);

     inherited;
end;

procedure TWinUtils_Contexte.Init( F: TFont);
begin
     C.Handle:= GetDC(0);
     C_Font.Assign( C.Font);
     C.Font.Assign( F);
end;

procedure TWinUtils_Contexte.Termine;
begin
     C.Font.Assign( C_Font);
     ReleaseDC( 0, C.Handle);
end;

function TWinUtils_Contexte.DrawText_interne( S: String;
                                              var lpRect: TRect;
                                              uFormat: UINT): Integer;
begin
     Result:= Windows.DrawText( C.Handle, PChar(S), Length(S), lpRect, uFormat);
end;

function TWinUtils_Contexte.DrawText( F: TFont; S: String; var lpRect: TRect;
                                      uFormat: UINT): Integer;
begin
     try
        Init( F);
        Result:= DrawText_interne( S, lpRect, uFormat);
     finally
            Termine;
            end;
end;

{ uWinUtils }

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
var
   Fonte: HFont;
   fnWeight: Integer;
   fdwPitchAndFamily: Cardinal;
begin
     if Orientation = 0 then exit;

     if TFontStyle.fsBold in F.Style
     then
         fnWeight:= FW_BOLD
     else
         fnWeight:= FW_NORMAL;

     case F.Pitch
     of
       fpDefault : fdwPitchAndFamily:=  DEFAULT_PITCH;
       fpFixed   : fdwPitchAndFamily:=    FIXED_PITCH;
       fpVariable: fdwPitchAndFamily:= VARIABLE_PITCH;
       else        fdwPitchAndFamily:=  DEFAULT_PITCH;
       end;

     fdwPitchAndFamily:= fdwPitchAndFamily or FF_DONTCARE;

     Fonte:= CreateFont( Abs(F.Height), 0, Orientation, Orientation,
                         fnWeight, 0,0,0, DEFAULT_CHARSET,
                         OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                         DEFAULT_QUALITY, fdwPitchAndFamily, PChar(F.Name));
     F.Handle:= Fonte;
end;

function HauteurTexte( F: TFont; S: String; Largeur: Integer): Integer;
var
   CALCRECT: TRect;
begin
     //Impossible de gérer l'orientation de la fonte ici
     //DrawText le gére pas en DT_CALCRECT.
     //Il semble le gérer dans les autres cas.
     CALCRECT:= Rect(0,0,Largeur,0);
     WinUtils_Contexte.DrawText( F, S, CALCRECT, DT_CALCRECT or DT_WORDBREAK);
     Result:= CALCRECT.Bottom;
end;

function LargeurTexte( F: TFont; S: String): Integer;
var
   SL: TBatpro_StringList;
   I:Integer;
   W, Max: Integer;
   function LargeurLigne( S: String): Integer;
   var
      CALCRECT: TRect;
   begin
        CALCRECT:= Rect(0,0,0,0);
        WinUtils_Contexte.DrawText_interne( S, CALCRECT, DT_CALCRECT);
        Result:= CALCRECT.Right;
   end;
begin
     if S = sys_Vide
     then
         begin
         Result:= 0;
         exit;
         end;

     //Impossible de gérer l'orientation de la fonte ici
     //GetTextExtentPoint32, appelé par TextWidth, ne le gère pas
     SL:= TBatpro_StringList.Create;
       SL.Text:= S;
       try
          WinUtils_Contexte.Init( F);
          Max:= 0;
          for I:= 0 to SL.Count-1
          do
            begin
            //W:= C.TextWidth( SL.Strings[I]);
            W:= LargeurLigne( SL.Strings[I]);
            if W > Max then Max:= W;
            end;
          Result:= Max;
       finally
              WinUtils_Contexte.Termine;
              end;
     FreeAndnil( SL);
end;

function LineHeight( F: TFont): Integer;
begin
     try
        WinUtils_Contexte.Init( F);
        Result:= WinUtils_Contexte.C.TextHeight( 'Wg');
     finally
            WinUtils_Contexte.Termine;
            end;
end;

function HauteurTexte_2( F: TFont; S: String; Largeur: Integer): Integer;
var
   sl: TStringList;
   I: Integer;
   W: Integer;
   sLigne, sInsert: String;
   Old_Length: Integer;
   LS: Integer;
begin
     sl:= TStringList.Create;
     try
        sl.Text:= S;
        I:= 0;
        while I < sl.Count
        do
          begin
          sLigne:= sl[I];
          sInsert:= '';
          while LargeurTexte( F, sLigne) > Largeur
          do
            if not Wordbreak( sLigne, sInsert)
            then
                break;

          if sInsert <> ''
          then
              begin
              sl[I]:= sLigne;
              sl.Insert( I+1, sInsert);
              end;
          Inc( I);
          end;
        S:= sl.Text;
        LS:= Length( S);
        if     (LS > 2)
           and (S[LS-1]= #13)
           and (S[LS  ]= #10)
        then
            Delete( S, LS-1, 2);

        Result:= HauteurTexte( F, S, Largeur);
     finally
            Free_nil( sl);
            end;
end;

function NbChars( F: TFont; Width: Integer): Integer;
var
   TW: Integer;
begin
     try
        WinUtils_Contexte.Init( F);

        TW:= WinUtils_Contexte.C.TextWidth( 'W');
        if TW = 0
        then
            Result:= 1
        else
            Result:= Width div TW;
     finally
            WinUtils_Contexte.Termine;
            end;
end;

function sGetLastError: String;
var
   MessageSysteme: PChar;
begin
     FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                    FORMAT_MESSAGE_ALLOCATE_BUFFER,
                    nil, GetLastError,
                    0, @MessageSysteme, 0, nil);
     Result:= StrPas(MessageSysteme);
end;

procedure TraiteLastError( Messag: String);
begin
     fAccueil_Erreur( Messag + sGetLastError);
end;

(*
function GetIILfromPath( Parent: HWnd; Path: string): PItemIDList;
var
   DesktopFolder: IShellFolder;
   olePath: array[0..MAX_PATH] of WideChar;
   chEaten: ULONG;
   dwAttributes: ULONG;
begin
     if SUCCEEDED( SHGetDesktopFolder( DesktopFolder))
     then
         begin
         MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, PChar(Path), -1,
                              olePath, MAX_PATH);
         if Failed(
              DesktopFolder.ParseDisplayName( Parent,nil,olePath,
                                              chEaten,Result,dwAttributes))
         then
             Result:= nil;
         end;
end;
*)
(*
int CALLBACK BrowseCallbackProc(
    HWND hwnd,
    UINT uMsg,
    LPARAM lParam,
    LPARAM lpData
    );
*)
//function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
function BrowseCallbackProc( Wnd: HWND; uMsg: UINT; lPARAM: LPARAM;
                             lpData: LPARAM): Integer; stdcall;
begin
     Result:= 0;
     if uMsg = BFFM_INITIALIZED
     then
         PostMessage( Wnd, BFFM_SETSELECTION, 1, lpData);
end;

function SelectionnneRepertoire( Parent: HWnd; Titre: String; var Path: String): Boolean;
var
   bi: TBrowseInfo;
   pIIL: PItemIDList;
   malloc: IMalloc;
   Display: PChar;
begin
     Result:= False;
     SHGetMalloc( malloc);
     Display:= malloc.Alloc( MAX_PATH+1);
       StrPCopy( Display, Path);
       bi.hwndOwner:= Parent;
       bi.pidlRoot:= nil;//GetIILfromPath(Parent, Path);
       bi.pszDisplayName:= Display;
       bi.lpszTitle:= PChar(Titre);
       bi.ulFlags:= 0;//$0010;//BIF_EDITBOX;
       bi.lpfn:= BrowseCallbackProc;
       bi.lParam:= Integer( Display);
       bi.iImage:=0;
       pIIL:= SHBrowseForFolder( bi);
       if pIIL <> nil
       then
           begin
           if SHGetPathFromIDList( pIIL, Display)
           then
               begin
               Path:= Display;
               Result:= True;
               end;
           end;
     malloc.Free( Display);
end;

procedure Enable_MenuItem( MenuItem: TMenuItem; Enabled: Boolean);
var
   I: Integer;
   Count: Integer;
begin
     Count:= MenuItem.Count;
     if Count = 0
     then
         MenuItem.Enabled:= Enabled and Assigned( MenuItem.OnClick)
     else
         for I:= 0 to Count-1
         do
           Enable_MenuItem( MenuItem.Items[I], Enabled);
end;

procedure Concat_Espace( var S1: String; S2, Espace: String);
begin
     if S1 <> ''
     then
         if S2 <> ''
         then
             S1:= S1 + Espace;
     S1:= S1 + S2;
end;


procedure Aligne_Sommet( Source, Cible: TControl);
var
   P: TPoint;
begin
     P:= Point( Source.Left, Source.Top);
     P:= Source.Parent.ClientToScreen( P);
     P:= Cible.Parent.ScreenToClient( P);
     Cible.Top := P.Y;
end;

function Try_ShortPathName( var Path: String): Boolean;
var
   Buffer: array[0..1024] of Char;
   Longueur: Integer;
   Resultat: Cardinal;
begin
     Result:= False;
     Fillchar(Buffer, SizeOf(Buffer), 0);
     Longueur:= SizeOf(Buffer)-1;
     Resultat:= GetShortPathName( PChar(Path), @Buffer[0], Longueur);
     if     (Resultat <> 0)
        and (Resultat = StrLen( Buffer))
     then
         begin
         Path:= StrPas( Buffer);
         Result:= Pos(' ', Path) = 0;
         end;
end;

procedure CheckAll( cb: TCheckListBox);
var
   I: Integer;
begin
     for I:= 0 to cb.Count-1
     do
       cb.Checked[ I]:= True;
end;

procedure UnCheckAll( cb: TCheckListBox);
var
   I: Integer;
begin
     for I:= 0 to cb.Count-1
     do
       cb.Checked[ I]:= False;
end;

procedure Check( cb: TCheckListBox; C: array of integer; C0: Integer = 0);
var
   IC, I, Count: Integer;
begin
     UnCheckAll( cb);
     Count:= cb.Count;

     for IC:= Low(C) to High(C)
     do
       begin
       I:= C[ IC] - C0;
       if (0 <= I)and(I < Count)
       then
           cb.Checked[ I]:= True;
       end;
end;

procedure EnumereControls( W: TWinControl; Proc: TControlProc);
var
   I: Integer;
   C: TControl;
begin
     if W = nil then exit;
     if @Proc = nil then exit;

     for I:= 0 to W.ControlCount-1
     do
       begin
       C:= W.Controls[ I];
       if Assigned( C)
       then
           Proc( C);
       end;
end;
function Panel_from_sl( sl: TBatpro_StringList; I: Integer): TPanel;
var
   O: TObject;
begin
     Result:= nil;
     if I            < 0 then exit;
     if sl.Count - 1 < I then exit;

     O:= sl.Objects[ I];
     if O = nil              then exit;
     if not (O is TPanel) then exit;

     Result:= TPanel( O);
end;

procedure uWinUtils_Control_Color( Color: TColor; _Controls: array of TControl);
var
   I: Integer;
   C: TControl;
begin
     for I:= Low( _Controls) to High( _Controls)
     do
       begin
       C:= _Controls[I];
            if C is TEdit     then TEdit    (C).Color:= Color
       else if C is TComboBox then TComboBox(C).Color:= Color;
       C.Refresh;
       end;
end;


function uWinUtils_RepertoireTemporaire: String;
var
   lpstrRepertoireTemporaire: PChar;
begin
     lpstrRepertoireTemporaire:= StrAlloc( MAX_PATH);
     try
        GetTempPath( MAX_PATH, lpstrRepertoireTemporaire);
        Result:= StrPas( lpstrRepertoireTemporaire);
     finally
            StrDispose( lpstrRepertoireTemporaire);
            end;
end;

initialization
              WinUtils_Contexte:= TWinUtils_Contexte.Create;
finalization
              Free_nil( WinUtils_Contexte);
end.






