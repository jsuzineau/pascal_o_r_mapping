unit uImpression_Font_Size_Multiplier;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uClean,
    uEXE_INI,
    uContextes,
  Windows, SysUtils, Classes;

type
 TContexte_Integer_Array= array[ct_Min..ct_Max] of Integer;
 TImpression_Font_Size_Multiplier
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    function GetValeur( I: Integer): Integer;
    procedure SetValeur( I: Integer; const Value: Integer);
  public
    property Valeur[ I: Integer]: Integer read GetValeur write SetValeur;
  end;

var
   Impression_Font_Size_Multiplier: TImpression_Font_Size_Multiplier= nil;

implementation

const
     inis_Impression_Font_Size_Multiplier= 'Impression_Font_Size_Multiplier';

{ TImpression_Font_Size_Multiplier }

constructor TImpression_Font_Size_Multiplier.Create;
begin

end;

destructor TImpression_Font_Size_Multiplier.Destroy;
begin

     inherited;
end;

function TImpression_Font_Size_Multiplier.GetValeur( I: Integer): Integer;
begin
     Result
     :=
       EXE_INI.ReadInteger( inis_Impression_Font_Size_Multiplier,
                            IntToStr( I), 4);
end;

procedure TImpression_Font_Size_Multiplier.SetValeur( I: Integer; const Value: Integer);
begin
     EXE_INI.WriteInteger( inis_Impression_Font_Size_Multiplier,
                           IntToStr( I), Value);
end;

initialization
              Impression_Font_Size_Multiplier
              :=
                TImpression_Font_Size_Multiplier.Create;
finalization
              Free_nil( Impression_Font_Size_Multiplier);
end.
