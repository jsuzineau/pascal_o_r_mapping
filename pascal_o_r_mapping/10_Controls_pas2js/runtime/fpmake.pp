{
   File generated automatically by Lazarus Package Manager

   fpmake.pp for OD_DelphiReportEngine_Controls_pas2js_runtime 0.0

   This file was generated on 30/08/2019
}

{$ifndef ALLPACKAGES} 
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;
{$endif ALLPACKAGES}

procedure add_OD_DelphiReportEngine_Controls_pas2js_runtime(const ADirectory: string);

var
  P : TPackage;
  T : TTarget;

begin
  with Installer do
    begin
    P:=AddPackage('od_delphireportengine_controls_pas2js_runtime');
    P.Version:='0.0';

    P.Directory:=ADirectory;

    P.Dependencies.Add('pas2js_widget');
    P.Options.Add('-MObjFPC');
    P.Options.Add('-Sc');
    P.Options.Add('-l');
    P.Options.Add('-vewnhibq');
    P.Options.Add('-dPas2js');
    P.Options.Add('-dPas2js');
    P.Options.Add('-dPas2js');
    P.Options.Add('-O-');
    P.Options.Add('-Jc');
    P.UnitPath.Add('.');
    T:=P.Targets.AddUnit('OD_DelphiReportEngine_Controls_pas2js_runtime.pas');
    t.Dependencies.AddUnit('ucWChamp_Edit');
    t.Dependencies.AddUnit('uJSChamps');

    T:=P.Targets.AddUnit('ucWChamp_Edit.pas');
    T:=P.Targets.AddUnit('uJSChamps.pas');

    // copy the compiled file, so the IDE knows how the package was compiled
    P.InstallFiles.Add('OD_DelphiReportEngine_Controls_pas2js_runtime.compiled',AllOSes,'$(unitinstalldir)');

    end;
end;

{$ifndef ALLPACKAGES}
begin
  add_OD_DelphiReportEngine_Controls_pas2js_runtime('');
  Installer.Run;
end.
{$endif ALLPACKAGES}
