program http_jsWorks;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
{$apptype console}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  uBatpro_StringList,
  uuStrings,
  ublCategorie,
  ublDevelopment,
  ublProject,
  ublState,
  ublWork,
  uhfCategorie,
  uhfDevelopment,
  uhfJour_ferie,
  uhfProject,
  uhfState,
  uhfWork,
  upoolCategorie,
  upoolDevelopment,
  upoolProject,
  upoolState,
  upoolWork, uPool, upoolG_BECP, uHTTP_Interface, ublAutomatic, upoolAutomatic,
  uContexteClasse, ujpNom_de_la_classe, ujpSQL_CREATE_TABLE,
  ujpPHP_Doctrine_Has_Column, ujpCSharp_Champs_persistants, ujpPascal_Affecte,
  uJoinPoint, uPatternHandler, uhATB, uhAUT, uLog, Interfaces, // this includes the LCL widgetset
Classes, blcksock, sockets, Synautil,SysUtils,LCLIntf, uhAutomatic_ATB, uhAutomatic_AUT;

procedure Traite_Test_AUT;
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
begin
     Repertoire:= 'C:\_freepascal\Test_angular_ui_tree\';
     uri:= HTTP_Interface.uri;
          if '' = uri                                  then Traite_Racine
     else                                                   Traite_Fichier;
end;

var
   HTTP_Interface_URL: String= '';
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
     //HTTP_Interface.Init_from_ClassName();
     S:= HTTP_Interface.Init;
     //Version_avec_complement;
     Version_brute;
     HTTP_Interface_URL:= S;
end;
begin
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;
     //poolProject  .ToutCharger;

     HTTP_Interface.Racine:= '';
     HTTP_Interfaces.Register_pool( poolProject    );
     HTTP_Interfaces.Register_pool( poolWork       );
     HTTP_Interfaces.Register_pool( poolDevelopment);
     HTTP_Interfaces.Register_pool( poolCategorie  );
     HTTP_Interfaces.Register_pool( poolState      );
     //HTTP_Interface.Register_pool( poolAutomatic  ); à voir, conflit avec uhAutomatic_ATB
     HTTP_Interface.slP.Ajoute( 'Test_AUT/', @Traite_Test_AUT);

     //hAutomatic_ATB.Execute_SQL( 'select * from a_cht  where phase <> "0" limit 0,100');
     hAutomatic_ATB.Execute_SQL( 'select * from Work limit 0,100');
     hAutomatic_AUT.Execute_SQL( 'select * from Work limit 0,100');

     Ecrit_URL;
     //HTTP_Interface.Run( True);
     HTTP_Interface.Run( False);
     {
     function ThttpRequete_securise.HTTP_Init: String;
     begin
          hi.Init_from_ClassName( ClassName, Self, HTTP_Traite);

          Result:= hi.Init;
     end;
     procedure ThttpRequete_securise.Execute;
     begin
          Log.PrintLn( 'Ecoute sur: '+ HTTP_Init);
          hi.Run( False);
          Log.PrintLn('http_run terminé');
     end;
     }

     if ParamCount > 0 then OpenURL( HTTP_Interface_URL);
     repeat
           sleep(1000);
     until False;
end.
