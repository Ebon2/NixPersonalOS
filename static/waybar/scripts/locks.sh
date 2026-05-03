#!/usr/bin/env bash

caps=$(hyprctl devices -j | jq '.keyboards[] | select(.main == true) | .capsLock')
num=$(hyprctl devices -j | jq '.keyboards[] | select(.main == true) | .numLock')

output=""

if [ "$caps" == "true" ]; then
  output+="MAYUS "
else
  output+=" "
fi


if [ "$num" == "true" ]; then
  output+="NUM "
else
  output+=" "
fi

echo "$output"
