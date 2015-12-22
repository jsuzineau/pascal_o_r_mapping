program Tuleap_Test;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms,
 wst_core, wst_synapse,

 soap_formatter,
 synapse_http_protocol,
 ufTuleap_Test,
 uWSDL_tracker_proxy,
 uWSDL_tracker,
 uWSDL_svn_proxy,
 uWSDL_svn,
 uWSDL_project_proxy,
 uWSDL_project,
 uWSDL_codendi_proxy,
 uWSDL_codendi;

{$R *.res}

begin
 SYNAPSE_RegisterHTTP_Transport();
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfTuleap_Test, fTuleap_Test);
 Application.Run;
end.

