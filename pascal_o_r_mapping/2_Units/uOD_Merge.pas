unit uOD_Merge;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    SysUtils, Classes;

type
  TOD_Merge
  =
   class
     Count: Integer;
     Debut,
     Fin: array of Integer;
   public
     constructor Create( _Debut  ,
                         _Fin    : array of Integer);
   end;

implementation

{ TOD_Merge }

constructor TOD_Merge.Create( _Debut  ,
                              _Fin    : array of Integer);
var
   I: Integer;
begin
     Count:= Length( _Debut);
     SetLength( Debut  , Count);
     SetLength( Fin    , Count);
     for I:= Low( Debut) to High( Debut)
     do
       begin
       Debut  [I]:=_Debut  [I];
       Fin    [I]:=_Fin    [I];
       end;
end;

end.
