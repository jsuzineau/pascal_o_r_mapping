unit uodNom_de_la_classe;
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

    ublNom_de_la_classe,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
    uEXE_INI,
 Classes, SysUtils;

type

 { TodNom_de_la_classe }

 TodNom_de_la_classe
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslNom_de_la_classe;
    blNom_de_la_classe: TblNom_de_la_classe;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blNom_de_la_classe: TblNom_de_la_classe); reintroduce;
//Aggregations_Pascal_uod_declaration_table_pas
  end;

implementation

constructor TodNom_de_la_classe.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Nom_de_la_classe.ott';
     sl:= TslNom_de_la_classe.Create( ClassName+'.sl');
end;

destructor TodNom_de_la_classe.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodNom_de_la_classe.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Nom_de_la_classe');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blNom_de_la_classe.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodNom_de_la_classe.Init( _blNom_de_la_classe: TblNom_de_la_classe);
begin
     inherited Init;

     if _blNom_de_la_classe = nil then exit;

     blNom_de_la_classe:= _blNom_de_la_classe;

     Ajoute_Maitre( 'Nom_de_la_classe', blNom_de_la_classe);

     sl.Clear;
     sl.AddObject( blNom_de_la_classe.sCle, blNom_de_la_classe);

//Aggregations_Pascal_uod_implementation_init_pas
end;

//Aggregations_Pascal_uod_implementation_methodes_pas

end.

