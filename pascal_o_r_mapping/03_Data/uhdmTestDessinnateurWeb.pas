unit uhdmTestDessinnateurWeb;

{$mode delphi}

interface

uses
    uClean,
    uSVG,
    uDrawInfo,
    uBatpro_Element,
    ubeClusterElement,
    ubeString,
    uhDessinnateurWeb,
    upoolG_BECP,
 Classes, SysUtils;

type

 { ThdmTestDessinnateurWeb }

 ThdmTestDessinnateurWeb
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //attributs
  private
    hdW: ThDessinnateurWeb;
    bs: TbeString;
    ce1: TbeClusterElement;
    ce2: TbeClusterElement;
  //Méthodes
  public
    function html_file: String;
  end;

function hdmTestDessinnateurWeb: ThdmTestDessinnateurWeb;

implementation

var
   FhdmTestDessinnateurWeb: ThdmTestDessinnateurWeb= nil;

function hdmTestDessinnateurWeb: ThdmTestDessinnateurWeb;
begin
     if nil = FhdmTestDessinnateurWeb
     then
         FhdmTestDessinnateurWeb:= ThdmTestDessinnateurWeb.Create;
     Result:= FhdmTestDessinnateurWeb;
end;

{ ThdmTestDessinnateurWeb }

constructor ThdmTestDessinnateurWeb.Create;
begin
     bs:= TbeString.Create( nil, 'Test', clYellow, bea_Gauche);
     bs.Cree_Cluster;
     bs.Cluster.Initialise;
     bs.Cluster.Colonne_LargeurMaxi:= 10;
     ce1:= TbeClusterElement.Create( nil, bs);
     ce2:= TbeClusterElement.Create( nil, bs);
     bs.Cluster.Ajoute( ce1, 1,1);
     bs.Cluster.Ajoute( ce2, 2,1);


     hdW:= ThDessinnateurWeb.Create( 1, 'Test', nil);
     hdW.sg.Width := 100;
     hdW.sg.Height:= 100;
     hdW.sg.DefaultColWidth := 25;
     hdW.sg.DefaultRowHeight:= 25;
     hdW.sg.Resize( 4, 4);

     hdW.Charge_Cell( ce1, 1, 1);
     hdW.Charge_Cell( ce2, 2, 1);
end;

destructor ThdmTestDessinnateurWeb.Destroy;
begin
     Free_nil( ce1);
     Free_nil( ce2);
     Free_nil( bs);
     Free_nil( hdW);
     inherited Destroy;
end;

function ThdmTestDessinnateurWeb.html_file: String;
begin
     Result:= hdW.html_file;
end;

initialization
finalization
               Free_nil( FhdmTestDessinnateurWeb);
end.

