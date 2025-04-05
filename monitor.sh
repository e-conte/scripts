#!/bin/sh
xrandr --newmode "2560x1080_68.00"  264.25  2560 2736 3008 3456  1080 1083 1093 1126 -hsync +vsync
xrandr --addmode DisplayPort-0 2560x1080_68.00
xrandr --output HDMI-A-0 --mode 1920x1080 --pos 292x0 --rotate normal --output DisplayPort-0 --primary --mode 2560x1080_68.00 --pos 0x1080 --rotate normal
