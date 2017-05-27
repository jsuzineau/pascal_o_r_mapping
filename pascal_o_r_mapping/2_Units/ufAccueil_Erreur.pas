unit ufAccueil_Erreur;
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
    uuStrings,
    {$IFDEF FPC}
    uLog,
    {$ENDIF}
  SysUtils, Classes, DB;

type
    TfAccueil_Erreur_function = function  ( _Message_Developpeur: String; _Message: String = ''): Boolean of object;
    TfAccueil_log_procedure   = procedure ( _Message_Developpeur: String; _Message: String = '') of object;
    TfAccueil_Dataset_Log_row_procedure   = procedure ( _ds: TDataset) of object;
    TfAccueil_Has_Log_function = function : Boolean of Object;
    TfAccueil_Execute_function = function : Boolean of Object;
    TfAccueil_Set_Has_Log_procedure= procedure ( _Has_Log: Boolean) of Object;

var
   fAccueil_Erreur_function: TfAccueil_Erreur_function = nil;
   fAccueil_log_procedure: TfAccueil_log_procedure = nil;
   fAccueil_LogBas_procedure: TfAccueil_log_procedure = nil;
   fAccueil_LogBas_ShowMessage_procedure: TfAccueil_log_procedure = nil;
   fAccueil_Dataset_Log_row_procedure: TfAccueil_Dataset_Log_row_procedure= nil;
   fAccueil_Has_Log_function: TfAccueil_Has_Log_function= nil;
   fAccueil_Execute_function: TfAccueil_Execute_function = nil;
   fAccueil_Set_Has_Log_procedure: TfAccueil_Set_Has_Log_procedure= nil;
   ufAccueil_Erreur_Tampon: String= '';

function  fAccueil_Erreur( _Message_Developpeur: String; _Message: String = ''): Boolean;

procedure fAccueil_Log( _Message_Developpeur: String; _Message: String = '');

procedure fAccueil_LogBas( _Message_Developpeur: String; _Message: String = '');

procedure fAccueil_LogBas_ShowMessage( _Message_Developpeur: String; _Message: String = '');

procedure fAccueil_Dataset_Log_row( _ds: TDataset);

function fAccueil_Has_Log: Boolean;
procedure fAccueil_Set_Has_Log( _Has_Log: Boolean);

function fAccueil_Execute: Boolean;

implementation

procedure ufAccueil_Erreur_Add( _Message_Developpeur: String; _Message: String);
begin
     Formate_Liste( ufAccueil_Erreur_Tampon, #13#10, _Message            );
     Formate_Liste( ufAccueil_Erreur_Tampon, #13#10, _Message_Developpeur);
     {$IFDEF FPC}
	      Log.PrintLn( _Message);
	      Log.PrintLn( _Message_Developpeur);
	      {$IFDEF ANDROID}
		       WriteLn( _Message);
		       WriteLn( _Message_Developpeur);
	      {$ENDIF}
     {$ENDIF}
end;

function fAccueil_Erreur( _Message_Developpeur: String; _Message: String = ''): Boolean;
begin
     if Assigned( fAccueil_Erreur_function)
     then
         Result:= fAccueil_Erreur_function( _Message_Developpeur, _Message)
     else
         begin
         ufAccueil_Erreur_Add( _Message_Developpeur, _Message);
         uForms_ShowMessage( Formate_Liste( [_Message, _Message_Developpeur], #13#10));
         Result:= True;
         end;
end;

procedure fAccueil_Log( _Message_Developpeur: String; _Message: String = '');
begin
     if Assigned( fAccueil_log_procedure)
     then
         fAccueil_log_procedure( _Message_Developpeur, _Message)
     else
         ufAccueil_Erreur_Add( _Message_Developpeur, _Message);
end;

procedure fAccueil_LogBas( _Message_Developpeur: String; _Message: String = '');
begin
     if Assigned( fAccueil_LogBas_procedure)
     then
         fAccueil_LogBas_procedure( _Message_Developpeur, _Message)
     else
         ufAccueil_Erreur_Add( _Message_Developpeur, _Message);
end;

procedure fAccueil_LogBas_ShowMessage( _Message_Developpeur: String; _Message: String = '');
begin
     if Assigned( fAccueil_LogBas_ShowMessage_procedure)
     then
         fAccueil_LogBas_ShowMessage_procedure( _Message_Developpeur, _Message)
     else
         ufAccueil_Erreur_Add( _Message_Developpeur, _Message);
end;

procedure fAccueil_Dataset_Log_row( _ds: TDataset);
begin
     if Assigned( fAccueil_Dataset_Log_row_procedure)
     then
         fAccueil_Dataset_Log_row_procedure( _ds)
     else
         ufAccueil_Erreur_Add( 'ufAccueil_Erreur: fAccueil_Dataset_Log_row_procedure non initialisé', 'Log_row');
end;

procedure fAccueil_Set_Has_Log( _Has_Log: Boolean);
begin

     if Assigned( fAccueil_Set_Has_Log_procedure)
     then
         fAccueil_Set_Has_Log_procedure( _Has_Log)
     else
         ufAccueil_Erreur_Add( 'ufAccueil_Erreur: fAccueil_Set_Has_Log_procedure non initialisé', 'Set_Has_Log');
end;

function fAccueil_Has_Log: Boolean;
begin
     Result:= False;
     if Assigned( fAccueil_Has_Log_function)
     then
         Result:= fAccueil_Has_Log_function()
     else
         ufAccueil_Erreur_Add( 'ufAccueil_Erreur: fAccueil_Has_Log_function non initialisé', 'Has_Log');
end;

function fAccueil_Execute: Boolean;
begin
     Result:= False;
     if Assigned( fAccueil_Execute_function)
     then
         Result:= fAccueil_Execute_function()
     else
         ufAccueil_Erreur_Add( 'ufAccueil_Erreur: fAccueil_Execute_function non initialisé', 'Execute');
end;


end.
