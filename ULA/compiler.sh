#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: ./compiler.sh <name>"
    exit 1
fi

FILE_NAME="$1"

ghdl -a "${FILE_NAME}.vhd"
ghdl -e "${FILE_NAME}"

ghdl -a "${FILE_NAME}_tb.vhd"
ghdl -e "${FILE_NAME}_tb"

ghdl -r "${FILE_NAME}_tb" --wave="${FILE_NAME}_tb.ghw"

gtkwave "${FILE_NAME}_tb.ghw"

rm -rf work-obj93.cf
rm -rf "${FILE_NAME}_tb.ghw"