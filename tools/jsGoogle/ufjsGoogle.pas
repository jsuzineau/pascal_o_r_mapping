unit ufjsGoogle;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
 Clipbrd,URIParser;

type

 { TfjsGoogle }

 TfjsGoogle = class(TForm)
  bSetPasteOnClick: TButton;
  eInputURL: TEdit;
  eOutputURL: TEdit;
  eParams: TEdit;
  ePasteOnClick: TEdit;
  mParams: TMemo;
  procedure bSetPasteOnClickClick(Sender: TObject);
  procedure eInputURLClick(Sender: TObject);
  procedure ePasteOnClickClick(Sender: TObject);
 private

 public

 end;

var
 fjsGoogle: TfjsGoogle;

implementation

{$R *.lfm}

{ TfjsGoogle }

procedure TfjsGoogle.eInputURLClick(Sender: TObject);
var
   S: String;
   uri: TURI;
   Params: String;
   slParams:TStringList;
   VideoID: String;
   t: String;
   start: String;
   OutPut: String;
   function start_from_t( _t: String): String;
   begin
        Result:= _t;
        if '' =_t then exit;

        Delete( _t, length(_t), 1);
   end;
begin
     S:= Clipboard.AsText;
     eInputURL.Text:= S;

     uri:= ParseURI( S);
     Params:= uri.Params;
     eParams.Text:= Params;

     slParams:= TStringList.Create;
     try
        slParams.Text:= StringReplace( Params, '&',LineEnding, [rfReplaceAll]);
        VideoID  :=slParams.Values['v'];
        t:=slParams.Values['t'];
        mParams.Lines.Text:= slParams.Text;
     finally
            FreeAndNil( slParams);
            end;
     start:= start_from_t( t);
     OutPut:='https://www.youtube.com/embed/'+VideoID;
     if ''<>start then OutPut:= OutPut + '?' + 'start='+start;
     eOutputURL.Text:= OutPut;
     Clipboard.AsText:= OutPut;
end;

procedure TfjsGoogle.bSetPasteOnClickClick(Sender: TObject);
begin
     ePasteOnClick.Text:= Clipboard.AsText;
end;

procedure TfjsGoogle.ePasteOnClickClick(Sender: TObject);
begin
     Clipboard.AsText:= ePasteOnClick.Text;
end;

end.

