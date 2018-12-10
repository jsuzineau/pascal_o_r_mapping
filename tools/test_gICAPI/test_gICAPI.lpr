program test_gICAPI;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2018 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{Adapted from The Micro Pascal WebServer, http://wiki.freepascal.org/Networking }

{$mode objfpc}{$H+}
{$IFDEF MSWINDOWS}
{$apptype console}
{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  uBatpro_StringList, uuStrings, uPool, upoolG_BECP, uHTTP_Interface, uLog,
  ujsDataContexte, uNetwork, Interfaces, // this includes the LCL widgetset
Classes, blcksock, sockets, Synautil,SysUtils,LCLIntf;

procedure Traite_angular_test_gICAPI;
var
   Repertoire: String;
   uri: String;
  procedure Traite_Racine;
  var
     NomFichier: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( 'index.html');
       if FileExists( NomFichier)
       then
           begin
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_HTML( S);
           Log.PrintLn( 'Envoi racine ');
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
  procedure Traite_Action;
  begin
       Log.PrintLn( 'Action '+uri);
       HTTP_Interface.Send_JSON('"true"');
end;
  procedure Traite_Data;
  var
     NomFichier: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( 'assets/Data.json');
       if FileExists( NomFichier)
       then
           begin
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_JSON( S);
           Log.PrintLn( 'Envoi Data ');
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
  procedure Traite_Fichier;
  var
     NomFichier: String;
     Extension: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( uri);
       if FileExists( NomFichier)
       then
           begin
           Log.PrintLn( 'Envoi fichier '#13#10+uri);
           Extension:= LowerCase(ExtractFileExt(uri));
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_MIME_from_Extension( S, Extension);
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
  function Prefixe( _Prefixe: String): Boolean;
  begin
       Result:= 1=Pos( _Prefixe, uri);
       if not Result then exit;
       StrTok( _Prefixe, uri);
  end;
begin
     Repertoire:= ExtractFilePath(ParamStr(0))
       +'angular-test-gICAPI'+PathDelim
       +'dist'+PathDelim
       +'angular-test-gICAPI'+PathDelim
       ;
     uri:= HTTP_Interface.uri;
          if '' = uri           then Traite_Racine
     else if Prefixe( 'Action') then Traite_Action
     else if Prefixe( 'Data'  ) then Traite_Data
     else                    Traite_Fichier;
end;

procedure Ecrit_URL;
var
   S: String;
   procedure Version_avec_complement;
   const Taille=1024;
   var
      Complement: Integer;
   begin
        Complement:= Taille-Length(S);
        Write( S+Espaces(Complement));
   end;
   procedure Version_brute;
   begin
        Write( S);
   end;
begin
     S:= HTTP_Interface.URL;
     //Version_avec_complement;
     Version_brute;
end;
begin
     HTTP_Interface.Racine
     :=
        ExtractFilePath(ParamStr(0))
       +'html'+PathDelim
       +'index.html';
     //HTTP_Interface.Register_pool( poolAutomatic  ); à voir, conflit avec uhAutomatic_ATB
     HTTP_Interface.slP.Ajoute( 'angular-test-gICAPI/', @Traite_angular_test_gICAPI);

     HTTP_Interface.Init;

     //Exécution monotâche
     //HTTP_Interface.Run;

     //Exécution asynchrone en thread séparé
     HTTP_Interface.Start;
     //String_to_File( ChangeFileExt( ParamStr(0), '_URL.txt'),HTTP_Interface.URL);
     Ecrit_URL;
     if ParamCount = 0 then OpenURL( HTTP_Interface.URL);
     repeat
           sleep(1000);
     until False;
end.
