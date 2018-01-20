unit uWinUtils;

// Copyright (C) Jean SUZINEAU 1997, 2017

interface

uses
    uForms,
    uClean,
    ufAccueil_Erreur,
    uBatpro_StringList,
    u_sys_,
    uuStrings,

  Classes,
  System.UITypes,
  FMX.Graphics, FMX.Controls, FMX.Menus,
  //FMX.CheckLst,
  System.SysUtils,
  {$IFDEF MSWINDOWS}
  Windows,
  ShlObj, ActiveX,
  {$ENDIF}
  FMX.StdCtrls, FMX.ExtCtrls, FMX.Consts, FMX.TextLayout, System.Types, System.IOUtils;

function sGetLastError: String;

procedure TraiteLastError( Messag: String);

{$IFDEF MSWINDOWS}
function SelectionnneRepertoire( Parent: HWnd;
                                 Titre: String; var Path: String): Boolean;
{$ENDIF}

procedure Enable_MenuItem( MenuItem: TMenuItem; Enabled: Boolean);

procedure Concat_Espace( var S1: String; S2, Espace: String);

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
function LineHeight( _F: TFont): Single;

function HauteurTexte  ( _F: TFont; _S: String; _Largeur: Single): Single;
function HauteurTexte_2( _F: TFont; _S: String; _Largeur: Single): Single;
function LargeurTexte  ( _F: TFont; _S: String                  ): Single;

function NbChars( _F: TFont; _Width: Single): Integer;

procedure Aligne_Sommet( Source, Cible: TControl);

function Try_ShortPathName( var Path: String): Boolean;

{ TCheckListBox existe seulement en VCL, pas en FMX
procedure CheckAll( cb: TCheckListBox);
procedure UnCheckAll( cb: TCheckListBox);
procedure Check( cb: TCheckListBox; C: array of integer; C0: Integer = 0);
}
{
type TControlProc = procedure ( C: TControl);
procedure EnumereControls( W: TWinControl; Proc: TControlProc);
}
function Panel_from_sl( sl: TBatpro_StringList; I: Integer): TPanel;


//code à reprendre pour FMX
{
procedure uWinUtils_Control_Color( Color: TColor; FMX.Controls: array of TControl);
}
function uWinUtils_RepertoireTemporaire: String;

function MulDiv( _Value, _Numerateur, _Denominateur: Integer):Integer; overload;

function MulDiv( _Value, _Numerateur, _Denominateur: Single):Single; overload;

implementation

{ uWinUtils }

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
var
//   Fonte: HFont;
   fnWeight: Integer;
   fdwPitchAndFamily: Cardinal;
begin
     if Orientation = 0 then exit;

     //code à reprendre pour FMX
     {
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
     }
end;

function HauteurTexte( _F: TFont; _S: String; _Largeur: Single): Single;
var
   tl: TTextLayout;
   MaxSize: TPointF;
begin
     Result:= 0;
     if sys_Vide = _S then exit;

     MaxSize:= TTextLayout.MaxLayoutSize;
     MaxSize.X:= _Largeur;

     tl:= TTextLayoutManager.DefaultTextLayout.Create;
     try
        tl.BeginUpdate;
        tl.TopLeft := TPointF.Create(0, 0);
        tl.MaxSize := MaxSize;
        tl.WordWrap:= True;
        tl.Font.Assign( _F);
        tl.Text:= _S;
        Result:= tl.Height;
     finally
            FreeAndNil( tl);
            end;
end;

function LargeurTexte( _F: TFont; _S: String): Single;
var
   tl: TTextLayout;
   sl: TBatpro_StringList;
   I:Integer;
   w, Max: Single;
begin
     Result:= 0;
     if sys_Vide = _S then exit;

     tl:= TTextLayoutManager.DefaultTextLayout.Create;
     try
        tl.Font.Assign( _F);
        //Impossible de gérer l'orientation de la fonte ici
        //GetTextExtentPoint32, appelé par TextWidth, ne le gère pas
        sl:= TBatpro_StringList.Create;
        try
           sl.Text:= _S;
           Max:= 0;
           for I:= 0 to sl.Count-1
           do
             begin
             tl.Text:= sl.Strings[I];
             w:= tl.Width;
             if w > Max then Max:= w;
             end;
           Result:= Max;
        finally
               FreeAndnil( sl);
               end;
     finally
            FreeAndNil( tl);
            end;
end;

function LineHeight( _F: TFont): Single;
var
   tl: TTextLayout;
begin
     tl:= TTextLayoutManager.DefaultTextLayout.Create;
     try
        tl.BeginUpdate;
        tl.Font.Assign( _F);
        tl.Text:= 'Wg';
        Result:= tl.Height;
     finally
            FreeAndNil( tl);
            end;
end;

function HauteurTexte_2( _F: TFont; _S: String; _Largeur: Single): Single;
var
   sl: TStringList;
   I: Integer;
   sLigne, sInsert: String;
   Old_Length: Integer;
   LS: Integer;
