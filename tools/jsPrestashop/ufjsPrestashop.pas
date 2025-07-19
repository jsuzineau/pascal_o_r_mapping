unit ufjsPrestashop;

{$mode objfpc}{$H+}

interface

uses
    uClean, udmDatabase, ufIP_dsb, Classes, SysUtils, Forms, Controls, Graphics,
    Dialogs, StdCtrls, ExtCtrls, SynEdit;

type

 { TfjsPrestashop }

 TfjsPrestashop
 =
  class(TForm)
   tShow: TTimer;
   procedure FormCreate(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure tShowTimer(Sender: TObject);
  private
    fIP_dsb: TfIP_dsb;
  end;

var
 fjsPrestashop: TfjsPrestashop;

implementation

// SELECT ip_address, count(*) as nb, min(date_add) as debut, max(date_add) as fin FROM `pslx_connections` group by ip_address order by nb desc;

//essai avec row_number() as id :
// SELECT row_number() over w as id, ip_address, count(*) as nb, min(date_add) as debut, max(date_add) as fin FROM `pslx_connections` group by ip_address window w as (order by nb desc);
{
OPTIMIZE TABLE pslx_connections_page;
OPTIMIZE TABLE pslx_guest;
OPTIMIZE TABLE pslx_connections;

OPTIMIZE TABLE pslx_connections_source;

}

{$R *.lfm}

{ TfjsPrestashop }

procedure TfjsPrestashop.FormCreate(Sender: TObject);
begin
     Clean_Create( fIP_dsb, TfIP_dsb);
end;

procedure TfjsPrestashop.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfjsPrestashop.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     fIP_dsb.Execute;
end;

end.

