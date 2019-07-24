unit uAide;
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
    SysUtils, Classes, Forms, LCLIntf;

{ class TObjet_Aide
Cette classe est créée uniquement parce que Application.OnHelp et TForm.OnHelp
doivent être obligatoirement la méthode d'un objet
(THelpEvent est une "function of object").
}
type
 TObjet_Aide
 =
  class
  public
    function Aide_Batpro( Command: Word; Data: PtrInt;var CallHelp: Boolean): Boolean;
    function Aide_nulle ( Command: Word; Data: PtrInt;var CallHelp: Boolean): Boolean;
  public
    Aide: THelpEvent;
    procedure Accroche_Aide_Batpro;
    procedure Accroche_Aide_nulle;
    procedure Desaccroche;
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  end;
var
   Objet_Aide: TObjet_Aide;

function ShowURL( URL: String): Boolean;
function PrintURL( URL: String): Boolean;

procedure MontreAide( NomAide: String);

procedure AideSommaire;

procedure AidePageAccueil;

implementation

uses
    uClean,
    u_sys_,
    ufHelp_Creator,
    uParametres_Ligne_de_commande;

const
     sys_Sommaire= 'sommaire';
     file_ExtensionAide= '.htm';

function AidePath( Nom: String): String;
begin
     Result:= ExtractFilePath(ParamStr(0))+'doc'+PathDelim+ Nom + file_ExtensionAide;
end;

function ShowURL( URL: String): Boolean;
begin
     //Result:= 32 < ShellExecute( 0, 'open', 'iexplore', PChar(URL),nil,SW_SHOWNORMAL);
     //Result:= 32 < ShellExecute( 0, 'open', PChar(URL),nil,nil,SW_SHOWNORMAL);
     Result:= LCLIntf.OpenURL( URL);
end;

function PrintURL( URL: String): Boolean;
begin
     //Result:= 32 < ShellExecute( 0, 'print', PChar(URL),nil,nil,SW_SHOWNORMAL);
     Result:= LCLIntf.OpenURL( URL);
end;

procedure MontreAide( NomAide: String);
var
   URL: String;
begin
     URL:= AidePath(NomAide);
     if not FileExists( URL)
     then
         URL:= AidePath( sys_Sommaire);
     ShowURL( URL);
end;

procedure AideSommaire;
begin
     MontreAide( sys_Sommaire);
end;

procedure AidePageAccueil;
begin
     ShowURL( 'http://www.batpro.com/');
end;


function TObjet_Aide.Aide_Batpro( Command: Word; Data: PtrInt;
                                  var CallHelp: Boolean): Boolean;
var
   NomAide: String;
   ActiveForm: TCustomForm;
begin
     NomAide:= sys_Sommaire;

     ActiveForm := Screen.ActiveCustomForm;
     if Assigned(ActiveForm)
     then
         begin
         NomAide:= ActiveForm.HelpFile;
         if NomAide = sys_Vide
         then
             NomAide:= ActiveForm.Name;
         end;
     if ModeHELP_CREATOR
     then
         Result
         :=
           fHelp_Creator.Execute( Command, Data, CallHelp,
                                  AidePath(NomAide), ActiveForm)
     else
         begin
         MontreAide( NomAide);

         CallHelp:= False;
         Result:= True;
         end;
end;

function TObjet_Aide.Aide_nulle( Command: Word; Data: PtrInt;
                                 var CallHelp: Boolean): Boolean;
begin
     CallHelp:= False;
     Result:= True;
end;

procedure TObjet_Aide.Accroche_Aide_Batpro;
begin
     Aide:= Aide_Batpro;
     {$IFNDEF FPC} Application.OnHelp:= Aide; {$ENDIF}
end;

procedure TObjet_Aide.Accroche_Aide_nulle;
begin
     Aide:= Aide_nulle;
     {$IFNDEF FPC} Application.OnHelp:= Aide; {$ENDIF}
end;

procedure TObjet_Aide.Desaccroche;
begin
     Aide:= nil;
     {$IFNDEF FPC} Application.OnHelp:= Aide; {$ENDIF}
end;

constructor TObjet_Aide.Create;
begin
     inherited;
     Accroche_Aide_Batpro;
     //Desaccroche;
end;

destructor TObjet_Aide.Destroy;
begin
     Desaccroche;
     inherited;
end;

initialization
              Objet_Aide:= TObjet_Aide.Create;
finalization
              Free_nil( Objet_Aide);
end.
