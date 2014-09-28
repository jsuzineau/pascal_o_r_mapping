unit uCharMap;
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
    Classes, SysUtils,
    uBatpro_StringList;

type
 TCharMap
 =
  class
  private
    Empty: Boolean;
    C: array[0..255] of char;
  public
    constructor Create;
    function Traduit( S: String): String;
  end;

var
   CharMap: TCharMap;

implementation

uses
    u_sys_,
    uEXE_INI,
    uClean;

{ TCharMap }

constructor TCharMap.Create;
var
   sl: TBatpro_StringList;
   I: Integer;
   SBase, SWindows: String;
   Cbase, CWindows: Char;
begin
     for I:= Low(C) to High(C)
     do
       C[I]:= Chr( I);

     sl:= TBatpro_StringList.Create;
     try
        EXE_INI.ReadSectionValues('CharMap', sl);
        Empty:= sl.Count = 0;
        if not Empty
        then
            for I:= 0 to sl.Count - 1
            do
              begin
              SBase   := sl.Names [I    ];
              SWindows:= sl.Values[SBase];
              if     (SBase    <> sys_Vide)
                 and (SWindows <> sys_Vide)
              then
                  begin
                  CBase   := SBase   [1];
                  CWindows:= SWindows[1];
                  C[Ord(CBase)]:= CWindows;
                  end;
              end;
     finally
            Free_nil( sl);
            end;
end;

function TCharMap.Traduit( S: String): String;
var
   I: Integer;
begin
     Result:= S;
     if Empty then exit;
     for I:= 1 to Length( S)
     do
       Result[I]:= C[Ord(Result[I])];
end;

initialization
              CharMap:= TCharMap.Create;
finalization
              Free_nil( CharMap);
end.
