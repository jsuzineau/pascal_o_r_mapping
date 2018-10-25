unit ufAfficher;

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
 { TfAfficher }

 TfAfficher
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
  aSearchFind: TSearchFind;
  sxs: TSynXMLSyn;
  procedure aChercherExecute(Sender: TObject);
  procedure aSauverExecute(Sender: TObject);
  procedure aSearchFindAccept(Sender: TObject);
  procedure seChange(Sender: TObject);
//Gestion du cycle de vie
 public
   constructor Create( _Name: String;
                       _S: String); reintroduce;
   destructor Destroy; override;
 //FileName
 private
   S: String;
 public
   procedure _from_S;
   procedure _to_S;
 end;
 PfAfficher= ^TfAfficher;

function Assure_fAfficher( var _fAfficher: TfAfficher; _Name: String; _S: String): TfAfficher;

implementation

{$R *.lfm}

{ TfAfficher }

function Assure_fAfficher(var _fAfficher: TfAfficher; _Name: String; _S: String): TfAfficher;
begin
     if nil = _fAfficher
     then
         _fAfficher:= TfAfficher.Create( _Name, _S);
     Result:= _fAfficher;
end;

constructor TfAfficher.Create(_Name: String; _S: String);
begin
     inherited Create( nil);
     Name:= _Name;
     S   := _S   ;
     _from_S;
end;

destructor TfAfficher.Destroy;
begin
     inherited Destroy;
end;

procedure TfAfficher._from_S;
begin
     se.Lines.Text:= S;
     aSauver.Visible:= False;
end;

procedure TfAfficher._to_S;
begin
     S:= se.Lines.Text;
     aSauver.Visible:= False;
end;

procedure TfAfficher.aSauverExecute(Sender: TObject);
begin
     _to_S;
end;

procedure TfAfficher.aSearchFindAccept(Sender: TObject);
begin

end;

procedure TfAfficher.seChange(Sender: TObject);
begin
     aSauver.Visible:= True;
end;

procedure TfAfficher.aChercherExecute(Sender: TObject);
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

