#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: ./compilar.sh <name>"
    exit 1
fi

FILE_NAME="$1"

ghdl -a "${FILE_NAME}.vhd"
ghdl -e "${FILE_NAME}"

ghdl -a "${FILE_NAME}_tb.vhd"
ghdl -e "${FILE_NAME}_tb"

ghdl -r "${FILE_NAME}_tb" --wave="${FILE_NAME}_tb.ghw"

gtkwave "${FILE_NAME}_tb.ghw"