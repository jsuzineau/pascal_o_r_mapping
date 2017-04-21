unit uhdmOpenDocument_DelphiReportEngine_Test;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

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
    ublOpenDocument_DelphiReportEngine_Test,

 Classes, SysUtils;

type
 { ThdmOpenDocument_DelphiReportEngine_Test }

 ThdmOpenDocument_DelphiReportEngine_Test
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
    function Iterateur: TIterateur_OpenDocument_DelphiReportEngine_Test;
    function Iterateur_Decroissant: TIterateur_OpenDocument_DelphiReportEngine_Test;
  //Méthodes
  public
    function Execute: Boolean;
    procedure Vide;
  end;

implementation

{ ThdmOpenDocument_DelphiReportEngine_Test }

constructor ThdmOpenDocument_DelphiReportEngine_Test.Create;
begin
     inherited Create( nil, TblOpenDocument_DelphiReportEngine_Test, nil);
     if Classe_Elements <> TblOpenDocument_DelphiReportEngine_Test
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+TblOpenDocument_DelphiReportEngine_Test.ClassName
                          );
end;

destructor ThdmOpenDocument_DelphiReportEngine_Test.Destroy;
begin
     inherited;
end;

class function ThdmOpenDocument_DelphiReportEngine_Test.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test;
end;

function ThdmOpenDocument_DelphiReportEngine_Test.Iterateur: TIterateur_OpenDocument_DelphiReportEngine_Test;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test( Iterateur_interne);
end;

function ThdmOpenDocument_DelphiReportEngine_Test.Iterateur_Decroissant: TIterateur_OpenDocument_DelphiReportEngine_Test;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test( Iterateur_interne_Decroissant);
end;

function ThdmOpenDocument_DelphiReportEngine_Test.Execute: Boolean;
var
   bl: TblOpenDocument_DelphiReportEngine_Test;
   procedure T( _Code         : String;
                _Libelle      : String;
                _Quantite     : double;
                _Prix_Unitaire: double;
                _Montant      : double
                );
   begin
        bl:= TblOpenDocument_DelphiReportEngine_Test.Create( sl, nil, nil);

        bl.Code         := _Code         ;
        bl.Libelle      := _Libelle      ;
        bl.Quantite     := _Quantite     ;
        bl.Prix_Unitaire:= _Prix_Unitaire;
        bl.Montant      := _Montant      ;

        Ajoute( bl);
   end;
begin
     Vide;

     T( '1', 'Libelle 1', 1, 1, 1);
     T( '2', 'Libelle 2', 2, 2, 2);
     T( '3', 'Libelle 3', 3, 3, 3);
     T( '4', 'Libelle 4', 4, 4, 4);
     T( '5', 'Libelle 5', 5, 5, 5);
     T( '6', 'Libelle 6', 6, 6, 6);
     T( '7', 'Libelle 7', 7, 7, 7);
     Result:= True;
end;

procedure ThdmOpenDocument_DelphiReportEngine_Test.Vide;
var
   I: TIterateur_OpenDocument_DelphiReportEngine_Test;
   bl: TblOpenDocument_DelphiReportEngine_Test;
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

