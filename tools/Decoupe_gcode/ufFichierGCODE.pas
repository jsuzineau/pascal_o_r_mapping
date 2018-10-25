unit ufFichierGCODE;

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2018 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uFichierGCODE, uOD_Forms, Classes, SysUtils, FileUtil, SynEdit,
    SynHighlighterXML, SynGutterBase, SynGutterMarks, SynGutterLineNumber,
    SynGutterChanges, SynGutter, SynGutterCodeFolding, Forms, Controls,
    Graphics, Dialogs, ExtCtrls, StdCtrls, ActnList, StdActns, ComCtrls, DOM,
    XMLWrite, XMLRead, strutils;

type
 { TfFichierGCODE }

 TfFichierGCODE
 =
 class(TForm)
 published
  aChercher: TAction;
  aSauver: TAction;
  al: TActionList;
  bChercher: TButton;
  bSauver: TButton;
  eChercher: TEdit;
  lFileName: TLabel;
  m: TMemo;
  pc: TPageControl;
  Panel1: TPanel;
  se: TSynEdit;
  seEND_GCODE: TSynEdit;
  seFirstHeader: TSynEdit;
  seFooter: TSynEdit;
  seCouches: TSynEdit;
  seMontees: TSynEdit;
  seSTART_GCODE: TSynEdit;
  seHeader: TSynEdit;
  seVariables: TSynEdit;
  sxs: TSynXMLSyn;
  tsCouches: TTabSheet;
  tsMontees: TTabSheet;
  tsHeader: TTabSheet;
  tsFirstHeader: TTabSheet;
  tsSTART_GCODE: TTabSheet;
  tsEND_GCODE: TTabSheet;
  tsFooter: TTabSheet;
  tsVariables: TTabSheet;
  tsGeneral: TTabSheet;
  tsFichier: TTabSheet;
  procedure aChercherExecute(Sender: TObject);
  procedure aSauverExecute(Sender: TObject);
  procedure seChange(Sender: TObject);
//Gestion du cycle de vie
 public
   constructor Create( _FileName: String); reintroduce;
   destructor Destroy; override;
 //FileName
 private
   FileName: String;
 private
   procedure _from_FileName;
   procedure _to_FileName;
 //Analyse du gcode
 private
   procedure Analyse;
 end;
 PfFichierGCODE= ^TfFichierGCODE;

function Assure_fFichierGCODE( var _fFichierGCODE: TfFichierGCODE; _FileName: String): TfFichierGCODE;

implementation

{$R *.lfm}

{ TfFichierGCODE }

function Assure_fFichierGCODE( var _fFichierGCODE: TfFichierGCODE; _FileName: String): TfFichierGCODE;
begin
     if nil = _fFichierGCODE
     then
         _fFichierGCODE:= TfFichierGCODE.Create( _FileName);
     Result:= _fFichierGCODE;
end;

constructor TfFichierGCODE.Create(_FileName: String);
begin
     inherited Create( nil);
     FileName:= _FileName;
     Caption:= ExtractFileName( FileName);
     lFileName.Caption:= FileName;
     _from_FileName;
     Analyse;
end;

destructor TfFichierGCODE.Destroy;
begin
     inherited Destroy;
end;

procedure TfFichierGCODE._from_FileName;
begin
     se.Lines.LoadFromFile( FileName);
     aSauver.Visible:= False;
end;

procedure TfFichierGCODE._to_FileName;
begin
     se.Lines.SaveToFile( FileName);
     Analyse;
     aSauver.Visible:= False;
end;

procedure TfFichierGCODE.Analyse;
var
   F: TFichierGCODE;
begin
     m.Clear;
     F:= TFichierGCODE.Create;
     try
        F.Charge( FileName);
        m.Lines.Add( IntToStr(Length(F.Montees))+' montées');
        m.Lines.Add( IntToStr(Length(F.Couches))+' couches');
        m.Lines.Add( 'G92 E0 final au caractère '+F.nExtrait_Ligne(F.Cherche_Reverse('G92 E0')));
        m.Lines.Add( 'Fin de ligne '+F.sFin_Ligne);
        seSTART_GCODE.Lines.Text:= F.sSTART_GCODE;
          seEND_GCODE.Lines.Text:= F.  sEND_GCODE;

        m.Lines.Add( 'START_GCODE au caractère '+F.nExtrait_Ligne(F.Cherche(F.sSTART_GCODE)));
        m.Lines.Add( 'END_GCODE   au caractère '+F.nExtrait_Ligne(F.Cherche(F.sEND_GCODE  )));
        m.Lines.Add( 'Fin START_GCODE au caractère '+F.nExtrait_Ligne(F.Fin_START_GCODE));
        m.Lines.Add( 'Debut_END_GCODE au caractère '+F.nExtrait_Ligne(F.Debut_END_GCODE));
        m.Lines.Add( 'Premiere_Couche au caractère '+F.nExtrait_Ligne(F.Premiere_Couche));
        seFirstHeader.Lines.Text:= F.Header(True );
        seHeader     .Lines.Text:= F.Header(False);
        seFooter     .Lines.Text:= F.Footer;
        seVariables  .Lines.Text:= F.slVariables.Text;
        seMontees    .Lines.Text:= F.sMontees;
        seCouches    .Lines.Text:= F.sCouches;
     finally
            FreeAndNil(F);
            end;
end;

procedure TfFichierGCODE.aSauverExecute(Sender: TObject);
begin
     _to_FileName;
end;

procedure TfFichierGCODE.seChange(Sender: TObject);
begin
     aSauver.Visible:= True;
end;

procedure TfFichierGCODE.aChercherExecute(Sender: TObject);
var
   I: Integer;
begin

     I:= PosEx( eChercher.Text, se.Text, se.SelEnd+1);
     if I = 0
     then
         begin
         uOD_Forms_ShowMessage( 'Texte non trouvé');
         exit;
         end;
     se.SetFocus;
     se.SelStart:= I;
     se.SelEnd:= se.SelStart+Length(eChercher.Text);
end;


end.

