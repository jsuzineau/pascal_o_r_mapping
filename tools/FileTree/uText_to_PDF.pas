unit uText_to_PDF;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils,
    fpreport,fpreportpdfexport, fpTTF;

type

 { TText_to_PDF }

 TText_to_PDF
 =
  class
  //Life cycle management
  public
    constructor Create;
    destructor Destroy; override;
  //Attributes
  private
    Text_to_PDF_First_Run: Boolean;
    slTXT2PDF: TStringList;
    FLineIndex : Integer;
  //Methods
  private
    procedure DoFirst(Sender: TObject);
    procedure DoGetEOF(Sender: TObject; var IsEOF: boolean);
    procedure DoGetNames(Sender: TObject; List: TStrings);
    procedure DoGetNext(Sender: TObject);
    procedure DoGetValue(Sender: TObject; const AValueName: string; var AValue: variant);
  public
    function Execute( _Text, _PDF_filename: String): String;
  end;
Var
   Report_Title:String;
//Text_to_PDF singleton
function Text_to_PDF: TText_to_PDF;

implementation

//Text_to_PDF singleton
var
   FText_to_PDF: TText_to_PDF= nil;

function Text_to_PDF: TText_to_PDF;
begin
     if nil = FText_to_PDF
     then
         FText_to_PDF:= TText_to_PDF.Create;

     Result:= FText_to_PDF;
end;

{ TText_to_PDF }

constructor TText_to_PDF.Create;
begin
     Text_to_PDF_First_Run:= True;
     slTXT2PDF := TStringList.Create;
end;

destructor TText_to_PDF.Destroy;
begin
     FreeAndNil( slTXT2PDF );
     inherited Destroy;
end;

procedure TText_to_PDF.DoGetNames(Sender: TObject; List: TStrings);
begin
     List.Add('Line');
end;

procedure TText_to_PDF.DoGetEOF(Sender: TObject; var IsEOF: boolean);
begin
     isEOF:=FLineIndex>=slTXT2PDF.Count;
end;

procedure TText_to_PDF.DoFirst(Sender: TObject);
begin
     FLineIndex:=0;
end;

procedure TText_to_PDF.DoGetNext(Sender: TObject);
begin
     Inc(FLineIndex);
end;

procedure TText_to_PDF.DoGetValue( Sender: TObject;
                                   const AValueName: string;
                                   var AValue: variant);
begin
     Avalue:=slTXT2PDF[FLineIndex];
end;

function TText_to_PDF.Execute( _Text, _PDF_filename: String): String;
var
   r  : TFPReport;
   rud: TFPReportUserData;
   PG : TFPReportPage;
   PH : TFPReportPageHeaderBand;
   PF : TFPReportPageFooterBand;
   DB : TFPReportDataBand;
   M : TFPReportMemo;
   PDF : TFPReportExportPDF;
   Fnt : String;

begin
     r:=TFPReport.Create(nil);
     rud:=TFPReportUserData.Create(nil);
     try
        {$IFDEF MSWINDOWS}
        Fnt:='Consolas';
        {$ELSE}
        Fnt:='DejaVuSans';
        {$ENDIF}
        //Fnt:='CourierNewPSMT';
        //Fnt:='UbuntuMono-Regular';
        //Terminate;
        //slTXT2PDF.LoadFromFile(ParamStr(1));
        slTXT2PDF.Text:= _Text;
        gTTFontCache.ReadStandardFonts;
        //gTTFontCache.SearchPath.Add('E:\01_Projets\01_pascal_o_r_mapping\tools\FileTree\fonts\');
        gTTFontCache.BuildFontCache;
        if Text_to_PDF_First_Run
        then
            begin
            PaperManager.RegisterStandardSizes;
            Text_to_PDF_First_Run:= False;
            end;
        // Page
        PG:=TFPReportPage.Create(r);
        PG.Data:=rud;
        PG.Orientation := poPortrait;
        PG.PageSize.PaperName := 'A4';
        PG.Margins.Left := 10;
        PG.Margins.Top := 10;
        PG.Margins.Right := 10;
        PG.Margins.Bottom := 10;
        // Page header
        PH:=TFPReportPageHeaderBand.Create(PG);
        PH.Layout.Height:=10; // 1 cm.
        M:=TFPReportMemo.Create(PH);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=200;
        M.Layout.Height:=7;
        M.Text:=Report_Title;
        M.Font.Name:=Fnt;
        M.Font.Size:=16;
        M:=TFPReportMemo.Create(PH);
        M.Layout.Top:=1;
        M.Layout.Left:=PG.Layout.Width-41;
        M.Layout.Width:=40;
        M.Layout.Height:=7;
        M.Text:='[Date]';
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Page footer
        PF:=TFPReportPageFooterBand.Create(PG);
        PF.Layout.Height:=10; // 1 cm.
        M:=TFPReportMemo.Create(PF);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=40;
        M.Layout.Height:=7;
        M.Text:='Page [PageNo]';
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Actual line
        DB:=TFPReportDataBand.Create(PG);
        DB.Data:=rud;
        //DB.Layout.Height:=5; // 0.5 cm.
        //DB.StretchMode:=smActualHeight;
        DB.Layout.Height:=4; // 0.4 cm.
        DB.StretchMode:=smDontStretch;
        M:=TFPReportMemo.Create(DB);
        M.Layout.Top:=1;
        M.Layout.Left:=1;
        M.Layout.Width:=PG.Layout.Width-41;
        M.Layout.Height:=4;
        M.Text:='[Line]';
        M.StretchMode:=smActualHeight;
        M.Font.Name:=Fnt;
        M.Font.Size:=10;
        // Set up data
        rud.OnGetNames:=@DoGetNames;
        rud.OnNext:=@DoGetNext;
        rud.OnGetValue:=@DoGetValue;
        rud.OnGetEOF:=@DoGetEOF;
        rud.OnFirst:=@DoFirst;
        // Go !
        r.RunReport;
        PDF:=TFPReportExportPDF.Create(nil);
        try
          PDF.FileName:=_pdf_filename;
          r.RenderReport(PDF);
        finally
          PDF.Free;
        end;

     finally
            FreeAndNil(rud);
            FreeAndNil(r);
            end;
     Result:= _pdf_filename;

end;

initialization

finalization
            FreeAndNil( FText_to_PDF);
end.

