unit uodMois;
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

    ublMois,

    uOD_Batpro_Table,
    uOD_Niveau,
    uOD_Table_Batpro,
    uEXE_INI,
 Classes, SysUtils;

type

 { TodMois }

 TodMois
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslMois;
    blMois: TblMois;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blMois: TblMois); reintroduce;
  //Piece: Piece
  public
    procedure Table_Piece; 
  end;

implementation

constructor TodMois.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Mois.ott';
     sl:= TslMois.Create( ClassName+'.sl');
end;

destructor TodMois.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodMois.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Mois');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blMois.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodMois.Init( _blMois: TblMois);
begin
     inherited Init;

     if _blMois = nil then exit;

     blMois:= _blMois;

     Ajoute_Maitre( 'Mois', blMois);

     sl.Clear;
     sl.AddObject( blMois.sCle, blMois);

     Table_Piece; 
end;

procedure TodMois.Table_Piece;
var
   tPiece: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nPiece: TOD_Niveau;
begin
     blMois.haPiece.Charge;
     
     tPiece:= Ajoute_Table( 'tPiece');
     tPiece.Pas_de_persistance:= True;
     tPiece.AddColumn( 40, '  '      );

     nRoot:= tPiece.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     nRoot.Ajoute_Column_Avant( 'D'                  , 0, 0);

     nPiece:= tPiece.AddNiveau( 'Piece');
     nPiece.Ajoute_Column_Avant( 'D'                  , 0, 0);
end;

 

end.

