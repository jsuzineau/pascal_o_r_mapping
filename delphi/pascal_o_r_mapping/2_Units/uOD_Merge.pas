unit uOD_Merge;
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
