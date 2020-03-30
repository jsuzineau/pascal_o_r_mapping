unit ufjsFrequences;

{$mode delphi}{$H+}
{$modeswitch externalclass}

interface

uses
 uJSChamps,
 ucWChamp_Edit,
 uFrequences,
 uCPL_G3,
 JS, Classes, SysUtils, Graphics, Controls, Forms, Dialogs, WebCtrls, StdCtrls,
 ExtCtrls;

type
 { TfjsFrequences }

 TfjsFrequences = class(TWForm)
  weOctaveFactor: TWEdit;
  WLabel1: TWLabel;
  wm: TWMemo;
  wmCPL_G3: TWMemo;
  WPanel1: TWPanel;
  procedure weOctaveFactorChange(Sender: TObject);
 public
  procedure Loaded; override;
 end;

var
 fjsFrequences: TfjsFrequences;


implementation

procedure TfjsFrequences.Loaded;
begin
     inherited Loaded;
     {$I ufjsFrequences.wfm}
     wmCPL_G3.Caption:= CPL_G3.Liste;
end;

procedure TfjsFrequences.weOctaveFactorChange(Sender: TObject);
var
   OctaveFactor: Integer;
begin
     if not TryStrToInt( weOctaveFactor.Text, OctaveFactor) then exit;
     wm.Caption:= Frequences.Liste( OctaveFactor);
end;

end.

