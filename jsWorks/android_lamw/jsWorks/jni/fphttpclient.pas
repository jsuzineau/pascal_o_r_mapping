unit fphttpclient;
//extrait de lazarus\fpc\3.0.0\source\packages\fcl-web\src\base\fphttpclient.pp
//pour faciliter la recompilation sous Android
{$mode delphi}

interface

uses
  Classes, SysUtils;

function DecodeURLElement(Const S: AnsiString): AnsiString;

implementation

function DecodeURLElement(Const S: AnsiString): AnsiString;

var
  i,l,o : Integer;
  c: AnsiChar;
  p : pchar;
  h : string;

begin
  l := Length(S);
  if l=0 then exit;
  SetLength(Result, l);
  P:=PChar(Result);
  i:=1;
  While (I<=L) do
    begin
    c := S[i];
    if (c<>'%') then
      begin
      P^:=c;
      Inc(P);
      end
    else if (I<L-1) then
      begin
      H:='$'+Copy(S,I+1,2);
      o:=StrToIntDef(H,-1);
      If (O>=0) and (O<=255) then
        begin
        P^:=char(O);
        Inc(P);
        Inc(I,2);
        end;
      end;
    Inc(i);
  end;
  SetLength(Result, P-Pchar(Result));
end;


end.

