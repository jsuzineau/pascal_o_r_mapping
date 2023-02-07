unit uodClient;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
        http://www.mars42.com                                                   |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
    uBatpro_StringList,

    ublClient,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
    uEXE_INI,
 Classes, SysUtils;

type

 { TodClient }

 TodClient
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslClient;
    blClient: TblClient;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blClient: TblClient); reintroduce;
  //Facture: Facture
  public
    procedure Table_Facture; 
  end;

implementation

constructor TodClient.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Client.ott';
     sl:= TslClient.Create( ClassName+'.sl');
end;

destructor TodClient.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodClient.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Client');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blClient.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodClient.Init( _blClient: TblClient);
begin
     inherited Init;

     if _blClient = nil then exit;

     blClient:= _blClient;

     Ajoute_Maitre( 'Client', blClient);

     sl.Clear;
     sl.AddObject( blClient.sCle, blClient);

     Table_Facture; 
end;

procedure TodClient.Table_Facture;
var
   tFacture: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nFacture: TOD_Niveau;
begin
     blClient.haFacture.Charge;
     
     tFacture:= Ajoute_Table( 'tFacture');
     tFacture.Pas_de_persistance:= True;
     tFacture.AddColumn( 40, '  '      );

     nRoot:= tFacture.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     nRoot.Ajoute_Column_Avant( 'D'                  , 0, 0);

     nFacture:= tFacture.AddNiveau( 'Facture');
     nFacture.Ajoute_Column_Avant( 'D'                  , 0, 0);
end;

 

end.

