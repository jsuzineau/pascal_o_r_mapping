unit uhdmTestDockableScrollbox;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean,
    uLog,
    uEXE_INI,
    uVide,
    uuStrings,
    ufAccueil_Erreur,
    uBatpro_StringList,
    uBatpro_Element,
    ublTestDockableScrollbox,

 Classes, SysUtils;

type
 { ThdmTestDockableScrollbox }

 ThdmTestDockableScrollbox
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create; reintroduce;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_TestDockableScrollbox;
    function Iterateur_Decroissant: TIterateur_TestDockableScrollbox;
  //Méthodes
  public
    function Execute: Boolean;
    procedure Vide;
  end;

implementation

{ ThdmTestDockableScrollbox }

constructor ThdmTestDockableScrollbox.Create;
begin
     inherited Create( nil, TblTestDockableScrollbox, nil);
     if Classe_Elements <> TblTestDockableScrollbox
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+TblTestDockableScrollbox.ClassName
                          );
end;

destructor ThdmTestDockableScrollbox.Destroy;
begin
     inherited;
end;

class function ThdmTestDockableScrollbox.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TestDockableScrollbox;
end;

function ThdmTestDockableScrollbox.Iterateur: TIterateur_TestDockableScrollbox;
begin
     Result:= TIterateur_TestDockableScrollbox( Iterateur_interne);
end;

function ThdmTestDockableScrollbox.Iterateur_Decroissant: TIterateur_TestDockableScrollbox;
begin
     Result:= TIterateur_TestDockableScrollbox( Iterateur_interne_Decroissant);
end;

function ThdmTestDockableScrollbox.Execute: Boolean;
var
   bl: TblTestDockableScrollbox;
   procedure T( _Nom: String);
   begin
        bl:= TblTestDockableScrollbox.Create( sl, nil, nil);

        bl.Nom:= _Nom;

        Ajoute( bl);
   end;
begin
     Vide;

     T( 'Libelle 1');
     T( 'Libelle 2');
     T( 'Libelle 3');
     T( 'Libelle 4');
     T( 'Libelle 5');
     T( 'Libelle 6');
     T( 'Libelle 7');
     T( 'Libelle 8');
     T( 'Libelle 9');
     T( 'Libelle 0');
     T( 'Libelle 1');
     T( 'Libelle 2');
     T( 'Libelle 3');
     T( 'Libelle 4');
     T( 'Libelle 5');
     T( 'Libelle 6');
     T( 'Libelle 7');
     T( 'Libelle 8');
     T( 'Libelle 9');

     Result:= True;
end;

procedure ThdmTestDockableScrollbox.Vide;
var
   I: TIterateur_TestDockableScrollbox;
   bl: TblTestDockableScrollbox;
begin
     I:= Iterateur_Decroissant;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;
       I.Supprime_courant;
       Free_nil( bl);
       end;
end;

end.

