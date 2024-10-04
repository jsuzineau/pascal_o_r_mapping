unit ufjpFile;

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean, ujpFile, uBatpro_StringList, Classes, SysUtils, SynEdit,
    SynHighlighterXML, VCL.Forms, VCL.Controls, VCL.Graphics, VCL.Dialogs, VCL.ExtCtrls, VCL.StdCtrls,
    VCL.ActnList, strutils, SynEditTypes,
    SynEditHighlighter, SynHighlighterPas, SynHighlighterDfm,
    SynHighlighterJScript, UITypes, System.Actions, SynEditCodeFolding;

type
 { TfjpF, System.Actions,
  SynEditCodeFoldingile }

 TfjpFile
 =
 class(TForm)
 published
  aSauver: TAction;
  al: TActionList;
  bSauver: TButton;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  p1: TPanel;
  p2: TPanel;
  p3: TPanel;
  p5: TPanel;
  p4: TPanel;
  p12: TPanel;
  p45: TPanel;
  Panel1: TPanel;
  se01: TSynEdit;
  se02: TSynEdit;
  se03: TSynEdit;
  se05: TSynEdit;
  se04: TSynEdit;
  Splitter1: TSplitter;
  Splitter2: TSplitter;
  Splitter3: TSplitter;
  Splitter4: TSplitter;
  shlXML: TSynXMLSyn;
  shlPAS: TSynPasSyn;
  shlLFM: TSynDfmSyn;
  shlJS: TSynJScriptSyn;
  procedure aSauverExecute(Sender: TObject);
  procedure seStatusChange(Sender: TObject; Changes: TSynStatusChanges);
 //Gestion du cycle de vie
 public
   constructor Create( _sCle, _Directory: String); reintroduce;
   destructor Destroy; override;
 //Attributs
 private
   sCle: String;
   Directory: String;
   jpf: TjpFile;
   procedure Cree_jpf( _nfKey: String);
   procedure Charger;
   procedure Sauver;
   procedure SetSHL;
 //Recherche de 01_key
 private
   procedure Cherche_01_key_FileFound( _NomFichier: String);
   procedure Cherche_01_key;

 end;

 TIterateur_fjpFile
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TfjpFile);
    function  not_Suivant( var _Resultat: TfjpFile): Boolean;
  end;

 TslfjpFile
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_fjpFile;
    function Iterateur_Decroissant: TIterateur_fjpFile;
  end;


function fjpFile_from_sl( sl: TBatpro_StringList; Index: Integer): TfjpFile;
function fjpFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TfjpFile;

implementation

{$R *.dfm}

function fjpFile_from_sl( sl: TBatpro_StringList; Index: Integer): TfjpFile;
begin
     _Classe_from_sl( Result, TfjpFile, sl, Index);
end;

function fjpFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TfjpFile;
begin
     _Classe_from_sl_sCle( Result, TfjpFile, sl, sCle);
end;

{ TIterateur_fjpFile }

function TIterateur_fjpFile.not_Suivant( var _Resultat: TfjpFile): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_fjpFile.Suivant( var _Resultat: TfjpFile);
begin
     Suivant_interne( _Resultat);
end;

{ TslfjpFile }

constructor TslfjpFile.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TfjpFile);
end;

destructor TslfjpFile.Destroy;
begin
     inherited;
end;

class function TslfjpFile.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_fjpFile;
end;

function TslfjpFile.Iterateur: TIterateur_fjpFile;
begin
     Result:= TIterateur_fjpFile( Iterateur_interne);
end;

function TslfjpFile.Iterateur_Decroissant: TIterateur_fjpFile;
begin
     Result:= TIterateur_fjpFile( Iterateur_interne_Decroissant);
end;

{ TfjpFile }

constructor TfjpFile.Create( _sCle, _Directory: String);
begin
     inherited Create( nil);
     sCle:= _sCle;
     Directory:= _Directory;
     jpf:= nil;
     Caption := sCle;
     Cherche_01_key;
end;

destructor TfjpFile.Destroy;
begin
     if      bSauver.Visible
        and (mrYes = MessageDlg( 'Enregistrer les modifications ?', mtConfirmation,mbYesNo,0))
     then
         Sauver;
     inherited Destroy;
end;

procedure TfjpFile.Cree_jpf(_nfKey: String);
begin
     jpf:= TjpFile.Create( _nfKey);
     Charger;
end;

procedure TfjpFile.Charger;
begin
     se01.Lines.LoadFromFile( jpf.nfKey       );
     se02.Lines.LoadFromFile( jpf.nfBegin     );
     se03.Lines.LoadFromFile( jpf.nfElement   );
     se04.Lines.LoadFromFile( jpf.nfSeparateur);
     se05.Lines.LoadFromFile( jpf.nfEnd       );
     SetSHL;
     bSauver.Hide;
end;

procedure TfjpFile.Sauver;
begin
     se01.Lines.SaveToFile( jpf.nfKey       );
     se02.Lines.SaveToFile( jpf.nfBegin     );
     se03.Lines.SaveToFile( jpf.nfElement   );
     se04.Lines.SaveToFile( jpf.nfSeparateur);
     se05.Lines.SaveToFile( jpf.nfEnd       );
     bSauver.Hide;
end;

procedure TfjpFile.SetSHL;
var
   Extension: String;
   sc: TSynCustomHighlighter;
begin
     Extension:= LowerCase( ExtractFileExt( jpf.nfKey));
          if '.pas' = Extension then sc:= shlPAS
     else if '.lfm' = Extension then sc:= shlLFM
     else if '.js'  = Extension then sc:= shlJS
     else                            sc:= nil;
     se01.Highlighter:= sc;
     se02.Highlighter:= sc;
     se03.Highlighter:= sc;
     se04.Highlighter:= sc;
     se05.Highlighter:= sc;

end;

procedure TfjpFile.Cherche_01_key_FileFound( _NomFichier: String);
begin
     if Assigned(jpf) then exit;

     Cree_jpf( _NomFichier);
end;

procedure TfjpFile.Cherche_01_key;
begin
     ujpFile_EnumFiles( Directory, Cherche_01_key_FileFound, s_key_mask);
end;

procedure TfjpFile.aSauverExecute(Sender: TObject);
begin
     Sauver;
end;

procedure TfjpFile.seStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
     if scModified in Changes
     then
         bSauver.Show;
end;

end.

