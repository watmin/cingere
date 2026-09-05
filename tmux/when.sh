#!/bin/sh
# Pacific wall clock for the tmux status line.
#   when.sh        -> 2026-08-31 09:47 PM PDT
#   when.sh date   -> 2026-08-31
#   when.sh time   -> 09:47 PM PDT
TZ=America/Los_Angeles
export TZ
case ${1:-both} in
  date) exec date '+%Y-%m-%d' ;;
  time) exec date '+%I:%M %p %Z' ;;
  *)    exec date '+%Y-%m-%d %I:%M %p %Z' ;;
esac
