libusb-1.0.dll copied from libusb-1.0.22\MS64\dll
include subdirectory copied from libusb-1.0.22\include

Compile from command line:
C:\lazarus\fpc\3.0.4\bin\x86_64-win64\fpc.exe -MObjFPC -Scghi -O1 -g -gl -l -vewnhibq -Filib\x86_64-win64 -Fuinclude\libusb-1.0 -Fu. -FUlib\x86_64-win64 -FE. -olsusb.exe lsusb.lpr

Result
E:\01_Projets\01_pascal_o_r_mapping\tools\lsusb>C:\lazarus\fpc\3.0.4\bin\x86_64-win64\fpc.exe -MObjFPC -Scghi -O1 -g -gl -l -vewnhibq -Filib\x86_64-win64 -Fuinclude\libusb-1.0 -Fu. -FUlib\x86_64-win64 -FE. -olsusb.exe lsusb.lpr
Hint: (11030) Start of reading config file C:\lazarus\fpc\3.0.4\bin\x86_64-win64\fpc.cfg
Hint: (11031) End of reading config file C:\lazarus\fpc\3.0.4\bin\x86_64-win64\fpc.cfg
Free Pascal Compiler version 3.0.4 [2019/02/03] for x86_64
Copyright (c) 1993-2017 by Florian Klaempfl and others
(1002) Target OS: Win64 for x64
(3104) Compiling lsusb.lpr
E:\01_Projets\01_pascal_o_r_mapping\tools\lsusb\lsusb.lpr(86,65) Hint: (5057) Local variable "descriptor" does not seem to be initialized
(9015) Linking .\lsusb.exe
(1008) 188 lines compiled, 0.2 sec, 170016 bytes code, 6692 bytes data
(1022) 3 hint(s) issued

E:\01_Projets\01_pascal_o_r_mapping\tools\lsusb>lsusb
Dev (bus 1, device 3): 10C4:EA60
Dev (bus 1, device 0): 8086:A2AF
Dev (bus 1, device 2): 1C4F:   2(SIGMACHIP) USB Keyboard []
Dev (bus 1, device 3):  46D:C077(Logitech) USB Optical Mouse []
Dev (bus 1, device 1):  7CA:A110

E:\01_Projets\01_pascal_o_r_mapping\tools\lsusb>