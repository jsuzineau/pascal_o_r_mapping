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
    uOOoChrono,
    uOpenDocument,
 Classes, SysUtils, FileUtil, SynEdit, SynHighlighterXML, Forms, Controls,
 Graphics, Dialogs, ExtCtrls, StdCtrls,DOM,XMLWrite,XMLRead,strutils;

type

 PTXMLDocument= ^TXMLDocument;

 { TfXML_Editor }

 TfXML_Editor
 =
 class(TForm)
 published
  bChercher: TButton;
  bValider: TButton;
  eChercher: TEdit;
  Panel1: TPanel;
  se: TSynEdit;
  sxs: TSynXMLSyn;
  procedure bChercherClick(Sender: TObject);
  procedure bValiderClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create( _Name: String;
                       _od: TOpenDocument;
                       _xml: PTXMLDocument); reintroduce;
   destructor Destroy; override;
 //od
 private
   od: TOpenDocument;
 //xml
 private
   xml: PTXMLDocument;
 public
   procedure _from_xml;
   procedure _to_xml;
 end;
 PfXML_Editor= ^TfXML_Editor;

function Assure_fXML_Editor( var _fXML_Editor: TfXML_Editor; _Name: String; _od: TOpenDocument; _xml: PTXMLDocument): TfXML_Editor;

implementation

{$R *.lfm}

{ TfXML_Editor }

function Assure_fXML_Editor( var _fXML_Editor: TfXML_Editor; _Name: String; _od: TOpenDocument; _xml: PTXMLDocument): TfXML_Editor;
begin
     if nil = _fXML_Editor
     then
         _fXML_Editor:= TfXML_Editor.Create( _Name, _od, _xml);
     Result:= _fXML_Editor;
end;

constructor TfXML_Editor.Create( _Name: String; _od: TOpenDocument; _xml: PTXMLDocument);
begin
     inherited Create( nil);
     Name:= _Name;
     od := _od;
     xml:= _xml;
     _from_xml;
end;

destructor TfXML_Editor.Destroy;
begin
     inherited Destroy;
end;

procedure TfXML_Editor._from_xml;
var
   ms: TMemoryStream;
begin
     ms:= TMemoryStream.Create;
     try
        WriteXML( xml^, ms);
        ms.Position:=0;
        se.Lines.LoadFromStream( ms);
     finally
            FreeAndNil( ms);
            end;
     OOoChrono.Stop( 'Chargement de l''objet XML dans l''éditeur '+Name+':'+ClassName);
end;

procedure TfXML_Editor._to_xml;
var
   ms: TMemoryStream;
begin
     FreeAndnil( xml^);
     ms:= TMemoryStream.Create;
     try
        se.Lines.SaveToStream( ms);
        ms.Position:= 0;
        ReadXMLFile( xml^, ms);
     finally
            FreeAndNil( ms);
            end;
end;


procedure TfXML_Editor.bValiderClick(Sender: TObject);
begin
     _to_xml;
     od.pChange.Publie;
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

