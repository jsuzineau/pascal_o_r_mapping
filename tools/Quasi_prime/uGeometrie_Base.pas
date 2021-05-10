unit uGeometrie_Base;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils;

function  Triangle_a_from_s( _s: ValReal): ValReal;
function     Carre_a_from_s( _s: ValReal): ValReal;
function Pentagone_a_from_s( _s: ValReal): ValReal;

function Triangle_circonscrit_r_from_a( _a: ValReal):ValReal;

implementation

function  Triangle_a_from_s( _s: ValReal): ValReal; begin Result:=sqrt((4/sqrt(3))*_s); end;
function     Carre_a_from_s( _s: ValReal): ValReal; begin Result:=sqrt(_s)            ; end;
function Pentagone_a_from_s( _s: ValReal): ValReal; begin Result:=sqrt(_s/(1/4*sqrt(25+10*sqrt(5)))); end;

function Triangle_circonscrit_r_from_a( _a: ValReal):ValReal;begin Result:=_a/sqrt(3); end;

end.

