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
  wieOctaveFactor: TWIntegertEdit;
  WLabel1: TWLabel;
  wl: TWLabel;
  wlCPL_G3: TWLabel;
  WPanel1: TWPanel;
  procedure wieOctaveFactorChange(Sender: TObject);
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
     wlCPL_G3.Caption:= CPL_G3.Liste;
end;

procedure TfjsFrequences.wieOctaveFactorChange(Sender: TObject);
begin
     wl.Caption:= Frequences.Liste( wieOctaveFactor.Value);
end;

end.

