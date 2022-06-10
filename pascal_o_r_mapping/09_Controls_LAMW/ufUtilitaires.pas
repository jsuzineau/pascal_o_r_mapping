{Hint: save all files to location: \jni }
unit ufUtilitaires;

{$mode delphi}

interface

uses
    uAndroid_Database,
 Classes, SysUtils, AndroidWidget, Laz_And_Controls;
 
type

 { TfUtilitaires }

 TfUtilitaires
 =
  class(jForm)
    bRecree_Base: jButton;
    procedure bRecree_BaseClick(Sender: TObject);
  private
    FileName: String;
  end;

 function fUtilitaires(_FileName: String): TfUtilitaires;

implementation
 
{$R *.lfm}
 
{ TfUtilitaires }

var
   FfUtilitaires: TfUtilitaires = nil;

function fUtilitaires(_FileName: String): TfUtilitaires;
begin
     if nil = FfUtilitaires
     then
	 begin
	 gApp.CreateForm( TfUtilitaires, FfUtilitaires);
	 FfUtilitaires.Init;
	 end;
     Result:= FfUtilitaires;
     Result.FileName:= _FileName;
end;

procedure TfUtilitaires.bRecree_BaseClick(Sender: TObject);
begin
     uAndroid_Database_Recree_Base( Self, FileName);
end;

end.
