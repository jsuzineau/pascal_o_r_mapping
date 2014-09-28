unit Unit1;

{   Cette unité est un exemple d'utilisation de OOoTools et OOoXray
    Modifiez-la pour tester vos propres essais
    Vous pouvez appeler des routines de OOoExamples

    This unit is an example of using OOoTools and OOoXray
    Modify it to test your own trials
    You may call routines from OOoExamples     }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Variants;

type
  TForm1 = class(TForm)
    OpenOfficeBtn: TButton;
    BitBtn1: TBitBtn;
    procedure OpenOfficeBtnClick(Sender: TObject);
  private
    { Private declarations}
  public
    { Public declarations}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses ComObj, OOoMessages, OOoTools, OOoConstants, OOoXray, OOoExamples;



{ ----------------------------------------------------------  }


procedure TForm1.OpenOfficeBtnClick(Sender: TObject);

begin
  ConnectOpenOffice;
  ShowMessage(OOoMess001);

  HelloWorldExample;

  DisconnectOpenOffice;
  ShowMessage(OOoMess002);
end;


end.
