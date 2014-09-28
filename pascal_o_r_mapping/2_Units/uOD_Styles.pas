unit uOD_Styles;
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
    uOOoStrings,
  SysUtils;

type
 TOD_Style_Alignment
 =
  (
  osa_Left  ,
  osa_Center,
  osa_Right
  );
 TOD_Styles
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Styles: String);
    destructor Destroy; override;
  //Attributs
  public
    Styles: array of String;
    Alignments: array of TOD_Style_Alignment;
  //Initialisation
  public
    procedure Init( _Styles: String);
  end;

implementation

{ TOD_Styles }

constructor TOD_Styles.Create( _Styles: String);
begin
     inherited Create;
     Init( _Styles);
end;

destructor TOD_Styles.Destroy;
begin

     inherited;
end;

procedure TOD_Styles.Init( _Styles: String);
begin
     SetLength( Styles, 0);
     while Length( _Styles) > 0
     do
       begin
       SetLength( Styles, Length( Styles)+1);
       Styles[ High( Styles)]:= Trim( StrTok( ',', _Styles));
       end;
     SetLength( Alignments, Length( Styles));
end;

end.
