unit uMicrosoft_Access_Connection;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    uBatpro_StringList,
 Classes, SysUtils, odbcconn, sqldb, db, FileUtil;

type

 { TMicrosoft_Access_Connection }

 TMicrosoft_Access_Connection
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    c: TODBCConnection;
    t: TSQLTransaction;
  //Nomfichier_MDB
  private
    FNomfichier_MDB: String;
    procedure SetNomfichier_MDB( _Value: String);
  public
    property Nomfichier_MDB: String read FNomfichier_MDB write SetNomfichier_MDB;
  end;

 TIterateur_Microsoft_Access_Connection
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TMicrosoft_Access_Connection);
    function  not_Suivant( var _Resultat: TMicrosoft_Access_Connection): Boolean;
  end;

 TslMicrosoft_Access_Connection
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Microsoft_Access_Connection;
    function Iterateur_Decroissant: TIterateur_Microsoft_Access_Connection;
  end;

function Microsoft_Access_Connection_from_sl( sl: TBatpro_StringList; Index: Integer): TMicrosoft_Access_Connection;
function Microsoft_Access_Connection_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TMicrosoft_Access_Connection;

implementation

function Microsoft_Access_Connection_from_sl( sl: TBatpro_StringList; Index: Integer): TMicrosoft_Access_Connection;
begin
     _Classe_from_sl( Result, TMicrosoft_Access_Connection, sl, Index);
end;

function Microsoft_Access_Connection_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TMicrosoft_Access_Connection;
begin
     _Classe_from_sl_sCle( Result, TMicrosoft_Access_Connection, sl, sCle);
end;

{ TIterateur_Microsoft_Access_Connection }

function TIterateur_Microsoft_Access_Connection.not_Suivant( var _Resultat: TMicrosoft_Access_Connection): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Microsoft_Access_Connection.Suivant( var _Resultat: TMicrosoft_Access_Connection);
begin
     Suivant_interne( _Resultat);
end;

{ TslMicrosoft_Access_Connection }

constructor TslMicrosoft_Access_Connection.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TMicrosoft_Access_Connection);
end;

destructor TslMicrosoft_Access_Connection.Destroy;
begin
     inherited;
end;

class function TslMicrosoft_Access_Connection.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Microsoft_Access_Connection;
end;

function TslMicrosoft_Access_Connection.Iterateur: TIterateur_Microsoft_Access_Connection;
begin
     Result:= TIterateur_Microsoft_Access_Connection( Iterateur_interne);
end;

function TslMicrosoft_Access_Connection.Iterateur_Decroissant: TIterateur_Microsoft_Access_Connection;
begin
     Result:= TIterateur_Microsoft_Access_Connection( Iterateur_interne_Decroissant);
end;

{ TMicrosoft_Access_Connection }

constructor TMicrosoft_Access_Connection.Create;
begin
     inherited;
     t:= TSQLTransaction.Create( nil);
     c:= TODBCConnection.Create(nil);
     c.Transaction:= t;
     c.Driver:='Microsoft Access Driver (*.mdb)';
end;

destructor TMicrosoft_Access_Connection.Destroy;
begin
     c.Close{( True) 2014_11_18: ne passe pas en 64 bits pour l'instant};
     c.Transaction:= nil;
     t.DataBase:= nil;
     Free_nil( c);
     Free_nil( t);
     inherited Destroy;
end;

procedure TMicrosoft_Access_Connection.SetNomfichier_MDB( _Value: String);
begin
     if FNomfichier_MDB = _Value then Exit;

     FNomfichier_MDB:=_Value;
     c.Close{( True) 2014_11_18: ne passe pas en 64 bits pour l'instant};
     c.Params.Values['DBQ']:= FNomfichier_MDB;
     //c.Params.Values['charSet']:= 'Windows-1252';
     //c.Params.Values['charSet']:= 'UTF-8'+';';
end;

end.

