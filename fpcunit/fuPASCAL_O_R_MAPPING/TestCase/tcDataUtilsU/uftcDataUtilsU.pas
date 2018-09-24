unit uftcDataUtilsU;

{$mode delphi}

interface

uses
    uClean,
 Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
 Dialogs;

type

 { TftcDataUtilsU }

 TftcDataUtilsU = class(TForm)
  c: TChart;
  cls: TLineSeries;
 private

 public

 end;

function ftcDataUtilsU: TftcDataUtilsU;

implementation

{$R *.lfm}

var
   FftcDataUtilsU: TftcDataUtilsU= nil;

function ftcDataUtilsU: TftcDataUtilsU;
begin
     Clean_Get( Result, FftcDataUtilsU, TftcDataUtilsU);
end;

end.

