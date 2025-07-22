#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

memory_output="#($CURRENT_DIR/scripts/memory.sh)"
memory_interpolation="\#{memory}"

do_interpolation() {
  local output="$1"
  local output="${output/$memory_interpolation/$memory_output}"
  echo "$output"
}

update_tmux_memory() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_memory "status-right"
  update_tmux_memory "status-left"
}
main

