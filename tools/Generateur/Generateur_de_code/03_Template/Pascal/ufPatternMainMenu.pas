unit ufPatternMainMenu;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  {Uses_Key}
  uClean;

type
 TfPatternMainMenu
 =
  class(TForm)
    mm: TMainMenu;
    miBase: TMenuItem;
    miVide: TMenuItem;
    miRelations: TMenuItem;
    miRelationVide: TMenuItem;
    miBaseCalcule: TMenuItem;
    miBaseCalculeVide: TMenuItem;
    miRelationsCalcule: TMenuItem;
    miRelationsCalculeVide: TMenuItem;
    procedure FormCreate(Sender: TObject);
    {Declaration_Key}
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fPatternMainMenu: TfPatternMainMenu;

implementation

{$R *.lfm}

var
   FfPatternMainMenu: TfPatternMainMenu;

function fPatternMainMenu: TfPatternMainMenu;
begin
     Clean_Get( Result, FfPatternMainMenu, TfPatternMainMenu);
end;

{ TfPatternMainMenu }

procedure TfPatternMainMenu.FormCreate(Sender: TObject);
begin
     inherited;
     miVide        .Visible:= False;
     miRelationVide.Visible:= False;
     miBaseCalculeVide     .Visible:= False;
     miRelationsCalculeVide.Visible:= False;
end;

{Implementation_Key}

initialization
              Clean_Create ( FfPatternMainMenu, TfPatternMainMenu);
finalization
              Clean_Destroy( FfPatternMainMenu);
end.

