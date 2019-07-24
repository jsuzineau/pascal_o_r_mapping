unit uUseCases;
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
    uClean,
    uuStrings,
    uChrono,
    u_sys_,
    uUseCase,
    uPublieur,
    uVersion,
    uEtat,
    SysUtils, Classes;

type
 TUseCases
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Général
  private
    sl: TStringList;
    function GetItem( Nom: String): TUseCase;
    function Charge_UseCase( NomFichierPackage: String): TUseCase;
  public
    procedure Add_UseCase   ( UseCase: TUseCase);
    procedure Remove_UseCase( UseCase: TUseCase);
    property Items[ Nom: String]: TUseCase read GetItem; default;
    function Is_loaded( Nom: String):Boolean;
    procedure GetVersions( S: TStrings);
  //gardé pour archive, génère facilement des plantages
  private
    procedure Decharge;
  //Recherche du bpl à partir du nom
  private
    Premier: Boolean;
    function NomFichierPackage_from_Nom( Nom: String; var FileName: String): String;
  end;

var
   UseCases: TUseCases;

function UsesCase_Execute( _UseCase: String; _Params: array of String): Boolean;

implementation

function UsesCase_Execute( _UseCase: String; _Params: array of String): Boolean;
begin
     UseCases[_UseCase].Execute( _Params);
end;

{ TUseCases }

constructor TUseCases.Create;
begin
     inherited Create;
     Premier:= True;
     sl:= TStringList.Create;

     Add_UseCase( TUseCase.Create( 0));//Le use case vide en n°0
end;

procedure TUseCases.Decharge;
var
   uc: TUseCase;
   I: Integer;
   PackageHandle: HModule;
begin
     while sl.Count > 0
     do
       begin
       I:= sl.Count -1;
       uc:= TUseCase(sl.Objects[I]);
       if Assigned( uc)
       then
           begin
           PackageHandle:= uc.PackageHandle;
           if PackageHandle <> 0
           then
               begin end (*UnloadPackage( PackageHandle)*)
           else
               begin    // le use case vide
               uc.Free;
               sl.Delete( I);
               end
           end;
       end;
end;

destructor TUseCases.Destroy;
begin
     //Decharge;
     Free_nil( sl);
     inherited;
end;

procedure TUseCases.Add_UseCase( UseCase: TUseCase);
begin
     if UseCase= nil then exit;
     sl.AddObject( UseCase.PackageName, UseCase);
end;

procedure TUseCases.Remove_UseCase(UseCase: TUseCase);
var
   I: Integer;
begin
     if UseCase= nil then exit;
     //uForms_MessageBox( 'pUseCases', 'Déchargement de '+UseCase.PackageName));
     I:= sl.IndexOfObject( UseCase);
     if I <> - 1
     then
         sl.Delete( I);
end;

function TUseCases.Charge_UseCase( NomFichierPackage: String): TUseCase;
var
   I: Integer;
   FileFound: Boolean;
begin
     FileFound:= FileExists( NomFichierPackage);

     if FileFound
     then
         begin
         (*LoadPackage( NomFichierPackage);*)
         I:= sl.IndexOf( NomFichierPackage);
         if I = -1 //si non trouvé, on prend le use case vide en n°0
         then
             begin
             I:= 0;
             uForms_ShowMessage(  'La fonctionnalité (use case) n''a pas pu être chargée: '
                          +NomFichierPackage+#13
                          +'Liste des paquets chargés:'#13
                          +sl.Text);
             end;
         end
     else
         begin
         I:= 0;
         uForms_ShowMessage( 'La fonctionnalité (use case) n''a pas été trouvée: '
                      +NomFichierPackage);
         end;

     Result:= TUseCase( sl.Objects[I]);
end;

function TUseCases.NomFichierPackage_from_Nom( Nom: String; var FileName: String): String;
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
             begin
             Result:=  uForms_pBatpro_Login_Path + FileName;
             if     FileExists( Result)
                and (0= Pos('C:\2_source\', uForms_EXE_Name))//= si on n'est pas sur la machine de développement
                and Premier
             then
                 begin
                 //uForms_ShowMessage(  'La fonctionnalité (use case) a été trouvée '
                 //             +'dans le répertoire du paquet pBatpro_Login:'#13#10
                 //             +Result+#13#10
                 //             +'Répertoire de l''EXE'#13#10
                 //             +Repertoire_EXE+#13#10
                 //             +'Exécutable'#13#10
                 //             +uForms_EXE_Name
                 //             );
                 Premier:= False;
                 end;
             end;
         end;

     if not FileExists( Result)
     then
         begin
         if uForms_pBatpro_EXE_ou_DLL_Path <> ''
         then
             begin
             Result:=  uForms_pBatpro_EXE_ou_DLL_Path + FileName;
             if     FileExists( Result)
                and (0= Pos('C:\2_source\', uForms_EXE_Name))//= si on n'est pas sur la machine de développement
                and Premier
             then
                 begin
                 //uForms_ShowMessage(  'La fonctionnalité (use case) a été trouvée '
                 //             +'dans le répertoire du paquet pBatpro_Login:'#13#10
                 //             +Result+#13#10
                 //             +'Répertoire de l''EXE'#13#10
                 //             +Repertoire_EXE+#13#10
                 //             +'Exécutable'#13#10
                 //             +uForms_EXE_Name
                 //             );
                 Premier:= False;
                 end;
             end;
         end;
end;

function TUseCases.Is_loaded(Nom: String): Boolean;
var
   FileName: String;
begin
     Result:= -1 <> sl.IndexOf( NomFichierPackage_from_Nom( Nom,FileName));
end;

function TUseCases.GetItem(Nom: String): TUseCase;
var
   FileName: String;
   I: Integer;
   NomFichierPackage: String;
begin
     //Chrono.Stop( 'TUseCases.GetItem( '+Nom+') Debut ');
     NomFichierPackage:= NomFichierPackage_from_Nom( Nom, FileName);

     I:= sl.IndexOf( NomFichierPackage);

     if I = -1
     then
         begin
         Etat.Change( 'Chargement du paquet '+ FileName);
         Result:= Charge_UseCase( NomFichierPackage);
         Etat.Change( sys_Vide);
         end
     else
         Result:= TUseCase( sl.Objects[I]);
     //Chrono.Stop( 'TUseCases.GetItem( '+Nom+') Fin ');
end;

procedure TUseCases.GetVersions(S: TStrings);
var
   I: Integer;
   uc: TUseCase;
begin
     S.Clear;
     for I:= 0 to sl.Count - 1
     do
       begin
       uc:= TUseCase( sl.Objects[I]);
       S.Add( GetVersionModule( uc.PackageHandle));
       end;
end;

{ TUseCase_Vide }


initialization
              UseCases:= TUseCases.Create;
              uClean_UsesCase_ExecuteFunction:= UsesCase_Execute;
finalization
              uClean_UsesCase_ExecuteFunction:= nil;
              Free_nil( UseCases);
end.
