unit uOOoStringList;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    SysUtils, Classes;

type
 TOOoStringList
 =
  class( TStringList)
  //Méthodes surchargées
  protected
    function CompareStrings(const S1:String;const S2:String):Integer;override;
  end;

implementation

{ TOOoStringList }

function TOOoStringList.CompareStrings( const S1, S2: String): Integer;
begin
     Result:= CompareStr( S1, S2);
end;

end.
