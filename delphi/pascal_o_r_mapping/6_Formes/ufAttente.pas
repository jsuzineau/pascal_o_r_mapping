unit ufAttente;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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

interface

uses
    uClean,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, Buttons, FMX.ExtCtrls;

type
  TfAttente = class(TForm)
    Panel1: TPanel;
    bOK: TBitBtn;
    tShow: TTimer;
    procedure FormDestroy(Sender: TObject);
  public
    function Execute( _Titre: String): Boolean;
  end;

var
   FfAttente: TfAttente;

function fAttente: TfAttente;

implementation

{$R *.dfm}

function fAttente: TfAttente;
begin
     Clean_Get( Result, FfAttente, TfAttente);
end;

{ TfAttente }

function TfAttente.Execute( _Titre: String): Boolean;
begin
     bOK.Caption:= _Titre;

     Sleep( 5000);
     ShowModal;
     Result:= True;
end;

procedure TfAttente.FormDestroy(Sender: TObject);
begin
     tShow.Enabled:= False;
end;

initialization
finalization
              Clean_Destroy( FfAttente);
end.
