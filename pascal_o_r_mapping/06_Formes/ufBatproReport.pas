unit ufBatproReport;
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
    uClean,
    uuStrings,
    uWinUtils,
    uDataClasses,

    uBatpro_Element,

    uhDessinnateur,
    uImpression_Font_Size_Multiplier,
    uBatproReportDocument,

    ufpBas,
    ufAccueil_Erreur,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Printers, Grids, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  Spin, Gauges, Clipbrd, Consts, Menus;

type
 TfBatproReport
 =
  class(TfpBas)
    pc: TPageControl;
    ts: TTabSheet;
    i: TImage;
    PrinterSetupDialog: TPrinterSetupDialog;
    bPrinterSetup: TButton;
    spe: TSpinEdit;
    Label1: TLabel;
    cbPageAffichee: TCheckBox;
    rgMultipages: TRadioGroup;
    cbAfficherLogo: TCheckBox;
    FontDialog: TFontDialog;
    bPoliceTitre: TButton;
    g: TGauge;
    tShow: TTimer;
    bDessinne: TButton;
    bArretDessin: TButton;
    cbStretch: TCheckBox;
    bSaveAs: TButton;
    sd: TSaveDialog;
    bCopy: TButton;
    cbAfficherTitre: TCheckBox;
    speImpression_Font_Size_Multiplier: TSpinEdit;
    cbGrille: TCheckBox;
    cbLargeur: TCheckBox;
    procedure aValidationExecute(Sender: TObject);
    procedure bPrinterSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure speChange(Sender: TObject);
    procedure rgMultipagesClick(Sender: TObject);
    procedure cbAfficherLogoClick(Sender: TObject);
    procedure bPoliceTitreClick(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
    procedure bDessinneClick(Sender: TObject);
    procedure bArretDessinClick(Sender: TObject);
    procedure cbStretchClick(Sender: TObject);
    procedure bSaveAsClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
    procedure cbAfficherTitreClick(Sender: TObject);
    procedure speImpression_Font_Size_MultiplierChange(Sender: TObject);
    procedure cbGrilleClick(Sender: TObject);
  private
    { Déclarations privées }
    BatproReportDocument: TBatproReportDocument;
    procedure Dessinne;
    procedure i_from_Document;
    procedure Init_from( unhdTable:ThDessinnateur;
                         RowCountMin: Integer;
                         HMax: Boolean;
                         _sLegende_ligne_1: String;
                         _aLegende_ligne_2: array of String;
                         _nColumnHeaderDebut: Integer = 0;
                         _nColumnHeaderFin  : Integer = 1;
                         _Bande_Titre: Boolean = True;
                         _Paysage: Boolean= True);
    procedure Traite_Hauteurs_Lignes;
  public
    { Déclarations publiques }
    function Execute( unhdTable:ThDessinnateur; RowCountMin: Integer;
                      HMax: Boolean;
                      _sLegende_ligne_1: String;
                      _aLegende_ligne_2: array of String;
                      _nColumnHeaderDebut: Integer = 0;
                      _nColumnHeaderFin  : Integer = 1;
                      _Bande_Titre: Boolean = True;
                      _Paysage: Boolean= True):Boolean;reintroduce;
  //Paramètres
  private
    Paysage: Boolean;
    procedure Printer_from_;
  //Sémaphore de modification de rgMultipages
  private
    rgMultipagesChanging: Boolean;
  //Méthode d'export pour inclusion dans modèle OpenOffice
  public
    procedure Exporter_vers( NomFichier: String;
                             _g: TGauge;
                             unhdTable:ThDessinnateur;
                             RowCountMin: Integer;
                             HMax: Boolean;
                             _sLegende_ligne_1: String;
                             _aLegende_ligne_2: array of String;
                             _nColumnHeaderDebut: Integer = 0;
                             _nColumnHeaderFin  : Integer = 1;
                             _Bande_Titre: Boolean = True;
                             _Paysage: Boolean= True);
  // accés speImpression_Font_Size_Multiplier
  private
    speImpression_Font_Size_Multiplier_Changing: Boolean;
  //Gestion de l'affichage de la grille
  private
    cbGrille_Changing: Boolean;
    procedure _from_Afficher_Grille;
  //pré- et post- exécution
  protected
    function PreExecute: Boolean; override;
    procedure PostExecute; override;
  end;

function fBatproReport: TfBatproReport;

implementation

{$R *.dfm}


var
   FfBatproReport: TfBatproReport;

function fBatproReport: TfBatproReport;
begin
     Clean_Get( Result, FfBatproReport, TfBatproReport);
end;

function fBatproReport_Execute( unhdTable:ThDessinnateur; RowCountMin: Integer;
                                HMax: Boolean;
                                _sLegende_ligne_1: String;
                                _aLegende_ligne_2: array of String;
                                _nColumnHeaderDebut: Integer = 0;
                                _nColumnHeaderFin  : Integer = 1;
                                _Bande_Titre: Boolean = True;
                                _Paysage: Boolean= True):Boolean;
begin
     Result:= fBatproReport.Execute( unhdTable, RowCountMin, HMax,
                                     _sLegende_ligne_1,
                                     _aLegende_ligne_2,
                                     _nColumnHeaderDebut,
                                     _nColumnHeaderFin  ,
                                     _Bande_Titre,
                                     _Paysage);
end;

{ TfBatproReport }

procedure TfBatproReport.FormCreate(Sender: TObject);
begin
     inherited;
     Execute_non_modal:= True;
     BatproReportDocument:= TBatproReportDocument.Create;
     rgMultipagesChanging:= False;
     speImpression_Font_Size_Multiplier_Changing:= False;
     cbGrille_Changing:= False;
end;

procedure TfBatproReport.FormDestroy(Sender: TObject);
begin
     tShow.Enabled:= False;
     Free_nil( BatproReportDocument);
     inherited;
end;

procedure TfBatproReport.i_from_Document;
var
   M: TMetafile;
begin
     M:= BatproReportDocument.mfPage_from_Index( spe.Value-1);

     if M = nil
     then
         i.Picture.Graphic:= nil
     else
         i.Picture.Assign( M);
     i.Stretch:= cbStretch.Checked;
end;

procedure TfBatproReport.Dessinne;
begin
     try
        bDessinne   .Hide;
        bArretDessin.Show;
        BatproReportDocument.Dessinne( g);
        spe.MinValue:= 1;
        spe.MaxValue:= BatproReportDocument.Pages.Count;
        i_from_Document;
     finally
            bDessinne   .Show;
            bArretDessin.Hide;
            end;
end;

procedure TfBatproReport.Printer_from_;
begin
     if Paysage
     then
         Printer.Orientation:= poLandscape
     else
         Printer.Orientation:= poPortrait;
end;

procedure TfBatproReport.Init_from( unhdTable: ThDessinnateur;
                                    RowCountMin: Integer;
                                    HMax: Boolean;
                                    _sLegende_ligne_1: String;
                                    _aLegende_ligne_2: array of String;
                                    _nColumnHeaderDebut,
                                    _nColumnHeaderFin: Integer;
                                    _Bande_Titre,
                                    _Paysage: Boolean);
begin
     Paysage:= _Paysage;
     Printer_from_;
     BatproReportDocument.Set_hdTable_Legende( unhdTable,
                                               _sLegende_ligne_1,
                                               _aLegende_ligne_2,
                                               _nColumnHeaderDebut,
                                               _nColumnHeaderFin  ,
                                               _Bande_Titre       );
end;

function TfBatproReport.PreExecute: Boolean;
begin
     Result:= inherited PreExecute;
     try
        rgMultipagesChanging:= True;
        if BatproReportDocument.Multipages
        then
            rgMultipages.ItemIndex:= 1
        else
            rgMultipages.ItemIndex:= 0;
     finally
            rgMultipagesChanging:= False;
            end;
     tShow.Enabled:= True;
end;

procedure TfBatproReport.Traite_Hauteurs_Lignes;
var
   hd: ThDessinnateur;
begin
     hd:= BatproReportDocument.PageFormat.hdTable;
     if cbLargeur.Checked
     then
         hd.Traite_Dimensions
     else
         hd.Traite_Hauteurs_Lignes;
end;

procedure TfBatproReport.PostExecute;
var
   hd: ThDessinnateur;
begin
     hd:= BatproReportDocument.PageFormat.hdTable;
     hd.DI.Impression:= False;
     hd.Traite_Dimensions;
     inherited;
end;

function TfBatproReport.Execute( unhdTable:ThDessinnateur; RowCountMin: Integer;
                      HMax: Boolean;
                      _sLegende_ligne_1: String;
                      _aLegende_ligne_2: array of String;
                      _nColumnHeaderDebut: Integer = 0;
                      _nColumnHeaderFin  : Integer = 1;
                      _Bande_Titre: Boolean = True;
                      _Paysage: Boolean= True):Boolean;
begin
     unhdTable.DI.Impression:= True;
     unhdTable.Traite_Dimensions;

     Init_from( unhdTable, RowCountMin, HMax, _sLegende_ligne_1,
                _aLegende_ligne_2,
                _nColumnHeaderDebut, _nColumnHeaderFin,
                _Bande_Titre, _Paysage);

     try
        cbGrille_Changing:= True;
        cbGrille.Checked:= uBatpro_Element_Afficher_Grille;
        _from_Afficher_Grille;
     finally
            cbGrille_Changing:= False;
            end;

     try
        speImpression_Font_Size_Multiplier_Changing:= True;
        speImpression_Font_Size_Multiplier.Value
        :=
          Impression_Font_Size_Multiplier.Valeur[ unhdTable.DI.Contexte];
     finally
            speImpression_Font_Size_Multiplier_Changing:= False;
            end;
     Result:= inherited Execute;
end;

procedure TfBatproReport.aValidationExecute(Sender: TObject);
var
   I: Integer;
   M: TMetafile;
   OldPrinterTitle: String;

   Device, Driver, Port: array[0..255] of Char;
   DeviceMode: THandle;
   dmDeviceMode: PDeviceMode;
   sDeviceMode: String;

   procedure D( _Nom, _Valeur: String);
   begin
        sDeviceMode:= sDeviceMode + _Nom+': '+_Valeur+#13#10;
   end;
begin
     inherited;

     OldPrinterTitle:= Printer.Title;
     Printer.GetPrinter( Device, Driver, Port , DeviceMode );
     Printer.SetPrinter( Device, Driver, Port , 0 );
     Printer_from_;

     Printer.Title:= 'BatproReport - '+BatproReportDocument.Titre;

     if cbPageAffichee.Checked
     then
         begin
         M:= BatproReportDocument.mfPage_from_Index( spe.Value-1);
         if M = nil then exit;

         Printer.BeginDoc;
         Printer.Canvas.StretchDraw( Rect( 0, 0,
                                           Printer.PageWidth, Printer.PageHeight),
                                     M);
         Printer.EndDoc;
         end
     else
         begin
         Printer.BeginDoc;
         for I:= 0 to BatproReportDocument.Pages.Count - 1
         do
           begin
           M:= BatproReportDocument.mfPage_from_Index( I);
           if Assigned( M)
           then
               begin
               if I > 0
               then
                   Printer.NewPage;
               Printer.Canvas.StretchDraw( Rect( 0, 0, Printer.PageWidth, Printer.PageHeight), M);
               end;
           end;

         //Printer.GetPrinter( Device, Driver, Port, DeviceMode);
         //
         //sDeviceMode:= '';
         //try
         //   dmDeviceMode:= GlobalLock( DeviceMode);
         //   if Assigned( dmDeviceMode)
         //   then
         //       begin
         //       D( 'dmDeviceName   ', StrPas  ( dmDeviceMode.dmDeviceName   ));
         //       D( 'dmSpecVersion  ', IntToStr( dmDeviceMode.dmSpecVersion  ));
         //       D( 'dmSpecVersion  ', IntToStr( dmDeviceMode.dmSpecVersion  ));
         //       D( 'dmDriverVersion', IntToStr( dmDeviceMode.dmDriverVersion));
         //       D( 'dmSize         ', IntToStr( dmDeviceMode.dmSize         ));
         //       D( 'dmDriverExtra  ', IntToStr( dmDeviceMode.dmDriverExtra  ));
         //       D( 'dmFields       ', IntToHex( dmDeviceMode.dmFields       , 8));
         //       D( 'dmOrientation  ', IntToStr( dmDeviceMode.dmOrientation  ));
         //       end;
         //
         //finally
         //       GlobalUnlock( DeviceMode);
         //       end;

         Printer.EndDoc;

         //fAccueil_Erreur( 'Impression vers Device: '+StrPas( Device)
         //                 +', '#13#10'Driver :>'+ StrPas( Driver)+'<'
         //                 +', '#13#10'Port :>'  + StrPas( Port  )+'<'#13#10
         //                 +'DeviceMode :'#13#10+sDeviceMode);
         end;
     Printer.Title:= OldPrinterTitle;
end;

procedure TfBatproReport.bPrinterSetupClick(Sender: TObject);
begin
     inherited;
     if PrinterSetupDialog.Execute
     then
         Dessinne;
end;

procedure TfBatproReport.speChange(Sender: TObject);
begin
     i_from_Document;
end;

procedure TfBatproReport.rgMultipagesClick(Sender: TObject);
begin
     if rgMultipagesChanging then exit;
     try
        rgMultipagesChanging:= True;
        BatproReportDocument.Multipages:= rgMultipages.ItemIndex = 1;
        Dessinne;
     finally
            rgMultipagesChanging:= False;
            end;
end;

procedure TfBatproReport.cbAfficherLogoClick(Sender: TObject);
begin
     BatproReportDocument.AfficherLogo:= cbAfficherLogo.Checked;
     Dessinne;
end;

procedure TfBatproReport.cbAfficherTitreClick(Sender: TObject);
begin
     BatproReportDocument.AfficherTitre:= cbAfficherTitre.Checked;
     Dessinne;
end;

procedure TfBatproReport.bPoliceTitreClick(Sender: TObject);
begin
     FontDialog.Font.Assign( BatproReportDocument.PageFormat.fTitre);
     if FontDialog.Execute
     then
         BatproReportDocument.PageFormat.fTitre.Assign( FontDialog.Font);

end;

procedure TfBatproReport.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     Dessinne;
end;

procedure TfBatproReport.bDessinneClick(Sender: TObject);
begin
     Dessinne;
end;

procedure TfBatproReport.bArretDessinClick(Sender: TObject);
begin
     BatproReportDocument.Abandon:= True;
end;

procedure TfBatproReport.cbStretchClick(Sender: TObject);
begin
     i_from_Document;
end;

procedure TfBatproReport.bSaveAsClick(Sender: TObject);
var
   M: TMetafile;
begin
     M:= BatproReportDocument.mfPage_from_Index( spe.Value-1);

     if M = nil then exit;
     if sd.Execute
     then
         M.SaveToFile( sd.FileName);
end;

procedure TfBatproReport.bCopyClick(Sender: TObject);
var
   M: TMetafile;
   ClipboardFormat: Word;
   Data: THandle;
   Palette: HPALETTE;
begin
     M:= BatproReportDocument.mfPage_from_Index( spe.Value-1);

     if M = nil then exit;

     M.SaveToClipboardFormat( ClipboardFormat, Data, Palette);
     Clipboard.SetAsHandle( ClipboardFormat, Data);
end;

procedure TfBatproReport.Exporter_vers( NomFichier: String;
                                        _g: TGauge;
                                        unhdTable: ThDessinnateur;
                                        RowCountMin: Integer;
                                        HMax: Boolean;
                                        _sLegende_ligne_1: String;
                                        _aLegende_ligne_2: array of String;
                                        _nColumnHeaderDebut,
                                        _nColumnHeaderFin: Integer;
                                        _Bande_Titre,
                                        _Paysage: Boolean);
var
   M: TMetafile;
begin
     Init_from( unhdTable, RowCountMin, HMax, _sLegende_ligne_1,
                _aLegende_ligne_2,
                _nColumnHeaderDebut, _nColumnHeaderFin,
                _Bande_Titre, _Paysage);

     BatproReportDocument.AfficherLogo := False;
     BatproReportDocument.AfficherTitre:= False;

     BatproReportDocument.Dessinne( _g);
     M:= BatproReportDocument.mfPage_from_Index( 0);

     if M = nil then exit;
     M.SaveToFile( NomFichier);
end;

procedure TfBatproReport.speImpression_Font_Size_MultiplierChange( Sender: TObject);
var
   Contexte: Integer;
begin
     if speImpression_Font_Size_Multiplier_Changing then exit;
     try
        speImpression_Font_Size_Multiplier_Changing:= True;
        Contexte:= BatproReportDocument.PageFormat.hdTable.DI.Contexte;
        Impression_Font_Size_Multiplier.Valeur[ Contexte]
        :=
          speImpression_Font_Size_Multiplier.Value;

        Traite_Hauteurs_Lignes;
        Dessinne;
     finally
            speImpression_Font_Size_Multiplier_Changing:= False;
            end;
end;

procedure TfBatproReport.cbGrilleClick(Sender: TObject);
begin
     if cbGrille_Changing then exit;

     try
        cbGrille_Changing:= True;
        uBatpro_Element_Afficher_Grille:= cbGrille.Checked;
        _from_Afficher_Grille;
        Dessinne;
     finally
            cbGrille_Changing:= False;
            end;
end;

procedure TfBatproReport._from_Afficher_Grille;
var
   sg: TStringGrid;
begin
     sg:= BatproReportDocument.PageFormat.hdTable.sg;
     if sg = nil then exit;

     if uBatpro_Element_Afficher_Grille
     then
         begin
         sg.GridLineWidth:= 1;
         //sg.Options:= sg.Options + [goVertLine];
         //sg.Options:= sg.Options + [goHorzLine];
         end
     else
         begin
         sg.GridLineWidth:= 0;
         //sg.Options:= sg.Options - [goVertLine];
         //sg.Options:= sg.Options - [goHorzLine];
         end;
end;

initialization
              Clean_CreateD( FfBatproReport, TfBatproReport);
              function_fBatproReport_Execute:= fBatproReport_Execute;
finalization
              Clean_Destroy( FfBatproReport);
end.

