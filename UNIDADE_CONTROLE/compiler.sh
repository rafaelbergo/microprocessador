#!/bin/bash

TESTBENCH="$1"

ghdl -a *.vhd

ghdl -a "${TESTBENCH}.vhd"
ghdl -e "${TESTBENCH}"

ghdl -r "${TESTBENCH}" --wave="${TESTBENCH}.ghw"

gtkwave "${TESTBENCH}.ghw"

rm -rf work-obj93.cf
rm -rf "${TESTBENCH}.ghw"