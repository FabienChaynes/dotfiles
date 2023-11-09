#!/usr/bin/env bash

# Terminate already running bar instances
# killall -q polybar
# If all your bars have ipc enabled, you can also use
polybar-msg cmd quit

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | grep " primary" | cut -d" " -f1); do
    echo "---" | tee -a /tmp/polybar_$m.log
    MONITOR=$m TRAY_POSITION=right polybar --reload default 2>&1 | tee -a /tmp/polybar_$m.log & disown
  done
  for m in $(xrandr --query | grep " connected" | grep -v " primary" |  cut -d" " -f1); do
    monitor_pos=`xrandr | grep " connected" | sed 's/primary //g' | cut -d' ' -f1,3 | grep "^$m " | cut -d' ' -f2`
    first_monitor=`xrandr | grep " connected" | sed 's/primary //g' | cut -d' ' -f1,3 | grep $monitor_pos | head -1 | cut -d' ' -f1`
    # If monitors are mirrored, only launch the bar for the first monitor
    if [ $m = $first_monitor ]
    then
      echo "---" | tee -a /tmp/polybar_$m.log
      MONITOR=$m TRAY_POSITION=none polybar --reload default 2>&1 | tee -a /tmp/polybar_$m.log & disown
    fi
  done
else
  echo "---" | tee -a /tmp/polybar.log
  polybar --reload default 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Bars launched..."
