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
unit libusb;
interface

{
  Automatically converted by H2Pas 1.0.0 from E:\03_travail\libusb\libusb-1.0.22\include\libusb-1.0\libusb.tmp.h
  The following command line parameters were used:
    -e
    -p
    -D
    -w
    -o
    E:\03_travail\libusb\libusb-1.0.22\include\libusb-1.0\libusb.pas
    E:\03_travail\libusb\libusb-1.0.22\include\libusb-1.0\libusb.tmp.h
}

    const
//      External_library='libusb-1.0'; {Setup as you need}
      External_library='E:\03_travail\libusb\libusb-1.0.22\MinGW64\static\libusb-1.0.a'; {Setup as you need}
//{$LINKLIB 'E:\03_travail\libusb\libusb-1.0.22\MinGW64\static\libusb-1.0.a'}
{$LINKLIB 'libusb-1.0.dll'}

    { Pointers to basic pascal types, inserted by h2pas conversion program.}
    Type
      PLongint  = ^Longint;
      PSmallInt = ^SmallInt;
      PByte     = ^Byte;
      PWord     = ^Word;
      PDWord    = ^DWord;
      PDouble   = ^Double;

{
Type
    Plibusb_bos_descriptor  = ^libusb_bos_descriptor;
    Plibusb_bos_dev_capability_descriptor  = ^libusb_bos_dev_capability_descriptor;
    Plibusb_bos_type  = ^libusb_bos_type;
    Plibusb_capability  = ^libusb_capability;
    Plibusb_class_code  = ^libusb_class_code;
    Plibusb_config_descriptor  = ^libusb_config_descriptor;
    Plibusb_container_id_descriptor  = ^libusb_container_id_descriptor;
    Plibusb_context  = ^libusb_context;
    Plibusb_control_setup  = ^libusb_control_setup;
    Plibusb_descriptor_type  = ^libusb_descriptor_type;
    Plibusb_device  = ^libusb_device;
    Plibusb_device_descriptor  = ^libusb_device_descriptor;
    Plibusb_device_handle  = ^libusb_device_handle;
    Plibusb_endpoint_descriptor  = ^libusb_endpoint_descriptor;
    Plibusb_endpoint_direction  = ^libusb_endpoint_direction;
    Plibusb_error  = ^libusb_error;
    Plibusb_hotplug_callback_handle  = ^libusb_hotplug_callback_handle;
    Plibusb_hotplug_event  = ^libusb_hotplug_event;
    Plibusb_hotplug_flag  = ^libusb_hotplug_flag;
    Plibusb_interface  = ^libusb_interface;
    Plibusb_interface_descriptor  = ^libusb_interface_descriptor;
    Plibusb_iso_packet_descriptor  = ^libusb_iso_packet_descriptor;
    Plibusb_iso_sync_type  = ^libusb_iso_sync_type;
    Plibusb_iso_usage_type  = ^libusb_iso_usage_type;
    Plibusb_log_level  = ^libusb_log_level;
    Plibusb_option  = ^libusb_option;
    Plibusb_pollfd  = ^libusb_pollfd;
    Plibusb_request_recipient  = ^libusb_request_recipient;
    Plibusb_request_type  = ^libusb_request_type;
    Plibusb_speed  = ^libusb_speed;
    Plibusb_ss_endpoint_companion_descriptor  = ^libusb_ss_endpoint_companion_descriptor;
    Plibusb_ss_usb_device_capability_attributes  = ^libusb_ss_usb_device_capability_attributes;
    Plibusb_ss_usb_device_capability_descriptor  = ^libusb_ss_usb_device_capability_descriptor;
    Plibusb_standard_request  = ^libusb_standard_request;
    Plibusb_supported_speed  = ^libusb_supported_speed;
    Plibusb_transfer  = ^libusb_transfer;
    Plibusb_transfer_flags  = ^libusb_transfer_flags;
    Plibusb_transfer_status  = ^libusb_transfer_status;
    Plibusb_transfer_type  = ^libusb_transfer_type;
    Plibusb_usb_2_0_extension_attributes  = ^libusb_usb_2_0_extension_attributes;
    Plibusb_usb_2_0_extension_descriptor  = ^libusb_usb_2_0_extension_descriptor;
    Plibusb_version  = ^libusb_version;
    Pssize_t  = ^ssize_t;
    Puint16_t  = ^uint16_t;
    Puint32_t  = ^uint32_t;
    Puint8_t  = ^uint8_t;
}
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {
   * Public libusb header file
   * Copyright © 2001 Johannes Erdfelt <johannes@erdfelt.com>
   * Copyright © 2007-2008 Daniel Drake <dsd@gentoo.org>
   * Copyright © 2012 Pete Batard <pete@akeo.ie>
   * Copyright © 2012 Nathan Hjelm <hjelmn@cs.unm.edu>
   * For more information, please visit: http://libusb.info
   *
   * This library is free software; you can redistribute it and/or
   * modify it under the terms of the GNU Lesser General Public
   * License as published by the Free Software Foundation; either
   * version 2.1 of the License, or (at your option) any later version.
   *
   * This library is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   * Lesser General Public License for more details.
   *
   * You should have received a copy of the GNU Lesser General Public
   * License along with this library; if not, write to the Free Software
   * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
    }
  type
    Pssize_t = ^ssize_t;
    ssize_t = int64;
  type
    Puint8_t = ^uint8_t;
    uint8_t = byte;

    Puint16_t = ^uint16_t;
    uint16_t = word;

    Puint32_t = ^uint32_t;
    uint32_t = dword;
    { [0] - non-standard, but usually working code  }
    const
      ZERO_SIZED_ARRAY =1;// 0;      
    { 'interface' might be defined as a macro on Windows, so we need to
     * undefine it so as not to break the current libusb API, because
     * libusb_config_descriptor has an 'interface' member
     * As this can be problematic if you include windows.h after libusb.h
     * in your sources, we force windows.h to be included first.  }

    function LIBUSB_DEPRECATED_FOR(f : longint) : longint;    

    { __GNUC__  }
    {* \def WINAPI
     * \ingroup libusb_misc
     * libusb's Windows calling convention.
     *
     * Under Windows, the selection of available compilers and configurations
     * means that, unlike other platforms, there is not <em>one true calling
     * convention</em> (calling convention: the manner in which parameters are
     * passed to functions in the generated assembly code).
     *
     * Matching the Windows API itself, libusb uses the WINAPI convention (which
     * translates to the <tt>stdcall</tt> convention) and guarantees that the
     * library is compiled in this way. The public header file also includes
     * appropriate annotations so that your own software will use the right
     * convention, even if another convention is being used by default within
     * your codebase.
     *
     * The one consideration that you must apply in your software is to mark
     * all functions which you use as libusb callbacks with this WINAPI
     * annotation, so that they too get compiled for the correct calling
     * convention.
     *
     * On non-Windows operating systems, this macro is defined as nothing. This
     * means that you can apply it to your code without worrying about
     * cross-platform compatibility.
      }
    { WINAPI must be defined on both definition and declaration of libusb
     * functions. You'd think that declaration would be enough, but cygwin will
     * complain about conflicting types unless both are marked this way.
     * The placement of this macro is important too; it must appear after the
     * return type, before the function name. See internal documentation for
     * API_EXPORTED.
      }
    {* \def LIBUSB_API_VERSION
     * \ingroup libusb_misc
     * libusb's API version.
     *
     * Since version 1.0.13, to help with feature detection, libusb defines
     * a LIBUSB_API_VERSION macro that gets increased every time there is a
     * significant change to the API, such as the introduction of a new call,
     * the definition of a new macro/enum member, or any other element that
     * libusb applications may want to detect at compilation time.
     *
     * The macro is typically used in an application as follows:
     * \code
     * #if defined(LIBUSB_API_VERSION) && (LIBUSB_API_VERSION >= 0x01001234)
     * // Use one of the newer features from the libusb API
     * #endif
     * \endcode
     *
     * Internally, LIBUSB_API_VERSION is defined as follows:
     * (libusb major << 24) | (libusb minor << 16) | (16 bit incremental)
      }

    const
      LIBUSB_API_VERSION = $01000106;      
    { The following is kept for compatibility, but will be deprecated in the future  }
      LIBUSBX_API_VERSION = LIBUSB_API_VERSION;      
    {*
     * \ingroup libusb_misc
     * Convert a 16-bit value from host-endian to little-endian format. On
     * little endian systems, this function does nothing. On big endian systems,
     * the bytes are swapped.
     * \param x the host-endian value to convert
     * \returns the value in little-endian byte order
      }
(* error 
static inline uint16_t libusb_cpu_to_le16(const uint16_t x)
 in declarator_list *)
(* error 
	union {
 in declarator_list *)
(* error 
		uint8_t  b8[2];
 in declarator_list *)

      var
        b16 : uint16_t;cvar;public;
(* error 
	} _tmp;
in declaration at line 174 *)
(* error 
	_tmp.b8[1] = (uint8_t) (x >> 8); *)
(* error 
	_tmp.b8[1] = (uint8_t) (x >> 8);
 in declarator_list *)
(* error 
	_tmp.b8[0] = (uint8_t) (x & 0xff); *)
(* error 
	_tmp.b8[0] = (uint8_t) (x & 0xff);
 in declarator_list *)
(* error 
	return _tmp.b16;
 in declarator_list *)
    { }
    {* \def libusb_le16_to_cpu
     * \ingroup libusb_misc
     * Convert a 16-bit value from little-endian to host-endian format. On
     * little endian systems, this function does nothing. On big endian systems,
     * the bytes are swapped.
     * \param x the little-endian value to convert
     * \returns the value in host-endian byte order
      }

