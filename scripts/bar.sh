#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/onedark



cpu() {
  # show CPU temperature from a thermal zone
  thermal_zone=2
  tz="/sys/class/thermal/thermal_zone${thermal_zone}/temp"
  warn=60
  if [ -r "$tz" ]; then
    raw=$(tr -d ' \n' <"$tz" 2>/dev/null)
    if [ -n "$raw" ] && echo "$raw" | grep -qE '^[0-9]+$'; then
      # handle millidegree (e.g. 42000) or degree (e.g. 42)
      if [ ${#raw} -ge 4 ]; then
        temp=$(awk "BEGIN{printf \"%.0f\", $raw/1000}") # integer Celsius
      else
        temp=$raw
      fi
      temp_label="${temp}°C"
    else
      temp_label="N/A"
    fi
  else
    temp_label="N/A"
  fi

  # icon / left block (keep style consistent with existing script)
  printf "^c$black^ ^b$green^  "

  if [ "$temp_label" = "N/A" ]; then
    printf "^c$white^ ^b$grey^ %s ^b$black^" "$temp_label"
  else
    # choose color if above warn threshold
    if awk "BEGIN{exit !($temp >= $warn)}"; then
      valcol=$red
    else
      valcol=$white
    fi
    printf "^c$valcol^ %s ^b$black^" "$temp_label"
  fi
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
