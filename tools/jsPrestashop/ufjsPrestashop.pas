unit ufjsPrestashop;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    udmDatabase,
    ufIP_dsb,
    ufReputation_dsb,
    ufIP_Address_CSV,
    Classes, SysUtils, Forms, Controls, Graphics,
    Dialogs, StdCtrls, ExtCtrls, SynEdit;

type

 { TfjsPrestashop }

 TfjsPrestashop
 =
  class(TForm)
   bIP_Address_CSV: TButton;
   tShow: TTimer;
   procedure bIP_Address_CSVClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure tShowTimer(Sender: TObject);
  private
    fIP_dsb: TfIP_dsb;
    fReputation_dsb: TfReputation_dsb;
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


CREATE VIEW ip_address
as
  select
	    ip_address
  from
      ip

update ip
set
   ip = ia.ip,
   reseau = ia.reseau
from
    (
	select ip_address, ip, reseau from ip_address
	) as ia
where ia.ip_address = ip.ip_address

CREATE VIEW reseau_view
as
  select
	    reseau,
	    count(*) as nb,
	    sum(nb) as ip_nb
  from
      ip
  group by reseau
  order by nb desc

create view reseau_47_128 as
select * from reseau_view where reseau like "47.128%"

}


{$R *.lfm}

{ TfjsPrestashop }

procedure TfjsPrestashop.FormCreate(Sender: TObject);
begin
     Clean_Create( fIP_dsb, TfIP_dsb);
     Clean_Create( fReputation_dsb, TfReputation_dsb);
end;

procedure TfjsPrestashop.bIP_Address_CSVClick(Sender: TObject);
begin
     fIP_Address_CSV.show;
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

