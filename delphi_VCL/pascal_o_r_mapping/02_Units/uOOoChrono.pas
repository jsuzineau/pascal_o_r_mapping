unit uOOoChrono;
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
    uOOoStringList,
  SysUtils, Classes;

type
 TOOoChrono
 =
  class
  private
    Debut, Fin, dtStop: TDateTime;
    sl: TOOoStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop( Info: String= '');

    function Get_Temps: String;

    function Get_Liste: String;
  end;

var
   OOoChrono: TOOoChrono;

implementation

{ TChrono }

constructor TOOoChrono.Create;
begin
     inherited;
     sl:= TOOoStringList.Create;
end;

destructor TOOoChrono.Destroy;
begin
     FreeAndNil( sl);
     inherited;
end;

procedure TOOoChrono.Start;
begin
     Debut:= Now;
     Fin  := Debut;
     dtStop:= Fin;
     sl.Clear;
end;

procedure TOOoChrono.Stop( Info: String= '');
begin
     dtStop:= Fin;
     Fin:= Now;
     if Info <> ''
     then
         Info:= ' <- '+Info;
     sl.Add( Get_Temps+Info);
end;

function TOOoChrono.Get_Temps: String;
var
   Delta_Debut : TDateTime;
   Delta_dtStop: TDateTime;
begin
     Delta_Debut := Fin - Debut ;
     Delta_dtStop:= Fin - dtStop;
     Result:=  FormatDateTime( 'hh:nn:ss"."zzz', Delta_Debut )
              +', delta: '
              +FormatDateTime( 'hh:nn:ss"."zzz', Delta_dtStop);
end;

function TOOoChrono.Get_Liste: String;
begin
     Result:= sl.Text;
end;

initialization
              OOoChrono:= TOOoChrono.Create;
finalization
            FreeAndNil( OOoChrono);
end.
