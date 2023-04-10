unit ufTest_rust;
//Note: to generate a C header file from rust: https://github.com/eqrion/cbindgen
//      then uses h2pas

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfTest_rust }

 TfTest_rust = class(TForm)
  bTest: TButton;
  m: TMemo;
  procedure bTestClick(Sender: TObject);
 private

 public

 end;

var
 fTest_rust: TfTest_rust;

implementation

{$R *.lfm}

{ TfTest_rust }

//extern void hello_from_rust();
procedure hello_from_rust; external 'test_rust_lib';

procedure TfTest_rust.bTestClick(Sender: TObject);
begin
     hello_from_rust;
     //m.Line.Add();
end;

end.

