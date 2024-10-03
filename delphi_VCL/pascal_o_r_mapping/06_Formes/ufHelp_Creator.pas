unit ufHelp_Creator;
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
    uBatpro_StringList,
    ufpBas,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, ShellAPI, FMX.StdCtrls, FMX.ActnList, FMX.Memo, FMX.ExtCtrls, VCL.Samples.Spin,
  FMX.Menus, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.Controls, Vcl.ExtCtrls, VCL.Graphics;

type
 TfHelp_Creator
 =
  class(TfpBas)
    Panel1: TPanel;
    m: FMX.Memo.TMemo;
    SaveDialogEMF: TSaveDialog;
    bHTML: TButton;
    SaveDialogHTML: TSaveDialog;
    Splitter1: TSplitter;
    Panel2: TPanel;
    mHTMLPattern: FMX.Memo.TMemo;
    Label1: TLabel;
    bAll: TButton;
    SaveDialogBMP: TSaveDialog;
    gbScreenShots: TGroupBox;
    bScreenShotEMF: TButton;
    bScreenShotBMP: TButton;
    GroupBox1: TGroupBox;
    speJPEGQuality: TSpinEdit;
    Label2: TLabel;
    bScreenShotJPEG: TButton;
    SaveDialogJPEG: TSaveDialog;
    bScreenShotWMF: TButton;
    Button1: TButton;
    bKomposer: TButton;
    procedure bHTMLClick(Sender: TObject);
    procedure bScreenShotEMFClick(Sender: TObject);
    procedure bAllClick(Sender: TObject);
    procedure bScreenShotBMPClick(Sender: TObject);
    procedure bScreenShotJPEGClick(Sender: TObject);
    procedure bScreenShotWMFClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bKomposerClick(Sender: TObject);
  private
    { Déclarations privées }
    NomFichier: String;
    NomFichierImage: String;
    F: TCustomForm;
    FF: TForm;
    function Sauver( var FileName: String; SD: TSaveDialog): Boolean;

    procedure Metafile_Screen_Shot( Enhanced: Boolean);
    procedure EMF_Screen_Shot;
    procedure WMF_Screen_Shot;
    procedure BMP_Screen_Shot;
    procedure JPEG_Screen_Shot;
    procedure Cree_HTML;
  public
    { Déclarations publiques }
    function Execute( Command: Word; Data: Integer; var CallHelp: Boolean;
                      unNomFichier: String;
                      unF: TCustomForm): Boolean; reintroduce;
  end;

function fHelp_Creator: TfHelp_Creator;

implementation

uses
    uClean,
    u_sys_, Types;

{$R *.fmx}
var
   FfHelp_Creator: TfHelp_Creator;

function fHelp_Creator: TfHelp_Creator;
begin
     Clean_Get( Result, FfHelp_Creator, TfHelp_Creator);
end;

function TfHelp_Creator.Execute( Command: Word; Data: Integer;
                                 var CallHelp: Boolean; unNomFichier: String;
                                 unF: TCustomForm): Boolean;
begin
     NomFichier:= unNomFichier;
     F:= unF;
     if F is TForm
     then
         FF:= F as TForm
     else
         FF:= nil;
     CallHelp:= False;

     m.Lines.Clear;
     m.Lines.Add( 'NomFichier: '+NomFichier);
     if Assigned( F)
     then
         m.Lines.Add( 'F.Caption: '+F.Caption);
     inherited Execute;
     result:= True;
end;

function TfHelp_Creator.Sauver( var FileName: String;SD: TSaveDialog): Boolean;
begin
     SD.FileName:= FileName;
     Result:= SD.Execute;
     if Result
     then
         begin
         FileName:= SD.FileName;
         Result:= not FileExists( FileName);
         if not Result
         then
             Result
             :=
               idYes
               =
               MessageDlg( FileName+' existe déjà.'#13#10+
                           'Voulez vous l''écraser ?',
                           mtConfirmation, [mbYes, mbNo], 0);
         end;
end;

procedure TfHelp_Creator.Metafile_Screen_Shot( Enhanced: Boolean);
var
   M: TMetafile;
   MC: TMetafileCanvas;
   Extension: String;
begin
     M:= TMetafile.Create;
     try
        M.Width := FF.ClientWidth;
        M.Height:= FF.ClientHeight;
        ShowMessage( 'non porté pour FMX');
        MC:= nil;
        //#################### à revoir pour FMX ####################"
        //MC:= TMetafileCanvas.Create( M, Canvas.Handle);
          MC.Lock;//verrouillage du handle HDC
          try
             //F.PaintTo( MC, 0, 0);
          finally
                 MC.Unlock;
                 end;
        Free_nil( MC);
        M.Enhanced:= Enhanced;
        if Enhanced
        then
            Extension:= '.EMF'
        else
            Extension:= '.WMF';
        NomFichierImage:= ChangeFileExt( NomFichier, Extension);
        if Sauver( NomFichierImage, SaveDialogEMF)
        then
            M.SaveToFile( NomFichierImage);
     finally
            Free_nil( M);
            end;
end;

procedure TfHelp_Creator.EMF_Screen_Shot;
begin
     Metafile_Screen_Shot( True);
end;

procedure TfHelp_Creator.WMF_Screen_Shot;
begin
     Metafile_Screen_Shot( False);
end;

procedure TfHelp_Creator.BMP_Screen_Shot;
var
   B: TBitmap;
