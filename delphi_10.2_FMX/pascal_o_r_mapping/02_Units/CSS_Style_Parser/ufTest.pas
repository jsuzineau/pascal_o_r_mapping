unit ufTest;

interface

uses
    uCSS_Style_Parser_PYACC,
  {$IFDEF FPC}
  Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;
  {$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;
  {$ENDIF}

type

  { TfTest }

  TfTest
  =
   class(TForm)
   bAuto: TButton;
    m: TMemo;
    e: TEdit;
    Panel1: TPanel;
    procedure bAutoClick(Sender: TObject);
    procedure eKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    p: TCSS_Style_Parser_PYACC;
    procedure Write_Property(_Name, _Value: String);
    function Parse( _S: String): Boolean;
  public
    { Public declarations }
  end;

var
  fTest: TfTest;

implementation

{$R *.lfm}

procedure TfTest.FormCreate(Sender: TObject);
begin
     p:= TCSS_Style_Parser_PYACC.Create;
end;

procedure TfTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     p.Free;
end;

procedure TfTest.bAutoClick(Sender: TObject);
begin
     Parse( 'color:#e60000');
     Parse( 'color:#e60000;background-color:#ff9900;font-style: italic;font-weight: bold;');
end;

procedure TfTest.Write_Property( _Name, _Value: String);
begin
     m.Lines.Add(_Name+'='+_Value);
end;

procedure TfTest.eKeyPress(Sender: TObject; var Key: Char);
begin
     if Key <> #13 then exit;

     Key:= #0;
     if Parse( e.Text)
     then
         e.Text:= '';
end;

function TfTest.Parse( _S: String): Boolean;
var
   ss: TStringStream;
begin
     Result:= False;
     m.Lines.Add('> ' + _S);

     {$IFDEF FPC}
     ss:= TStringStream.Create('');
     {$ELSE}
     ss:= TStringStream.Create;
     {$ENDIF}
     try
        ss.WriteString(_S);
        ss.Position := 0;
        try
           p.parse(ss, Write_Property);
        except
              on E: ECSS_Style_Parser_PYACC_Exception
              do
                m.Lines.Add( E.Message);
              end;
        Result:= True;
     finally
            ss.Free;
     end;
end;

end.

