unit ufBloqueur;
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
    uClean,
    uPublieur,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfBloqueur = class(TForm)
    tShow: TTimer;
    procedure tShowTimer(Sender: TObject);
  private
    F: TForm;
    Proc: TAbonnement_Objet_Proc;
  end;

procedure Bloque( _F: TForm; _Proc: TAbonnement_Objet_Proc);

implementation

{$R *.dfm}

procedure Bloque( _F: TForm; _Proc: TAbonnement_Objet_Proc);
var
   fBloqueur: TfBloqueur;
begin
     Clean_Create( fBloqueur, TfBloqueur);
     try
        fBloqueur.F:= _F;
        fBloqueur.Proc:= _Proc;
        if _F = nil
        then
            fBloqueur.WindowState:= wsMaximized
        else
            begin
            fBloqueur.Top   := _F.Top   ;
            fBloqueur.Left  := _F.Left  ;
            fBloqueur.Width := _F.Width ;
            fBloqueur.Height:= _F.Height;
            end;
        fBloqueur.ShowModal;
     finally
            Clean_Destroy( fBloqueur);
            end;
end;

{ TfBloqueur }

procedure TfBloqueur.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     try
        Proc;
     finally
            ModalResult:= mrOk;
            end;
end;

end.
