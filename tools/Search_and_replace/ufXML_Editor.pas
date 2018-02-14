unit ufXML_Editor;

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

{$mode delphi}

interface

uses
    uOD_Forms,
 Classes, SysUtils, FileUtil, SynEdit, SynHighlighterXML, Forms, Controls,
 Graphics, Dialogs, ExtCtrls, StdCtrls,DOM,XMLWrite,XMLRead,strutils;

type

 { TfXML_Editor }

 TfXML_Editor
 =
 class(TForm)
 published
  bChercher: TButton;
  eChercher: TEdit;
  Panel1: TPanel;
  se: TSynEdit;
  sxs: TSynXMLSyn;
  procedure bChercherClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create( _Name: String); reintroduce;
   destructor Destroy; override;
   procedure Affiche( _S: String);
 end;
 PfXML_Editor= ^TfXML_Editor;

function Assure_fXML_Editor( var _fXML_Editor: TfXML_Editor; _Name: String): TfXML_Editor;

implementation

{$R *.lfm}

{ TfXML_Editor }

function Assure_fXML_Editor(var _fXML_Editor: TfXML_Editor; _Name: String): TfXML_Editor;
begin
     if nil = _fXML_Editor
     then
         _fXML_Editor:= TfXML_Editor.Create( _Name);
     Result:= _fXML_Editor;
end;

constructor TfXML_Editor.Create(_Name: String);
begin
     inherited Create( nil);
     Name:= _Name;
end;

destructor TfXML_Editor.Destroy;
begin
     inherited Destroy;
end;

procedure TfXML_Editor.Affiche(_S: String);
begin
     se.Lines.Text:= _S;
end;

procedure TfXML_Editor.bChercherClick(Sender: TObject);
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

