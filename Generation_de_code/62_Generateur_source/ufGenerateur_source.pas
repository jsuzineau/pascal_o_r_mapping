unit ufGenerateur_source;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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

{$mode objfpc}{$H+}

interface

uses
    uOD_Forms,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfGenerateur_source }

  TfGenerateur_source = class(TForm)
   Button1: TButton;
   eThaElement: TEdit;
   eTElement: TEdit;
   eSuffixe: TEdit;
   gbModele: TGroupBox;
   gbProduit: TGroupBox;
   Label1: TLabel;
   Label2: TLabel;
   mProduit: TMemo;
   Nom: TLabel;
   mModele: TMemo;
   Panel1: TPanel;
   Splitter1: TSplitter;
   procedure Button1Click(Sender: TObject);
   procedure eSuffixeChange(Sender: TObject);
   procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fGenerateur_source: TfGenerateur_source;

implementation

{$R *.lfm}

{ TfGenerateur_source }

procedure TfGenerateur_source.Button1Click(Sender: TObject);
var
   S: String;
begin

     S:= mModele.Lines.Text;
     S:= StringReplace( S, 'Suffixe'   , eSuffixe   .Text, [rfReplaceAll]);
     S:= StringReplace( S, 'TElement'  , eTElement  .Text, [rfReplaceAll]);
     S:= StringReplace( S, 'ThaElement', eThaElement.Text, [rfReplaceAll]);

     mProduit.Lines.Text:= S;
     mProduit.SetFocus;
end;

procedure TfGenerateur_source.eSuffixeChange(Sender: TObject);
begin
     eTElement  .Text:= 'Tbl'+eSuffixe.Text;
     eThaElement.Text:= 'Tha'+eSuffixe.Text;
end;

procedure TfGenerateur_source.FormCreate(Sender: TObject);
begin
     mModele.Lines.LoadFromFile( ExtractFilePath( uOD_Forms_EXE_Name)+'uModele.pas');
     mModele.Lines.Text:= AnsiToUtf8( mModele.Lines.Text);
end;

end.

