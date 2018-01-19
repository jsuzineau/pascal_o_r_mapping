unit uJCL;
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
    //==> dans le programme utiliser uses JCLDebug, JclHookExcept
    //et appeler JclHookExceptions / JclUnHookExceptions
    uClean,
    ufAccueil_Erreur,
  SysUtils, Classes;

procedure uJCL_StackTrace( _Contexte: String; _E: Exception;
                           _Message_Utilisateur: String= 'Erreur système');

implementation

procedure uJCL_StackTrace( _Contexte: String; _E: Exception;
                           _Message_Utilisateur: String= 'Erreur système');
var
   sl: TStringList;
   Message_Exception: String;
   Message_Utilisateur: String;
begin
     if _E = nil
     then
         Message_Exception:= 'Exception : nil'
     else
         Message_Exception:= 'Exception '+_E.Classname+#13#10+_E.Message;
     Message_Utilisateur:= _Message_Utilisateur+#13#10 +Message_Exception;
     sl:= TStringList.Create;

     sl.Add(  _Contexte +#13#10 +Message_Exception);
     sl.Add( _E.StackTrace);

     uClean_Log( sl.Text);
     fAccueil_Erreur( sl.Text, Message_Utilisateur);

     Free_nil( sl);
end;

initialization
finalization
end.
