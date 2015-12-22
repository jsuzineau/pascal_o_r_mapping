unit ufTULEAP;
{                               /ww                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http:/w.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    uTULEAP,

    ublJSON,

    upoolJSON,

    uhVST,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Spin, VirtualTrees,LCLIntf;

type

 { TfTULEAP }

 TfTULEAP
 =
  class(TForm)
   bAuthenticate: TButton;
   bProjects: TButton;
   bAPI_Explorer: TButton;
   cbStreaming: TCheckBox;
   ePassword: TLabeledEdit;
   eUserName: TLabeledEdit;
   m: TMemo;
   Panel1: TPanel;
   Splitter1: TSplitter;
   vst: TVirtualStringTree;
   procedure bAPI_ExplorerClick(Sender: TObject);
   procedure bAuthenticateClick(Sender: TObject);
   procedure bProjectsClick(Sender: TObject);
   procedure cbStreamingChange(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  //TULEAP
  public
    TULEAP: TTULEAP;
    procedure Affiche_Resultat( _JSON: String);
  //Liste de lignes
  public
     sl: TslJSON;
  //Gestionnaire du VST
  private
    hVST: ThVST;
  end;

var
   fTULEAP: TfTULEAP;

implementation

{$R *.lfm}

{ TfTULEAP }

procedure TfTULEAP.FormCreate(Sender: TObject);
begin
     sl:= TslJSON.Create( ClassName+'.sl');
     hVST:= ThVST.Create( vst, sl, poolJSON.Tri, poolJSON.hf);

     TULEAP:= TTULEAP.Create;
     cbStreaming.Checked:= TULEAP.Streaming;

end;

procedure TfTULEAP.FormDestroy(Sender: TObject);
begin
     Free_nil( TULEAP);

     Free_nil( hVST);
     Free_nil( sl);
end;

procedure TfTULEAP.Affiche_Resultat( _JSON: String);
begin
     m.Lines.Add( _JSON);
     poolJSON.Charge_from_JSON( _JSON, sl);
     hVST._from_sl;
end;

procedure TfTULEAP.bAuthenticateClick(Sender: TObject);
begin
     //Affiche_Resultat( TULEAP.Authenticate( eUserName.Text, ePassword.Text));
end;

procedure TfTULEAP.bAPI_ExplorerClick(Sender: TObject);
begin
     LCLIntf.OpenURL( TULEAP.API_Explorer_URL);
end;

procedure TfTULEAP.cbStreamingChange(Sender: TObject);
begin
     TULEAP.Streaming:= cbStreaming.Checked;
end;

procedure TfTULEAP.bProjectsClick(Sender: TObject);
begin
     Affiche_Resultat( TULEAP.json_Projects);
end;

end.

