program Installation_Check;

{$mode objfpc}{$H+}

{$DEFINE UseCThreads}
uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, uBatpro_Ligne, tlntsend, libssh2, ufInstallation_Check, telnetsshclient,
 udkCommande
 { you can add units after this },
  blcksock, ublCommande;

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfInstallation_Check, fInstallation_Check);
 Application.Run;
end.

