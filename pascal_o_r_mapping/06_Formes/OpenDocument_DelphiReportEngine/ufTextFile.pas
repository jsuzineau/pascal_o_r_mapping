unit ufTextFile;

{$mode delphi}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 StdCtrls;

type

 { TfTextFile }

 TfTextFile
 =
  class(TForm)
  published
   mMIMETYPE: TMemo;
   Panel1: TPanel;
  //Gestion du cycle de vie
  public
    constructor Create( _Caption, _FileName: String); reintroduce;
    destructor Destroy; override;
  //FileName
  public
    FileName: String
  end;

function Assure_fTextFile( var _fTextFile: TfTextFile; _Caption, _FileName: String): TfTextFile;

implementation

{$R *.lfm}

{ TfTextFile }

function Assure_fTextFile( var _fTextFile: TfTextFile; _Caption, _FileName: String): TfTextFile;
begin
     if nil = _fTextFile
     then
         _fTextFile:= TfTextFile.Create( _Caption, _FileName);
     Result:= _fTextFile;
end;

constructor TfTextFile.Create( _Caption, _FileName: String);
begin
     inherited Create( nil);
     FileName:= _FileName;

     Caption:= _Caption;
     mMIMETYPE.Lines.LoadFromFile( FileName);
end;

destructor TfTextFile.Destroy;
begin
     inherited Destroy;
end;

end.

