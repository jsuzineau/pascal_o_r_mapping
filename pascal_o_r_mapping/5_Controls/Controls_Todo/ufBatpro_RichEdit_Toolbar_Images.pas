unit ufBatpro_RichEdit_Toolbar_Images;
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

interface

uses
    uForms,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ImgList, StdActns, ActnList;

type
  TfBatpro_RichEdit_Toolbar_Images = class(TForm)
    i: TImageList;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

procedure Cree_fBatpro_RichEdit_Toolbar_Images;

procedure Detruit_fBatpro_RichEdit_Toolbar_Images;

function fBatpro_RichEdit_Toolbar_Images: TfBatpro_RichEdit_Toolbar_Images;

implementation

uses
    uClean;

{$R *.dfm}

var
   FfBatpro_RichEdit_Toolbar_Images: TfBatpro_RichEdit_Toolbar_Images;

function fBatpro_RichEdit_Toolbar_Images: TfBatpro_RichEdit_Toolbar_Images;
begin
     Clean_Get( Result,
                FfBatpro_RichEdit_Toolbar_Images,
                TfBatpro_RichEdit_Toolbar_Images);
end;

procedure Cree_fBatpro_RichEdit_Toolbar_Images;
begin
     Clean_Create (  FfBatpro_RichEdit_Toolbar_Images,
                    TfBatpro_RichEdit_Toolbar_Images);
     //FfBatpro_RichEdit_Toolbar_Images.Show;
     //uForms_ProcessMessages;
end;

procedure Detruit_fBatpro_RichEdit_Toolbar_Images;
begin
     Clean_Destroy( FfBatpro_RichEdit_Toolbar_Images);
end;

end.