//    const
//      libusb_le16_to_cpu = libusb_cpu_to_le16;      
    { standard USB stuff  }
    {* \ingroup libusb_desc
     * Device and/or Interface Class codes  }
    {* In the context of a \ref libusb_device_descriptor "device descriptor",
    	 * this bDeviceClass value indicates that each interface specifies its
    	 * own class information and all interfaces operate independently.
    	  }
    {* Audio class  }
    {* Communications class  }
    {* Human Interface Device class  }
    {* Physical  }
    {* Printer class  }
    {* Image class  }
    { legacy name from libusb-0.1 usb.h  }
    {* Mass storage class  }
    {* Hub class  }
    {* Data class  }
    {* Smart Card  }
    {* Content Security  }
    {* Video  }
    {* Personal Healthcare  }
    {* Diagnostic Device  }
    {* Wireless class  }
    {* Application class  }
    {* Class is vendor-specific  }

    type
      libusb_class_code =  Longint;
      Const
        LIBUSB_CLASS_PER_INTERFACE = 0;
        LIBUSB_CLASS_AUDIO = 1;
        LIBUSB_CLASS_COMM = 2;
        LIBUSB_CLASS_HID = 3;
        LIBUSB_CLASS_PHYSICAL = 5;
        LIBUSB_CLASS_PRINTER = 7;
        LIBUSB_CLASS_PTP = 6;
        LIBUSB_CLASS_IMAGE = 6;
        LIBUSB_CLASS_MASS_STORAGE = 8;
        LIBUSB_CLASS_HUB = 9;
        LIBUSB_CLASS_DATA = 10;
        LIBUSB_CLASS_SMART_CARD = $0b;
        LIBUSB_CLASS_CONTENT_SECURITY = $0d;
        LIBUSB_CLASS_VIDEO = $0e;
        LIBUSB_CLASS_PERSONAL_HEALTHCARE = $0f;
        LIBUSB_CLASS_DIAGNOSTIC_DEVICE = $dc;
        LIBUSB_CLASS_WIRELESS = $e0;
        LIBUSB_CLASS_APPLICATION = $fe;
        LIBUSB_CLASS_VENDOR_SPEC = $ff;

    {* \ingroup libusb_desc
     * Descriptor types as defined by the USB specification.  }
    {* Device descriptor. See libusb_device_descriptor.  }
    {* Configuration descriptor. See libusb_config_descriptor.  }
    {* String descriptor  }
    {* Interface descriptor. See libusb_interface_descriptor.  }
    {* Endpoint descriptor. See libusb_endpoint_descriptor.  }
    {* BOS descriptor  }
    {* Device Capability descriptor  }
    {* HID descriptor  }
    {* HID report descriptor  }
    {* Physical descriptor  }
    {* Hub descriptor  }
    {* SuperSpeed Hub descriptor  }
    {* SuperSpeed Endpoint Companion descriptor  }

    type
      libusb_descriptor_type =  Longint;
      Const
        LIBUSB_DT_DEVICE = $01;
        LIBUSB_DT_CONFIG = $02;
        LIBUSB_DT_STRING = $03;
        LIBUSB_DT_INTERFACE = $04;
        LIBUSB_DT_ENDPOINT = $05;
        LIBUSB_DT_BOS = $0f;
        LIBUSB_DT_DEVICE_CAPABILITY = $10;
        LIBUSB_DT_HID = $21;
        LIBUSB_DT_REPORT = $22;
        LIBUSB_DT_PHYSICAL = $23;
        LIBUSB_DT_HUB = $29;
        LIBUSB_DT_SUPERSPEED_HUB = $2a;
        LIBUSB_DT_SS_ENDPOINT_COMPANION = $30;

    { Descriptor sizes per descriptor type  }
      LIBUSB_DT_DEVICE_SIZE = 18;      
      LIBUSB_DT_CONFIG_SIZE = 9;      
      LIBUSB_DT_INTERFACE_SIZE = 9;      
      LIBUSB_DT_ENDPOINT_SIZE = 7;      
    { Audio extension  }      LIBUSB_DT_ENDPOINT_AUDIO_SIZE = 9;      
      LIBUSB_DT_HUB_NONVAR_SIZE = 7;      
      LIBUSB_DT_SS_ENDPOINT_COMPANION_SIZE = 6;      
      LIBUSB_DT_BOS_SIZE = 5;      
      LIBUSB_DT_DEVICE_CAPABILITY_SIZE = 3;      
    { BOS descriptor sizes  }
      LIBUSB_BT_USB_2_0_EXTENSION_SIZE = 7;      
      LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE = 10;      
      LIBUSB_BT_CONTAINER_ID_SIZE = 20;      
    { We unwrap the BOS => define its max size  }

    { was #define dname def_expr }
    LIBUSB_DT_BOS_MAX_SIZE= LIBUSB_DT_BOS_SIZE+LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE+LIBUSB_BT_CONTAINER_ID_SIZE;

  { in bEndpointAddress  }  const
    LIBUSB_ENDPOINT_ADDRESS_MASK = $0f;    
    LIBUSB_ENDPOINT_DIR_MASK = $80;    
  {* \ingroup libusb_desc
   * Endpoint direction. Values for bit 7 of the
   * \ref libusb_endpoint_descriptor::bEndpointAddress "endpoint address" scheme.
    }
  {* In: device-to-host  }
  {* Out: host-to-device  }

  type
    libusb_endpoint_direction =  Longint;
    Const
      LIBUSB_ENDPOINT_IN = $80;
      LIBUSB_ENDPOINT_OUT = $00;

  { in bmAttributes  }    LIBUSB_TRANSFER_TYPE_MASK = $03;    
  {* \ingroup libusb_desc
   * Endpoint transfer type. Values for bits 0:1 of the
   * \ref libusb_endpoint_descriptor::bmAttributes "endpoint attributes" field.
    }
  {* Control endpoint  }
  {* Isochronous endpoint  }
  {* Bulk endpoint  }
  {* Interrupt endpoint  }
  {* Stream endpoint  }

  type
    libusb_transfer_type =  Longint;
    Const
      LIBUSB_TRANSFER_TYPE_CONTROL = 0;
      LIBUSB_TRANSFER_TYPE_ISOCHRONOUS = 1;
      LIBUSB_TRANSFER_TYPE_BULK = 2;
      LIBUSB_TRANSFER_TYPE_INTERRUPT = 3;
      LIBUSB_TRANSFER_TYPE_BULK_STREAM = 4;

  {* \ingroup libusb_misc
   * Standard requests, as defined in table 9-5 of the USB 3.0 specifications  }
  {* Request status of the specific recipient  }
  {* Clear or disable a specific feature  }
  { 0x02 is reserved  }
  {* Set or enable a specific feature  }
  { 0x04 is reserved  }
  {* Set device address for all future accesses  }
  {* Get the specified descriptor  }
  {* Used to update existing descriptors or add new descriptors  }
  {* Get the current device configuration value  }
  {* Set device configuration  }
  {* Return the selected alternate setting for the specified interface  }
  {* Select an alternate interface for the specified interface  }
  {* Set then report an endpoint's synchronization frame  }
  {* Sets both the U1 and U2 Exit Latency  }
  {* Delay from the time a host transmits a packet to the time it is
  	  * received by the device.  }

  type
    libusb_standard_request =  Longint;
    Const
      LIBUSB_REQUEST_GET_STATUS = $00;
      LIBUSB_REQUEST_CLEAR_FEATURE = $01;
      LIBUSB_REQUEST_SET_FEATURE = $03;
      LIBUSB_REQUEST_SET_ADDRESS = $05;
      LIBUSB_REQUEST_GET_DESCRIPTOR = $06;
      LIBUSB_REQUEST_SET_DESCRIPTOR = $07;
      LIBUSB_REQUEST_GET_CONFIGURATION = $08;
      LIBUSB_REQUEST_SET_CONFIGURATION = $09;
      LIBUSB_REQUEST_GET_INTERFACE = $0A;
      LIBUSB_REQUEST_SET_INTERFACE = $0B;
      LIBUSB_REQUEST_SYNCH_FRAME = $0C;
      LIBUSB_REQUEST_SET_SEL = $30;
      LIBUSB_SET_ISOCH_DELAY = $31;

  {* \ingroup libusb_misc
   * Request type bits of the
   * \ref libusb_control_setup::bmRequestType "bmRequestType" field in control
   * transfers.  }
  {* Standard  }
  {* Class  }
  {* Vendor  }
  {* Reserved  }

  type
    libusb_request_type =  Longint;
    Const
      LIBUSB_REQUEST_TYPE_STANDARD = $00 shl 5;
      LIBUSB_REQUEST_TYPE_CLASS = $01 shl 5;
      LIBUSB_REQUEST_TYPE_VENDOR = $02 shl 5;
      LIBUSB_REQUEST_TYPE_RESERVED = $03 shl 5;

  {* \ingroup libusb_misc
   * Recipient bits of the
   * \ref libusb_control_setup::bmRequestType "bmRequestType" field in control
   * transfers. Values 4 through 31 are reserved.  }
  {* Device  }
  {* Interface  }
  {* Endpoint  }
  {* Other  }

  type
    libusb_request_recipient =  Longint;
    Const
      LIBUSB_RECIPIENT_DEVICE = $00;
      LIBUSB_RECIPIENT_INTERFACE = $01;
      LIBUSB_RECIPIENT_ENDPOINT = $02;
      LIBUSB_RECIPIENT_OTHER = $03;

    LIBUSB_ISO_SYNC_TYPE_MASK = $0C;    
  {* \ingroup libusb_desc
   * Synchronization type for isochronous endpoints. Values for bits 2:3 of the
   * \ref libusb_endpoint_descriptor::bmAttributes "bmAttributes" field in
   * libusb_endpoint_descriptor.
    }
  {* No synchronization  }
  {* Asynchronous  }
  {* Adaptive  }
  {* Synchronous  }

  type
    libusb_iso_sync_type =  Longint;
    Const
      LIBUSB_ISO_SYNC_TYPE_NONE = 0;
      LIBUSB_ISO_SYNC_TYPE_ASYNC = 1;
      LIBUSB_ISO_SYNC_TYPE_ADAPTIVE = 2;
      LIBUSB_ISO_SYNC_TYPE_SYNC = 3;

    LIBUSB_ISO_USAGE_TYPE_MASK = $30;    
  {* \ingroup libusb_desc
   * Usage type for isochronous endpoints. Values for bits 4:5 of the
   * \ref libusb_endpoint_descriptor::bmAttributes "bmAttributes" field in
   * libusb_endpoint_descriptor.
    }
  {* Data endpoint  }
  {* Feedback endpoint  }
  {* Implicit feedback Data endpoint  }

  type
    libusb_iso_usage_type =  Longint;
    Const
      LIBUSB_ISO_USAGE_TYPE_DATA = 0;
      LIBUSB_ISO_USAGE_TYPE_FEEDBACK = 1;
      LIBUSB_ISO_USAGE_TYPE_IMPLICIT = 2;

  {* \ingroup libusb_desc
   * A structure representing the standard USB device descriptor. This
   * descriptor is documented in section 9.6.1 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE LIBUSB_DT_DEVICE in this
  	 * context.  }
  {* USB specification release number in binary-coded decimal. A value of
  	 * 0x0200 indicates USB 2.0, 0x0110 indicates USB 1.1, etc.  }
  {* USB-IF class code for the device. See \ref libusb_class_code.  }
  {* USB-IF subclass code for the device, qualified by the bDeviceClass
  	 * value  }
  {* USB-IF protocol code for the device, qualified by the bDeviceClass and
  	 * bDeviceSubClass values  }
  {* Maximum packet size for endpoint 0  }
  {* USB-IF vendor ID  }
  {* USB-IF product ID  }
  {* Device release number in binary-coded decimal  }
  {* Index of string descriptor describing manufacturer  }
  {* Index of string descriptor describing product  }
  {* Index of string descriptor containing device serial number  }
  {* Number of possible configurations  }

  type
    Plibusb_device_descriptor = ^libusb_device_descriptor;
    libusb_device_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bcdUSB : uint16_t;
        bDeviceClass : uint8_t;
        bDeviceSubClass : uint8_t;
        bDeviceProtocol : uint8_t;
        bMaxPacketSize0 : uint8_t;
        idVendor : uint16_t;
        idProduct : uint16_t;
        bcdDevice : uint16_t;
        iManufacturer : uint8_t;
        iProduct : uint8_t;
        iSerialNumber : uint8_t;
        bNumConfigurations : uint8_t;
      end;

  {* \ingroup libusb_desc
   * A structure representing the standard USB endpoint descriptor. This
   * descriptor is documented in section 9.6.6 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_ENDPOINT LIBUSB_DT_ENDPOINT in
  	 * this context.  }
  {* The address of the endpoint described by this descriptor. Bits 0:3 are
  	 * the endpoint number. Bits 4:6 are reserved. Bit 7 indicates direction,
  	 * see \ref libusb_endpoint_direction.
  	  }
  {* Attributes which apply to the endpoint when it is configured using
  	 * the bConfigurationValue. Bits 0:1 determine the transfer type and
  	 * correspond to \ref libusb_transfer_type. Bits 2:3 are only used for
  	 * isochronous endpoints and correspond to \ref libusb_iso_sync_type.
  	 * Bits 4:5 are also only used for isochronous endpoints and correspond to
  	 * \ref libusb_iso_usage_type. Bits 6:7 are reserved.
  	  }
  {* Maximum packet size this endpoint is capable of sending/receiving.  }
  {* Interval for polling endpoint for data transfers.  }
  {* For audio devices only: the rate at which synchronization feedback
  	 * is provided.  }
  {* For audio devices only: the address if the synch endpoint  }
  {* Extra descriptors. If libusb encounters unknown endpoint descriptors,
  	 * it will store them here, should you wish to parse them.  }
(* Const before type ignored *)
  {* Length of the extra descriptors, in bytes.  }
    Plibusb_endpoint_descriptor = ^libusb_endpoint_descriptor;
    libusb_endpoint_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bEndpointAddress : uint8_t;
        bmAttributes : uint8_t;
        wMaxPacketSize : uint16_t;
        bInterval : uint8_t;
        bRefresh : uint8_t;
        bSynchAddress : uint8_t;
        extra : Pbyte;
        extra_length : longint;
      end;

  {* \ingroup libusb_desc
   * A structure representing the standard USB interface descriptor. This
   * descriptor is documented in section 9.6.5 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_INTERFACE LIBUSB_DT_INTERFACE
  	 * in this context.  }
  {* Number of this interface  }
  {* Value used to select this alternate setting for this interface  }
  {* Number of endpoints used by this interface (excluding the control
  	 * endpoint).  }
  {* USB-IF class code for this interface. See \ref libusb_class_code.  }
  {* USB-IF subclass code for this interface, qualified by the
  	 * bInterfaceClass value  }
  {* USB-IF protocol code for this interface, qualified by the
  	 * bInterfaceClass and bInterfaceSubClass values  }
  {* Index of string descriptor describing this interface  }
  {* Array of endpoint descriptors. This length of this array is determined
  	 * by the bNumEndpoints field.  }
(* Const before type ignored *)
  {* Extra descriptors. If libusb encounters unknown interface descriptors,
  	 * it will store them here, should you wish to parse them.  }
(* Const before type ignored *)
  {* Length of the extra descriptors, in bytes.  }
    Plibusb_interface_descriptor = ^libusb_interface_descriptor;
    libusb_interface_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bInterfaceNumber : uint8_t;
        bAlternateSetting : uint8_t;
        bNumEndpoints : uint8_t;
        bInterfaceClass : uint8_t;
        bInterfaceSubClass : uint8_t;
        bInterfaceProtocol : uint8_t;
        iInterface : uint8_t;
        endpoint : Plibusb_endpoint_descriptor;
        extra : Pbyte;
        extra_length : longint;
      end;

  {* \ingroup libusb_desc
   * A collection of alternate settings for a particular USB interface.
    }
  {* Array of interface descriptors. The length of this array is determined
  	 * by the num_altsetting field.  }
(* Const before type ignored *)
  {* The number of alternate settings that belong to this interface  }
    Plibusb_interface = ^libusb_interface;
    libusb_interface = record
        altsetting : Plibusb_interface_descriptor;
        num_altsetting : longint;
      end;

  {* \ingroup libusb_desc
   * A structure representing the standard USB configuration descriptor. This
   * descriptor is documented in section 9.6.3 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_CONFIG LIBUSB_DT_CONFIG
  	 * in this context.  }
  {* Total length of data returned for this configuration  }
  {* Number of interfaces supported by this configuration  }
  {* Identifier value for this configuration  }
  {* Index of string descriptor describing this configuration  }
  {* Configuration characteristics  }
  {* Maximum power consumption of the USB device from this bus in this
  	 * configuration when the device is fully operation. Expressed in units
  	 * of 2 mA when the device is operating in high-speed mode and in units
  	 * of 8 mA when the device is operating in super-speed mode.  }
  {* Array of interfaces supported by this configuration. The length of
  	 * this array is determined by the bNumInterfaces field.  }
(* Const before type ignored *)
  {* Extra descriptors. If libusb encounters unknown configuration
  	 * descriptors, it will store them here, should you wish to parse them.  }
(* Const before type ignored *)
  {* Length of the extra descriptors, in bytes.  }
    Plibusb_config_descriptor = ^libusb_config_descriptor;
    libusb_config_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        wTotalLength : uint16_t;
        bNumInterfaces : uint8_t;
        bConfigurationValue : uint8_t;
        iConfiguration : uint8_t;
        bmAttributes : uint8_t;
        MaxPower : uint8_t;
        _interface : Plibusb_interface;
        extra : Pbyte;
        extra_length : longint;
      end;

  {* \ingroup libusb_desc
   * A structure representing the superspeed endpoint companion
   * descriptor. This descriptor is documented in section 9.6.7 of
   * the USB 3.0 specification. All multiple-byte fields are represented in
   * host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_SS_ENDPOINT_COMPANION in
  	 * this context.  }
  {* The maximum number of packets the endpoint can send or
  	 *  receive as part of a burst.  }
  {* In bulk EP:	bits 4:0 represents the	maximum	number of
  	 *  streams the	EP supports. In	isochronous EP:	bits 1:0
  	 *  represents the Mult	- a zero based value that determines
  	 *  the	maximum	number of packets within a service interval   }
  {* The	total number of bytes this EP will transfer every
  	 *  service interval. valid only for periodic EPs.  }
    Plibusb_ss_endpoint_companion_descriptor = ^libusb_ss_endpoint_companion_descriptor;
    libusb_ss_endpoint_companion_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bMaxBurst : uint8_t;
        bmAttributes : uint8_t;
        wBytesPerInterval : uint16_t;
      end;

  {* \ingroup libusb_desc
   * A generic representation of a BOS Device Capability descriptor. It is
   * advised to check bDevCapabilityType and call the matching
   * libusb_get_*_descriptor function to get a structure fully matching the type.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
  	 * LIBUSB_DT_DEVICE_CAPABILITY in this context.  }
  {* Device Capability type  }
  {* Device Capability data (bLength - 3 bytes)  }
    Plibusb_bos_dev_capability_descriptor = ^libusb_bos_dev_capability_descriptor;
    libusb_bos_dev_capability_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bDevCapabilityType : uint8_t;
        dev_capability_data : array[0..(ZERO_SIZED_ARRAY)-1] of uint8_t;
      end;

  {* \ingroup libusb_desc
   * A structure representing the Binary Device Object Store (BOS) descriptor.
   * This descriptor is documented in section 9.6.2 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_BOS LIBUSB_DT_BOS
  	 * in this context.  }
  {* Length of this descriptor and all of its sub descriptors  }
  {* The number of separate device capability descriptors in
  	 * the BOS  }
  {* bNumDeviceCap Device Capability Descriptors  }
    Plibusb_bos_descriptor = ^libusb_bos_descriptor;
    libusb_bos_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        wTotalLength : uint16_t;
        bNumDeviceCaps : uint8_t;
        dev_capability : array[0..(ZERO_SIZED_ARRAY)-1] of Plibusb_bos_dev_capability_descriptor;
      end;

  {* \ingroup libusb_desc
   * A structure representing the USB 2.0 Extension descriptor
   * This descriptor is documented in section 9.6.2.1 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
  	 * LIBUSB_DT_DEVICE_CAPABILITY in this context.  }
  {* Capability type. Will have value
  	 * \ref libusb_capability_type::LIBUSB_BT_USB_2_0_EXTENSION
  	 * LIBUSB_BT_USB_2_0_EXTENSION in this context.  }
  {* Bitmap encoding of supported device level features.
  	 * A value of one in a bit location indicates a feature is
  	 * supported; a value of zero indicates it is not supported.
  	 * See \ref libusb_usb_2_0_extension_attributes.  }
    Plibusb_usb_2_0_extension_descriptor = ^libusb_usb_2_0_extension_descriptor;
    libusb_usb_2_0_extension_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bDevCapabilityType : uint8_t;
        bmAttributes : uint32_t;
      end;

  {* \ingroup libusb_desc
   * A structure representing the SuperSpeed USB Device Capability descriptor
   * This descriptor is documented in section 9.6.2.2 of the USB 3.0 specification.
   * All multiple-byte fields are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
  	 * LIBUSB_DT_DEVICE_CAPABILITY in this context.  }
  {* Capability type. Will have value
  	 * \ref libusb_capability_type::LIBUSB_BT_SS_USB_DEVICE_CAPABILITY
  	 * LIBUSB_BT_SS_USB_DEVICE_CAPABILITY in this context.  }
  {* Bitmap encoding of supported device level features.
  	 * A value of one in a bit location indicates a feature is
  	 * supported; a value of zero indicates it is not supported.
  	 * See \ref libusb_ss_usb_device_capability_attributes.  }
  {* Bitmap encoding of the speed supported by this device when
  	 * operating in SuperSpeed mode. See \ref libusb_supported_speed.  }
  {* The lowest speed at which all the functionality supported
  	 * by the device is available to the user. For example if the
  	 * device supports all its functionality when connected at
  	 * full speed and above then it sets this value to 1.  }
  {* U1 Device Exit Latency.  }
  {* U2 Device Exit Latency.  }
    Plibusb_ss_usb_device_capability_descriptor = ^libusb_ss_usb_device_capability_descriptor;
    libusb_ss_usb_device_capability_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bDevCapabilityType : uint8_t;
        bmAttributes : uint8_t;
        wSpeedSupported : uint16_t;
        bFunctionalitySupport : uint8_t;
        bU1DevExitLat : uint8_t;
        bU2DevExitLat : uint16_t;
      end;

  {* \ingroup libusb_desc
   * A structure representing the Container ID descriptor.
   * This descriptor is documented in section 9.6.2.3 of the USB 3.0 specification.
   * All multiple-byte fields, except UUIDs, are represented in host-endian format.
    }
  {* Size of this descriptor (in bytes)  }
  {* Descriptor type. Will have value
  	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE_CAPABILITY
  	 * LIBUSB_DT_DEVICE_CAPABILITY in this context.  }
  {* Capability type. Will have value
  	 * \ref libusb_capability_type::LIBUSB_BT_CONTAINER_ID
  	 * LIBUSB_BT_CONTAINER_ID in this context.  }
  {* Reserved field  }
  {* 128 bit UUID  }
    Plibusb_container_id_descriptor = ^libusb_container_id_descriptor;
    libusb_container_id_descriptor = record
        bLength : uint8_t;
        bDescriptorType : uint8_t;
        bDevCapabilityType : uint8_t;
        bReserved : uint8_t;
        ContainerID : array[0..15] of uint8_t;
      end;

  {* \ingroup libusb_asyncio
   * Setup packet for control transfers.  }
  {* Request type. Bits 0:4 determine recipient, see
  	 * \ref libusb_request_recipient. Bits 5:6 determine type, see
  	 * \ref libusb_request_type. Bit 7 determines data transfer direction, see
  	 * \ref libusb_endpoint_direction.
  	  }
  {* Request. If the type bits of bmRequestType are equal to
  	 * \ref libusb_request_type::LIBUSB_REQUEST_TYPE_STANDARD
  	 * "LIBUSB_REQUEST_TYPE_STANDARD" then this field refers to
  	 * \ref libusb_standard_request. For other cases, use of this field is
  	 * application-specific.  }
  {* Value. Varies according to request  }
  {* Index. Varies according to request, typically used to pass an index
  	 * or offset  }
  {* Number of bytes to transfer  }
    Plibusb_control_setup = ^libusb_control_setup;
    libusb_control_setup = record
        bmRequestType : uint8_t;
        bRequest : uint8_t;
        wValue : uint16_t;
        wIndex : uint16_t;
        wLength : uint16_t;
      end;

(* error 
#define LIBUSB_CONTROL_SETUP_SIZE (sizeof(struct libusb_control_setup))
in define line 890 *)
    { libusb  }
      Plibusb_context = ^libusb_context;
      libusb_context = record
          {undefined structure}
        end;

      Plibusb_device = ^libusb_device;
      PPlibusb_device = ^Plibusb_device;
      PPPlibusb_device = ^PPlibusb_device;
      Plibusb_device_array= array[0..0] of Plibusb_device;
      libusb_device = record
          {undefined structure}
        end;

      Plibusb_device_handle = ^libusb_device_handle;
      PPlibusb_device_handle = ^Plibusb_device_handle;
      libusb_device_handle = record
          {undefined structure}
        end;

    {* \ingroup libusb_lib
     * Structure providing the version of the libusb runtime
      }
    {* Library major version.  }
(* Const before type ignored *)
    {* Library minor version.  }
(* Const before type ignored *)
    {* Library micro version.  }
(* Const before type ignored *)
    {* Library nano version.  }
(* Const before type ignored *)
    {* Library release candidate suffix string, e.g. "-rc4".  }
(* Const before type ignored *)
    {* For ABI compatibility only.  }
(* Const before type ignored *)
      Plibusb_version = ^libusb_version;
      libusb_version = record
          major : uint16_t;
          minor : uint16_t;
          micro : uint16_t;
          nano : uint16_t;
          rc : Pchar;
          describe : Pchar;
        end;

    {* \ingroup libusb_lib
     * Structure representing a libusb session. The concept of individual libusb
     * sessions allows for your program to use two libraries (or dynamically
     * load two modules) which both independently use libusb. This will prevent
     * interference between the individual libusb users - for example
     * libusb_set_option() will not affect the other user of the library, and
     * libusb_exit() will not destroy resources that the other user is still
     * using.
     *
     * Sessions are created by libusb_init() and destroyed through libusb_exit().
     * If your application is guaranteed to only ever include a single libusb
     * user (i.e. you), you do not have to worry about contexts: pass NULL in
     * every function call where a context is required. The default context
     * will be used.
     *
     * For more information, see \ref libusb_contexts.
      }
    {* \ingroup libusb_dev
     * Structure representing a USB device detected on the system. This is an
     * opaque type for which you are only ever provided with a pointer, usually
     * originating from libusb_get_device_list().
     *
     * Certain operations can be performed on a device, but in order to do any
     * I/O you will have to first obtain a device handle using libusb_open().
     *
     * Devices are reference counted with libusb_ref_device() and
     * libusb_unref_device(), and are freed when the reference count reaches 0.
     * New devices presented by libusb_get_device_list() have a reference count of
     * 1, and libusb_free_device_list() can optionally decrease the reference count
     * on all devices in the list. libusb_open() adds another reference which is
     * later destroyed by libusb_close().
      }
    {* \ingroup libusb_dev
     * Structure representing a handle on a USB device. This is an opaque type for
     * which you are only ever provided with a pointer, usually originating from
     * libusb_open().
     *
     * A device handle is used to perform I/O and other operations. When finished
     * with a device handle, you should call libusb_close().
      }
    {* \ingroup libusb_dev
     * Speed codes. Indicates the speed at which the device is operating.
      }
    {* The OS doesn't report or know the device speed.  }
    {* The device is operating at low speed (1.5MBit/s).  }
    {* The device is operating at full speed (12MBit/s).  }
    {* The device is operating at high speed (480MBit/s).  }
    {* The device is operating at super speed (5000MBit/s).  }
    {* The device is operating at super speed plus (10000MBit/s).  }
      libusb_speed =  Longint;
      Const
        LIBUSB_SPEED_UNKNOWN = 0;
        LIBUSB_SPEED_LOW = 1;
        LIBUSB_SPEED_FULL = 2;
        LIBUSB_SPEED_HIGH = 3;
        LIBUSB_SPEED_SUPER = 4;
        LIBUSB_SPEED_SUPER_PLUS = 5;

    {* \ingroup libusb_dev
     * Supported speeds (wSpeedSupported) bitfield. Indicates what
     * speeds the device supports.
      }
    {* Low speed operation supported (1.5MBit/s).  }
    {* Full speed operation supported (12MBit/s).  }
    {* High speed operation supported (480MBit/s).  }
    {* Superspeed operation supported (5000MBit/s).  }

    type
      libusb_supported_speed =  Longint;
      Const
        LIBUSB_LOW_SPEED_OPERATION = 1;
        LIBUSB_FULL_SPEED_OPERATION = 2;
        LIBUSB_HIGH_SPEED_OPERATION = 4;
        LIBUSB_SUPER_SPEED_OPERATION = 8;

    {* \ingroup libusb_dev
     * Masks for the bits of the
     * \ref libusb_usb_2_0_extension_descriptor::bmAttributes "bmAttributes" field
     * of the USB 2.0 Extension descriptor.
      }
    {* Supports Link Power Management (LPM)  }

    type
      libusb_usb_2_0_extension_attributes =  Longint;
      Const
        LIBUSB_BM_LPM_SUPPORT = 2;

    {* \ingroup libusb_dev
     * Masks for the bits of the
     * \ref libusb_ss_usb_device_capability_descriptor::bmAttributes "bmAttributes" field
     * field of the SuperSpeed USB Device Capability descriptor.
      }
    {* Supports Latency Tolerance Messages (LTM)  }

    type
      libusb_ss_usb_device_capability_attributes =  Longint;
      Const
        LIBUSB_BM_LTM_SUPPORT = 2;

    {* \ingroup libusb_dev
     * USB capability types
      }
    {* Wireless USB device capability  }
    {* USB 2.0 extensions  }
    {* SuperSpeed USB device capability  }
    {* Container ID type  }

    type
      libusb_bos_type =  Longint;
      Const
        LIBUSB_BT_WIRELESS_USB_DEVICE_CAPABILITY = 1;
        LIBUSB_BT_USB_2_0_EXTENSION = 2;
        LIBUSB_BT_SS_USB_DEVICE_CAPABILITY = 3;
        LIBUSB_BT_CONTAINER_ID = 4;

    {* \ingroup libusb_misc
     * Error codes. Most libusb functions return 0 on success or one of these
     * codes on failure.
     * You can call libusb_error_name() to retrieve a string representation of an
     * error code or libusb_strerror() to get an end-user suitable description of
     * an error code.
      }
    {* Success (no error)  }
    {* Input/output error  }
    {* Invalid parameter  }
    {* Access denied (insufficient permissions)  }
    {* No such device (it may have been disconnected)  }
    {* Entity not found  }
    {* Resource busy  }
    {* Operation timed out  }
    {* Overflow  }
    {* Pipe error  }
    {* System call interrupted (perhaps due to signal)  }
    {* Insufficient memory  }
    {* Operation not supported or unimplemented on this platform  }
    { NB: Remember to update LIBUSB_ERROR_COUNT below as well as the
    	   message strings in strerror.c when adding new error codes here.  }
    {* Other error  }

    type
      libusb_error =  Longint;
      Const
        LIBUSB_SUCCESS = 0;
        LIBUSB_ERROR_IO = -(1);
        LIBUSB_ERROR_INVALID_PARAM = -(2);
        LIBUSB_ERROR_ACCESS = -(3);
        LIBUSB_ERROR_NO_DEVICE = -(4);
        LIBUSB_ERROR_NOT_FOUND = -(5);
        LIBUSB_ERROR_BUSY = -(6);
        LIBUSB_ERROR_TIMEOUT = -(7);
        LIBUSB_ERROR_OVERFLOW = -(8);
        LIBUSB_ERROR_PIPE = -(9);
        LIBUSB_ERROR_INTERRUPTED = -(10);
        LIBUSB_ERROR_NO_MEM = -(11);
        LIBUSB_ERROR_NOT_SUPPORTED = -(12);
        LIBUSB_ERROR_OTHER = -(99);

    { Total number of error codes in enum libusb_error  }
      LIBUSB_ERROR_COUNT = 14;      
    {* \ingroup libusb_asyncio
     * Transfer status codes  }
    {* Transfer completed without error. Note that this does not indicate
    	 * that the entire amount of requested data was transferred.  }
    {* Transfer failed  }
    {* Transfer timed out  }
    {* Transfer was cancelled  }
    {* For bulk/interrupt endpoints: halt condition detected (endpoint
    	 * stalled). For control endpoints: control request not supported.  }
    {* Device was disconnected  }
    {* Device sent more data than requested  }
    { NB! Remember to update libusb_error_name()
    	   when adding new status codes here.  }

    type
      libusb_transfer_status =  Longint;
      Const
        LIBUSB_TRANSFER_COMPLETED = 0;
        LIBUSB_TRANSFER_ERROR = 1;
        LIBUSB_TRANSFER_TIMED_OUT = 2;
        LIBUSB_TRANSFER_CANCELLED = 3;
        LIBUSB_TRANSFER_STALL = 4;
        LIBUSB_TRANSFER_NO_DEVICE = 5;
        LIBUSB_TRANSFER_OVERFLOW = 6;

    {* \ingroup libusb_asyncio
     * libusb_transfer.flags values  }
    {* Report short frames as errors  }
    {* Automatically free() transfer buffer during libusb_free_transfer().
    	 * Note that buffers allocated with libusb_dev_mem_alloc() should not
    	 * be attempted freed in this way, since free() is not an appropriate
    	 * way to release such memory.  }
    {* Automatically call libusb_free_transfer() after callback returns.
    	 * If this flag is set, it is illegal to call libusb_free_transfer()
    	 * from your transfer callback, as this will result in a double-free
    	 * when this flag is acted upon.  }
    {* Terminate transfers that are a multiple of the endpoint's
    	 * wMaxPacketSize with an extra zero length packet. This is useful
    	 * when a device protocol mandates that each logical request is
    	 * terminated by an incomplete packet (i.e. the logical requests are
    	 * not separated by other means).
    	 *
    	 * This flag only affects host-to-device transfers to bulk and interrupt
    	 * endpoints. In other situations, it is ignored.
    	 *
    	 * This flag only affects transfers with a length that is a multiple of
    	 * the endpoint's wMaxPacketSize. On transfers of other lengths, this
    	 * flag has no effect. Therefore, if you are working with a device that
    	 * needs a ZLP whenever the end of the logical request falls on a packet
    	 * boundary, then it is sensible to set this flag on <em>every</em>
    	 * transfer (you do not have to worry about only setting it on transfers
    	 * that end on the boundary).
    	 *
    	 * This flag is currently only supported on Linux.
    	 * On other systems, libusb_submit_transfer() will return
    	 * LIBUSB_ERROR_NOT_SUPPORTED for every transfer where this flag is set.
    	 *
    	 * Available since libusb-1.0.9.
    	  }

    type
      libusb_transfer_flags =  Longint;
      Const
        LIBUSB_TRANSFER_SHORT_NOT_OK = 1 shl 0;
        LIBUSB_TRANSFER_FREE_BUFFER = 1 shl 1;
        LIBUSB_TRANSFER_FREE_TRANSFER = 1 shl 2;
        LIBUSB_TRANSFER_ADD_ZERO_PACKET = 1 shl 3;

    {* \ingroup libusb_asyncio
     * Isochronous packet descriptor.  }
    {* Length of data to request in this packet  }
    {* Amount of data that was actually transferred  }
    {* Status code for this packet  }

    type
      Plibusb_iso_packet_descriptor = ^libusb_iso_packet_descriptor;
      libusb_iso_packet_descriptor = record
          length : dword;
          actual_length : dword;
          status : libusb_transfer_status;
        end;

    {* \ingroup libusb_asyncio
     * The generic USB transfer structure. The user populates this structure and
     * then submits it in order to request a transfer. After the transfer has
     * completed, the library populates the transfer with the results and passes
     * it back to the user.
      }
    {* Handle of the device that this transfer will be submitted to  }
    {* A bitwise OR combination of \ref libusb_transfer_flags.  }
    {* Address of the endpoint where this transfer will be sent.  }
    {* Type of the endpoint from \ref libusb_transfer_type  }
    {* Timeout for this transfer in milliseconds. A value of 0 indicates no
    	 * timeout.  }
    {* The status of the transfer. Read-only, and only for use within
    	 * transfer callback function.
    	 *
    	 * If this is an isochronous transfer, this field may read COMPLETED even
    	 * if there were errors in the frames. Use the
    	 * \ref libusb_iso_packet_descriptor::status "status" field in each packet
    	 * to determine if errors occurred.  }
    {* Length of the data buffer  }
    {* Actual length of data that was transferred. Read-only, and only for
    	 * use within transfer callback function. Not valid for isochronous
    	 * endpoint transfers.  }
    {* Callback function. This will be invoked when the transfer completes,
    	 * fails, or is cancelled.  }
    {* User context data to pass to the callback function.  }
    {* Data buffer  }
    {* Number of isochronous packets. Only used for I/O with isochronous
    	 * endpoints.  }
    {* Isochronous packet descriptors, for isochronous transfers only.  }
      Plibusb_transfer = ^libusb_transfer;
      libusb_transfer_cb_fn = procedure (transfer:Plibusb_transfer);cdecl;
      libusb_transfer = record
          dev_handle : Plibusb_device_handle;
          flags : uint8_t;
          endpoint : byte;
          _type : byte;
          timeout : dword;
          status : libusb_transfer_status;
          length : longint;
          actual_length : longint;
          callback : libusb_transfer_cb_fn;
          user_data : pointer;
          buffer : Pbyte;
          num_iso_packets : longint;
          iso_packet_desc : array[0..(ZERO_SIZED_ARRAY)-1] of libusb_iso_packet_descriptor;
        end;

      {* \ingroup libusb_asyncio
       * Asynchronous transfer callback function type. When submitting asynchronous
       * transfers, you pass a pointer to a callback function of this type via the
       * \ref libusb_transfer::callback "callback" member of the libusb_transfer
       * structure. libusb will call this function later, when the transfer has
       * completed or failed. See \ref libusb_asyncio for more information.
       * \param transfer The libusb_transfer struct the callback function is being
       * notified about.
        }

    {* \ingroup libusb_misc
     * Capabilities supported by an instance of libusb on the current running
     * platform. Test if the loaded library supports a given capability by calling
     * \ref libusb_has_capability().
      }
    {* The libusb_has_capability() API is available.  }
    {* Hotplug support is available on this platform.  }
    {* The library can access HID devices without requiring user intervention.
    	 * Note that before being able to actually access an HID device, you may
    	 * still have to call additional libusb functions such as
    	 * \ref libusb_detach_kernel_driver().  }
    {* The library supports detaching of the default USB driver, using 
    	 * \ref libusb_detach_kernel_driver(), if one is set by the OS kernel  }
      libusb_capability =  Longint;
      Const
        LIBUSB_CAP_HAS_CAPABILITY = $0000;
        LIBUSB_CAP_HAS_HOTPLUG = $0001;
        LIBUSB_CAP_HAS_HID_ACCESS = $0100;
        LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER = $0101;

    {* \ingroup libusb_lib
     *  Log message levels.
     *  - LIBUSB_LOG_LEVEL_NONE (0)    : no messages ever printed by the library (default)
     *  - LIBUSB_LOG_LEVEL_ERROR (1)   : error messages are printed to stderr
     *  - LIBUSB_LOG_LEVEL_WARNING (2) : warning and error messages are printed to stderr
     *  - LIBUSB_LOG_LEVEL_INFO (3)    : informational messages are printed to stderr
     *  - LIBUSB_LOG_LEVEL_DEBUG (4)   : debug and informational messages are printed to stderr
      }

    type
      libusb_log_level =  Longint;
      Const
        LIBUSB_LOG_LEVEL_NONE = 0;
        LIBUSB_LOG_LEVEL_ERROR = 1;
        LIBUSB_LOG_LEVEL_WARNING = 2;
        LIBUSB_LOG_LEVEL_INFO = 3;
        LIBUSB_LOG_LEVEL_DEBUG = 4;


    function libusb_init( ctx:Plibusb_context):longint;cdecl;external  name 'libusb_init';

    procedure libusb_exit( ctx:Plibusb_context);cdecl;external  name 'libusb_exit';

(* error 
void  libusb_set_debug(libusb_context *ctx, int level);
(* error 
void  libusb_set_debug(libusb_context *ctx, int level);
 in declarator_list *)
 in declarator_list *)
(* Const before type ignored *)
    function libusb_get_version:Plibusb_version;cdecl;external  name 'libusb_get_version';

    function libusb_has_capability(capability:uint32_t):longint;cdecl;external  name 'libusb_has_capability';

(* Const before type ignored *)
    function libusb_error_name(errcode:longint):Pchar;cdecl;external  name 'libusb_error_name';

(* Const before type ignored *)
    function libusb_setlocale(locale:Pchar):longint;cdecl;external  name 'libusb_setlocale';

(* Const before type ignored *)
    function libusb_strerror(errcode:libusb_error):Pchar;cdecl;external  name 'libusb_strerror';

    function libusb_get_device_list( ctx:Plibusb_context; list:PPPlibusb_device):ssize_t;cdecl;external  name 'libusb_get_device_list';

    procedure libusb_free_device_list( list:Plibusb_device_array; unref_devices:longint);cdecl;external  name 'libusb_free_device_list';

    function libusb_ref_device(var dev:libusb_device):Plibusb_device;cdecl;external  name 'libusb_ref_device';

    procedure libusb_unref_device(var dev:libusb_device);cdecl;external  name 'libusb_unref_device';

    function libusb_get_configuration(var dev:libusb_device_handle; var config:longint):longint;cdecl;external  name 'libusb_get_configuration';

    function libusb_get_device_descriptor(dev:Plibusb_device; var desc:libusb_device_descriptor):longint;cdecl;external  name 'libusb_get_device_descriptor';

    function libusb_get_active_config_descriptor(var dev:libusb_device; var config:Plibusb_config_descriptor):longint;cdecl;external  name 'libusb_get_active_config_descriptor';

    function libusb_get_config_descriptor(var dev:libusb_device; config_index:uint8_t; var config:Plibusb_config_descriptor):longint;cdecl;external  name 'libusb_get_config_descriptor';

    function libusb_get_config_descriptor_by_value(var dev:libusb_device; bConfigurationValue:uint8_t; var config:Plibusb_config_descriptor):longint;cdecl;external  name 'libusb_get_config_descriptor_by_value';

    procedure libusb_free_config_descriptor(var config:libusb_config_descriptor);cdecl;external  name 'libusb_free_config_descriptor';

(* Const before type ignored *)
    function libusb_get_ss_endpoint_companion_descriptor(var ctx:libusb_context; var endpoint:libusb_endpoint_descriptor; var ep_comp:Plibusb_ss_endpoint_companion_descriptor):longint;cdecl;external  name 'libusb_get_ss_endpoint_companion_descriptor';

    procedure libusb_free_ss_endpoint_companion_descriptor(var ep_comp:libusb_ss_endpoint_companion_descriptor);cdecl;external  name 'libusb_free_ss_endpoint_companion_descriptor';

    function libusb_get_bos_descriptor(var dev_handle:libusb_device_handle; var bos:Plibusb_bos_descriptor):longint;cdecl;external  name 'libusb_get_bos_descriptor';

    procedure libusb_free_bos_descriptor(var bos:libusb_bos_descriptor);cdecl;external  name 'libusb_free_bos_descriptor';

    function libusb_get_usb_2_0_extension_descriptor(var ctx:libusb_context; var dev_cap:libusb_bos_dev_capability_descriptor; var usb_2_0_extension:Plibusb_usb_2_0_extension_descriptor):longint;cdecl;external  name 'libusb_get_usb_2_0_extension_descriptor';

    procedure libusb_free_usb_2_0_extension_descriptor(var usb_2_0_extension:libusb_usb_2_0_extension_descriptor);cdecl;external  name 'libusb_free_usb_2_0_extension_descriptor';

    function libusb_get_ss_usb_device_capability_descriptor(var ctx:libusb_context; var dev_cap:libusb_bos_dev_capability_descriptor; var ss_usb_device_cap:Plibusb_ss_usb_device_capability_descriptor):longint;cdecl;external  name 'libusb_get_ss_usb_device_capability_descriptor';

    procedure libusb_free_ss_usb_device_capability_descriptor(var ss_usb_device_cap:libusb_ss_usb_device_capability_descriptor);cdecl;external  name 'libusb_free_ss_usb_device_capability_descriptor';

    function libusb_get_container_id_descriptor(var ctx:libusb_context; var dev_cap:libusb_bos_dev_capability_descriptor; var container_id:Plibusb_container_id_descriptor):longint;cdecl;external  name 'libusb_get_container_id_descriptor';

    procedure libusb_free_container_id_descriptor(var container_id:libusb_container_id_descriptor);cdecl;external  name 'libusb_free_container_id_descriptor';

    function libusb_get_bus_number( dev:Plibusb_device):uint8_t;cdecl;external  name 'libusb_get_bus_number';

    function libusb_get_port_number(var dev:libusb_device):uint8_t;cdecl;external  name 'libusb_get_port_number';

    function libusb_get_port_numbers(var dev:libusb_device; var port_numbers:uint8_t; port_numbers_len:longint):longint;cdecl;external  name 'libusb_get_port_numbers';

(* error 
int  libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
(* error 
int  libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
(* error 
int  libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
(* error 
int  libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    function libusb_get_parent(var dev:libusb_device):Plibusb_device;cdecl;external  name 'libusb_get_parent';

    function libusb_get_device_address(dev:Plibusb_device):uint8_t;cdecl;external  name 'libusb_get_device_address';

    function libusb_get_device_speed(var dev:libusb_device):longint;cdecl;external  name 'libusb_get_device_speed';

    function libusb_get_max_packet_size(var dev:libusb_device; endpoint:byte):longint;cdecl;external  name 'libusb_get_max_packet_size';

    function libusb_get_max_iso_packet_size(var dev:libusb_device; endpoint:byte):longint;cdecl;external  name 'libusb_get_max_iso_packet_size';

    function libusb_open(dev: Plibusb_device; dev_handle:PPlibusb_device_handle):longint;cdecl;external  name 'libusb_open';

    procedure libusb_close( dev_handle:Plibusb_device_handle);cdecl;external  name 'libusb_close';

    function libusb_get_device(var dev_handle:libusb_device_handle):Plibusb_device;cdecl;external  name 'libusb_get_device';

    function libusb_set_configuration(var dev_handle:libusb_device_handle; configuration:longint):longint;cdecl;external  name 'libusb_set_configuration';

    function libusb_claim_interface(var dev_handle:libusb_device_handle; interface_number:longint):longint;cdecl;external  name 'libusb_claim_interface';

    function libusb_release_interface(var dev_handle:libusb_device_handle; interface_number:longint):longint;cdecl;external  name 'libusb_release_interface';

    function libusb_open_device_with_vid_pid(var ctx:libusb_context; vendor_id:uint16_t; product_id:uint16_t):Plibusb_device_handle;cdecl;external  name 'libusb_open_device_with_vid_pid';

    function libusb_set_interface_alt_setting(var dev_handle:libusb_device_handle; interface_number:longint; alternate_setting:longint):longint;cdecl;external  name 'libusb_set_interface_alt_setting';

    function libusb_clear_halt(var dev_handle:libusb_device_handle; endpoint:byte):longint;cdecl;external  name 'libusb_clear_halt';

    function libusb_reset_device(var dev_handle:libusb_device_handle):longint;cdecl;external  name 'libusb_reset_device';

    function libusb_alloc_streams(var dev_handle:libusb_device_handle; num_streams:uint32_t; var endpoints:byte; num_endpoints:longint):longint;cdecl;external  name 'libusb_alloc_streams';

    function libusb_free_streams(var dev_handle:libusb_device_handle; var endpoints:byte; num_endpoints:longint):longint;cdecl;external  name 'libusb_free_streams';

    function libusb_dev_mem_alloc(var dev_handle:libusb_device_handle; length:size_t):Pbyte;cdecl;external  name 'libusb_dev_mem_alloc';

    function libusb_dev_mem_free(var dev_handle:libusb_device_handle; var buffer:byte; length:size_t):longint;cdecl;external  name 'libusb_dev_mem_free';

    function libusb_kernel_driver_active(var dev_handle:libusb_device_handle; interface_number:longint):longint;cdecl;external  name 'libusb_kernel_driver_active';

    function libusb_detach_kernel_driver(var dev_handle:libusb_device_handle; interface_number:longint):longint;cdecl;external  name 'libusb_detach_kernel_driver';

    function libusb_attach_kernel_driver(var dev_handle:libusb_device_handle; interface_number:longint):longint;cdecl;external  name 'libusb_attach_kernel_driver';

    function libusb_set_auto_detach_kernel_driver(var dev_handle:libusb_device_handle; enable:longint):longint;cdecl;external  name 'libusb_set_auto_detach_kernel_driver';

    { async I/O  }
    {* \ingroup libusb_asyncio
     * Get the data section of a control transfer. This convenience function is here
     * to remind you that the data does not start until 8 bytes into the actual
     * buffer, as the setup packet comes first.
     *
     * Calling this function only makes sense from a transfer callback function,
     * or situations where you have already allocated a suitably sized buffer at
     * transfer->buffer.
     *
     * \param transfer a transfer
     * \returns pointer to the first byte of the data section
      }
(* error 
static inline unsigned char *libusb_control_transfer_get_data(
 in declarator_list *)
(* error 
	return transfer->buffer + LIBUSB_CONTROL_SETUP_SIZE;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Get the control setup packet of a control transfer. This convenience
     * function is here to remind you that the control setup occupies the first
     * 8 bytes of the transfer data buffer.
     *
     * Calling this function only makes sense from a transfer callback function,
     * or situations where you have already allocated a suitably sized buffer at
     * transfer->buffer.
     *
     * \param transfer a transfer
     * \returns a casted pointer to the start of the transfer data buffer
      }
(* error 
static inline struct libusb_control_setup *libusb_control_transfer_get_setup(
 in declarator_list *)
(* error 
	return (struct libusb_control_setup * )(void * ) transfer->buffer;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Helper function to populate the setup packet (first 8 bytes of the data
     * buffer) for a control transfer. The wIndex, wValue and wLength values should
     * be given in host-endian byte order.
     *
     * \param buffer buffer to output the setup packet into
     * This pointer must be aligned to at least 2 bytes boundary.
     * \param bmRequestType see the
     * \ref libusb_control_setup::bmRequestType "bmRequestType" field of
     * \ref libusb_control_setup
     * \param bRequest see the
     * \ref libusb_control_setup::bRequest "bRequest" field of
     * \ref libusb_control_setup
     * \param wValue see the
     * \ref libusb_control_setup::wValue "wValue" field of
     * \ref libusb_control_setup
     * \param wIndex see the
     * \ref libusb_control_setup::wIndex "wIndex" field of
     * \ref libusb_control_setup
     * \param wLength see the
     * \ref libusb_control_setup::wLength "wLength" field of
     * \ref libusb_control_setup
      }
(* error 
static inline void libusb_fill_control_setup(unsigned char *buffer,
(* error 
	uint8_t bmRequestType, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
(* error 
	uint8_t bmRequestType, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
(* error 
	uint8_t bmRequestType, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
(* error 
	uint8_t bmRequestType, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
(* error 
	uint16_t wLength)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	struct libusb_control_setup *setup = (struct libusb_control_setup * )(void * ) buffer;
 in declarator_list *)
(* error 
	setup->bmRequestType = bmRequestType;
(* error 
	setup->bmRequestType = bmRequestType;
 in declarator_list *)
(* error 
	setup->bRequest = bRequest;
(* error 
	setup->bRequest = bRequest;
 in declarator_list *)
(* error 
	setup->wValue = libusb_cpu_to_le16(wValue);
(* error 
	setup->wValue = libusb_cpu_to_le16(wValue);
 in declarator_list *)
(* error 
	setup->wIndex = libusb_cpu_to_le16(wIndex);
(* error 
	setup->wIndex = libusb_cpu_to_le16(wIndex);
 in declarator_list *)
(* error 
	setup->wLength = libusb_cpu_to_le16(wLength);
(* error 
	setup->wLength = libusb_cpu_to_le16(wLength);
 in declarator_list *)
    { }
(* error 
struct libusb_transfer *  libusb_alloc_transfer(int iso_packets);
in declaration at line 1477 *)*)*)*)*)*)
    function libusb_submit_transfer(var transfer:libusb_transfer):longint;cdecl;external  name 'libusb_submit_transfer';

    function libusb_cancel_transfer(var transfer:libusb_transfer):longint;cdecl;external  name 'libusb_cancel_transfer';

    procedure libusb_free_transfer(var transfer:libusb_transfer);cdecl;external  name 'libusb_free_transfer';

    procedure libusb_transfer_set_stream_id(var transfer:libusb_transfer; stream_id:uint32_t);cdecl;external  name 'libusb_transfer_set_stream_id';

    function libusb_transfer_get_stream_id(var transfer:libusb_transfer):uint32_t;cdecl;external  name 'libusb_transfer_get_stream_id';

    {* \ingroup libusb_asyncio
     * Helper function to populate the required \ref libusb_transfer fields
     * for a control transfer.
     *
     * If you pass a transfer buffer to this function, the first 8 bytes will
     * be interpreted as a control setup packet, and the wLength field will be
     * used to automatically populate the \ref libusb_transfer::length "length"
     * field of the transfer. Therefore the recommended approach is:
     * -# Allocate a suitably sized data buffer (including space for control setup)
     * -# Call libusb_fill_control_setup()
     * -# If this is a host-to-device transfer with a data stage, put the data
     *    in place after the setup packet
     * -# Call this function
     * -# Call libusb_submit_transfer()
     *
     * It is also legal to pass a NULL buffer to this function, in which case this
     * function will not attempt to populate the length field. Remember that you
     * must then populate the buffer and length fields later.
     *
     * \param transfer the transfer to populate
     * \param dev_handle handle of the device that will handle the transfer
     * \param buffer data buffer. If provided, this function will interpret the
     * first 8 bytes as a setup packet and infer the transfer length from that.
     * This pointer must be aligned to at least 2 bytes boundary.
     * \param callback callback function to be invoked on transfer completion
     * \param user_data user data to pass to callback function
     * \param timeout timeout for the transfer in milliseconds
      }
(* error 
static inline void libusb_fill_control_transfer(
(* error 
	struct libusb_transfer *transfer, libusb_device_handle *dev_handle,
(* error 
	unsigned char *buffer, libusb_transfer_cb_fn callback, void *user_data,
(* error 
	unsigned char *buffer, libusb_transfer_cb_fn callback, void *user_data,
(* error 
	unsigned char *buffer, libusb_transfer_cb_fn callback, void *user_data,
(* error 
	unsigned int timeout)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	struct libusb_control_setup *setup = (struct libusb_control_setup * )(void * ) buffer;
 in declarator_list *)
(* error 
	transfer->dev_handle = dev_handle;
(* error 
	transfer->dev_handle = dev_handle;
 in declarator_list *)
(* error 
	transfer->endpoint = 0;
(* error 
	transfer->endpoint = 0;
 in declarator_list *)
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_CONTROL;
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_CONTROL;
 in declarator_list *)
(* error 
	transfer->timeout = timeout;
(* error 
	transfer->timeout = timeout;
 in declarator_list *)
(* error 
	transfer->buffer = buffer;
(* error 
	transfer->buffer = buffer;
 in declarator_list *)
(* error 
		transfer->length = (int) (LIBUSB_CONTROL_SETUP_SIZE
 in declarator_list *)
(* error 
	transfer->user_data = user_data;
(* error 
	transfer->user_data = user_data;
 in declarator_list *)
(* error 
	transfer->callback = callback;
(* error 
	transfer->callback = callback;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Helper function to populate the required \ref libusb_transfer fields
     * for a bulk transfer.
     *
     * \param transfer the transfer to populate
     * \param dev_handle handle of the device that will handle the transfer
     * \param endpoint address of the endpoint where this transfer will be sent
     * \param buffer data buffer
     * \param length length of data buffer
     * \param callback callback function to be invoked on transfer completion
     * \param user_data user data to pass to callback function
     * \param timeout timeout for the transfer in milliseconds
      }
(* error 
static inline void libusb_fill_bulk_transfer(struct libusb_transfer *transfer,
(* error 
	libusb_device_handle *dev_handle, unsigned char endpoint,
(* error 
	libusb_device_handle *dev_handle, unsigned char endpoint,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	void *user_data, unsigned int timeout)
(* error 
	void *user_data, unsigned int timeout)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	transfer->dev_handle = dev_handle;
 in declarator_list *)
(* error 
	transfer->endpoint = endpoint;
(* error 
	transfer->endpoint = endpoint;
 in declarator_list *)
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_BULK;
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_BULK;
 in declarator_list *)
(* error 
	transfer->timeout = timeout;
(* error 
	transfer->timeout = timeout;
 in declarator_list *)
(* error 
	transfer->buffer = buffer;
(* error 
	transfer->buffer = buffer;
 in declarator_list *)
(* error 
	transfer->length = length;
(* error 
	transfer->length = length;
 in declarator_list *)
(* error 
	transfer->user_data = user_data;
(* error 
	transfer->user_data = user_data;
 in declarator_list *)
(* error 
	transfer->callback = callback;
(* error 
	transfer->callback = callback;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Helper function to populate the required \ref libusb_transfer fields
     * for a bulk transfer using bulk streams.
     *
     * Since version 1.0.19, \ref LIBUSB_API_VERSION >= 0x01000103
     *
     * \param transfer the transfer to populate
     * \param dev_handle handle of the device that will handle the transfer
     * \param endpoint address of the endpoint where this transfer will be sent
     * \param stream_id bulk stream id for this transfer
     * \param buffer data buffer
     * \param length length of data buffer
     * \param callback callback function to be invoked on transfer completion
     * \param user_data user data to pass to callback function
     * \param timeout timeout for the transfer in milliseconds
      }
(* error 
static inline void libusb_fill_bulk_stream_transfer(
(* error 
	struct libusb_transfer *transfer, libusb_device_handle *dev_handle,
(* error 
	unsigned char endpoint, uint32_t stream_id,
(* error 
	unsigned char endpoint, uint32_t stream_id,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
(* error 
	void *user_data, unsigned int timeout)
(* error 
	void *user_data, unsigned int timeout)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_BULK_STREAM;
 in declarator_list *)
(* error 
	libusb_transfer_set_stream_id(transfer, stream_id);
(* error 
	libusb_transfer_set_stream_id(transfer, stream_id);
 in declarator_list *)
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Helper function to populate the required \ref libusb_transfer fields
     * for an interrupt transfer.
     *
     * \param transfer the transfer to populate
     * \param dev_handle handle of the device that will handle the transfer
     * \param endpoint address of the endpoint where this transfer will be sent
     * \param buffer data buffer
     * \param length length of data buffer
     * \param callback callback function to be invoked on transfer completion
     * \param user_data user data to pass to callback function
     * \param timeout timeout for the transfer in milliseconds
      }
(* error 
static inline void libusb_fill_interrupt_transfer(
(* error 
	struct libusb_transfer *transfer, libusb_device_handle *dev_handle,
(* error 
	unsigned char endpoint, unsigned char *buffer, int length,
(* error 
	unsigned char endpoint, unsigned char *buffer, int length,
(* error 
	unsigned char endpoint, unsigned char *buffer, int length,
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	transfer->dev_handle = dev_handle;
 in declarator_list *)
(* error 
	transfer->endpoint = endpoint;
(* error 
	transfer->endpoint = endpoint;
 in declarator_list *)
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_INTERRUPT;
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_INTERRUPT;
 in declarator_list *)
(* error 
	transfer->timeout = timeout;
(* error 
	transfer->timeout = timeout;
 in declarator_list *)
(* error 
	transfer->buffer = buffer;
(* error 
	transfer->buffer = buffer;
 in declarator_list *)
(* error 
	transfer->length = length;
(* error 
	transfer->length = length;
 in declarator_list *)
(* error 
	transfer->user_data = user_data;
(* error 
	transfer->user_data = user_data;
 in declarator_list *)
(* error 
	transfer->callback = callback;
(* error 
	transfer->callback = callback;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Helper function to populate the required \ref libusb_transfer fields
     * for an isochronous transfer.
     *
     * \param transfer the transfer to populate
     * \param dev_handle handle of the device that will handle the transfer
     * \param endpoint address of the endpoint where this transfer will be sent
     * \param buffer data buffer
     * \param length length of data buffer
     * \param num_iso_packets the number of isochronous packets
     * \param callback callback function to be invoked on transfer completion
     * \param user_data user data to pass to callback function
     * \param timeout timeout for the transfer in milliseconds
      }
(* error 
static inline void libusb_fill_iso_transfer(struct libusb_transfer *transfer,
(* error 
	libusb_device_handle *dev_handle, unsigned char endpoint,
(* error 
	libusb_device_handle *dev_handle, unsigned char endpoint,
(* error 
	unsigned char *buffer, int length, int num_iso_packets,
(* error 
	unsigned char *buffer, int length, int num_iso_packets,
(* error 
	unsigned char *buffer, int length, int num_iso_packets,
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
(* error 
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	transfer->dev_handle = dev_handle;
 in declarator_list *)
(* error 
	transfer->endpoint = endpoint;
(* error 
	transfer->endpoint = endpoint;
 in declarator_list *)
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_ISOCHRONOUS;
(* error 
	transfer->type = LIBUSB_TRANSFER_TYPE_ISOCHRONOUS;
 in declarator_list *)
(* error 
	transfer->timeout = timeout;
(* error 
	transfer->timeout = timeout;
 in declarator_list *)
(* error 
	transfer->buffer = buffer;
(* error 
	transfer->buffer = buffer;
 in declarator_list *)
(* error 
	transfer->length = length;
(* error 
	transfer->length = length;
 in declarator_list *)
(* error 
	transfer->num_iso_packets = num_iso_packets;
(* error 
	transfer->num_iso_packets = num_iso_packets;
 in declarator_list *)
(* error 
	transfer->user_data = user_data;
(* error 
	transfer->user_data = user_data;
 in declarator_list *)
(* error 
	transfer->callback = callback;
(* error 
	transfer->callback = callback;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Convenience function to set the length of all packets in an isochronous
     * transfer, based on the num_iso_packets field in the transfer structure.
     *
     * \param transfer a transfer
     * \param length the length to set in each isochronous packet descriptor
     * \see libusb_get_max_packet_size()
      }
(* error 
static inline void libusb_set_iso_packet_lengths(
(* error 
	struct libusb_transfer *transfer, unsigned int length)
 in declarator_list *)
 in declarator_list *)
(* error 
	int i;
 in declarator_list *)
(* error 
	for (i = 0; i < transfer->num_iso_packets; i++)
 in declarator_list *)
(* error 
	for (i = 0; i < transfer->num_iso_packets; i++)
in declaration at line 1658 *)
(* error 
	for (i = 0; i < transfer->num_iso_packets; i++)
in declaration at line 1659 *)
    { }
    {* \ingroup libusb_asyncio
     * Convenience function to locate the position of an isochronous packet
     * within the buffer of an isochronous transfer.
     *
     * This is a thorough function which loops through all preceding packets,
     * accumulating their lengths to find the position of the specified packet.
     * Typically you will assign equal lengths to each packet in the transfer,
     * and hence the above method is sub-optimal. You may wish to use
     * libusb_get_iso_packet_buffer_simple() instead.
     *
     * \param transfer a transfer
     * \param packet the packet to return the address of
     * \returns the base address of the packet buffer inside the transfer buffer,
     * or NULL if the packet does not exist.
     * \see libusb_get_iso_packet_buffer_simple()
      }
(* error 
static inline unsigned char *libusb_get_iso_packet_buffer(
(* error 
	struct libusb_transfer *transfer, unsigned int packet)
 in declarator_list *)
 in declarator_list *)
(* error 
	int i;
 in declarator_list *)
(* error 
	size_t offset = 0;
 in declarator_list *)

      var
        _packet : longint;cvar;public;
(* error 
	(* oops..slight bug in the API. packet is an unsigned int, but we use
in declaration at line 1689 *)
(* error 
	_packet = (int) packet;
in declaration at line 1690 *)
(* error 
	if (_packet >= transfer->num_iso_packets)
 in declarator_list *)
(* error 
	for (i = 0; i < _packet; i++)
 in declarator_list *)
(* error 
	for (i = 0; i < _packet; i++)
in declaration at line 1695 *)
(* error 
	for (i = 0; i < _packet; i++)
in declaration at line 1696 *)
(* error 
	return transfer->buffer + offset;
 in declarator_list *)
    { }
    {* \ingroup libusb_asyncio
     * Convenience function to locate the position of an isochronous packet
     * within the buffer of an isochronous transfer, for transfers where each
     * packet is of identical size.
     *
     * This function relies on the assumption that every packet within the transfer
     * is of identical size to the first packet. Calculating the location of
     * the packet buffer is then just a simple calculation:
     * <tt>buffer + (packet_size * packet)</tt>
     *
     * Do not use this function on transfers other than those that have identical
     * packet lengths for each packet.
     *
     * \param transfer a transfer
     * \param packet the packet to return the address of
     * \returns the base address of the packet buffer inside the transfer buffer,
     * or NULL if the packet does not exist.
     * \see libusb_get_iso_packet_buffer()
      }
(* error 
static inline unsigned char *libusb_get_iso_packet_buffer_simple(
(* error 
	struct libusb_transfer *transfer, unsigned int packet)
 in declarator_list *)
 in declarator_list *)
(* error 
	int _packet;
 in declarator_list *)
(* error 
	(* oops..slight bug in the API. packet is an unsigned int, but we use
in declaration at line 1729 *)
(* error 
	_packet = (int) packet;
in declaration at line 1730 *)
(* error 
	if (_packet >= transfer->num_iso_packets)
 in declarator_list *)
(* error 
	return transfer->buffer + ((int) transfer->iso_packet_desc[0].length * _packet);
 in declarator_list *)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)*)
    { }
    { sync I/O  }

    function libusb_control_transfer(var dev_handle:libusb_device_handle; request_type:uint8_t; bRequest:uint8_t; wValue:uint16_t; wIndex:uint16_t; 
               var data:byte; wLength:uint16_t; timeout:dword):longint;cdecl;external  name 'libusb_control_transfer';

    function libusb_bulk_transfer(var dev_handle:libusb_device_handle; endpoint:byte; var data:byte; length:longint; var actual_length:longint; 
               timeout:dword):longint;cdecl;external  name 'libusb_bulk_transfer';

    function libusb_interrupt_transfer(var dev_handle:libusb_device_handle; endpoint:byte; var data:byte; length:longint; var actual_length:longint; 
               timeout:dword):longint;cdecl;external  name 'libusb_interrupt_transfer';

    {* \ingroup libusb_desc
     * Retrieve a descriptor from the default control pipe.
     * This is a convenience function which formulates the appropriate control
     * message to retrieve the descriptor.
     *
     * \param dev_handle a device handle
     * \param desc_type the descriptor type, see \ref libusb_descriptor_type
     * \param desc_index the index of the descriptor to retrieve
     * \param data output buffer for descriptor
     * \param length size of data buffer
     * \returns number of bytes returned in data, or LIBUSB_ERROR code on failure
      }
(* error 
static inline int libusb_get_descriptor(libusb_device_handle *dev_handle,
(* error 
	uint8_t desc_type, uint8_t desc_index, unsigned char *data, int length)
(* error 
	uint8_t desc_type, uint8_t desc_index, unsigned char *data, int length)
(* error 
	uint8_t desc_type, uint8_t desc_index, unsigned char *data, int length)
(* error 
	uint8_t desc_type, uint8_t desc_index, unsigned char *data, int length)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	return libusb_control_transfer(dev_handle, LIBUSB_ENDPOINT_IN,
 in declarator_list *)
(* error 
		LIBUSB_REQUEST_GET_DESCRIPTOR, (uint16_t) ((desc_type << 8) | desc_index),
(* error 
		0, data, (uint16_t) length, 1000);
 in declarator_list *)
 in declarator_list *)
(* error 
		0, data, (uint16_t) length, 1000);
(* error 
		0, data, (uint16_t) length, 1000);
 in declarator_list *)
 in declarator_list *)
    { }
    {* \ingroup libusb_desc
     * Retrieve a descriptor from a device.
     * This is a convenience function which formulates the appropriate control
     * message to retrieve the descriptor. The string returned is Unicode, as
     * detailed in the USB specifications.
     *
     * \param dev_handle a device handle
     * \param desc_index the index of the descriptor to retrieve
     * \param langid the language ID for the string descriptor
     * \param data output buffer for descriptor
     * \param length size of data buffer
     * \returns number of bytes returned in data, or LIBUSB_ERROR code on failure
     * \see libusb_get_string_descriptor_ascii()
      }
(* error 
static inline int libusb_get_string_descriptor(libusb_device_handle *dev_handle,
(* error 
	uint8_t desc_index, uint16_t langid, unsigned char *data, int length)
(* error 
	uint8_t desc_index, uint16_t langid, unsigned char *data, int length)
(* error 
	uint8_t desc_index, uint16_t langid, unsigned char *data, int length)
(* error 
	uint8_t desc_index, uint16_t langid, unsigned char *data, int length)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
	return libusb_control_transfer(dev_handle, LIBUSB_ENDPOINT_IN,
 in declarator_list *)
(* error 
		LIBUSB_REQUEST_GET_DESCRIPTOR, (uint16_t)((LIBUSB_DT_STRING << 8) | desc_index),
 in declarator_list *)
(* error 
		langid, data, (uint16_t) length, 1000);
(* error 
		langid, data, (uint16_t) length, 1000);
 in declarator_list *)
 in declarator_list *)
    { }
    function libusb_get_string_descriptor_ascii( dev_handle:Plibusb_device_handle; desc_index:uint8_t; data: PChar; length:longint):longint;cdecl;external  name 'libusb_get_string_descriptor_ascii';

    { polling and timeouts  }
    function libusb_try_lock_events(var ctx:libusb_context):longint;cdecl;external  name 'libusb_try_lock_events';

    procedure libusb_lock_events(var ctx:libusb_context);cdecl;external  name 'libusb_lock_events';

    procedure libusb_unlock_events(var ctx:libusb_context);cdecl;external  name 'libusb_unlock_events';

    function libusb_event_handling_ok(var ctx:libusb_context):longint;cdecl;external  name 'libusb_event_handling_ok';

    function libusb_event_handler_active(var ctx:libusb_context):longint;cdecl;external  name 'libusb_event_handler_active';

    procedure libusb_interrupt_event_handler(var ctx:libusb_context);cdecl;external  name 'libusb_interrupt_event_handler';

    procedure libusb_lock_event_waiters(var ctx:libusb_context);cdecl;external  name 'libusb_lock_event_waiters';

    procedure libusb_unlock_event_waiters(var ctx:libusb_context);cdecl;external  name 'libusb_unlock_event_waiters';
type
    timeval
    =
     record
       tv_sec : longint;//time_t;
       tv_usec: longint;//clong;
     end;

    function libusb_wait_for_event(var ctx:libusb_context; var tv:timeval):longint;cdecl;external  name 'libusb_wait_for_event';

    function libusb_handle_events_timeout(var ctx:libusb_context; var tv:timeval):longint;cdecl;external  name 'libusb_handle_events_timeout';

    function libusb_handle_events_timeout_completed(var ctx:libusb_context; var tv:timeval; var completed:longint):longint;cdecl;external  name 'libusb_handle_events_timeout_completed';

    function libusb_handle_events(var ctx:libusb_context):longint;cdecl;external  name 'libusb_handle_events';

    function libusb_handle_events_completed(var ctx:libusb_context; var completed:longint):longint;cdecl;external  name 'libusb_handle_events_completed';

    function libusb_handle_events_locked(var ctx:libusb_context; var tv:timeval):longint;cdecl;external  name 'libusb_handle_events_locked';

    function libusb_pollfds_handle_timeouts(var ctx:libusb_context):longint;cdecl;external  name 'libusb_pollfds_handle_timeouts';

    function libusb_get_next_timeout(var ctx:libusb_context; var tv:timeval):longint;cdecl;external  name 'libusb_get_next_timeout';

    {* \ingroup libusb_poll
     * File descriptor for polling
      }
    {* Numeric file descriptor  }
    {* Event flags to poll for from <poll.h>. POLLIN indicates that you
    	 * should monitor this file descriptor for becoming ready to read from,
    	 * and POLLOUT indicates that you should monitor this file descriptor for
    	 * nonblocking write readiness.  }

    type
      Plibusb_pollfd = ^libusb_pollfd;
      PPlibusb_pollfd = Plibusb_pollfd;
      libusb_pollfd = record
          fd : longint;
          events : smallint;
        end;

    {* \ingroup libusb_poll
     * Callback function, invoked when a new file descriptor should be added
     * to the set of file descriptors monitored for events.
     * \param fd the new file descriptor
     * \param events events to monitor for, see \ref libusb_pollfd for a
     * description
     * \param user_data User data pointer specified in
     * libusb_set_pollfd_notifiers() call
     * \see libusb_set_pollfd_notifiers()
      }

      libusb_pollfd_added_cb = procedure (fd:longint; events:smallint; user_data:pointer);cdecl;
    {* \ingroup libusb_poll
     * Callback function, invoked when a file descriptor should be removed from
     * the set of file descriptors being monitored for events. After returning
     * from this callback, do not use that file descriptor again.
     * \param fd the file descriptor to stop monitoring
     * \param user_data User data pointer specified in
     * libusb_set_pollfd_notifiers() call
     * \see libusb_set_pollfd_notifiers()
      }

      libusb_pollfd_removed_cb = procedure (fd:longint; user_data:pointer);cdecl;
(* Const before type ignored *)

    function libusb_get_pollfds(var ctx:libusb_context):PPlibusb_pollfd;cdecl;external  name 'libusb_get_pollfds';

(* Const before type ignored *)
    procedure libusb_free_pollfds(var pollfds:Plibusb_pollfd);cdecl;external  name 'libusb_free_pollfds';

    procedure libusb_set_pollfd_notifiers(var ctx:libusb_context; added_cb:libusb_pollfd_added_cb; removed_cb:libusb_pollfd_removed_cb; user_data:pointer);cdecl;external  name 'libusb_set_pollfd_notifiers';

    {* \ingroup libusb_hotplug
     * Callback handle.
     *
     * Callbacks handles are generated by libusb_hotplug_register_callback()
     * and can be used to deregister callbacks. Callback handles are unique
     * per libusb_context and it is safe to call libusb_hotplug_deregister_callback()
     * on an already deregisted callback.
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * For more information, see \ref libusb_hotplug.
      }

    type
      Plibusb_hotplug_callback_handle = ^libusb_hotplug_callback_handle;
      libusb_hotplug_callback_handle = longint;
    {* \ingroup libusb_hotplug
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * Flags for hotplug events  }
    {* Default value when not using any flags.  }
    {* Arm the callback and fire it for all matching currently attached devices.  }

      Plibusb_hotplug_flag = ^libusb_hotplug_flag;
      libusb_hotplug_flag =  Longint;
      Const
        LIBUSB_HOTPLUG_NO_FLAGS = 0;
        LIBUSB_HOTPLUG_ENUMERATE = 1 shl 0;

    {* \ingroup libusb_hotplug
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * Hotplug events  }
    {* A device has been plugged in and is ready to use  }
    {* A device has left and is no longer available.
    	 * It is the user's responsibility to call libusb_close on any handle associated with a disconnected device.
    	 * It is safe to call libusb_get_device_descriptor on a device that has left  }

    type
      Plibusb_hotplug_event = ^libusb_hotplug_event;
      libusb_hotplug_event =  Longint;
      Const
        LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED = $01;
        LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT = $02;

    {* \ingroup libusb_hotplug
     * Wildcard matching for hotplug events  }
      LIBUSB_HOTPLUG_MATCH_ANY = -(1);      
    {* \ingroup libusb_hotplug
     * Hotplug callback function type. When requesting hotplug event notifications,
     * you pass a pointer to a callback function of this type.
     *
     * This callback may be called by an internal event thread and as such it is
     * recommended the callback do minimal processing before returning.
     *
     * libusb will call this function later, when a matching event had happened on
     * a matching device. See \ref libusb_hotplug for more information.
     *
     * It is safe to call either libusb_hotplug_register_callback() or
     * libusb_hotplug_deregister_callback() from within a callback function.
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * \param ctx            context of this notification
     * \param device         libusb_device this event occurred on
     * \param event          event that occurred
     * \param user_data      user data provided when this callback was registered
     * \returns bool whether this callback is finished processing events.
     *                       returning 1 will cause this callback to be deregistered
      }

    type

      libusb_hotplug_callback_fn = function (var ctx:libusb_context; var device:libusb_device; event:libusb_hotplug_event; user_data:pointer):longint;cdecl;
    {* \ingroup libusb_hotplug
     * Register a hotplug callback function
     *
     * Register a callback with the libusb_context. The callback will fire
     * when a matching event occurs on a matching device. The callback is
     * armed until either it is deregistered with libusb_hotplug_deregister_callback()
     * or the supplied callback returns 1 to indicate it is finished processing events.
     *
     * If the \ref LIBUSB_HOTPLUG_ENUMERATE is passed the callback will be
     * called with a \ref LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED for all devices
     * already plugged into the machine. Note that libusb modifies its internal
     * device list from a separate thread, while calling hotplug callbacks from
     * libusb_handle_events(), so it is possible for a device to already be present
     * on, or removed from, its internal device list, while the hotplug callbacks
     * still need to be dispatched. This means that when using \ref
     * LIBUSB_HOTPLUG_ENUMERATE, your callback may be called twice for the arrival
     * of the same device, once from libusb_hotplug_register_callback() and once
     * from libusb_handle_events(); and/or your callback may be called for the
     * removal of a device for which an arrived call was never made.
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * \param[in] ctx context to register this callback with
     * \param[in] events bitwise or of events that will trigger this callback. See \ref
     *            libusb_hotplug_event
     * \param[in] flags hotplug callback flags. See \ref libusb_hotplug_flag
     * \param[in] vendor_id the vendor id to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
     * \param[in] product_id the product id to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
     * \param[in] dev_class the device class to match or \ref LIBUSB_HOTPLUG_MATCH_ANY
     * \param[in] cb_fn the function to be invoked on a matching event/device
     * \param[in] user_data user data to pass to the callback function
     * \param[out] callback_handle pointer to store the handle of the allocated callback (can be NULL)
     * \returns LIBUSB_SUCCESS on success LIBUSB_ERROR code on failure
      }

    function libusb_hotplug_register_callback(var ctx:libusb_context; events:libusb_hotplug_event; flags:libusb_hotplug_flag; vendor_id:longint; product_id:longint; 
               dev_class:longint; cb_fn:libusb_hotplug_callback_fn; user_data:pointer; var callback_handle:libusb_hotplug_callback_handle):longint;cdecl;external  name 'libusb_hotplug_register_callback';

    {* \ingroup libusb_hotplug
     * Deregisters a hotplug callback.
     *
     * Deregister a callback from a libusb_context. This function is safe to call from within
     * a hotplug callback.
     *
     * Since version 1.0.16, \ref LIBUSB_API_VERSION >= 0x01000102
     *
     * \param[in] ctx context this callback is registered with
     * \param[in] callback_handle the handle of the callback to deregister
      }
    procedure libusb_hotplug_deregister_callback(var ctx:libusb_context; callback_handle:libusb_hotplug_callback_handle);cdecl;external  name 'libusb_hotplug_deregister_callback';

    {* \ingroup libusb_lib
     * Available option values for libusb_set_option().
      }
    {* Set the log message verbosity.
    	 *
    	 * The default level is LIBUSB_LOG_LEVEL_NONE, which means no messages are ever
    	 * printed. If you choose to increase the message verbosity level, ensure
    	 * that your application does not close the stderr file descriptor.
    	 *
    	 * You are advised to use level LIBUSB_LOG_LEVEL_WARNING. libusb is conservative
    	 * with its message logging and most of the time, will only log messages that
    	 * explain error conditions and other oddities. This will help you debug
    	 * your software.
    	 *
    	 * If the LIBUSB_DEBUG environment variable was set when libusb was
    	 * initialized, this function does nothing: the message verbosity is fixed
    	 * to the value in the environment variable.
    	 *
    	 * If libusb was compiled without any message logging, this function does
    	 * nothing: you'll never get any messages.
    	 *
    	 * If libusb was compiled with verbose debug message logging, this function
    	 * does nothing: you'll always get messages from all levels.
    	  }
    {* Use the UsbDk backend for a specific context, if available.
    	 *
    	 * This option should be set immediately after calling libusb_init(), otherwise
    	 * unspecified behavior may occur.
    	 *
    	 * Only valid on Windows.
    	  }

    type
      libusb_option =  Longint;
      Const
        LIBUSB_OPTION_LOG_LEVEL = 0;
        LIBUSB_OPTION_USE_USBDK = 1;


    function libusb_set_option(var ctx:libusb_context; option:libusb_option; args:array of const):longint;cdecl;external  name 'libusb_set_option';

    function libusb_set_option(var ctx:libusb_context; option:libusb_option):longint;cdecl;external  name 'libusb_set_option';

implementation

    { was #define dname(params) para_def_expr }
    { argument types are unknown }
    { return type might be wrong }   
    function LIBUSB_DEPRECATED_FOR(f : longint) : longint;
    begin
   //   LIBUSB_DEPRECATED_FOR:=__attribute__(deprecated);
    end;

    { was #define dname def_expr }
    {
    function LIBUSB_DT_BOS_MAX_SIZE : Integer;
    begin
        Result:=LIBUSB_DT_BOS_SIZE+LIBUSB_BT_USB_2_0_EXTENSION_SIZE+LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE+LIBUSB_BT_CONTAINER_ID_SIZE;
    end;
    }

end.
