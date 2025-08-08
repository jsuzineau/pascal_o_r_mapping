unit uacCloud_Filter;

{$mode Delphi}

interface

uses
    uClean,
    uDataUtilsU,
    uLog,
    uChrono,
    uAPI_Client,
    uuStrings,
 Classes, SysUtils,StrUtils;

type

 { TacCloud_Filter }

 TacCloud_Filter
 =
  class( TAPI_Client)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    function Bad_reputation( _ip: String): Boolean;
  //Compteur pour éviter d'être banni
  private
    Count: Integer;
  public
    function Max_reached: Boolean;
  end;

implementation

{ TacCloud_Filter }

constructor TacCloud_Filter.Create;
begin
     inherited Create;
     Count:= 0;
end;

destructor TacCloud_Filter.Destroy;
begin
     inherited Destroy;
end;

function TacCloud_Filter.Bad_reputation(_ip: String): Boolean;
var
   html: String;
   i: Integer;
begin
     html
     :=
       GET( 'Bad_reputation',
            'https://cloudfilt.com/ip-reputation/lookup?ip='+_ip);
     i:= Pos( _ip+' Has a bad reputation', html);
     Result:= i > 0;
     Inc( Count);
end;

function TacCloud_Filter.Max_reached: Boolean;
begin
     Result:= Count >= 50;
end;

end.

