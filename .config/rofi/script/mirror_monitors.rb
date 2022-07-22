#!/usr/bin/env ruby

monitors = `xrandr --query | grep " connected" | cut -d' ' -f1 | rofi -dmenu -multi-select -p "Select the monitors to mirror"`.split("\n")

if monitors.count >= 2
  first_monitor = monitors.shift
  cmd = "xrandr"
  while monitors.any?
    cmd << " --output #{monitors.shift} --same-as #{first_monitor}"
  end
  `#{cmd}`
end
