unit uCode_barre;
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
    SysUtils, Classes,
    Math,
    u_sys_;

function EAN128( chaine: String): String;


implementation

function EAN128_V1( Chaine: String): String;
  //V 1.0
  //Paramètres : une chaine
  //Retour : * une chaine qui, affichée avec la police CODE128.TTF, donne le code barre
  //         * une chaine vide si paramètre fourni incorrect
var
   i: Integer;
   //checksum&,
   checksum: Integer;
   mini: Integer;
   dummy: Integer;
   tableB: Boolean;

   Chaine_Valide: Boolean;

   LChaine: Integer;
   LResult: Integer;

   procedure testnum;
   var
      i_mini: Integer;
   begin
        //si les mini% caractères à partir de i% sont numériques, alors mini%=0
        Dec( mini);
        i_mini:= i + mini;
        if i_mini <= LChaine
        then
            while mini >= 0
            do
              begin
              i_mini:= i + mini;
              if   (Chaine[i_mini] < #48)
                 or(Chaine[i_mini] > #57)
              then
                  break;
              Dec( mini);
              end;
   end;
begin
     Result:= sys_Vide;

     LChaine:= Length( Chaine);
     if LChaine > 0
     then
         begin
         //Vérifier si caractères valides
         Chaine_Valide:= True;
         for i:= 1 To LChaine
         do
           case Chaine[I]
           of
             #32..#126: begin end;
             else
                 begin
                 Chaine_Valide:= False;
                 break;
                 end;
             end;

         //Calculer la chaine de code en optimisant l'usage des tables B et C
         tableB:= True;
         if Chaine_Valide
         then
             begin
             i:= 1; //i% devient l'index sur la chaine
             while i <= LChaine
             do
               begin
               if tableB
               then
                   begin
                   //Voir si intéressant de passer en table C
                   //Oui pour 4 chiffres au début ou à la fin, sinon pour 6 chiffres
                   mini:= IfThen( (i = 1) or (i + 3 = LChaine), 4, 6);
                   testnum;
                   if mini < 0
                   then //Choix table C
                       begin
                       if i = 1
                       then
                           //Débuter sur table C
                           Result:= #205
                       else
                           //Commuter sur table C
                           Result:= Result + #199;

                       tableB:= False;
                       end
                   else
                       if i= 1
                       then
                           Result:= #204;//Débuter sur table B
                   end;
               if not tableB
               then
                   begin
                   //On est sur la table C, essayer de traiter 2 chiffres
                   mini:= 2;
                   testnum;
                   if mini < 0
                   then //OK pour 2 chiffres, les traiter
                       begin
                       dummy:= StrToInt( Copy( chaine, i, 2));
                       dummy:= IfThen( dummy < 95, dummy + 32, dummy + 100);
                       Result:= Result + Chr( dummy);
                       i:= i + 2;
                       end
                   else
                       //'On n'a pas 2 chiffres, repasser en table B
                       begin
                       Result:=  Result + #200;
                       tableB:= True;
                       end;
                   end;
               if tableB
               then
                   begin
                   //Traiter 1 caractère en table B
                   Result:= Result + chaine[ i];
                   Inc( I);
                   end;
               end;
             //Calcul de la clé de contrôle
             LResult:= Length( Result);
             checksum:= 0;//juste pour le warning du compilateur
             for i:= 1 to LResult
             do
               begin
               dummy:= Ord( Result[i]);
               dummy:= IfThen( dummy < 127, dummy - 32, dummy - 100);
               if i = 1
               then
                   checksum:= dummy;
               checksum:= (checksum + (i - 1) * dummy) Mod 103;
               end;
             //Calcul du code ASCII de la clé
             checksum:= IfThen( checksum < 95, checksum + 32, checksum + 100);
             //Ajout de la clé et du STOP
             Result:= Result + Chr(checksum) + #206;
             end;
         end;
end;

function Code128( chaine: String): String;
  //'Cette fonction est régie par la Licence Générale Publique Amoindrie GNU (GNU LGPL)
  //'This function is governed by the GNU Lesser General Public License (GNU LGPL)
  //'V 2.0.0
  //'Paramètres : une chaine
  //'Parameters : a string
  //'Retour : * une chaine qui, affichée avec la police CODE128.TTF, donne le code barre
  //'         * une chaine vide si paramètre fourni incorrect
  //'Return : * a string which give the bar code when it is dispayed with CODE128.TTF font
  //'         * an empty string if the supplied parameter is no good
var
   i: Integer;
   checksum: Integer;
   mini, dummy: Integer;
   tableB: Boolean;

   procedure testnum;
   begin
        //'si les mini% caractères à partir de i% sont numériques, alors mini%=0
        //'if the mini% characters from i% are numeric, then mini%=0
        Dec( mini);
        if i + mini <= Length(chaine)
        then
            while mini >= 0
            do
              begin
              if    (chaine[i + mini] < #48)
                 or (chaine[i + mini] > #57)
              then
                  break;
              Dec( mini);
              end;
   end;
begin
      Result:= sys_Vide;
      if Length( chaine) > 0
      then
          begin
          //'Vérifier si caractères valides
          //'Check for valid characters
          i:= 1;
          while i <= Length(chaine)
          do
            case Chaine[i]
            of
             #32..#126, #203:
               Inc( I);
             else
               begin
               i:= 0;
               break;
               end;
             end;
          //'Calculer la chaine de code en optimisant l'usage des tables B et C
          //'Calculation of the code string with optimized use of tables B and C
          Result:= sys_Vide;
          tableB:= True;
          if i > 0
          then
              begin
              i:= 1; //'i% devient l'index sur la chaine / i% become the string index
              while i <= Length( chaine)
              do
                begin
                if tableB
                then
                    begin
                    //'Voir si intéressant de passer en table C / See if interesting to switch to table C
                    //'Oui pour 4 chiffres au début ou à la fin, sinon pour 6 chiffres / yes for 4 digits at start or end, else if 6 digits
                    if    (i = 1)
                       or (i + 3 = Length(chaine))
                    then
                        mini:= 4
                    else
                        mini:= 6;

                    testnum;
                    if mini < 0
                    then //'Choix table C / Choice of table C
                        begin
                        if i = 1
                        then //'Débuter sur table C / Starting with table C
                            Result:= #210
                        else //'Commuter sur table C / Switch to table C
                            Result:= Result + #204;
                        tableB:= False;
                        end
                    else
                        if i = 1
                        then
                            Result:= #209;//'Débuter sur table B / Starting with table B
                    end;
                if not tableB
                then
                    begin
                    //'On est sur la table C, essayer de traiter 2 chiffres / We are on table C, try to process 2 digits
                    mini:= 2;
                    testnum;
                    if mini < 0
                    then //'OK pour 2 chiffres, les traiter / OK for 2 digits, process it
                        begin
                        dummy:= StrToInt( Copy(chaine, i, 2));
                        dummy:= IfThen( dummy < 95, dummy + 32, dummy + 105);
                        Result:= Result + Chr(dummy);
                        Inc( i, 2);
                        end
                    else //'On n'a pas 2 chiffres, repasser en table B / We haven't 2 digits, switch to table B
                        begin
                        Result:= Result + #205;
                        tableB:= True;
                        end;
                    end;
                if tableB
                then
                    begin
                    //'Traiter 1 caractère en table B / Process 1 digit with table B
                    Result:= Result + chaine[i];
                    Inc( i);
                    end;
                end;
              //'Calcul de la clé de contrôle / Calculation of the checksum
              checksum:= 0;
              for i:= 1 to Length( Result)
              do
                begin
                dummy:= Ord(Result[ i]);
                if dummy < 127
                then
                    dummy:= dummy - 32
                else
                    dummy:= dummy - 105;
                if i = 1
                then
                    checksum:= dummy;
                checksum:= (checksum + (i - 1) * dummy) mod 103;
                end;
              //'Calcul du code ASCII de la clé / Calculation of the checksum ASCII code
              checksum:= IfThen(checksum < 95, checksum + 32, checksum + 105);
              //'Ajout de la clé et du STOP / Add the checksum and the STOP
              Result:= Result + Chr(checksum) + #211;
              end;
          end;
end;

function Code128_sans_table_C( chaine: String): String;
  //'Cette fonction est régie par la Licence Générale Publique Amoindrie GNU (GNU LGPL)
  //'This function is governed by the GNU Lesser General Public License (GNU LGPL)
  //'V 2.0.0
  //'Paramètres : une chaine
  //'Parameters : a string
  //'Retour : * une chaine qui, affichée avec la police CODE128.TTF, donne le code barre
  //'         * une chaine vide si paramètre fourni incorrect
  //'Return : * a string which give the bar code when it is dispayed with CODE128.TTF font
  //'         * an empty string if the supplied parameter is no good
var
   i: Integer;
   checksum: Integer;
   dummy: Integer;
begin
      Result:= sys_Vide;
      if Length( chaine) > 0
      then
          begin
          //'Vérifier si caractères valides
          //'Check for valid characters
          i:= 1;
          while i <= Length(chaine)
          do
            case Chaine[i]
            of
             #32..#126, #203:
               Inc( I);
             else
               begin
               i:= 0;
               break;
               end;
             end;
          //'Calculer la chaine de code en optimisant l'usage des tables B et C
          //'Calculation of the code string with optimized use of tables B and C
          Result:= sys_Vide;
          if i > 0
          then
              begin
              i:= 1; //'i% devient l'index sur la chaine / i% become the string index
              while i <= Length( chaine)
              do
                begin
                if i = 1
                then
                    Result:= #209;//'Débuter sur table B / Starting with table B
                //'Traiter 1 caractère en table B / Process 1 digit with table B
                Result:= Result + chaine[i];
                Inc( i);
                end;
              //'Calcul de la clé de contrôle / Calculation of the checksum
              checksum:= 0;
              for i:= 1 to Length( Result)
              do
                begin
                dummy:= Ord(Result[ i]);
                if dummy < 127
                then
                    dummy:= dummy - 32
                else
                    dummy:= dummy - 105;
                if i = 1
                then
                    checksum:= dummy;
                checksum:= (checksum + (i - 1) * dummy) mod 103;
                end;
              //'Calcul du code ASCII de la clé / Calculation of the checksum ASCII code
              checksum:= IfThen(checksum < 95, checksum + 32, checksum + 105);
              //'Ajout de la clé et du STOP / Add the checksum and the STOP
              Result:= Result + Chr(checksum) + #211;
              end;
          end;
end;

function EAN128( chaine: String): String;
begin
     Result:= Code128_sans_table_C( chaine);
end;

end.

