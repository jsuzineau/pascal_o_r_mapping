unit uftc_fProgression;
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
  ufProgression,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls;

type
  Tftc_fProgression = class(TForm)
    bDemarre: TButton;
    bAjoute: TButton;
    bTermine: TButton;
    procedure bDemarreClick(Sender: TObject);
    procedure bAjouteClick(Sender: TObject);
    procedure bTermineClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
   ftc_fProgression: Tftc_fProgression;

implementation

{$R *.fmx}

procedure Tftc_fProgression.bDemarreClick(Sender: TObject);
begin
     fProgression.Demarre( 'test', 1, 100);
     fProgression.Demarre( 'sous-test', 1, 100);
end;

procedure Tftc_fProgression.bAjouteClick(Sender: TObject);
begin
     fProgression.AddProgress( 50);
end;

procedure Tftc_fProgression.bTermineClick(Sender: TObject);
begin
     fProgression.Termine;
end;

initialization
              Clean_Create( ftc_fProgression , Tftc_fProgression);
finalization
              Clean_Destroy( ftc_fProgression);
end.
