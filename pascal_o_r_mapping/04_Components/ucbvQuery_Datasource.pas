unit ucbvQuery_Datasource;
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
    SysUtils, Classes, 
    DB,
    ucBatproVerifieur;

type
  TbvQuery_Datasource = class(TBatproVerifieur)
  private
    { Déclarations privées }
    FQuery : TDataSet;
  protected
    { Déclarations protégées }
    function GetComponent_Valeur: TComponent; override;
  public
    { Déclarations publiques }
  published
    { Déclarations publiées }
    property bv2Query : TDataSet      read FQuery  write FQuery;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TbvQuery_Datasource]);
end;

function TbvQuery_Datasource.GetComponent_Valeur: TComponent;
begin
     if FQuery = nil
     then
         Result:= nil
     else
         Result:= FQuery.DataSource;
end;

end.
