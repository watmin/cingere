#!/bin/sh
#   procs.sh p  -> process count
#   procs.sh t  -> thread count (loadavg scheduling entities)
case ${1:-t} in
  p) ls -d /proc/[0-9]* 2>/dev/null | wc -l ;;
  t) awk '{ split($4, a, "/"); printf "%s", a[2] }' /proc/loadavg ;;
  *) awk '{ split($4, a, "/"); printf "%s/%s", a[1], a[2] }' /proc/loadavg ;;
esac
