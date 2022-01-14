#!/usr/bin/env bash

# Terminate already running bar instances
# killall -q polybar
# If all your bars have ipc enabled, you can also use
polybar-msg cmd quit

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | grep " primary" | cut -d" " -f1); do
    echo "---" | tee -a /tmp/polybar_$m.log
    MONITOR=$m polybar --reload default 2>&1 | tee -a /tmp/polybar_$m.log & disown
  done
  # Delay to launch the tray in the primary monitor bar
  sleep 0.5
  for m in $(xrandr --query | grep " connected" | grep -v " primary" |  cut -d" " -f1); do
    echo "---" | tee -a /tmp/polybar_$m.log
    MONITOR=$m polybar --reload default 2>&1 | tee -a /tmp/polybar_$m.log & disown
  done
else
  echo "---" | tee -a /tmp/polybar.log
  $polybar --reload default 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Bars launched..."
