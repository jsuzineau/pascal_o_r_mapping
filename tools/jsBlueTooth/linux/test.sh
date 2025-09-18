#!/bin/bash -vx
./test_btmon.sh
./test_journalctl.sh
./test_busctl.sh
./test_gdbus.sh
./test_bluetoothctl.sh