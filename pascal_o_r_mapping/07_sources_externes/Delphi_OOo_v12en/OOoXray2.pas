unit OOoXray2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TxrayForm2 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    ExitBtn: TBitBtn;
    Label1: TLabel;
    ObjectPath: TEdit;
    procedure Display(thisText, currObjPath: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  xrayForm2: TxrayForm2;

implementation

{$R *.dfm}                           



procedure TxrayForm2.Display(thisText, currObjPath: String);
begin
  ObjectPath.Text:= currObjPath;
  Memo1.Lines.Text:= AdjustLineBreaks(thisText);
  ShowModal;
end;




end.
