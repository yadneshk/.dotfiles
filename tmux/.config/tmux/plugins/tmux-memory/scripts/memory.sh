#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

# CREDIT: http://arstechnica.com/civis/viewtopic.php?f=19&t=35031
print_memory() {
  free -h | awk '/Mem:/ { print $3 "/" $2 }'
}

main() {
  print_memory
}

main
