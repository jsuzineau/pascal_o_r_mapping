unit uodFacture;
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

 { TodFacture }

 TodFacture
 =
  class( TOD_Table_Batpro)
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Gestion état
  private
    sl: TslFacture;
    blFacture: TblFacture;
  protected
    function  Composer: String; override;
  public
    procedure Init( _blFacture: TblFacture); reintroduce;
  //Piece: Piece
  public
    procedure Table_Piece;   //Facture_Ligne: Facture_Ligne
  public
    procedure Table_Facture_Ligne; 
  end;

implementation

constructor TodFacture.Create;
begin
     FNomFichier_Modele:= ExtractFilePath(ParamStr(0))+'Facture.ott';
     sl:= TslFacture.Create( ClassName+'.sl');
end;

destructor TodFacture.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
end;

function TodFacture.Composer: String;
var
   Repertoire: String;
begin
     Repertoire:= EXE_INI.Assure_String('Repertoire_Facture');
     if '' <> Repertoire
     then
         Repertoire:= IncludeTrailingPathDelimiter(Repertoire);
     NomFichier:= Repertoire+blFacture.GetLibelle+'.odt';
     Result:=inherited Composer;
end;

procedure TodFacture.Init( _blFacture: TblFacture);
begin
     inherited Init;

     if _blFacture = nil then exit;

     blFacture:= _blFacture;

     Ajoute_Maitre( 'Facture', blFacture);
     Ajoute_Maitre( 'Facture_Client', blFacture.Client_bl);

     sl.Clear;
     sl.AddObject( blFacture.sCle, blFacture);

     Table_Piece;      Table_Facture_Ligne; 
end;

procedure TodFacture.Table_Piece;
var
   tPiece: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nPiece: TOD_Niveau;
begin
     blFacture.haPiece.Charge;
     
     tPiece:= Ajoute_Table( 'tPiece');
     tPiece.Pas_de_persistance:= True;
     tPiece.AddColumn( 40, '  '      );

     nRoot:= tPiece.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     nRoot.Ajoute_Column_Avant( 'D'                  , 0, 0);

     nPiece:= tPiece.AddNiveau( 'Piece');
     nPiece.Ajoute_Column_Avant( 'D'                  , 0, 0);
end;

 procedure TodFacture.Table_Facture_Ligne;
var
   tFacture_Ligne: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nFacture_Ligne: TOD_Niveau;
begin
     blFacture.haFacture_Ligne.Charge;
     
     tFacture_Ligne:= Ajoute_Table( 'tFacture_Ligne');
     tFacture_Ligne.Pas_de_persistance:= True;
     tFacture_Ligne.AddColumn( 369, 'Date'         );
     tFacture_Ligne.AddColumn( 735, 'Désignation'  );
     tFacture_Ligne.AddColumn( 142, 'Heures'       );
     tFacture_Ligne.AddColumn( 221, 'Prix unitaire');
     tFacture_Ligne.AddColumn( 221, 'Montant'      );

     nRoot:= tFacture_Ligne.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     nRoot.Ajoute_Column_Apres( 'Label_Total', 0, 0);
     nRoot.Ajoute_Column_Apres( 'Label_TVA'  , 1, 1);
     nRoot.Ajoute_Column_Apres( 'Montant'    , 4, 4);

     nFacture_Ligne:= tFacture_Ligne.AddNiveau( 'Facture_Ligne');
     nFacture_Ligne.Ajoute_Column_Avant( 'Date'         , 0, 0);
     nFacture_Ligne.Ajoute_Column_Avant( 'Libelle'      , 1, 1);
     nFacture_Ligne.Ajoute_Column_Avant( 'NbHeures'     , 2, 2);
     nFacture_Ligne.Ajoute_Column_Avant( 'Prix_unitaire', 3, 3);
     nFacture_Ligne.Ajoute_Column_Avant( 'Montant'      , 4, 4);
end;

 

end.

