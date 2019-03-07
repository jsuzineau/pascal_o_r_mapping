copy %cd%\test_remote_debug.exe %cd%\exe_for_gdbserver\test_remote_debug.exe
copy %cd%\test_remote_debug.dbg %cd%\exe_for_gdbserver\test_remote_debug.dbg
E:\msys64\mingw64\bin\gdbserver.exe host:2345 %cd%\exe_for_gdbserver\test_remote_debug.exe
cmd