begin
     B:= TBitmap.Create;
     try
        B.Width := FF.ClientWidth;
        B.Height:= FF.ClientHeight;
        B.Canvas.Lock;//verrouillage du handle HDC
        try
           //F.PaintTo( B.Canvas, 0, 0);
        finally
               B.Canvas.Unlock;
               end;
        NomFichierImage:= ChangeFileExt( NomFichier, '.BMP');
        if Sauver( NomFichierImage, SaveDialogBMP)
        then
            B.SaveToFile( NomFichierImage);
     finally
            Free_nil( B);
            end;
end;

procedure TfHelp_Creator.JPEG_Screen_Shot;
var
   B: TBitmap;
   Image: TImage;
begin
     B:= TBitmap.Create;
     try
        B.Width := FF.ClientWidth;
        B.Height:= FF.ClientHeight;
        B.Canvas.Lock;//verrouillage du handle HDC
        try
           //F.PaintTo( B.Canvas, 0, 0);
        finally
               B.Canvas.Unlock;
               end;
        NomFichierImage:= ChangeFileExt( NomFichier, '.JPG');
        if Sauver( NomFichierImage, SaveDialogJPEG)
        then
            try
               Image:= TImage.Create(nil);
               Image.Assign( B);
               //Image.CompressionQuality:= speJPEGQuality.Value;
               //Image.Compress;
               Image.Picture.SaveToFile( NomFichierImage);
            finally
                   Free_Nil( Image);
                   end;
     finally
            Free_nil( B);
            end;
end;

procedure TfHelp_Creator.Cree_HTML;
var
   sl: TBatpro_StringList;
   Titre: String;
begin
     sl:= TBatpro_StringList.Create;
     try
        if Assigned( F)
        then
            Titre:= F.Caption
        else
            Titre:= sys_Vide;
        sl.Text:= Format( mHTMLPattern.Text,
                          [ Titre, ExtractFileName( NomFichierImage)]);
        if Sauver( NomFichier, SaveDialogHTML)
        then
            sl.SaveToFile( NomFichier);
     finally
            Free_nil( sl);
            end;
end;

procedure TfHelp_Creator.bScreenShotEMFClick(Sender: TObject);
begin
     inherited;
     EMF_Screen_Shot;
end;

procedure TfHelp_Creator.bScreenShotWMFClick(Sender: TObject);
begin
     inherited;
     WMF_Screen_Shot;
end;

procedure TfHelp_Creator.bScreenShotBMPClick(Sender: TObject);
begin
     inherited;
     BMP_Screen_Shot;
end;

procedure TfHelp_Creator.bScreenShotJPEGClick(Sender: TObject);
begin
     inherited;
     JPEG_Screen_Shot;
end;

procedure TfHelp_Creator.bHTMLClick(Sender: TObject);
begin
     inherited;
     Cree_HTML;
end;

procedure TfHelp_Creator.bAllClick(Sender: TObject);
begin
     inherited;
     JPEG_Screen_Shot;
     Cree_HTML;
     ShellExecute( 0, 'open', 'iexplore', PChar(NomFichier),nil,SW_SHOWNORMAL);
end;

procedure TfHelp_Creator.bKomposerClick(Sender: TObject);
begin
     ShellExecute( 0, 'edit', PChar(NomFichier), nil ,nil,SW_SHOWNORMAL);
end;

procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);
var
  P: TPoint;
begin
  GetWindowOrgEx(DC, P);
  SetWindowOrgEx(DC, P.X - DX, P.Y - DY, nil);
end;

procedure TfHelp_Creator.Button1Click(Sender: TObject);
var
   M: TMetafile;
   MC: TMetafileCanvas;
   Extension: String;
   sHandle: String;
   H: THandle;
   R: TRect;
   SrcDC, DC: HDC;
begin
     sHandle
     :=
       InputBox( 'Screenshot de fenêtre','Donnez le handle de fenêtre', IntToStr(0{Handle}));

     H:= StrToInt(sHandle);


     M:= TMetafile.Create;
     try
        Windows.GetClientRect( H, R);
        SrcDC:= Windows.GetWindowDC( H);
        M.Width := R.Right;
        M.Height:= R.Bottom;
        MC:= TMetafileCanvas.Create( M, SrcDC);
          MC.Lock;//verrouillage du handle HDC
          try
             DC:= MC.Handle;
             //uForms_ShowMessage( IntToStr(DC));
             //à reprendre pouyr FMX
             //ControlState:= ControlState + [ csPaintCopy];
             MoveWindowOrg(DC, 0, 0);
             Windows.IntersectClipRect(DC, 0, 0, M.Width, M.Height);
             SendMessage( H, WM_ERASEBKGND, DC, 0);
             SendMessage( H, WM_PAINT, DC, 0);

             //F.PaintTo( MC, 0, 0);
             //PaintTo( MC, 0, 0);
          finally
                 MC.Unlock;
                 end;
        Free_nil( MC);
        M.Enhanced:= False;
        Extension:= '_Fenetre.WMF';
        NomFichierImage:= ChangeFileExt( NomFichier, Extension);
        if Sauver( NomFichierImage, SaveDialogEMF)
        then
            M.SaveToFile( NomFichierImage);
     finally
            Free_nil( M);
            end;
end;
//$000B1552
initialization
              Clean_CreateD( FfHelp_Creator, TfHelp_Creator);
finalization
              Clean_Destroy( FfHelp_Creator);
end.

