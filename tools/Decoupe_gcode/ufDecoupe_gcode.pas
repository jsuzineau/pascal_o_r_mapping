unit ufDecoupe_gcode;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uFichierGCODE,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
 StdCtrls, ExtCtrls, Spin;

type

 { TfDecoupe_gcode }

 TfDecoupe_gcode = class(TForm)
  bDecoupe_en: TButton;
  bChoix: TButton;
  eSource: TEdit;
  Label1: TLabel;
  m: TMemo;
  mVariables: TMemo;
  miOuvrir: TMenuItem;
  miFichier: TMenuItem;
  mm: TMainMenu;
  od: TOpenDialog;
  Panel1: TPanel;
  seNb: TSpinEdit;
  Splitter1: TSplitter;
  procedure bChoixClick(Sender: TObject);
  procedure bDecoupe_enClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure miOuvrirClick(Sender: TObject);
 private
  { private declarations }
 public
  { public declarations }
 end;

var
 fDecoupe_gcode: TfDecoupe_gcode;

implementation

{$R *.lfm}

{ TfDecoupe_gcode }

procedure TfDecoupe_gcode.FormCreate(Sender: TObject);
begin
     eSource.Text:= EXE_INI.ReadString('Options', 'Source','');
end;

procedure TfDecoupe_gcode.FormDestroy(Sender: TObject);
begin
     EXE_INI.WriteString('Options', 'Source',eSource.Text);
end;

procedure TfDecoupe_gcode.miOuvrirClick(Sender: TObject);
var
   F: TFichierGCODE;
begin
     m.Clear;
     F:= TFichierGCODE.Create;
     try
        F.Charge( eSource.Text);
        m.Lines.Add( IntToStr(Length(F.Montees))+' montées');
        m.Lines.Add( 'G92 E0 final en position '+IntToStr(F.Cherche_Reverse('G92 E0')));
        m.Lines.Add( 'Fin de ligne '+F.sFin_Ligne);
        m.Lines.Add( 'START_GCODE:'#13#10'>'+F.sSTART_GCODE+'<');
        m.Lines.Add( 'END_GCODE:'#13#10'>'+F.sEND_GCODE+'<');

        m.Lines.Add( 'START_GCODE en position :'+IntToStr(F.Cherche(F.sSTART_GCODE)));
        m.Lines.Add( 'END_GCODE   en position :'+IntToStr(F.Cherche(F.sEND_GCODE  )));
        m.Lines.Add( 'Fin START_GCODE en position :'+IntToStr(F.Fin_START_GCODE));
        m.Lines.Add( 'Debut_END_GCODE en position :'+IntToStr(F.Debut_END_GCODE));
        m.Lines.Add( 'Premiere_Couche en position :'+IntToStr(F.Premiere_Couche));
        m.Lines.Add( 'Header Premier fichier:'#13#10'>'+F.Header(True)+'<');
        m.Lines.Add( 'Header fichiers suivant:'#13#10'>'+F.Header(False)+'<');
        m.Lines.Add( 'Footer:'#13#10'>'+F.Footer+'<');
        mVariables.Text:= F.slVariables.Text;
     finally
            FreeAndNil(F);
            end;
end;

procedure TfDecoupe_gcode.bDecoupe_enClick(Sender: TObject);
var
   F: TFichierGCODE;
begin
     F:= TFichierGCODE.Create;
     try
        F.Charge( eSource.Text);
        F.Decoupe( seNb.Value);
     finally
            FreeAndNil(F);
            end;
end;

procedure TfDecoupe_gcode.bChoixClick(Sender: TObject);
begin
     od.FileName:= eSource.Text;
     if od.Execute
     then
         eSource.Text:= od.FileName;
end;

end.

