unit ufFichier;

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
    uOD_Forms, Classes, SysUtils, FileUtil, SynEdit, SynHighlighterXML, Forms,
    Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ActnList, StdActns, DOM,
    XMLWrite, XMLRead, strutils;

type
 { TfFichier }

 TfFichier
 =
 class(TForm)
 published
  aChercher: TAction;
  aSauver: TAction;
  al: TActionList;
  bChercher: TButton;
  bSauver: TButton;
  eChercher: TEdit;
  Panel1: TPanel;
  se: TSynEdit;
  sxs: TSynXMLSyn;
  procedure aChercherExecute(Sender: TObject);
  procedure aSauverExecute(Sender: TObject);
  procedure seChange(Sender: TObject);
//Gestion du cycle de vie
 public
   constructor Create( _Name: String;
                       _FileName: String); reintroduce;
   destructor Destroy; override;
 //FileName
 private
   FileName: String;
 public
   procedure _from_FileName;
   procedure _to_FileName;
 end;
 PfFichier= ^TfFichier;

function Assure_fFichier( var _fFichier: TfFichier; _Name: String; _FileName: String): TfFichier;

implementation

{$R *.lfm}

{ TfFichier }

function Assure_fFichier( var _fFichier: TfFichier; _Name: String; _FileName: String): TfFichier;
begin
     if nil = _fFichier
     then
         _fFichier:= TfFichier.Create( _Name, _FileName);
     Result:= _fFichier;
end;

constructor TfFichier.Create(_Name: String; _FileName: String);
begin
     inherited Create( nil);
     Name    := _Name    ;
     FileName:= _FileName;
     _from_FileName;
end;

destructor TfFichier.Destroy;
begin
     inherited Destroy;
end;

procedure TfFichier._from_FileName;
begin
     se.Lines.LoadFromFile( FileName);
     aSauver.Visible:= False;
end;

procedure TfFichier._to_FileName;
begin
     se.Lines.SaveToFile( FileName);
     aSauver.Visible:= False;
end;

procedure TfFichier.aSauverExecute(Sender: TObject);
begin
     _to_FileName;
end;

procedure TfFichier.seChange(Sender: TObject);
begin
     aSauver.Visible:= True;
end;

procedure TfFichier.aChercherExecute(Sender: TObject);
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

