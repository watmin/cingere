#!/bin/sh
# Powerline-style uptime: 203d 22h 38m / 0h 09m
awk '{
  s = int($1)
  d = int(s / 86400); s %= 86400
  h = int(s / 3600);  s %= 3600
  m = int(s / 60)
  if (d > 0) printf "%dd %dh %02dm", d, h, m
  else if (h > 0) printf "%dh %02dm", h, m
  else printf "%dm", m
}' /proc/uptime
