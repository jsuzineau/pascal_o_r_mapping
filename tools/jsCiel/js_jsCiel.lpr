program js_jsCiel;

{$mode objfpc}

uses
  BrowserConsole, BrowserApp, WASIHostApp, JOB_Browser,JS,
  Classes, SysUtils, Web, wasitypes, wasizenfs, libzenfs, libzenfsdom,wasienv;

type

 { Tjs_jsCiel }

 Tjs_jsCiel
 =
  class(TWASIHostApplication)
  protected
    FS :TWASIZenFS;
    procedure RunWasm ; async;
    procedure DoRun; override;
  private
    ob: TJSObjectBridge;
    sd: TWebAssemblyStartDescriptor;
    function wasmBeforeStart(_Sender: TObject; _Descriptor: TWebAssemblyStartDescriptor): Boolean;
    procedure wasmWrite(Sender: TObject; const aOutput: String);
  public
    constructor Create(aOwner : TComponent); override;
  end;

var
  Application : Tjs_jsCiel;

  constructor Tjs_jsCiel.Create(aOwner: TComponent);
  begin
       inherited Create(aOwner);
       ob:= TJSObjectBridge.Create( WasiEnvironment);
       RunEntryFunction:='_initialize';

       WasiEnvironment.OnStdErrorWrite :=@wasmWrite;
       WasiEnvironment.OnStdOutputWrite:=@wasmWrite;
       //WasiEnvironment.LogAPI:=True;
       //Writeln('Enabling logging');
  end;

function Tjs_jsCiel.wasmBeforeStart( _Sender: TObject; _Descriptor: TWebAssemblyStartDescriptor): Boolean;
begin
     //WriteLn(ClassName+'.wasmBeforeStart');

     sd:= _Descriptor;

     ob.InstanceExports:=_Descriptor.Exported;
     Result:=true;
end;

procedure Tjs_jsCiel.DoRun;
begin
     RunWasm;
end;

procedure Tjs_jsCiel.wasmWrite(Sender: TObject; const aOutput: String);
begin
     Writeln( aOutput);
end;

procedure Tjs_jsCiel.RunWasm;
const
     //Files_Racine: array of String= ();
     Files_vsop87
     :
      array of String
      =
       (
       'vsop87/VSOP87D.ear',
       'vsop87/VSOP87D.jup',
       'vsop87/VSOP87D.mar',
       'vsop87/VSOP87D.mer',
       'vsop87/VSOP87D.nep',
       'vsop87/VSOP87D.sat',
       'vsop87/VSOP87D.ura',
       'vsop87/VSOP87D.ven'
       );
var
   //Res_Racine: TPreLoadFilesResult;
   Res_vsop87: TPreLoadFilesResult;
begin
     // Writeln('Enabling logging');
     // WasiEnvironment.LogAPI:=True;
     //await
     //  (
     //  TJSObject,
     //  ZenFS.configure(new( ['mounts', new(['/', DomBackends.WebStorage])]))
     //  );
     FS:=TWASIZenFS.Create;
     WasiEnvironment.FS:=FS;
     //ZenFS.mkdir( '/vsop87', &777);
     //Res_Racine:= await( TPreLoadFilesResult, PreLoadFilesIntoDirectory('/', Files_Racine));
     //Res_vsop87:= await( TPreLoadFilesResult, PreLoadFilesIntoDirectory('/vsop87', Files_vsop87));
     StartWebAssembly('wasm_jsCiel.wasm',true,@wasmBeforeStart);
end;

begin
     //ConsoleStyle:=DefaultConsoleStyle;
     ConsoleStyle:=DefaultCRTConsoleStyle;
     HookConsole;
     Application:=Tjs_jsCiel.Create(nil);
     Application.Initialize;
     Application.Run;
end.
//old pas2js: $(LazarusDir)\pas2js-win64-x86_64-3.0.1\bin\pas2js.exe
