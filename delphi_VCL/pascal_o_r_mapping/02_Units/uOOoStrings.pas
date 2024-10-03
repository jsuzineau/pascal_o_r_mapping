unit uOOoStrings;
{                                                                             |
    Part of package pOOoDelphiReportEngine                                    |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                          |
            partly as freelance: http://www.mars42.com                        |
        and partly as employee : http://www.batpro.com                        |
    Contact: gilles.doutre@batpro.com                                         |
                                                                              |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                           |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                   |
                                                                              |
    See pOOoDelphiReportEngine.dpk.LICENSE for full copyright notice.         |
|                                                                             }

interface

uses
    uOD_Forms,
 SysUtils, Classes;

const
     sys_Vide= '';

function StrToK( Key: String; var S: String): String;

procedure Modele_inexistant( _NomFichierModele: String);

implementation

function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

procedure Modele_inexistant( _NomFichierModele: String);
var
   S: String;
begin
     if _NomFichierModele = ''
     then
         S:= 'Pas de modèle trouvé pour ce choix.'
     else
         S:= 'Le modèle ci-dessous entre > et < n''existe pas.'#13#10
            +'>'+_NomFichierModele+'<';
     uOD_Forms_ShowMessage( S);
end;

end.
