unit ufjsODP;

{$mode objfpc}{$H+}

interface

uses
    uOpenDocument,
    uOD_JCL,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DOM;

type

 { TfjsODP }

 TfjsODP = class(TForm)
  bOF: TButton;
  bSupprime_animations: TButton;
  eFilename: TEdit;
  Label1: TLabel;
  od: TOpenDialog;
  procedure bOFClick(Sender: TObject);
  procedure bSupprime_animationsClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
 private
  procedure Traite_parametres;
  procedure Supprime_animations( _Filename: String);
 public

 end;

var
 fjsODP: TfjsODP;

implementation

{$R *.lfm}

{ TfjsODP }

procedure TfjsODP.FormCreate(Sender: TObject);
begin
     eFilename.Text:= '';
     Traite_parametres;
end;

procedure TfjsODP.bOFClick(Sender: TObject);
begin
     od.FileName:= eFilename.Text;
     if od.Execute
     then
         eFilename.Text:= od.FileName;
end;

procedure TfjsODP.FormDropFiles(Sender: TObject;
 const FileNames: array of string);
begin
     if 0 = length(FileNames) then exit;
     eFilename.Text:= FileNames[0];
end;

procedure TfjsODP.Traite_parametres;
begin
     if ParamCount = 0 then exit;
     eFilename.Text:= ParamStr(1);
end;

procedure TfjsODP.Supprime_animations( _Filename: String);
var
   D: TOpenDocument;
   N: TDOMNode;
begin
     try
        D:= TOpenDocument.Create( _Filename);
        D.Nom:= ChangeFileExt( _Filename, '_sans_animations.odp');
        while true
        do
          begin
          N:= Cherche_Item_Recursif( D.xmlContent.DocumentElement,
                                     'anim:par',
                                     ['presentation:node-type'],
                                     ['timing-root']);
          if nil = N then break;
          FreeAndNil( N);
          end;
        D.Save;
     finally
            FreeAndNil( D);
            end;
end;

procedure TfjsODP.bSupprime_animationsClick(Sender: TObject);
begin
     Supprime_animations( eFilename.Text);
end;

end.

