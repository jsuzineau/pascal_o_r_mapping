unit ufStringList;

{$mode delphi}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 StdCtrls;

type

 { TfStringList }

 TfStringList
 =
  class(TForm)
  published
   m: TMemo;
   Panel1: TPanel;
   procedure FormShow(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( _Caption: String; _S: TStrings); reintroduce;
    destructor Destroy; override;
  //S
  public
    S: TStrings;
  end;

function Assure_fStringList( var _fStringList: TfStringList; _Caption: String; _S: TStrings): TfStringList;

implementation

{$R *.lfm}

{ TfStringList }

function Assure_fStringList( var _fStringList: TfStringList; _Caption: String; _S: TStrings): TfStringList;
begin
     if nil = _fStringList
     then
         _fStringList:= TfStringList.Create( _Caption, _S);
     Result:= _fStringList;
end;

procedure TfStringList.FormShow(Sender: TObject);
begin
     m.Lines.Text:= S.Text;
end;

constructor TfStringList.Create( _Caption: String; _S: TStrings);
begin
     inherited Create( nil);
     S:= _S;

     Caption:= _Caption;
end;

destructor TfStringList.Destroy;
begin
     inherited Destroy;
end;

end.

