{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }
program lsusb;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, libusb, CustApp
 { you can add units after this };

type

 { TLSUSB }

 TLSUSB = class(TCustomApplication)
 protected
  procedure DoRun; override;
 public
  constructor Create(TheOwner: TComponent); override;
  destructor Destroy; override;
  procedure WriteHelp; virtual;
 //List devices
 private
   function List_devices: ssize_t;
 end;


Function sDescriptor( _dev_handle: Plibusb_device_handle; _index:Longint): String;
const STRING_MAX_SIZE = 256;
var
   Buffer: array[0..STRING_MAX_SIZE] of Char;
begin
     Result:= '';
     if 0 = _index then exit;

     if 0 > libusb_get_string_descriptor_ascii( _dev_handle, _index, Buffer, STRING_MAX_SIZE-1)
     then
         exit;
     Result:= StrPas( Buffer);
end;


{ TLSUSB }

function TLSUSB.List_devices: ssize_t;
var
   devices: PPlibusb_device;
   devices_length: ssize_t;
   I: Integer;
   procedure Handle_Device( _device: Plibusb_device; _level: Integer);
   var
      descriptor: libusb_device_descriptor;
      Line: String;
      procedure Add_Info_from_Device_Handle;
      var
         device_handle: Plibusb_device_handle;
         function sD( _index:Longint): String;
         begin
              Result:= sDescriptor( device_handle, _index);
         end;
      begin
           try
              if LIBUSB_SUCCESS <> libusb_open( _device, @device_handle) then exit;
           except
                 on E: Exception
                 do
                   begin
                   Line:= Line+'libusb_open failed: '+E.Message;
                   exit;
                   end;
                 end;

           try
              Line
              :=
                 Line
                +'('+sD( descriptor.iManufacturer)+')'
                +' '+sD( descriptor.iProduct     )+' '
                +'['+sD( descriptor.iSerialNumber)+']';
           finally
                  libusb_close(device_handle);
                  end;
      end;
   begin
        if 0 > libusb_get_device_descriptor( _device, descriptor)
        then
            begin
            WriteLn('failed to get device descriptor');
            exit;
            end;
        Line
        :=
           Format( '%sDev (bus %d, device %d): %04X:%04X',
                   [
                   StringOfChar(' ',2*_level),
                   libusb_get_bus_number(_device),
                   libusb_get_device_address(_device),
                   descriptor.idVendor,
                   descriptor.idProduct
                   ]);
        Add_Info_from_Device_Handle;
        WriteLn( Line);
   end;

begin
     devices_length:= libusb_get_device_list( nil, @devices);
     Result:= devices_length;
     if Result < 0 then exit;

     try
        for I:= 0 to devices_length-1
        do
          begin
          Handle_Device( devices[I], 0);
          end;

     finally
    	    libusb_free_device_list(devices, 1);
            end;
end;

procedure TLSUSB.DoRun;
var
   ErrorMsg: String;
   libusb_init_result: Integer;
begin
     // quick check parameters
     ErrorMsg:=CheckOptions('h', 'help');
     if ErrorMsg<>''
     then
         begin
         ShowException(Exception.Create(ErrorMsg));
         Terminate;
         Exit;
     end ;

     // parse parameters
     if HasOption('h', 'help')
     then
         begin
         WriteHelp;
         Terminate;
         Exit;
         end;

     { add your program here }
     libusb_init_result:= libusb_init( nil);
     if 0 <> libusb_init_result
     then
         Halt( libusb_init_result);

     try
        List_devices;
     finally
    	    libusb_exit( nil);
            end;

     // stop program loop
     Terminate;
end;

constructor TLSUSB.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);
     StopOnException:=True;
end;

destructor TLSUSB.Destroy;
begin
     inherited Destroy;
end;

procedure TLSUSB.WriteHelp;
begin
     { add your help code here }
     writeln('Usage: ', ExeName, ' -h');
end;

var
   Application: TLSUSB;
begin
     Application:=TLSUSB.Create(nil);
     Application.Title:='LSUSB';
     Application.Run;
     Application.Free;
end.

