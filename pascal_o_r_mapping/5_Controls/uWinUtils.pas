unit uWinUtils;
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

// Copyright (C) Jean SUZINEAU 1997, 2000, 2013

interface

uses
    uClean,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uForms,

  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF WINDOWS_GRAPHIC}
  LCLIntf, LCLType,
  Menus, Dialogs, Graphics, Controls, CheckLst, StdCtrls, ExtCtrls, Forms,
  {$ENDIF}
  SysUtils, Classes;

{$IFDEF WINDOWS_GRAPHIC}
procedure Enable_MenuItem( MenuItem: TMenuItem; Enabled: Boolean);

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
function LineHeight( F: TFont): Integer;

function HauteurTexte( F: TFont; S: String; Largeur: Integer): Integer;
function HauteurTexte_2( F: TFont; S: String; Largeur: Integer): Integer;
function LargeurTexte( F: TFont; S: String                  ): Integer;

function NbChars( F: TFont; Width: Integer): Integer;

procedure Aligne_Sommet( Source, Cible: TControl);

procedure CheckAll( cb: TCheckListBox);
procedure UnCheckAll( cb: TCheckListBox);
procedure Check( cb: TCheckListBox; C: array of integer; C0: Integer = 0);

type TControlProc = procedure ( C: TControl);
procedure EnumereControls( W: TWinControl; Proc: TControlProc);

function Panel_from_sl( sl: TBatpro_StringList; I: Integer): TPanel;

function InputPassword(const ACaption, APrompt, ADefault: string): String;

procedure uWinUtils_Control_Color( Color: TColor; Controls: array of TControl);
{$ENDIF}

implementation

{$IFDEF WINDOWS_GRAPHIC}
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

    function DrawText_interne( S:String;var lpRect:TRect;uFormat:Word):Integer;
    function DrawText        ( F: TFont;
                               S:String;var lpRect:TRect;uFormat:Word):Integer;
  //Gestion de chargement de paquets
  private
    function Paquet_Trouve( _NomPaquet: String): Boolean;
    procedure Ajoute_Paquet( _NomPaquet: String);
  public
    slPaquets: TBatpro_StringList;
    function Paquet_Charge( _NomPaquet: String): Boolean;
  end;

var
   WinUtils_Contexte: TWinUtils_Contexte= nil;

{ TWinUtils_Contexte }

constructor TWinUtils_Contexte.Create;
begin
     C:= TCanvas.Create;
     C_Font:= TFont.Create;

     //Gestion de chargement de paquets
     slPaquets:= TBatpro_StringList.Create;
end;

destructor TWinUtils_Contexte.Destroy;
begin
     //Gestion de chargement de paquets
     Free_nil( slPaquets);

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
                                              uFormat: word): Integer;
begin
     Result:= LCLIntf.DrawText( C.Handle, PChar(S), Length(S), lpRect, uFormat);
end;

function TWinUtils_Contexte.DrawText( F: TFont; S: String; var lpRect: TRect;
                                      uFormat: word): Integer;
begin
     try
        Init( F);
        Result:= DrawText_interne( S, lpRect, uFormat);
     finally
            Termine;
            end;
end;

function TWinUtils_Contexte.Paquet_Trouve( _NomPaquet: String): Boolean;
begin
     Result:= -1 <> slPaquets.IndexOf( _NomPaquet);
end;

procedure TWinUtils_Contexte.Ajoute_Paquet(_NomPaquet: String);
begin
     if Paquet_Trouve( _NomPaquet) then exit;
     slPaquets.Add( _NomPaquet);
end;

(*function EnumModules_Callback( HInstance:Integer; Data:Pointer):Boolean;
var
   NomFichier: String;
   NomPaquet: String;
begin
     Result:= True;

     NomFichier:= GetModuleName( HInstance);
     if '.BPL' <> UpperCase( ExtractFileExt( NomFichier))  then exit;

     NomPaquet:= ChangeFileExt( ExtractFileName( NomFichier), sys_Vide);
     WinUtils_Contexte.Ajoute_Paquet( NomPaquet);
end;*)

function TWinUtils_Contexte.Paquet_Charge( _NomPaquet: String): Boolean;
begin
     Result:= Paquet_Trouve( _NomPaquet);
     if Result then exit;

     //désactivé: il faut un loadpackage pour que toutes les unités du paquet
     //soient chargées, le chargement statique ne suffit pas.
     //EnumModules( EnumModules_Callback, nil);
     //Result:= Paquet_Trouve( _NomPaquet);
end;

{ uWinUtils }

procedure Oriente_Fonte( Orientation: Integer; F: TFont);
var
   Fonte: HFont;
   fnWeight: Integer;
   fdwPitchAndFamily: Cardinal;
begin
     if Orientation = 0 then exit;

     if fsBold in F.Style
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
     //Il semble le gérer dans les autres cas.     CALCRECT:= Rect(0,0,Largeur,0);
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

procedure Aligne_Sommet( Source, Cible: TControl);
var
   P: TPoint;
begin
     P:= Point( Source.Left, Source.Top);
     P:= Source.Parent.ClientToScreen( P);
     P:= Cible.Parent.ScreenToClient( P);
     Cible.Top := P.Y;
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

function GetAveCharSize(Canvas: TCanvas): TPoint;
begin
end;

function InputPassword(const ACaption, APrompt, ADefault: string): String;
begin
end;

procedure uWinUtils_Control_Color( Color: TColor; Controls: array of TControl);
var
   I: Integer;
   C: TControl;
begin
     for I:= Low( Controls) to High( Controls)
     do
       begin
       C:= Controls[I];
            if C is TEdit     then TEdit    (C).Color:= Color
       else if C is TComboBox then TComboBox(C).Color:= Color;
       C.Refresh;
       end;
end;
{$ENDIF}

initialization
              {$IFDEF WINDOWS_GRAPHIC}
              WinUtils_Contexte:= TWinUtils_Contexte.Create;
              {$ENDIF}
finalization
              {$IFDEF WINDOWS_GRAPHIC}
              Free_nil( WinUtils_Contexte);
              {$ENDIF}
end.






