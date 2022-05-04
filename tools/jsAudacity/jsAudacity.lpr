program jsAudacity;

{$mode objfpc}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms, ufjsAudacity, ublPassage, upoolPassage, uhfPassage, udkPassage,
  LResources, uAudacity;

{$R *.res}

begin
  Application.Initialize;
 Application.CreateForm(TfjsAudacity, fjsAudacity);
  Application.Run;
end.

