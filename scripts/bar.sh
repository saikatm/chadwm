#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/onedark

cpu() {
  tz="/sys/class/thermal/thermal_zone2/temp"
  if [ -r "$tz" ]; then
    raw=$(tr -d ' \n' <"$tz")
    if [ -n "$raw" ] && [ "$raw" -eq "$raw" ] 2>/dev/null; then
      temp=$(( ${#raw} -ge 4 ? raw/1000 : raw ))
      temp_label="Temp ${temp}°"
    else
      temp_label="Temp N/A"
    fi
  else
    temp_label="Temp N/A"
  fi

  printf "^c$grey^ %s" "$temp_label"
}

mem() {
  # compute memory usage percentage using /proc/meminfo (falls back to free if needed)
  if [ -r /proc/meminfo ]; then
    pct=$(awk '
      /^MemTotal:/   {total=$2}
      /^MemAvailable:/{avail=$2}
      /^MemFree:/    {free=$2}
      /^Buffers:/    {buffers=$2}
      /^Cached:/     {cached=$2}
      END {
        if (total==0) {print "N/A"; exit}
        if (avail>0) {printf "%.0f%%", (total-avail)/total*100; exit}
        used = total - (free+buffers+cached)
        printf "%.0f%%", used/total*100
      }' /proc/meminfo)
  else
    pct=$(free | awk '/^Mem:/ {printf "%.0f%%", $3/$2*100}')
  fi

  printf "^c$red^^b$black^  "
  printf "^c$red^ %s" "$pct"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
  printf "^c$black^ ^b$darkblue^ 󱑆 "
  printf "^c$black^^b$blue^ $(date '+%a, %b %d, %-I:%M %p')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(cpu) $(mem) $(wlan) $(clock)"
done
