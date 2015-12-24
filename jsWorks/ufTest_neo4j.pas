unit ufTest_neo4j;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
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
    uNEO4J,

    upoolJSON,

    uhVST,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Spin, VirtualTrees;

type

 { TfTest_neo4j }

 TfTest_neo4j
 =
  class(TForm)
   bAuthenticate: TButton;
   bServiceRoot: TButton;
   bProperty_Keys: TButton;
   bCreate_node: TButton;
   bGet_node: TButton;
   cbStreaming: TCheckBox;
   ePassword: TLabeledEdit;
   eUserName: TLabeledEdit;
   m: TMemo;
   Panel1: TPanel;
   seNode: TSpinEdit;
   Splitter1: TSplitter;
   vst: TVirtualStringTree;
   procedure bAuthenticateClick(Sender: TObject);
   procedure bCreate_nodeClick(Sender: TObject);
   procedure bGet_nodeClick(Sender: TObject);
   procedure bProperty_KeysClick(Sender: TObject);
   procedure bServiceRootClick(Sender: TObject);
   procedure cbStreamingChange(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  //Neo4j
  public
    neo4j: TNEO4J;
    procedure Affiche_Resultat( _JSON: String);
  //Liste de lignes
  public
     sl: TslJSON;
  //Gestionnaire du VST
  private
    hVST: ThVST;
  end;

var
   fTest_neo4j: TfTest_neo4j;

implementation

{$R *.lfm}

{ TfTest_neo4j }

procedure TfTest_neo4j.FormCreate(Sender: TObject);
begin
     sl:= TslJSON.Create( ClassName+'.sl');
     hVST:= ThVST.Create( vst, sl, poolJSON.Tri, poolJSON.hf);

     neo4j:= TNEO4J.Create;
     cbStreaming.Checked:= neo4j.Streaming;

end;

procedure TfTest_neo4j.FormDestroy(Sender: TObject);
begin
     Free_nil( neo4j);

     Free_nil( hVST);
     Free_nil( sl);
end;

procedure TfTest_neo4j.Affiche_Resultat( _JSON: String);
begin
     m.Lines.Add( _JSON);
     poolJSON.Charge_from_JSON( _JSON, sl);
     hVST._from_sl;
end;

procedure TfTest_neo4j.bAuthenticateClick(Sender: TObject);
begin
     Affiche_Resultat( neo4j.Authenticate( eUserName.Text, ePassword.Text));
end;

procedure TfTest_neo4j.bServiceRootClick(Sender: TObject);
begin
     Affiche_Resultat( neo4j.ServiceRoot);
end;

procedure TfTest_neo4j.cbStreamingChange(Sender: TObject);
begin
     neo4j.Streaming:= cbStreaming.Checked;
end;

procedure TfTest_neo4j.bProperty_KeysClick(Sender: TObject);
begin
     Affiche_Resultat( neo4j.Property_Keys);
end;

procedure TfTest_neo4j.bCreate_nodeClick(Sender: TObject);
begin
     Affiche_Resultat( neo4j.Create_node('{"foo": "bar"}'));
end;

procedure TfTest_neo4j.bGet_nodeClick(Sender: TObject);
begin
     Affiche_Resultat( neo4j.Get_node(seNode.Value));
end;

end.

