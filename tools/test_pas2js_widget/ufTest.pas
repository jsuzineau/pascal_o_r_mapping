unit ufTest;

{$mode delphi}{$H+}
{$modeswitch externalclass}

interface

uses
 JS, Classes, SysUtils, Graphics, Controls, Forms, Dialogs, WebCtrls, StdCtrls,
 uJSChamps, ucWChamp_Edit;

type
 { TfTest }

 TfTest = class(TWForm)
  b: TWButton;
  bAffiche_proxy: TWButton;
  l: TWLabel;
  lAffiche_proxy: TWLabel;
  lProxy: TWLabel;
  bProxy: TWButton;
  lCallBack: TWLabel;
  bAffiche_target: TWButton;
  lAffiche_Target: TWLabel;
  bAutre_Form: TWButton;
  wce: TWChamp_Edit;
  wce1: TWChamp_Edit;
  WDataGrid1: TWDataGrid;
  WEdit1: TWEdit;
  WPanel1: TWPanel;
  procedure bAffiche_proxyClick(Sender: TObject);
  procedure bAffiche_targetClick(Sender: TObject);
  procedure bAutre_FormClick(Sender: TObject);
  procedure bClick(Sender: TObject);
  procedure bProxyClick(Sender: TObject);
 private
 public
  procedure Loaded; override;
 //tric
 private
  tric: TJSChamps;
  procedure proxy_OnSet( _propertyKey, _value: TJSObject);
 end;

var
 fTest: TfTest;


implementation

uses
     ufAutre_Form;
procedure TfTest.Loaded;
begin
     inherited Loaded;
     {$I ufTest.wfm}
     tric:= TJSChamps.Create;
     tric.Properties['a']:= 'affecté par TfTest.Loaded;';
     tric.OnSet.Add( @proxy_OnSet);
     wce.Champs:= tric;
     wce1.Champs:= tric;
end;

procedure TfTest.bClick(Sender: TObject);
begin
     if 'Truc' = l.Caption
     then
         l.Caption:= 'Troc'
     else
         l.Caption:= 'Truc';

end;

procedure TfTest.bProxyClick(Sender: TObject);
var
   jsv: JSValue;
begin
     //asm tric.a= 'troc'; end;
     tric.proxy.Properties['a']:= 'affecté par proxy';
     jsv:= tric.Properties['a'];
     lProxy.Caption:= JS.toString( jsv);

     tric.Properties['a']:= 'affecté par target';

end;

procedure TfTest.bAffiche_targetClick(Sender: TObject);
begin
     lAffiche_Target.Caption:= JS.toString( tric.Properties['a']);
end;

procedure TfTest.bAutre_FormClick(Sender: TObject);
begin
     fAutre_Form.Show;
end;

procedure TfTest.bAffiche_proxyClick(Sender: TObject);
begin
     lAffiche_proxy.Caption:= JS.toString( tric.proxy.Properties['a']);
end;

procedure TfTest.proxy_OnSet( _propertyKey, _value: TJSObject);
begin
     lCallBack.Caption:= 'Callback: '+TJSJSON.stringify( _propertyKey)+'='+TJSJSON.stringify( _value);
end;

end.

