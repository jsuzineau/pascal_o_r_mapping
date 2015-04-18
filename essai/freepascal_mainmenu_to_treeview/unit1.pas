unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ComCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    l: TLabel;
    mm: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Splitter1: TSplitter;
    tv: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure tvClick(Sender: TObject);
    procedure tvSelectionChanged(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure MenuClic( _Sender: TObject);
    procedure Treeview_from_MainMenu;
    procedure Traite_MenuItem( _rmi: TMenuItem; _rtn: TTreeNode);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     Treeview_from_MainMenu;
end;

procedure TForm1.MenuClic( _Sender: TObject);
begin
     l.Caption:= 'Item cliqué: '+(_Sender as TMenuItem).Caption;
end;

procedure TForm1.Traite_MenuItem( _rmi: TMenuItem; _rtn: TTreeNode);
var
   I: Integer;
   mi: TMenuItem;
   tn: TTreeNode;
begin
     for I:= 0 to _rmi.Count-1
     do
       begin
       mi:= _rmi.Items[I];

       tn:= tv.Items.AddChild( _rtn, mi.Caption);
       tn.Data:= mi;

       Traite_MenuItem( mi, tn);
       end;
end;

procedure TForm1.Treeview_from_MainMenu;
begin
     Traite_MenuItem( mm.Items, tv.Items.GetFirstNode);
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
     MenuClic( Sender);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
     MenuClic( Sender);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
     MenuClic( Sender);
end;

procedure TForm1.tvClick(Sender: TObject);
var
   tn: TTreeNode;
   mi: TMenuItem;
begin
     tn:= tv.Selected;
     if nil = tn then exit;
     if tn.Data = nil then exit;
     if not (TObject( tn.Data) is TMenuItem) then exit;
     mi:= TMenuItem( tn.Data);

     if not Assigned( mi.OnClick) then exit;
     mi.OnClick( mi);
end;

procedure TForm1.tvSelectionChanged(Sender: TObject);
begin

end;

end.

