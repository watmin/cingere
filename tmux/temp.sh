#!/bin/sh
# Package/CPU temp if the kernel exports it; silent otherwise.
for z in /sys/class/thermal/thermal_zone*; do
  [ -r "$z/temp" ] || continue
  t=$(cat "$z/type" 2>/dev/null) || continue
  case $t in
    x86_pkg_temp|k10temp|cpu*|CPU*|pkg*)
      awk '{ printf "%d°C", $1 / 1000 }' "$z/temp"
      exit 0
      ;;
  esac
done
if [ -r /sys/class/thermal/thermal_zone0/temp ]; then
  awk '{ printf "%d°C", $1 / 1000 }' /sys/class/thermal/thermal_zone0/temp
fi
