unit uUseCase;
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
  SysUtils, Classes, Types;

type
 TUseCase
 =
  class
  public
    PackageHandle: HModule;
    PackageName: String;
    constructor Create( unHInstance: HModule);
    function Execute( Params: array of String): Boolean; virtual;
    function Doc: String; virtual;
  //Parametres
  public
    Parametre1: String;
    Parametre2: String;
    Parametre3: String;
    Parametre4: String;
    Parametre5: String;
    Parametre6: String;
	  Parametre7: String;
  //Nom de fichier du package
  public
    procedure Init_PackageName; virtual;
  //Recherche du bpl à partir du nom
  protected
    function NomFichierPackage_from_Nom( Nom: String; var FileName: String): String;
  end;

var
   Ouvre_Modules_LoginProc: procedure = nil;

implementation

{ TUseCase }

constructor TUseCase.Create( unHInstance: HModule);
begin
     PackageHandle:= unHInstance;
     Init_PackageName;
     if Assigned(Ouvre_Modules_LoginProc)
     then
         Ouvre_Modules_LoginProc;
end;

procedure TUseCase.Init_PackageName;
begin
     PackageName:= GetModuleName( PackageHandle);
end;

function TUseCase.Doc: String;
begin
     Result:= 'Use case ' + PackageName+':'#13#10+
              ' pas de documentation spécifique';
end;

function TUseCase.Execute( Params: array of String): Boolean;
var
   L: Integer;
   function T( _S: String): String;
   begin
        //Désactivé 2014/02/18
        //Result:= StringReplace( _S, '-', ' ', [rfReplaceAll]);
        Result:= _S;
   end;
begin
     Result:= True;

     L:= Length( Params);

     if L > 0 then Parametre1:= T( Params[0]) else Parametre1:= '';
     if L > 1 then Parametre2:= T( Params[1]) else Parametre2:= '';
     if L > 2 then Parametre3:= T( Params[2]) else Parametre3:= '';
     if L > 3 then Parametre4:= T( Params[3]) else Parametre4:= '';
     if L > 4 then Parametre5:= T( Params[4]) else Parametre5:= '';
     if L > 5 then Parametre6:= T( Params[5]) else Parametre6:= '';
     if L > 6 then Parametre7:= T( Params[6]) else Parametre7:= '';
end;

function TUseCase.NomFichierPackage_from_Nom( Nom: String;
                                              var FileName: String): String;
var
   Repertoire_EXE: String;
begin
     Repertoire_Exe:= ExtractFilePath( GetModuleName( HInstance));
     FileName:= 'puc'+ Nom + '.bpl';

     Result:= Repertoire_EXE + FileName;
     if not FileExists( Result)
     then
         begin
         Repertoire_Exe:= ExtractFilePath( uForms_EXE_Name);
         Result:= Repertoire_EXE + FileName;
         end;

     if not FileExists( Result)
     then
         begin
         if uForms_pBatpro_Login_Path <> ''
         then
             Result:=  uForms_pBatpro_Login_Path + FileName;
         end;

     if not FileExists( Result)
     then
         begin
         if uForms_pBatpro_EXE_ou_DLL_Path <> ''
         then
             Result:=  uForms_pBatpro_EXE_ou_DLL_Path + FileName;
         end;
end;

end.