begin
     sl:= TStringList.Create;
     try
        sl.Text:= _S;
        I:= 0;
        while I < sl.Count
        do
          begin
          sLigne:= sl[I];
          sInsert:= '';
          while LargeurTexte( _F, sLigne) > _Largeur
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
        _S:= sl.Text;
        LS:= Length( _S);
        if     (LS > 2)
           and (_S[LS-1]= #13)
           and (_S[LS  ]= #10)
        then
            Delete( _S, LS-1, 2);

        Result:= HauteurTexte( _F, _S, _Largeur);
     finally
            Free_nil( sl);
            end;
end;

function NbChars( _F: TFont; _Width: Single): Integer;
var
   tl: TTextLayout;
   TextWidth: Single;
   TW: Single;
begin
     tl:= TTextLayoutManager.DefaultTextLayout.Create;
     try
        tl.BeginUpdate;
        tl.Font.Assign( _F);
        TextWidth:= _Width-tl.Padding.Left-tl.Padding.Right;
        tl.Text:= 'W';
        TW:= tl.Width;
     finally
            FreeAndNil( tl);
            end;
     if TW = 0
     then
         Result:= 1
     else
         Result:= Trunc( TextWidth / TW);
end;

function sGetLastError: String;
begin
     Result:= SysErrorMessage( GetLastError);
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

{$IFDEF MSWINDOWS}
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
   bi: TBrowseInfoA;
   pIIL: PItemIDList;
   malloc: IMalloc;
   Display: PChar;
begin
     //code à reprendre pour FMX
     {
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
     }
end;
{$ENDIF}
{ version Apple OSX, source: http://jed-software.com/blog/?p=538
uses MacApi.AppKit, MacApi.Foundation, Macapi.CocoaTypes;
function SelectDirectory(const ATitle: string; var ADir: string): Boolean;
var
  LOpenDir: NSOpenPanel;
  LInitialDir: NSURL;
  LDlgResult: NSInteger;
begin
  Result := False;
  LOpenDir := TNSOpenPanel.Wrap(TNSOpenPanel.OCClass.openPanel);
  LOpenDir.setAllowsMultipleSelection(False);
  LOpenDir.setCanChooseFiles(False);
  LOpenDir.setCanChooseDirectories(True);
  if ADir <> '' then
  begin
    LInitialDir := TNSURL.Create;
    LInitialDir.initFileURLWithPath(NSSTR(ADir));
    LOpenDir.setDirectoryURL(LInitialDir);
  end;
  if ATitle <> '' then
    LOpenDir.setTitle(NSSTR(ATitle));
  LOpenDir.retain;
  try
    LDlgResult := LOpenDir.runModal;
    if LDlgResult = NSOKButton then
    begin
      ADir := string(TNSUrl.Wrap(LOpenDir.URLs.objectAtIndex(0)).relativePath.UTF8String);
      Result := True;
    end;
  finally
    LOpenDir.release;
  end;
end;
}
procedure Enable_MenuItem( MenuItem: TMenuItem; Enabled: Boolean);
var
   I: Integer;
   Count: Integer;
begin
     //code à reprendre pour FMX
     {
     Count:= MenuItem.Count;
     if Count = 0
     then
         MenuItem.Enabled:= Enabled and Assigned( MenuItem.OnClick)
     else
         for I:= 0 to Count-1
         do
           Enable_MenuItem( MenuItem.Items[I], Enabled);
     }
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
     //code à reprendre pour FMX
     {
     P:= PointF( Source.Left, Source.Top);
     P:= Source.Parent.ClientToScreen( P);
     P:= Cible.Parent.ScreenToClient( P);
     Cible.Top := P.Y;
     }
end;

{$IFNDEF MSWINDOWS}
function Try_ShortPathName( var Path: String): Boolean;
begin
     Result:= True;
end;
{$ELSE}
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
{$ENDIF}
//code à reprendre pour FMX
{
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
       C:= W.FMX.Controls[ I];
       if Assigned( C)
       then
           Proc( C);
       end;
end;
}
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

//code à reprendre pour FMX
{
procedure uWinUtils_Control_Color( Color: TColor; FMX.Controls: array of TControl);
var
   I: Integer;
   C: TControl;
begin
     for I:= Low( FMX.Controls) to High( FMX.Controls)
     do
       begin
       C:= FMX.Controls[I];
            if C is TEdit     then TEdit    (C).Color:= Color
       else if C is TComboBox then TComboBox(C).Color:= Color;
       C.Refresh;
       end;
end;
}

function uWinUtils_RepertoireTemporaire: String;
begin
     Result:= System.IOUtils.TPath.GetTempPath;
end;

function MulDiv( _Value, _Numerateur, _Denominateur: Integer):Integer; overload;
begin
     Result:= (_Value * _Numerateur) div _Denominateur;
end;

function MulDiv( _Value, _Numerateur, _Denominateur: Single):Single; overload;
begin
     Result:= (_Value * _Numerateur) / _Denominateur;
end;


end.






