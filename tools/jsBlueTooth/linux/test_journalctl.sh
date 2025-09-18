#!/bin/bash -vx
sudo journalctl --since "10min ago" -u bluetooth
#sudo journalctl --since "1hour ago" -u bluetooth
#sudo journalctl --since "today" -u bluetooth