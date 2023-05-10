unit uf_f_dbgKeyPress_Key_Pattern;
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
    Messages, SysUtils, Variants, Classes, FMX.Forms, FMX.Memo, Vcl.Controls,
  Vcl.StdCtrls;

type
  Tf_f_dbgKeyPress_Key_Pattern = class(TForm)
    m: TMemo;
    mVariables: TMemo;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Traite( Condition: String; var Bloc, Vars: String);
  end;

var
   f_f_dbgKeyPress_Key_Pattern: Tf_f_dbgKeyPress_Key_Pattern;

implementation

{$R *.dfm}

{ Tf_f_dbgKeyPress_Key_Pattern }

procedure Tf_f_dbgKeyPress_Key_Pattern.Traite(Condition: String; var Bloc,Vars: String);
begin
     if Condition = ''
     then
         begin
         Bloc:= '';
         Vars:= '';
         end
     else
         begin
         Bloc:= Format( m.Text, [Condition]);
         Vars:= mVariables.Text;
         end;
end;

initialization
              f_f_dbgKeyPress_Key_Pattern:= Tf_f_dbgKeyPress_Key_Pattern.Create( nil);
finalization
            FreeAndNil( f_f_dbgKeyPress_Key_Pattern);
end.
