unit ufTest_rust;
//Note: to generate a C header file from rust: https://github.com/eqrion/cbindgen
//      then uses h2pas

{$mode objfpc}{$H+}

interface

uses
    uTest_rust_lib,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,StrUtils;

type

 { TfTest_rust }

 TfTest_rust = class(TForm)
  bHello_from_rust: TButton;
  bTest_double: TButton;
  bTest_String: TButton;
  m: TMemo;
  Panel1: TPanel;
  procedure bHello_from_rustClick(Sender: TObject);
  procedure bTest_doubleClick(Sender: TObject);
  procedure bTest_StringClick(Sender: TObject);
 private

 public

 end;

var
 fTest_rust: TfTest_rust;

implementation

{$R *.lfm}

{ TfTest_rust }

//extern void hello_from_rust();
procedure Hello_from_rust; external 'test_rust_lib';

procedure TfTest_rust.bHello_from_rustClick(Sender: TObject);
begin
     Hello_from_rust;
     //m.Line.Add();
end;

procedure TfTest_rust.bTest_doubleClick(Sender: TObject);
var
   Sent, Received: double;
   sSent, sReceived: String;
begin
     Sent    := 4;
     Received:= Test_double( Sent);
     sSent    := FloatToStr( Sent    );
     sReceived:= FloatToStr( Received);
     m.Lines.Add('Test_double( '+sSent+') = '+sReceived);

end;

procedure TfTest_rust.bTest_StringClick(Sender: TObject);
var
   Sent, Received: String;
begin
     Sent    := 'Test';
     Received:= Test_PChar( PChar(Sent));
     m.Lines.Add('Test_PChar( '''+Sent+''') = '''+Received+'''');

end;


end.

