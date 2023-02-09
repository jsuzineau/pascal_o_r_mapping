unit uodPiece;
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

    ublFacture,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
    uEXE_INI,
 Classes, SysUtils;

type

 { TodPiece }

 TodPiece
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslPiece;
    blPiece: TblPiece;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blPiece: TblPiece); reintroduce;
//Aggregations_Pascal_uod_declaration_table_pas
  end;

implementation

constructor TodPiece.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Piece.ott';
     sl:= TslPiece.Create( ClassName+'.sl');
end;

destructor TodPiece.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodPiece.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Piece');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blPiece.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodPiece.Init( _blPiece: TblPiece);
begin
     inherited Init;

     if _blPiece = nil then exit;

     blPiece:= _blPiece;

     Ajoute_Maitre( 'Piece', blPiece);

     sl.Clear;
     sl.AddObject( blPiece.sCle, blPiece);

//Aggregations_Pascal_uod_implementation_init_pas
end;

//Aggregations_Pascal_uod_implementation_methodes_pas

end.

