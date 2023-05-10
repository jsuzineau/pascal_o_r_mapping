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
    uBatpro_StringList,
    uTuleap,

    upoolJSON,

    uhVST,
  blcksock,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Spin, VirtualTrees,LCLIntf;

type

 { TfTULEAP }

 TfTULEAP
 =
  class(TForm)
   bAuthenticate: TButton;
   bGenere: TButton;
   bProjects: TButton;
   bAPI_Explorer: TButton;
   bTrackers: TButton;
   cbStreaming: TCheckBox;
   eProject: TEdit;
   ePassword: TLabeledEdit;
   eRoot_URL: TEdit;
   eUserName: TLabeledEdit;
   Label1: TLabel;
   Label2: TLabel;
   lSSL: TLabel;
   m: TMemo;
   Panel1: TPanel;
   Splitter1: TSplitter;
   vst: TVirtualStringTree;
   procedure bAPI_ExplorerClick(Sender: TObject);
   procedure bAuthenticateClick(Sender: TObject);
   procedure bGenereClick(Sender: TObject);
   procedure bProjectsClick(Sender: TObject);
   procedure bTrackersClick(Sender: TObject);
   procedure cbStreamingChange(Sender: TObject);
   procedure eRoot_URLChange(Sender: TObject);
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

     lSSL.Caption:= 'SSLImplementation: '+blcksock.SSLImplementation.ClassName;

     eRoot_URL.Text:= TULEAP.Root_URL;
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
     Affiche_Resultat( TULEAP.Authenticate( eUserName.Text, ePassword.Text));
end;

procedure TfTULEAP.bGenereClick(Sender: TObject);
var
   bl: TblJSON;
   NomTable: String;
begin
     if sl.Count = 0                          then exit;
     if Affecte_( bl, TblJSON, sl.Objects[0]) then exit;

     NomTable:= 'Nouveau';
     if not InputQuery( 'Génération de code', 'Suffixe d''identification (nom de la table)', NomTable) then exit;

     bl.Genere_code( NomTable);
end;

procedure TfTULEAP.bAPI_ExplorerClick(Sender: TObject);
begin
     LCLIntf.OpenURL( TULEAP.API_Explorer_URL);
end;

procedure TfTULEAP.cbStreamingChange(Sender: TObject);
begin
     TULEAP.Streaming:= cbStreaming.Checked;
end;

procedure TfTULEAP.eRoot_URLChange(Sender: TObject);
begin
     TULEAP.Root_URL:= eRoot_URL.Text;
end;

procedure TfTULEAP.bProjectsClick(Sender: TObject);
begin
     Affiche_Resultat( TULEAP.json_Projects);
end;

procedure TfTULEAP.bTrackersClick(Sender: TObject);
begin
     Affiche_Resultat( TULEAP.json_Trackers( eProject.Text));
end;

end.

