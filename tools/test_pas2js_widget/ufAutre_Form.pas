unit ufAutre_Form;

{$mode delphi}{$H+}

interface

uses
 JS, Classes, SysUtils, Graphics, Controls, Forms, Dialogs, WebCtrls,
 mysql56conn;

type

 { TfAutre_Form }

 TfAutre_Form = class(TWForm)
  bfTest: TWButton;
  MySQL56Connection1: TMySQL56Connection;
  WLabel1: TWLabel;
  procedure bfTestClick(Sender: TObject);
 private

 public
  procedure Loaded; override;
 end;

var
 fAutre_Form: TfAutre_Form;

implementation
uses
    ufTest;

procedure TfAutre_Form.bfTestClick(Sender: TObject);
begin
     fTest.Show;
end;

procedure TfAutre_Form.Loaded;
begin
 inherited Loaded;
 {$I ufAutre_Form.wfm}
end;

end.

