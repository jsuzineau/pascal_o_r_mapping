unit ufTest_remote_debug;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfTest_remote_debug }

 TfTest_remote_debug = class(TForm)
  Button1: TButton;
  procedure Button1Click(Sender: TObject);
 private

 public

 end;

var
 fTest_remote_debug: TfTest_remote_debug;

implementation

{$R *.lfm}

{ TfTest_remote_debug }

procedure TfTest_remote_debug.Button1Click(Sender: TObject);
var
   I: Integer;
begin
     for I:=0 to 15
     do
       begin
       Showmessage( IntToStr(I));
       end;
end;

end.

