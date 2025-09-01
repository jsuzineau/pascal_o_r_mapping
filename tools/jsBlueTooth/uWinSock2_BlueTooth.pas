unit uWinSock2_BlueTooth;

{$mode ObjFPC}{$H+}

interface

uses
    uWinUtils,
    Classes, SysUtils, Windows, Winsock2;
//ws2bth.h
const
     NS_BTH         = 16; //namespace Bluetooth pour les appels
                          // WinSock WSALookupService
                          //(valeur définie dans ws2bth.h du SDK Windows)
     AF_BTH         = 32; // Famille d'adresse Bluetooth
     BTHPROTO_RFCOMM=  3; // Protocole RFCOMM Bluetooth

type
    TBTH_Addr = UInt64; // Adresse Bluetooth, 48 bits significatifs

    TSockAddr_BTH
    =
     packed record
       addressFamily : Word     ;// AF_BTH
       btAddr        : TBTH_Addr;
       serviceClassId: TGUID    ;
       port          : ULONG    ;// RFCOMM channel ou 0 (auto)
     end;
    PSockAddr_BTH= ^TSockAddr_BTH;

    { TWSA }

    TWSA
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create;
       destructor Destroy; override;
     //attributs
     public
       Error: Integer;
       WSAData: TWSAData;
     end;

function WSALastError_Message: String;

implementation

function WSALastError_Message: String;
begin
     Result:= LastError_Message( WSAGetLastError);
end;

{ TWSA }

constructor TWSA.Create;
begin
     if 0 <> WSAStartup( $0202, WSAData)
     then
         raise Exception.Create( WSALastError_Message);
end;

destructor TWSA.Destroy;
begin
     if 0 <> WSACleanup
     then
         raise Exception.Create( WSALastError_Message);
     inherited Destroy;
end;


end.

